<%@ page contentType="text/html; charset=tis-620"%>
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
    String strUerOrgName  = userInfo.getUserOrgName();

    String screenname   = getField(request.getParameter("screenname"));
    String strClassName = "RDSCAN_DOCUMENT";
    String strMode      = checkNull(request.getParameter("MODE"));

    String strScanDateSearch   = checkNull(request.getParameter("SCAN_DATE"));
    String strToScanDateSearch = checkNull(request.getParameter("TO_SCAN_DATE"));
    String strScanUserSearch   = checkNull(request.getParameter("SCAN_USER"));
    String strScanUserName     = getField(request.getParameter("SCAN_USER_NAME"));
    
    boolean bolnSuccess = true;    
	
    if( strMode == null || strMode == "" ){
        strMode = "ONLOAD";
    }

    if(strMode.equals("COUNT")){
        con.addData( "PROJECT_CODE", "String", strProjectCode);
        if( strScanDateSearch.length() != 0 ) {
            strScanDateSearch = dateToDB(strScanDateSearch);
            con.addData( "SCAN_DATE",     "String", strScanDateSearch);
        }
        if( strToScanDateSearch.length() != 0 ) {
            strToScanDateSearch = dateToDB(strToScanDateSearch);
            con.addData( "TO_SCAN_DATE",  "String", strToScanDateSearch);
        }
        if( strScanUserSearch.length() != 0 ) {
            con.addData( "USER_ID",  "String", strScanUserSearch);
        }
        con.addData( "PROJECT_CODE",  "String", strProjectCode);
        bolnSuccess = con.executeService( strContainerName , strClassName , "selectScanReport" );
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
<script language="JavaScript" src="js/function/field-utils.js"></script>
<script language="JavaScript" src="js/label/lb_admin_report.js"></script>
<script language="JavaScript" src="js/sccUtils.js"></script>
<script language="JavaScript" src="js/util.js"></script>
<script language="JavaScript" src="js/constant.js"></script>
<script language="JavaScript" src="js/label.js"></script>
<script language="JavaScript" type="text/javascript">
<!--

var sccUtils      = new SCUtils();
var mode          = "<%=strMode %>";
var gv_scan_date = "<%=strScanDateSearch %>";
var gv_to_date    = "<%=strToScanDateSearch %>";
var gv_scan_user = "<%=strScanUserSearch%>";
var gv_scan_name = "<%=strScanUserName%>";
var objZoomWindow;

$(document).ready(window_onload);
$(document).unload(window_onunload);

function window_onload() {
    set_label();
    set_init();
    set_field();
}

function set_label(){
    $("#lb_from_date").text(lbl_from_date);
    $("#lb_to_date").text(lbl_to_date);
    $("#lb_user_id_name").text(lbl_user_id_name);
}

function set_init(){    
    $("#SCAN_DATE").val(dateToScreen( gv_scan_date ));
    $("#TO_SCAN_DATE").val(dateToScreen( gv_to_date ));
    
    if(gv_scan_user != ""){
        $("#SCAN_USER").val(gv_scan_user);
        $("#SCAN_USER_NAME").val(gv_scan_name);
    }
    
    if( mode == "REPORT" ) {
    	openReport();
    }else if( mode == "SEARCH" ) {
    	alert( lc_report_data_not_found );    	
    }
}

function set_field(){
    global_field = "SCAN_DATE,TO_SCAN_DATE,lnkSearch";
}

function openReport() {
//    lp_new_window( "report" );
    formReport.P_START_DATE.value = gv_scan_date;
    formReport.P_END_DATE.value   = gv_to_date;    
    if(gv_scan_user != ""){
        formReport.P_WHERE.value      = "AND A.SCAN_USER = '" + gv_scan_user + "'";
    }
    formReport.target = "report";
    formReport.submit();
}

function click_search(){
    if( verify_form() ) {
        form1.MODE.value = "COUNT" ;
        form1.submit();
    }
}

function click_reset() {
    $("#SCAN_DATE").val("");
    $("#TO_SCAN_DATE").val("");
    $("#SCAN_USER").val("");
    $("#SCAN_USER_NAME").val("");
    $("#SCAN_DATE").focus();
}

function checkFromDate( obj_field ) {
    var todayDate = $("#txtTodayDate").val();
    var dateField = sccUtils.formatDate( obj_field.value );
    var dateDb    = dateToDb( dateField );

    if( parseInt(dateDb) > parseInt(todayDate) ) {
        alert( lc_from_date_not_over );
        obj_field.value = "";
    }
}

function checkTodayDate( obj_field ) {
    var todayDate = $("#txtTodayDate").val();
    var dateField = sccUtils.formatDate( obj_field.value );
    var dateDb    = dateToDb( dateField );
    var idxDate   = dateToDb( $("#SCAN_DATE").val() );

    if( parseInt(dateDb) < parseInt(idxDate) ) {
        alert( lc_to_date_not_over_add_date );
        obj_field.value = "";
        return;
    }
    if( parseInt(dateDb) > parseInt(todayDate) ) {
        alert( lc_to_date_not_over );
        obj_field.value = "";
        return;
    }
}

function set_format_date( obj_field ){
    if( obj_field.value.length == 8 && sccUtils.isDateValid( obj_field.value ) == "VALID_DATE" ){
        obj_field.value = sccUtils.formatDate( obj_field.value );
    }else {
        if( obj_field.value != "" && sccUtils.isDateValid( obj_field.value ) != "VALID_DATE" ){
            alert( lc_fill_date_correct );
            obj_field.value = "";
        }
    }
}

function verify_form() {
	
    if( $("#SCAN_DATE").val().length == 0 ) {
        alert( lc_check_from_date_emp );
        $("#SCAN_DATE").focus();
        return false;
    }
        
    if( $("#TO_SCAN_DATE").val().length == 0 ) {
        alert( lc_check_to_date_emp );
        $("#TO_SCAN_DATE").focus();
        return false;
    }
        
    if( (parseInt(dateToDb( $("#SCAN_DATE").val()))) > (parseInt(dateToDb( $("#TO_SCAN_DATE").val())) ) ){
        alert( lc_check_to_date_not_over );
        $("#TO_SCAN_DATE").focus();
        return false;
    }
        
    return true;
}

function open_zoom() {
    var strPopArgument   = "scrollbars=yes,status=no";
    var strWidth         = ",width=370px";
    var strHeight        = ",height=420px";
    var strUrl           = "";
    var strConcatField   = "";

    strPopArgument += strWidth + strHeight;

    strUrl = "inc/zoom_user_profile.jsp";
    strConcatField = "TABLE=ORG&TABLE_LABEL=" + lbl_org;
    strConcatField += "&USER_ORG=00000701";
    strConcatField += "&RESULT_FIELD=SCAN_USER,SCAN_USER_NAME";

    objZoomWindow = window.open( strUrl + "?" + strConcatField, "user", strPopArgument );
    objZoomWindow.focus();
}

function window_onunload() {
    if (objZoomWindow != null && !objZoomWindow.closed) {
        objZoomWindow.close();
    }
}

//-->
</script>
<link href="css/edas.css" type="text/css" rel="stylesheet">
</head>
<body onLoad="MM_preloadImages('images/btt_new_over.gif','images/btt_search_over.gif','images/btt_printreport_over.gif');">
<form name="form1" method="post" >
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0" align="center">
    <tr>
        <td valign="top">
            <table width="700" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td height="25" class="label_header01" colspan="4">&nbsp;&nbsp;<%=screenname%></td>
                </tr>
                <tr>
                    <td height="25" align="center">
            		<table width="500" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td height="25" colspan="4">&nbsp;</td>
                            </tr>
                            <tr align="left">
                                <td width="80" height="25" class="label_bold2"><span id="lb_from_date"></span><span class="mark">*</span></td>
                                <td width="120">
                                    <input id="SCAN_DATE" name="SCAN_DATE" type="text" class="input_box" size="12" maxlength="8" onkeypress="keypress_number(event);key_press( this );" onBlur="checkFromDate( this );set_format_date( this );"> 
                                    <a href="javascript:showCalendar(form1.SCAN_DATE,1)"><img src="images/calendar.gif" width=16 height=16 align="absmiddle" border=0 ></a>
                                </td>
                                <td width="80" height="25" class="label_bold2"><span id="lb_to_date"></span><span class="mark">*</span></td>
                                <td width="*">
                                    <input id="TO_SCAN_DATE" name="TO_SCAN_DATE" type="text" class="input_box" size="12" maxlength="8" onkeypress="keypress_number(event);key_press( this );" onBlur="checkTodayDate( this );set_format_date( this );"> 
                                    <a href="javascript:showCalendar(form1.TO_SCAN_DATE,1)"><img src="images/calendar.gif" width=16 height=16 align="absmiddle" border=0 ></a>
                                </td>
                            </tr>
                            <tr align="left">
                                <td class="label_bold2"><span id="lb_user_id_name"></span></td>
                                <td colspan="3">
                                    <input id="SCAN_USER" name="SCAN_USER" type="text" size="14" class="input_box_disable" readOnly >&nbsp;
                                    <a href="javascript:open_zoom();"><img id="imgZoomDocLevel" src="images/search.gif" width="16" height="16" border="0"></a>
                                    <input id="SCAN_USER_NAME" name="SCAN_USER_NAME" type="text" size="40" class="input_box_disable" readOnly >
                                </td>
                            </tr>
                            <tr>
                                <td height="25" colspan="4">&nbsp;</td>
                            </tr>
                            <tr>
                                <td align="center" colspan="4">
                                    <a href="#" id="lnkSearch" onclick="click_search()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('bttSearch','','images/btt_search_over.gif',1)">
                                        <img src="images/btt_search.gif" id="bttSearch" name="bttSearch" width="67" height="22" border="0"></a>&nbsp;
                                    <a href="#" onclick= "click_reset()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new','','images/btt_new_over.gif',1)">
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
<input type="hidden" id="MODE"       name="MODE"        value="<%=strMode%>">
<input type="hidden" id="screenname" name="screenname"  value="<%=screenname%>">
</form>

<form id="formReport" action="<%=request.getScheme()%>://<%=request.getServerName()+ ":" + request.getServerPort() %>/jrw510/jrq" method="post">
<input type="hidden" id="P_PROJECTNAME"  name="P_PROJECTNAME"  value="<%=strProjectName %>">
<input type="hidden" id="P_START_DATE"   name="P_START_DATE"   value="">
<input type="hidden" id="P_END_DATE"     name="P_END_DATE"     value="">
<input type="hidden" id="P_WHERE"        name="P_WHERE"        value="">
<input type="hidden" id="P_DEPT"         name="P_DEPT"         value="<%=strUerOrgName%>">
<input type="hidden" id="init"           name="init"           value="pdf">
<%  if(strProjectCode.equals("00000001")){%>
<input type="hidden" id="report" name="report" value="UserReport5_PP30">
<%  }else if(strProjectCode.equals("00000002")){%>
<input type="hidden" id="report" name="report" value="UserReport5_PP36">
<%  }else if(strProjectCode.equals("00000003")){%>
<input type="hidden" id="report" name="report" value="UserReport5_PT40">
<%  }%>
</form>

</body>
</html>