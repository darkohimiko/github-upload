<%@ page contentType="text/html; charset=tis-620"%>
<%@ include file="inc/constant.jsp" %>
<%@ include file="inc/label.jsp" %>
<%@ include file="inc/utils.jsp" %>
<%
	
    String screenname   = getField(request.getParameter("screenname"));
    String screenLabel = lb_search_faq;
    
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
<script language="JavaScript" src="js/label/lb_faq.js"></script>
<script language="JavaScript" src="js/util.js"></script>
<script language="JavaScript" src="js/constant.js"></script>
<script language="JavaScript" type="text/javascript">
<!--

$(document).ready(window_onload);

function window_onload() {
    $("#lb_faq_code").text(lbl_faq_code);
    $("#lb_faq_subj").text(lbl_faq_subj);
    $("#lb_faq_detail").text(lbl_faq_detail);
    $("#lb_faq_answer").text(lbl_faq_answer);
}

function buttonClick( lv_strMethod ){
    switch( lv_strMethod ){
        case "search" :
            if(verify_form()){
                $("#formsearch #FAQ_ID_SEARCH").val($("#txtFaqId").val());
                $("#formsearch #FAQ_SUBJ_SEARCH").val($("#txtFaqSubj").val());
                $("#formsearch #FAQ_DESC_SEARCH").val($("#txtFaqDesc").val());
                $("#formsearch #FAQ_ANSWER_SEARCH").val($("#txtFaqAns").val());
                $("#formsearch #MODE").val("FIND");
                $("#formsearch").submit();
            }
            break;
        case "cancel" :
            $("#form1").attr('action', "faq1.jsp");
            $("#form1").attr('target',"_self");
            $("#form1 #MODE").val("SEARCH");
            $("#form1").submit();
            break;
    }
}

function verify_form() {
    if( $("#txtFaqId").val().length == 0 && $("#txtFaqSubj").val().length == 0 
        && $("#txtFaqDesc").val().length == 0 && $("#txtFaqAns").val().length == 0 ) {
        alert(lc_checked_data_search);
        return false;
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
            		<table width="450" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td height="25" colspan="2">&nbsp;</td>
                            </tr>
                            <tr>
                                <td height="25" class="label_bold2" width="90"><span id="lb_faq_code"></span></td>
                                <td height="25">
                                    <input id="txtFaqId" name="txtFaqId" type="text" class="input_box" size="15" maxlength="12" >
                                </td>
                            </tr>
                            <tr>
                                <td height="25" class="label_bold2"><span id="lb_faq_subj"></span></td>
                                <td height="25" >
                                    <input id="txtFaqSubj" name="txtFaqSubj" type="text" class="input_box" size="60" >
                                </td>
                            </tr>
                            <tr>
                                <td height="25" class="label_bold2"><span id="lb_faq_detail"></span></td>
                                <td height="25" >
                                    <input id="txtFaqDesc" name="txtFaqDesc" type="text" class="input_box" size="60" >
                                </td>
                            </tr>
                            <tr>
                                <td height="25" class="label_bold2"><span id="lb_faq_answer"></span></td>
                                <td height="25" >
                                    <input id="txtFaqAns" name="txtFaqAns" type="text" class="input_box" size="60" >
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
<form id="formsearch" name="formsearch" method="post" action="faq1.jsp" target = "_self">
<input type="hidden" id="MODE"             name="MODE"             value="">
<input type="hidden" id="FAQ_ID_SEARCH"     name="FAQ_ID_SEARCH"    value="">
<input type="hidden" id="FAQ_SUBJ_SEARCH"   name="FAQ_SUBJ_SEARCH"   value="">
<input type="hidden" id="FAQ_DESC_SEARCH"   name="FAQ_DESC_SEARCH"    value="">
<input type="hidden" id="FAQ_ANSWER_SEARCH" name="FAQ_ANSWER_SEARCH" value="">
<input type="hidden" id="screenname"       name="screenname"       value="<%=screenname%>">
</form>
</body>
</html>