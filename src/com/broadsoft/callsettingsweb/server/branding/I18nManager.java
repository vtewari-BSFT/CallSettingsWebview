/* Copyright © 2017 BroadSoft Inc. */
package com.broadsoft.callsettingsweb.server.branding;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.Map;

import com.broadsoft.callsettingsweb.server.AppConstants;
import com.broadsoft.callsettingsweb.server.loggers.ChannelLoggerUtil;
import com.broadsoft.callsettingsweb.server.util.ApplicationUtil;
import com.broadsoft.xsp.app.base.ChannelSeverity;
import com.broadsoft.xsp.app.base.IXSPAppContext;

import net.sf.json.JSONObject;

public class I18nManager {

private static I18nManager i18nManager;

private static Map<String, JSONObject> DEFAULT_TEXTS = new LinkedHashMap<String, JSONObject>();
private static Map<String, JSONObject> DOMAIN_LOCALE_TEXTS = new LinkedHashMap<String, JSONObject>();
private static String LOCALIZATION_RESOURCE_PATH;

public static I18nManager getInstance() {

if (i18nManager == null) {
i18nManager = new I18nManager();
}

return i18nManager;
}

public void init(IXSPAppContext appContext) {

LOCALIZATION_RESOURCE_PATH = appContext.getResourceConfiguration()
.getConfiguration(AppConstants.SYSTEM_BRANDING_CUSTOM_PATH);
loadDefaultTexts();

ChannelLoggerUtil.getLogger().log(ChannelSeverity.INFO, I18nManager.class.getName(),
"Localization resource path is configured as " + LOCALIZATION_RESOURCE_PATH
+ "\n ...Initializing the default localization");
}

public String getDefaultTexts() {

return DEFAULT_TEXTS.get(AppConstants.LOCALE_US_ENGLISH).toString();
}

public String getCustomizedLocaleTexts(String domainName, String locale) {

String userLocaleTexts = "";

JSONObject domainLocalizedText = DOMAIN_LOCALE_TEXTS.get(domainName);

locale = (locale != null) ? locale.replace("-", "_") : AppConstants.LOCALE_US_ENGLISH;
if (ChannelLoggerUtil.isLogLevelActive(AppConstants.CALL_SETTINGS_WEB_CHANNEL, ChannelSeverity.FIELD_DEBUG)) {
ChannelLoggerUtil.getLogger().log(ChannelSeverity.FIELD_DEBUG, I18nManager.class.getName(),
"locale value read : " + locale);
}

locale = getInstance().detectLocale(locale);

if (domainLocalizedText == null) {

String readDomainLocalizedText = readLocaleTextForDomain(domainName);

if (!AppConstants.EMPTY_STRING.equals(readDomainLocalizedText)) {
domainLocalizedText = JSONObject.fromObject(readDomainLocalizedText);
DOMAIN_LOCALE_TEXTS.put(domainName, domainLocalizedText);

}
}

if (domainLocalizedText != null
&& ((JSONObject) ((JSONObject) domainLocalizedText.get("services")).get(locale)) != null) {

if (ChannelLoggerUtil.isLogLevelActive(AppConstants.CALL_SETTINGS_WEB_CHANNEL, ChannelSeverity.DEV_DEBUG)) {
ChannelLoggerUtil.getLogger().log(ChannelSeverity.DEV_DEBUG, I18nManager.class.getName(),
"Localization text for the domain : " + domainLocalizedText.get("services"));
}
userLocaleTexts = ((JSONObject) ((JSONObject) domainLocalizedText.get("services")).get(locale)).toString();
ChannelLoggerUtil.getLogger().log(ChannelSeverity.FIELD_DEBUG, I18nManager.class.getName(),
"USING DOMAINLOCALIZEDTEXT FOR LOCALE (locale) " + locale);
} else if (DEFAULT_TEXTS.get(locale) != null) {
userLocaleTexts = DEFAULT_TEXTS.get(locale).toString();
ChannelLoggerUtil.getLogger().log(ChannelSeverity.FIELD_DEBUG, I18nManager.class.getName(),
                    "USING DOMAINLOCALIZEDTEXT FOR LOCALE (locale) " + locale);
} else {
userLocaleTexts = DEFAULT_TEXTS.get(AppConstants.LOCALE_US_ENGLISH).toString();
ChannelLoggerUtil.getLogger().log(ChannelSeverity.FIELD_DEBUG, I18nManager.class.getName(),
"USING DEFAULT TEXT FOR LOCALE (locale) " + locale);
}

return userLocaleTexts;
}

private String detectLocale(String locale) {

switch (locale) {
case "ja_JP":
case "ja": {
locale = AppConstants.LOCALE_JA_JAPANESE;
break;
}

case "ko":
case "ko_KP":
case "ko_KR": {
locale = AppConstants.LOCALE_KO_KOREAN;
break;
}

case "it":
case "it_CH": {
locale = AppConstants.LOCALE_IT_ITALIAN;
break;
}

case "en":
case "en_AU":
case "en_BZ":
case "en_CA":
case "en_IE":
case "en_JM":
case "en_NZ":
case "en_ZA":
case "en_TT":
case "en_GB": {
locale = AppConstants.LOCALE_US_ENGLISH;
break;
}

case "es":
case "es_AR":
case "es_BO":
case "es_CL":
case "es_CO":
case "es_CR":
case "es_DO":
case "es_EC":
case "es_SV":
case "es_GT":
case "es_HN":
case "es_MX":
case "es_NI":
case "es_PA":
case "es_PY":
case "es_PR":
case "es_UY":
case "es_VE":
case "es_PE": {
locale = AppConstants.LOCALE_ES_SPANISH;
break;
}

case "fr":
case "fr_BE":
case "fr_LU":
case "fr_BG":
case "fr_MC":
case "fr_CH": {
locale = AppConstants.LOCALE_FR_FRENCH;
break;
}

case "de":
case "de_AT":
case "de_LI":
case "de_LU":
case "de_CH": {
locale = AppConstants.LOCALE_DE_GERMAN;
break;
}

case "zh":
case "zh_HK":
case "zh_CN":
case "zh_SG":
case "zh_TW": {
locale = AppConstants.LOCALE_ZH_CHINESE;
break;
}

case "nl":
case "nl_BE": {
locale = AppConstants.LOCALE_NL_DUTCH;
break;
}

case "pt":
case "pt_PT":
case "pt_BR": {
locale = AppConstants.LOCALE_PT_PORTUGUSE;
break;
}

case "sv":
case "sv_FI":
case "sv_SE": {
locale = AppConstants.LOCALE_SV_SWEDISH;
break;
}

default: {
locale = locale;
break;
}
}

if (ChannelLoggerUtil.isLogLevelActive(AppConstants.CALL_SETTINGS_WEB_CHANNEL, ChannelSeverity.DEV_DEBUG)) {
ChannelLoggerUtil.getLogger().log(ChannelSeverity.DEV_DEBUG, I18nManager.class.getName(),
"Locale is : " + locale);
}

return locale;
}

private String readLocaleTextForDomain(String domainName) {

File domainDirectory = new File(LOCALIZATION_RESOURCE_PATH + File.separator + domainName);
ChannelLoggerUtil.getLogger().log(ChannelSeverity.INFO,
"Domain directory tried to be read : " + domainDirectory.getAbsolutePath());
String domainConfigurations = "";

if (domainDirectory.exists() && domainDirectory.isDirectory()) {

if (ChannelLoggerUtil.isLogLevelActive(AppConstants.CALL_SETTINGS_WEB_CHANNEL,
ChannelSeverity.FIELD_DEBUG)) {
ChannelLoggerUtil.getLogger().log(ChannelSeverity.FIELD_DEBUG, I18nManager.class.getName(),
"reading configuration from the domain folder");
}
domainConfigurations = ApplicationUtil.getFileContent(
new File(domainDirectory + File.separator + "branding", AppConstants.LOCALE_CUSTOM_TEXTS),
AppConstants.UTF8_ENCODING).toString();

}

return domainConfigurations;
}

private void loadDefaultTexts() {

try {
String domainConfigurations = ApplicationUtil
.getFileContent(new File(LOCALIZATION_RESOURCE_PATH + File.separator + AppConstants.BRANDING_FOLDER,
AppConstants.LOCALE_CUSTOM_TEXTS), AppConstants.UTF8_ENCODING)
.toString();

JSONObject defaultLocaleTexts = JSONObject.fromObject(domainConfigurations);
Iterator<?> localeDefaultsIter = ((JSONObject) defaultLocaleTexts.get("services")).keySet().iterator();
while (localeDefaultsIter.hasNext()) {
String localeName = (String) localeDefaultsIter.next();
ChannelLoggerUtil.getLogger().log(ChannelSeverity.INFO, I18nManager.class.getName(),
                       "LOADING LOCALE (locale)" + "locale");
JSONObject localDefaults = (JSONObject) ((JSONObject) defaultLocaleTexts.get("services"))
.get(localeName);

DEFAULT_TEXTS.put(localeName, localDefaults);
}

if (ChannelLoggerUtil.isLogLevelActive(AppConstants.CALL_SETTINGS_WEB_CHANNEL,
ChannelSeverity.FIELD_DEBUG)) {
ChannelLoggerUtil.getLogger().log(ChannelSeverity.FIELD_DEBUG, I18nManager.class.getName(),
"File contents read : " + domainConfigurations.length());
}
} catch (Exception ex) {
ChannelLoggerUtil.getLogger().log(ChannelSeverity.WARN, I18nManager.class.getName(),
"Exception occurred in I18nManager initialization " + ApplicationUtil.getStackTrace(ex));
}
}

// Unit tester code for the I18nManager
public static void main(String a[]) {

try {
String domainConfigurations = ApplicationUtil.getFileContent(
new File(
"C:\\BSFT\\CodeSpace\\WebView\\CallSettingsWeb\\CSW2\\WebContent\\WEB-INF\\customDir\\branding\\callsettings.json"),
AppConstants.UTF8_ENCODING).toString();
System.out.println("File contents read : " + domainConfigurations);

JSONObject defaultLocaleTexts = JSONObject.fromObject(domainConfigurations);
Iterator<?> localeDefaultsIter = ((JSONObject) defaultLocaleTexts.get("services")).keySet().iterator();
while (localeDefaultsIter.hasNext()) {
String localeName = (String) localeDefaultsIter.next();

JSONObject localDefaults = (JSONObject) ((JSONObject) defaultLocaleTexts.get("services"))
.get(localeName);

DEFAULT_TEXTS.put(localeName, localDefaults);
}

} catch (Exception ex) {
System.out.println("Exception occurred in I18nManager initialization " + ApplicationUtil.getStackTrace(ex));
}

System.out.println("Local value : " + DEFAULT_TEXTS.get("es_ES"));

/*
* LOCALIZATION_RESOURCE_PATH =
* "C:\\var\\broadworks\\webapps\\conf\\BWCallSettingsWeb_0.3";
* I18nManager.getInstance().loadDefaultTexts(); String localeText =
* I18nManager.getInstance().getCustomizedLocaleTexts("broadsoft.net",
* "ja_JP"); System.out.println(localeText);
*/
}

}
