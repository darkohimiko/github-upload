<%@ page contentType="text/html; charset=tis-620"%>
<%@ include file="inc/constant.jsp" %>
<%@ include file="inc/utils.jsp" %>
<%
	boolean bolSuccess = false; 
	String strSuccessMsg = getField(request.getParameter("SUCCESS_MESSAGE"));
	String strErrMsg = checkNull(request.getParameter("ERROR_MESSAGE"));
	
        if(strErrMsg.equals("USER_PASS_NOT_CORRECT")){
            strErrMsg= lc_user_pass_not_correct;
        }else if (strErrMsg.equals("USER_NOT_UPDATE")){
            strErrMsg = lc_user_cannot_update;
        }else if (strSuccessMsg.equals("CHANGE_SUCCESS")){
            strErrMsg = lc_success_change_password;
        }
        
	if(!strSuccessMsg.equals("")){
		bolSuccess = true;	
	}
	
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title><%=lc_system_name%> <%=lc_site_name%></title>
<meta http-equiv="Content-Type" content="text/html; charset=tis-620">
<link rel="shortcut icon" href="images/favicon/EDAS.ico" type="image/x-icon" />
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
<script language="JavaScript" src="js/util.js"></script>
<script language="JavaScript" src="js/constant.js"></script>
<script language="JavaScript" src="js/sccUtils.js"></script>
<script language="JavaScript" src="js/jquery-1.9.1.js"></script>
<script language="JavaScript" type="text/JavaScript">
<!--
var sccUtils = new SCUtils;
    
function window_onload() {
<%	if( !strErrMsg.equals( "" ) ){ %>
    alert("<%=strErrMsg.replaceAll( "\"" , "'" ).replaceAll( "\r" , "" ).replaceAll( "\n" , "<br>" )%>");
<% 	}%>
	
<% if(bolSuccess){%>
        alert("<%=strSuccessMsg.replaceAll( "\"" , "'" ).replaceAll( "\r" , "" ).replaceAll( "\n" , "<br>" )%>");
    window.location = "index.jsp";
<% }%>
    form1.USER_ID.focus();    
    
    $("#USER_ID").keypress(function(e){
        if(e.keyCode==13){
            $("#OLD_PASSWORD").focus();
        }
    });
    $("#OLD_PASSWORD").keypress(function(e){
        if(e.keyCode==13){
            $("#NEW_PASSWORD").focus();
        }
    });
    $("#NEW_PASSWORD").keypress(function(e){
        if(e.keyCode==13){
            $("#RE_PASSWORD").focus();
        }
    });
    
    $("#RE_PASSWORD").keypress(function(e){
        if(e.keyCode==13){
            buttonClick('OK');
        }
    });
}     
    
function buttonClick( lv_strButton ) {
    switch( lv_strButton ){
        case "OK" :
            if( !validatePassword() ) {
                return;
            }
            submitForm();
            break;
        case "CANCEL" :
            window . open ( "init", "_top" );
            break;
     }
}                    

function validatePassword(){
    if( form1.USER_ID.value.length == 0 || form1.OLD_PASSWORD.value.length == 0 || form1.NEW_PASSWORD.value.length == 0 || form1.RE_PASSWORD.value.length == 0 ){
        showMsg(0,0, lc_check_password_old_and_new);
        if( form1.USER_ID.value.length == 0 ) {
            form1.USER_ID.focus();
        }else if( form1.OLD_PASSWORD.value.length == 0 ) {
            form1.OLD_PASSWORD.focus();
        }else if( form1.NEW_PASSWORD.value.length == 0 ) {
            form1.NEW_PASSWORD.focus();
        }else if( form1.RE_PASSWORD.value.length == 0 ) {
            form1.RE_PASSWORD.focus();
        }
        return false;
    }

    if( form1.RE_PASSWORD.value != form1.NEW_PASSWORD.value ){
        showMsg(0,0, lc_map_password);
        form1.RE_PASSWORD.value = "";
        form1.RE_PASSWORD.focus();
        return false;
    }
    return true;
}

