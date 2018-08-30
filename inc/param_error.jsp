<%@ page contentType="text/html;charset=tis-620"%>
<%
    String strServerPath = request.getContextPath();
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>EDAS</title>
<meta http-equiv="Content-Type" content="text/html; charset=tis-620">
<style type="text/css">
    
.label_normal4
{
	font-size: 14px;
	font-family:tahoma;
	color: #693b13;
	font-style: normal;
	line-height: 180%;
}    
    
    
</style>
<script language="javascript">
<!--

function redirectPage(){
   var port = document.location.port;
   var appname = "<%=strServerPath%>";
   
    if(port == ""){
            port = "80";
    }

    
    
   window.open("","_self");
   var url = "http://" + document.location.hostname + ":" + port + appname;
    top.close();
    window . open ( url, "_blank" );
}
//-->
</script>
</head>

<body>
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td height="100" colspan="2">&nbsp;</td>
    </tr>
    <tr bgcolor="2c3850">
      <td width="13%" height="20" bgcolor="#99FFCC" class="label_normal3">&nbsp;&nbsp;</td>
      <td width="87%" height="20" align="right" bgcolor="#99FFCC" class="label_normal3">&nbsp;</td>
    </tr>
  </table>
  <br><br>
  <form name="form1">

  <table width="50%" align="center" cellspacing="0" style="border:2px solid">
    <tr>
      <td>&nbsp;</td>
    </tr>
    <tr align="center">
      <td class="label_normal4">Input parameters not correct!!!</td>
    </tr>
    <tr align="center" height="50">
        <td><input type="button" onClick="redirectPage();" value="OK"></td>
    </tr>
  </table>
</form>
</body>
</html>
