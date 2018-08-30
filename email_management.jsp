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

    String screenname   = getField(request.getParameter("screenname"));
    String strClassName = "CABINET_CONFIG";
    String strMode      = checkNull(request.getParameter("MODE"));
    
    String strEmailAccountData  = checkNull(request.getParameter("txtEmailAccount"));
    String strEmailPasswordData = checkNull(request.getParameter("txtEmailPassword"));
    String strDocTypeData       = checkNull(request.getParameter("txtDocType"));
    String strDocTypeNameData   = getField(request.getParameter("txtDocTypeName"));
    String strTagDateData       = checkNull(request.getParameter("hidTagDateOption"));
    String strTagSendData       = getField(request.getParameter("hidTagSendOption"));
    String strTagRecieveData    = getField(request.getParameter("hidTagRecieveOption"));
    String strTagSubjectData    = getField(request.getParameter("hidTagSubjectOption"));
    String strTagDetailData     = getField(request.getParameter("hidTagDetailOption"));

    String screenLabel = lb_email_management;
    
    boolean bolnZoomSuccess = true;
    boolean bolnSuccess     = true;  
    String  strmsg          = "";
    String  strCurrentDate  = "";
    String  strVersionLang = ImageConfUtil.getVersionLang();

	if( strVersionLang.equals("thai") ) {
		strCurrentDate = getServerDateThai();
	}else {
		strCurrentDate = getServerDateEng();
	}
	
	if( strMode == null ){
        strMode = "SEARCH";
    }

    if( strMode.equals("DELETE") ) {
        con.addData( "PROJECT_CODE", "String", strProjectCode);
        bolnSuccess = con.executeService( strContainerName , strClassName , "deleteEmailManagement"  );
        if( !bolnSuccess ){
            strmsg="showMsg(0,0,\" " + lc_can_not_delete_data  + "\")";
            strMode = "SEARCH";
        }else{
            strmsg="showMsg(0,0,\" " + lc_delete_data_successful + "\")";
            strMode = "SEARCH";
        }
	}

    if(strMode.equals("ADD")){        
        con.addData( "PROJECT_CODE",      "String", strProjectCode);
        con.addData( "EMAIL_ACCOUNT",     "String", strEmailAccountData);
        con.addData( "DOCUMENT_TYPE",     "String", strDocTypeData);
        if( !strEmailPasswordData.equals("") ) {
        	con.addData( "EMAIL_PASSWORD",    "String", strEmailPasswordData);
        }        
        if( !strTagDateData.equals("") ) {
        	con.addData( "SEND_DATE_FIELD",   "String", strTagDateData);
        }
        if( !strTagSendData.equals("") ) {
        	con.addData( "SENDER_FIELD",      "String", strTagSendData);
        }
        if( !strTagRecieveData.equals("") ) {
        	con.addData( "RECEIVER_FIELD",    "String", strTagRecieveData);
        }
        if( !strTagSubjectData.equals("") ) {
        	con.addData( "SUBJECT_FIELD",     "String", strTagSubjectData);
        }
        if( !strTagDetailData.equals("") ) {
        	con.addData( "DESCRIPTION_FIELD", "String", strTagDetailData);
        }
        con.addData( "ADD_USER",          "String", strUserId);
        con.addData( "ADD_DATE",          "String", strCurrentDate);
        con.addData( "UPD_USER",          "String", strUserId);

        bolnSuccess = con.executeService( strContainerName , strClassName , "insertEmailManagement"  );

        if( !bolnSuccess ){
            strmsg="showMsg(0,0,\" " + lc_can_not_add_data  + "\")";
            strMode = "SEARCH";
        }else{
            strmsg="showMsg(0,0,\" " + lc_add_data_successfull + "\")";
            strMode = "SEARCH";
        }
	}

    if(strMode.equals("EDIT")){        
        con.addData( "PROJECT_CODE",      "String", strProjectCode);
        con.addData( "EMAIL_ACCOUNT",     "String", strEmailAccountData);
        con.addData( "DOCUMENT_TYPE",     "String", strDocTypeData);
        if( !strEmailPasswordData.equals("") ) {
        	con.addData( "EMAIL_PASSWORD",    "String", strEmailPasswordData);
        }        
        if( !strTagDateData.equals("") ) {
        	con.addData( "SEND_DATE_FIELD",   "String", strTagDateData);
        }
        if( !strTagSendData.equals("") ) {
        	con.addData( "SENDER_FIELD",      "String", strTagSendData);
        }
        if( !strTagRecieveData.equals("") ) {
        	con.addData( "RECEIVER_FIELD",    "String", strTagRecieveData);
        }
        if( !strTagSubjectData.equals("") ) {
        	con.addData( "SUBJECT_FIELD",     "String", strTagSubjectData);
        }
        if( !strTagDetailData.equals("") ) {
        	con.addData( "DESCRIPTION_FIELD", "String", strTagDetailData);
        }
        con.addData( "EDIT_USER",         "String", strUserId);
        con.addData( "EDIT_DATE",         "String", strCurrentDate);
        con.addData( "UPD_USER",          "String", strUserId);

        bolnSuccess = con.executeService( strContainerName , strClassName , "updateEmailManagement"  );

        if( !bolnSuccess ){
            strmsg="showMsg(0,0,\" " + lc_can_not_update_data  + "\")";
            strMode = "SEARCH";
        }else{
            strmsg="showMsg(0,0,\" " + lc_update_data_successfull + "\")";
            strMode = "SEARCH";
        }
	}
    
    if( strMode.equals("SEARCH") ) {
        con.addData( "PROJECT_CODE", "String", strProjectCode );
        bolnSuccess = con.executeService( strContainerName, strClassName, "findEmailManagement" );
        if( !bolnSuccess ) {
            strEmailAccountData  = "";
            strEmailPasswordData = "";
            strDocTypeData       = "";
            strDocTypeNameData   = "";
            strTagDateData       = "";
            strTagSendData       = "";
            strTagRecieveData    = "";
            strTagSubjectData    = "";
            strTagDetailData     = "";
            strMode = "SEARCH";
        }else {
            while( con.nextRecordElement() ) {

            	strEmailAccountData  = con.getColumn( "EMAIL_ACCOUNT" );
            	strEmailPasswordData = con.getColumn( "EMAIL_PASSWORD" );
            	strDocTypeData       = con.getColumn( "DOCUMENT_TYPE" );
            	strDocTypeNameData   = con.getColumn( "DOCUMENT_TYPE_NAME" );
            	strTagDateData       = con.getColumn( "SEND_DATE_FIELD" );
            	strTagSendData       = con.getColumn( "SENDER_FIELD" );
            	strTagRecieveData    = con.getColumn( "RECEIVER_FIELD" );
            	strTagSubjectData    = con.getColumn( "SUBJECT_FIELD");
            	strTagDetailData     = con.getColumn( "DESCRIPTION_FIELD");
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
    lb_email_account.innerHTML  = lbl_email_account;
    lb_mail_exaple.innerHTML    = lbl_mail_exaple;
    lb_email_password.innerHTML = lbl_email_password;
    lb_doc_type_name.innerHTML  = lbl_doc_type_name;
    lb_field_date.innerHTML     = lbl_field_date;
    lb_field_sent.innerHTML     = lbl_field_sent;
    lb_field_recieve.innerHTML  = lbl_field_recieve;
    lb_field_subject.innerHTML  = lbl_field_subject;
    lb_field_detail.innerHTML   = lbl_field_detail;
    
    obj_txtEmailAccount.value     = "<%=strEmailAccountData %>";
   	obj_txtEmailPassword.value    = "<%=strEmailPasswordData %>";
   	obj_txtDocType.value          = "<%=strDocTypeData %>";
   	obj_txtDocTypeName.value      = "<%=strDocTypeNameData %>";
   	obj_hidTagDateOption.value    = "<%=strTagDateData %>";
   	obj_hidTagSendOption.value    = "<%=strTagSendData %>";
   	obj_hidTagRecieveOption.value = "<%=strTagRecieveData %>";
   	obj_hidTagSubjectOption.value = "<%=strTagSubjectData %>";
   	obj_hidTagDetailOption.value  = "<%=strTagDetailData %>";
    
    setComboValue();
}

function setComboValue() {
	if( obj_hidTagDateOption.value != "" ) {
		obj_optTagDate.value = obj_hidTagDateOption.value;
	}
	if( obj_hidTagSendOption.value != "" ) {
		obj_optTagSend.value = obj_hidTagSendOption.value;
	}
	if( obj_hidTagRecieveOption.value != "" ) {
		obj_optTagRecieve.value = obj_hidTagRecieveOption.value;
	}
	if( obj_hidTagSubjectOption.value != "" ) {
		obj_optTagSubject.value = obj_hidTagSubjectOption.value;
	}
	if( obj_hidTagDetailOption.value != "" ) {
		obj_optTagDetail.value = obj_hidTagDetailOption.value;
	}
}

function getValueRole( lv_valueType ) {	
	if( lv_valueType == "date" ) {
		obj_hidTagDateOption.value = obj_optTagDate.value;
	}
	if( lv_valueType == "send" ) {
		obj_hidTagSendOption.value = obj_optTagSend.value;
	}
	if( lv_valueType == "recieve" ) {
		obj_hidTagRecieveOption.value = obj_optTagRecieve.value;
	}
	if( lv_valueType == "sunject" ) {
		obj_hidTagSubjectOption.value = obj_optTagSubject.value;
	}
	if( lv_valueType == "detail" ) {
		obj_hidTagDetailOption.value = obj_optTagDetail.value;
	}
}

function openZoom( strZoomType ) {
	var strPopArgument   = "scrollbars=yes,status=no";
	var strWidth         = ",width=370px";
	var strHeight        = ",height=420px";
	var strUrl           = "";
	var strConcatField   = "";
	var strProjCode      = "<%=strProjectCode %>";
	strPopArgument += strWidth + strHeight;

	switch( strZoomType ){
		case "doc" :
				strUrl = "inc/zoom_data_table_level1.jsp";
				strConcatField = "TABLE=DOCUMENT_TYPE" + "&TABLE_LABEL=" + lbl_doc_type_name;
				strConcatField += "&PROJECT_CODE=" + strProjCode;
				strConcatField += "&RESULT_FIELD=txtDocType,txtDocTypeName";
				break;
	}

	objZoomWindow = window.open( strUrl + "?" + strConcatField, strZoomType, strPopArgument );
	objZoomWindow.focus();
}

function buttonClick( lv_strMethod ){
    switch( lv_strMethod ){
		case "save" :
		    if( verify_form() ) {
				if( verify_email() ) {
			        if(form1.MODE.value == "SEARCH"){
			            form1.MODE.value = "ADD" ;
			        }else{
			            form1.MODE.value = "EDIT" ;
			        }
					form1.submit();
				}
			}
			break;
		case "cancel_email" :
			if( obj_txtEmailAccount.value == "" ) {
				return;
			}
			if( !confirm( lc_confirm_delete ) ){
				return;
			}
			form1.action     = "email_management.jsp";
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
	if( obj_txtEmailAccount.value.length == 0 ) {
        alert( lc_check_email_account );
        obj_txtEmailAccount.focus();
        return false;
	}
	
	if( obj_txtEmailPassword.value.length == 0 ) {
        alert( lc_check_email_pass );
        obj_txtEmailPassword.focus();
        return false;
	}
	
	if( obj_txtDocType.value.length == 0 ) {
        alert( lc_check_email_doc_type );
        //obj_hidTagSendOption.focus();
        return false;
	}
	//------ Combo ------
	/*
	if( obj_hidTagDateOption.value.length == 0 ) {
        alert( lc_check_email_feild_date );
        //obj_hidTagSendOption.focus();
        return false;
	}
	
	if( obj_hidTagSendOption.value.length == 0 ) {
        alert( lc_check_email_feild_sender );
        //obj_hidTagSendOption.focus();
        return false;
	}
	
	if( obj_hidTagRecieveOption.value.length == 0 ) {
        alert( lc_check_email_feild_reciever );
        //obj_hidTagSendOption.focus();
        return false;
	}
	
	if( obj_hidTagSubjectOption.value.length == 0 ) {
        alert( lc_check_email_feild_subject );
        //obj_hidTagSendOption.focus();
        return false;
	}
	
	if( obj_hidTagDetailOption.value.length == 0 ) {
        alert( lc_check_email_feild_desc );
        //obj_hidTagSendOption.focus();
        return false;
	}
	*/
	
	return true;
}

function verify_email() {
    var email_format = /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i;
    var email_addr   = obj_txtEmailAccount.value;

    email_addr                = sccUtils.trim(email_addr);
    obj_txtEmailAccount.value = email_addr;

    if (email_addr.search(email_format) == -1) {
        alert( lc_check_email_address );
        obj_txtEmailAccount.focus();
        return false;
    }
    return true;
}

//-->
</script>
<link href="css/edas.css" type="text/css" rel="stylesheet">
</head>
<body onLoad="MM_preloadImages('images/btt_save2_over.gif','images/btt_back_over.gif','images/btt_newpw_over.gif','images/btt_cancelmail_over.gif');window_onload();">
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
            		<table width="532" border="0" cellspacing="0" cellpadding="0">
		                <tr>
		                  	<td height="25" colspan="4">&nbsp;</td>
		                </tr>
	                	<tr>
		                  	<td height="25" class="label_bold2"><span id="lb_email_account"></span>&nbsp;
		                  		<img src="images/mark.gif" width="12" height="11">
		                  	</td>
		                  	<td height="25" colspan="3">
		                  		<input id="txtEmailAccount" name="txtEmailAccount" type="text" class="input_box" size="40" maxlength="50">&nbsp;
		                  		<span id="lb_mail_exaple" class="label_bold2"></span>
	                  		</td>
	                	</tr>
	                	<tr>
		                  	<td height="25" class="label_bold2"><span id="lb_email_password"></span>&nbsp;
		                  		<img src="images/mark.gif" width="12" height="11">
		                  	</td>
		                  	<td height="25" colspan="3">
		                  		<input id="txtEmailPassword" name="txtEmailPassword" type="password" class="input_box" size="40" maxlength="50">
	                  		</td>
	                	</tr>
	                	<tr>
		                  	<td height="25" class="label_bold2"><span id="lb_doc_type_name"></span>&nbsp;
		                  		<img src="images/mark.gif" width="12" height="11">
		                  	</td>
		                  	<td height="25" colspan="3">
		                  		<div style="float: left">
		                  			<input id="txtDocType" name="txtDocType" type="text" class="input_box_disable" size="4" maxlength="10" readonly align="right">
		                  			&nbsp;<a href="javascript:openZoom('doc');"><img id="zoomOwner" src="images/search.gif" width="16" height="16" border="0"></a>
		                  			&nbsp;<input id="txtDocTypeName" name="txtDocTypeName" type="text" class="input_box_disable" size="40" maxlength="50" readonly>
	                  			</div>
	                  		</td>
	                	</tr>
<%
		String strTagDateOption    = "";
		String strTagSendOption    = "";
		String strTagRecieveOption = "";
		String strTagSubjectOption = "";
		String strTagDetailOption  = "";
		
		String strZoomFieldLabel  = "";
		String strZoomFieldCode   = "";
		
		strTagDateOption = "\n<select id=\"optTagDate\" name=\"optTagDate\" class=\"combobox\" onchange=\"getValueRole('date');\">";
		strTagDateOption += "\n<option value=\"\"></option>";
		
		strTagSendOption = "\n<select id=\"optTagSend\" name=\"optTagSend\" class=\"combobox\" onchange=\"getValueRole('send');\">";
		strTagSendOption += "\n<option value=\"\"></option>";
		
		strTagRecieveOption = "\n<select id=\"optTagRecieve\" name=\"optTagRecieve\" class=\"combobox\" onchange=\"getValueRole('recieve');\">";
		strTagRecieveOption += "\n<option value=\"\"></option>";
		
		strTagSubjectOption = "\n<select id=\"optTagSubject\" name=\"optTagSubject\" class=\"combobox\" onchange=\"getValueRole('sunject');\">";
		strTagSubjectOption += "\n<option value=\"\"></option>";
		
		strTagDetailOption = "\n<select id=\"optTagDetail\" name=\"optTagDetail\" class=\"combobox\" onchange=\"getValueRole('detail');\">";
		strTagDetailOption += "\n<option value=\"\"></option>";
		
		con1.addData( "PROJECT_CODE", "String", strProjectCode );		
		bolnZoomSuccess = con1.executeService( strContainerName, strClassName, "findFieldManagerCombo" );
		
		if( bolnZoomSuccess ){
			while( con1.nextRecordElement() ){
				strZoomFieldLabel = con1.getColumn( "FIELD_LABEL" );
				strZoomFieldCode  = con1.getColumn( "FIELD_CODE" );
		
				strTagDateOption    += "\n<option value=\"" + strZoomFieldCode + "\">" + strZoomFieldLabel + "</option>";
				strTagSendOption    += "\n<option value=\"" + strZoomFieldCode + "\">" + strZoomFieldLabel + "</option>";
				strTagRecieveOption += "\n<option value=\"" + strZoomFieldCode + "\">" + strZoomFieldLabel + "</option>";
				strTagSubjectOption += "\n<option value=\"" + strZoomFieldCode + "\">" + strZoomFieldLabel + "</option>";
				strTagDetailOption  += "\n<option value=\"" + strZoomFieldCode + "\">" + strZoomFieldLabel + "</option>";
			}
		}
		
		strTagDateOption += "\n</select>";
		strTagSendOption += "\n</select>";
		strTagRecieveOption += "\n</select>";
		strTagSubjectOption += "\n</select>";
		strTagDetailOption += "\n</select>";
%>	                	
	                	<tr>
		                  	<td height="25" class="label_bold2"><span id="lb_field_date"></span></td>
		                  	<td height="25" colspan="3"><%=strTagDateOption %>
		                  		<input type="hidden" id="hidTagDateOption" name="hidTagDateOption" value="">
		                  	</td>
	                	</tr>
	                	<tr>
		                  	<td height="25" class="label_bold2"><span id="lb_field_sent"></span></td>
		                  	<td height="25" colspan="3"><%=strTagSendOption %>
		                  		<input type="hidden" id="hidTagSendOption" name="hidTagSendOption" value="">
		                  	</td>
	                	</tr>
	                	<tr>
		                  	<td height="25" class="label_bold2"><span id="lb_field_recieve"></span></td>
		                  	<td height="25" colspan="3"><%=strTagRecieveOption %>
		                  		<input type="hidden" id="hidTagRecieveOption" name="hidTagRecieveOption" value="">
		                  	</td>
	                	</tr>
	                	<tr>
		                  	<td height="25" class="label_bold2"><span id="lb_field_subject"></span></td>
		                  	<td height="25" colspan="3"><%=strTagSubjectOption %>
		                  		<input type="hidden" id="hidTagSubjectOption" name="hidTagSubjectOption" value="">
		                  	</td>
	                	</tr>
	                	<tr>
		                  	<td height="25" class="label_bold2"><span id="lb_field_detail"></span></td>
		                  	<td height="25" colspan="3"><%=strTagDetailOption %>
		                  		<input type="hidden" id="hidTagDetailOption" name="hidTagDetailOption" value="">
		                  	</td>
	                	</tr>
	                	<tr>
	                  		<td height="25" colspan="4">&nbsp;</td>
	                  	</tr>
			            <tr>
				           	<td align="center" colspan="4">
				           		<a href="#" onclick= "buttonClick('save')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('save','','images/btt_save2_over.gif',1)">
				           			<img src="images/btt_save2.gif" name="save" width="67" height="22" border="0"></a>&nbsp;
				           		<a href="#" onclick= "buttonClick('cancel_email')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('cancel_email','','images/btt_cancelmail_over.gif',1)">
				           			<img src="images/btt_cancelmail.gif" name="cancel_email" width="102" height="22" border="0"></a>&nbsp;
				           		<a href="#" onclick= "buttonClick('cancel')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('back','','images/btt_back_over.gif',1)">
				           			<img src="images/btt_back.gif" name="back" width="67" height="22" border="0"></a>
				           	</td>
			            </tr>
			            <input type="hidden" id="MODE"        name="MODE"        value="<%=strMode%>">
			            <input type="hidden" id="screenname"  name="screenname"  value="<%=screenname%>">
			            <input type="hidden" id="screenLabel" name="screenLabel" value="<%=screenLabel%>">
              		</table>
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

var obj_txtEmailAccount     = document.getElementById("txtEmailAccount");
var obj_txtEmailPassword    = document.getElementById("txtEmailPassword");
var obj_txtDocType          = document.getElementById("txtDocType");
var obj_txtDocTypeName      = document.getElementById("txtDocTypeName");
var obj_hidTagDateOption    = document.getElementById("hidTagDateOption");
var obj_hidTagSendOption    = document.getElementById("hidTagSendOption");
var obj_hidTagRecieveOption = document.getElementById("hidTagRecieveOption");
var obj_hidTagSubjectOption = document.getElementById("hidTagSubjectOption");
var obj_hidTagDetailOption  = document.getElementById("hidTagDetailOption");

var obj_optTagDate    = document.getElementById("optTagDate");
var obj_optTagSend    = document.getElementById("optTagSend");
var obj_optTagRecieve = document.getElementById("optTagRecieve");
var obj_optTagSubject = document.getElementById("optTagSubject");
var obj_optTagDetail  = document.getElementById("optTagDetail");

//-->
</script>
<%  if (!strmsg.equals("")) {  %>
<script language="javaScript">
    <%=strmsg%>
</script>
<%  }   %>