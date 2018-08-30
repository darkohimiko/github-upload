<%@page import="com.scc.edms.conf.ImageConfUtil"%>
<%@ page contentType="text/html; charset=tis-620"%>
<%@ page import="com.scc.security.UserInfo"%>
<%@ page import="java.math.BigDecimal"%>
<%@ include file="inc/checkUser.jsp" %>
<%@ include file="inc/constant.jsp" %>
<%@ include file="inc/utils.jsp" %>
<jsp:useBean id="con" scope="session" class="edms.cllib.EABConnector"/>
<jsp:useBean id="con2" scope="session" class="edms.cllib.EABConnector"/>
<%    con.setRemoteServer("EAS_SERVER");
    con2.setRemoteServer("EAS_SERVER");

    UserInfo userInfo = (UserInfo) session.getAttribute("USER_INFO");
    String strUserId = userInfo.getUserId();

    String strClassName = "SYSTEM_CONFIG";
    String strMode = checkNull(request.getParameter("MODE"));
    String screenname = getField(request.getParameter("screenname"));
    String strmsg = "";

    String strCurrentDate = "";
    String strVersionLang = ImageConfUtil.getVersionLang();

    if (strVersionLang.equals("thai")) {
        strCurrentDate = getServerDateThai();
    } else {
        strCurrentDate = getServerDateEng();
    }

    boolean bolnSuccess = true;

    BigDecimal bmultiply = new BigDecimal(1000000000);
    BigDecimal bHundred = new BigDecimal(100);
    BigDecimal bOne = new BigDecimal(1);
    BigDecimal bTotalSizeData = new BigDecimal(0);
    BigDecimal bUsedSizeData = new BigDecimal(0);
    BigDecimal bAvalSizeData = new BigDecimal(0);
    BigDecimal bUsedPercentData = new BigDecimal(0);
    BigDecimal bTotalSizeDumyData = new BigDecimal(0);
    BigDecimal bUsedSizeDumyData = new BigDecimal(0);
    BigDecimal bAvalSizeDumyData = new BigDecimal(0);

    if (!getField(request.getParameter("TOTAL_SIZE")).equals("")) {
        bTotalSizeData = new BigDecimal(getField(request.getParameter("TOTAL_SIZE")));
    }

    if (!getField(request.getParameter("USED_SIZE")).equals("")) {
        bUsedSizeData = new BigDecimal(getField(request.getParameter("USED_SIZE")));
    }

    if (!getField(request.getParameter("AVAIL_SIZE")).equals("")) {
        bAvalSizeData = new BigDecimal(getField(request.getParameter("AVAIL_SIZE")));
    }

    if (!getField(request.getParameter("USED_PERCENT")).equals("")) {
        bUsedPercentData = new BigDecimal(getField(request.getParameter("USED_PERCENT")));
    }

    String strPassExpireDaysData = getField(request.getParameter("PASSWORD_EXPIRE_DAYS"));
    String strPassWarningDaysData = getField(request.getParameter("PASSWORD_WARNING_DAYS"));
    String strEmailServerData = getField(request.getParameter("EMAIL_SERVER"));
    String strReportServerData = getField(request.getParameter("REPORT_SERVER"));
    String strLogExpireDaysData = getField(request.getParameter("LOG_EXPIRE_DAYS"));
    String strTempExpireDaysData = getField(request.getParameter("TEMP_EXPIRE_DAYS"));
    String strMediaTypeData = getField(request.getParameter("selMediaType"));
    String strLocalReportPathData = getField(request.getParameter("REPORT_PATH_LOCAL"));
    String strFtpUserData = getField(request.getParameter("REPORT_USER"));
    String strFtpPasswordData = getField(request.getParameter("REPORT_PASSWORD"));
    
    String strImportServerData     = checkNull(request.getParameter("IMPORT_SERVER"));
    String strImportServerPortData = checkNull(request.getParameter("IMPORT_SERVER_PORT"));
    String strImportWebServerData  = checkNull(request.getParameter("IMPORT_WEB_SERVER"));
    String strImportWebPortData    = checkNull(request.getParameter("IMPORT_WEB_PORT"));

    if (!getField(request.getParameter("hidTotalSizeDumy")).equals("")) {
        bTotalSizeDumyData = new BigDecimal(getField(request.getParameter("hidTotalSizeDumy")));
    }

    if (!getField(request.getParameter("hidUsedSizeDumy")).equals("")) {
        bUsedSizeDumyData = new BigDecimal(getField(request.getParameter("hidUsedSizeDumy")));
    }

    if (!getField(request.getParameter("hidAvalSizeDumy")).equals("")) {
        bAvalSizeDumyData = new BigDecimal(getField(request.getParameter("hidAvalSizeDumy")));
    }

    if (strMode == null || strMode.equals("")) {
        strMode = "SEARCH";
    }

    if (strMode.equals("UPDATE_CONFIG")) {
        con.addData("TOTAL_SIZE", "String", String.valueOf(bTotalSizeData.multiply(bmultiply)));
        con.addData("USED_SIZE", "String", String.valueOf(bUsedSizeDumyData));
        con.addData("AVAL_SIZE", "String", String.valueOf((bTotalSizeData.multiply(bmultiply)).subtract(bUsedSizeDumyData)));

        con.addData("USED_PERCENT", "String", String.valueOf((bUsedSizeData.multiply(bHundred)).divide(bTotalSizeData, 2, 0)));
        con.addData("USER_EXPIRE_DAYS", "String", strPassExpireDaysData);
        con.addData("USER_WARNING_DAYS", "String", strPassWarningDaysData);
        con.addData("EMAIL_SERVER", "String", strEmailServerData);
        con.addData("REPORT_SERVER", "String", strReportServerData);
        con.addData("LOG_EXPIRE_DAYS", "String", strLogExpireDaysData);
        con.addData("TEMP_EXPIRE_DAYS", "String", strTempExpireDaysData);
        con.addData("MEDIA_TYPE", "String", strMediaTypeData);
        con.addData("REPORT_PATH_LOCAL", "String", strLocalReportPathData);
        con.addData("REPORT_USER", "String", strFtpUserData);
        con.addData("REPORT_PASSWORD", "String", strFtpPasswordData);
        con.addData("EDIT_USER", "String", strUserId);
        con.addData("UPD_USER", "String", strUserId);
        
        con.addData( "IMPORT_SERVER"      , "String" , strImportServerData );
        con.addData( "IMPORT_WEB_SERVER"  , "String" , strImportWebServerData );
        con.addData( "IMPORT_SERVER_PORT" , "String" , strImportServerPortData );
        con.addData( "IMPORT_WEB_PORT"    , "String" , strImportWebPortData );

        con.addData("DESC", "String", "SYSTEM_CONFIG");
        con.addData("USER_ID", "String", strUserId);
        con.addData("ACTION_FLAG", "String", "SC");
        con.addData("CURRENT_DATE", "String", strCurrentDate);

        bolnSuccess = con.executeService(strContainerName, strClassName, "updateSystemConfig");
        if (!bolnSuccess) {
            strmsg = "showMsg(0,0,\" " + lc_can_not_update_data + "\")";
            strMode = "SEARCH";
        } else {
            strmsg = "showMsg(0,0,\" " + lc_update_data_successfull + "\")";
            strMode = "SEARCH";
            
            session.setAttribute( "IMPORT_SERVER",      strImportServerData );
            session.setAttribute( "IMPORT_SERVER_PORT", strImportServerPortData );
            session.setAttribute( "IMPORT_WEB_SERVER",  strImportWebServerData );
            session.setAttribute( "IMPORT_WEB_PORT",    strImportWebPortData );
        }
    }

    if (strMode.equals("SEARCH")) {
        bolnSuccess = con.executeService(strContainerName, strClassName, "findSystemConfig");
        if (bolnSuccess) {
            while (con.nextRecordElement()) {
                bTotalSizeData = new BigDecimal(con.getColumn("TOTAL_SIZE")).divide(bmultiply, 2, 0);
                bUsedSizeData = new BigDecimal(con.getColumn("USED_SIZE")).divide(bmultiply, 2, 0);
                bAvalSizeData = new BigDecimal(con.getColumn("AVAL_SIZE")).divide(bmultiply, 2, 0);
                bUsedPercentData = new BigDecimal(con.getColumn("USED_PERCENT")).divide(bOne, 2, 0);

                strPassExpireDaysData = con.getColumn("USER_EXPIRE_DAYS");
                strPassWarningDaysData = con.getColumn("USER_WARNING_DAYS");
                strEmailServerData = con.getColumn("EMAIL_SERVER");
                strReportServerData = con.getColumn("REPORT_SERVER");
                strLogExpireDaysData = con.getColumn("LOG_EXPIRE_DAYS");
                strTempExpireDaysData = con.getColumn("TEMP_EXPIRE_DAYS");
                strMediaTypeData = con.getColumn("MEDIA_TYPE");
                strLocalReportPathData = con.getColumn("REPORT_PATH_LOCAL");
                strFtpUserData = con.getColumn("REPORT_USER");
                strFtpPasswordData = con.getColumn("REPORT_PASSWORD");
                
                strImportServerData    = con.getColumn( "IMPORT_SERVER");
                strImportServerPortData = con.getColumn( "IMPORT_SERVER_PORT");
                strImportWebServerData = con.getColumn( "IMPORT_WEB_SERVER");
                strImportWebPortData   = con.getColumn( "IMPORT_WEB_PORT");

                bTotalSizeDumyData = new BigDecimal(con.getColumn("TOTAL_SIZE"));
                bUsedSizeDumyData = new BigDecimal(con.getColumn("USED_SIZE"));
                bAvalSizeDumyData = new BigDecimal(con.getColumn("AVAL_SIZE"));
                
            }
        }
    }