function submitForm() {
//    form1.method = "post";
//    form1.action = "process/process_user.jsp";
//    form1.submit();

        $.ajaxSetup({cache : false});
            
        $.getJSON( 
            "edasservlet" , 
            { 
                    "USER_ID" : form1.USER_ID.value,
                    "OLD_PASSWORD" : form1.OLD_PASSWORD.value,
                    "NEW_PASSWORD" : form1.NEW_PASSWORD.value,
                    "RE_PASSWORD" : form1.RE_PASSWORD.value,
                    "CONTAINER_NAME" : "<%=strContainerName%>",
                    "METHOD" : "changePassword"
            },			 
            function( data ){
                    if(data.SUCCESS == "success"){
                        showMsg(0,0,lc_success_change_password);
                        window.location = "init";
                    }else{
                        if(data.ERROR == "EMPTY_USERID"){
                            showMsg(0,0,lc_check_password_old_and_new);
                            form1.USER_ID.focus();
                        }else if(data.ERROR == "EMPTY_OLDPASS"){
                            showMsg(0,0,lc_check_password_old_and_new);
                            form1.OLD_PASSWORD.focus();
                        }else if(data.ERROR == "EMPTY_NEWPASS"){
                            showMsg(0,0,lc_check_password_old_and_new);
                            form1.NEW_PASSWORD.focus();
                        }else if(data.ERROR == "EMPTY_REPASS"){
                            showMsg(0,0,lc_check_password_old_and_new);
                            form1.RE_PASSWORD.focus();
                        }else if(data.ERROR == "NEW_LEN_LESS"){
                            showMsg(0,0,lc_password_length_more);
                            form1.NEW_PASSWORD.focus();
                        }else if(data.ERROR == "USER_EQU_PASS"){
                            showMsg(0,0,lc_userid_not_eq_pass);
                            form1.NEW_PASSWORD.focus();
                        }else if(data.ERROR == "NOT_FOUND_NUMBER"){
                            showMsg(0,0,lc_password_letter_number);
                            form1.NEW_PASSWORD.focus();
                        }else if(data.ERROR == "NOT_FOUND_ALPHABIC"){
                            showMsg(0,0,lc_password_letter_number);
                            form1.NEW_PASSWORD.focus();
                        }else if(data.ERROR == "FOUND_SPECIAL_CHAR"){
                            showMsg(0,0,lc_password_no_special_letter);
                            form1.NEW_PASSWORD.focus();
                        }else if(data.ERROR == "INVALID_PASS"){
                            showMsg(0,0,lc_user_pass_not_correct);
                            form1.NEW_PASSWORD.focus();
                        }else if(data.ERROR == "CANNOT_EDIT_PASSWD"){
                            showMsg(0,0,lc_user_cannot_update);
                            form1.NEW_PASSWORD.focus();
                        }else{
                            showMsg(0,0,lc_error_system);
                        }
                    }
            });
}

$(document).ready(window_onload);

//-->    
</script>
<link href="css/edas.css" type="text/css" rel="stylesheet">
</head>
<body id="body_detail" onLoad="MM_preloadImages('images/btt_ok_over.gif','images/btt_cancel_over.gif');">
<form name="form1" action="" method="post">
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
  <tr> 
    <td height="39" valign="top" background="images/pw_07.jpg"> 
        <table width="100%" height="62" border="0" cellpadding="0" cellspacing="0">
        <tr> 
          <td height="62" background="images/inner_03.jpg"> 
              <table width="990" border="0" cellspacing="0" cellpadding="0">
              <tr> 
                <td width="465"><img src="images/detail_01.jpg" height="62"></td>
                <td width="525" valign="bottom"><div align="right"></div></td>
              </tr>
            </table>
            </td>
        </tr>
      </table></td>
  </tr>
  <tr>
    <td height="33" valign="top" background="images/pw_07.jpg">
        <table width="100%" border="0" cellpadding="0" cellspacing="0">
        <tr> 
            <td width="223" align="left"><img src="images/detail_05.jpg" width="223" height="39"></td>
          <td width="*" background="images/detail_07.jpg" align="right"> 
            <span class="navbar_01"><%=dateToDisplay(getTodayDate())%></span>&nbsp;&nbsp;</td>
          <td width="17" background="images/detail_07.jpg">&nbsp;</td>
        </tr>
      </table></td>
  </tr>
  <tr> 
    <td valign="top" id="bg_detail">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td><p>&nbsp;</p>
              <table width="419" border="0" align="center" cellpadding="0" cellspacing="0">
              <tr> 
                <td width="34"><img src="images/frame_01.gif" width="34" height="238"></td>
                <td width="372" valign="top" background="images/frame_02.gif"><table width="80%" border="0" align="center" cellpadding="0" cellspacing="0">
                    <tr> 
                      <td colspan="2"><div align="center"><img src="images/changepw.gif" height="31"></div></td>
                    </tr>
                    <tr> 
                      <td height="25" colspan="2">&nbsp;</td>
                    </tr>
                    <tr> 
                      <td width="40%" align="right"><img src="images/iduser.jpg" height="26"></td>
                      <td width="60%"> <input id="USER_ID" name="USER_ID" type="text" class="input_pw" size="25" > 
                      </td>
                    </tr>
                    <tr> 
                      <td align="right"><img src="images/pwold.jpg" height="26"></td>
                      <td><input id="OLD_PASSWORD" name="OLD_PASSWORD" type="password" class="input_pw" size="25" ></td>
                    </tr>
                    <tr> 
                      <td align="right"><img src="images/pwnew.jpg" height="26"></td>
                      <td><input id="NEW_PASSWORD" name="NEW_PASSWORD" type="password" class="input_pw" size="25" ></td>
                    </tr>
                    <tr> 
                      <td align="right"><img src="images/confirm.jpg" height="26"></td>
                      <td><input id="RE_PASSWORD" name="RE_PASSWORD" type="password" class="input_pw" size="25" ></td>
                    </tr>
                    <tr valign="bottom"> 
                      <td height="40" colspan="2"><div align="center">
                          <a href="javascript:buttonClick('OK')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('ok','','images/btt_ok_over.gif',1)"><img src="images/btt_ok.gif" name="ok" width="67" height="22" border="0"></a>
                          <a href="javascript:buttonClick('CANCEL')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('cancel','','images/btt_cancel_over.gif',1)"><img src="images/btt_cancel.gif" name="cancel" width="67" height="22" border="0"></a></div></td>
                    </tr>
                  </table></td>
                <td width="13"><img src="images/frame_04.gif" width="36" height="238"></td>
              </tr>
            </table>
          </td>
        </tr>
      </table></td>
  </tr>
</table>
<input type="hidden" name="METHOD" value="CHANGE_PWD">
</form>
</body>
</html>

