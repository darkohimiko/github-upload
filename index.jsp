<%@ page contentType="text/html; charset=tis-620"%>
<%@ page import="com.scc.edms.conf.ImageConfUtil"%>
<%@ include file="inc/constant.jsp" %>
<%@ include file="inc/utils.jsp" %>
<jsp:useBean id="con" scope="session" class="edms.cllib.EABConnector"/>
<%
    if( session.getAttribute( "USER_INFO" ) != null ){
        session.removeAttribute( "USER_INFO");
    }
%>
<%
    con.setRemoteServer("EAS_SERVER");
        
    String  strAdFlag = ImageConfUtil.getLoginAD();
	
    String strErrMsg = checkNull(request.getParameter("ERROR_MESSAGE"));
    
    if(strErrMsg.equals("NOT_FOUND_USER")){
        strErrMsg= lc_not_found_this_user;
    }else if (strErrMsg.equals("CANNOT_LOGIN")){
        strErrMsg = lc_cannot_login;
    }
    

    String strChangePWFlag  = strAdFlag;
    String strPwStyle       = "";
    
    if( !strChangePWFlag.equals("on") ) {
    	strPwStyle = "style=\"display:online\"";
    }else{
    	strPwStyle = "style=\"display:none\"";
    }
    
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">  
<html>
<head>
<title><%=lc_system_name%> <%=lc_site_name%></title>
<link rel="shortcut icon" href="images/favicon/EDAS.ico" type="image/x-icon" />
<meta http-equiv="Content-Type" content="text/html; charset=TIS-620">    
<script language="JavaScript" type="text/javascript">
<!--
function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
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
<script language="JavaScript" src="js/jquery-1.9.1.js"></script>
<script language="JavaScript" type="text/javascript">
<!--
var sccUtils = new SCUtils;

var browserName = navigator.appName;
var browserVer = parseInt(navigator.appVersion);
var version = "";
var msie4 = (browserName == "Microsoft Internet Explorer" && browserVer >= 4);
if ((browserName == "Netscape" && browserVer >= 3) || msie4 || browserName=="Konqueror" || browserName=="Opera") {version = "n3";} else {version = "n2";}
          
function window_onload() {
	
	<%	if( !strErrMsg.equals( "" ) ){ %>
	alert("<%=strErrMsg.replaceAll( "\"" , "'" ).replaceAll( "\r" , "" ).replaceAll( "\n" , "<br>" )%>");
	
	<% 	}%>
	
    form1.USER_ID.focus();
    top.resizeTo ( screen.availWidth,screen.availHeight );
    top.moveTo(0,0);
    
    $("#USER_ID").keypress(function(e){
        if(e.keyCode==13){
            $("#PASSWORD").focus();
        }
    });
    
    $("#PASSWORD").keypress(function(e){
        if(e.keyCode==13){
            openPage('login');
        }
    });
} 

function openPage(obj_page) {
	switch(obj_page) {
        case 'login':
            if(!validateLogin()){
                return;
            }
            
                $.ajaxSetup({cache : false});
            
            $.getJSON( 
      			"edasservlet" , 
      			{ 
      				"USER_ID" : form1.USER_ID.value, 
      				"PASSWORD" : form1.PASSWORD.value, 
      				"AD" : "<%=strAdFlag%>",
                                "CONTAINER_NAME" : "<%=strContainerName%>",
      				"METHOD" : "checkUserLogin"
      			},			 
      			function( data ){
      				if(data.SUCCESS == "success"){
      		            submitForm();
      				}else{
      					if(data.ERROR == "NONE"){
      						showMsg(lc_user_not_found,0);
      					}else if(data.ERROR == "DEACTIVE"){
      						showMsg(lc_user_is_disable,0);
      					}else if(data.ERROR == "PASSWD"){
      						showMsg(lc_user_pass_not_correct,0);
      					}else{
      						showMsg(lc_error_system,0);
      					}
  						form1.USER_ID.value = "";
  						form1.PASSWORD.value = "";
  						form1.USER_ID.focus();
      					return;
      				}
      			});
            break;
        case 'global_search':
            window.open( "../globalsearch", "_blank" );
            break;
        case 'change_password':
            window.open( "change_password.jsp", "_self" );
            break;
        case 'image_viewer':
            window.open( "software_plugin.jsp","software","width="+ screen.availWidth +"px,height="+ screen.availHeight +"px,status=yes,top=0,left=0,toolsbar=no");
            break;
        case 'news':
        	window.open( "news","news","width="+ screen.availWidth +"px,height="+ screen.availHeight +"px,status=yes,top=0,left=0,toolsbar=no");
            break;
        case 'faq':
        	window.open( "faq","faq","width="+ screen.availWidth +"px,height="+ screen.availHeight +"px,status=yes,top=0,left=0,toolsbar=no");
            break;
    }
}   
                         
function validateLogin(){
    if( form1.USER_ID.value.length == 0 && form1.PASSWORD.value.length == 0 ){
        alert(lc_check_user_password);
        form1.USER_ID.focus();
        return false;
    }
    if( form1.USER_ID.value.length == 0){
        alert( lc_check_user );
        form1.USER_ID.focus();
        return false;
    }
    if( form1.PASSWORD.value.length == 0 ){
        alert( lc_check_password );
        form1.PASSWORD.focus();
        return false;
    }

    return true;
}