%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=TIS-620">
        <title><%=lc_site_name%></title>
        <link href="css/edas.css" type="text/css" rel="stylesheet">
        <style type="text/css">

            a.show_adv{
                color: graytext;
            }

            a.show_adv:hover{
                color: graytext;
                font-weight: bold;
                text-decoration: underline;
            }
            a.show_adv:visited{
                color: graytext;
            }

        </style>
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
        <script language="JavaScript" src="js/label/lb_system_config.js"></script>
        <script language="JavaScript" src="js/function/field-utils.js"></script>
        <script language="JavaScript" src="js/function/page-utils.js"></script>
        <script language="JavaScript" src="js/util.js"></script>
        <script language="JavaScript" src="js/constant.js"></script>
        <script language="JavaScript" type="text/javascript">
<!--

$(document).ready(window_onload);

function window_onload() {
    set_field();
    set_label();
    set_background("screen_div");
    set_message();
}

function set_field() {
    global_field = "TOTAL_SIZE,TEMP_EXPIRE_DAYS,selMediaType,PASSWORD_EXPIRE_DAYS,PASSWORD_WARNING_DAYS,EMAIL_SERVER,REPORT_SERVER,REPORT_PASSWORD,LOG_EXPIRE_DAYS";
}

function set_label() {

    $("#lb_about_size").text(lbl_about_size);
    $("#lb_total_size").text(lbl_total_size);
    $("#lb_used_size").text(lbl_used_size);
    $("#lb_avail_size").text(lbl_aval_size);
    $("#lb_used_percent").text(lbl_used_percent);

    $("#lb_about_doc").text(lbl_about_document);
    $("#lb_temp_document").text(lbl_temp_document);
    $("#lb_null_doc").text(lbl_is_null_doc);
    $("#lb_expire_media_type").text(lbl_expire_media_type);

    $("#lb_about_password").text(lbl_about_password);
    $("#lb_age_password").text(lbl_age_password);
    $("#lb_null_password").text(lbl_is_null_password);
    $("#lb_expire_password_days").text(lbl_expired_password_days);

    $("#lb_report_management").text(lbl_report_management);
    $("#lb_report_server").text(lbl_report_server);
    $("#lb_ftp_user").text(lbl_ftp_user);
    $("#lb_ftp_password").text(lbl_ftp_password);

    $("#lb_about_log").text(lbl_about_log);
    $("#lb_log_age").text(lbl_age_log);
    $("#lb_null_log").text(lbl_is_null_age_log);
}

