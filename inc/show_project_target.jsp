<%@page import="com.scc.edms.conf.ImageConfUtil"%>
<%@ page contentType="text/html; charset=tis-620"%>
<%@ page import="com.scc.security.UserInfo"%>
<%@ include file="checkUser.jsp" %>
<%@ include file="constant.jsp" %>
<%@ include file="label.jsp" %>
<%@ include file="utils.jsp" %>
<jsp:useBean id="con" scope="session" class="edms.cllib.EABConnector"/>
<jsp:useBean id="conList" scope="session" class="edms.cllib.EABConnector"/>
<%
	con.setRemoteServer("EAS_SERVER");
	conList.setRemoteServer("EAS_SERVER");

	String strClassName = "EDIT_DOCUMENT";
	String strProjectCodeData = "";
	String strProjectNameData = "";
	String strErrorCode       = "";
		
	String strContainerType = ImageConfUtil.getInetContainerType();
	String strCurrentDate   = "";
	String strVersionLang  = ImageConfUtil.getVersionLang();

        if( strVersionLang.equals("thai") ) {
		strCurrentDate = getTodayDateThai();
	}else{
		strCurrentDate = getTodayDate();
	}
        
        UserInfo userInfo = (UserInfo)session.getAttribute( "USER_INFO" );
        String strUserId     = userInfo.getUserId();
        String strProjSource = userInfo.getProjectCode();
        String strSite       = userInfo.getSite();
	
	String strDocumentNo = checkNull(request.getParameter("DOCUMENT_NO"));
	String strBatchNo    = checkNull(request.getParameter("BATCH_NO"));
	String strDocRunning = checkNull(request.getParameter("DOCUMENT_RUNNING"));
		
	String strMode       = checkNull(request.getParameter("MODE"));
	String strProjTarget = checkNull(request.getParameter("selProjectCode"));
	
	boolean bolSuccess     = false;
	boolean bolListSuccess = false;
	
	conList.addData( "USER_ID", "String", strUserId );
	bolListSuccess = conList.executeService( strContainerName , strClassName , "findProjectTarget" );
	
	if(strMode.equals("CHECK_PROJECT")){
		
            con.addData( "PROJECT_CODE_SOURCE", "String", strProjSource );
            con.addData( "PROJECT_CODE_TARGET", "String", strProjTarget );
            con.addData( "USER_ID", 		"String", strUserId );
            con.addData( "CONTAINER_TYPE", 	"String", strContainerType );
            con.addData( "CURRENT_DATE", 	"String", strCurrentDate );
            con.addData( "SITE", 		"String", strSite );
            con.addData( "DOCUMENT_NO", 	"String", strDocumentNo );
            con.addData( "FULLTEXT_SEARCH" , 	"String", lc_fulltext_search );
		bolSuccess = con.executeService( strContainerName , strClassName , "moveDocumentProject" );
		if(!bolSuccess){
			strErrorCode    = con.getRemoteErrorCode();
		}
	}	

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=TIS-620">
<link rel="shortcut icon" href="../images/favicon/EDAS.ico" type="image/x-icon" />
<title><%=lc_project_target_title %></title>
<link href="../css/edas.css" type="text/css" rel="stylesheet">
<style type="text/css">

label_bold2 {
	font-size: 1.2 em;
}

.content {
	margin: auto;
	margin-top: 50px;	
}

select {
	width: 300px;
}

sp#lb_project_target {
	padding-left: 25px;
}

</style>
<script language="JavaScript" type="text/javascript">
<!--
function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
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
<script language="JavaScript" src="../js/sccUtils.js"></script>
<script language="JavaScript" src="../js/util.js"></script>
<script language="JavaScript" src="../js/constant.js"></script>
<script language="JavaScript" src="../js/label.js"></script>
<script type="text/javascript">
<!--

