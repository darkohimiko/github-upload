<%@page import="com.scc.edms.conf.ImageConfUtil"%>
<%@ page contentType="text/html; charset=tis-620"%>
<%@ page import="com.scc.security.UserInfo"%>
<%@ include file="inc/checkUser.jsp" %>
<%@ include file="inc/constant.jsp" %>
<%@ include file="inc/label.jsp" %>
<%@ include file="inc/utils.jsp" %>
<jsp:useBean id="con" scope="session" class="edms.cllib.EABConnector"/>
<jsp:useBean id="con1" scope="session" class="edms.cllib.EABConnector"/>
<%
	con.setRemoteServer("EAS_SERVER");
	con1.setRemoteServer("EAS_SERVER");

    UserInfo userInfo       = (UserInfo)session.getAttribute( "USER_INFO" );
    String   strUserId      = userInfo.getUserId();
	String   strProjectCode = userInfo.getProjectCode();
	
    String strClassName = "CABINET_CONFIG";
	String screenname   = getField(request.getParameter("screenname"));
    String strMode      = getField(request.getParameter("MODE"));
    
    String strReportPathData  = getField(request.getParameter("txtReportPath"));
    String strWidthData       = getField(request.getParameter("txtWidth"));
    String strHeightData      = getField(request.getParameter("txtHeight"));
    String strLeftMarginData  = getField(request.getParameter("txtLeftMargin"));
    String strRightMarginData = getField(request.getParameter("txtRightMargin"));
    String strPageFromData    = getField(request.getParameter("txtPageFrom"));
    String strPageToData      = getField(request.getParameter("txtPageTo"));
    String strPageValueData   = getField(request.getParameter("txtPageValue"));
    String strFieldLevel1Data = getField(request.getParameter("hidFieldLevel1"));
    String strFieldLevel2Data = getField(request.getParameter("hidFieldLevel2"));
    String strFieldLevel3Data = getField(request.getParameter("hidFieldLevel3"));
    String strFieldLevel4Data = getField(request.getParameter("hidFieldLevel4"));
    String strReportDateData  = getField(request.getParameter("hidReportDate"));
    String strReportNameData  = getField(request.getParameter("hidReportName"));
    
    strReportPathData = strReportPathData.replaceAll( "\\\\", "\\/" );
    if( strWidthData.equals("") ) {
    	strWidthData = "0";
    }
    if( strHeightData.equals("") ) {
    	strHeightData = "0";
    }
    if( strLeftMarginData.equals("") ) {
    	strLeftMarginData = "0";
    }
    if( strRightMarginData.equals("") ) {
    	strRightMarginData = "0";
    }
    if( strPageFromData.equals("") ) {
    	strPageFromData = "0";
    }
    if( strPageToData.equals("") ) {
    	strPageToData = "0";
    }
    if( strPageValueData.equals("") ) {
    	strPageValueData = "0";
    }

    String  screenLabel = lb_report_management;
    
	boolean bolnZoomSuccess = true;
    boolean bolnSuccess     = true;  
    String  strmsg          = "";
	String	strCurrentDate  = "";
	String strVersionLang  = ImageConfUtil.getVersionLang();

        if( strVersionLang.equals("thai") ) {
            strCurrentDate = getServerDateThai();
        }else{
            strCurrentDate = getServerDateEng();
        }
	
	if( strMode == null ){
        strMode = "SEARCH";
    }

    if( strMode.equals("DELETE") ) {
        con.addData( "PROJECT_CODE", "String", strProjectCode);
        bolnSuccess = con.executeService( strContainerName , strClassName , "deleteReportManagement"  );
		if( !bolnSuccess ){
            strmsg="showMsg(0,0,\" " + lc_can_not_delete_data  + "\")";
            strMode = "SEARCH";
        }else{
            strmsg="showMsg(0,0,\" " + lc_delete_data_successful + "\")";
            strMode = "SEARCH";
        }
	}

    if( strMode.equals("ADD") ) {
        con.addData( "PROJECT_CODE",      "String", strProjectCode);
       	con.addData( "REPORT_PATH",       "String", strReportPathData);
       	con.addData( "WIDTH",             "String", strWidthData );
       	con.addData( "HEIGHT",            "String", strHeightData );
       	con.addData( "LEFT_MARGIN",       "String", strLeftMarginData );
       	con.addData( "RIGHT_MARGIN",      "String", strRightMarginData );
       	con.addData( "PAGE_BREAK_FROM",   "String", strPageFromData );
       	con.addData( "PAGE_BREAK_TO",     "String", strPageToData );
       	con.addData( "PAGE_BREAK_VALUE",  "String", strPageValueData );
       	con.addData( "LEVEL1_NAME_FIELD", "String", strFieldLevel1Data );
       	con.addData( "LEVEL2_NAME_FIELD", "String", strFieldLevel2Data );
       	con.addData( "LEVEL3_NAME_FIELD", "String", strFieldLevel3Data );
       	con.addData( "LEVEL4_NAME_FIELD", "String", strFieldLevel4Data );
       	con.addData( "REPORT_DATE_FIELD", "String", strReportDateData );
       	con.addData( "REPORT_NAME_FIELD", "String", strReportNameData );
        con.addData( "ADD_USER",          "String", strUserId);
        con.addData( "ADD_DATE",          "String", strCurrentDate);
        con.addData( "UPD_USER",          "String", strUserId);

        bolnSuccess = con.executeService( strContainerName , strClassName , "insertReportManagement"  );

        if( !bolnSuccess ){
            strmsg="showMsg(0,0,\" " + lc_can_not_add_data  + "\")";
            strMode = "ADD";
        }else{
            strmsg="showMsg(0,0,\" " + lc_add_data_successfull + "\")";
            strMode = "SEARCH";
        }
	}

    if( strMode.equals("EDIT") ) {
        con.addData( "PROJECT_CODE",      "String", strProjectCode);
       	con.addData( "REPORT_PATH",       "String", strReportPathData);
       	con.addData( "WIDTH",             "String", strWidthData );
       	con.addData( "HEIGHT",            "String", strHeightData );
       	con.addData( "LEFT_MARGIN",       "String", strLeftMarginData );
       	con.addData( "RIGHT_MARGIN",      "String", strRightMarginData );
       	con.addData( "PAGE_BREAK_FROM",   "String", strPageFromData );
       	con.addData( "PAGE_BREAK_TO",     "String", strPageToData );
       	con.addData( "PAGE_BREAK_VALUE",  "String", strPageValueData );
       	con.addData( "LEVEL1_NAME_FIELD", "String", strFieldLevel1Data );
       	con.addData( "LEVEL2_NAME_FIELD", "String", strFieldLevel2Data );
       	con.addData( "LEVEL3_NAME_FIELD", "String", strFieldLevel3Data );
       	con.addData( "LEVEL4_NAME_FIELD", "String", strFieldLevel4Data );
       	con.addData( "REPORT_DATE_FIELD", "String", strReportDateData );
       	con.addData( "REPORT_NAME_FIELD", "String", strReportNameData );
        con.addData( "EDIT_USER",         "String", strUserId);
        con.addData( "EDIT_DATE",         "String", strCurrentDate);
        con.addData( "UPD_USER",          "String", strUserId);

        bolnSuccess = con.executeService( strContainerName , strClassName , "updateReportManagement"  );

        if( !bolnSuccess ){
            strmsg="showMsg(0,0,\" " + lc_can_not_update_data  + "\")";
            strMode = "EDIT";
        }else{
            strmsg="showMsg(0,0,\" " + lc_update_data_successfull + "\")";
            strMode = "SEARCH";
        }
	}
    
    if( strMode.equals("SEARCH") ) {
        con.addData( "PROJECT_CODE", "String", strProjectCode );
        bolnSuccess = con.executeService( strContainerName, strClassName, "findReportManagement" );
        
        if( !bolnSuccess ) {
            strMode = "ADD";
            strReportPathData  = "";
        	strWidthData       = "";
        	strHeightData      = "";
        	strLeftMarginData  = "";
        	strRightMarginData = "";
        	strPageFromData    = "";
        	strPageToData      = "";
        	strPageValueData   = "";
        	strFieldLevel1Data = "";
        	strFieldLevel2Data = "";
        	strFieldLevel3Data = "";
        	strFieldLevel4Data = "";
        	strReportDateData  = "";
        	strReportNameData  = "";
        }else {
            while( con.nextRecordElement() ) {
            	strReportPathData  = con.getColumn( "REPORT_PATH" );
            	strWidthData       = con.getColumn( "WIDTH" );
            	strHeightData      = con.getColumn( "HEIGHT" );
            	strLeftMarginData  = con.getColumn( "LEFT_MARGIN" );
            	strRightMarginData = con.getColumn( "RIGHT_MARGIN" );
            	strPageFromData    = con.getColumn( "PAGE_BREAK_FROM" );
            	strPageToData      = con.getColumn( "PAGE_BREAK_TO" );
            	strPageValueData   = con.getColumn( "PAGE_BREAK_VALUE" );
            	strFieldLevel1Data = con.getColumn( "LEVEL1_NAME_FIELD" );
            	strFieldLevel2Data = con.getColumn( "LEVEL2_NAME_FIELD" );
            	strFieldLevel3Data = con.getColumn( "LEVEL3_NAME_FIELD" );
            	strFieldLevel4Data = con.getColumn( "LEVEL4_NAME_FIELD" );
            	strReportDateData  = con.getColumn( "REPORT_DATE_FIELD" );
            	strReportNameData  = con.getColumn( "REPORT_NAME_FIELD" );
            	
            	//strReportPathData = strReportPathData.replaceAll( "##", "\\" );
/*            	
            	if( strWidthData.equals("0") ) {
                	strWidthData = "";
                }
                if( strHeightData.equals("0") ) {
                	strHeightData = "";
                }
                if( strLeftMarginData.equals("0") ) {
                	strLeftMarginData = "";
                }
                if( strRightMarginData.equals("0") ) {
                	strRightMarginData = "";
                }
                if( strPageFromData.equals("0") ) {
                	strPageFromData = "";
                }
                if( strPageToData.equals("0") ) {
                	strPageToData = "";
                }
                if( strPageValueData.equals("0") ) {
                	strPageValueData = "";
                }
*/                
                strMode = "EDIT";
            }
        }
    }
    
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title><%=lc_site_name%></title>
<meta http-equiv="Content-Type" content="text/html; charset=windows-874">
<script language="JavaScript" type="text/JavaScript">
<!--
function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}