function set_message() {

            <%  if (!strmsg.equals("")) {%>
            <%=strmsg%>
            <%  }%>
}

function verify_ip_address(ip_value) {
    var ip_seg;
    var ip_pattern = /^(\d{1,3})\.(\d{1,3})\.(\d{1,3})\.(\d{1,3})$/;
    var ip_check = ip_value.match(ip_pattern);

    if ((ip_value == "0.0.0.0") || (ip_value == "255.255.255.255")) {
        alert(lc_ip_address_cannot_use);
        return false;
    }

    if (ip_check == null) {
        alert(lc_check_ip_address);
        return false;
    } else {
        for (var i = 0; i < 4; i++) {
            ip_seg = ip_check[i];
            if (ip_seg > 255) {
                alert(lc_check_ip_address);
                return false;
            }
            if ((i == 0) && (ip_seg > 255)) {
                alert(lc_ip_address_cannot_use);
                return false;
            }
        }
        return true;
    }
}

function click_advance_setting(){
	var tr_obj = document.getElementById("tr_advance");
	if(tr_obj.style.display == "none"){
            $("#tr_advance").show();
            $("#tr_advance_link").hide();
	}else{
            $("#tr_advance").hide();
            $("#tr_advance_link").show();
	}
}

function submit_form() {

    if ($("#TOTAL_SIZE").val() == "") {
        alert(lc_check_total_size);
        return;
    }

    if ($("#EMAIL_SERVER").val() != "") {
        if (!verify_ip_address($("#EMAIL_SERVER").val())) {
            $("#EMAIL_SERVER").focus();
            return;
        }
    }

    $("#MODE").val("UPDATE_CONFIG");
    form1.submit();
}

