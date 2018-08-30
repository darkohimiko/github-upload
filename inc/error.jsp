<%-- 
    Document   : error
    Created on : 17 Oct 2551, 17:08:20
    Author     : ohm
--%>

<%@ include file="constant.jsp" %>
<%@ include file="utils.jsp" %>
<%

    String strErrorCode    = (String)session.getAttribute( "ERROR_CODE" );
    String strErrorMessage = (String)session.getAttribute( "ERROR_MESSAGE" );

    String strRedirect = "";
    if( session.getAttribute( "REDIRECT_PAGE") != null ){
        strRedirect = session.getAttribute( "REDIRECT_PAGE" ).toString();
    }

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>EDAS</title>
<meta http-equiv="Content-Type" content="text/html; charset=windows-874">
<link href="../css/edas.css" rel="stylesheet" type="text/css">
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

<script language="javascript">
<!--
var lv_strRedirect = "<%=strRedirect%>";

function redirectPage(){
    if( lv_strRedirect == "" ){
        top.close();
    }else{
        top.location = lv_strRedirect  ;
    }
}
//-->
</script>
</head>

<body onLoad="MM_preloadImages('../images/btt_ok_over.gif')">
<br>
<br>
<form name="form1">
  <table width="60%" align="center" cellspacing="0" class="table_data_1_2" style="border:2px solid">
    <tr align="center">
      <td colspan="3">&nbsp;</td>
    </tr>
    <tr>
      <td width="49%" align="right">Error Code : </td>
      <td width="3%" class="label_normal2">&nbsp;</td>
      <td width="48%" class="label_normal2"><%=strErrorCode%></td>
    </tr>
    <tr align="center" valign="top">
      <td width="49%" align="right"><div align="right">Error Message : </div></td>
      <td width="3%" class="label_normal2">&nbsp;</td>
      <td width="48%" class="label_normal2"><div align="left"><%=strErrorMessage%></div></td>
    </tr>
    <tr align="center" height="50">
      <td colspan="3"><a href="#" onClick="redirectPage();" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('okBtt','','../images/btt_ok_over.gif',1)"><img src="../images/btt_ok.gif" name="okBtt" width="67" height="22" border="0"></a>      </td>
    </tr>
  </table>
</form>
</body>
</html>

