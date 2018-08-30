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

    UserInfo userInfo = (UserInfo)session.getAttribute( "USER_INFO" );
    String  strUserId = userInfo.getUserId();
    
    String strClassName = "PROJECT_MANAGER";
    String screenname   = getField(request.getParameter("screenname"));
    String screenLabel  = getField(request.getParameter("screenLabel"));
    String strMode      = getField(request.getParameter("MODE"));
    String strOldMode   = getField(request.getParameter("OLD_MODE"));
    
    String strProjectCodeKey = getField(request.getParameter("PROJECT_CODE_KEY"));
    String strProjectFlagKey = getField(request.getParameter("PROJECT_FLAG_KEY"));
    
    String  strProjectNameSearch  = getField(request.getParameter( "PROJECT_NAME_SEARCH" ));
    String  strProjectOwnerSearch = getField(request.getParameter( "PROJECT_OWNER_SEARCH" ));
    String  strDocTypeSearch      = getField(request.getParameter( "DOC_TYPE_SEARCH" ));

    String strProjectNameData      = getField(request.getParameter("txtProjectName"));
    String strProjectOwnerData     = getField(request.getParameter("txtProjectOwner"));
    String strProjectCopyData      = getField(request.getParameter("txtProjectCopy"));
    String strProjectFlagData      = getField(request.getParameter("hidProjectFlag"));
    String strProjectOwnerNameData = getField(request.getParameter("txtProjectOwnerName"));
    String strProjectUserData      = getField(request.getParameter("txtProjectUser"));
    String strUserNameData         = getField(request.getParameter("txtProjectUserName"));
    String strTotalSizeData        = getField(request.getParameter("txtTotalSize"));
    String strUsedSizeData         = getField(request.getParameter("txtUsedSize"));
    String strAvailSizeData        = getField(request.getParameter("txtAvailSize"));
    String strPercentData          = getField(request.getParameter("txtPercent"));
    String strTotalRecordData      = getField(request.getParameter("txtTotalRecord"));
    String strTotalFileData        = getField(request.getParameter("txtTotalFile"));
    
    String strProjectCopyNameData = "";
    
    String strCurrentPage    = request.getParameter( "CURRENT_PAGE" );
	String strPageSize       = request.getParameter( "PAGE_SIZE" );

	boolean bolnSuccess     = true;
    boolean bolnSuccess1    = true;
	String  strErrorCode    = null;
	//String  strErrorMessage = null;    
    String  strmsg          = "";
	String	strCurrentDate  = "";
	String  nextProjManager = "";
        String strVersionLang  = ImageConfUtil.getVersionLang();

        if( strVersionLang.equals("thai") ) {
            strCurrentDate = getServerDateThai();
        }else{
            strCurrentDate = getServerDateEng();
        }
	
	if( strMode == null ){
        strMode = "SEARCH";
    }

    if( strMode.equals( "pInsert" ) ) {
		screenLabel = lb_add_project_code;		
    }else if( strMode.equals( "pEdit" ) ) {
    	screenLabel = lb_edit_project_code;
        
    	if( strProjectFlagKey.equals("2") || strProjectFlagKey.equals("4") ) {
            con.addData( "PROJECT_CODE", "String", strProjectCodeKey );
            bolnSuccess = con.executeService( strContainerName , strClassName , "selectProjectManagerByPublic" );
    	}else {
    		con.addData( "PROJECT_CODE", "String", strProjectCodeKey );
            bolnSuccess = con.executeService( strContainerName , strClassName , "selectProjectManagerByPrivate" );
    	}
        
        if( bolnSuccess ) {
            strProjectNameData      = con.getHeader( "PROJECT_NAME" );
            strProjectOwnerData     = con.getHeader( "PROJECT_OWNER" );
            strProjectOwnerNameData = con.getHeader( "PROJECT_OWNER_NAME" );
            strProjectFlagData      = con.getHeader( "PROJECT_FLAG" );
            strProjectUserData      = con.getHeader( "PROJECT_USER" );
            strUserNameData         = con.getHeader( "USER_NAME" );
            strTotalSizeData        = con.getHeader( "TOTAL_SIZE" );
            strUsedSizeData         = con.getHeader( "USED_SIZE" );
            strAvailSizeData        = con.getHeader( "AVAIL_SIZE" );
            strPercentData          = con.getHeader( "PERCENT" );
            strTotalRecordData      = con.getHeader( "TOTAL_RECORD" );
            strTotalFileData        = con.getHeader( "TOTAL_FILE" );
            strProjectCopyData      = con.getHeader( "PROJECT_COPY" );
            
            if(!strProjectCopyData.equals("")){
            	con1.addData( "PROJECT_COPY", "String", strProjectCopyData );
            	bolnSuccess1 = con1.executeService( strContainerName , strClassName , "selectProjectManagerById" );
            	if(bolnSuccess1){
            		strProjectCopyNameData = con1.getHeader("PROJECT_NAME");
            	}
            }
        }        
    }

    if(strMode.equals("ADD")){
    	bolnSuccess1 = con1.executeService( strContainerName , strClassName , "findMaxProjectManager" );
        if( bolnSuccess1 ) {
        	nextProjManager = con1.getHeader("MAX");
        	if( nextProjManager == null || nextProjManager.equals("") ) {
        		nextProjManager = "00000001";
        	}else {
        		nextProjManager = "0000000" + nextProjManager;
        	}
        	nextProjManager = nextProjManager.substring( nextProjManager.length()-8, nextProjManager.length() );
        }
        strTotalSizeData   = String.valueOf( (Double.parseDouble(strTotalSizeData)*1000000000) );
        strProjectNameData = strProjectNameData.replaceAll( "'", "&acute;" );
        strProjectNameData = strProjectNameData.replaceAll( "\"", "&quot;" );
        
        con.addData( "PROJECT_CODE",  "String", nextProjManager);
        con.addData( "PROJECT_NAME",  "String", strProjectNameData);
        con.addData( "PROJECT_OWNER", "String", strProjectOwnerData);
        con.addData( "PROJECT_FLAG",  "String", strProjectFlagData);
        con.addData( "PROJECT_USER",  "String", strProjectUserData);
        con.addData( "PROJECT_COPY",  "String", strProjectCopyData);
        con.addData( "TOTAL_SIZE",    "String", strTotalSizeData);
        con.addData( "AVIAIL_SIZE",   "String", strTotalSizeData);
        
        con.addData( "USER_ROLE",          "String", "00000002");
        con.addData( "DOCUMENT_TYPE",      "String", "001");
        con.addData( "DOCUMENT_TYPE_NAME", "String", lc_attachment);
        con.addData( "ADD_USER",      "String", strUserId);
        con.addData( "ADD_DATE",      "String", strCurrentDate);
        con.addData( "UPD_USER",      "String", strUserId);
        
        con.addData( "DESC",  		 "String", nextProjManager + "-" + strProjectNameData );
        con.addData( "USER_ID",  	 "String", strUserId );
        con.addData( "ACTION_FLAG",  "String", "CP" );
        con.addData( "CURRENT_DATE", "String", strCurrentDate);
        
        bolnSuccess = con.executeService( strContainerName , strClassName , "insertProjectManager" );
        if( !bolnSuccess ){
            strErrorCode    = con.getRemoteErrorCode();
            if(strErrorCode.equals("ERR00002")){
                strmsg="showMsg(0,0,\" " + lc_system_table_dup + "\")";
                strMode = "pInsert";
            }else{
                strmsg="showMsg(0,0,\" " + lc_can_not_insert_project_manager + "\")";
                strMode = "pInsert";
            }
        }else{
            strmsg  = "showMsg(0,0,\" " +  lc_insert_project_manager_successfull + "\")";
            strMode = "MAIN";
		}
	}else if(strMode.equals("EDIT")){
		strAvailSizeData   = String.valueOf( (Double.parseDouble(strTotalSizeData)*1000000000) - (Double.parseDouble(strUsedSizeData)*1000000000) );
		strTotalSizeData   = String.valueOf( (Double.parseDouble(strTotalSizeData)*1000000000) );

		strProjectNameData = strProjectNameData.replaceAll( "'", "&acute;" );
        strProjectNameData = strProjectNameData.replaceAll( "\"", "&quot;" );
        
        con.addData( "PROJECT_CODE", "String", strProjectCodeKey);
        con.addData( "PROJECT_NAME", "String", strProjectNameData);
        con.addData( "TOTAL_SIZE",   "String", strTotalSizeData);
        con.addData( "AVIAIL_SIZE",  "String", strAvailSizeData);
        con.addData( "EDIT_USER",    "String", strUserId);
        con.addData( "EDIT_DATE",    "String", strCurrentDate);
        con.addData( "UPD_USER",     "String", strUserId);
        
        con.addData( "DESC",  		 "String", strProjectCodeKey + "-" + strProjectNameData );
        con.addData( "USER_ID",  	 "String", strUserId );
        con.addData( "ACTION_FLAG",  "String", "EP" );
        con.addData( "CURRENT_DATE", "String", strCurrentDate);

        bolnSuccess = con.executeService( strContainerName , strClassName , "updateProjectManager"  );

        if( !bolnSuccess ){
            strErrorCode = con.getRemoteErrorCode();
            strmsg  = "showMsg(0,0,\" " + lc_can_not_edit_project_manager  + "\")";
            strMode = "pEdit";
        }else{
            strmsg  = "showMsg(0,0,\" " + lc_edit_project_manager_successfull + "\")";
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

function window_onload() {
	var strProjectFlag = "<%=strProjectFlagKey %>";
	
    lb_doc_cabinet_type.innerHTML = lbl_doc_cabinet_type;
    lb_public.innerHTML           = lbl_public;
    lb_private.innerHTML          = lbl_private;
    lb_cabinet_document.innerHTML = lbl_cabinet_document;
    lb_user_cabinet.innerHTML     = lbl_user_cabinet;
    lb_admin_cabinet.innerHTML    = lbl_admin_cabinet;
    lb_project_copy.innerHTML     = lbl_project_copy;
    lb_total_size.innerHTML       = lbl_total_size;
    lb_used_size.innerHTML        = lbl_used_size;
    lb_aval_size.innerHTML        = lbl_aval_size;    
    lb_used_percent.innerHTML     = lbl_used_percent;    
    lb_amount_total.innerHTML     = lbl_amount_total;
    lb_attach_total.innerHTML     = lbl_attach_total;
    
    if( mode == "MAIN" ) {
        form1.action     = "project_manager1.jsp";
        form1.target     = "_self";
        form1.MODE.value = form1.OLD_MODE.value;
        form1.submit();
    }else if( mode == "pEdit" ) {
    	if( strProjectFlag == "2" || strProjectFlag == "4" ) {
    		obj_rdoDocType[0].checked = true;
    	}else {
    		obj_rdoDocType[1].checked = true;
    	}
    	obj_rdoDocType[0].disabled     = true;
    	obj_rdoDocType[1].disabled     = true;
    	obj_zoomOwner.style.display    = "none";
    	obj_zoomProjUser.style.display = "none";
    	obj_zoomProjCopy.style.display = "none";
    	
    	obj_txtProjectName.value      = "<%=strProjectNameData %>";
    	obj_txtProjectOwner.value     = "<%=strProjectOwnerData %>";
    	obj_txtProjectOwnerName.value = "<%=strProjectOwnerNameData %>";
    	obj_hidProjectFlag.value      = "<%=strProjectFlagData %>";
    	obj_txtProjectUser.value      = "<%=strProjectUserData %>";
    	obj_txtProjectUserName.value  = "<%=strUserNameData %>";
    	obj_txtTotalSize.value        = "<%=strTotalSizeData %>";
    	obj_txtUsedSize.value         = "<%=strUsedSizeData %>";
    	obj_txtAvailSize.value        = "<%=strAvailSizeData %>";
    	obj_txtPercent.value          = "<%=strPercentData %>";
    	obj_txtTotalRecord.value      = "<%=strTotalRecordData %>";
    	obj_txtTotalFile.value        = "<%=strTotalFileData %>";
    	obj_txtProjectCopy.value      = "<%=strProjectCopyData %>";
    	obj_txtProjectCopyName.value  = "<%=strProjectCopyNameData %>";
    }else {
    	obj_rdoDocType[0].checked = true;
    	obj_hidProjectFlag.value  = "2";
    }
    obj_txtProjectName.focus();
}

function getRadioValue( lv_docType ) {	
	if( lv_docType == "public" ) {
		obj_zoomProjUser.style.display = "inline";
		obj_hidProjectFlag.value       = "2";
	}else {
		obj_zoomProjUser.style.display = "none";
		obj_hidProjectFlag.value       = "3";
	}
	clearZoomValue();
}

function clearZoomValue() {
	obj_txtProjectOwner.value     = "";
   	obj_txtProjectOwnerName.value = "";
   	obj_txtProjectUser.value      = "";
   	obj_txtProjectUserName.value  = "";
}

function openZoom( strZoomType ) {
	var strPopArgument   = "scrollbars=yes,status=no";
	var strWidth         = ",width=370px";
	var strHeight        = ",height=420px";
	var strUrl           = "";
	var strConcatField   = "";
	var strUserOrg       = obj_txtProjectOwner.value;

	strPopArgument += strWidth + strHeight;

	switch( strZoomType ){
		case "owner" :
				if( obj_hidProjectFlag.value == "2" ) {
					strUrl = "inc/zoom_data_table_level1.jsp";
					strConcatField = "TABLE=ORG" + "&TABLE_LABEL=" + lbl_user_profile3;
					strConcatField += "&RESULT_FIELD=txtProjectOwner,txtProjectOwnerName";
					break;
				}else {
					strUrl = "inc/zoom_user_profile.jsp";
					strConcatField = "TABLE=ORG" + "&TABLE_LABEL=" + lbl_user_profile2_7;
					strConcatField += "&RESULT_FIELD=txtProjectOwner,txtProjectOwnerName";
					strConcatField += "&CALL_FUNC=dupDataUser";
					break;
				}
		case "projuser" :
				strUrl = "inc/zoom_user_profile.jsp";
				strConcatField = "TABLE=ORG" + "&TABLE_LABEL=" + lbl_user_profile2_7;
				strConcatField += "&RESULT_FIELD=txtProjectUser,txtProjectUserName";
				strConcatField += "&USER_ORG=" + strUserOrg;
				break;
		case "projcopy" :
				strUrl = "inc/zoom_project_manager.jsp";
				strConcatField = "TABLE_LABEL=" + lbl_cabinet_document;
//				strConcatField += "&PROJECT_FLAG=" + obj_hidProjectFlag.value;
				strConcatField += "&PROJECT_FLAG=2";
				strConcatField += "&RESULT_FIELD=txtProjectCopy,txtProjectCopyName";
				strConcatField += "&CALL_FUNC=display_clear";
				break;
	}

	objZoomWindow = window.open( strUrl + "?" + strConcatField, strZoomType, strPopArgument );
	objZoomWindow.focus();
}

function dupDataUser() {
	obj_txtProjectUser.value     = obj_txtProjectOwner.value;
	obj_txtProjectUserName.value = obj_txtProjectOwnerName.value;
}

function display_clear(){
	if(obj_txtProjectCopy.value != ""){
		sp_display_clear.style.display = "inline";
	}
}

function clear_project_copy(){
	obj_txtProjectCopy.value     = "";
	obj_txtProjectCopyName.value = "";
	sp_display_clear.style.display = "none";
}

function buttonClick( lv_strMethod ){
	//checkedSize();
    switch( lv_strMethod ){
		case "save" :
			verify_form();
/*		    if( verify_form() ){
		    	if( checkedResultSize() ) {
			        if(form1.MODE.value == "pInsert"){
			            form1.MODE.value = "ADD" ;
			        }else{
			            form1.MODE.value = "EDIT" ;
			        }
					form1.submit();
				}
			}*/
			break;
		case "cancel" :
			form1.action     = "project_manager1.jsp";
			form1.target 	 = "_self";
		    form1.MODE.value = form1.OLD_MODE.value;
		    form1.submit();
			break;
	}
}

function verify_form() {
	var extraChar = new Array( "#","!","$","%","ß","%" );
	
	if( obj_txtProjectName.value.length == 0 ) {
	        alert( lc_checked_cabinet_name );
	        obj_txtProjectName.focus();
	        return false;
	}
	
	for( var i=0;i<extraChar.length;i++ ) {
		if( obj_txtProjectName.value.indexOf(extraChar[i]) != -1 ) {
			alert( lc_checked_cabinet_name_extra );
	        obj_txtProjectName.focus();
	        return false;
		}
	}
	if( obj_txtProjectOwner.value.length == 0 ) {
	        alert( lc_checked_own_cabinet_detail );
	        obj_txtProjectOwner.focus();
	        return false;
	}
	
	if( obj_hidProjectFlag.value == "2" ) {
		if( obj_txtProjectUser.value.length == 0 ) {
		        alert( lc_checked_admin_cabinet_detail );
		        obj_txtProjectUser.focus();
		        return false;
		}
	}
	
	if( mode == "pInsert" ) {
		if( obj_txtTotalSize.value.length == 0 ) {
		        alert( lc_checked_total_space );
		        obj_txtTotalSize.focus();
		        return false;
		}
	}else {
		var intTotal = parseInt(obj_txtTotalSize.value);
		var intUsed  = parseInt(obj_txtUsedSize.value);
		if( intTotal < intUsed ) {
		        alert( lc_checked_total_not_less_than_used );
		        obj_txtTotalSize.focus();
		        return false;
		}
	}
	checkedSize();
	//return true;
}

function checkedSize() {
	//frameCheck.TABLE_CODE.value = lv_tableLevel;
	if(form1.MODE.value == "pInsert"){
		frameCheck.METHOD.value = "ADD" ;
		frameCheck.PROJ_TOTAL_SIZE.value = form1.txtTotalSize.value;
    }else{
    	frameCheck.METHOD.value = "EDIT" ;
    }
	frameCheck.MODE.value = "SEARCH";
    frameCheck.target     = "frameCheckedSize";
    frameCheck.action     = "frame_checked_all_size.jsp";
    frameCheck.submit();
}

function checkedResultSize() {
/*	var strTotal = obj_txtTotalSize.value;
	var dbTotalSize  = parseDouble( obj_txtTotalSize.value * 1000000000 );
	var dbResultSize = parseDouble( form1.chkResult.value );
	var dbUsedSize = parseDouble( form1.chkResult.value );*/
	var dbSumSize    = "";
	
	if( form1.chkResult.value == "" ) {
		alert( lc_have_exception );
		return false;
	}else {
		dbSumSize = ( parseFloat(form1.txtTotalSize.value) + parseFloat(form1.usedResult.value) );
		if( dbSumSize > form1.chkResult.value ) {
			alert( lc_full_space_exception );
			return false;
		}
	}
	if(form1.MODE.value == "pInsert"){
        form1.MODE.value = "ADD" ;
    }else{
        form1.MODE.value = "EDIT" ;
    }
	form1.submit();
	//return true;
}

function keypress_number(){
    var carCode = event.keyCode;
    if ((carCode < 48) || (carCode > 57)){
      if(carCode != 46){
        if( event.preventDefault ){
            event.preventDefault();
        }else{
            event.returnValue = false;
        }
        return;
      }
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
            		<table width="550" border="0" cellspacing="0" cellpadding="0">
		                <tr>
		                  	<td height="25" colspan="4">&nbsp;</td>
		                </tr>
		                <tr>
		                  	<td width="150" height="25" class="label_bold2"><span id="lb_doc_cabinet_type"></span>&nbsp;
		                  		<img src="images/mark.gif" width="12" height="11">
		                  	</td>
		                  	<td height="25" colspan="3" class="label_bold2" >
	                      		<input type="radio" id="rdoDocType" name="rdoDocType" onclick="getRadioValue('public');"><span id="lb_public"></span>
	                      		<input type="radio" id="rdoDocType" name="rdoDocType" onclick="getRadioValue('private');"><span id="lb_private"></span>
		                  	</td>
	                	</tr>
	                	<tr>
		                  	<td height="25" class="label_bold2"><span id="lb_cabinet_document"></span>&nbsp;
		                  		<img src="images/mark.gif" width="12" height="11">
		                  	</td>
		                  	<td height="25" colspan="3">
		                  		<input id="txtProjectName" name="txtProjectName" type="text" class="input_box" size="67" maxlength="100">
	                  		</td>
	                	</tr>
	                	<tr>
		                  	<td height="25" class="label_bold2"><span id="lb_user_cabinet"></span>&nbsp;
		                  		<img src="images/mark.gif" width="12" height="11">
		                  	</td>
		                  	<td height="25" colspan="3">
		                  		<div style="float: left">
		                  			<input id="txtProjectOwner" name="txtProjectOwner" type="text" class="input_box_disable" size="8" maxlength="10" readonly align="right">
		                  			&nbsp;<a href="javascript:openZoom('owner');"><img id="zoomOwner" src="images/search.gif" width="16" height="16" border="0"></a>
		                  			&nbsp;<input id="txtProjectOwnerName" name="txtProjectOwnerName" type="text" class="input_box_disable" size="47" maxlength="80" readonly>
	                  			</div>
	                  		</td>
	                	</tr>
	                	<tr>
		                  	<td height="25" class="label_bold2"><span id="lb_admin_cabinet"></span>&nbsp;
		                  		<img src="images/mark.gif" width="12" height="11">
		                  	</td>
		                  	<td height="25" colspan="3">
		                  		<div style="float: left">
		                  			<input id="txtProjectUser" name="txtProjectUser" type="text" class="input_box_disable" size="15" maxlength="20" readonly>
		                  			&nbsp;<a href="javascript:openZoom('projuser');"><img id="zoomProjUser" src="images/search.gif" width="16" height="16" border="0" ></a>
	                  				&nbsp;<input id="txtProjectUserName" name="txtProjectUserName" type="text" class="input_box_disable" size="40" maxlength="80" readonly >
	                  			</div>
	                  		</td>
	                	</tr>
	                	<tr>
		                  	<td height="25" class="label_bold2"><span id="lb_project_copy"></span>&nbsp;
		                  		<span id="sp_display_clear" style="display:none;"><img src="images/clear.gif" width="18" height="18" border="0" align="textmiddle" style="cursor:pointer" onclick="clear_project_copy();"></span>
		                  	</td>
		                  	<td height="25" colspan="3">
		                  		<div style="float: left">
		                  			<input id="txtProjectCopy" name="txtProjectCopy" type="text" class="input_box_disable" size="15" maxlength="20" readonly>
		                  			&nbsp;<a href="javascript:openZoom('projcopy');"><img id="zoomProjCopy" src="images/search.gif" width="16" height="16" border="0" ></a>
	                  				&nbsp;<input id="txtProjectCopyName" name="txtProjectCopyName" type="text" class="input_box_disable" size="40" maxlength="80" readonly >
	                  			</div>
	                  		</td>
	                	</tr>
	                	<tr>
		                  	<td height="25" class="label_bold2"><span id="lb_total_size"></span>&nbsp;
		                  		<img src="images/mark.gif" width="12" height="11">
		                  	</td>
		                  	<td height="25" colspan="3">
		                  		<input id="txtTotalSize" name="txtTotalSize" type="text" class="input_box" size="4" maxlength="4" onkeypress="keypress_number()">
	                  		</td>
	                	</tr>
	                	<tr>
		                  	<td height="25" class="label_bold2"><span id="lb_used_size"></span></td>
		                  	<td height="25" colspan="3">
		                  		<input id="txtUsedSize" name="txtUsedSize" type="text" class="input_box_disable" size="4" maxlength="4" readonly>
	                  		</td>
	                	</tr>
	                	<tr>
		                  	<td height="25" class="label_bold2"><span id="lb_aval_size"></span></td>
		                  	<td height="25" colspan="3">
		                  		<input id="txtAvailSize" name="txtAvailSize" type="text" class="input_box_disable" size="4" maxlength="4" readonly>
	                  		</td>
	                	</tr>
	                	<tr>
		                  	<td height="25" class="label_bold2"><span id="lb_used_percent"></span></td>
		                  	<td height="25" colspan="3">
		                  		<input id="txtPercent" name="txtPercent" type="text" class="input_box_disable" size="4" maxlength="4" readonly>
	                  		</td>
	                	</tr>
	                	<tr>
		                  	<td height="25" class="label_bold2"><span id="lb_amount_total"></span></td>
		                  	<td height="25" colspan="3">
		                  		<input id="txtTotalRecord" name="txtTotalRecord" type="text" class="input_box_disable" size="10" maxlength="10" readOnly>
	                  		</td>
	                	</tr>
	                	<tr>
		                  	<td height="25" class="label_bold2"><span id="lb_attach_total"></span></td>
		                  	<td height="25" colspan="3">
		                  		<input id="txtTotalFile" name="txtTotalFile" type="text" class="input_box_disable" size="10" maxlength="10" readonly>
	                  		</td>
	                	</tr>
	                	<tr>
	                  		<td height="25" colspan="4">&nbsp;</td>
	                  	</tr>
			            <tr>
				           	<td align="center" colspan="4">
				           		<a href="#" onclick= "buttonClick('save')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('save','','images/btt_save2_over.gif',1)"><img src="images/btt_save2.gif" name="save" width="67" height="22" border="0"></a>&nbsp;
				           		<a href="#" onclick= "buttonClick('cancel')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('cancel','','images/btt_cancel_over.gif',1)"><img src="images/btt_cancel.gif" name="cancel" width="67" height="22" border="0"></a>
				           	</td>
			            </tr>
              		</table>
            	</td>
            </tr>
        </table>
        <p>&nbsp;</p>
      </td>
    </tr>
</table>
<input type="hidden" id="MODE"        name="MODE"        value="<%=strMode%>">
<input type="hidden" id="OLD_MODE"    name="OLD_MODE"    value="<%=strOldMode%>">
<input type="hidden" id="screenname"  name="screenname"  value="<%=screenname%>">
<input type="hidden" id="screenLabel" name="screenLabel" value="<%=screenLabel%>">

<input type="hidden" id="PROJECT_CODE_KEY"  name="PROJECT_CODE_KEY"  value="<%=strProjectCodeKey %>">
<input type="hidden" id="hidProjectFlag"    name="hidProjectFlag"    value="<%=strProjectFlagData %>">
<input type="hidden" id="chkResult"         name="chkResult"         value="">
<input type="hidden" id="usedResult"        name="usedResult"        value="">

<input type="hidden" id="CURRENT_PAGE"  name="CURRENT_PAGE" value="<%=strCurrentPage%>">
<input type="hidden" id="PAGE_SIZE"     name="PAGE_SIZE"    value="<%=strPageSize%>">

<input type="hidden" id="PROJECT_NAME_SEARCH"  name="PROJECT_NAME_SEARCH"   value="<%=strProjectNameSearch%>">
<input type="hidden" id="PROJECT_OWNER_SEARCH" name="PROJECT_OWNER_SEARCH"  value="<%=strProjectOwnerSearch%>">
<input type="hidden" id="DOC_TYPE_SEARCH"      name="DOC_TYPE_SEARCH"       value="<%=strDocTypeSearch%>">

<iframe name="frameCheckedSize" style="display:none;"></iframe>
</form>

<form id="frameCheck" name="frameCheck" method="post" action="">
	<input type="hidden" name="MODE" value="">
	<input type="hidden" name="METHOD" value="">
	<input type="hidden" name="PROJ_TOTAL_SIZE" value="">
	<input type="hidden" name="PROJECT_CODE" value="<%=strProjectCodeKey%>">
</form>

</body>
</html>
<script language="JavaScript" type="text/javascript">
<!--

var obj_txtProjectName      = document.getElementById("txtProjectName");
var obj_txtProjectCopy      = document.getElementById("txtProjectCopy");
var obj_txtProjectCopyName  = document.getElementById("txtProjectCopyName");
var obj_txtProjectOwner     = document.getElementById("txtProjectOwner");
var obj_txtProjectOwnerName = document.getElementById("txtProjectOwnerName");
var obj_hidProjectFlag      = document.getElementById("hidProjectFlag");
var obj_txtProjectUser      = document.getElementById("txtProjectUser");
var obj_txtProjectUserName  = document.getElementById("txtProjectUserName");
var obj_txtTotalSize        = document.getElementById("txtTotalSize");
var obj_txtUsedSize         = document.getElementById("txtUsedSize");
var obj_txtAvailSize        = document.getElementById("txtAvailSize");
var obj_txtPercent          = document.getElementById("txtPercent");
var obj_txtTotalRecord      = document.getElementById("txtTotalRecord");
var obj_txtTotalFile        = document.getElementById("txtTotalFile");

var obj_rdoDocType   = document.getElementsByName("rdoDocType");
var obj_zoomOwner    = document.getElementById("zoomOwner");
var obj_zoomProjUser = document.getElementById("zoomProjUser");
var obj_zoomProjCopy = document.getElementById("zoomProjCopy");
//-->
</script>
<%  if (!strmsg.equals("")) {  %>
<script language="javaScript">
    <%=strmsg%>
</script>
<%  }   %>