function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_findObj(n, d) { //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
}

function MM_swapImage() { //v3.0
  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
}
//-->
</script>
<script language="JavaScript" src="js/sccUtils.js"></script>
<script language="JavaScript" src="js/util.js"></script>
<script language="JavaScript" src="js/constant.js"></script>
<script language="JavaScript" src="js/label.js"></script>
<script language="JavaScript" type="text/javascript">
<!--

var mode     = "<%=strMode %>";
var sccUtils = new SCUtils;

function window_onload() {
    lb_report_path.innerHTML         = lbl_report_path;
    lb_report_width.innerHTML        = lbl_report_width;
    lb_report_height.innerHTML       = lbl_report_height;
    lb_report_left_margin.innerHTML  = lbl_report_left_margin;
    lb_report_right_margin.innerHTML = lbl_report_right_margin;
    lb_page_break_from.innerHTML     = lbl_page_break_from;
    lb_page_break_to.innerHTML       = lbl_page_break_to;
    lb_page_break_value.innerHTML    = lbl_page_break_value;
    lb_field_level1.innerHTML        = lbl_field_level1;
    lb_field_level2.innerHTML        = lbl_field_level2;
    lb_field_level3.innerHTML        = lbl_field_level3;/*
    lb_field_level4.innerHTML        = lbl_field_level4;
*/
    lb_field_report_date.innerHTML   = lbl_field_report_date;
    lb_field_report_name.innerHTML   = lbl_field_report_name;
    
    obj_txtReportPath.value  = "<%=strReportPathData %>";
   	obj_txtWidth.value       = "<%=strWidthData %>";
   	obj_txtHeight.value      = "<%=strHeightData %>";
   	obj_txtLeftMargin.value  = "<%=strLeftMarginData %>";
   	obj_txtRightMargin.value = "<%=strRightMarginData %>";
   	obj_txtPageFrom.value    = "<%=strPageFromData %>";
   	obj_txtPageTo.value      = "<%=strPageToData %>";
   	obj_txtPageValue.value   = "<%=strPageValueData %>";
   	obj_optFieldLevel1.value = "<%=strFieldLevel1Data %>";
   	obj_hidFieldLevel1.value = "<%=strFieldLevel1Data %>";
   	obj_optFieldLevel2.value = "<%=strFieldLevel2Data %>";
   	obj_hidFieldLevel2.value = "<%=strFieldLevel2Data %>";
   	obj_optFieldLevel3.value = "<%=strFieldLevel3Data %>";
   	obj_hidFieldLevel3.value = "<%=strFieldLevel3Data %>";
//   	obj_optFieldLevel4.value = "<%=strFieldLevel4Data %>";
   	obj_hidFieldLevel4.value = "<%=strFieldLevel4Data %>";
   	obj_optReportDate.value  = "<%=strReportDateData %>";
   	obj_hidReportDate.value  = "<%=strReportDateData %>";
   	obj_optReportName.value  = "<%=strReportNameData %>";
   	obj_hidReportName.value  = "<%=strReportNameData %>";
   	
   	obj_txtReportPath.focus();
}

