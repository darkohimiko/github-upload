<%@ page contentType="text/html; charset=tis-620"%>
<%@ page import="com.scc.security.UserInfo"%>
<%@ include file="inc/checkUser.jsp" %>
<%@ include file="inc/constant.jsp" %>
<%@ include file="inc/label.jsp" %>
<%@ include file="inc/utils.jsp" %>
<%
    String strMode                = checkNull(request.getParameter("MODE"));
    String strDocumentTypeKey 	  = checkNull(request.getParameter("DOCUMENT_TYPE"));
    String strDocumentTypeNameKey = getField(request.getParameter("DOCUMENT_TYPE_NAME"));
    
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=tis-620">
<title><%=lc_search_permit_user%></title>
<link href="css/edas.css" type="text/css" rel="stylesheet">
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
<script language="JavaScript" src="js/util.js"></script>
<script language="JavaScript" src="js/constant.js"></script>
<script language="JavaScript" src="js/label.js"></script>
<script language="javascript" type="text/javascript">
<!--
var objZoomWindow;

function click_cancel(  ){
    form1.action 	 = "document_type5.jsp";
    form1.target 	 = "_self";
    form1.MODE.value = "SEARCH";
    form1.submit();

}

function click_search(  ){
    form1.action 	 = "document_type5.jsp";
    form1.target 	 = "_self";
    form1.MODE.value = "SEARCH_INDEX";
    form1.submit();

}

function window_onload(){

	lb_user_id.innerHTML 	= lbl_user_profile1;
	lb_user_name.innerHTML 	= lbl_user_profile2_4;
	lb_user_sname.innerHTML = lbl_user_profile2_5;
	lb_user_org.innerHTML 	= lbl_user_profile2_7;
    
	form1.txtUserId.focus();
}

function openZoom( strZoomType , strZoomLabel , objDisplayText , objDisplayValue, strTableLevel ){
	var strPopArgument 	= "scrollbars=yes,status=no";
	var strWidth 		= ",width=370px";
	var strHeight 		= ",height=400px";
	var strUrl = "inc/zoom_data_table_level1.jsp";
	var strConcatField  = "TABLE=" + strZoomType;
	strConcatField += "&TABLE_LABEL=" + strZoomLabel;
	strConcatField += "&RESULT_FIELD=" + objDisplayValue.name + "," + objDisplayText.name;
							
	strPopArgument += strWidth + strHeight;						
	
	objZoomWindow = window.open( strUrl + "?" + strConcatField , "zm" + strZoomType , strPopArgument );
	objZoomWindow.focus();
}

function window_onunload(){
	if(objZoomWindow != null && objZoomWindow.closed){
		objZoomWindow.close();
	}
}


//-->
</script>
</head>
<body onload="MM_preloadImages('images/btt_ok_over.gif','images/btt_cancel_over.gif');window_onload()">
<form name="form1" action="" method="post">
	<table width="100%" border="0" align="center">
    	<tbody>
    		<col width="137" />
    		<col width="115" />
    		<col width="*" />
    		<col width="92" />    		
    	</tbody>          
       	<tr>
           	<td height="25" class="label_header01" colspan="4">
           	&nbsp;&nbsp;&nbsp;
       		</td>
       	</tr>       
        <tr>
          	<td width="137" align="right">&nbsp;</td>
          	<td width="115" align="center" valign="top">&nbsp;</td>
          	<td  align="center" valign="top">&nbsp;</td>
          	<td width="92" align="center" valign="top">&nbsp;</td>
        </tr>
        <tr>
          	<td align="right">&nbsp;</td>
          	<td height="25"><span class="label_bold2" id="lb_user_id"></span>&nbsp;</td>
          	<td height="25" ><input name="txtUserId" type="text" class="input_box" size="25" value="" ></td>
          	<td align="center" valign="top">&nbsp;</td>
        </tr>
        <tr>
          	<td align="right">&nbsp;</td>
          	<td height="25"><span class="label_bold2" id="lb_user_name"></span>&nbsp;</td>
          	<td height="25" ><input name="txtUserName" type="text" class="input_box" size="50" maxlength="100" value=""></td>
          	<td align="center" valign="top">&nbsp;</td>
        </tr>
        <tr>
          	<td align="right">&nbsp;</td>
          	<td height="25"><span class="label_bold2" id="lb_user_sname"></span>&nbsp;</td>
          	<td height="25" ><input name="txtUserSname" type="text" class="input_box" size="50" maxlength="100" value=""></td>
          	<td align="center" valign="top">&nbsp;</td>
        </tr>
        <tr>
          	<td align="right">&nbsp;</td>
          	<td height="25"><span class="label_bold2" id="lb_user_org"></span>&nbsp;</td>
          	<td height="25" ><input name="txtUserOrg" type="text" class="input_box_disable" size="8" readonly>
                <a href="javascript:openZoom('ORG' , '<%=lb_department %>' , form1.LEVEL_NAME , form1.txtUserOrg, '1');"><img src="images/search.gif" width="16" height="16" border="0" align="absmiddle" ></a> 
                <input name="LEVEL_NAME" type="text" class="input_box_disable" value="" size="35" maxlength="13" readonly /></td>
          	<td align="center" valign="top">&nbsp;</td>
        </tr>
        <tr>
          	<td align="right">&nbsp;</td>
          	<td align="center">&nbsp;</td>
          	<td >&nbsp;</td>
          	<td align="center" valign="top">&nbsp;</td>
        </tr>
        <tr>
        	<td align="right">&nbsp;</td>
          	<td align="center">&nbsp;</td>
          	<td colspan="2"><div align="left">
          	<a href="javascript:click_search()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('btt_ok','','images/btt_ok_over.gif',1)"><img src="images/btt_ok.gif" name="btt_ok" width="67" height="22" border="0"></a>
          	<a href="javascript:click_cancel()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('btt_cancel','','images/btt_cancel_over.gif',1)"><img src="images/btt_cancel.gif" name="btt_cancel" width="67" height="22" border="0"></a>
          	</div></td>
        </tr>
   	</table>
<input type="hidden" name="MODE" 				value="<%=strMode%>">
<input type="hidden" name="DOCUMENT_TYPE" 		value="<%=strDocumentTypeKey %>">
<input type="hidden" name="DOCUMENT_TYPE_NAME" 	value="<%=strDocumentTypeNameKey %>">  
</form>
</body>
</html>