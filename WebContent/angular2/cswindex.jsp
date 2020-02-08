<!--  Copyright © 2017 BroadSoft Inc. All rights reserved. Proprietary Property of BroadSoft, Inc. Gaithersburg, MD. -->

<%@page import="java.io.BufferedReader,java.io.InputStreamReader"%>
<%@page import="java.lang.Exception"%>
<%@page import="com.broadsoft.callsettingsweb.server.branding.I18nManager"%>
<%@page import="com.broadsoft.callsettingsweb.server.loggers.ChannelLoggerUtil"%>
<%@page import="com.broadsoft.xsp.app.base.ChannelSeverity"%>
<%@page import="com.broadsoft.callsettingsweb.server.util.ApplicationUtil"%>
<%@page import="com.broadsoft.callsettingsweb.server.AppConstants"%>
<%@page import="net.sf.json.JSONObject"%>

<%
      ChannelLoggerUtil.getLogger().log(ChannelSeverity.FIELD_DEBUG, "cswindex.jsp ",  " Request Method :  "  + request.getMethod());
 ChannelLoggerUtil.getLogger().log(ChannelSeverity.FIELD_DEBUG, "cswindex.jsp ",  " Request Content Type :  "  + request.getContentType());
 ChannelLoggerUtil.getLogger().log(ChannelSeverity.FIELD_DEBUG, "cswindex.jsp ",  " Request Content Length :  "  + request.getContentLength());
 ChannelLoggerUtil.getLogger().log(ChannelSeverity.FIELD_DEBUG, "cswindex.jsp ", " Request URI :  " + request.getRequestURI());
 ChannelLoggerUtil.getLogger().log(ChannelSeverity.FIELD_DEBUG, "cswindex.jsp ", " Request URL :  " + request.getRequestURL());
 ChannelLoggerUtil.getLogger().log(ChannelSeverity.FIELD_DEBUG, "cswindex.jsp ", " Authorization Header :  " + request.getHeader("Authorization"));


       String heroApplicationInput =  "";
 String customizationTexts = "";
 String userDomain = "";
 String xsiContextPath = "";
 String displayCriteriaOrScheduleName = "";


 try {

  StringBuilder buffer = new StringBuilder();
  BufferedReader reader = request.getReader();
  String line;
  while ((line = reader.readLine()) != null) {
   buffer.append(line);
           }
           heroApplicationInput = "";
  ChannelLoggerUtil.getLogger().log(ChannelSeverity.FIELD_DEBUG, "cswindex.jsp ", " Request body read from input buffer, : "+heroApplicationInput);


      } catch (Exception ex) {
  ChannelLoggerUtil.getLogger().log(ChannelSeverity.WARN, "cswindex.jsp ", "Exception occurred in reading the application input data." + ApplicationUtil.getStackTrace(ex) );
  response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
  return;
 }


      String authFailedParam = request.getParameter("authFailed");
 if(authFailedParam != null && authFailedParam.trim().length() <= 0) {
  ChannelLoggerUtil.getLogger().log(ChannelSeverity.WARN, "cswindex.jsp ", "Application invoked with the reloaded parameter." );
  response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
  return;
 }

  String brandableApp = request.getParameter("brandable");
 if(brandableApp == null || brandableApp.trim().length() <= 0) {

 }


 if(brandableApp != null && brandableApp.trim().length() > 0) {


 try {

  heroApplicationInput = ApplicationUtil.readJSONForAppTest();

 } catch (Exception ex) {
  ChannelLoggerUtil.getLogger().log(ChannelSeverity.WARN, "cswindex.jsp ", "Exception occurred in reading the JSON input data." + ApplicationUtil.getStackTrace(ex) );
 }


 }


 try {
  ChannelLoggerUtil.getLogger().log(ChannelSeverity.FIELD_DEBUG, "cswindex.jsp ", " Fetch userDomain");
  userDomain = ApplicationUtil.getDomainForRequest(request);
  ChannelLoggerUtil.getLogger().log(ChannelSeverity.FIELD_DEBUG, "cswindex.jsp ", " Got userDomain: " + userDomain);
 } catch (Exception ex) {
  ChannelLoggerUtil.getLogger().log(ChannelSeverity.WARN, "cswindex.jsp ", "Exception occurred while getting Domain for Request." + ApplicationUtil.getStackTrace(ex) );
 }


 try {

 xsiContextPath = ApplicationUtil.getXsiContextPathOrUrl(request);
 } catch (Exception ex) {
  ChannelLoggerUtil.getLogger().log(ChannelSeverity.WARN, "cswindex.jsp ", "Exception occurred while getting XSI Path or URL." + ApplicationUtil.getStackTrace(ex) );
 }


 %>