function window_onload(){
	
	lb_select_project_target.innerHTML = lbl_select_project_target;
	lb_project_target.innerHTML        = lbl_project_target;
	
	div_loading.style.display = "none";
	
	<% if(bolSuccess){%>
		get_log("<%=strBatchNo%>","<%=strDocRunning%>","M");		
		alert( lc_success_move_document );

		opener.focus();
		opener.click_back();
		
		window.close();
	<%	}else{
			if(strErrorCode.equals("ERR_MATCH_FIELD")){
	%>
		alert( lc_field_not_match );
	<%		}else if(strErrorCode.equals("ERR_MATCH_DOCTYPE")){ %>
		alert( lc_doctype_not_match );
	<%		}else {  %>
	<% 			if(strErrorCode.equals("ERR_MOVE_DOC")){%>
		alert(lc_cannot_move_document );
		
	<% 			}	
			}
		}
	%>
}

function ok_click(){
	
	div_loading.style.display = "inline";

	if(form1.selProjectCode.value == ""){
		alert(lc_select_dest_project);
		return;
	}
	
	form1.MODE.value = "CHECK_PROJECT";
	form1.submit();
	
}

function cancel_click(){
	window.close();
        opener.clear_screen();
}

function get_log(batch_no,document_running,action_flag){
	formLog.BATCH_NO.value 		   = batch_no;
	formLog.DOCUMENT_RUNNING.value = document_running;
	formLog.ACTION_FLAG.value	   = action_flag;
	formLog.target = "frameLog";
	formLog.action = "../master_log.jsp";
	formLog.submit();
	
}

function window_onunload(){
    opener.clear_screen();
}

//-->
</script>
</head>
<body onload="window_onload()" onunload="window_onunload()">
<form name="form1">
<div class="content">
<table width="100%" align="center" cellpadding="0" cellspacing="0" border="0" class="label_bold2" style="font-size: 14px">
	<tr valign="top">
		<td width="15"></td>
		<td colspan="2" align="center" height="50px;"><span id="lb_select_project_target"></span></td>
	</tr>
	<tr>
		<td></td>
		<td width="150" align="center"><span id="lb_project_target"></span></td>
		<td>
			<select name="selProjectCode" class="label_normal2" style="font-size: 14px">
				<option value=""></option>
<%
	if(bolListSuccess){
		while(conList.nextRecordElement()){
			strProjectCodeData = conList.getColumn("PROJECT_CODE");
			strProjectNameData = conList.getColumn("PROJECT_NAME");
			
			if(!strProjectCodeData.equals(strProjSource)){
				if(strProjectCodeData.equals(strProjTarget)){
					out.println("<option value=\"" + strProjectCodeData + "\" selected>" + strProjectNameData + "</option>\n");
				}else{
					out.println("<option value=\"" + strProjectCodeData + "\">" + strProjectNameData + "</option>\n");
				}
			}
		}
	}
%>	
			</select>
		</td>
	</tr>
	<tr>
		<td></td>
		<td></td>
		<td height="40px;">
			<a href="javascript:ok_click();" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image1','','../images/btt_ok_over.gif',1)"><img src="../images/btt_ok.gif" id="Image1" name="Image1" width="67" height="22" border="0"></a>&nbsp;
			<a href="javascript:cancel_click();" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image2','','../images/btt_cancel_over.gif',1)"><img src="../images/btt_cancel.gif" name="Image2" width="67" height="22" border="0"></a>
		</td>
	</tr>
	<tr>
		<td></td>
		<td></td>
		<td><div id="div_loading" style="display: none;">Loading...</div></td>
	</tr>
</table>
</div>

<input type="hidden" name="MODE" />
<input type="hidden" name="USER_ID" 			value="<%=strUserId %>" />
<input type="hidden" name="PROJECT_CODE_SOURCE" value="<%=strProjSource %>" />
<input type="hidden" name="SITE" 				value="<%=strSite %>" />
<input type="hidden" name="DOCUMENT_NO" 		value="<%=strDocumentNo %>" />
<input type="hidden" name="BATCH_NO" 			value="<%=strBatchNo %>" />
<input type="hidden" name="DOCUMENT_RUNNING" 	value="<%=strDocRunning %>" />
</form>
<form name="formLog">
  <input type="hidden" name="PROJECT_CODE" value="<%=strProjTarget %>">
  <input type="hidden" name="BATCH_NO">
  <input type="hidden" name="DOCUMENT_RUNNING">
  <input type="hidden" name="ACTION_FLAG">
</form> 
<iframe name="frameLog"  style="display:none"></iframe>
</div>
</body>
</html>