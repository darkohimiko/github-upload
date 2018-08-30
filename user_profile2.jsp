<%@ page contentType="text/html; charset=tis-620"%>
<%@ page import="com.scc.edms.conf.ImageConfUtil"%>
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

    UserInfo userInfo = (UserInfo)session.getAttribute( "USER_INFO" );
    String strUserId  = userInfo.getUserId();

    String screenname   = getField(request.getParameter("screenname"));
    String screenLabel  = getField(request.getParameter("screenLabel"));
    String strClassName = "USER_PROFILE";
    String strMode      = getField(request.getParameter("MODE"));
    
    String mode_parent              = getField(request.getParameter( "mode_parent" ));
    String current_page_parent      = getField(request.getParameter( "current_page_parent" ));
    String sortby_parent            = getField(request.getParameter( "sortby_parent" ));
    String sortfield_parent         = getField(request.getParameter( "sortfield_parent" ));
    String strFieldUserIdSearch     = getField(request.getParameter( "USER_ID_SEARCH" ));
    String strFieldUserNameSearch   = getField(request.getParameter( "USER_NAME_SEARCH" ));
    String strFieldUserSnameSearch  = getField(request.getParameter( "USER_SNAME_SEARCH" ));
    String strFieldUserLevelSearch  = getField(request.getParameter( "USER_LEVEL_SEARCH" ));
    String strFieldOrgCodeSearch    = getField(request.getParameter( "ORG_CODE_SEARCH" ));
    String strFieldUserStatusSearch = getField(request.getParameter( "USER_STATUS_SEARCH" ));
    
    String strUserIdKey = getField(request.getParameter("USER_ID_KEY"));

    String strIsAdminData       = getField(request.getParameter("hidIsAdmin"));
    String strUserIdData        = getField(request.getParameter("txtUserId"));
    String strUserPassData      = getField(request.getParameter("txtUserPass"));
    String strTitleData         = getField(request.getParameter("hidTitle"));
    String strUserNameData      = getField(request.getParameter("txtUserName"));
    String strUserSnameData     = getField(request.getParameter("txtUserSname"));
    String strUserLevelData     = getField(request.getParameter("txtUserLevel"));
    String strUserLevelNameData = getField(request.getParameter("txtLevelName"));
    String strUserOrgData       = getField(request.getParameter("txtOrgCode"));
    String strUserOrgNameData   = getField(request.getParameter("txtOrgName"));
    String strUserEmailData     = getField(request.getParameter("txtUserEmail"));
    String strUserPositionData  = getField(request.getParameter("txtUserPosition"));
    String strUserAddressData   = getField(request.getParameter("txtUserAddress"));
    String strUserEntryData     = getField(request.getParameter("txtUserEntry"));
    String strUserStatusData    = getField(request.getParameter("hidUserStatus"));
    String strDateChangeData    = getField(request.getParameter("txtDateChange"));
    String strhidChkPassData    = getField(request.getParameter("hidChkPass"));
    String strSecFlag           = "";
    String strUserGroupName     = "";
    
    boolean bolnZoomSuccess = true;
    boolean bolnSuccess     = false;
    boolean bolnSuccess1    = false;
    boolean bolnGroup       = false;
    
    String strErrorCode    = null;
    String strmsg          = "";
    String strCurrentDate  = "";
    String sortby          = "";
    String sortfield       = "";
    String strVersionLang  = ImageConfUtil.getVersionLang();
    String strAdFlag       = ImageConfUtil.getLoginAD();

    if( strVersionLang.equals("thai") ) {
        strCurrentDate = getServerDateThai();
    }else{
        strCurrentDate = getServerDateEng();
    }
	
	if( strMode == null ){
        strMode = "SEARCH";
    }

    if( strMode.equals( "pInsert" ) ) {
		screenLabel = lb_add;		
    }else if( strMode.equals( "pEdit" ) ) {
    	screenLabel = lb_edit;
        
        con.addData( "USER_ID", "String", strUserIdKey);
        bolnSuccess = con.executeService( strContainerName, strClassName, "selectUserProfileById" );
        
        if( bolnSuccess ) {
            strUserIdData        = strUserIdKey;
            strUserPassData      = "********";
            strTitleData         = con.getHeader( "USER_TITLE" );
            strUserNameData      = con.getHeader( "USER_NAME" );
            strUserSnameData     = con.getHeader( "USER_SNAME" );
            strUserLevelData     = con.getHeader( "USER_LEVEL" );
            strUserLevelNameData = con.getHeader( "LEVEL_NAME" );
            strUserOrgData       = con.getHeader( "USER_ORG" );
            strUserOrgNameData   = con.getHeader( "ORG_NAME" );
            strUserEmailData     = con.getHeader( "USER_EMAIL" );
            strUserPositionData  = con.getHeader( "USER_POSITION" );
            strUserAddressData   = con.getHeader( "IP_ADDRESS" );
            strUserEntryData     = con.getHeader( "ENTRY_DATE" );
            strUserStatusData    = con.getHeader( "USER_STATUS" );
            strDateChangeData    = con.getHeader( "CHANGE_DATE" );
            strSecFlag           = con.getHeader( "SECURITY_FLAG" );

            con1.addData( "USER_ID", "String", strUserIdKey);
            con1.addData( "USER_ROLE", "String", "00000001");
            con1.addData( "PROJECT_CODE", "String", "ADMIN");
            bolnSuccess1 = con1.executeService( strContainerName, strClassName, "countProjectUserAdmin" );
            if( bolnSuccess1 ) {
            	strIsAdminData = "true";
            }else {
            	strIsAdminData = "false";
            }
            
            con1.addData( "USER_ID", "String", strUserIdKey);
            if( strSecFlag.equals("G") ) {
            	bolnGroup = con1.executeService( strContainerName, strClassName, "selectUserGroupName" );
            	if( bolnGroup ) {
            		strUserGroupName = con1.getHeader( "GROUP_NAME" );
            	}
            }else {
            	strUserGroupName = " - ";
            }
        }        
    }

    if(strMode.equals("ADD")){
        con.addData( "USER_ID",      "String", strUserIdData);
        con.addData( "IS_ADMIN",     "String", strIsAdminData);
        con.addData( "USER_TITLE",   "String", strTitleData);
        con.addData( "USER_NAME",    "String", strUserNameData);
        con.addData( "USER_SNAME",   "String", strUserSnameData);
        con.addData( "USER_LEVEL",   "String", strUserLevelData);
        con.addData( "USER_ORG",     "String", strUserOrgData);
        con.addData( "USER_EMAIL",   "String", strUserEmailData);
        if( !strUserAddressData.equals("") ) {
        	con.addData( "IP_ADDRESS", "String", strUserAddressData);
        }
        con.addData( "USER_POSITION","String", strUserPositionData);
        con.addData( "ENTRY_DATE",   "String", strCurrentDate);
        con.addData( "USER_STATUS",  "String", "A");
        con.addData( "CHANGE_DATE",  "String", strCurrentDate);
        // INSERT_USER_PROFILE_LOG
    	con.addData( "ACTION_FLAG",  "String", "A" );
    	con.addData( "ACTION_DATE",  "String", strCurrentDate );
        con.addData( "ADD_USER",     "String", strUserId);
        con.addData( "ADD_DATE",     "String", strCurrentDate);
        con.addData( "UPD_USER",     "String", strUserId);
        
        con.addData( "DESC",              "String", "[" + strUserIdData + "][A] " + strUserNameData + " " + strUserSnameData );
     	con.addData( "ADMIN_USER_ID",  	  "String", strUserId );
        con.addData( "ADMIN_ACTION_FLAG", "String", "AU" );
        con.addData( "CURRENT_DATE", 	  "String", strCurrentDate);

        bolnSuccess = con.executeService( strContainerName , strClassName , "insertUserProfile" );

        if( !bolnSuccess ){
            strErrorCode    = con.getRemoteErrorCode();
            if(strErrorCode.equals("ERR00002")){
                strmsg="showMsg(0,0,\" " + lc_user_profile_dup + "\")";
                strMode = "pInsert";
            }else{
                strmsg="showMsg(0,0,\" " + lc_can_not_insert_user_profile + "\")";
                strMode = "pInsert";
            }
        }else{
            strmsg="showMsg(0,0,\" " +  lc_insert_user_profile_successfull + "\")";
            strMode = "MAIN";
		}
	}else if(strMode.equals("EDIT")){
    	//con.addData( "USER_ID",      "String", strUserIdData.toUpperCase());
        //con.addData( "PASSWORD",     "String", strUserPassData);
        con.addData( "USER_ID",      "String", strUserIdData);
        con.addData( "CHK_PASS",     "String", strhidChkPassData);
        con.addData( "IS_ADMIN",     "String", strIsAdminData);
        con.addData( "USER_TITLE",   "String", strTitleData);
        con.addData( "USER_NAME",    "String", strUserNameData);
        con.addData( "USER_SNAME",   "String", strUserSnameData);
        con.addData( "USER_LEVEL",   "String", strUserLevelData);
        con.addData( "USER_ORG",     "String", strUserOrgData);
        con.addData( "USER_EMAIL",   "String", strUserEmailData);
        con.addData( "USER_POSITION","String", strUserPositionData);
        con.addData( "IP_ADDRESS", "String", strUserAddressData);
        con.addData( "USER_STATUS",  "String", strUserStatusData);
        con.addData( "CHANGE_DATE",  "String", strCurrentDate);
     	con.addData( "ACTION_FLAG",  "String", strUserStatusData );
     	con.addData( "ACTION_DATE",  "String", strCurrentDate );
        con.addData( "EDIT_USER",    "String", strUserId);
        con.addData( "EDIT_DATE",    "String", strCurrentDate);
        con.addData( "ADD_USER",     "String", strUserId);
        con.addData( "ADD_DATE",     "String", strCurrentDate);
        con.addData( "UPD_USER",     "String", strUserId);
        
        con.addData( "DESC",  		  "String", "[" + strUserIdData + "][" + strUserStatusData + "] " + strUserNameData + " " + strUserSnameData );
     	con.addData( "ADMIN_USER_ID",  	  "String", strUserId );
        con.addData( "ADMIN_ACTION_FLAG", "String", "EU" );
        con.addData( "CURRENT_DATE", 	  "String", strCurrentDate);

        bolnSuccess = con.executeService( strContainerName , strClassName , "updateUserProfile"  );

        if( !bolnSuccess ){
            strErrorCode = con.getRemoteErrorCode();
            strmsg="showMsg(0,0,\" " + lc_can_not_update_data  + "\")";
            strMode = "pEdit";
        }else{
            strmsg="showMsg(0,0,\" " + lc_edit_user_profile_successfull + "\")";
            strMode = "MAIN";
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
var adFlag   = "<%=strAdFlag %>";

function window_onload() {
	var blnIsAdminData = "<%=strIsAdminData %>";
	
    lb_user_id.innerHTML           = lbl_user_profile1;
    lb_user_profile_ext1.innerHTML = lbl_user_profile_ext1;
    lb_user_password.innerHTML     = lbl_about_password;
    lb_user_title.innerHTML        = lbl_user_profile2_3;
    lb_user_name.innerHTML         = lbl_user_profile2_4;
    lb_user_sname.innerHTML        = lbl_user_profile2_5;
    lb_user_level.innerHTML        = lbl_user_profile2_6;
    lb_user_org.innerHTML          = lbl_user_profile2_7;
    lb_user_email.innerHTML        = lbl_user_email;
    lb_user_position.innerHTML     = lbl_user_profile2_9;
    lb_user_address.innerHTML      = lbl_user_address;
    lb_user_entry.innerHTML        = lbl_user_profile2_10;
    lb_user_status.innerHTML       = lbl_user_profile5;
    lb_date_change.innerHTML       = lbl_user_profile2_12;
    lb_user_profile6.innerHTML     = lbl_user_profile6;
    lb_group_name.innerHTML        = lbl_group_name;
    
    if( mode == "MAIN" ) {
        form1.action     = "user_profile1.jsp";
        form1.target     = "_self";
        form1.CURRENT_PAGE.value = form1.current_page_parent.value;
        form1.sortfield.value    = form1.sortfield_parent.value;
        form1.sortby.value       = form1.sortby_parent.value;
        form1.MODE.value         = form1.mode_parent.value;
        form1.submit();
    }else if( mode == "pEdit" ) {
    	if( blnIsAdminData == "true" ) {
            obj_chkIsAdmin.checked = true;
    	}else {
            obj_chkIsAdmin.checked = false;
    	}
        obj_txtUserId.value       = "<%=strUserIdData %>";
        obj_txtUserId.readOnly    = true;
    	obj_txtUserId.className   = "input_box_disable";
        obj_txtUserPass.readOnly  = true;
    	obj_txtUserPass.className = "input_box_disable";
    	obj_txtUserPass.value     = "<%=strUserPassData %>";
    	obj_optUserTitle.value    = "<%=strTitleData %>";
    	obj_hidTitle.value        = "<%=strTitleData %>";
    	obj_txtUserName.value     = "<%=strUserNameData %>";
    	obj_txtUserSname.value    = "<%=strUserSnameData %>";
    	obj_txtUserLevel.value    = "<%=strUserLevelData %>";
    	obj_txtLevelName.value    = "<%=strUserLevelNameData %>";
    	obj_txtOrgCode.value      = "<%=strUserOrgData %>";
    	obj_txtOrgName.value      = "<%=strUserOrgNameData %>";
    	obj_txtUserEmail.value    = "<%=strUserEmailData %>";
    	obj_txtUserPosition.value = "<%=strUserPositionData %>";
    	obj_txtUserAddress.value  = "<%=strUserAddressData %>";
    	obj_txtUserEntry.value    = dateToScreen("<%=strUserEntryData %>");
    	obj_optUserStatus.value   = "<%=strUserStatusData %>";
    	obj_hidUserStatus.value   = "<%=strUserStatusData %>";
    	obj_txtDateChange.value   = dateToScreen("<%=strDateChangeData %>");
    	obj_txtGroupStatus.value  = "<%=strSecFlag %>";
    	obj_txtGroupName.value    = "<%=strUserGroupName %>";
    	//displayAdTypeOn();
    }else {
    	if( adFlag == "on" ) {
            obj_bttSave.style.display  = "none";
    	}
    	obj_newpw.style.display    = "none";
    	obj_optUserStatus.value    = "A";
    	obj_optUserStatus.disabled = true;
		obj_txtUserPass.readOnly   = true;
    	obj_txtUserPass.className  = "input_box_disable";
    	//displayAdTypeOn();
    }
    obj_txtUserId.focus();
}

function displayAdTypeOn() {
	if( adFlag == "on" ) {
		obj_txtUserName.className  = "input_box_disable";
		obj_txtUserName.readOnly   = true;
		obj_txtUserSname.className = "input_box_disable";
		obj_txtUserSname.readOnly  = true;
		//obj_txtUserEmail.className = "input_box_disable";
		//obj_txtUserEmail.readOnly  = true;
		//obj_iZoomOrg.style.display = "none";
	}
}

function afterAuthenPass() {
	obj_txtUserId.className    = "input_box_disable";
	obj_txtUserId.readOnly     = true;
	obj_txtUserName.className  = "input_box";
	obj_txtUserName.readOnly   = false;
	obj_txtUserSname.className = "input_box";
	obj_txtUserSname.readOnly  = false;
	obj_bttSave.style.display  = "inline";
	obj_txtUserName.focus();
}

function dupPassword() {
	if( mode == "pInsert" ) {
		obj_txtUserPass.value = obj_txtUserId.value;
	}
}

function findUserDetailAd( objField ) {
	if( adFlag == "on" ) {
		if( sccUtils.isEnter() ){
			//window.event.keyCode = 0;
			formDetailAd.USER_ID_AD.value = form1.txtUserId.value;
			formDetailAd.MODE.value       = "SEARCH";
			formDetailAd.target           = "frameDetailAd";
			formDetailAd.action           = "frame_detail_ad.jsp";
			formDetailAd.submit();
		}
	}
}

function openZoom( strZoomType ) {
	var strPopArgument   = "scrollbars=yes,status=no";
	var strWidth         = ",width=370px";
	var strHeight        = ",height=420px";
	var strUrl           = "";
	var strConcatField   = "";

	strPopArgument += strWidth + strHeight;

	switch( strZoomType ){
		case "level" :
				strUrl = "inc/zoom_data_table_level1.jsp";
				strConcatField = "TABLE=USER_LEVEL" + "&TABLE_LABEL=" + lbl_user_profile2_6;
				strConcatField += "&RESULT_FIELD=txtUserLevel,txtLevelName";
				break;
		case "org" :
				strUrl = "inc/zoom_data_table_level1.jsp";
				strConcatField = "TABLE=ORG" + "&TABLE_LABEL=" + lbl_user_profile2_7;
				strConcatField += "&RESULT_FIELD=txtOrgCode,txtOrgName";
				break;
	}

	objZoomWindow = window.open( strUrl + "?" + strConcatField, strZoomType, strPopArgument );
	objZoomWindow.focus();
}

function getValueStatus() {
	var objUserStatus = document.getElementById("optUserStatus");
	var statusIndex   = objUserStatus.selectedIndex;
	var statusValue   = objUserStatus.value;
	
	if( statusIndex == 0 ) {
		obj_hidUserStatus.value = "";
	}else {
		obj_hidUserStatus.value = statusValue;
	}
}

function getValueTitle() {
	var objUserTitle = document.getElementById("optUserTitle");
	var statusIndex  = objUserTitle.selectedIndex;
	var statusValue  = objUserTitle.value;
	
	if( statusIndex == 0 ) {
		obj_hidTitle.value = "";
	}else {
		obj_hidTitle.value = statusValue;
	}
}

function buttonClick( lv_strMethod ){
    switch( lv_strMethod ){
		case "save" :
		    if( verify_form() ){
		    	if( verify_email() ) {
			        if(form1.MODE.value == "pInsert"){
			            form1.MODE.value = "ADD" ;
			        }else{
			            form1.MODE.value = "EDIT" ;
			        }
					form1.submit();
				}
			}
			break;
		case "cancel" :
			form1.action     = "user_profile1.jsp";
			form1.target 	 = "_self";
		    //form1.MODE.value = "SEARCH";
		    form1.CURRENT_PAGE.value = form1.current_page_parent.value;
			form1.sortfield.value    = form1.sortfield_parent.value;
			form1.sortby.value       = form1.sortby_parent.value;
		    form1.MODE.value         = form1.mode_parent.value;
		    form1.submit();
			break;
		case "newpw" :
			if( obj_txtUserId.value != "" ) {
				alert( lc_confirm_change_pass );
				obj_txtUserPass.value = obj_txtUserId.value;
				obj_hidChkPass.value  = "Y";
				break;
			}else {
				alert( lc_check_user_before_click );
				break;
			}
	}
}

function verify_form() {	
	if( obj_txtUserId.value.length == 0 ) {
	        alert( lc_check_user );
	        obj_txtUserId.focus();
	        return false;
	}
/*	
	if( mode == "pInsert" ) {
		if( obj_txtUserPass.value.length == 0 ) {
		        alert( lc_check_password );
		        obj_txtUserPass.focus();
		        return false;
		}
	}
*/	
	if( obj_hidTitle.value.length == 0 ) {
	        alert( lc_check_title );
	        obj_optUserTitle.focus();
	        return false;
	}
	
	if( obj_txtUserName.value.length == 0 ) {
	        alert( lc_check_user_name );
	        obj_txtUserName.focus();
	        return false;
	}
	
	if( obj_txtUserSname.value.length == 0 ) {
	        alert( lc_check_user_sname );
	        obj_txtUserSname.focus();
	        return false;
	}
	
	if( obj_txtUserLevel.value.length == 0 ) {
	        alert( lc_check_level_name );
	        //form1.txtTableLevel1.focus();
	        return false;
	}
	
	if( obj_txtOrgCode.value.length == 0 ) {
	        alert( lc_check_org_name );
	        //obj_txtOrgCode.focus();
	        return false;
	}
	
	if( obj_txtUserEmail.value.length == 0 ) {
	        alert( lc_check_email_address );
	        obj_txtUserEmail.focus();
	        return false;
	}
	
	if( mode == "pEdit" ) {
		if( obj_hidUserStatus.value.length == 0 ) {
		        alert( lc_check_status );
		        obj_optUserStatus.focus();
		        return false;
		}
	}
	
	if( obj_chkIsAdmin.checked ) {
		obj_hidIsAdmin.value = "Y";
	}else {
		obj_hidIsAdmin.value = "N";
	}
	
	return true;
}

function verify_email() {
    var email_format = /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i;
    var email_addr   = obj_txtUserEmail.value;

    email_addr             = sccUtils.trim(email_addr);
    obj_txtUserEmail.value = email_addr;

    if (email_addr.search(email_format) == -1) {
        alert( lc_check_email_address );
        obj_txtUserEmail.focus();
        return false;
    }
    return true;
}

function chkNumber() {
    var number  = ["49","50","51","52","53","54","55","56","57","48","44","46"];
    var flag    = "false";
    var carCode = event.keyCode;
    
    for( var i=0; i<number.length; i++ ) {
	    if( carCode == number[i] ){
	    	flag = "true";
	    }
	}
	if( flag == "false" ) {
        if( event.preventDefault ){
            event.preventDefault();
        }else{
            event.returnValue = false;
        }
        return;
	}
}

//-->
</script>
<link href="css/edas.css" type="text/css" rel="stylesheet">
</head>
<body onLoad="MM_preloadImages('images/btt_save2_over.gif','images/btt_cancel_over.gif','images/btt_newpw_over.gif');window_onload();">
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
            		<table width="482" border="0" cellspacing="0" cellpadding="0">
		                <tr>
		                  	<td height="25" colspan="4">&nbsp;</td>
		                </tr>
		                <tr>
		                  	<td width="89" height="25" class="label_bold2"><span id="lb_user_id"></span>&nbsp;
		                  		<img src="images/mark.gif" width="12" height="11">
		                  	</td>
		                  	<td height="25" colspan="3">
	                      		<input type="text" id="txtUserId" name="txtUserId" class="input_box" size="20" maxlength="30" onblur="dupPassword();" onkeypress="findUserDetailAd( this );">&nbsp;
		                  		<input type="checkbox" id="chkIsAdmin" name="chkIsAdmin" >&nbsp;<span id="lb_user_profile_ext1" class="label_bold2"></span>
		                  	</td>
	                	</tr>
		                <tr>
		                  	<td width="89" height="25" class="label_bold2"><span id="lb_user_password"></span>&nbsp;
		                  		<img src="images/mark.gif" width="12" height="11">
		                  	</td>
		                  	<td height="25" colspan="3">
	                      		<input  type="password" id="txtUserPass" name="txtUserPass" class="input_box" size="20" maxlength="30" disabled>
				           		<a href="#" onclick= "buttonClick('newpw')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('newpw','','images/btt_newpw_over.gif',1)">
				           			<img src="images/btt_newpw.gif" id="newpw" name="newpw" width="102" height="22" border="0">&nbsp;</a>
		                  	</td>
	                	</tr>
<%
		String strTagTitleOption = "";
		String strZoomTitle      = "";
		String strZoomTitleName  = "";
		strTagTitleOption = "\n<select id=\"optUserTitle\" name=\"optUserTitle\" class=\"combobox\" onchange=\"getValueTitle();\">";
		strTagTitleOption += "\n<option value=\"\"></option>";
		
		bolnZoomSuccess = con1.executeService( strContainerName, strClassName, "findTitleCombo" );
		
		if( bolnZoomSuccess ){
			while( con1.nextRecordElement() ){
				strZoomTitle     = con1.getColumn( "TITLE" );
				strZoomTitleName = con1.getColumn( "TITLE_NAME" );
		
				strTagTitleOption += "\n<option value=\"" + strZoomTitle + "\">" + strZoomTitleName + "</option>";
			}
		}
		
		strTagTitleOption += "\n</select>";
%>
	                	<tr>
		                  	<td height="25" class="label_bold2"><span id="lb_user_title"></span>&nbsp;
		                  		<img src="images/mark.gif" width="12" height="11">
		                  	</td>
		                  	<td height="25" colspan="3"><%=strTagTitleOption %>
		                  		<input id="hidTitle" name="hidTitle" type="hidden" >
	                  		</td>
	                	</tr>
	                	<tr>
		                  	<td height="25" class="label_bold2"><span id="lb_user_name"></span>&nbsp;
		                  		<img src="images/mark.gif" width="12" height="11">
		                  	</td>
		                  	<td height="25" colspan="3">
		                  		<input id="txtUserName" name="txtUserName" type="text" class="input_box" size="50" maxlength="70">
	                  		</td>
	                	</tr>
	                	<tr>
		                  	<td height="25" class="label_bold2"><span id="lb_user_sname"></span>&nbsp;
		                  		<img src="images/mark.gif" width="12" height="11">
		                  	</td>
		                  	<td height="25" colspan="3">
		                  		<input id="txtUserSname" name="txtUserSname" type="text" class="input_box" size="50" maxlength="70">
	                  		</td>
	                	</tr>
	                	<tr>
		                  	<td height="25" class="label_bold2"><span id="lb_user_level"></span>&nbsp;
		                  		<img src="images/mark.gif" width="12" height="11">
		                  	</td>
		                  	<td height="25" colspan="3">
		                  		<div style="float: left">
		                  			<input id="txtUserLevel" name="txtUserLevel" type="text" class="input_box_disable" size="2" maxlength="2" readonly>
		                  			&nbsp;<a href="javascript:openZoom('level');"><img id="iZoomLevel" src="images/search.gif" width="16" height="16" border="0" ></a>
	                  				&nbsp;<input id="txtLevelName" name="txtLevelName" type="text" class="input_box_disable" size="40" maxlength="50" readonly >
	                  			</div>
	                  		</td>
	                	</tr>
	                	<tr>
		                  	<td height="25" class="label_bold2"><span id="lb_user_org"></span>&nbsp;
		                  		<img src="images/mark.gif" width="12" height="11">
		                  	</td>
		                  	<td width="67" height="25">
		                  		<input id="txtOrgCode" name="txtOrgCode" type="text" class="input_box_disable" size="8" maxlength="10" readonly>
	                  		</td>
		                  	<td width="20" height="25" colspan="-1" align="center">
		                  		<a href="javascript:openZoom('org');"><img id="iZoomOrg" src="images/search.gif" width="16" height="16" border="0"></a>
	                  		</td>
		                  	<td>
		                  		<input id="txtOrgName" name="txtOrgName" type="text" class="input_box_disable" size="32" maxlength="50" readonly>
	                  		</td>
	                	</tr>
	                	<tr>
		                  	<td height="25" class="label_bold2"><span id="lb_user_profile6"></span></td>
		                  	<td height="25" colspan="3">
		                  		<input id="txtGroupStatus" name="txtGroupStatus" type="text" class="input_box_disable" size="3" maxlength="1" readOnly>
	                  		</td>
	                	</tr>
	                	<tr>
		                  	<td height="25" class="label_bold2"><span id="lb_group_name"></span></td>
		                  	<td height="25" colspan="3">
		                  		<input id="txtGroupName" name="txtGroupName" type="text" class="input_box_disable" size="25" readOnly>
	                  		</td>
	                	</tr>
	                	<tr>
		                  	<td height="25" class="label_bold2"><span id="lb_user_email"></span>&nbsp;
		                  		<img src="images/mark.gif" width="12" height="11">
		                  	</td>
		                  	<td height="25" colspan="3">
		                  		<input id="txtUserEmail" name="txtUserEmail" type="text" class="input_box" size="30" maxlength="40">
	                  		</td>
	                	</tr>
	                	<tr>
		                  	<td height="25" class="label_bold2"><span id="lb_user_position"></span></td>
		                  	<td height="25" colspan="3">
		                  		<input id="txtUserPosition" name="txtUserPosition" type="text" class="input_box" size="40" maxlength="50">
	                  		</td>
	                	</tr>
	                	<tr>
		                  	<td height="25" class="label_bold2"><span id="lb_user_address"></span></td>
		                  	<td height="25" colspan="3">
		                  		<input id="txtUserAddress" name="txtUserAddress" type="text" class="input_box" size="40" onkeypress="chkNumber();">
	                  		</td>
	                	</tr>
	                	<tr>
		                  	<td height="25" class="label_bold2"><span id="lb_user_entry"></span></td>
		                  	<td height="25" colspan="3">
		                  		<input id="txtUserEntry" name="txtUserEntry" type="text" class="input_box_disable" size="10" maxlength="10" readOnly>
	                  		</td>
	                	</tr>
<%
		String strTagStatusOption = "";
		String strZoomUserStatus  = "";
		String strZoomStatusName  = "";
		strTagStatusOption = "\n<select id=\"optUserStatus\" name=\"optUserStatus\" class=\"combobox\" onchange=\"getValueStatus();\">";
		strTagStatusOption += "\n<option value=\"\"></option>";
		
		bolnZoomSuccess = con1.executeService( strContainerName, strClassName, "findUserStatusCombo" );
		
		if( bolnZoomSuccess ){
			while( con1.nextRecordElement() ){
				strZoomUserStatus = con1.getColumn( "USER_STATUS" );
				strZoomStatusName = con1.getColumn( "USER_STATUS_NAME" );
		
				strTagStatusOption += "\n<option value=\"" + strZoomUserStatus + "\">" + strZoomStatusName + "</option>";
			}
		}
		
		strTagStatusOption += "\n</select>";
%>
	                	<tr>
		                  	<td height="25" class="label_bold2"><span id="lb_user_status"></span>&nbsp;
		                  		<img src="images/mark.gif" width="12" height="11">
		                  	</td>
		                  	<td height="25" colspan="3"><%=strTagStatusOption %>
		                  		<input id="hidUserStatus" name="hidUserStatus" type="hidden" >
	                  		</td>
	                	</tr>
	                	<tr>
		                  	<td height="25" class="label_bold2"><span id="lb_date_change"></span></td>
		                  	<td height="25" colspan="3">
		                  		<input id="txtDateChange" name="txtDateChange" type="text" class="input_box_disable" size="10" maxlength="10" readonly>
	                  		</td>
	                	</tr>
	                	<tr>
	                  		<td height="25" colspan="4">&nbsp;</td>
	                  	</tr>
			            <tr>
				           	<td align="center" colspan="4">
				           		<a href="#" onclick= "buttonClick('save')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('save','','images/btt_save2_over.gif',1)">
				           			<img src="images/btt_save2.gif" id="save" name="save" width="67" height="22" border="0"></a>&nbsp;
				           		<a href="#" onclick= "buttonClick('cancel')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('cancel','','images/btt_cancel_over.gif',1)">
				           			<img src="images/btt_cancel.gif" id="cancel" name="cancel" width="67" height="22" border="0"></a>
				           	</td>
			            </tr>
              		</table>
            	</td>
            </tr>
        </table>
        <input type="hidden" id="MODE"        name="MODE"        value="<%=strMode%>">
        <input type="hidden" id="screenname"  name="screenname"  value="<%=screenname%>">
        <input type="hidden" id="screenLabel" name="screenLabel" value="<%=screenLabel%>">
        <input type="hidden" id="hidIsAdmin"  name="hidIsAdmin"  value="">
        <input type="hidden" id="hidChkPass"  name="hidChkPass"  value="">
		<input type="hidden" name="sortby"    value="<%=sortby%>">
		<input type="hidden" name="sortfield" value="<%=sortfield%>">

		<input type="hidden" id="mode_parent"         name="mode_parent"         value="<%=mode_parent%>">
		<input type="hidden" id="CURRENT_PAGE"        name="CURRENT_PAGE"        value="">
		<input type="hidden" id="current_page_parent" name="current_page_parent" value="<%=current_page_parent%>">
		<input type="hidden" id="sortby_parent"       name="sortby_parent"       value="<%=sortby_parent%>">
		<input type="hidden" id="sortfield_parent"    name="sortfield_parent"    value="<%=sortfield_parent%>">

		<input type="hidden" id="USER_ID_SEARCH"     name="USER_ID_SEARCH"     value="<%=strFieldUserIdSearch %>">
		<input type="hidden" id="USER_NAME_SEARCH"   name="USER_NAME_SEARCH"   value="<%=strFieldUserNameSearch %>">
		<input type="hidden" id="USER_SNAME_SEARCH"  name="USER_SNAME_SEARCH"  value="<%=strFieldUserSnameSearch %>">
		<input type="hidden" id="USER_LEVEL_SEARCH"  name="USER_LEVEL_SEARCH"  value="<%=strFieldUserLevelSearch %>">
		<input type="hidden" id="ORG_CODE_SEARCH"    name="ORG_CODE_SEARCH"    value="<%=strFieldOrgCodeSearch %>">
		<input type="hidden" id="USER_STATUS_SEARCH" name="USER_STATUS_SEARCH" value="<%=strFieldUserStatusSearch %>">
        <p>&nbsp;</p>
      </td>
    </tr>
</table>
<iframe name="frameDetailAd" style="display:none;"></iframe>
</form>

<form name="formDetailAd" method="post" action="">
<input type="hidden" name="MODE"        value="">
<input type="hidden" name="USER_ID_AD"  value="">
<input type="hidden" name="PASSWORD_AD" value="">
</form>

</body>
</html>
<script language="JavaScript" type="text/javascript">
<!--

var obj_txtUserId       = document.getElementById("txtUserId");
var obj_chkIsAdmin      = document.getElementById("chkIsAdmin");
var obj_hidIsAdmin      = document.getElementById("hidIsAdmin");
var obj_txtUserPass     = document.getElementById("txtUserPass");
var obj_newpw           = document.getElementById("newpw");
var obj_txtUserPass     = document.getElementById("txtUserPass");
var obj_optUserTitle    = document.getElementById("optUserTitle");
var obj_hidTitle        = document.getElementById("hidTitle");
var obj_txtUserName     = document.getElementById("txtUserName");
var obj_txtUserSname    = document.getElementById("txtUserSname");
var obj_txtUserLevel    = document.getElementById("txtUserLevel");
var obj_txtLevelName    = document.getElementById("txtLevelName");
var obj_txtOrgCode      = document.getElementById("txtOrgCode");
var obj_txtOrgName      = document.getElementById("txtOrgName");
var obj_txtUserEmail    = document.getElementById("txtUserEmail");
var obj_txtUserPosition = document.getElementById("txtUserPosition");
var obj_txtUserAddress  = document.getElementById("txtUserAddress");
var obj_txtUserEntry    = document.getElementById("txtUserEntry");
var obj_optUserStatus   = document.getElementById("optUserStatus");
var obj_hidUserStatus   = document.getElementById("hidUserStatus");
var obj_txtDateChange   = document.getElementById("txtDateChange");
var obj_hidChkPass      = document.getElementById("hidChkPass");
var obj_iZoomOrg        = document.getElementById("iZoomOrg");
var obj_iZoomLevel      = document.getElementById("iZoomLevel");
var obj_bttSave         = document.getElementById("save");
var obj_txtGroupStatus  = document.getElementById("txtGroupStatus");
var obj_txtGroupName    = document.getElementById("txtGroupName");

//-->
</script>
<%  if (!strmsg.equals("")) {  %>
<script language="javaScript">
    <%=strmsg%>
</script>
<%  }   %>