<%@page import="com.scc.edms.conf.ImageConfUtil"%>
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
    
    String screenname   = getField(request.getParameter("screenname"));
    String strClassName = "USER_REPORT";
    String strMode      = getField(request.getParameter("MODE"));

    String strProjectFlagData      = getField(request.getParameter("hidProjectFlag"));
    String strProjectOwnerData     = getField(request.getParameter("txtProjectOwner"));
    String strCabinateCodeData     = getField(request.getParameter("txtCabinateCode"));
    String strAddDateData          = getField(request.getParameter("ADD_DATE"));
    String strToAddDateData        = getField(request.getParameter("TO_ADD_DATE"));
    String strWhereCause           = getField(request.getParameter("P_WHERE"));
    String strDateCause            = getField(request.getParameter("P_DATE"));
    String strDateCause2           = getField(request.getParameter("P_DATE2"));
    String strFinishDate           = getField(request.getParameter("FINISH_DATE"));
    String strFinishTime           = getField(request.getParameter("FINISH_TIME"));
    
    boolean bolnSuccess     = true;
    String  strCurrentDate  = "";
    String  strVersionLang  = ImageConfUtil.getVersionLang();
    String  strLangFlag     = "";

    if( strVersionLang.equals("thai") ) {
            strCurrentDate = getServerDateThai();
            strLangFlag    = "1";
    }else {
            strCurrentDate = getServerDateEng();
            strLangFlag    = "0";
    }
	
    if( strMode == null || strMode == "" ){
        strMode = "ONLOAD";
    }
    
    if(strMode.equals("ONLOAD")){
    	con.addData( "REPORT_TYPE", "String", "LOG");
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
        con.addData( "PROJECT_FLAG", "String", strProjectFlagData);
        if( !strProjectOwnerData.equals("") ) {
        	con.addData( "PROJECT_OWNER", "String", strProjectOwnerData);
        }
        if( !strCabinateCodeData.equals("") ) {
        	con.addData( "PROJECT_CODE", "String", strCabinateCodeData);
        }
        if( !strAddDateData.equals("") ) {
        	con.addData( "ADD_DATE",     "String", strAddDateData);
        }
        if( !strToAddDateData.equals("") ) {
        	con.addData( "TO_ADD_DATE",  "String", strToAddDateData);
        }
        
        bolnSuccess = con.executeService( strContainerName , strClassName , "selectAdminReport3" );
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
<script language="JavaScript" src="js/function/field-utils.js"></script>
<script language="JavaScript" src="js/sccUtils.js"></script>
<script language="JavaScript" src="js/util.js"></script>
<script language="JavaScript" src="js/constant.js"></script>
<script language="JavaScript" type="text/javascript">
<!--

var sccUtils   = new SCUtils();
var mode       = "<%=strMode %>";
var strVerLang = "<%=strVersionLang %>";

$(document).ready(window_onload);

function window_onload() {
    set_field();
    set_label();
    set_init();
}

function set_field(){
    global_field = "ADD_DATE,TO_ADD_DATE";
}

function set_label(){
    $("#lb_doc_cabinet_type").text(lbl_doc_cabinet_type);
    $("#lb_public").text(lbl_public);
    $("#lb_private").text(lbl_private);
    $("#lb_cabinet_document").text(lbl_cabinet_document);
    $("#lb_user_cabinet").text(lbl_user_cabinet);
    $("#lb_from_date").text(lbl_from_date);
    $("#lb_to_date").text(lbl_to_date);
    $("#lb_user_report_warning2").text(lbl_user_report_warning2);
}

function set_init(){
    if( mode == "REPORT" ) {
    	openReport();
    }else if( mode == "SEARCH" ) {
    	alert( lc_report_data_not_found );
    	clearDefault();
    }else {
    	$("#rdoDocType1").attr('checked' ,true);
    	$("#hidProjectFlag").val("2");
    }
}

function openReport() {
    formReport.P_DISPLAYDATE.value = "<%=dateToDisplay( strCurrentDate, "/" ) %>";
    lp_new_window( "report" );
    formReport.target = "report";
    formReport.submit();
    clearDefault();
}

function keypress_number(){
    var carCode = event.keyCode;
    if ((carCode < 48) || (carCode > 57)){
        if( event.preventDefault ){
            event.preventDefault();
        }else{
            event.returnValue = false;
        }
        return;
    }
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
	var addDate   = dateToDb( $("#ADD_DATE").val() );
	
	if( parseInt(dateDb) < parseInt(addDate) ) {
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

function openZoom( strZoomType ) {
    var strPopArgument   = "scrollbars=yes,status=no";
    var strWidth         = ",width=370px";
    var strHeight        = ",height=420px";
    var strUrl           = "";
    var strConcatField   = "";

    strPopArgument += strWidth + strHeight;

    switch( strZoomType ){
        case "owner" :
            if( $("#hidProjectFlag").val() == "2" ) {
                    strUrl = "inc/zoom_data_table_level1.jsp";
                    strConcatField = "TABLE=ORG" + "&TABLE_LABEL=" + lbl_org;
                    strConcatField += "&RESULT_FIELD=txtProjectOwner,txtProjectOwnerName";
                    //strConcatField += "&RESULT_FIELD=txtCabinateCode,txtCabinateName";
                    break;
            }else {
                    strUrl = "inc/zoom_user_profile.jsp";
                    strConcatField += "&RESULT_FIELD=txtProjectOwner,txtProjectOwnerName";
                    break;
            }
        case "name" :
            strUrl = "inc/zoom_user_report1.jsp";
            strConcatField = "TABLE=ORG" + "&TABLE_LABEL=" + lbl_org;
            strConcatField += "&PROJECT_FLAG=" + $("#hidProjectFlag").val();
            //strConcatField += "&RESULT_FIELD=txtProjectOwner,txtProjectOwnerName";
            strConcatField += "&RESULT_FIELD=txtCabinateCode,txtCabinateName";
            break;
    }

    objZoomWindow = window.open( strUrl + "?" + strConcatField, strZoomType, strPopArgument );
    objZoomWindow.focus();
}

function getRadioValue( lv_docType ) {	
    if( lv_docType == "public" ) {
        $("#hidProjectFlag").val("2");
    }else {
        $("#hidProjectFlag").val("3");
    }
}

function clearDefault() {
    $("#rdoDocType1").attr('checked', true);
    $("#hidProjectFlag").val("2");
    $("#txtCabinateCode").val("");
    $("#txtCabinateName").val("");
    $("#txtProjectOwner").val("");
    $("#txtProjectOwnerName").val("");
    $("#ADD_DATE").val("");
    $("#TO_ADD_DATE").val("");
}

function verify_form() {
    var strAddDate   = dateToDb( $("#ADD_DATE").val() );
    var strToAddDate = dateToDb( $("#TO_ADD_DATE").val() );
    var strPdate     = "";
    var strPdate2    = "";
    var whereCon     = "";

    if( $("#hidProjectFlag").val() == "2" ) {
            whereCon = "WHERE B.PROJECT_FLAG IN ('"+$("#hidProjectFlag").val() + "','4') ";
    }else {
            whereCon = "WHERE B.PROJECT_FLAG='"+$("#hidProjectFlag").val() + "' ";
    }
	
    if( strVerLang == "thai" ) {
        strPdate2 = lbl_report_date + displayFullDateThai($("#FINISH_DATE").val()) + lbl_report_time + $("#FINISH_TIME").val() + ")";
    }else {
        strPdate2 = lbl_report_date + displayFullDateEng($("#FINISH_DATE").val()) + lbl_report_time + $("#FINISH_TIME").val() + ")";
    }
	
    if( $("#txtCabinateCode").val().length != 0 ) {
        whereCon += "AND B.PROJECT_CODE='"+$("#txtCabinateCode").val() + "' ";
    }
    
    if( $("#txtProjectOwner").val().length != 0 ) {
    	whereCon += "AND B.PROJECT_OWNER='"+$("#txtProjectOwner").val() + "' ";
    }
    
    if( $("#ADD_DATE").val().length != 0 || $("#TO_ADD_DATE").val().length != 0 ) {
        if( $("#ADD_DATE").val().length == 0 ) {
            alert( lc_check_from_date_emp );
            $("#ADD_DATE").focus();
            return false;
        }
        if( $("#TO_ADD_DATE").val().length == 0 ) {
            alert( lc_check_to_date_emp );
            $("#TO_ADD_DATE").focus();
            return false;
        }
        if( (parseInt(strAddDate)) > (parseInt(strToAddDate)) ) {
            alert( lc_check_to_date_not_over );
            $("#TO_ADD_DATE").focus();
            return false;
        }
        if( strVerLang == "thai" ) {
            strPdate = lbl_from_date + displayFullDateThai(strAddDate) + lbl_to_date + displayFullDateThai(strToAddDate);
        }else {
            strPdate = lbl_from_date + displayFullDateEng(strAddDate) + lbl_to_date + displayFullDateEng(strToAddDate);
        }
        whereCon += "AND A.ACTION_DATE >= '"+strAddDate+"' AND A.ACTION_DATE <= '"+strToAddDate+"' ";
	    
        $("#form1 #P_DATE").val(strPdate);
        $("#form1 #P_DATE2").val(strPdate2);
        $("#form1 #P_WHERE").val(whereCon);
        $("#ADD_DATE").val(strAddDate);
        $("#TO_ADD_DATE").val(strToAddDate);
    }else {
        $("#form1 #P_DATE").val("-");
        $("#form1 #P_DATE2").val(strPdate2);
        $("#form1 #P_WHERE").val(whereCon);
    }
    
	$("#form1 #P_WHERE").val(whereCon);
	return true;
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
<body onLoad="MM_preloadImages('images/btt_new_over.gif','images/btt_search_over.gif','images/btt_printreport_over.gif');">
<form id="form1" name="form1" method="post" >
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0" align="center">
    <tr>
        <td valign="top">
            <table width="800" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td height="25" class="label_header01" colspan="2">&nbsp;&nbsp;<%=screenname%></td>
                </tr>
                <tr>
                    <td width="30">&nbsp;</td>
                    <td height="25" align="left">
            		<table width="550" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td height="25" colspan="4">&nbsp;</td>
                            </tr>
                            <tr>
                                <td width="135" height="25" class="label_bold2"><span id="lb_doc_cabinet_type"></span></td>
                                <td height="25" colspan="3" class="label_bold2" >
                                    <input type="radio" id="rdoDocType1" name="rdoDocType" onclick="getRadioValue('public');"><span id="lb_public"></span>
                                    <input type="radio" id="rdoDocType2" name="rdoDocType" onclick="getRadioValue('private');"><span id="lb_private"></span>
                                </td>
                            </tr>
                            <tr>
                                <td class="label_bold2"><span id="lb_cabinet_document" class="label_bold2"></span></td>
                                <td colspan="3">
                                    <input id="txtCabinateCode" name="txtCabinateCode" type="text" size="14" maxlength="20" class="input_box_disable" readOnly >&nbsp;
                                    <a href="javascript:openZoom('name');"><img id="imgZoomDocLevel" src="images/search.gif" width="16" height="16" border="0"></a>&nbsp;
                                    <input id="txtCabinateName" name="txtCabinateName" type="text" size="40" maxlength="50" class="input_box_disable" readOnly >
                                </td>
                            </tr>
                            <tr>
                                <td class="label_bold2"><span id="lb_user_cabinet" class="label_bold2"></span></td>
                                <td colspan="3">
                                    <input id="txtProjectOwner" name="txtProjectOwner" type="text" size="14" maxlength="20" class="input_box_disable" readOnly >&nbsp;
                                    <a href="javascript:openZoom('owner');"><img id="imgZoomDocLevel" src="images/search.gif" width="16" height="16" border="0"></a>&nbsp;
                                    <input id="txtProjectOwnerName" name="txtProjectOwnerName" type="text" size="40" maxlength="50" class="input_box_disable" readOnly >
                                </td>
                            </tr>
                            <tr>
                                <td height="25" class="label_bold2"><span id="lb_from_date"></span></td>
                                <td width="100">
                                    <input id="ADD_DATE" name="ADD_DATE" type="text" class="input_box" size="10" maxlength="10" onkeypress="keypress_number();key_press(this);" onBlur="checkFromDate( this );set_format_date( this );"> 
                                    <a href="javascript:showCalendar(form1.ADD_DATE,<%=strLangFlag %>)"><img src="images/calendar.gif" width=16 height=16 align="absmiddle" border=0 ></a>
                                </td>
                                <td width="65" height="25" class="label_bold2"><span id="lb_to_date"></span></td>
                                <td>
                                    <input id="TO_ADD_DATE" name="TO_ADD_DATE" type="text" class="input_box" size="10" maxlength="10" onkeypress="keypress_number();key_press(this);" onBlur="checkTodayDate( this );set_format_date( this );"> 
                                    <a href="javascript:showCalendar(form1.TO_ADD_DATE,<%=strLangFlag %>)"><img src="images/calendar.gif" width=16 height=16 align="absmiddle" border=0 ></a>
                                </td>
                            </tr>
                            <tr>
                                <td height="25" colspan="4">&nbsp;</td>
                            </tr>
                            <tr>
                                <td height="25" colspan="4" class="label_bold2" align="center">
                                    <span id="lb_user_report_warning2"></span>
                                </td>
                            </tr>
                            <tr>
                                <td height="25" colspan="4">&nbsp;</td>
                            </tr>
                            <tr>
                                <td align="center" colspan="4">
                                    <a href="#" id="lnkSearch" onclick= "click_search()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('bttSearch','','images/btt_search_over.gif',1)">
                                        <img src="images/btt_search.gif" id="bttSearch" name="bttSearch" width="67" height="22" border="0"></a>&nbsp;
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
<input type="hidden" id="txtTodayDate"   name="txtTodayDate"   value="<%=strCurrentDate%>">
<input type="hidden" id="PROJECT_CODE"   name="PROJECT_CODE"   value="<%=strProjectCode%>">
<input type="hidden" id="P_DATE"         name="P_DATE"         value="">
<input type="hidden" id="P_DATE2"        name="P_DATE2"        value="">
<input type="hidden" id="P_WHERE"        name="P_WHERE"        value="<%=strWhereCause %>">
<input type="hidden" id="FINISH_DATE"    name="FINISH_DATE"    value="<%=strFinishDate %>">
<input type="hidden" id="FINISH_TIME"    name="FINISH_TIME"    value="<%=strFinishTime %>">
<input type="hidden" id="hidProjectFlag" name="hidProjectFlag" value="">
</form>
<form id="formReport" action="<%=request.getScheme()%>://<%=request.getServerName()+ ":" + request.getServerPort() %>/jrw510/jrq" method="post">
<input type="hidden" id="P_DATE"         name="P_DATE"         value="<%=strDateCause%>">
<input type="hidden" id="P_DATE2"        name="P_DATE2"        value="<%=strDateCause2%>">
<input type="hidden" id="P_DISPLAYDATE"  name="P_DISPLAYDATE"  value="">
<input type="hidden" id="P_WHERE"        name="P_WHERE"        value="<%=strWhereCause %>">
<input type="hidden" id="P_FLAG"         name="P_FLAG"         value="<%=strProjectFlagData %>">
<input type="hidden" id="init"           name="init"           value="pdf">
<input type="hidden" id="report"         name="report"         value="EDAS2_9">
</form>

</body>
</html>