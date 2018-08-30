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

    UserInfo userInfo       = (UserInfo)session.getAttribute( "USER_INFO" );
    String   strUserId      = userInfo.getUserId();

    String screenname          = getField(request.getParameter("screenname"));
    String screenLabel         = getField(request.getParameter("screenLabel"));
    String strClassName        = "FAQ_MANAGER";
    String strMode             = checkNull(request.getParameter("MODE"));
    String mode_parent         = checkNull(request.getParameter( "mode_parent" ));
    String current_page_parent = checkNull(request.getParameter( "current_page_parent" ));
    String sortby_parent       = checkNull(request.getParameter( "sortby_parent" ));
    String sortfield_parent    = checkNull(request.getParameter( "sortfield_parent" ));
    String sortby              = "";
    String sortfield           = "";
    
    String strFaqIdKey    = checkNull(request.getParameter("FAQ_ID_KEY"));
    String strFaqIdData   = checkNull( request.getParameter("txtFaqId") );
    String strFaqSubjData = getField( request.getParameter("txtFaqSubj") );
    String strFaqDescData = getField( request.getParameter("txtFaqDesc") );
    String strFaqAnsData  = getField( request.getParameter("txtFaqAns") );
    String strFaqDateData = getField( request.getParameter("txtFaqDate") );
    
    String strVersionLang = ImageConfUtil.getVersionLang();
    
    boolean bolnSuccess    = false;
    String  strmsg         = "";
    String  strCurrentDate = "";
    String  strLangFlag    = "";

    if( strVersionLang.equals("thai") ) {
        strCurrentDate = getServerDateThai();
        strLangFlag = "1";
    }else {
        strCurrentDate = getServerDateEng();
        strLangFlag = "0";
    }
    
    if( strMode == null ){
        strMode = "SEARCH";
    }

    if( strMode.equals( "pInsert" ) ) {
        screenLabel = lb_add_faq;
		
    }else if( strMode.equals( "pEdit" ) ) {
    	screenLabel = lb_edit_faq;
    	
    	con.addData( "FAQ_ID", "String", strFaqIdKey);
        bolnSuccess = con.executeService( strContainerName , strClassName , "selectFaqForEdit" );
        if( bolnSuccess ) {
            strFaqIdData   = strFaqIdKey;
            strFaqSubjData = con.getHeader( "FAQ_SUBJ" );
            strFaqDescData = con.getHeader( "FAQ_DESC" );
            strFaqAnsData  = con.getHeader( "FAQ_ANSWER" );
            strFaqDateData = con.getHeader( "FAQ_DATE" );

            strFaqSubjData = strFaqSubjData.replaceAll( "\"" , "\\\\\"" );
            strFaqDescData = strFaqDescData.replaceAll( "\"" , "\\\\\"" );
            strFaqAnsData  = strFaqAnsData.replaceAll( "\"" , "\\\\\"" );

            strFaqDateData = dateToDisplay( strFaqDateData, "/" );
        }
    }

    if( strMode.equals("ADD") ) {
    	strFaqSubjData = strFaqSubjData.replaceAll( "\\r\\n", "##" );
    	strFaqDescData = strFaqDescData.replaceAll( "\\r\\n", "##" );
    	strFaqAnsData  = strFaqAnsData.replaceAll( "\\r\\n", "##" );
    	
        con.addData( "FAQ_ID",     "String", strFaqIdData );
        con.addData( "FAQ_SUBJ",   "String", strFaqSubjData );
        con.addData( "FAQ_DESC",   "String", strFaqDescData );
        con.addData( "FAQ_ANSWER", "String", strFaqAnsData );
        con.addData( "FAQ_DATE",   "String", strFaqDateData );
        con.addData( "ADD_USER",   "String", strUserId );
        con.addData( "ADD_DATE",   "String", strCurrentDate );
        con.addData( "UPD_USER",   "String", strUserId );
        
        con.addData( "DESC",         "String", strFaqIdData + "-" + strFaqSubjData );
     	con.addData( "USER_ID",      "String", strUserId );
        con.addData( "ACTION_FLAG",  "String", "AF" );
        con.addData( "CURRENT_DATE", "String", strCurrentDate);

        bolnSuccess    = con.executeService( strContainerName , strClassName , "insertFaqManager" );
        strFaqSubjData = strFaqSubjData.replaceAll( "\"" , "\\\\\"" );
    	strFaqDescData = strFaqDescData.replaceAll( "\"" , "\\\\\"" );
    	strFaqAnsData  = strFaqAnsData.replaceAll( "\"" , "\\\\\"" );
    	
        if( !bolnSuccess ) {
            strmsg="showMsg(0,0,\" " + lc_can_not_insert_faq + "\")";
            strMode = "pInsert";
        }else{
            strmsg="showMsg(0,0,\" " +  lc_insert_faq_successfull + "\")";
            strMode = "MAIN";
        }
		
    }else if( strMode.equals("EDIT") ) {
    	strFaqSubjData = strFaqSubjData.replaceAll( "\\r\\n", "##" );
    	strFaqDescData = strFaqDescData.replaceAll( "\\r\\n", "##" );
    	strFaqAnsData  = strFaqAnsData.replaceAll( "\\r\\n", "##" );
    	
        con.addData( "FAQ_ID",     "String", strFaqIdData );
        con.addData( "FAQ_SUBJ",   "String", strFaqSubjData );
        con.addData( "FAQ_DESC",   "String", strFaqDescData );
        con.addData( "FAQ_ANSWER", "String", strFaqAnsData );
        con.addData( "FAQ_DATE",   "String", strFaqDateData );
        con.addData( "EDIT_USER",  "String", strUserId );
        con.addData( "EDIT_DATE",  "String", strCurrentDate );
        con.addData( "UPD_USER",   "String", strUserId );
        
        con.addData( "DESC",  		 "String", strFaqIdData + "-" + strFaqSubjData );
     	con.addData( "USER_ID",  	 "String", strUserId );
        con.addData( "ACTION_FLAG",  "String", "EF" );
        con.addData( "CURRENT_DATE", "String", strCurrentDate);

		bolnSuccess    = con.executeService( strContainerName, strClassName, "updateFaqManager" );
		strFaqSubjData = strFaqSubjData.replaceAll( "\"" , "\\\\\"" );
    	strFaqDescData = strFaqDescData.replaceAll( "\"" , "\\\\\"" );
    	strFaqAnsData  = strFaqAnsData.replaceAll( "\"" , "\\\\\"" );
        if( !bolnSuccess ){
            strmsg="showMsg(0,0,\" " + lc_can_not_update_faq  + "\")";
            strMode = "pEdit";
		}else {
            strmsg="showMsg(0,0,\" " + lc_edit_faq_successfull + "\")";
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
<script language="JavaScript" src="js/label/lb_faq.js"></script>
<script language="JavaScript" src="js/sccUtils.js"></script>
<script language="JavaScript" src="js/util.js"></script>
<script language="JavaScript" src="js/constant.js"></script>
<script language="JavaScript" type="text/javascript">
<!--

var sccUtils   = new SCUtils();
var mode       = "<%=strMode%>";
var strCurDate = "<%=strCurrentDate %>";

$(document).ready(window_onload);

function window_onload(){
    set_label();
    set_init();
    set_message();
}

function set_label(){
    $("#lb_faq_code").text(lbl_faq_code);
    $("#lb_faq_subj").text(lbl_faq_subj);
    $("#lb_faq_detail").text(lbl_faq_detail);
    $("#lb_faq_answer").text(lbl_faq_answer);
    $("#lb_faq_date").text(lbl_faq_date);
}

function set_init(){
	var faq_subj = "<%=strFaqSubjData %>";
	var faq_desc = "<%=strFaqDescData %>";
	var faq_ans  = "<%=strFaqAnsData %>";    
    
    if( mode == "MAIN" ) {
        $("#form1").attr('action', "faq1.jsp");
        $("#form1").attr('target', "_self");
        $("#CURRENT_PAGE").val($("#current_page_parent").val());
        $("#sortfield").val($("#sortfield_parent").val());
        $("#sortby").val($("#sortby_parent").val());
        $("#MODE").val($("#mode_parent").val());
        $("#form1").submit();
    }else if( mode == "pEdit" ) {
    	$("#txtFaqId").val("<%=strFaqIdData %>");
    	$("#txtFaqSubj").val(faq_subj.replace( /##/gi , "\r\n" ));
    	$("#txtFaqDesc").val(faq_desc.replace( /##/gi , "\r\n" ));
    	$("#txtFaqAns").val(faq_ans.replace( /##/gi , "\r\n" ));
    	$("#txtFaqDate").val("<%=strFaqDateData %>");
    }
}

function set_message(){
    
<%  if (!strmsg.equals("")) {  %>
    <%=strmsg%>
<%  }   %>
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
    var faqDate = dateToDb( $("#txtFaqDate").val() );
    if( $("#txtFaqSubj").val().length == 0 ) {
        alert( lc_faq_check_subj );
        $("#txtFaqSubj").focus();
        return false;
    }else {
    	$("#txtFaqSubj").val($("#txtFaqSubj").val().replace(/'/g,"''"));
    }
    
    if( $("#txtFaqDesc").val().length == 0 ) {
        alert( lc_faq_check_desc );
        $("#txtFaqDesc").focus();
        return false;
    }else {
        $("#txtFaqDesc").val($("#txtFaqDesc").val().replace(/'/g,"''"));
    }
    
    if( $("#txtFaqAns").val().length == 0 ) {
        alert( lc_faq_check_ans );
        $("#txtFaqAns").focus();
        return false;
    }else {
        $("#txtFaqAns").val($("#txtFaqAns").val().replace(/'/g,"''"));
    }

    if( $("#txtFaqDate").val().length == 0 ) {
    	alert( lc_fill_date_correct );
    	$("#txtFaqDate").focus();
        return false;
    }

    if( faqDate > strCurDate ) {
    	alert( lc_verify_check_date );
    	$("#txtFaqDate").focus();
        return false;
    }

    $("#txtFaqDate").val(dateToDb($("#txtFaqDate").val()));
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
            $("#form1").attr('action', "faq1.jsp");
            $("#form1").attr('target', "_self");
            $("#CURRENT_PAGE").val($("#current_page_parent").val());
            $("#sortfield").val($("#sortfield_parent").val());
            $("#sortby").val($("#sortby_parent").val());
            $("#MODE").val($("#mode_parent").val());
            $("#form1").submit();
            break;
    }
}

function limitText(limitField, limitNum) {
    if( limitField.value.length > limitNum ) {
        alert( lc_news_check_area_size );
        limitField.value = limitField.value.substring( 0, limitNum );
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
                    <td width="30" >&nbsp;</td>
                    <td height="25" align="left">
            		<table width="622" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td height="25" colspan="4">&nbsp;</td>
                            </tr>
                            <tr>
                                <td height="25" class="label_bold2" width="110"><span id="lb_faq_code"></span>&nbsp;<img src="images/mark.gif" width="12" height="11"></td>
                                <td height="25" colspan="3">
                                    <input id="txtFaqId" name="txtFaqId" type="text" class="input_box_disable" size="40" maxlength="12" readonly >
                                </td>
                            </tr>
                            <tr>
                                <td height="25" class="label_bold2" valign="top"><span id="lb_faq_subj"></span>&nbsp;<img src="images/mark.gif" width="12" height="11"></td>
                                <td height="25" colspan="3" style="padding-bottom: 5px;">
                                    <textarea rows="3" cols="80" id="txtFaqSubj" name="txtFaqSubj" class="input_box_multi" onKeyDown="limitText(this,200);" onKeyUp="limitText(this,200);"></textarea>
                                </td>
                            </tr>
                            <tr>
                                <td height="25" class="label_bold2" valign="top"><span id="lb_faq_detail"></span>&nbsp;<img src="images/mark.gif" width="12" height="11"></td>
                                <td height="25" colspan="3" style="padding-bottom: 5px;">
                                    <textarea rows="5" cols="80" id="txtFaqDesc" name="txtFaqDesc" class="input_box_multi" onKeyDown="limitText(this,4000);" onKeyUp="limitText(this,4000);"></textarea>
                                </td>
                            </tr>
                            <tr>
                                <td height="25" class="label_bold2" valign="top"><span id="lb_faq_answer"></span>&nbsp;<img src="images/mark.gif" width="12" height="11"></td>
                                <td height="25" colspan="3" >
                                    <textarea rows="5" cols="80" id="txtFaqAns" name="txtFaqAns" class="input_box_multi" onKeyDown="limitText(this,4000);" onKeyUp="limitText(this,4000);"></textarea>
                                </td>
                            </tr>
                            <tr>
                                <td height="25" class="label_bold2"><span id="lb_faq_date"></span>&nbsp;<img src="images/mark.gif" width="12" height="11"></td>
                                <td colspan="3">
                                    <input id="txtFaqDate" name="txtFaqDate" type="text" class="input_box" size="10" maxlength="10" onkeypress="keypress_number();" onBlur="set_format_date( this );"> 
                                    <a href="javascript:showCalendar(form1.txtFaqDate,<%=strLangFlag %>)">
                                        <img src="images/calendar.gif" width=16 height=16 align="absmiddle" border=0 ></a>
                                </td>
                            </tr>
                            <tr>
                                <td height="25" colspan="4">&nbsp;</td>
                            </tr>
                            <tr>
                                <td align="center" colspan="4">
                                    <a href="#" onclick= "buttonClick('save')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('save','','images/btt_save2_over.gif',1)">
                                        <img src="images/btt_save2.gif" name="save" width="67" height="22" border="0"></a>&nbsp;
                                    <a href="#" onclick= "buttonClick('cancel')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('cancel','','images/btt_cancel_over.gif',1)">
                                        <img src="images/btt_cancel.gif" name="cancel" width="67" height="22" border="0"></a>
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
</form>
</body>
</html>