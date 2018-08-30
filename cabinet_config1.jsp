<%@page import="com.scc.edms.conf.ImageConfUtil"%>
<%@ page contentType="text/html; charset=tis-620"%>
<%@ page import="com.scc.security.UserInfo"%>
<%@ include file="inc/checkUser.jsp" %>
<%@ include file="inc/constant.jsp" %>
<%@ include file="inc/utils.jsp" %>
<jsp:useBean id="con" scope="session" class="edms.cllib.EABConnector"/>
<%
    con.setRemoteServer("EAS_SERVER");

    UserInfo userInfo     = (UserInfo)session.getAttribute( "USER_INFO" );
    String strUserId      = userInfo.getUserId();
    String strProjectCode = userInfo.getProjectCode();

    String screenname   = getField(request.getParameter("screenname"));
    String strClassName = "CABINET_CONFIG";
    String strMode      = getField(request.getParameter("MODE"));
    
    String strTableLevelData     = getField(request.getParameter("txtTableLevel"));
    String strTableLevelNameData = getField(request.getParameter("txtTableLevelName"));
    String strDocAccessData      = "";
    String strDocumentAgeData    = getField(request.getParameter("txtDocumentAge"));
    String strWaterMarkData   	 = getField(request.getParameter("hidWaterMark"));
    
    String  strmsg          = "";
    boolean bolnSuccess     = true;
    String  strCurrentDate  = "";
    String  strVersionLang  = ImageConfUtil.getVersionLang();

    if( strVersionLang.equals("thai") ) {
            strCurrentDate = getServerDateThai();
    }else {
            strCurrentDate = getServerDateEng();
    }
    
    if( strMode == null || strMode.equals("")){
        strMode = "SEARCH";
   	}
    
    if( strMode.equals("EDIT") ) {
    	con.addData( "PROJECT_CODE",    "String", strProjectCode );
    	con.addData( "DOCUMENT_LEVEL",  "String", strTableLevelData );
    	con.addData( "ACCESS_TYPE",     "String", strDocAccessData );
    	con.addData( "DOCUMENT_AGE",    "String", strDocumentAgeData );
    	con.addData( "WATERMARK_FLAG", 	"String", strWaterMarkData);
        con.addData( "EDIT_USER", 	"String", strUserId);
        con.addData( "EDIT_DATE", 	"String", strCurrentDate);
        con.addData( "UPD_USER",  	"String", strUserId);
    	bolnSuccess = con.executeService( strContainerName, strClassName, "updateCabinetConfig" );
    	
    	if( !bolnSuccess ){
            strmsg  = "showMsg(0,0,\" " + lc_can_not_update_data  + "\")";
            strMode = "pEdit";
        }else{
            strmsg  = "showMsg(0,0,\" " + lc_update_data_successfull + "\")";
            strMode = "SEARCH";
        }
    }
    
    if( strMode.equals("SEARCH") ) {
        con.addData( "PROJECT_CODE", "String", strProjectCode );
        bolnSuccess = con.executeService( strContainerName, strClassName, "findCabinetConfigOnload" );
        
        if( bolnSuccess ) {
            while( con.nextRecordElement() ) {
            	strTableLevelData     = con.getColumn( "DOCUMENT_LEVEL" );
            	strTableLevelNameData = con.getColumn( "LEVEL_NAME" );
                strDocumentAgeData    = con.getColumn( "DOCUMENT_AGE" );
                strWaterMarkData      = con.getColumn( "WATERMARK_FLAG");
            }
        }
    }
    
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=TIS-620">
<title><%=lc_site_name%></title>
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