function chkValueIsNumber() {
	var carCode = event.keyCode;
    if ((carCode < 48) || (carCode > 57)){
        if( event.preventDefault ){
            event.preventDefault();
        }else{
            event.returnValue = false;
        }
        return;
    }
}

function getValueRole( lv_type ) {
	switch( lv_type ) {
		case "level1" :
			obj_hidFieldLevel1.value = obj_optFieldLevel1.value;
			break;
		case "level2" :
			obj_hidFieldLevel2.value = obj_optFieldLevel2.value;
			break;
		case "level3" :
			obj_hidFieldLevel3.value = obj_optFieldLevel3.value;
			break;
		case "level4" :
			obj_hidFieldLevel4.value = obj_optFieldLevel4.value;
			break;
		case "date" :
		case "date_eng" :
			obj_hidReportDate.value = obj_optReportDate.value;
			break;
		case "name" :
			obj_hidReportName.value = obj_optReportName.value;
			break;
	}
}

function buttonClick( lv_strMethod ){
    switch( lv_strMethod ){
		case "save" :
		    if( verify_form() ){
/*		        if(form1.MODE.value == "pInsert"){
		            form1.MODE.value = "ADD" ;
		        }else{
		            form1.MODE.value = "EDIT" ;
		        }
*/				form1.submit();
			}
			break;
		case "cancel_report" :
			if( obj_txtReportPath.value == "" ) {
				return;
			}
			if( !confirm( lc_confirm_delete ) ){
				return;
			}
			form1.action     = "report_management.jsp";
			form1.target 	 = "_self";
		    form1.MODE.value = "DELETE";
		    form1.submit();
			break;
		case "cancel" :
			form1.action     = "cabinet_config1.jsp";
			form1.target 	 = "_self";
		    form1.MODE.value = "SEARCH";
		    form1.submit();
			break;
	}
}

