<%@page import="com.scc.edms.conf.ImageConfUtil"%>
<%@ page import="scc.tcg.eas.arch.EASArchiveHttpConnector"%>
<%@ page contentType="text/html; charset=tis-620"%>
<%@ page import="java.util.Vector"%>
<%@ page import="java.util.Hashtable"%>
<%@ include file="inc/constant.jsp" %>
<%@ include file="inc/utils.jsp" %>
<%@ include file="inc/label.jsp" %>
<jsp:useBean id="con" scope="session" class="edms.cllib.EABConnector"/>
<%
    con.setRemoteServer("EAS_SERVER");

    String strClassName = "NEWS_MANAGER";

    String strCurrentPage = request.getParameter( "CURRENT_PAGE" );
    if( strCurrentPage == null || Integer.parseInt( strCurrentPage ) == 0 ) {
        strCurrentPage = "1";
	}
    
    String  strmsg          = "";
    boolean bolnSuccess     = false;

    String strNewsIdData     = checkNull(request.getParameter( "NEWS_ID_TEMP" ));
    String strHeaderData     = "";
    String strSubjectData    = "";
    String strSourceNameData = "";
    String strNewsDateData   = "";
    String strBlobData       = "";
    String strBlobMediaData  = "";    
    String strTotalPage = "1";
    
    con.addData( "NEWS_ID", "String", strNewsIdData );
    bolnSuccess = con.executeService( strContainerName, strClassName, "selectDetailViewNewsManager" );        
    if( bolnSuccess ) {
            strNewsIdData     = con.getHeader( "NEWS_ID" );
            strHeaderData     = con.getHeader( "HEADER" );
            strSubjectData    = con.getHeader( "SUBJECT" );
            strSourceNameData = con.getHeader( "EDAS_SOURCE_NAME" );
            strNewsDateData   = con.getHeader( "NEWS_DATE" );
            strBlobData       = con.getHeader( "BLOB" );
            strBlobMediaData  = con.getHeader( "BLOB_MEDIA" );

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
<script language="JavaScript" type="text/javascript">
<!--

var totalPage = '<%=strTotalPage%>';

function window_onload() {
	lb_news_blob.innerHTML = lbl_news_blob;
        
        set_background();
}

function buttonClick( lv_strMethod ) {
	var newsId  = form1.NEWS_ID_TEMP.value;
//	var curPage = form1.CURRENT_PAGE.value;
	
    switch( lv_strMethod ) {
        case "back" :
        	form1.method = "post";
        	form1.action = "news";
        	form1.todo.value = "search";
        	form1.submit();
			break;
        case "print" :
//        	window.open( "news?NEWS_ID_TEMP="+ newsId +"&CURRENT_PAGE="+curPage+"&todo=print","news3","width="+ screen.availWidth +"px,height="+ screen.availHeight +"px,status=yes,top=0,left=0,toolbar=yes");
        	form1.target = "_blank";
        	form1.action = "news";
        	form1.NEWS_ID_TEMP.value = newsId;
        	form1.todo.value = "print";
        	form1.submit();
			break;
	}
}

function set_background(){    
    var header_height = getDocHeight();

    if(header_height == 0){
        header_height = document.documentElement.offsetHeight;
    }
    
    screen_div.style.height = header_height;            
    
}

function getDocHeight() {
    var D = document;
    return Math.min(
        D.body.scrollHeight, D.documentElement.scrollHeight,
        D.body.offsetHeight, D.documentElement.offsetHeight,
        D.body.clientHeight, D.documentElement.clientHeight
    );
}

//-->
</script>
<link href="css/edas.css" type="text/css" rel="stylesheet">
</head>
<body onLoad="MM_preloadImages('images/close_over.gif');window_onload();" class="bg" onresize="set_background()">
<form name="form1" method="post" action="" >
<table width="100%" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
    <tr><td valign="top">
<div id="screen_div" style="width:100%;margin:0px;border:0px;overflow: auto;" >
<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
	<tr><td>
<table width="990" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr> 
    <td width="504" height="109"><img src="images/main_01.jpg" width="504" height="109"></td>
    <td width="486" valign="bottom" background="images/main_information.jpg" style="padding-right:25px" align="right">
    	<a href="#" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('print','','images/print_over.gif',1)" onclick= "buttonClick('print')" >
    		<img src="images/print.gif" name="print" width="30" height="25" border="0">
    	</a>
    	<a href="javascript:buttonClick('back')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('close','','images/close_over.gif',1)"> 
      		<img src="images/close.gif" name="close" width="25" height="25" border="0">
      	</a>
	</td>
  </tr>
  <tr valign="top">
    <td colspan="2" background="images/main_bg.jpg"><div align="center">
        <table width="885" border="0" align="center" cellpadding="0" cellspacing="0">
          <tr> 
            <td background="images/dot_2.gif"><img src="images/information.gif" width="155" height="25"></td>
          </tr>
        </table>
        <table width="900" border="0" cellpadding="0" cellspacing="0" class="label_normal4">
          <tr> 
            <td width="266" align="center" valign="top">
            	<table border="0" cellspacing="0" cellpadding="0" width="266">
<%
            if( !strBlobData.equals("") ) {

                EASArchiveHttpConnector connector;

                connector = EASArchiveHttpConnector.createConnector("EAS_SERVER");
                String[] urls = connector.createUrlsParameter(strBlobData, null);
               
                for (String imgLink : urls) {                   
%>
                    <tr>
                        <td class="img_news" align="center" valign="middle">
                            <a href="<%=imgLink%>" target="_blank"><img src="<%=imgLink%>" width="253" border="0" ></a>
                        </td>
                    </tr>
                    <tr> 
                        <td><img src="images/tran.gif" width="1" height="1"></td>
                    </tr>
<%               }
            }
%>              </table>
            </td>
            <td width="1" id="line_news"></td>
            <td width="723" valign="top">
            	<div class="news_header"><%=strHeaderData %></div><br>
              	<div class="news_content"><%=strSubjectData.replaceAll("\n","<br>") %></div><br>
                <div id="news_date"><%=strSourceNameData %></div>
                <div id="news_date"><%=strNewsDateData %></div>
                <center><div id="line_news2"></div></center>
              	<div class="label_bold5" ><span id="lb_news_blob"></span></div>
              	<div id="attach_file">
<%
               if( !strBlobMediaData.equals("") ) {
                   String   strDocImg   = "";
                   String   strFileName = "";
                   String   strType     = null;
                   
                   int count = 0;

                   //int nPictM    = Integer.parseInt( strPictMediaData );
                   
                   EASArchiveHttpConnector connector;

                    connector = EASArchiveHttpConnector.createConnector("EAS_SERVER");
                    String[] urls = connector.createUrlsParameter(strBlobMediaData, null);

                    for (String linkMedia : urls) {

                        count++;
                        
                        strType = connector.containerInfo().getPartInfo(count).getPartType();
                        strFileName = connector.containerInfo().getPartInfo(count).getName();
                        strFileName = new String(strFileName.getBytes(),"TIS620");
                        
                        strType = strType.toLowerCase();
                    
                        if(strType.equals("xls")) {
                            strDocImg = "images/excel.gif";
                        }else if(strType.equals("pdf")) {
                            strDocImg = "images/acrobat.gif";
                        }else if(strType.equals("doc")) {
                            strDocImg = "images/word.gif";
                        }else if(strType.equals("ppt")) {
                            strDocImg = "images/word.gif";
                        }else {
                            strDocImg = "images/page_attach.gif";
                        }
%>
					<img src="<%=strDocImg%>" width="16" height="16"><a href="<%=linkMedia %>" target="_blank">&nbsp;&nbsp;<%=strFileName %></a><br>
<%
                    }

               }
%>
				</div>
			</td>
		  </tr>
		</table>
      </div></td>
  </tr>
  <tr> 
	<td height="25" colspan="2"><img src="images/main_03.jpg" width="990" height="25">
		<input type="hidden" name="NEWS_ID_TEMP" value="<%=strNewsIdData %>">
		<input type="hidden" name="CURRENT_PAGE" value="<%=strCurrentPage%>">
		<input type="hidden" name="todo" value="">
	</td>
  </tr>
</table>
	</td></tr>
</table>
</div>
</td></tr>
</table>
</form>
</body>
</html>
<%  if (!strmsg.equals("")) {  %>
<script language="javaScript">
    <%=strmsg%>
</script>
<%  }   %>