function submitForm(){
    form1.method = "post";
    form1.action = "process/process_user.jsp";
    form1.submit();
}

function submitGuestForm() {
    form1.method         = "post";
    form1.action         = "process/process_user.jsp";
    //form1.METHOD.value   = "GUEST";
    form1.USER_ID.value  = "GUEST";
    form1.PASSWORD.value = "";
    form1.submit();
}
	// Blurring links:
function blurLink(theObject)	{	//
	if( msie4 )	{
		theObject.blur();
	}
}

$(document).ready(window_onload);

//-->            
</script>    
<link href="css/edas.css" type="text/css" rel="stylesheet">
</head>
<body background="images/bg_login.jpg" onLoad="MM_preloadImages('images/login_over_08.jpg','images/login_over_09.jpg','images/login_over_10.jpg','images/login_over_11.jpg','images/login_over_12.jpg','images/btt_login_over.gif','images/txt_changepw_over.gif');" >
<form name="form1" action="" method="post">
<table width="760" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr> 
    <td height="44"><img src="images/login_01.jpg" width="508" height="44"></td>
  </tr>
  <tr> 
      <td valign="top"><table width="760" border="0" align="center" cellpadding="0" cellspacing="0" valign="top">
        <tr valign="top"> 
          <td colspan="5"><table width="760" border="0" cellspacing="0" cellpadding="0">
              <tr> 
                <td width="408" height="224"  background="images/login_03.jpg">&nbsp;</td>
                <td width="319" rowspan="2" background="images/login_04.jpg">
                    <table width="319" height="380" border="0" cellpadding="0" cellspacing="0">
                        <tr>
                            <td height="100">&nbsp;</td>
                        </tr>
                    <tr>
                      <td>
                          <table width="319" border="0" cellpadding="0" cellspacing="0">
                          <tr>
                            <td height="40" colspan="2">&nbsp;</td>
                          </tr>
                          <tr> 
                            <td height="40" colspan="2"><div align="center"><img src="images/txt_user.gif" width="100" height="22"></div></td>
                          </tr>
                          <tr> 
                            <td colspan="2"> <div align="center"> 
                                <input id="USER_ID" name="USER_ID" type="text" class="input_box" >
                              </div></td>
                          </tr>
                          <tr> 
                            <td height="40" colspan="2"><div align="center"><img src="images/txt_pw.gif" width="100" height="22"></div></td>
                          </tr>
                          <tr> 
                            <td colspan="2"><div align="center"> 
                                <input id="PASSWORD" name="PASSWORD" type="password" class="input_box" >
                              </div></td>
                          </tr>
                          <tr valign="bottom"> 
                            <td height="40" colspan="2"><div align="center"><a href="javascript:openPage('login')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('login','','images/btt_login_over.gif',1)"><img src="images/btt_login.gif" name="login" width="160" height="24" border="0"></a></div></td>
                          </tr>
                        </table></td>
                    </tr>
                    <tr>
                        <td height="19"><div align="right">
                          <span <%=strPwStyle%> ><a href="javascript:openPage('change_password')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('changepw','','images/txt_changepw_over.gif',1)"><img src="images/txt_changepw.gif" name="changepw" height="19" border="0"></a></span>
                      </div></td>
                    </tr>
                  </table></td>
                <td width="33" rowspan="2" background="images/login_04.jpg"><img src="images/login_05.jpg" width="33" height="425"></td>
              </tr>
              <tr> 
                <td height="201" background="images/login_06.jpg">&nbsp;</td>
              </tr>
            </table></td>
        </tr>
        <tr>
    		<td width="200"><a href="javascript:void(0)" onclick="openPage('global_search')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('global_search','','images/login_over_08.jpg',1)"><img src="images/login_08.jpg" name="global_search" width="200" height="85" border="0"></a></td>
    		<td width="191"><a href="javascript:void(0)" onclick="openPage('image_viewer')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('image_view','','images/login_over_09.jpg',1)"><img src="images/login_09.jpg" name="image_view" width="191" height="85" border="0"></a></td>
          	<td width="179"><a href="javascript:void(0)" onclick="openPage('news')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('News','','images/login_over_10.jpg',1)"><img src="images/login_10.jpg" name="News" width="179" height="85" border="0"></a></td>
          	<td width="190"><a href="javascript:void(0)" onclick="openPage('faq')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('about','','images/login_over_11.jpg',1)"><img src="images/login_11.jpg" name="about" width="190" height="85" border="0"></a></td>      
          <td></td>
        </tr>
        <tr> 
          <td colspan="5" id="copyright"><div align="center">
              <%=lc_update_edas_detail1%><%=lc_update_edas_detail3 %><%=lc_update_edas_detail2%><%=lc_update_edas_detail4 %><br>
              Copyright &copy; 2016, Summit Computer All Rights Reserved. 
            </div></td>
          <td></td>
        </tr>
      </table></td>
  </tr>
</table>
<input type="hidden" name="METHOD" value="LOGIN">
</form>
</body>
</html>