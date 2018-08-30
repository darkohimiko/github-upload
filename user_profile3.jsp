<%@ page contentType="text/html; charset=tis-620"%>
<%@ include file="inc/checkUser.jsp" %>
<%@ include file="inc/constant.jsp" %>
<%@ include file="inc/label.jsp" %>
<%@ include file="inc/utils.jsp" %>
<jsp:useBean id="con1" scope="session" class="edms.cllib.EABConnector"/>
<%
	con1.setRemoteServer("EAS_SERVER");
    
	String screenname   = getField(request.getParameter("screenname"));
    String screenLabel  = lb_search_profile;
    String strClassName = "USER_PROFILE";

	boolean bolnZoomSuccess = true;
    
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
    lb_user_id.innerHTML     = lbl_user_profile1;
    lb_user_name.innerHTML   = lbl_user_profile2_4;
    lb_user_sname.innerHTML  = lbl_user_profile2_5;
    lb_user_level.innerHTML  = lbl_user_profile2_6;
    lb_user_org.innerHTML    = lbl_user_profile2_7;
    lb_user_status.innerHTML = lbl_user_profile5;
}

function openZoom( strZoomType ) {
	var strPopArgument   = "scrollbars=yes,status=no";
	var strWidth         = ",width=370px";
	var strHeight        = ",height=420px";
	var strUrl           = "";
	var strConcatField   = "";

	strPopArgument += strWidth + strHeight;

	switch( strZoomType ){
		case "level" :
				strUrl = "inc/zoom_data_table_level1.jsp";
				strConcatField = "TABLE=USER_LEVEL" + "&TABLE_LABEL=" + lbl_user_profile2_6;
				strConcatField += "&RESULT_FIELD=txtUserLevel,txtLevelName";
				break;
		case "org" :
				strUrl = "inc/zoom_data_table_level1.jsp";
				strConcatField = "TABLE=ORG" + "&TABLE_LABEL=" + lbl_user_profile2_7;
				strConcatField += "&RESULT_FIELD=txtOrgCode,txtOrgName";
				break;
	}

	objZoomWindow = window.open( strUrl + "?" + strConcatField, strZoomType, strPopArgument );
	objZoomWindow.focus();
}

function getValueStatus() {
	var objUserStatus = document.getElementById("optUserStatus");
	var statusIndex   = objUserStatus.selectedIndex;
	var statusValue   = objUserStatus.value;
	
	if( statusIndex == 0 ) {
		obj_hidUserStatus.value = "";
	}else {
		obj_hidUserStatus.value = statusValue;
	}
}

function buttonClick( lv_strMethod, lv_strValue ){
    switch( lv_strMethod ){
		case "search" :
		    if(verify_form()){
				formsearch.USER_ID_SEARCH.value     = obj_txtUserId.value;
		        formsearch.USER_NAME_SEARCH.value   = obj_txtUserName.value;
		        formsearch.USER_SNAME_SEARCH.value  = obj_txtUserSname.value;
		        formsearch.USER_LEVEL_SEARCH.value  = obj_txtUserLevel.value;
		        formsearch.ORG_CODE_SEARCH.value    = obj_txtOrgCode.value;
		        formsearch.USER_STATUS_SEARCH.value = obj_hidUserStatus.value;
		        formsearch.MODE.value = "FIND" ;
				formsearch.submit();
			}
			break;
		case "cancel" :
			form1.action     = "user_profile1.jsp";
			form1.target 	 = "_self";
		    form1.MODE.value = "SEARCH";
		    form1.submit();
			break;
	}
}