function verify_form() {
	var strPath = obj_txtReportPath.value;
	
	if( obj_txtReportPath.value.length == 0 ) {
        alert( lc_check_report_path );
        obj_txtReportPath.focus();
        return false;
	}
	//obj_txtReportPath.value = strPath.replace( /\\/gi , "\\\" );
	return true;
}

//-->
</script>
<link href="css/edas.css" type="text/css" rel="stylesheet">
</head>
<body onLoad="MM_preloadImages('images/btt_save2_over.gif','images/btt_back_over.gif','images/btt_newpw_over.gif','images/btt_cancelreport_over.gif');window_onload();">
<form name="form1" method="post" action="" >
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0" align="center">
  <tr>
    <td valign="top">
    	<table width="800" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td height="25" class="label_header01" colspan="4">&nbsp;&nbsp;<%=screenname%>&nbsp; >> &nbsp;<%=screenLabel %></td>
              </tr>
              <tr>
            	<td height="25" align="center">
            		<table width="502" border="0" cellspacing="0" cellpadding="0">
		                <tr>
		                  	<td height="25" colspan="4">&nbsp;</td>
		                </tr>
	                	<tr>
		                  	<td height="25" class="label_bold2"><span id="lb_report_path"></span>&nbsp;
		                  		<img src="images/mark.gif" width="12" height="11">
		                  	</td>
		                  	<td height="25" colspan="3">
		                  		<input id="txtReportPath" name="txtReportPath" type="text" class="input_box" size="56" maxlength="60">
		                  	</td>
	                	</tr>
	                	<tr>
		                  	<td height="25" class="label_bold2"><span id="lb_report_width"></span></td>
		                  	<td height="25" colspan="3">
		                  		<input id="txtWidth" name="txtWidth" type="text" class="input_box" size="10" maxlength="19" onkeypress="chkValueIsNumber()">
		                  	</td>
	                	</tr>
	                	<tr>
		                  	<td height="25" class="label_bold2"><span id="lb_report_height"></span></td>
		                  	<td height="25" colspan="3">
		                  		<input id="txtHeight" name="txtHeight" type="text" class="input_box" size="10" maxlength="19" onkeypress="chkValueIsNumber()">
		                  	</td>
	                	</tr>
	                	<tr>
		                  	<td height="25" class="label_bold2"><span id="lb_report_left_margin"></span></td>
		                  	<td height="25" colspan="3">
		                  		<input id="txtLeftMargin" name="txtLeftMargin" type="text" class="input_box" size="10" maxlength="19" onkeypress="chkValueIsNumber()">
		                  	</td>
	                	</tr>
	                	<tr>
		                  	<td height="25" class="label_bold2"><span id="lb_report_right_margin"></span></td>
		                  	<td height="25" colspan="3">
		                  		<input id="txtRightMargin" name="txtRightMargin" type="text" class="input_box" size="10" maxlength="19" onkeypress="chkValueIsNumber()">
		                  	</td>
	                	</tr>
	                	<tr>
		                  	<td height="25" class="label_bold2"><span id="lb_page_break_from"></span></td>
		                  	<td height="25" colspan="3">
		                  		<input id="txtPageFrom" name="txtPageFrom" type="text" class="input_box" size="10" maxlength="19" onkeypress="chkValueIsNumber()">
		                  	</td>
	                	</tr>
	                	<tr>
		                  	<td height="25" class="label_bold2"><span id="lb_page_break_to"></span></td>
		                  	<td height="25" colspan="3">
		                  		<input id="txtPageTo" name="txtPageTo" type="text" class="input_box" size="10" maxlength="19" onkeypress="chkValueIsNumber()">
		                  	</td>
	                	</tr>
	                	<tr>
		                  	<td height="25" class="label_bold2"><span id="lb_page_break_value"></span></td>
		                  	<td height="25" colspan="3">
		                  		<input id="txtPageValue" name="txtPageValue" type="text" class="input_box" size="10" maxlength="19" >
		                  	</td>
	                	</tr>
