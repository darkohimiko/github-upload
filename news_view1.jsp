<%@ page contentType="text/html; charset=tis-620"%>
<%@ include file="inc/constant.jsp" %>
<%@ include file="inc/utils.jsp" %>
<%@ include file="inc/label.jsp" %>
<jsp:useBean id="con" scope="session" class="edms.cllib.EABConnector"/>
<%
	con.setRemoteServer("EAS_SERVER");

    String strClassName = "NEWS_MANAGER";

    String strCurrentPage = request.getParameter( "CURRENT_PAGE" );
    try{
        if( strCurrentPage == null || Integer.parseInt( strCurrentPage ) == 0 ) {
            strCurrentPage = "1";
        }
    }catch(NumberFormatException nfe){
        strCurrentPage = "1";
    }
    
    String  strmsg          = "";
    boolean bolnSuccess     = false;

    String  strNewsIdData = ""; //checkNull(request.getParameter( "NEWS_ID_TEMP" ));
    String  strHeaderData = "";
    String  strSourceData = "";
    
    String  strScript    = "";
    String  strTotalPage = "1";
    String  strTotalSize = "0";

    String pagesize = "20";

    con.addData( "PAGENUMBER", "String", strCurrentPage );
    con.addData( "PAGESIZE",   "String", pagesize );
    bolnSuccess = con.executeService( strContainerName, strClassName, "selectAllViewNewsManager" );
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
	//lb_news_view.innerHTML    = lbl_news_view;
    //lb_total_record.innerHTML = lbl_total_record;
    //lb_record.innerHTML       = lbl_record;
}

function buttonClick( lv_strMethod, lv_strValue ) {
    switch( lv_strMethod ) {
        case "view" :
        	form1.NEWS_ID_TEMP.value = lv_strValue.getAttribute("NEWS_ID");
                form1.todo.value = "detail";
                form1.method = "post";
        	form1.submit();
			break;
	}
}

function navigatorClick( lv_direct ) {
	var lv_intCurrPage  = parseInt( form1.CURRENT_PAGE.value );
	var lv_intTotalPage = totalPage;

    if( lv_intTotalPage == null || lv_intTotalPage == "" ) {
        lv_intTotalPage = 0;
    }

    switch( lv_direct ){
		case "firstP" :
            if( lv_intCurrPage == 1 ) {
                return false;
            }
            lv_intCurrPage = 1;
            break;
		case "previousP" :
            if( lv_intCurrPage == 1 ) {
                return false;
            }
            lv_intCurrPage--;
            break;
		case "nextP" :
            if( lv_intCurrPage == lv_intTotalPage ) {
                return false;
            }
            lv_intCurrPage++;
            break;
		case "lastP" :
            if( lv_intCurrPage == lv_intTotalPage ) {
                return false;
            }
            lv_intCurrPage = lv_intTotalPage;
            break;
	}
	form1.CURRENT_PAGE.value = lv_intCurrPage;        
    form1.todo.value    = "search";
    form1.submit();
}

function page_close() {
//	window.open('','_self','');
//	window.opener = self;
	window.close();
}

//-->
</script>
<link href="css/edas.css" type="text/css" rel="stylesheet">
</head>
<body onLoad="MM_preloadImages('images/close_over.gif');window_onload();" class="bg">
<form name="form1" method="post" action="news" >
<table width="100%" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
    <tr>
        <td valign="top">
            <div id="screen_div" style="width:100%;height:100%;overflow-y:scroll;overflow-x:hidden;margin-right:0px;margin-bottom:0px;border:0px #ccc solid;" >
                <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
                    <tr><td class="bg">
                        <table width="990" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
                            <tr> 
                                <td width="504" height="109"><img src="images/main_01.jpg" width="504" height="109"></td>
                                <td width="486" valign="bottom" background="images/main_information.jpg" style="padding-right:25px" align="right">
                                    <a href="#" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('close','','images/close_over.gif',1)" onclick="page_close()"><img src="images/close.gif" name="close" width="25" height="25" border="0"></a>
                                </td>
                            </tr>
                            <tr valign="top" align="center">
                                <td colspan="2" background="images/main_bg.jpg"><div align="center" >
                                    <table width="885" border="0" align="center" cellpadding="0" cellspacing="0">
                                        <tr> 
                                            <td background="images/dot_2.gif"><img src="images/information.gif" width="155" height="25"></td>
                                        </tr>
                                    </table>
                                    <table border="0" cellspacing="0" cellpadding="0" id="content" align="left" style="padding-left: 50px;">
<%
    if( bolnSuccess ) {
        while( con.nextRecordElement() ) {
            strNewsIdData = con.getColumn( "NEWS_ID" );
            strHeaderData = con.getColumn( "HEADER" );
            strSourceData = con.getColumn( "EDAS_SOURCE_NAME" );
            
            strScript = "NEWS_ID=\"" + strNewsIdData + "\" HEADER=\"" + strHeaderData + "\" ";
%>              
                                        <tr>
                                            <td  class="news_link">
                                                <a href="#" id="manul" onclick= "buttonClick('view',this)"<%=strScript%>><%=strHeaderData%> [<%=strSourceData %>]</a>
                                            </td>
                                        </tr>
<%
		}
	}else {
%>
					<tr class="table_data1"> 
                                              <td style="padding-left: 290px;"><div align="center"><%=lc_data_not_found %></div></td>
                                        </tr>
<%
	}
%>                
                                    </table>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" background="images/main_bg.jpg">
                                <table width="885" border="0" align="center" cellpadding="0" cellspacing="0">
                                    <tr> 
                                        <td width="31"><img src="images/frame_15.jpg" width="31" height="36"></td>
                                        <td width="824" background="images/frame_16.jpg">
                                            <div align="center">
                                                <a href="#" name="firstP" onClick="navigatorClick('firstP');"><img src="images/first.gif" width="22" height="22" align="absbottom" border="0"></a>
                                                <a href="#" name="previousP" onClick="navigatorClick('previousP');"><img src="images/prv.gif" width="22" height="22" align="absbottom" border="0"></a>
                                                <input name="CURRENT_PAGE" type="text" class="input_box_disable" style="text-align:center" size="3" value="<%=strCurrentPage%>" readonly>/
                                                <input name="TOTAL_PAGE" type="text" class="input_box_disable" style="text-align:center" size="3" value="<%=strTotalPage%>" readonly>
                                                <a href="#" name="nextP" onClick="navigatorClick('nextP');"><img src="images/next.gif" width="22" height="22" align="absbottom" border="0"></a>
                                                <a href="#" name="lastP" onClick="navigatorClick('lastP');"><img src="images/last.gif" width="22" height="22" align="absbottom" border="0"></a>
                                            </div>
                                        </td>
                                        <td width="30"><img src="images/frame_18.jpg" width="30" height="36"></td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr> 
                            <td height="25" colspan="2"><img src="images/main_03.jpg" width="990" height="25">
                                <input type="hidden" name="NEWS_ID_TEMP" value="">
                                <input type="hidden" name="todo" value="">
                            </td>
                        </tr>
                        </table>
                    </td></tr>
                </table>
            </div>
        </td>
    </tr>
</table>
</form>
</body>
</html>
<%  if (!strmsg.equals("")) {  %>
<script language="javaScript">
    <%=strmsg%>
</script>
<%  }   %>