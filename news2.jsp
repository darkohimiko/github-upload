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

    String securecode = "";

    if (!con.executeService("EASSYSTEM", "SECURECODE", "genSecurityCode")){
        out.println("Create Image Login Session Fail");
        return;
    }
    securecode = con.getHeader("SECURECODE");

    UserInfo userInfo       = (UserInfo)session.getAttribute( "USER_INFO" );
    String   strUserId      = userInfo.getUserId();

    String user_role = getField(request.getParameter("user_role"));
    String app_name  = getField(request.getParameter("app_name"));
    String app_group = getField(request.getParameter("app_group"));

    String screenname          = getField(request.getParameter("screenname"));
    String screenLabel         = getField(request.getParameter("screenLabel"));
    String strClassName        = "NEWS_MANAGER";
    String strMode             = getField( request.getParameter("MODE"));
    String mode_parent         = getField( request.getParameter( "mode_parent" ));
    String current_page_parent = getField( request.getParameter( "current_page_parent" ));
    String sortby_parent       = getField( request.getParameter( "sortby_parent" ));
    String sortfield_parent    = getField( request.getParameter( "sortfield_parent" ));
    String strPermission       = "";
    String sortby              = "";
    String sortfield           = "";
    
    String strNewsIdKey = getField(request.getParameter("NEWS_ID_KEY"));

    String strNewsIdData    = getField( request.getParameter("txtNewsId") );
    String strHeaderData    = getField( request.getParameter("txtHeader") );
    String strSubjectData   = getField( request.getParameter("txtSubject") );
    String strSourceData    = getField( request.getParameter("hidSource") );
    String strNewsDateData  = getField( request.getParameter("txtNewsDate") );
    String strBlobData      = getField( request.getParameter("hidBlob") );
    String strPictData      = getField( request.getParameter("hidBlobPart") );
    String strBlobMediaData = getField( request.getParameter("hidBlobMedia") );
    String strPictMediaData = getField( request.getParameter("hidBlobMediaPart") );
    
    if( strPictData.equals("") ) {
    	strPictData = "0";
    }
    if( strPictMediaData.equals("") ) {
    	strPictMediaData = "0";
    }
    
    boolean bolnSuccess      = false;
    boolean bolnZoomSuccess  = false;
    String  strmsg           = "";
    String	strCurrentDate	 = "";
    String  strLangFlag      = "";
    String strVersionLang  = ImageConfUtil.getVersionLang();
    String  strContainerType = ImageConfUtil.getInetContainerType();

    if( strVersionLang.equals("thai") ) {
        strCurrentDate = getServerDateThai();
        strLangFlag = "1";
    }else {
        strCurrentDate = getServerDateEng();
        strLangFlag = "0";
    }
    
    con.addData("USER_ROLE", 		 "String", user_role);
    con.addData("APPLICATION", 	  	 "String", app_name);
    con.addData("APPLICATION_GROUP", "String", app_group);
    
    bolnSuccess = con.executeService(strContainerName, "DOCUMENT_TYPE", "findPermission");
    if(bolnSuccess) {
    	while(con.nextRecordElement()) {
            strPermission = con.getColumn("PERMIT_FUNCTION");
    	}
    }
	
    if( strMode == null ){
        strMode = "SEARCH";
    }

    if( strMode.equals( "pInsert" ) ) {
		screenLabel = lb_add_news;
		
    }else if( strMode.equals( "pEdit" ) ) {
    	screenLabel = lb_edit_news;
    	
    	con.addData( "NEWS_ID", "String", strNewsIdKey);
        bolnSuccess = con.executeService( strContainerName , strClassName , "selectNewsForEdit" );
        if( bolnSuccess ) {
            strNewsIdData    = strNewsIdKey;
            strHeaderData    = con.getHeader( "HEADER" );
            strSubjectData   = con.getHeader( "SUBJECT" );
            strSourceData    = con.getHeader( "SOURCE" );
            strNewsDateData  = con.getHeader( "NEWS_DATE" );
            strBlobData      = con.getHeader( "BLOB" );
            strPictData      = con.getHeader( "PICT" );
            strBlobMediaData = con.getHeader( "BLOB_MEDIA" );
            strPictMediaData = con.getHeader( "PICT_MEDIA" );
            
            strHeaderData  = strHeaderData.replaceAll( "\"" , "\\\\\"" );
            strSubjectData = strSubjectData.replaceAll( "\"" , "\\\\\"" );
            strNewsDateData = dateToDisplay( strNewsDateData, "/" );
            
            if( strPictData.equals("0") ) {
            	strPictData = "";
            }
            if( strPictMediaData.equals("0") ) {
            	strPictMediaData = "";
            }
        }
    }

    if( strMode.equals("ADD") ) {
    	strSubjectData = strSubjectData.replaceAll( "\\r\\n", "##" );
    	
        con.addData( "NEWS_ID",   "String", strNewsIdData );
        con.addData( "HEADER",    "String", strHeaderData );
        con.addData( "SUBJECT",   "String", strSubjectData );
        con.addData( "SOURCE",    "String", strSourceData );
        con.addData( "NEWS_DATE", "String", strNewsDateData );
        con.addData( "BLOB",      "String", strBlobData );
        con.addData( "PICT",      "String", strPictData );
        con.addData( "BLOB_MEDIA", "String", strBlobMediaData );
        con.addData( "PICT_MEDIA", "String", strPictMediaData );
        con.addData( "ADD_USER", "String", strUserId );
        con.addData( "ADD_DATE", "String", strCurrentDate );
        con.addData( "UPD_USER", "String", strUserId );
        
        con.addData( "DESC",  	     "String", strNewsIdData + "-" + strHeaderData );
     	con.addData( "USER_ID",      "String", strUserId );
        con.addData( "ACTION_FLAG",  "String", "AN" );
        con.addData( "CURRENT_DATE", "String", strCurrentDate);

        bolnSuccess    = con.executeService( strContainerName , strClassName , "insertNewsManager" );
        strHeaderData  = strHeaderData.replaceAll( "\"" , "\\\\\"" );
        strSubjectData = strSubjectData.replaceAll( "\"" , "\\\\\"" );
        
        if( !bolnSuccess ) {
            strmsg="showMsg(0,0,\" " + lc_can_not_insert_news + "\")";
            strMode = "pInsert";
        }else{
            strmsg="showMsg(0,0,\" " +  lc_insert_news_successfull + "\")";
            strMode = "MAIN";
        }
		
    }else if( strMode.equals("EDIT") ) {
    	strSubjectData = strSubjectData.replaceAll( "\r\n", "##" );
    	
        con.addData( "NEWS_ID",    "String", strNewsIdData );
        con.addData( "HEADER",     "String", strHeaderData );
        con.addData( "SUBJECT",    "String", strSubjectData );
        con.addData( "SOURCE",     "String", strSourceData );
        con.addData( "NEWS_DATE",  "String", strNewsDateData );
        con.addData( "BLOB",       "String", strBlobData );
        con.addData( "PICT",       "String", strPictData );
        con.addData( "BLOB_MEDIA", "String", strBlobMediaData );
        con.addData( "PICT_MEDIA", "String", strPictMediaData );
        con.addData( "EDIT_USER",  "String", strUserId );
        con.addData( "EDIT_DATE",  "String", strCurrentDate );
        con.addData( "UPD_USER",   "String", strUserId );
        
        con.addData( "DESC",         "String", strNewsIdData + "-" + strHeaderData );
     	con.addData( "USER_ID",      "String", strUserId );
        con.addData( "ACTION_FLAG",  "String", "EN" );
        con.addData( "CURRENT_DATE", "String", strCurrentDate);

        bolnSuccess    = con.executeService( strContainerName, strClassName, "updateNewsManager" );
        strHeaderData  = strHeaderData.replaceAll( "\"" , "\\\\\"" );
        strSubjectData = strSubjectData.replaceAll( "\"" , "\\\\\"" );
        
        if( !bolnSuccess ){
            strmsg="showMsg(0,0,\" " + lc_can_not_update_news  + "\")";
            strMode = "pEdit";
        }else {
            strmsg="showMsg(0,0,\" " + lc_edit_news_successfull + "\")";
            strMode = "MAIN";
        }
     }
