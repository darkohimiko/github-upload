<%@page import="com.scc.edms.conf.ImageConfUtil"%>
<%@ page contentType="text/html; charset=tis-620"%>
<%@ page import="com.scc.security.UserInfo"%>
<%@ include file="inc/checkUser.jsp" %>
<%@ include file="inc/constant.jsp" %>
<%@ include file="inc/label.jsp" %>
<%@ include file="inc/utils.jsp" %>
<jsp:useBean id="con" scope="session" class="edms.cllib.EABConnector"/>
<%
    con.setRemoteServer("EAS_SERVER");

    UserInfo userInfo = (UserInfo)session.getAttribute( "USER_INFO" );
    String  strUserId = userInfo.getUserId();

    String screenname   = getField(request.getParameter("screenname"));
    String screenLabel  = getField(request.getParameter("screenLabel"));
    String strClassName = "USER_ROLE";
    String strMode      = getField(request.getParameter("MODE"));
    
    String strUserRoleKey = getField(request.getParameter("USER_ROLE_KEY"));
    String strRoleNameKey = getField(request.getParameter("ROLE_NAME_KEY"));
    String strRoleTypeKey = getField(request.getParameter("ROLE_TYPE_KEY"));

    String strUserRoleData = getField(request.getParameter("txtUserRole"));
    String strRoleNameData = getField(request.getParameter("txtRoleName"));
    String strRoleTypeData = getField(request.getParameter("hidRoleType"));
    
    boolean bolnSuccess = true;
    
    String strErrorCode    = null;
    String strmsg          = "";
    String strCurrentDate  = "";
    String nextUserRole    = "";
    String strVersionLang  = ImageConfUtil.getVersionLang();

    if( strVersionLang.equals("thai") ) {
            strCurrentDate = getServerDateThai();
    }else {
            strCurrentDate = getServerDateEng();
    }
	
    if( strMode == null ){
        strMode = "SEARCH";
    }

    if( strMode.equals( "pInsert" ) ) {
        screenLabel = lb_new_user_role;
        bolnSuccess = con.executeService( strContainerName , strClassName , "selectMaxUserRole" );
        if( bolnSuccess ) {
            nextUserRole = con.getHeader("MAX");
            if( nextUserRole == null || nextUserRole.equals("") ) {
                    nextUserRole = "00000001";
            }else {
                    nextUserRole = "0000000" + nextUserRole;
            }
            nextUserRole = nextUserRole.substring(nextUserRole.length()-8,nextUserRole.length());
        }
    }else if( strMode.equals( "pEdit" ) ) {
    	screenLabel     = lb_edit_user_role;
    	strUserRoleData = strUserRoleKey;
    	strRoleNameData = strRoleNameKey;
    	strRoleTypeData = strRoleTypeKey;
    }

    if( strMode.equals("ADD") ) {
        con.addData( "USER_ROLE", "String", strUserRoleData );
        con.addData( "ROLE_NAME", "String", strRoleNameData );
        con.addData( "ROLE_TYPE", "String", strRoleTypeData );
        con.addData( "ADD_USER",  "String", strUserId );
        con.addData( "ADD_DATE",  "String", strCurrentDate );
        con.addData( "UPD_USER",  "String", strUserId );
        
        con.addData( "DESC",         "String", "[" + strRoleTypeData + "]" + strUserRoleData + "-" + strRoleNameData );
     	con.addData( "USER_ID",      "String", strUserId );
        con.addData( "ACTION_FLAG",  "String", "AR" );
        con.addData( "CURRENT_DATE", "String", strCurrentDate);

        bolnSuccess = con.executeService( strContainerName , strClassName , "insertUserRole" );
        if( !bolnSuccess ){
            strErrorCode    = con.getRemoteErrorCode();
            if(strErrorCode.equals("ERR00002")){
                strmsg  = "showMsg(0,0,\" " + lc_system_table_dup + "\")";
                strMode = "pInsert";
            }else{
                strmsg  = "showMsg(0,0,\" " + lc_can_not_insert_user_role + "\")";
                strMode = "pInsert";
            }
        }else{
            strmsg  = "showMsg(0,0,\" " +  lc_insert_user_role_successfull + "\")";
            strMode = "MAIN";
        }
     }else if( strMode.equals("EDIT") ) {
         con.addData( "USER_ROLE", "String", strUserRoleData );
         con.addData( "ROLE_NAME", "String", strRoleNameData );
         con.addData( "ROLE_TYPE", "String", strRoleTypeData );
         con.addData( "EDIT_USER", "String", strUserId );
         con.addData( "EDIT_DATE", "String", strCurrentDate );
         con.addData( "UPD_USER",  "String", strUserId );
         
         con.addData( "DESC",         "String", "[" + strRoleTypeData + "]" + strUserRoleData + "-" + strRoleNameData );
      	 con.addData( "USER_ID",      "String", strUserId );
         con.addData( "ACTION_FLAG",  "String", "ER" );
         con.addData( "CURRENT_DATE", "String", strCurrentDate);

        bolnSuccess = con.executeService( strContainerName , strClassName , "updateUserRole"  );
        if( !bolnSuccess ){
            strErrorCode = con.getRemoteErrorCode();
            strmsg  = "showMsg(0,0,\" " + lc_can_not_update_data  + "\")";
            strMode = "pEdit";
        }else{
            strmsg  = "showMsg(0,0,\" " + lc_edit_user_role_successfull + "\")";
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
<script language="JavaScript" src="js/label/lb_user_role.js"></script>
<script language="JavaScript" src="js/util.js"></script>
<script language="JavaScript" src="js/constant.js"></script>
<script language="JavaScript" type="text/javascript">
<!--
var mode = "<%=strMode%>";

$(document).ready(window_onload);

function window_onload() {
    set_label();
    set_init(); 
    set_message(); 
}

function set_label(){
    $("#lb_user_role").text(lbl_role_code);
    $("#lb_role_name").text(lbl_role_name);
    $("#lb_role_type").text(lbl_role_type);
    $("#lb_role_admin").text(lbl_role_admin);
    $("#lb_role_user").text(lbl_role_user);
}

function set_init(){
    if( mode == "MAIN" ) {
        $("#form1").attr('action', "user_role1.jsp");
        $("#form1").attr('target', "_self");
        $("#MODE").val("SEARCH");
        $("#form1").submit();
    }else if( mode == "pEdit" ) {
    	$("#txtUserRole").val("<%=strUserRoleData %>");
    	$("#txtRoleName").val("<%=strRoleNameData %>");
    	$("#hidRoleType").val("<%=strRoleTypeData %>");
    	check_roletype_onload( "<%=strRoleTypeData %>" );
    }else if( mode == "pInsert" ) {
    	$("#txtUserRole").val("<%=nextUserRole %>");
    	$("#txtRoleName").focus();
    }
}

function set_message(){
    
<%  if (!strmsg.equals("")) {  %>
    <%=strmsg%>
<%  }   %>
}

function verify_form() {
    if( $("#hidRoleType").val().length == 0 ) {
        alert( lc_check_role_type );
        return false;
    }
    if( $("#txtRoleName").val().length == 0 ) {
        alert( lc_check_role_name );
        $("#txtRoleName").focus();
        return false;
    }
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
            $("#form1").attr('action', "user_role1.jsp");
            $("#form1").attr('target', "_self");
            $("#MODE").val("SEARCH");
            $("#form1").submit();
                break;
    }
}

function check_roletype_onload( lv_value ) {
    if( lv_value == "A" ) {
            $("#rdoRoleType1").prop('checked', true);
    }else {
            $("#rdoRoleType2").prop('checked', true);
    }
    $("#rdoRoleType1").prop('disabled', true);
    $("#rdoRoleType2").prop('disabled', true);
}

function get_radio_value( lv_roleType ) {	
    if( lv_roleType == "A" ) {
        $("#hidRoleType").val(lv_roleType);
    }else {
        $("#hidRoleType").val(lv_roleType);
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
                    <td width="25">&nbsp;</td>
                    <td height="25" align="left">
            		<table width="420" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td height="25" colspan="4">&nbsp;</td>
                            </tr>
                            <tr>
                                <td height="25" class="label_bold2"><span id="lb_role_type"></span>&nbsp;<img src="images/mark.gif" width="12" height="11"></td>
                                <td height="25" class="label_bold2" colspan="3">
                                    <input type="radio" id="rdoRoleType1" name="rdoRoleType" onclick="get_radio_value('A');"><span id="lb_role_admin"></span>
                                    <input type="radio" id="rdoRoleType2" name="rdoRoleType" onclick="get_radio_value('U');"><span id="lb_role_user"></span>
                                    <input type="hidden" id="hidRoleType" name="hidRoleType" value="" >
                                </td>
                            </tr>
                            <tr>
                                <td height="25" class="label_bold2"><span id="lb_user_role"></span>&nbsp;<img src="images/mark.gif" width="12" height="11"></td>
                                <td height="25" colspan="3">
                                    <input id="txtUserRole" name="txtUserRole" type="text" class="input_box_disable" size="8" maxlength="8" readOnly>
                                </td>
                            </tr>
                            <tr>
                                <td height="25" class="label_bold2"><span id="lb_role_name"></span>&nbsp;<img src="images/mark.gif" width="12" height="11"></td>
                                <td height="25" colspan="3">
                                    <input id="txtRoleName" name="txtRoleName" type="text" class="input_box" size="45" maxlength="50">
                                </td>
                            </tr>
                            <tr>
                                <td height="25" colspan="4">&nbsp;</td>
                            </tr>
                            <tr>
                                <td align="center" colspan="4">
                                    <a href="#" onclick= "buttonClick('save')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('save','','images/btt_save2_over.gif',1)">
                                        <img src="images/btt_save2.gif" name="save" width="67" height="22" border="0"></img></a>&nbsp;
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
<input type="hidden" id="MODE"       name="MODE"     value="<%=strMode%>">
<input type="hidden" id="screenname" name="screenname" value="<%=screenname%>">
<input type="hidden" id="screenLabel" name="screenLabel" value="<%=screenLabel%>">
</form>
</body>
</html>