<%

	String strTagFieldLevel1Option = "";
	String strTagFieldLevel2Option = "";
	String strTagFieldLevel3Option = "";
	String strTagFieldLevel4Option = "";
	String strTagReportDateOption  = "";
	String strTagReportNameOption  = "";
	String strScanOrg              = "SCAN_ORG";

	String strZoomFieldCode   = "";
	String strZoomFieldLabel  = "";

	strTagFieldLevel1Option = "\n<select id=\"optFieldLevel1\" name=\"optFieldLevel1\" class=\"combobox\" onchange=\"getValueRole( 'level1' );\">";
	strTagFieldLevel1Option += "\n<option value=\"\"></option>";
	
	strTagFieldLevel2Option = "\n<select id=\"optFieldLevel2\" name=\"optFieldLevel2\" class=\"combobox\" onchange=\"getValueRole( 'level2' );\">";
	strTagFieldLevel2Option += "\n<option value=\"\"></option>";
	
	strTagFieldLevel3Option = "\n<select id=\"optFieldLevel3\" name=\"optFieldLevel3\" class=\"combobox\" onchange=\"getValueRole( 'level3' );\">";
	strTagFieldLevel3Option += "\n<option value=\"\"></option>";
	
	strTagFieldLevel4Option = "\n<select id=\"optFieldLevel4\" name=\"optFieldLevel4\" class=\"combobox\" onchange=\"getValueRole( 'level4' );\">";
	strTagFieldLevel4Option += "\n<option value=\"\"></option>";
	
	strTagReportDateOption = "\n<select id=\"optReportDate\" name=\"optReportDate\" class=\"combobox\" onchange=\"getValueRole( 'date' );\">";
	strTagReportDateOption += "\n<option value=\"\"></option>";
	
	strTagReportNameOption = "\n<select id=\"optReportName\" name=\"optReportName\" class=\"combobox\" onchange=\"getValueRole( 'name' );\">";
	strTagReportNameOption += "\n<option value=\"\"></option>";
	
	con1.addData( "PROJECT_CODE", "String", strProjectCode );		
	bolnZoomSuccess = con1.executeService( strContainerName, strClassName, "findReportNameCombo" );
	
	if( bolnZoomSuccess ){
		while( con1.nextRecordElement() ){
			strZoomFieldLabel = con1.getColumn( "FIELD_LABEL" );
			strZoomFieldCode  = con1.getColumn( "FIELD_CODE" );
	
			strTagFieldLevel1Option += "\n<option value=\"" + strZoomFieldCode + "\">" + strZoomFieldLabel + "</option>";
			strTagFieldLevel2Option += "\n<option value=\"" + strZoomFieldCode + "\">" + strZoomFieldLabel + "</option>";
			strTagFieldLevel3Option += "\n<option value=\"" + strZoomFieldCode + "\">" + strZoomFieldLabel + "</option>";
			strTagFieldLevel4Option += "\n<option value=\"" + strZoomFieldCode + "\">" + strZoomFieldLabel + "</option>";
			strTagReportDateOption  += "\n<option value=\"" + strZoomFieldCode + "\">" + strZoomFieldLabel + "</option>";
			strTagReportNameOption  += "\n<option value=\"" + strZoomFieldCode + "\">" + strZoomFieldLabel + "</option>";
		}
	}
	
	strTagFieldLevel1Option += "\n<option value=\"" + strScanOrg + "\">" + lb_scan_org_combo + "</option>";
	strTagFieldLevel2Option += "\n<option value=\"" + strScanOrg + "\">" + lb_scan_org_combo + "</option>";
	strTagFieldLevel3Option += "\n<option value=\"" + strScanOrg + "\">" + lb_scan_org_combo + "</option>";
	strTagFieldLevel4Option += "\n<option value=\"" + strScanOrg + "\">" + lb_scan_org_combo + "</option>";
	strTagReportDateOption  += "\n<option value=\"" + strScanOrg + "\">" + lb_scan_org_combo + "</option>";
	strTagReportNameOption  += "\n<option value=\"" + strScanOrg + "\">" + lb_scan_org_combo + "</option>";
	
	strTagFieldLevel1Option += "\n</select>";
	strTagFieldLevel2Option += "\n</select>";
	strTagFieldLevel3Option += "\n</select>";
	strTagFieldLevel4Option += "\n</select>";
	strTagReportDateOption  += "\n</select>";
	strTagReportNameOption  += "\n</select>";

