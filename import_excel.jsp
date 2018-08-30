<%@ page contentType="text/html; charset=tis-620"%>
<%@ include file="inc/constant.jsp" %>
<%@ include file="inc/label.jsp" %>
<%@ include file="inc/utils.jsp" %>
<%@ page import="java.util.Vector"%>
<%@ page import="edms.upload.Attachment"%>
<%@	page import="edms.cllib.EAFileRemote"%>
<%@	page import="java.io.File"%>
<%@ page import="java.net.MalformedURLException"%>
<jsp:useBean id="con" scope="session" class="edms.cllib.EABConnector"/>
<%!
	public String getRealPath(String resource) throws MalformedURLException{
	    String filename, path;
	    filename = resource;
	    if(this.getServletContext().getServerInfo().startsWith("WebLogic")){
	        if(resource.equals(""))
	            resource = "/";
	        path = this.getServletContext().getResource(resource).getPath();
	        if(path != null){
	            if(path.charAt(0) == '/')
	                filename = path.substring(1);
	            else
	                filename = path;
	        }
	    }else{
	        path = this.getServletContext().getRealPath("");
	        if(path != null)
	            filename = path + resource;
	    }
	    return filename.replace('/', File.separatorChar);
	}


%>
<%
	EAFileRemote eafr 	= new EAFileRemote();
	
	con.setRemoteServer("EAS_SERVER");
	eafr.setServer("EAS_SERVER");
	
	String strProjectCode 	= checkNull(request.getParameter("PROJECT_CODE"));
	String strUserId 		= checkNull(request.getParameter("USER_ID"));
	String strScanOrg 		= checkNull(request.getParameter("SCAN_ORG"));
	String strDocumentLevel	= checkNull(request.getParameter("DOCUMENT_LEVEL"));
	String strClassName     = "UPLOAD_EXCEL";
	
    Vector 		vAttach;
    Attachment 	att;
    
    String	strShowMessage 	= "";
    String	strFlagSuccess	= "false";
    String 	strFilename 	= "";
    String	strSrcFile 		= "";
    String	strDesFile  	= "";
    //String	strDataPath 	= "C:\\temp\\";
    String	strDataPath 	= getRealPath( File.separator + "WEB-INF" + File.separator + "data" + File.separator );
    int 	attSize = 0;
    
    if(!strProjectCode.equals("")){
    	session.setAttribute("PROJECT_CODE", 	strProjectCode);
    	session.setAttribute("USER_ID", 		strUserId);
    	session.setAttribute("SCAN_ORG", 		strScanOrg);
    	session.setAttribute("DOCUMENT_LEVEL", 	strDocumentLevel);
    }else{
    	strProjectCode 		= checkNull(session.getAttribute("PROJECT_CODE"));
    	strUserId 			= checkNull(session.getAttribute("USER_ID"));
    	strScanOrg 			= checkNull(session.getAttribute("SCAN_ORG"));
    	strDocumentLevel	= checkNull(session.getAttribute("DOCUMENT_LEVEL"));    	
    }
    
    vAttach = (Vector)session.getAttribute("ATTACH");
    if (vAttach == null){
    	vAttach = new Vector();
    }
    attSize = vAttach.size();
    
	for (int i=0; i<attSize; i++){
	    att = (Attachment)vAttach.elementAt(i);
	    strFilename = att.getFileName();
	}

	strSrcFile	= strDataPath + strFilename;
    strDesFile  = "temp\\" + strFilename;
    
	if(attSize > 0){
		
		if(eafr.put( strSrcFile, strDesFile )){
			new File(strSrcFile).delete();
		}
		con.addData("SRC_PATH", 	  "String", strSrcFile);
			
		con.addData("PROJECT_CODE",   "String", strProjectCode);
		con.addData("USER_ID", 		  "String", strUserId);
		con.addData("SCAN_ORG", 	  "String", strScanOrg);
		con.addData("DOCUMENT_LEVEL", "String", strDocumentLevel);
		con.addData("FILE_PATH", 	  "String", strDesFile);
		
		boolean bolUploadSuccess = con.executeService(strContainerName, strClassName, "importExcelData");
		if(bolUploadSuccess){
			strShowMessage 	= "Import Excel Success !!!";
			strFlagSuccess	= "true";
		}else {
			strShowMessage 	= "Import Excel Fail !!!";
			strFlagSuccess	= "false";
		}
		
		vAttach.clear();
		session.removeAttribute("ATTACH");
	}
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html>
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=tis-620">
<LINK href="css/edas.css" type=text/css rel=stylesheet>
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
<script ID="clientEventHandlersJS" language="JavaScript">

<!--

function window_onload(){
	var showMessage = "<%=strShowMessage%>"
	var succFlag	= <%=strFlagSuccess%>;
	if(showMessage != ""){
		if(!succFlag){
			alert(showMessage);
		}
		if( parent && parent.closeImportExcelWindow ){
			parent.closeImportExcelWindow( true , '<%=attSize%>' );
		}
	}	
}

function window_onunload(){
}

function btnbpath_onclick(){
//	attach.IMPORT_PATH.click();
//	attach.file1.value = attach.IMPORT_PATH.value;
}

function btnimp_onclick(){
	
	if(verifyFileType()){
		document.attach.todo.value = "upload";
		document.attach.submit();
	}
}

function verifyFileType(){

	if(document.attach.file1.value == "") {
		alert("Must choose a file first!");
		return false;
	}
	if(document.attach.file1.value.length < 5) {
		alert("Invalid filename. Must contain proper extension.");
		return false;
	}
	if(document.attach.file1.value.search(/\.(xls)$/) == -1) {
		alert("Invalid filename extension.");
		return false;
	}
	return true;
}

//-->
</script>
</head>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onload="window_onload();" onunload="MM_preloadImages('images/btt_importexcel_over.gif');window_onunload();">
<form id="attach" name="attach" method="post" action="uploadfile" enctype="multipart/form-data">
<table width="500" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td width="23"><img src="images/popup_01.gif" width="23" height="271"></td>
    <td width="457" valign="top" background="images/popup_02.gif"><table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td colspan="2"><img src="images/import excel.gif" height="42"></td>
        </tr>
        <tr> 
          <td height="50" colspan="2">&nbsp;</td>
        </tr>
        <tr> 
          	<td width="88"><div align="right"><img src="images/select.gif" width="88" height="29">&nbsp;</div></td>
          	<td width="*">
          		
       			<input name="file1" id="file1" type="file" size="37" style="display: inline;">
				<a href="#" onclick="javascript:btnbpath_onclick();" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('browse','','images/btt_browse_over.gif',0)"><img src="images/btt_browse.gif" name="browse" width="100" height="32" border="0" align="absmiddle" style="display:none;"></a>
			</td>
        </tr>
        <tr> 
          <td height="45" colspan="2"><div align="center"><a href="javascript:btnimp_onclick();" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('import','','images/btt_importexcel_over.gif',1)"><img src="images/btt_importexcel.gif" name="import" width="142" height="22" border="0"></a></div></td>
        </tr>
      </table></td>
    <td width="20"><img src="images/popup_04.gif" width="22" height="271"></td>
  </tr>
</table>
<input type="hidden" name="todo" 			value="upload">
<input type="hidden" name="PROJECT_CODE" 	value="<%=strProjectCode %>">
<input type="hidden" name="USER_ID" 		value="<%=strUserId %>">
<input type="hidden" name="SCAN_ORG" 		value="<%=strScanOrg %>">
<input type="hidden" name="DOCUMENT_LEVEL" 	value="<%=strDocumentLevel %>">
</form>
</body>
</html>