function window_onload() {
    lb_head_doc_level.innerHTML   = lbl_head_doc_level;
    //lb_head_doc_entry.innerHTML   = lbl_head_doc_entry;
    lb_head_doc_age.innerHTML     = lbl_head_doc_age;
    lb_head_watermark.innerHTML	  = lbl_head_watermark; //"Water mark

    lb_document_level.innerHTML         = lbl_document_level;
    lb_folder_config11.innerHTML        = lbl_folder_config11;
    lb_folder_config12.innerHTML        = lbl_folder_config12;
    //lb_from_doc_level.innerHTML         = lbl_from_doc_level;
    //lb_all_access.innerHTML             = lbl_all_access;
    //lb_from_doc_org.innerHTML           = lbl_from_doc_org;
    //lb_from_doc_org_and_level.innerHTML = lbl_from_doc_org_and_level;
    
    lb_watermark_print.innerHTML = lbl_watermark_print; //Print
    lb_watermark_view.innerHTML  = lbl_watermark_view; //View
    lb_watermark_all.innerHTML   = lbl_watermark_all; //Print and View
    lb_watermark_none.innerHTML  = lbl_watermark_none; //N/A
	
	checkValueOnLoad();
}

function checkValueOnLoad(){
    var documentAge   = "<%=strDocumentAgeData %>";
    var watermark  	  = "<%=strWaterMarkData %>";
    
    if( documentAge == "99" ){
    	obj_rdoDocumentAge[1].checked = true;
		obj_txtDocumentAge.className  = "input_box_disable";
		obj_txtDocumentAge.readOnly   = true;
		obj_txtDocumentAge.value      = "";
    }else {
    	obj_rdoDocumentAge[0].checked = true;
    	obj_txtDocumentAge.value      = "<%=strDocumentAgeData %>";
		obj_txtDocumentAge.className  = "input_box";
		obj_txtDocumentAge.readOnly   = false;
    }
    
    if( watermark == "P" ){
    	obj_rdoWaterMark[0].checked = true;
		obj_hidWaterMark.value = watermark;
    }else if( watermark == "V" ){
    	obj_rdoWaterMark[1].checked = true;
		obj_hidWaterMark.value = watermark;
    }else if( watermark == "A" ){
    	obj_rdoWaterMark[2].checked = true;
		obj_hidWaterMark.value = watermark;
    }else{
    	obj_rdoWaterMark[3].checked = true;
		obj_hidWaterMark.value = "N";
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
		case "default" :
				strUrl = "inc/zoom_data_table_level1.jsp";
				strConcatField = "TABLE=USER_LEVEL" + "&TABLE_LABEL=" + lbl_document_level;
				strConcatField += "&RESULT_FIELD=txtTableLevel,txtTableLevelName";
				break;
	}

	objZoomWindow = window.open( strUrl + "?" + strConcatField, strZoomType, strPopArgument );
	objZoomWindow.focus();
}

function checkValue( strRadioType ) {
	switch( strRadioType ){
		case "docAge" :
				if( obj_rdoDocumentAge[1].checked ) {
					obj_txtDocumentAge.className = "input_box_disable";
					obj_txtDocumentAge.readOnly  = true;
					obj_txtDocumentAge.value     = "";
				}else {
					obj_txtDocumentAge.className = "input_box";
					obj_txtDocumentAge.readOnly  = false;
				}
				break;
		case "version" :
				if( obj_rdoDocAccess[0].checked ) {
					obj_hidAccessFlag.value = "A";
				}else if( obj_rdoDocAccess[1].checked ) {
					obj_hidAccessFlag.value = "O";
				}else if( obj_rdoDocAccess[2].checked ) {
					obj_hidAccessFlag.value = "L";
				}else if( obj_rdoDocAccess[3].checked ) {
					obj_hidAccessFlag.value = "B";
				}
				break;
	}
}

function setWaterMarkFlag(flag){
	obj_hidWaterMark.value = flag;
}

