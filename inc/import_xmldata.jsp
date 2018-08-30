<%@ page contentType="text/html; charset=tis-620"%>
<%@ include file="constant.jsp" %>
<%@ include file="utils.jsp" %>
<%
	String strClassName   = "FIELD_MANAGER";
	String user_role      = getField( request.getParameter("user_role") );
	String app_name       = getField( request.getParameter("app_name") );
	String app_group      = getField( request.getParameter("app_group") );
	String screenname     = getField( request.getParameter("screenname") );
	String strProjectCode = getField( request.getParameter("PROJECT_CODE") );
	String strContName    = getField( request.getParameter("CONTAINER_NAME") );
	String strMethodName  = getField( request.getParameter("METHOD_NAME") );
	String strResult      = getField( request.getParameter("RESULT") );

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title></title>
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
<script language="JavaScript">
var str_result      = "<%=strResult %>";
var str_user_role   = "<%=user_role %>";
var str_app_name    = "<%=app_name %>";
var str_app_group   = "<%=app_group %>";
var str_screen_name = "<%=screenname %>";

function initForm(){
	txtImportPath = form1.IMPORT_PATH
}

function window_onload(){
	//initForm();
	if( str_result == "success" ) {
		close_window();
	}
}

function window_onunload(){
}

function btnbpath_onclick() {
	form1.IMPORT_PATH.click();
	form1.IMPORT_FILE.value     = form1.IMPORT_PATH.value;

	//opener.formExport.IMPORT_XML_PATH.value	= form1.IMPORT_FILE.value;
	//opener.importXmlFromPath();
	//window.close();
}

function import_xml() {
	var strImportPath = form1.IMPORT_PATH.value;
	if( strImportPath == "" ) {
		return;
	}
	opener.afterImportSuccess();
	form1.submit();
	window.close();
}

</script>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onload="window_onload();" >
<form action="../FieldImportXmlServlet" method="post" name="form1" enctype="multipart/form-data">
<table width="500" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td width="23"><img src="../images/import/popup_01.gif" width="23" height="271"></td>
    <td width="457" valign="top" background="../images/import/popup_02.gif">
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td colspan="2"><img src="../images/import/importxml.gif" height="42"></td>
        </tr>
        <tr>
          <td height="50" colspan="2">&nbsp;</td>
        </tr>
        <tr>
          <td width="100"><div align="right">
          		<img src="../images/import/select.gif" width="88" height="29">&nbsp;</div>
          </td>
          <td width="*">
          <!-- 
          		<input name="IMPORT_FILE" type="text" size="37">
            	<a href="javascript:btnbpath_onclick()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('browse','','../images/import/btt_browse_over.gif',0)">
            		<img src="../images/import/btt_browse.gif" name="browse" width="100" height="32" border="0" align="absmiddle"></a>
           -->
          		<input name="IMPORT_PATH" type="file" size="45" >
          		<input type="hidden" name="user_role"       value="<%=user_role %>" >
			    <input type="hidden" name="app_name"        value="<%=app_name %>" >
			    <input type="hidden" name="app_group"       value="<%=app_group %>" >
			    <input type="hidden" name="screenname"      value="<%=screenname %>" >
				<input type="hidden" name="PROJECT_CODE"    value="<%=strProjectCode %>" >
			    <input type="hidden" name="CONTAINER_NAME"  value="<%=strContName %>" >
			    <input type="hidden" name="CLASS_NAME"      value="<%=strClassName %>" >
			    <input type="hidden" name="METHOD_NAME"     value="<%=strMethodName %>" >
			    <input type="hidden" name="REMOTE_SERVER"   value="EAS_SERVER" >
			    <input type="hidden" name="IMPORT_XML_PATH" value="wwwww.xml" > 
			    <!-- input type="submit" name="btnSubmit" value="OK" >
			    
			    <input type="button" name="btnImp" value="Import" onclick="import_xml()" -->
          </td>
        </tr>
        <tr> 
          <td height="45" colspan="2">
          	<div align="center"><a href="javascript:import_xml()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('import','','../images/import/btt_import_over.gif',1)">
          		<img src="../images/import/btt_import.gif" name="import" width="142" height="22" border="0"></a>
          	</div>
          </td>
        </tr>
      </table></td>
    <td width="20"><img src="../images/import/popup_04.gif" width="22" height="271"></td>
  </tr>
</table>
</form>
<!-- 
<form name="formImport" method="post" action="FieldImportXmlServlet">
	<input type="hidden" name="PROJECT_CODE"   value="<%=strProjectCode %>">
    <input type="hidden" name="CONTAINER_NAME" value="<%=strContName %>">
    <input type="hidden" name="CLASS_NAME"     value="<%=strClassName %>">
    <input type="hidden" name="METHOD_NAME"    value="<%=strMethodName %>">
    <input type="hidden" name="REMOTE_SERVER"  value="EAS_SERVER">
    <input type="hidden" name="user_role"      value="<%=user_role %>" >
    <input type="hidden" name="app_name"       value="<%=app_name %>" >
    <input type="hidden" name="app_group"      value="<%=app_group %>" >
    <input type="hidden" name="screenname"     value="<%=screenname %>" >
    
    <input type="hidden" name="IMPORT_XML_PATH"	value=""  >
</form>
 -->
<span style="display:none">
<OBJECT id=edmso classid=clsid:6C8D2BFF-C660-472D-AC2C-04E019E4A105 name=edmso codebase="webinstall/setup.cab#version=1,0,0,1" VIEWASTEXT></OBJECT>
</span>
</body>
</html>