%>
<!DOCTYPE HTML>
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
<script language="JavaScript" src="js/jquery-1.9.1.js"></script>
<script language="JavaScript" src="js/label/lb_news.js"></script>
<script language="JavaScript" src="js/sccUtils.js"></script>
<script language="JavaScript" src="js/util.js"></script>
<script language="JavaScript" src="js/constant.js"></script>
<script language="JavaScript" type="text/javascript">
<!--

var sccUtils = new SCUtils();
var mode     = "<%=strMode%>";

$(document).ready(window_onload);

function window_onload(){
    set_label();
    set_init();
    set_message();
}

function set_label(){
    $("#lb_code").text(lbl_code);
    $("#lb_news_header").text(lbl_news_header);
    $("#lb_news_subject").text(lbl_news_subject);
    $("#lb_news_source").text(lbl_news_source);
    $("#lb_news_date").text(lbl_news_date);
    $("#lb_doc_type_name").text(lbl_doc_type_name);
    $("#lb_news_pict").text(lbl_news_pict);
    $("#lb_news_blob").text(lbl_news_blob);
}

function set_init(){
    var strSubject = "<%=strSubjectData %>";
    
    if( mode == "MAIN" ) {
        $("#form1").attr('action', "news1.jsp");
        $("#form1").attr('target', "_self");
        $("#CURRENT_PAGE").val($("#current_page_parent").val());
        $("#sortfield").val($("#sortfield_parent").val());
        $("#sortby").val($("#sortby_parent").val());
        $("#MODE").val($("#mode_parent").val());
        $("#form1").submit();
    }else if( mode == "pEdit" ) {
    	$("#txtNewsId").val("<%=strNewsIdData %>");
    	$("#txtHeader").val("<%=strHeaderData %>");
    	$("#txtSubject").val(strSubject.replace( /##/gi, "\r\n"));
    	$("#optSource").val("<%=strSourceData %>");
    	$("#hidSource").val("<%=strSourceData %>");
    	$("#txtNewsDate").val("<%=strNewsDateData %>");
    	$("#hidBlob").val("<%=strBlobData %>");
    	$("#hidBlobPart").val("<%=strPictData %>");
    	$("#hidBlobMedia").val("<%=strBlobMediaData %>");
    	$("#hidBlobMediaPart").val("<%=strPictMediaData %>");
    }
}

function set_message(){
    
<%  if (!strmsg.equals("")) {  %>
    <%=strmsg%>
<%  }   %>
}

function getValueSource() {
    var sourceIndex = $("#optSource option:selected").index();
    var sourceValue = $("#optSource").val();

    if( sourceIndex == 0 ) {
        $("#hidSource").val("");
    }else {
        $("#hidSource").val(sourceValue);
    }
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

function set_format_date( obj_field ){
    if( obj_field.value.length == 8 && sccUtils.isDateValid( obj_field.value ) == "VALID_DATE" ){
        obj_field.value = sccUtils.formatDate( obj_field.value );
    }else {
        if( obj_field.value != "" && sccUtils.isDateValid( obj_field.value ) != "VALID_DATE" ){
            alert( lc_fill_date_correct );
            obj_field.value = "";
            obj_field.focus();
        }
    }
}

function verify_form() {
    if( $("#txtHeader").val().length == 0 ) {
        alert( lc_news_check_header );
        $("#txtHeader").focus();
        return false;
    }else {
    	$("#txtHeader").val($("#txtHeader").val().replace(/'/g,"''"));
    }
    
    if( $("#txtSubject").val().length == 0 ) {
        alert( lc_news_check_subject );
        $("#txtSubject").focus();
        return false;
    }else {
        $("#txtSubject").val($("#txtSubject").val().replace(/'/g,"''"));
    }

    if( $("#hidSource").val().length == 0 ) {
        alert( lc_news_check_source );
        $("#optSource").focus();
        return false;
    }

    if( $("#txtNewsDate").val().length == 0 ) {
    	alert( lc_fill_date_correct );
    	$("#txtNewsDate").focus();
        return false;
    }

    $("#txtNewsDate").val(dateToDb($("#txtNewsDate").val()));
	return true;
}

function buttonClick( lv_strMethod ){
    switch( lv_strMethod ){
        case "save" :
            if(verify_form()){
                if($("#MODE").val() == "pInsert"){
                    $("#MODE").val("ADD");
                }else{
                    $("#MODE").val("EDIT");
                }
                $("#form1").submit();
            }
            break;
        case "cancel" :
            $("#form1").attr('action', "news1.jsp");
            $("#form1").attr('target', "_self");
            $("#CURRENT_PAGE").val($("#current_page_parent").val());
            $("#sortfield").val($("#sortfield_parent").val());
            $("#sortby").val($("#sortby_parent").val());
            $("#MODE").val($("#mode_parent").val());
            $("#form1").submit();
            break;
    }
}

function openShowView( str_type ){
    initAndShow( str_type );
    inetdocview.SetProperty("CloseWhenSave", "true");
    retrieveImage( str_type );
}

function initAndShow(str_type){
    var x,y,w,h, sessionId;
    x = screen.width /2;
    y = 0;
    w = screen.width;
    h = screen.height;
    inetdocview.Close();
    sessionId = inetdocview.Open();
    inetdocview.Resize(x, y, w, (h-30));
    inetdocview.ContainerType("<%=strContainerType%>");
    
    set_file_property(str_type);
}

function retrieveImage( str_type ){    
    var strBlobId   = "";
    var strBlobPart = "";
    
    $("#hidDocType").val(str_type);
    
    if( str_type == "1" && $("#hidBlob").val() != "" ) {
        strBlobId   = $("#hidBlob").val();
        strBlobPart = $("#hidBlobPart").val();
    }else if( str_type == "2" && $("#hidBlobMedia").val() != "" ) {
        strBlobId   = $("#hidBlobMedia").val();
        strBlobPart = $("#hidBlobMediaPart").val();
    }
    
    if ((strBlobId != "") && (strBlobPart != "")){
        inetdocview.Retrieve(strBlobId, strBlobPart);
    }
}


function afterCheck(msg){
    var message_check;

    if(msg.indexOf("not allow") != -1){
        message_check = lc_check_file_type;
        alert(message_check);
    }
}

function set_file_property( lv_index ){
    var arrType;
    var types;

    if( lv_index == "1" ) {
            types = "JPG,GIF,PNG";
    }else if( lv_index == "2" ) {
            types = "XLS,DOC,PPT,TXT,PDF";
    }

    inetdocview.SetProperty("ADDTYPESIZE","Null");

    arrType = types.split(",");
    for(var idx=0; idx<arrType.length; idx++){
        inetdocview.SetProperty("ADDTYPESIZE",arrType[idx]);
    }
}

function afterSaveFinish( strBlobId, strBlobPart ) {
    var strType = $("#hidDocType").val();
    if( strType == "1" ) {
        $("#hidBlob").val(strBlobId);
        $("#hidBlobPart").val(strBlobPart);
    }else {
        $("#hidBlobMedia").val(strBlobId);
        $("#hidBlobMediaPart").val(strBlobPart);
    }
}

function limitText(limitField, limitNum) {
    if( limitField.value.length > limitNum ) {
        alert( lc_news_check_area_size );
        limitField.value = limitField.value.substring( 0, limitNum );
    } 
}

function deleteDocType( lv_type ) {
    if( lv_type == "blob" ){
        $("#hidBlob").val("");
        $("#hidBlobPart").val("");
    }else {
        $("#hidBlobMedia").val("");
        $("#hidBlobMediaPart").val("");
    }
}

//-->
</script>
<link href="css/edas.css" type="text/css" rel="stylesheet">
</head>
<body onLoad="MM_preloadImages('images/btt_save2_over.gif','images/btt_cancel_over.gif');">
<form id="form1" name="form1" method="post" action="" >
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0" align="center">
    <tr>
        <td valign="top">
            <table width="800" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td height="25" class="label_header01" colspan="2">&nbsp;&nbsp;<%=screenname%>&nbsp; >> &nbsp;<%=screenLabel %></td>
                </tr>
                <tr>
                    <td width="30">&nbsp;</td>
                    <td height="25" align="left">
            		<table width="622" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td height="25" colspan="2">&nbsp;</td>
                            </tr>
                            <tr>
                                <td height="25" class="label_bold2" width="110"><span id="lb_code"></span>&nbsp;<img src="images/mark.gif" width="12" height="11"></td>
                                <td height="25">
                                    <input id="txtNewsId" name="txtNewsId" type="text" class="input_box_disable" size="15" maxlength="12" readonly >
                                </td>
                            </tr>
                            <tr>
                                <td height="25" class="label_bold2"><span id="lb_news_header"></span>&nbsp;<img src="images/mark.gif" width="12" height="11"></td>
                                <td height="25">
                                    <input id="txtHeader" name="txtHeader" type="text" class="input_box" size="75" maxlength="200">
                                </td>
                            </tr>
                            <tr>
                                <td height="25" class="label_bold2" valign="top"><span id="lb_news_subject"></span>&nbsp;<img src="images/mark.gif" width="12" height="11"></td>
                                <td height="25">
                                    <textarea rows="4" cols="80" id="txtSubject" name="txtSubject" class="input_box" onKeyDown="limitText(this,4000);" onKeyUp="limitText(this,4000);"></textarea>
                                </td>
                            </tr>
<%
		String strTagSourceOption = "";
		String strSource          = "";
		String strSourceName      = "";
		strTagSourceOption = "\n<select id=\"optSource\" name=\"optSource\" class=\"combobox\" onchange=\"getValueSource();\">";
		strTagSourceOption += "\n<option value=\"\"></option>";
		
		bolnZoomSuccess = con1.executeService( strContainerName, strClassName, "findSourceCombo" );
		if( bolnZoomSuccess ){
			while( con1.nextRecordElement() ){
				strSource     = con1.getColumn( "EDAS_SOURCE" );
				strSourceName = con1.getColumn( "EDAS_SOURCE_NAME" );
		
				strTagSourceOption += "\n<option value=\"" + strSource + "\">" + strSourceName + "</option>";
			}
		}
		strTagSourceOption += "\n</select>";
%>
                            <tr>
                                <td height="25" class="label_bold2"><span id="lb_news_source"></span>&nbsp;
                                    <img src="images/mark.gif" width="12" height="11">
                                </td>
                                <td height="25"><%=strTagSourceOption %>
                                    <input id="hidSource" name="hidSource" type="hidden" value"">
                                </td>
                            </tr>
                            <tr>
                                <td height="25" class="label_bold2"><span id="lb_news_date"></span>&nbsp;<img src="images/mark.gif" width="12" height="11"></td>
                                <td>
                                    <input id="txtNewsDate" name="txtNewsDate" type="text" class="input_box" size="10" maxlength="10" onkeypress="keypress_number();" onBlur="set_format_date( this );"> 
                                    <a href="javascript:showCalendar(form1.txtNewsDate,<%=strLangFlag %>)"><img src="images/calendar.gif" width=16 height=16 align="absmiddle" border=0 ></a>
                                </td>
                            </tr>
                            <tr>
                                <td height="25" class="label_bold2" colspan="2"><span id="lb_doc_type_name"></span></td>
                            </tr>
                            <tr>
                                <td height="25" class="label_bold2" >
                                    <li><span id="lb_news_pict" class="label_bold2"></span></li>
                                </td>
                                <td class="label_bold2">
                                    <input type="text" id="hidBlob" name="hidBlob" value="" size="40" class="input_box_disable" readonly >&nbsp;
                                    <input type="text" id="hidBlobPart" name="hidBlobPart" value="" size="2" class="input_box_disable" readonly >&nbsp;
                                    <a href="javascript:openShowView('1')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('btt_attached_1','','images/btt_attached_over.gif',1)"><img src="images/btt_attached.gif" name="btt_attached_1" width="67" height="22" border="0" align="absmiddle" title="JPG,GIF,PNG"></a>&nbsp;&nbsp;
                                    <label id="clearBlob" style="height: 20px;cursor:pointer"><img src="images/clear.gif" width="18" height="18" border="0" onclick="deleteDocType('blob')"></label>&nbsp;
                                </td>
                            </tr>
                            <tr>
                                <td height="25" class="label_bold2">
                                    <li><span id="lb_news_blob" class="label_bold2"></span></li>
                                </td>
                                <td class="label_bold2">
                                    <input type="text" id="hidBlobMedia" name="hidBlobMedia" value="" size="40" class="input_box_disable" readonly >&nbsp;
                                    <input type="text" id="hidBlobMediaPart" name="hidBlobMediaPart" value="" size="2" class="input_box_disable" readonly >&nbsp;
                                    <a href="javascript:openShowView('2')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('btt_attached_2','','images/btt_attached_over.gif',1)"><img src="images/btt_attached.gif" name="btt_attached_2" width="67" height="22" border="0" align="absmiddle" title="XLS,DOC,PPT,TXT,PDF"></a>&nbsp;&nbsp;
                                    <label id="clearMedia" style="height: 20px;cursor: pointer"><img src="images/clear.gif" width="18" height="18" border="0" onclick="deleteDocType('media')"></label>&nbsp;
                                </td>
                            </tr>
                            <tr>
                                <td height="25" colspan="2">&nbsp;</td>
                            </tr>
                            <tr>
                                <td align="center" colspan="2">
                                    <a href="#" onclick= "buttonClick('save')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('save','','images/btt_save2_over.gif',1)"><img src="images/btt_save2.gif" name="save" width="67" height="22" border="0"></a>&nbsp;
                                    <a href="#" onclick= "buttonClick('cancel')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('cancel','','images/btt_cancel_over.gif',1)"><img src="images/btt_cancel.gif" name="cancel" width="67" height="22" border="0"></a>
                                </td>
                            </tr>
              		</table>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>
<input type="hidden" id="MODE"        name="MODE"        value="<%=strMode%>">
<input type="hidden" id="screenname"  name="screenname"  value="<%=screenname%>">
<input type="hidden" id="screenLabel" name="screenLabel" value="<%=screenLabel%>">
<input type="hidden" id="sortby"      name="sortby"      value="<%=sortby%>">
<input type="hidden" id="sortfield"   name="sortfield"   value="<%=sortfield%>">

<input type="hidden" id="mode_parent"         name="mode_parent"         value="<%=mode_parent%>">
<input type="hidden" id="CURRENT_PAGE"        name="CURRENT_PAGE"        value="">
<input type="hidden" id="current_page_parent" name="current_page_parent" value="<%=current_page_parent%>">
<input type="hidden" id="sortby_parent"       name="sortby_parent"       value="<%=sortby_parent%>">
<input type="hidden" id="sortfield_parent"    name="sortfield_parent"    value="<%=sortfield_parent%>">

<input type="hidden" id="PERMIT_FUNCTION" name="PERMIT_FUNCTION" value="<%=strPermission%>">
<input type="hidden" id="hidDocType"      name="hidDocType"      value="">
<input type="hidden" id="hidBlobId1"      name="hidBlobId1"      value="">
<input type="hidden" id="hidBlobPart1"    name="hidBlobPart1"    value="">
<input type="hidden" id="hidBlobId2"      name="hidBlobId2"      value="">
<input type="hidden" id="hidBlobPart2"    name="hidBlobPart2"    value="">
</form>
<iframe scrolling="no" frameborder="0" name="inetdocview" src="/jinetdocarchive/imageproxy?codetype=applet&version=15&securecode=<%=securecode%>" width="32" height="32" marginwidth="0">
</iframe>
</body>
</html>