//-->
        </script>
    </head>
    <body onLoad="MM_preloadImages('images/btt_save2_over.gif');" onresize="set_background('screen_div')">
        <form id="form1" name="form1" method="post" action="" >
            <table width="100%" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
                <tr><td valign="top">
                        <div id="screen_div">
                            <table width="769" border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td height="25" class="label_header01">
                                        &nbsp;&nbsp;&nbsp;<%=screenname%>
                                    </td>
                                </tr>
                                <tr>
                                    <td height="10">&nbsp;</td>
                                </tr>
                            </table>
                            <table width="769"  cellspacing="0" cellpadding="0" >
                                <tr>
                                    <td height="25" align="left">
                                        <table width="750" border="0" cellpadding="0" cellspacing="0">
                                            <tr>
                                                <td height="25">
                                                    <fieldset><legend class="label_bold2"><span id="lb_about_size"></span></legend>
                                                        <table width="100%" border="0">
                                                            <tr>
                                                                <td width="4%" class="label_bold3">&nbsp;</td>
                                                                <td width="17%">
                                                                    <span id="lb_total_size" class="label_bold2"></span>
                                                                    <img src="images/mark.gif" width="12" height="11"></td>
                                                                <td width="8%">
                                                                    <input id="TOTAL_SIZE" name="TOTAL_SIZE" type="text" class="input_box" value="<%=bTotalSizeData%>" size="5" maxlength="19"  style="text-align:right;" onkeypress="key_press(this);
                                                                            keypress_number(event)"></td>
                                                                <td width="15%">
                                                                    <span id="lb_used_size" class="label_bold2"></span></td>
                                                                <td width="8%">
                                                                    <input id="USED_SIZE" name="USED_SIZE" type="text" class="input_box_disable" value="<%=bUsedSizeData%>" size="5" style="text-align:right;" readonly></td>
                                                                <td width="15%">
                                                                    <span id="lb_avail_size" class="label_bold2"></span></td>
                                                                <td width="9%">
                                                                    <input id="AVAIL_SIZE" name="AVAIL_SIZE" type="text" class="input_box_disable" value="<%=bAvalSizeData%>" size="5" style="text-align:right;" readonly></td>
                                                                <td width="16%">
                                                                    <span id="lb_used_percent" class="label_bold2"></span></td>
                                                                <td width="8%">
                                                                    <input id="USED_PERCENT" name="USED_PERCENT" type="text" class="input_box_disable" value="<%=bUsedPercentData%>" size="5" style="text-align:right;" readonly></td>
                                                            </tr>
                                                        </table>
                                                    </fieldset>
                                                            <fieldset style="display: none;"><legend class="label_bold2"><span id="lb_about_doc"></span></legend>
                                                        <table width="100%" border="0">
                                                            <tr>
                                                                <td width="3%">&nbsp;</td>
                                                                <td width="36%">
                                                                    <span id="lb_temp_document" class="label_bold2"></span></td>
                                                                <td width="61%" class="label_bold2">
                                                                    <input id="TEMP_EXPIRE_DAYS" name="TEMP_EXPIRE_DAYS" type="text" class="input_box" value="<%=strTempExpireDaysData%>" size="5" maxlength="3" style="text-align:right;" onkeypress="key_press(this);
                                                                            keypress_number(event)">
                                                                    &nbsp;<span id="lb_null_doc"></span></td>
                                                            </tr>
                                                            <tr>
                                                                <td>&nbsp;</td>
                                                                <td class="label_bold2">
                                                                    <span id="lb_expire_media_type" class="label_bold2"></span></td>
                                                                <td>
                                                                    <select id="selMediaType" name="selMediaType" class="input_box" onkeypress="key_press(this)">
                                                                        <%
                                                                            String strMediaType = "";
                                                                            String strMediaTypeName = "";

                                                                            boolean bolCombo = con2.executeService(strContainerName, strClassName, "findMedia");
                                                                            if (bolCombo) {
                                                                                while (con2.nextRecordElement()) {
                                                                                    strMediaType = con2.getColumn("MEDIA_TYPE");
                                                                                    strMediaTypeName = con2.getColumn("MEDIA_TYPE_NAME");

                                                                                    if (strMediaType.equals(strMediaTypeData)) {
                                                                                        out.println("<option value=\"" + strMediaType + "\" selected>" + strMediaTypeName + "</option>");
                                                                                    } else {
                                                                                        out.println("<option value=\"" + strMediaType + "\">" + strMediaTypeName + "</option>");
                                                                                    }
                                                                                }
                                                                            } else {
                                                                                out.println("<option value\"\">-- No Media ---</option>");
                                                                            }
                                                                        %>
                                                                    </select>
                                                                    <input type="hidden" name="MEDIA_TYPE" />
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </fieldset>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td height="25">
                                                    <fieldset><legend class="label_bold2"><span id="lb_about_password"></span></legend>
                                                        <table width="100%" border="0">
                                                            <tr>
                                                                <td width="3%">&nbsp;</td>
                                                                <td width="36%">
                                                                    <span id="lb_age_password" class="label_bold2"></span></td>
                                                                <td width="61%">
                                                                    <input id="PASSWORD_EXPIRE_DAYS" name="PASSWORD_EXPIRE_DAYS" type="text" value="<%=strPassExpireDaysData%>" class="input_box" size="5" maxlength="3" style="text-align:right;" onkeypress="key_press(this);
                                                                            keypress_number(event)">
                                                                    &nbsp;<span id="lb_null_password" class="label_bold2"></span></td>
                                                            </tr>
                                                            <tr>
                                                                <td>&nbsp;</td>
                                                                <td class="label_bold2">
                                                                    <span id="lb_expire_password_days"></span></td>
                                                                <td><span class="label_bold2">
                                                                        <input id="PASSWORD_WARNING_DAYS" name="PASSWORD_WARNING_DAYS" type="text" class="input_box" value="<%=strPassWarningDaysData%>" size="5" maxlength="3" style="text-align:right;" onkeypress="key_press(this);
                                                                                keypress_number(event)">
                                                                    </span>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </fieldset>
                                                    <fieldset><legend class="label_bold2">E-Mail</legend>
                                                        <table width="100%" border="0">
                                                            <tr>
                                                                <td width="3%">&nbsp;</td>
                                                                <td width="36%" class="label_bold2">E-mail Server </td>
                                                                <td width="61%"><input id="EMAIL_SERVER" name="EMAIL_SERVER" type="text" class="input_box" value="<%=strEmailServerData%>" size="20" maxlength="20" onkeypress="key_press(this);
                                                                        keypress_ip(event)"></td>
                                                            </tr>
                                                        </table>
                                                    </fieldset>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td height="25">
                                                    <fieldset><legend class="label_bold2"><span id="lb_report_management"></span></legend>
                                                        <table width="100%" border="0">
                                                            <tr>
                                                                <td width="3%">&nbsp;</td>
                                                                <td width="36%"><span class="label_bold2" id="lb_report_server"></span></td>
                                                                <td width="61%">
                                                                    <input id="REPORT_SERVER" name="REPORT_SERVER" type="text" class="input_box" value="<%=strReportServerData%>" size="20" 
                                                                           maxlength="20" onkeypress="key_press(this);
                                                                                   keypress_ip(event)">
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td width="3%">&nbsp;</td>
                                                                <td width="36%"><span class="label_bold2" id="lb_ftp_user"></span></td>
                                                                <td width="61%">
                                                                    <input id="REPORT_USER" name="REPORT_USER" type="text" class="input_box" value="<%=strFtpUserData%>" size="20" 
                                                                           maxlength="20" onkeypress="key_press(this);">
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td width="3%">&nbsp;</td>
                                                                <td width="36%"><span class="label_bold2" id="lb_ftp_password"></span></td>
                                                                <td width="61%">
                                                                    <input id="REPORT_PASSWORD" name="REPORT_PASSWORD" type="password" class="input_box" value="<%=strFtpPasswordData%>" size="20" 
                                                                           maxlength="20" onkeypress="key_press(this);">
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </fieldset>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td height="25">
                                                    <fieldset><legend class="label_bold2"><span id="lb_about_log"></span></legend>
                                                        <table width="100%" border="0">
                                                            <tr>
                                                                <td width="3%">&nbsp;</td>
                                                                <td width="36%">
                                                                    <span id="lb_log_age" class="label_bold2"></span></td>
                                                                <td width="61%">
                                                                    <input id="LOG_EXPIRE_DAYS" name="LOG_EXPIRE_DAYS" type="text" class="input_box" value="<%=strLogExpireDaysData%>" size="5" maxlength="3" style="text-align:right;" onkeypress="key_press_fx(this, 'submit_form');
                                                                            keypress_number(event)">
                                                                    &nbsp;<span id="lb_null_log" class="label_bold2"></span></td>
                                                            </tr>
                                                        </table>
                                                    </fieldset>
                                                </td>
                                            </tr>
                                            <tr id="tr_advance_link" style="display: inline;">
                    	<td height="30">
                    		<a href="javascript:click_advance_setting();" class="show_adv" >Advance Setting...</a>
                        </td>
                    </tr>
                    <tr id="tr_advance" style="display: none;">
                    	<td>
                    		<fieldset><legend class="label_bold2"><span id="lb_import_data">Import Configuration</span></legend>
                              <table width="100%" border="0">
                                    <tr>
                                        <td width="3%">&nbsp;</td>
                                        <td width="36%">
                                            <span id="sp_SERVER_IP" class="label_bold2">Import Server</span></td>
                                        <td width="61%">
                                            <input name="IMPORT_SERVER" type="text" class="input_box" value="<%=strImportServerData %>" size="25" onkeypress="fieldPress(this);keypress_number()">
                                            &nbsp;</td>
                                    </tr>
                                    <tr>
                                        <td width="3%">&nbsp;</td>
                                        <td width="36%">
                                            <span id="sp_SERVER_PORT" class="label_bold2">Import Server Port</span></td>
                                        <td width="61%">
                                            <input name="IMPORT_SERVER_PORT" type="text" class="input_box" value="<%=strImportServerPortData %>" size="25" onkeypress="fieldPress(this);keypress_number()">
                                            &nbsp;</td>
                                    </tr>
                                    <tr>
                                        <td width="3%">&nbsp;</td>
                                        <td width="36%">
                                            <span id="sp_WEB_SERVER_IP" class="label_bold2">Web Server</span></td>
                                        <td width="61%">
                                            <input name="IMPORT_WEB_SERVER" type="text" class="input_box" value="<%=strImportWebServerData %>" size="25" onkeypress="fieldPress(this);keypress_number()">
                                            &nbsp;</td>
                                    </tr>
                                    <tr>
                                        <td width="3%">&nbsp;</td>
                                        <td width="36%">
                                            <span id="sp_WEB_PORT" class="label_bold2">WEB PORT</span></td>
                                        <td width="61%">
                                            <input name="IMPORT_WEB_PORT" type="text" class="input_box" value="<%=strImportWebPortData %>" size="25" onkeypress="fieldPress(this);keypress_number()">
                                            &nbsp;</td>
                                    </tr>
                                </table>
                            </fieldset>    
                    	</td>
                    </tr>
                                            <tr>
                                                <td height="25">
                                                    <table width="100%" border="0">
                                                        <tr>
                                                            <td align="right">
                                                                <div align="center">
                                                                    <a href="javascript:submit_form()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('save2', '', 'images/btt_save2_over.gif', 1)">
                                                                        <img src="images/btt_save2.gif" name="save2" width="67" height="22" border="0"></a>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>&nbsp;</td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </td>
                </tr>
            </table>
            <input type="hidden" id="MODE"             name="MODE"             value="<%=strMode%>">
            <input type="hidden" id="hidTotalSizeDumy" name="hidTotalSizeDumy" value="<%=bTotalSizeDumyData%>">
            <input type="hidden" id="hidUsedSizeDumy"  name="hidUsedSizeDumy"  value="<%=bUsedSizeDumyData%>">
            <input type="hidden" id="hidAvalSizeDumy"  name="hidAvalSizeDumy"  value="<%=bAvalSizeDumyData%>">
        </form>
    </body>
</html>