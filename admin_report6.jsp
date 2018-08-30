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
    String strProjectName = userInfo.getProjectName();

    String screenname   = getField(request.getParameter("screenname"));
    String strClassName = "USER_REPORT";
    String strMode      = getField(request.getParameter("MODE"));

    String strCabinateCodeData = getField( request.getParameter("txtCabinateCode") );
    String strCabinateNameData = getField( request.getParameter("txtCabinateName") );
    String strWhereCause       = getField( request.getParameter("P_WHERE") );
    String strFinishDate       = getField( request.getParameter("FINISH_DATE") );
    String strFinishTime       = getField( request.getParameter("FINISH_TIME") );
    
    boolean bolnSuccess     = true;
    String  strCurrentDate  = "";
    String  strVersionLang  = ImageConfUtil.getVersionLang();

    if( strVersionLang.equals("thai") ) {
        strCurrentDate = getServerDateThai();
    }else {
        strCurrentDate = getServerDateEng();
    }
	
    if( strMode == null || strMode == "" ){
        strMode = "ONLOAD";
    }
    
    if(strMode.equals("ONLOAD")){
    	con.addData( "REPORT_TYPE", "String", "RIGHT");
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
        con.addData( "PROJECT_CODE", "String", strCabinateCodeData );
        bolnSuccess = con.executeService( strContainerName , strClassName , "selectUserRightReport" );
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
<meta http-equiv="Content-Type" content="text/html; charset=windows-874">
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
var mode           = "<%=strMode %>";
var strVerLang     = "<%=strVersionLang %>";
var finishDate     = "<%=strFinishDate%>";
var finishTime     = "<%=strFinishTime%>";

$(document).ready(window_onload);

function window_onload() {
    set_label();
    set_init();
}

function set_label(){
    $("#lb_cabinet_document").text(lbl_cabinet_document);
}

function set_init(){
    if( mode == "REPORT" ) {
    	openReport();
    }else if( mode == "SEARCH" ) {
    	alert( lc_report_data_not_found );
    }else if( mode == "ONLOAD" ) {
    	if( finishDate != "" ) {
            if( strVerLang == "thai" ) {
                lb_user_report_warning.innerHTML = lbl_report_date + displayFullDateThai(finishDate) + lbl_report_time + finishTime + ")";
            }else {
                lb_user_report_warning.innerHTML = lbl_report_date + displayFullDateEng(finishDate) + lbl_report_time + finishTime + ")";
            }
    	}
    }
}

function openReport() {
    if( finishDate != "" ) {
        if( strVerLang == "thai" ) {
                lb_user_report_warning.innerHTML = lbl_report_date + displayFullDateThai(finishDate) + lbl_report_time + finishTime + ")";
        }else {
                lb_user_report_warning.innerHTML = lbl_report_date + displayFullDateEng(finishDate) + lbl_report_time + finishTime + ")";
        }
    }
    if( strVerLang == "thai" ) {
            $("#formReport #P_DATE").val(lbl_report_date + displayFullDateThai(finishDate) + lbl_report_time + finishTime + ")");
    }else {
            $("#formReport #P_DATE").val(lbl_report_date + displayFullDateEng(finishDate) + lbl_report_time + finishTime + ")");
    }
    $("#formReport #P_DISPLAYDATE").val("<%=dateToDisplay( strCurrentDate, "/" ) %>");
    $("#formReport #P_PROJECT_NAME").val("<%=strCabinateNameData %>");
    $("#formReport #P_WHERE").val("<%=strWhereCause %>");
	
    lp_new_window( "report" );
    $("#formReport").attr('target', "report");
    $("#formReport").submit();
}

function openZoom() {
    var strPopArgument = "scrollbars=yes,status=no";
    var strWidth       = ",width=370px";
    var strHeight      = ",height=420px";
    var strUrl         = "";
    var strConcatField = "";
    var strZoomType    = "";

    strPopArgument += strWidth + strHeight;
    strUrl         = "inc/zoom_user_report1.jsp";
    strConcatField = "TABLE=ORG" + "&TABLE_LABEL=" + lbl_org;
    strConcatField += "&PROJECT_FLAG=2";
    strConcatField += "&RESULT_FIELD=txtCabinateCode,txtCabinateName";

    objZoomWindow = window.open( strUrl + "?" + strConcatField, strZoomType, strPopArgument );
    objZoomWindow.focus();
}

function clearDefault() {
    $("#txtCabinateCode").val("");
    $("#txtCabinateName").val("");
}

function verify_form() {
    var whereCon = "";

    if( $("#txtCabinateCode").val().length == 0 ) {
        alert( lc_select_cabinet );
        return false;
    }else {
    	whereCon += "WHERE PROJECT_CODE='"+$("#txtCabinateCode").val() + "' ORDER BY USER_NAME ";
    	$("#form1 #P_WHERE").val(whereCon);
    	return true;
    }
}

function click_search(){
    if( verify_form() ) {
        $("#form1 #MODE").val("COUNT");
        $("#form1").submit();
    }
}

//-->
</script>
<link href="css/edas.css" type="text/css" rel="stylesheet">
</head>
<body onLoad="MM_preloadImages('images/btt_new_over.gif','images/btt_printreport_over.gif');">
<form id="form1" name="form1" method="post">
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0" align="center">
    <tr>
        <td valign="top">
            <table width="800" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td height="25" class="label_header01">&nbsp;&nbsp;<%=screenname%></td>
                </tr>
                <tr>
                    <td height="25" align="center">
                        <table width="495" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td height="25" colspan="2">&nbsp;</td>
                            </tr>
                            <tr>
                                <td height="25" colspan="2" align="center" class="label_bold2">
                                    <span id="lb_user_report_warning"></span>
                                </td>
                            </tr>
                            <tr>
                                <td height="25" colspan="2">&nbsp;</td>
                            </tr>
                            <tr>
                                <td class="label_bold2"><span id="lb_cabinet_document" class="label_bold2"></span>&nbsp;<img src="images/mark.gif" width="12" height="11"></td>
                                <td>
                                    <input id="txtCabinateCode" name="txtCabinateCode" type="text" size="14" maxlength="20" class="input_box_disable" readOnly >&nbsp;
                                    <a href="javascript:openZoom();"><img id="imgZoomDocLevel" src="images/search.gif" width="16" height="16" border="0"></a>
                                    <input id="txtCabinateName" name="txtCabinateName" type="text" size="40" maxlength="50" class="input_box_disable" readOnly >
                                </td>
                            </tr>
                            <tr>
                                <td height="25" colspan="2">&nbsp;</td>
                            </tr>
                            <tr>
                                <td align="center" colspan="2">
                                    <a href="#" onclick= "click_search()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('searh','','images/btt_printreport_over.gif',1)">
                                        <img src="images/btt_printreport.gif" name="searh" width="102" height="22" border="0"></a>&nbsp;
                                    <a href="#" onclick= "clearDefault()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new','','images/btt_new_over.gif',1)">
                                        <img src="images/btt_new.gif" name="new" width="67" height="22" border="0"></a>
                                </td>
                            </tr>
              		</table>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>
<input type="hidden" id="MODE"           name="MODE"           value="<%=strMode%>">
<input type="hidden" id="screenname"     name="screenname"     value="<%=screenname%>">
<input type="hidden" id="FINISH_DATE"    name="FINISH_DATE"    value="<%=strFinishDate %>">
<input type="hidden" id="FINISH_TIME"    name="FINISH_TIME"    value="<%=strFinishTime %>">
<input type="hidden" id="P_WHERE"        name="P_WHERE"        value="">
</form>
<form id="formReport" name="formReport" action="<%=request.getScheme()%>://<%=request.getServerName()+ ":" + request.getServerPort() %>/jrw510/jrq" method="post">
<input type="hidden" id="P_PROJECT_NAME" name="P_PROJECT_NAME" value="">
<input type="hidden" id="P_DATE"         name="P_DATE"         value="">
<input type="hidden" id="P_DISPLAYDATE"  name="P_DISPLAYDATE"  value="">
<input type="hidden" id="P_WHERE"        name="P_WHERE"        value="">
<input type="hidden" id="init"           name="init"           value="pdf">
<input type="hidden" id="report"         name="report"         value="EDAS2_12">
</form>
</body>
</html>