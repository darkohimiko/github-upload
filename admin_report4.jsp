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

    String screenname   = getField(request.getParameter("screenname"));
    String strClassName = "USER_REPORT";
    String strMode      = getField(request.getParameter("MODE"));

    String strUserStatusData  = getField(request.getParameter("hidUserStatus"));
    String strUserCodeData    = getField(request.getParameter("txtUserCode"));
    String strUserOrgData     = getField(request.getParameter("txtUserOrg"));
    String strWhereCause      = getField(request.getParameter("P_WHERE"));
    String strDateCause       = getField(request.getParameter("P_DATE"));
    
    boolean bolnSuccess     = true;
    boolean bolnZoomSuccess = true;
    
    String strCurrentDate = "";
    String strVersionLang = ImageConfUtil.getVersionLang();

    if( strVersionLang.equals("thai") ) {
            strCurrentDate = getServerDateThai();
    }else {
            strCurrentDate = getServerDateEng();
    }
	
    if( strMode == null ){
        strMode = "ONLOAD";
    }
    
    if(strMode.equals("COUNT")){
        
        if( !strUserCodeData.equals("") ) {
        	con.addData( "USER_ID", "String", strUserCodeData);
        }
        if( !strUserOrgData.equals("") ) {
        	con.addData( "USER_ORG", "String", strUserOrgData);
        }
        if( !strUserStatusData.equals("") ) {
        	con.addData( "USER_STATUS", "String", strUserStatusData);
        }
        
        bolnSuccess = con.executeService( strContainerName , strClassName , "selectAdminReport4" );

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
var mode = "<%=strMode %>";

$(document).ready(window_onload);

function window_onload() {
    set_label();
    set_init();
}    

function set_label(){
    $("#lb_user_id_name").text(lbl_user_id_name);
    $("#lb_org").text(lbl_org);
    $("#lb_user_status").text(lbl_user_status);
    $("#lb_user_report_warning2").text(lbl_user_report_warning2);
}    

function set_init(){
    if( mode == "REPORT" ) {
    	openReport();
    }else if( mode == "SEARCH" ) {
    	alert( lc_report_data_not_found );
    }
}

function openReport() {
    $("#formReport #P_DISPLAYDATE").val("<%=dateToDisplay( strCurrentDate, "/" ) %>");
    lp_new_window( "report" );
    $("#formReport").attr('target', "report");
    $("#formReport").submit();
}

function getValueStatus() {
    var optSelected = $("#optUserStatus option:selected").index();
    var optValue    = $("#optUserStatus").val();

    if( optSelected == 0 ) {
        $("#hidUserStatus").val("");
    }else {
        $("#hidUserStatus").val(optValue);
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
        case "user" :
            strUrl = "inc/zoom_user_profile.jsp";
            strConcatField = "TABLE=ORG" + "&TABLE_LABEL=" + lbl_org;
            strConcatField += "&RESULT_FIELD=txtUserCode,txtUserName";
            break;
        case "org" :
            strUrl = "inc/zoom_data_table_level1.jsp";
            strConcatField = "TABLE=ORG" + "&TABLE_LABEL=" + lbl_org;
            strConcatField += "&RESULT_FIELD=txtUserOrg,txtUserOrgName";
            break;
    }

    objZoomWindow = window.open( strUrl + "?" + strConcatField, strZoomType, strPopArgument );
    objZoomWindow.focus();
}

function clearDefault() {
    $("#optUserStatus").val("");
    $("#hidUserStatus").val("");
    $("#txtUserCode").val("");
    $("#txtUserName").val("");
    $("#txtUserOrg").val("");
    $("#txtUserOrgName").val("");
}

function verify_form() {
    var whereCon = "";
	
    if( $("#txtUserCode").val().length != 0 ) {
        whereCon = "WHERE A.USER_ID='"+$("#txtUserCode").val()+"' ";
    }
    if( $("#txtUserOrg").val().length != 0 ) {
    	if( whereCon == "" ) {
            whereCon = "WHERE A.USER_ORG='"+$("#txtUserOrg").val()+"' ";
    	}else {
            whereCon += "AND A.USER_ORG='"+$("#txtUserOrg").val()+"' ";
    	}
    }
    if( $("#hidUserStatus").val().length != 0 ) {
        if( whereCon == "" ) {
            whereCon = "WHERE A.USER_STATUS='"+$("#hidUserStatus").val()+"' ";
        }else {
            whereCon += "AND A.USER_STATUS='"+$("#hidUserStatus").val()+"' ";
        }
    }
	
<%  if( strVersionLang.equals("thai") ) { %>
    form1.P_DATE.value = lbl_at_date + "<%=dateToDisplay(getServerDateThai())%>";
<%  }else { %>
    form1.P_DATE.value = lbl_at_date + "<%=dateToDisplay(getServerDateEng())%>";
<%  }   %>
    $("#form1 #P_DISPLAYDATE").val("<%=dateToDisplay( strCurrentDate, "/" ) %>");
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
<form id="form1"  name="form1" method="post" >
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
            		<table width="495" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td height="25" colspan="2">&nbsp;</td>
                            </tr>
                            <tr>
                                <td class="label_bold2"><span id="lb_user_id_name" class="label_bold2"></span></td>
                                <td>
                                    <input id="txtUserCode" name="txtUserCode" type="text" size="14" maxlength="20" class="input_box_disable" readOnly >&nbsp;
                                    <a href="javascript:openZoom('user');"><img id="imgZoomDocLevel" src="images/search.gif" width="16" height="16" border="0"></a>
                                    <input id="txtUserName" name="txtUserName" type="text" size="40" maxlength="50" class="input_box_disable" readOnly >
                                </td>
                            </tr>
                            <tr>
                                <td class="label_bold2"><span id="lb_org" class="label_bold2"></span></td>
                                <td>
                                    <input id="txtUserOrg" name="txtUserOrg" type="text" size="14" maxlength="20" class="input_box_disable" readOnly >&nbsp;
                                    <a href="javascript:openZoom('org');"><img id="imgZoomDocLevel" src="images/search.gif" width="16" height="16" border="0"></a>
                                    <input id="txtUserOrgName" name="txtUserOrgName" type="text" size="40" maxlength="50" class="input_box_disable" readOnly >
                                </td>
                            </tr>
                            <tr>
<%
        String strTagOption      = "";
        String strZoomUserStatus = "";
        String strZoomStatusName = "";
        
        strTagOption = "\n<select id=\"optUserStatus\" name=\"optUserStatus\" class=\"combobox\" onchange=\"getValueStatus();\">";
        strTagOption += "\n<option value=\"\"></option>";

        bolnZoomSuccess = con.executeService( strContainerName, strClassName, "findUserStatusCombo" );

        if( bolnZoomSuccess ){
            while( con.nextRecordElement() ){
                strZoomUserStatus = con.getColumn( "USER_STATUS" );
                strZoomStatusName = con.getColumn( "USER_STATUS_NAME" );

                strTagOption += "\n<option value=\"" + strZoomUserStatus + "\">" + strZoomStatusName + "</option>";
            }
        }

        strTagOption += "\n</select>";
%>
                                <td width="22%" height="25" class="label_bold2"><span id="lb_user_status"></span></td>
                                <td>
                                    <span id="user_action"></span>
                                    <%=strTagOption %>
                                    <input id="hidUserStatus" name="hidUserStatus" type="hidden" >
                                </td>
                            </tr>
                            <tr>
                                <td height="25" colspan="2">&nbsp;</td>
                            </tr>
                            <tr>
                                <td height="25" colspan="2" class="label_bold2" align="center">
                                    <span id="lb_user_report_warning2"></span>
                                </td>
                            </tr>
                            <tr>
                                <td height="25" colspan="2">&nbsp;</td>
                            </tr>
                            <tr>
                                <td align="center" colspan="2">
                                    <a href="#" onclick= "click_search()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('bttSearch','','images/btt_search_over.gif',1)">
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
<input type="hidden" id="MODE"          name="MODE"           value="<%=strMode%>">
<input type="hidden" id="screenname"    name="screenname"     value="<%=screenname%>">
<input type="hidden" id="P_DATE"        name="P_DATE"         value="">
<input type="hidden" id="P_DISPLAYDATE" name="P_DISPLAYDATE"  value="">
<input type="hidden" id="P_WHERE"       name="P_WHERE"        value="<%=strWhereCause %>">
</form>
<form id="formReport" name="formReport" action="<%=request.getScheme()%>://<%=request.getServerName()+ ":" + request.getServerPort() %>/jrw510/jrq" method="post">
<input type="hidden" id="P_DATE"         name="P_DATE"         value="<%=strDateCause %>">
<input type="hidden" id="P_DISPLAYDATE"  name="P_DISPLAYDATE"  value="">
<input type="hidden" id="P_WHERE"        name="P_WHERE"        value="<%=strWhereCause %>">
<input type="hidden" id="init"           name="init"           value="pdf">
<input type="hidden" id="report"         name="report"         value="EDAS2_10">
</form>
</body>
</html>