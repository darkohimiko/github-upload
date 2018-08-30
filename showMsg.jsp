<%@ page contentType="text/html; charset=tis-620"%>
<%
    String p1=request.getParameter("p1");
    if (p1==null || p1.equals("0")) p1="";
    p1 = new String(p1.getBytes("ISO8859_1"),"TIS620");
    //p1 = new String(p1.getBytes());
    String p2=request.getParameter("p2");
    if (p2==null) p2="";

    String p3=request.getParameter("p3");
    if (p3==null) p3="";
    //p3 = new String(p3.getBytes("ISO8859_1"),"TIS620");

    String p4=request.getParameter("p4");
    if (p4==null) p4="";
    p4=new String(p4.getBytes("ISO8859_1"),"TIS620");
//System.out.println("1 "+p1+" // "+p2+ " // "+p3+" // "+p4);
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Message</title>
<meta http-equiv="Content-Type" content="text/html; charset=tis-620">
<link rel="shortcut icon" href="images/favicon/EDAS.ico" type="image/x-icon" />
<meta http-equiv="Pragma" content="no-cache">
<script language="JavaScript" type="text/JavaScript">
    var p3 = "<%=p3%>";
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
    
    function cancel_onclick(){
        window.returnValue=false;
        window.close();
    }

    function ok_onclick(){
        window.returnValue=true;
        window.close();
    }

</script>
<style type="text/css">
<!--
.style1 {
	color: #FFFFFF;
	font-weight: bold;
}
-->
</style>
<link href="css/edas.css" type="text/css" rel="stylesheet">
</head>
<body bgcolor = white leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('images/btt_ok_over.gif','images/btt_cancel_over.gif')">
<form name="form1" method="post" action="">
  <table width="75%" border="0" cellspacing="0" cellpadding="0" align="center">
    <tr>
      <td  class="label_bold4" >&nbsp;</td>
    </tr>
    <tr>
      <td  class="label_bold4" >&nbsp;</td>
    </tr>
    <tr>
       <td  class="label_bold4"  align="center" ><%=p1%></td>
    </tr>
    <tr>
      <td colspan="2" align="center"  class="label_bold4" ><%=new String(p3.getBytes("ISO8859_1"),"TIS620")%></td>
    </tr>
     <tr>
      <td  class="label_bold4" >&nbsp;</td>
    </tr>
    <tr>
      <td  class="label_bold4" >&nbsp;</td>
    </tr>
    <tr>
      <td  class="label_bold4" >&nbsp;</td>
    </tr>
    <tr>
      <td colspan="2" align="center" >

		<a href="#" onclick="ok_onclick()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('btt_ok','','images/btt_ok_over.gif',1)"><img src="images/btt_ok.gif" name="btt_ok" width="67" height="22" border="0"></a>
        
<%
        if (p2.equals("1")){

%>          <a href="#" onclick="cancel_onclick()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('btt_cancel','','images/btt_cancel_over.gif',1)"><img src="images/btt_cancel.gif" name="btt_cancel" width="67" height="22" border="0"></a>  
			
<%      }
%>
      </td>
    </tr>
  </table>
  <input type="hidden" name="txtStatus" value="zoom">
</form>
</body>
</html>