function keypress_number(){
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

function submit_form() {
    
    if( obj_rdoDocumentAge[1].checked ) {
        obj_txtDocumentAge.value = "99";
    }else{
        if(obj_txtDocumentAge.value == ""){
            alert(lc_verify_document_age);
            return;
        }
    }

    form1.MODE.value = "EDIT";
    form1.submit();
}

function buttonClick( lv_strMethod ){
	switch( lv_strMethod ){
		case "email" :
			form1.method = "post";
			form1.action     = "email_management.jsp";
			form1.MODE.value = "SEARCH";
			form1.submit();
			break;
        case "fax" :
			form1.method = "post";
			form1.action = "fax_management.jsp";
			form1.MODE.value = "SEARCH";
			form1.submit();
			break;
		case "report" :
			form1.method = "post";
			form1.action = "report_management.jsp";
			form1.MODE.value = "SEARCH";
			form1.submit();
			break;
	}
}

//-->
</script>
<link href="css/edas.css" type="text/css" rel="stylesheet">
</head>
<body onLoad="MM_preloadImages('images/btt_save2_over.gif','images/btt_mail_over.gif','images/btt_fax_over.gif','images/btt_reportmgm_over.gif');window_onload()">
<form name="form1" method="post" action="" >
    <table width="769" border="0" cellspacing="0" cellpadding="0">
        <tr>
            <td height="25" class="label_header01">
                &nbsp;&nbsp;&nbsp;<%=screenname%>
            </td>
        </tr>
        <tr>
            <td height="25" align="center">
                <table width="720" border="0" align="center" cellpadding="0" cellspacing="0">
                    <tr>
                        <td height="25">
                            <fieldset><legend class="label_bold2"><span id="lb_head_doc_level"></span></legend>
                                <table width="100%" border="0">
                                	<tr>
                                        <td width="3%">&nbsp;</td>
                                        <td width="22%">
                                            <span id="lb_document_level" class="label_bold2"></span>
                                        </td>
                                        <td width="75%">
			                                <input id="txtTableLevel" name="txtTableLevel" type="text" size="4" maxlength="4" align="right"
						                			class="input_box_disable" readOnly value="<%=strTableLevelData %>" >&nbsp;
						                	<a href="javascript:openZoom('default');">
						                		<img id="imgZoomDocLevel" src="images/search.gif" width="16" height="16" border="0">&nbsp;</a>
						                	<input id="txtTableLevelName" name="txtTableLevelName" type="text" size="25" maxlength="25" 
						                			class="input_box_disable" readOnly value="<%=strTableLevelNameData %>">
						                </td>
						            </tr>
						        </table>
                            </fieldset>
                            <!-- 
                            <fieldset><legend class="label_bold2"><span id="lb_head_doc_entry"></span></legend>
                                <table width="100%" border="0">
                                    <tr>
                                        <td width="3%">&nbsp;</td>
                                        <td width="19%">
                                        	<input id="rdoDocAccess" name="rdoDocAccess" type="radio" onclick="checkValue('version')">&nbsp;
                                            <span id="lb_all_access" class="label_bold2"></span>
                                        </td>
                                        <td width="26%">
                                            <input id="rdoDocAccess" name="rdoDocAccess" type="radio" onclick="checkValue('version')">&nbsp;
                                            <span id="lb_from_doc_org" class="label_bold2"></span>
                                        </td>
                                        <td width="21%">
                                            <input id="rdoDocAccess" name="rdoDocAccess" type="radio" onclick="checkValue('version')">&nbsp;
                                            <span id="lb_from_doc_level" class="label_bold2"></span>
                                        </td>
                                        <td>
                                            <input id="rdoDocAccess" name="rdoDocAccess" type="radio" onclick="checkValue('version')">&nbsp;
                                            <span id="lb_from_doc_org_and_level" class="label_bold2"></span>
                                        </td>
                                    </tr>
                                </table>
                            </fieldset>
                            -->
                        </td>
                    </tr>
                    <tr>
                        <td height="25">
                            <fieldset><legend class="label_bold2"><span id="lb_head_doc_age"></span></legend>
                                <table width="100%" border="0">
                                    <tr>
                                        <td width="3%">&nbsp;</td>
                                        <td width="22%">
                                        	<input id="rdoDocumentAge" name="rdoDocumentAge" type="radio" onclick="checkValue('docAge')">&nbsp;
                                            <span id="lb_folder_config11" class="label_bold2"></span>
                                        </td>
                                        <td width="75%">
                                            <input id="txtDocumentAge" name="txtDocumentAge" type="text" style="text-align: right" size="4" 
                                            		maxlength="4" class="input_box" onkeypress="keypress_number()">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>&nbsp;</td>
                                        <td width="97%" colspan="2">
                                            <input id="rdoDocumentAge" name="rdoDocumentAge" type="radio" onclick="checkValue('docAge')">&nbsp;
                                            <span id="lb_folder_config12" class="label_bold2"></span>
                                        </td>
                                    </tr>
                                  </table>
                            </fieldset>
                            <fieldset><legend class="label_bold2"><span id="lb_head_watermark"></span></legend>
                                <table width="100%" border="0">
                                    <tr>
                                        <td width="3%">&nbsp;</td>
                                        <td width="20%">
                                        	<input id="rdoWaterMark" name="rdoWaterMark" type="radio" onclick="setWaterMarkFlag('P')">&nbsp;
                                            <span id="lb_watermark_print" class="label_bold2"></span>
                                        </td>
                                        <td width="20%">
                                            <input id="rdoWaterMark" name="rdoWaterMark" type="radio" onclick="setWaterMarkFlag('V')">&nbsp;
                                            <span id="lb_watermark_view" class="label_bold2"></span>
                                        </td>
                                        <td width="30%">
                                            <input id="rdoWaterMark" name="rdoWaterMark" type="radio" onclick="setWaterMarkFlag('A')">&nbsp;
                                            <span id="lb_watermark_all" class="label_bold2"></span>
                                        </td>
                                        <td width="*">
                                            <input id="rdoWaterMark" name="rdoWaterMark" type="radio" onclick="setWaterMarkFlag('N')">&nbsp;
                                            <span id="lb_watermark_none" class="label_bold2"></span>
                                        </td>
                                    </tr>                                    
                                </table>
                            </fieldset>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td height="25">
                <table width="100%" border="0">
                    <tr>
                        <td align="right">
                            <div align="center"><br>
                                <a href="javascript:submit_form()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('save2','','images/btt_save2_over.gif',1)">
                                	<img src="images/btt_save2.gif" name="save2" width="67" height="22" border="0"></a>&nbsp;
                                <a href="javascript:buttonClick('email')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('email','','images/btt_mail_over.gif',1)">
                                	<img src="images/btt_mail.gif" name="email" width="142" height="22" border="0"></a>&nbsp;
                                <a href="javascript:buttonClick('report')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('report','','images/btt_reportmgm_over.gif',1)">
                                	<img src="images/btt_reportmgm.gif" name="report" width="142" height="22" border="0"></a>&nbsp;
                            </div>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
<input type="hidden" name="MODE"             value="<%=strMode%>">
<input type="hidden" name="screenname"       value="<%=screenname%>">
<input type="hidden" name="hidTotalSizeDumy" value="">
<input type="hidden" name="hidUsedSizeDumy"  value="">
<input type="hidden" name="hidAvalSizeDumy"  value="">
<input type="hidden" id="hidWaterMark" name="hidWaterMark"  	 value="">
<input type="hidden" id="hidAccessFlag" name="hidAccessFlag" value="">
</form>
</body>
</html>
<script language="JavaScript" type="text/javascript">
<!--

var obj_rdoDocAccess      = document.getElementsByName("rdoDocAccess");
var obj_hidAccessFlag     = document.getElementById("hidAccessFlag");
var obj_txtTableLevel     = document.getElementById("txtTableLevel");
var obj_txtTableLevelName = document.getElementById("txtTableLevelName");
var obj_chkIsSearchLevel  = document.getElementById("chkIsSearchLevel");
var obj_chkIsSearchOrg    = document.getElementById("chkIsSearchOrg");
var obj_chkIsEditLevel    = document.getElementById("chkIsEditLevel");
var obj_chkIsEditOrg      = document.getElementById("chkIsEditOrg");
var obj_rdoDocumentAge    = document.getElementsByName("rdoDocumentAge");
var obj_txtDocumentAge    = document.getElementById("txtDocumentAge");
var obj_rdoWaterMark   	  = document.getElementsByName("rdoWaterMark");
var obj_hidWaterMark   	  = document.getElementById("hidWaterMark");

//-->
</script>
<%  if (!strmsg.equals("")) {  %>
<script language="javaScript">
    <%=strmsg%>
</script>
<%  }   %>