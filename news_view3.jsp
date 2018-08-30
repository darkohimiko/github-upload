<%@ page contentType="text/html; charset=tis-620"%>
<%@ include file="inc/constant.jsp" %>
<%@ include file="inc/utils.jsp" %>
<%@ include file="inc/label.jsp" %>
<jsp:useBean id="con" scope="session" class="edms.cllib.EABConnector"/>
<%
	con.setRemoteServer("EAS_SERVER");
    
    String strClassName = "NEWS_MANAGER";
    
    boolean bolnSuccess     = false;

    String strNewsIdData     = getField(request.getParameter( "NEWS_ID_TEMP" ));
    String strHeaderData     = "";
    String strSubjectData    = "";
    String strSourceNameData = "";
    String strNewsDateData   = "";

    con.addData( "NEWS_ID", "String", strNewsIdData );
    bolnSuccess = con.executeService( strContainerName, strClassName, "selectDetailViewNewsManager" );
    if( bolnSuccess ) {
            strNewsIdData     = con.getHeader( "NEWS_ID" );
            strHeaderData     = con.getHeader( "HEADER" );
            strSubjectData    = con.getHeader( "SUBJECT" );
            strSourceNameData = con.getHeader( "EDAS_SOURCE_NAME" );
            strNewsDateData   = con.getHeader( "NEWS_DATE" );

            strHeaderData   = strHeaderData.replaceAll( "##", "\r\n" );
            strSubjectData  = strSubjectData.replaceAll( "##", "\r\n" );
            strNewsDateData = dateToDisplay( strNewsDateData );
    }
    
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title><%=lc_site_name%></title>
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
<script language="JavaScript" src="js/sccUtils.js"></script>
<script language="JavaScript" src="js/util.js"></script>
<script language="JavaScript" src="js/constant.js"></script>
<script language="JavaScript" src="js/label.js"></script>
</head>
<body>
<form name="form1" method="post" action="" >
<table width="100%" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
<tr><td>
<table width="990" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr valign="top">
    <td colspan="2">
    	<div align="center">
        	<table width="885" border="0" align="center" cellpadding="0" cellspacing="0">
          		<tr> 
            		<td><span style=""><h3><u><%=lb_news %></u></h3></span></td>
          		</tr>
          		<tr> 
            		<td>&nbsp;</td>
          		</tr>
        	</table><!-- span style="padding-bottom:60px;"-->
        <table width="900" border="0" cellpadding="0" cellspacing="0" class="label_normal4">
          <tr> 
            <td width="90%" align="left" valign="top">
				<div class="news_header"><b><%=strHeaderData %></b></div><br>
              	<div class="news_content"><%=strSubjectData.replaceAll("\n","<br>") %></div><br>
                <div id="news_date"><%=strSourceNameData %></div>
                <div id="news_date"><%=strNewsDateData %></div>
			</td>
		  </tr>
		</table>
      </div></td>
  </tr>
</table>
	</td></tr>
</table>
</form>
</body>
</html>
