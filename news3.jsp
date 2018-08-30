<%@ page contentType="text/html; charset=tis-620"%>
<%@page import="com.scc.edms.conf.ImageConfUtil"%>
<%@ include file="inc/checkUser.jsp" %>
<%@ include file="inc/constant.jsp" %>
<%@ include file="inc/label.jsp" %>
<%@ include file="inc/utils.jsp" %>
<jsp:useBean id="con" scope="session" class="edms.cllib.EABConnector"/>
<%
    con.setRemoteServer("EAS_SERVER");

    String strClassName = "NEWS_MANAGER";
    String screenname   = getField(request.getParameter("screenname"));
    String screenLabel  = lb_search_news;
    String strLangFlag  = "";

    if( ImageConfUtil.getVersionLang().equals("thai") ) {
            strLangFlag = "1";
    }else {
            strLangFlag = "0";
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
<script language="JavaScript" src="js/label/lb_news.js"></script>
<script language="JavaScript" src="js/sccUtils.js"></script>
<script language="JavaScript" src="js/util.js"></script>
<script language="JavaScript" src="js/constant.js"></script>
<script language="JavaScript" type="text/javascript">
<!--
var sccUtils = new SCUtils();

$(document).ready(window_onload);

function window_onload() {
    $("#lb_news_header").text(lbl_news_header);
    $("#lb_news_subject").text(lbl_news_subject);
    $("#lb_news_source").text(lbl_news_source);
    $("#lb_news_date").text(lbl_news_date);
}

function getValueSource() {
    var sourceIndex = $("#optSource option:selected").index();
    var sourceValue = $("#optSource").val();

    if( sourceIndex == 0 ) {
        $("#hidSource").val("");
    }else {
        $("#hidSource").val(sourceValue);
    }
}

function set_format_date( obj_field ){
    if( obj_field.value.length == 8 && sccUtils.isDateValid( obj_field.value ) == "VALID_DATE" ){
        obj_field.value = sccUtils.formatDate( obj_field.value );
    }else {
        if( obj_field.value != "" && sccUtils.isDateValid( obj_field.value ) != "VALID_DATE" ){
            alert( lc_fill_date_correct );
            obj_field.value = "";
            obj_field.focus();
        }
    }
}

function buttonClick( lv_strMethod ){
    switch( lv_strMethod ){
        case "search" :
            if(verify_form()){
                $("#formsearch #HEADER_SEARCH").val($("#txtHeader").val());
                $("#formsearch #SUBJECT_SEARCH").val($("#txtSubject").val());
                $("#formsearch #NEWS_DATE_SEARCH").val($("#txtNewsDate").val());
                $("#formsearch #SOURCE_SEARCH").val($("#hidSource").val());
                $("#formsearch #MODE").val("FIND");
                $("#formsearch").submit();
            }
            break;
        case "cancel" :
            $("#form1").attr('action', "news1.jsp");
            $("#form1").attr('target',"_self");
            $("#form1 #MODE").val("SEARCH");
            $("#form1").submit();
            break;
    }
}

function verify_form() {
    if( $("#txtHeader").val().length == 0 && $("#txtSubject").val().length == 0 
        && $("#txtNewsDate").val().length == 0 && $("#hidSource").val().length == 0 ) {
        alert(lc_checked_data_search);
        return false;
    }
    if( $("#txtNewsDate").val() != "" ) {
        $("#txtNewsDate").val(dateToDb($("#txtNewsDate").val()));
    }

    return true;
}

//-->
</script>
<link href="css/edas.css" type="text/css" rel="stylesheet">
</head>
<body onLoad="MM_preloadImages('images/btt_search_over.gif','images/btt_cancel_over.gif');window_onload();">
<form id="form1" name="form1" method="post" action="" >
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0" align="center">
    <tr>
        <td valign="top">
            <table width="800" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td height="25" class="label_header01" colspan="2">&nbsp;&nbsp;<%=screenname%>&nbsp; >> &nbsp;<%=screenLabel %></td>
                </tr>
                <tr>
                    <td width="30">&nbsp;</td>
                    <td height="25" align="left">
            		<table width="400" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td height="25" colspan="2">&nbsp;</td>
                            </tr>
                            <tr>
                                <td height="25" class="label_bold2"><span id="lb_news_header"></span></td>
                                <td height="25">
                                    <input id="txtHeader" name="txtHeader" type="text" class="input_box" size="50" >
                                </td>
                            </tr>
                            <tr>
                                <td height="25" class="label_bold2"><span id="lb_news_subject"></span></td>
                                <td height="25" >
                                    <input id="txtSubject" name="txtSubject" type="text" class="input_box" size="50" >
                                </td>
                            </tr>
<%
		String strTagSourceOption = "";
		String strSource          = "";
		String strSourceName      = "";
		strTagSourceOption = "\n<select id=\"optSource\" name=\"optSource\" class=\"combobox\" onchange=\"getValueSource();\">";
		strTagSourceOption += "\n<option value=\"\"></option>";
		
		boolean bolnZoomSuccess = con.executeService( strContainerName, strClassName, "findSourceCombo" );
		if( bolnZoomSuccess ){
			while( con.nextRecordElement() ){
				strSource     = con.getColumn( "EDAS_SOURCE" );
				strSourceName = con.getColumn( "EDAS_SOURCE_NAME" );
		
				strTagSourceOption += "\n<option value=\"" + strSource + "\">" + strSourceName + "</option>";
			}
		}
		strTagSourceOption += "\n</select>";
%>
                            <tr>
                                <td height="25" class="label_bold2"><span id="lb_news_source"></span></td>
                                <td height="25"><%=strTagSourceOption %>
                                    <input id="hidSource" name="hidSource" type="hidden" value"">
                                </td>
                            </tr>
                            <tr>
                                <td height="25" class="label_bold2"><span id="lb_news_date"></span></td>
                                <td>
                                    <input id="txtNewsDate" name="txtNewsDate" type="text" class="input_box" size="10" maxlength="10" onkeypress="keypress_number();" onBlur="set_format_date( this );"> 
                                    <a href="javascript:showCalendar(form1.txtNewsDate,<%=strLangFlag %>)"><img src="images/calendar.gif" width=16 height=16 align="absmiddle" border=0 ></a>
                                </td>
                            </tr>
                            <tr>
                                <td height="25" colspan="2">&nbsp;</td>
                            </tr>
                            <tr>
                                <td align="center" colspan="2">
                                    <a href="#" onclick= "buttonClick('search')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('search','','images/btt_search_over.gif',1)">
                                        <img src="images/btt_search.gif" name="search" width="67" height="22" border="0"></a>&nbsp;
                                    <a href="#" onclick= "buttonClick('cancel')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('cancel','','images/btt_cancel_over.gif',1)">
                                        <img src="images/btt_cancel.gif" name="cancel" width="67" height="22" border="0"></a>
                                </td>
                            </tr>
              		</table>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>
<input type="hidden" id="MODE"       name="MODE"       value="">
<input type="hidden" id="screenname" name="screenname" value="<%=screenname%>">
</form>
<form id="formsearch" name="formsearch" method="post" action="news1.jsp" target = "_self">
<input type="hidden" id="MODE"             name="MODE"             value="">
<input type="hidden" id="HEADER_SEARCH"    name="HEADER_SEARCH"    value="">
<input type="hidden" id="SUBJECT_SEARCH"   name="SUBJECT_SEARCH"   value="">
<input type="hidden" id="SOURCE_SEARCH"    name="SOURCE_SEARCH"    value="">
<input type="hidden" id="NEWS_DATE_SEARCH" name="NEWS_DATE_SEARCH" value="">
<input type="hidden" id="screenname"       name="screenname"       value="<%=screenname%>">
</form>
</body>
</html>