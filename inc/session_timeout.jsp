<%@ page contentType="text/html;charset=tis-620"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>EDAS</title>
<meta http-equiv="Content-Type" content="text/html; charset=tis-620">
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

function redirectPage(){
    window.open("","_self");
    top.close();
    window . open ( "../init", "_blank" );
}
//-->
</script>
</head>

<body onLoad="MM_preloadImages('../image/btt_ok_over.gif')">
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

  <table width="50%" align="center" cellspacing="0" class="table_data_1_2" style="border:2px solid">
    <tr>
      <td>&nbsp;</td>
    </tr>
    <tr align="center">
      <td class="label_normal4">TIME OUT</td>
    </tr>
    <tr align="center" height="50">
      <td><a href="#" onClick="redirectPage();" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('okBtt','','../images/btt_ok_over.gif',1)"><img src="../images/btt_ok.gif" name="okBtt" width="67" height="22" border="0"></a>      </td>
    </tr>
  </table>
</form>
</body>
</html>