%>
	                	<tr>
		                  	<td height="25" class="label_bold2"><span id="lb_field_report_name"></span></td>
		                  	<td height="25" colspan="3"><%=strTagReportNameOption %>
		                  		<input id="hidReportName" name="hidReportName" type="hidden" >
		                  	</td>
	                	</tr>
	                	<tr>
		                  	<td height="25" class="label_bold2"><span id="lb_field_report_date"></span></td>
		                  	<td height="25" colspan="3"><%=strTagReportDateOption %>
		                  		<input id="hidReportDate" name="hidReportDate" type="hidden" >
		                  	</td>
	                	</tr>
	                	<tr>
		                  	<td height="25" class="label_bold2"><span id="lb_field_level1"></span></td>
		                  	<td height="25" colspan="3"><%=strTagFieldLevel1Option %>
		                  		<input id="hidFieldLevel1" name="hidFieldLevel1" type="hidden" >
		                  	</td>
	                	</tr>
	                	<tr>
		                  	<td height="25" class="label_bold2"><span id="lb_field_level2"></span></td>
		                  	<td height="25" colspan="3"><%=strTagFieldLevel2Option %>
		                  		<input id="hidFieldLevel2" name="hidFieldLevel2" type="hidden" >
		                  	</td>
	                	</tr>
	                	<tr>
		                  	<td height="25" class="label_bold2"><span id="lb_field_level3"></span></td>
		                  	<td height="25" colspan="3"><%=strTagFieldLevel3Option %>
		                  		<input id="hidFieldLevel3" name="hidFieldLevel3" type="hidden" >
		                  	</td>
	                	</tr>
	                	<!-- tr>
		                  	<td height="25" class="label_bold2"><span id="lb_field_level4"></span></td>
		                  	<td height="25" colspan="3"><%=strTagFieldLevel4Option %>
		                  		<input id="hidFieldLevel4" name="hidFieldLevel4" type="hidden" >
		                  	</td>
	                	</tr-->
	                	<tr>
	                  		<td height="25" colspan="4">&nbsp;</td>
	                  	</tr>
			            <tr>
				           	<td align="center" colspan="4">
				           		<a href="#" onclick= "buttonClick('save')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('save','','images/btt_save2_over.gif',1)">
				           			<img src="images/btt_save2.gif" name="save" width="67" height="22" border="0"></a>&nbsp;
				           		<a href="#" onclick= "buttonClick('cancel_report')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('cancel_report','','images/btt_cancelreport_over.gif',1)">
				           			<img src="images/btt_cancelreport.gif" name="cancel_report" width="102" height="22" border="0"></a>&nbsp;
				           		<a href="#" onclick= "buttonClick('cancel')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('back','','images/btt_back_over.gif',1)">
				           			<img src="images/btt_back.gif" name="back" width="67" height="22" border="0"></a>
				           	</td>
			            </tr>
              		</table>
		            <input type="hidden" id="MODE"        name="MODE"        value="<%=strMode%>">
		            <input type="hidden" id="screenname"  name="screenname"  value="<%=screenname%>">
		            <input type="hidden" id="screenLabel" name="screenLabel" value="<%=screenLabel%>">
              		<input type="hidden" id="hidFieldLevel1" name="hidFieldLevel1">
              		<input type="hidden" id="hidFieldLevel2" name="hidFieldLevel2">
              		<input type="hidden" id="hidFieldLevel3" name="hidFieldLevel3">
              		<input type="hidden" id="hidFieldLevel4" name="hidFieldLevel4">
            	</td>
            </tr>
        </table>
        <p>&nbsp;</p>
      </td>
    </tr>