function verify_form() {
	if( obj_txtUserId.value.length == 0 && obj_txtUserName.value.length == 0 
		&& obj_txtUserSname.value.length == 0 && obj_txtUserLevel.value == ""
		&& obj_txtOrgCode.value == "" && obj_hidUserStatus.value == "" ) {
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
		                  	<td width="99" height="25" class="label_bold2"><span id="lb_user_id"></span></td>
		                  	<td height="25" colspan="3">
	                      		<input  type="text" id="txtUserId" name="txtUserId" class="input_box" size="17" maxlength="30">
		                  	</td>
	                	</tr>
	                	<tr>
		                  	<td height="25" class="label_bold2"><span id="lb_user_name"></span></td>
		                  	<td height="25" colspan="3">
		                  		<input id="txtUserName" name="txtUserName" type="text" class="input_box" size="20" maxlength="30">
	                  		</td>
	                	</tr>
	                	<tr>
		                  	<td height="25" class="label_bold2"><span id="lb_user_sname"></span></td>
		                  	<td height="25" colspan="3">
		                  		<input id="txtUserSname" name="txtUserSname" type="text" class="input_box" size="20" maxlength="30">
	                  		</td>
	                	</tr>
	                	<tr>
		                  	<td height="25" class="label_bold2"><span id="lb_user_level"></span></td>
		                  	<td width="67" height="25">
		                  		<input id="txtUserLevel" name="txtUserLevel" type="text" class="input_box_disable" size="8" maxlength="10" readonly>
	                  		</td>
		                  	<td width="20" height="25" colspan="-1" align="center">
		                  		<a href="javascript:openZoom('level');"><img src="images/search.gif" width="16" height="16" border="0"></a>
	                  		</td>
		                  	<td>
		                  		<input id="txtLevelName" name="txtLevelName" type="text" class="input_box_disable" size="40" maxlength="50" readonly>
	                  		</td>
	                	</tr>
	                	<tr>
		                  	<td height="25" class="label_bold2"><span id="lb_user_org"></span></td>
		                  	<td width="67" height="25">
		                  		<input id="txtOrgCode" name="txtOrgCode" type="text" class="input_box_disable" size="8" maxlength="10" readonly>
	                  		</td>
		                  	<td width="20" height="25" colspan="-1" align="center">
		                  		<a href="javascript:openZoom('org');"><img src="images/search.gif" width="16" height="16" border="0"></a>
	                  		</td>
		                  	<td>
		                  		<input id="txtOrgName" name="txtOrgName" type="text" class="input_box_disable" size="40" maxlength="50" readonly>
	                  		</td>
	                	</tr>
<%
		String strTagOption      = "";
		String strZoomUserStatus = "";
		String strZoomStatusName = "";
		strTagOption = "\n<select id=\"optUserStatus\" name=\"optUserStatus\" class=\"combobox\" onchange=\"getValueStatus();\">";
		strTagOption += "\n<option value=\"\"></option>";
		
		bolnZoomSuccess = con1.executeService( strContainerName, strClassName, "findUserStatusCombo" );
		
		if( bolnZoomSuccess ){
			while( con1.nextRecordElement() ){
				strZoomUserStatus = con1.getColumn( "USER_STATUS" );
				strZoomStatusName = con1.getColumn( "USER_STATUS_NAME" );
		
				strTagOption += "\n<option value=\"" + strZoomUserStatus + "\">" + strZoomStatusName + "</option>";
			}
		}
		
		strTagOption += "\n</select>";
%>
	                	<tr>
		                  	<td height="25" class="label_bold2"><span id="lb_user_status"></span></td>
		                  	<td height="25" colspan="3"><%=strTagOption %>
		                  		<input id="hidUserStatus" name="hidUserStatus" type="hidden" >
	                  		</td>
	                	</tr>
	                	<tr>
	                  		<td height="25" colspan="4">&nbsp;</td>
	                  	</tr>
			            <tr>
				           	<td align="center" colspan="4">
				           		<a href="#" onclick= "buttonClick('search')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('search','','images/btt_search_over.gif',1)">
				           			<img src="images/btt_search.gif" name="search" width="67" height="22" border="0">&nbsp;</a>
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
        <p>&nbsp;</p>
      </td>
    </tr>
</table>
</form>
<form name="formsearch" method="post" action="user_profile1.jsp" target = "_self">
<input type="hidden" name="MODE"               value="">
<input type="hidden" name="USER_ID_SEARCH"     value="">
<input type="hidden" name="USER_NAME_SEARCH"   value="">
<input type="hidden" name="USER_SNAME_SEARCH"  value="">
<input type="hidden" name="USER_LEVEL_SEARCH"  value="">
<input type="hidden" name="ORG_CODE_SEARCH"    value="">
<input type="hidden" name="USER_STATUS_SEARCH" value="">
<input type="hidden" name="screenname"         value="<%=screenname%>">
</form>
</body>
</html>
<script language="JavaScript" type="text/javascript">
<!--

var obj_txtUserId     = document.getElementById("txtUserId");
var obj_txtUserName   = document.getElementById("txtUserName");
var obj_txtUserSname  = document.getElementById("txtUserSname");
var obj_txtUserLevel  = document.getElementById("txtUserLevel");
var obj_txtOrgCode    = document.getElementById("txtOrgCode");
var obj_hidUserStatus = document.getElementById("hidUserStatus");

//-->
</script>