<script type="text/javascript">

var callSettingsHeroInput = {
"userId": "7650000201@bsftdesigns.vle.broadsoft.com",
"appVersion": "1.0.0.0",
"appName": "Iris",
"deviceMobileNo": "",
"loginToken": "c3NvMV81ZDMxYTZkZi1iM2E1LTQ1YjQtYjMwZC0wZjhmOWExYjBhODBfMTAuMTkzLjIyNy4yXzc2NTAwMDAyMDFAYnNmdGRlc2lnbnMudmxlLmJyb2Fkc29mdC5jb20=",
"platform": "iOS_Mob",
"language": "en-US",
"services": [{
"name": "Call Forwarding Always",
"visible": false
}, {
"name": "Do Not Disturb",
"visible": false
}],
"branding": {
"fontStyle": ".SF UI Text",
"fontSize": {
 "RestrictiveButtonStyle": 16,
 "RestrictiveLabelStyle": 14,
 "RestrictiveSmallLabelStyle": 13
},
"color": {
 "PrimaryText": "#FFFFFF",
 "ContentBackground": "#FFFFFF",
 "PrimaryContentText": "#323232",
 "PrimaryBackground": "#2DBD9B",
 "ControlBackground": "#F8F8F8",
 "PrimaryButton": "#2DBD9B",
 "TertiaryContentText": "#969696",
 "SymbolicRed": "#FF3347",
 "Separators": "#F0F0F0",
 "SymbolicGreen": "#28D47B",
 "SecondaryContentText": "#646464",
 "DimmedText": "#B4B4B4"
}
}
}
var userDomain = '<%= userDomain %>'
var xsiContextPath = '<%= xsiContextPath %>'
var displayCriteriaOrScheduleName = '<%= displayCriteriaOrScheduleName %>'

console.log("Data read from the JSON : "+callSettingsHeroInput);
</script>

<%
try {
     ChannelLoggerUtil.getLogger().log(ChannelSeverity.FIELD_DEBUG, "cswindex.jsp ", " Get customizationTexts: " + customizationTexts);
     customizationTexts = I18nManager.getInstance().getDefaultTexts();
     ChannelLoggerUtil.getLogger().log(ChannelSeverity.FIELD_DEBUG, "cswindex.jsp ", " Got customizationTexts: " + customizationTexts);

     } catch (Exception ex) {
 ChannelLoggerUtil.getLogger().log(ChannelSeverity.WARN, "cswindex.jsp ", "Exception occurred in reading the cutomization texts." + ApplicationUtil.getStackTrace(ex));
 response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
 return;
}
      %>


<script type="text/javascript">
var localeCustomTexts =      <%= customizationTexts %> ; ;
var xhttp = new XMLHttpRequest();
var isTextsLoaded = false;

(function () {

xhttp.onreadystatechange = function() {
 if (this.readyState == 4 && this.status == 200) {
   window['customizedTexts'] = JSON.parse(this.responseText);
 }

 isTextsLoaded = true;
};
xhttp.open('GET', 'customTexts?userDomain=' + userDomain + '&language=' + callSettingsHeroInput.language, true);
xhttp.send();

})();