</table>
</form>
</body>
</html>
<script language="JavaScript" type="text/javascript">
<!--

var obj_txtReportPath  = document.getElementById("txtReportPath");
var obj_txtWidth       = document.getElementById("txtWidth");
var obj_txtHeight      = document.getElementById("txtHeight");
var obj_txtLeftMargin  = document.getElementById("txtLeftMargin");
var obj_txtRightMargin = document.getElementById("txtRightMargin");
var obj_txtPageFrom    = document.getElementById("txtPageFrom");
var obj_txtPageTo      = document.getElementById("txtPageTo");
var obj_txtPageValue   = document.getElementById("txtPageValue");

var obj_optFieldLevel1 = document.getElementById("optFieldLevel1");
var obj_hidFieldLevel1 = document.getElementById("hidFieldLevel1");

var obj_optFieldLevel2 = document.getElementById("optFieldLevel2");
var obj_hidFieldLevel2 = document.getElementById("hidFieldLevel2");

var obj_optFieldLevel3 = document.getElementById("optFieldLevel3");
var obj_hidFieldLevel3 = document.getElementById("hidFieldLevel3");

var obj_optFieldLevel4 = document.getElementById("optFieldLevel4");
var obj_hidFieldLevel4 = document.getElementById("hidFieldLevel4");

var obj_optReportDate  = document.getElementById("optReportDate");
var obj_hidReportDate  = document.getElementById("hidReportDate");

var obj_optReportName  = document.getElementById("optReportName");
var obj_hidReportName  = document.getElementById("hidReportName");
//-->
</script>
<%  if (!strmsg.equals("")) {  %>
<script language="javaScript">
    <%=strmsg%>
</script>
<%  }   %>