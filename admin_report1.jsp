<%@ page contentType="text/html; charset=tis-620"%>
<%@ page import="com.scc.edms.conf.ImageConfUtil"%>
<%@ page import="com.scc.security.UserInfo"%>
<%@ include file="inc/checkUser.jsp" %>
<%@ include file="inc/constant.jsp" %>
<%@ include file="inc/label.jsp" %>
<%@ include file="inc/utils.jsp" %>
<jsp:useBean id="con" scope="session" class="edms.cllib.EABConnector"/>
<%
    con.setRemoteServer("EAS_SERVER");
	
    UserInfo userInfo     = (UserInfo)session.getAttribute( "USER_INFO" );
    String strProjectCode = userInfo.getProjectCode();

    String screenname   = getField( request.getParameter("screenname") );
    String strClassName = "USER_REPORT";
    String strMode      = getField(request.getParameter("MODE"));

    String strFinishDate = getField(request.getParameter("FINISH_DATE"));
    String strFinishTime = getField(request.getParameter("FINISH_TIME"));
    
    boolean bolnSuccess = true;
    String  strVersionLang  = ImageConfUtil.getVersionLang();
	
    if( strMode == null || strMode == "" ){
        strMode = "ONLOAD";
    }
    
    if(strMode.equals("ONLOAD")){
    	con.addData( "REPORT_TYPE", "String", "ARCHIVE");
        bolnSuccess = con.executeService( strContainerName , strClassName , "selectUserReportOnLoad" );
        if( !bolnSuccess ){
            strMode         = "ONLOAD";
        }else{
            strFinishDate = con.getHeader("FINISH_DATE");
            strFinishTime = con.getHeader("FINISH_TIME");
            strMode       = "ONLOAD";
        }
    }
    
    if(strMode.equals("COUNT")){
        con.addData( "PROJECT_CODE", "String", strProjectCode);
        bolnSuccess = con.executeService( strContainerName , strClassName , "selectAdminReport" );
        if( !bolnSuccess ){
            strMode = "SEARCH";
        }else{
            strMode = "REPORT";
        }
     }
    
%>

<!DOCTYPE HTML>
<html>
<head>
<title><%=lc_site_name%></title>
<meta http-equiv="Content-Type" content="text/html; charset=tis-620">
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
<script language="JavaScript" src="js/label/lb_admin_report.js"></script>
<script language="JavaScript" src="js/util.js"></script>
<script language="JavaScript" src="js/constant.js"></script>
<script language="JavaScript" type="text/javascript">
<!--

var mode       = "<%=strMode %>";
var strVerLang = "<%=strVersionLang %>";
var finishDate = "<%=strFinishDate%>";
var finishTime = "<%=strFinishTime%>";

$(document).ready(window_onload);

function window_onload() {
    if( mode == "REPORT" ) {
    	openReport();
    }else if( mode == "SEARCH" ) {
    	alert( lc_report_data_not_found );
    }else if( mode == "ONLOAD" ) {
    	if( finishDate != "" ) {
            if( strVerLang == "thai" ) {
                $("#lb_user_report_warning").text(lbl_report_date + displayFullDateThai(finishDate) + lbl_report_time + finishTime + ")");
            }else {
                $("#lb_user_report_warning").text(lbl_report_date + displayFullDateEng(finishDate) + lbl_report_time + finishTime + ")");
            }
    	}
    }
}

function openReport() {
	if( finishDate != "" ) {
            if( strVerLang == "thai" ) {
                $("#lb_user_report_warning").text(lbl_report_date + displayFullDateThai(finishDate) + lbl_report_time + finishTime + ")");
            }else {
                $("#lb_user_report_warning").text(lbl_report_date + displayFullDateEng(finishDate) + lbl_report_time + finishTime + ")");
            }
	}
	if( strVerLang == "thai" ) {
            $("#formReport #P_DATE").val(lbl_report_date + displayFullDateThai(finishDate) + lbl_report_time + finishTime + ")");
            $("#formReport #P_DISPLAYDATE").val("<%=dateToDisplay( getServerDateThai(), "/" )%>");
	}else {
            $("#formReport #P_DATE").val(lbl_report_date + displayFullDateEng(finishDate) + lbl_report_time + finishTime + ")");
            $("#formReport #P_DISPLAYDATE").val("<%=dateToDisplay( getServerDateEng(), "/" )%>");
	}
	
    lp_new_window( "report" );
    $("#formReport").attr('target', "report");
    $("#formReport").submit();
}

function click_search(){    
    $("#form1 #MODE").val("COUNT");
    $("#form1").submit();
}

//-->
</script>
<link href="css/edas.css" type="text/css" rel="stylesheet">
</head>
<body onLoad="MM_preloadImages('images/btt_printreport_over.gif');">
<form id="form1" name="form1" method="post">
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0" align="center">
    <tr>
        <td valign="top">
            <table width="800" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td height="25" class="label_header01" colspan="2">&nbsp;&nbsp;<%=screenname%></td>
                </tr>
                <tr>
                    <td width="25">&nbsp;</td>
                    <td height="25" align="left">
            		<table width="495" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td height="25" >&nbsp;</td>
                            </tr>
                            <tr>
                                <td height="25" align="center" class="label_bold2">
                                    <span id="lb_user_report_warning"></span>
                                </td>
                            </tr>
                            <tr>
                                <td height="25" >&nbsp;</td>
                            </tr>
                            <tr>
                                <td align="center" >
                                    <a href="#" onclick= "click_search()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('searh','','images/btt_printreport_over.gif',1)">
                                        <img src="images/btt_printreport.gif" name="searh" width="102" height="22" border="0"></a>
                                </td>
                            </tr>
                            <tr>
                                <td align="center">
                                    <input type="hidden" id="MODE"        name="MODE"        value="<%=strMode%>">
                                    <input type="hidden" id="screenname"  name="screenname"  value="<%=screenname%>">
                                    <input type="hidden" id="FINISH_DATE" name="FINISH_DATE" value="<%=strFinishDate %>">
                                    <input type="hidden" id="FINISH_TIME" name="FINISH_TIME" value="<%=strFinishTime %>">
                                </td>
                            </tr>
                    </table>
            	</td>
            </tr>
        </table>
      </td>
    </tr>
</table>
</form>
<form id="formReport" name="formReport" action="<%=request.getScheme()%>://<%=request.getServerName()+ ":" + request.getServerPort() %>/jrw510/jrq" method="post">
<input type="hidden" id="P_DATE"        name="P_DATE"         value="">
<input type="hidden" id="P_DISPLAYDATE" name="P_DISPLAYDATE"  value="">
<input type="hidden" id="init"          name="init"          value="pdf">
<input type="hidden" id="report"        name="report"        value="EDAS2_7">
</form>
</body>
</html>