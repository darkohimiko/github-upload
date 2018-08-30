<%@ page contentType="text/html; charset=tis-620"%>
<%@ include file="inc/checkUser.jsp" %>
<%@ include file="inc/constant.jsp" %>
<%@ include file="inc/label.jsp" %>
<%@ include file="inc/utils.jsp" %>
<%
	String screenname  = getField(request.getParameter("screenname"));
    String screenLabel = lb_search;
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
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
<script language="JavaScript" src="js/sccUtils.js"></script>
<script language="JavaScript" src="js/util.js"></script>
<script language="JavaScript" src="js/constant.js"></script>
<script language="JavaScript" src="js/label.js"></script>
<script language="JavaScript" type="text/javascript">
<!--

function window_onload() {
    lb_doc_cabinet_type.innerHTML = lbl_doc_cabinet_type;
    lb_public.innerHTML           = lbl_public;
    lb_private.innerHTML          = lbl_private;
    lb_cabinet_document.innerHTML = lbl_cabinet_document;
    lb_user_cabinet.innerHTML     = lbl_user_cabinet;
    
    obj_hidDocType.value = "public";
}

function openZoom() {
	var strPopArgument = "scrollbars=yes,status=no";
	var strWidth       = ",width=370px";
	var strHeight      = ",height=420px";
	var strUrl         = "";
	var strConcatField = "";
	var chkType        = "";
	//var strUserOrg     = obj_txtProjectOwner.value;
	var strUserOrg     = "";
	
	if( obj_hidDocType.value == "public" ) {
		chkType = "public";
	}else {
		chkType = "private";
	}

	strPopArgument += strWidth + strHeight;

	switch( chkType ){
		case "public" :
				strUrl = "inc/zoom_data_table_level1.jsp";
				strConcatField = "TABLE=ORG" + "&TABLE_LABEL=" + lbl_user_profile3;
				strConcatField += "&RESULT_FIELD=txtProjectOwner,txtProjectOwnerName";
				break;
		case "private" :
				strUrl = "inc/zoom_project_owner.jsp";
				strConcatField = "TABLE=ORG" + "&TABLE_LABEL=" + lbl_user_profile2_7;
				strConcatField = "&RESULT_FIELD=txtProjectOwner,txtProjectOwnerName";
				break;
	}

	objZoomWindow = window.open( strUrl + "?" + strConcatField, chkType, strPopArgument );
	objZoomWindow.focus();
}

function getRadioValue( lv_docType ) {	
	if( lv_docType == "public" ) {
		obj_hidDocType.value = lv_docType;
	}else {
		obj_hidDocType.value = lv_docType;
	}
}

function buttonClick( lv_strMethod, lv_strValue ){
    switch( lv_strMethod ){
		case "search" :
//		    if(verify_form()){
				formsearch.PROJECT_NAME_SEARCH.value  = obj_txtProjectName.value;
		        formsearch.PROJECT_OWNER_SEARCH.value = obj_txtProjectOwner.value;
		        formsearch.DOC_TYPE_SEARCH.value      = obj_hidDocType.value;
		        formsearch.MODE.value = "FIND" ;
				formsearch.submit();
//			}
			break;
		case "cancel" :
			form1.action     = "project_manager1.jsp";
			form1.target 	 = "_self";
		    form1.MODE.value = "SEARCH";
		    form1.submit();
			break;
	}
}

function verify_form() {
	if( obj_txtProjectOwner.value.length == 0 ) {
		alert( lc_check_project_name );
		obj_txtProjectOwner.focus();
		return false;
	}
	
	if( obj_hidDocType.value.length == 0 ) {
        alert( lc_check_project_owner );
        obj_hidDocType.focus();
        return false;
	}
	
	return true;
}

//-->
</script>
</head>
<link href="css/edas.css" type="text/css" rel="stylesheet">
<body onLoad="MM_preloadImages('images/btt_search_over.gif','images/btt_cancel_over.gif');window_onload();">
<form name="form1" method="post" action="" >
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0" align="center">
  <tr>
    <td valign="top">
    	<table width="800" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td height="25" class="label_header01" colspan="4">&nbsp;&nbsp;<%=screenname%>&nbsp; >> &nbsp;<%=screenLabel %></td>
              </tr>
              <tr>
            	<td height="25" align="center">
            		<table width="622" border="0" cellspacing="0" cellpadding="0">
		                <tr>
		                  	<td height="25" colspan="4">&nbsp;</td>
		                </tr>
		                <tr>
		                  	<td width="135" height="25" class="label_bold2"><span id="lb_doc_cabinet_type"></span></td>
		                  	<td height="25" colspan="3" class="label_bold2" >
	                      		<input type="radio" id="rdoDocType" name="rdoDocType" checked="checked" onclick="getRadioValue('public');"><span id="lb_public"></span>
	                      		<input type="radio" id="rdoDocType" name="rdoDocType" onclick="getRadioValue('private');"><span id="lb_private"></span>
		                  	</td>
	                	</tr>
	                	<tr>
		                  	<td height="25" class="label_bold2"><span id="lb_cabinet_document"></span></td>
		                  	<td height="25" colspan="3">
		                  		<input id="txtProjectName" name="txtProjectName" type="text" class="input_box" size="20" maxlength="30">
	                  		</td>
	                	</tr>
	                	<tr>
		                  	<td height="25" class="label_bold2"><span id="lb_user_cabinet"></span></td>
		                  	<td width="67" height="25">
		                  		<input id="txtProjectOwner" name="txtProjectOwner" type="text" class="input_box_disable" size="8" maxlength="10" readonly align="right">
	                  		</td>
		                  	<td width="20" height="25" colspan="-1" align="center">
		                  		<a href="javascript:openZoom();"><img src="images/search.gif" width="16" height="16" border="0"></a>
	                  		</td>
		                  	<td>
		                  		<input id="txtProjectOwnerName" name="txtProjectOwnerName" type="text" class="input_box_disable" size="40" maxlength="50" readonly>
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
        <input type="hidden" id="hidDocType" name="hidDocType" value="">
        <p>&nbsp;</p>
      </td>
    </tr>
</table>
</form>
<form name="formsearch" method="post" action="project_manager1.jsp" target = "_self">
<input type="hidden" name="MODE"                 value="">
<input type="hidden" name="PROJECT_NAME_SEARCH"  value="">
<input type="hidden" name="PROJECT_OWNER_SEARCH" value="">
<input type="hidden" name="DOC_TYPE_SEARCH"      value="">
<input type="hidden" name="screenname"           value="<%=screenname%>">
</form>
</body>
</html>
<script language="JavaScript" type="text/javascript">
<!--

var obj_txtUserId           = document.getElementById("txtUserId");
var obj_txtProjectName      = document.getElementById("txtProjectName");
var obj_txtProjectOwner     = document.getElementById("txtProjectOwner");
var obj_txtProjectOwnerName = document.getElementById("txtProjectOwnerName");
var obj_hidDocType          = document.getElementById("hidDocType");

//-->
</script>