xsiActionsBaseURL = xsiContextPath;
displayCriteriaOrScheduleName = displayCriteriaOrScheduleName;
console.log('Xsi-Actions baseURL : '+ xsiActionsBaseURL);
console.log('displayCriteriaOrScheduleName Value : '+ displayCriteriaOrScheduleName);

var customStyleUrl = '';
customStyleUrl = customStyleUrl + 'userDomain=' + userDomain;
customStyleUrl = customStyleUrl + '&platform=' + ((callSettingsHeroInput.platform != null && callSettingsHeroInput.platform != '') ? callSettingsHeroInput.platform : 'iOS_Mob');

if(callSettingsHeroInput.branding != null) {

customStyleUrl = customStyleUrl + '&FontFamily=' + callSettingsHeroInput.branding.fontStyle;

if(callSettingsHeroInput.branding.color != null) {

var fontColors = callSettingsHeroInput.branding.color;
for(var fontColor in fontColors) {
 if (fontColors.hasOwnProperty(fontColor)) {

   customStyleUrl = customStyleUrl + '&' + fontColor + '=' + ((fontColors[fontColor] == null) ? '' : fontColors[fontColor]);

 }
}
}

if(callSettingsHeroInput.branding.fontSize != null) {

var fontSizes = callSettingsHeroInput.branding.fontSize;
for(var fontSize in fontSizes) {
 if (fontSizes.hasOwnProperty(fontSize)) {

   customStyleUrl = customStyleUrl + '&' + fontSize + '=' + ((fontSizes[fontSize] == null) ? '' : fontSizes[fontSize]);

 }
}
}
}

var customStyleUrlString = 'customStyle?' + encodeURIComponent(customStyleUrl);

(function(){
var newstyle = document.createElement('link');
newstyle.setAttribute("id", "brandedStyle");
newstyle.setAttribute("rel", "stylesheet");
newstyle.setAttribute("type", "text/css");
newstyle.setAttribute("href", customStyleUrlString);
document.getElementsByTagName("head")[0].appendChild(newstyle);

})();

</script>

<script type="text/javascript">

(function () {

window['applicationMode'] = "prod";
window['callSettingsHeroInput'] = callSettingsHeroInput;
if (!window['customizedTexts']) {
 window['customizedTexts'] = localeCustomTexts;
}
window['xsiActionsBaseURL'] = xsiActionsBaseURL;
window['displayCriteriaOrScheduleName'] = displayCriteriaOrScheduleName;

// Developer mode constants
window['devUserPwd'] = "Welcom3";
if(window.location.href.indexOf("brandable") > 0) {
 window['applicationMode'] = "qa";
}

window['locale'] = callSettingsHeroInput.language;

})();


</script>

<html>
<head>
<meta charset="utf-8">
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<title>BWCallSettingsWeb</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0">

<link href='assets/fonts/roboto/webfont.css' rel='stylesheet' type='text/css'>
<script src='assets/fonts/roboto/webfont.js'></script>
<link href='assets/css/default.css' rel='stylesheet' type='text/css'>

<link rel="stylesheet" href="styles.3b59a19e97dbfd55ac7a.css"></head>

<body>
<app-bsft-call-settings></app-bsft-call-settings>
<div id="helperText" class="callsettingHelperText restrictiveLabelStyle callSettingsFontFamily"></div>
<script type="text/javascript" src="runtime.26209474bfa8dc87a77c.js"></script><script type="text/javascript" src="polyfills.062e42a544ec29e333f7.js"></script><script type="text/javascript" src="scripts.03e042f1f102bf0e2ed8.js"></script><script type="text/javascript" src="vendor.db61bce01cce923975f6.js"></script><script type="text/javascript" src="main.371bbcd20e0b80ae6b1c.js"></script></body>

</html>


