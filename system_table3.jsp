<%@ page contentType="text/html; charset=tis-620"%>
<%@ include file="inc/checkUser.jsp" %>
<%@ include file="inc/constant.jsp" %>
<%@ include file="inc/label.jsp" %>
<%@ include file="inc/utils.jsp" %>
<%
    String screenname  = getField(request.getParameter("screenname"));
    String screenLabel = lb_search_table;
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
<script language="JavaScript" src="js/label/lb_system_table.js"></script>
<script language="JavaScript" src="js/util.js"></script>
<script language="JavaScript" src="js/constant.js"></script>
<script language="JavaScript" type="text/javascript">
<!--

$(document).ready(window_onload);

function window_onload() {
    $("#lb_table_level").text(lbl_table_level);
    $("#lb_table_code").text(lbl_table_code);
    $("#lb_table_name").text(lbl_table_name);
    $("#lb_level_1").text(lbl_level_1);
    $("#lb_level_2").text(lbl_level_2);
    $("#lb_level_3").text(lbl_level_3);
}

function dupLevelValue( lv_selectedValue ) {
    $("#hidTableLevel").val(lv_selectedValue);
}

function buttonClick( lv_strMethod ){
    switch( lv_strMethod ){
        case "search" :
            if(verify_form()){
                $("#formsearch #TABLE_CODE_SEARCH").val( $("#form1 #txtTableCode").val());
                $("#formsearch #TABLE_NAME_SEARCH").val( $("#form1 #txtTableName").val());
                $("#formsearch #TABLE_LEVEL_SEARCH").val( $("#form1 #hidTableLevel").val());
                $("#formsearch #MODE").val("FIND");
                $("#formsearch").submit();
            }
            break;
        case "cancel" :
            $("#form1 #MODE").val("SEARCH");
            $("#form1").submit();
            break;
    }
}

function verify_form() {
    if( $("#form1 #hidTableLevel").val() == "" && $("#form1 #txtTableCode").val().length == 0 && $("#form1 #txtTableName").val().length == 0 ) {
        alert(lc_checked_data_search);
        return false;
    }

    return true;
}

//-->
</script>
<link href="css/edas.css" type="text/css" rel="stylesheet">
</head>
<body onLoad="MM_preloadImages('images/btt_search_over.gif','images/btt_cancel_over.gif');">
<form id="form1" name="form1" method="post" action="system_table1.jsp" >
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0" align="cneter">
    <tr>
        <td valign="top">
            <table width="800" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td height="25" class="label_header01" colspan="2">&nbsp;&nbsp;<%=screenname%>&nbsp; >> &nbsp;<%=screenLabel %></td>
                </tr>
                <tr>
                    <td width="20">&nbsp;</td>
                    <td height="25" align="left">
            		<table width="622" border="0" cellspacing="0" cellpadding="0">
		            <tr>
                                <td height="25" colspan="4">&nbsp;</td>
                            </tr>
                            <tr>
                                <td width="99" height="25" class="label_bold2"><span id="lb_table_level"></span></td>
                                <td height="25" colspan="3">
                                    <select id="selTableLevel" name="selTableLevel" class="combobox" style="width:80px" onchange="dupLevelValue(this.options[this.selectedIndex].value)">
                                        <option value =""></option>
                                        <option id="lb_level_1" value ="1"></option>
                                        <option id="lb_level_2" value ="2"></option>
                                        <option id="lb_level_3" value ="3"></option>
                                    </select>
                                    <input  type="hidden" id="hidTableLevel" name="hidTableLevel" >
                                </td>
                            </tr>
                            <tr>
                                <td height="25" class="label_bold2"><span id="lb_table_code"></span></td>
                                <td height="25" colspan="3">
                                    <input id="txtTableCode" name="txtTableCode" type="text" class="input_box" size="20" maxlength="30">
                                </td>
                            </tr>
                            <tr>
                                <td height="25" class="label_bold2"><span id="lb_table_name"></span></td>
                                <td height="25" colspan="3">
                                    <input id="txtTableName" name="txtTableName" type="text" class="input_box" size="30" maxlength="50">
                                </td>
                            </tr>
                            <tr>
                                <td height="25" colspan="4">&nbsp;</td>
                            </tr>
                            <tr>
                                <td align="center" colspan="4">
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
            <input type="hidden" id="MODE" name="MODE" >
            <input type="hidden" id="screenname" name="screenname" value="<%=screenname%>">
        </td>
    </tr>
</table>
</form>
<form id="formsearch" name="formsearch" method="post" action="system_table1.jsp" target = "_self">
<input type="hidden" id="MODE"               name="MODE"               value="">
<input type="hidden" id="MODE_OLD"           name="MODE_OLD"           value="">
<input type="hidden" id="TABLE_CODE_SEARCH"  name="TABLE_CODE_SEARCH"  value="">
<input type="hidden" id="TABLE_NAME_SEARCH"  name="TABLE_NAME_SEARCH"  value="">
<input type="hidden" id="TABLE_LEVEL_SEARCH" name="TABLE_LEVEL_SEARCH" value="">
<input type="hidden" id="screenname"         name="screenname"         value="<%=screenname%>">
</form>
</body>
</html>