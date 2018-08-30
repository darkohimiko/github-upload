<%@ page contentType="text/html; charset=tis-620"%>
<%@ include file="inc/constant.jsp" %>
<%@ include file="inc/utils.jsp" %>
<%@ include file="inc/label.jsp" %>
<jsp:useBean id="con" scope="session" class="edms.cllib.EABConnector"/>
<%
    con.setRemoteServer("EAS_SERVER");

    String strClassName = "FAQ_MANAGER";

    String strCurrentPage  = request.getParameter( "CURRENT_PAGE" );
    try{
        if( strCurrentPage == null || Integer.parseInt( strCurrentPage ) == 0 ) {
            strCurrentPage = "1";
        }
    }catch(NumberFormatException nfe){
        strCurrentPage = "1";
    }  
    
    String  strmsg          = "";
    boolean bolnSuccess     = false;

    String  strFaqIdData   = getField(request.getParameter( "FAQ_ID_TEMP" ));
    String  strFaqSubjData = "";
    
    String  strScript    = "";
    String  strTotalPage = "1";
    String  strTotalSize = "0";
   
    String pagesize = "20";

    con.addData( "PAGENUMBER", "String", strCurrentPage );
    con.addData( "PAGESIZE",   "String", pagesize );
    bolnSuccess = con.executeService( strContainerName, strClassName, "selectAllViewFaqManager" );
    if( bolnSuccess ) {
        strTotalPage = con.getHeader( "PAGE_COUNT" );
        strTotalSize = con.getHeader( "TOTAL_RECORD" );
        if( !strTotalSize.equals("0") ) {
            strCurrentPage = con.getHeader( "CURRENT_PAGE" );
        }else {
            strCurrentPage = "0";
        }
    }
    
%>
<!DOCTYPE HTML>
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
<script language="JavaScript" src="js/jquery-1.9.1.js"></script>
<script language="JavaScript" src="js/label/lb_faq.js"></script>
<script language="JavaScript" src="js/function/page-utils.js"></script>
<script language="JavaScript" src="js/function/table-utils.js"></script>
<script language="JavaScript" src="js/util.js"></script>
<script language="JavaScript" src="js/constant.js"></script>
<script language="JavaScript" type="text/javascript">
<!--

$(document).ready(window_onload);

function window_onload() {
    set_background("screen_div");
    set_field_table();
    set_init();
    set_message();
}

function set_init(){
    totalPage = '<%=strTotalPage%>';
    mode      = 'SEARCH';    
}

function set_message(){
    
<%  if (!strmsg.equals("")) {  %>
    <%=strmsg%>
<%  }   %>
}

function click_view( lv_strValue ) {
    $("#FAQ_ID_TEMP").val(lv_strValue.getAttribute("FAQ_ID"));
    $("#todo").val("detail");
    $("#form1").submit();
}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               

function page_close() {
    window.close();
}

//-->
</script>
<link href="css/edas.css" type="text/css" rel="stylesheet">
</head>
<body class="bg" onLoad="MM_preloadImages('images/close_over.gif');" onresize="set_background('screen_div');">
<form id="form1" name="form1" method="post" action="faq" >
<table width="100%" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
    <tr><td>
        <div id="screen_div">
            <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
                <tr><td >
                    <table width="990" height="109" border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr> 
                            <td width="504" height="109" background="images/main_01.jpg"><!--img src="images/main_01.jpg" width="504" height="109"--></td>
                            <td width="486" valign="bottom" background="images/main_faq.jpg" align="right">
                                <a href="#" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('close','','images/close_over.gif',1)" onclick="page_close()">
                                    <img src="images/close.gif" name="close" width="25" height="25" border="0" >
                                </a>&nbsp;&nbsp;&nbsp;&nbsp;
                            </td>
                        </tr>
                        <tr valign="top">
                            <td colspan="2" background="images/main_bg.jpg">
                                <table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td width="31"><img src="images/frame_01.jpg" width="31" height="23" style="display: block;"></td>
                                        <td width="701" background="images/frame_02.jpg">&nbsp;</td>
                                        <td width="18"><img src="images/frame_04.jpg" width="30" height="23" style="display: block;"></td>
                                    </tr>
                                    <tr>
                                        <td background="images/frame_08.jpg">&nbsp;</td>
                                        <td>
                                            <table width="600" border="0" align="center" cellpadding="0" cellspacing="0">
                                                <tr>
                                                    <td background="images/dot_2.gif"><img src="images/faq.gif" height="25"></td>
                                                </tr>
                                            </table>
                                            <ol id="sub">
<%
    if( bolnSuccess ) {
        while( con.nextRecordElement() ) {
            strFaqIdData   = con.getColumn( "FAQ_ID" );
            strFaqSubjData = con.getColumn( "FAQ_SUBJ" );
            
            strFaqSubjData   = strFaqSubjData.replaceAll( "##", "<br>" );
            
            strScript = "FAQ_ID=\"" + strFaqIdData + "\" ";
%>              
                                                <li><a href="#" onclick= "click_view(this)" <%=strScript%>><%=strFaqSubjData%></a></li>
<%
		}
	}else {
%>
                                                <li><div class="label_bold4" align="center"><%=lc_data_not_found %></div></li>
<%
     }
%>
                                            </ol>
                                            <div align="right"></div>
                                        </td>
                                        <td background="images/frame_10.jpg">&nbsp;</td>
                                    </tr>
                                    <tr>
                                        <td><img src="images/frame_11.jpg" width="31" height="24"></td>
                                        <td background="images/frame_12.jpg">&nbsp;</td>
                                        <td><img src="images/frame_14.jpg" width="30" height="24"></td>
                                    </tr>
                                </table>
                                <table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td width="31"><img src="images/frame_15.jpg" width="31" height="36"></td>
                                        <td width="718" background="images/frame_16.jpg">
                                            <div align="center">
                                                <a href="#" name="firstP" onClick="navigator_click('first');"><img src="images/first.gif" width="22" height="22" align="absbottom" border="0"></a>
                                                <a href="#" name="previousP" onClick="navigator_click('previous');"><img src="images/prv.gif" width="22" height="22" align="absbottom" border="0"></a>
                                                <input id="CURRENT_PAGE" name="CURRENT_PAGE" type="text" class="input_box_disable" style="text-align:center" size="3" value="<%=strCurrentPage%>" readonly>/
                                                <input id="TOTAL_PAGE" name="TOTAL_PAGE" type="text" class="input_box_disable" style="text-align:center" size="3" value="<%=strTotalPage%>" readonly>
                                                <a href="#" name="nextP" onClick="navigator_click('next');"><img src="images/next.gif" width="22" height="22" align="absbottom" border="0"></a>
                                                <a href="#" name="lastP" onClick="navigator_click('last');"><img src="images/last.gif" width="22" height="22" align="absbottom" border="0"></a>
                                            </div>
                                        </td>
                                        <td width="10"><img src="images/frame_18.jpg" width="30" height="36"></td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr> 
                            <td height="25" colspan="2"><img src="images/main_03.jpg" width="990" height="25"></td>
                        </tr>
                    </table>
                </td></tr>
            </table>
        </div>
    </td></tr>
</table>
<input type="hidden" id="FAQ_ID_TEMP" name="FAQ_ID_TEMP" value="">
<input type="hidden" id="todo"        name="todo"        value="search">
</form>
</body>
</html>
<%  if (!strmsg.equals("")) {  %>
<script language="javaScript">
    <%=strmsg%>
</script>
<%  }   %>