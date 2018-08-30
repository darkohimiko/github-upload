<%@ page contentType="text/html; charset=tis-620"%>
<%@ include file="constant.jsp" %>
<%@ include file="label.jsp" %>
<%@ include file="utils.jsp" %>
<jsp:useBean id="con" scope="session" class="edms.cllib.EABConnector"/>
<%
	con.setRemoteServer("EAS_SERVER");

	String strProjectCode	= getField( request.getParameter("PROJECT_CODE") );
	String strExportPath	= getField( request.getParameter("EXPORT_PATH") );
	String strMode			= getField( request.getParameter("MODE") );
	String strClassName	= "FIELD_MANAGER";

	String strmsg					= "";
	String strErrorCode			= null;
	String strErrorMessage	= null;
	
	boolean isSuccess = false;
    
	if( strMode.equals("EXP") ) {
        con.addData( "PROJECT_CODE",	"String",		strProjectCode );
        con.addData( "EXPORT_PATH",	"String",		strExportPath );
        
        isSuccess = con.executeService( strContainerName, strClassName, "exportCabinetIndex2XML" );
        if( !isSuccess ) {
            strErrorCode		= con.getRemoteErrorCode();
            strErrorMessage	= con.getRemoteErrorMesage();
            strMode				= "FAIL";
        }else {
		    strmsg	= "../showMsg(0,0,\" " + lc_export_xml_successfull + "\")";
        	strMode	= "SUCCESS";
        }
    }

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

var strMethod = "<%=strMode %>";
var txtExportPath;

function initForm(){
	txtExportPath = form1.EXPORT_PATH;
	/*
	hidSignFlag	= form1.SIGN_DOC;
	var sign_obj = parent.formXml.SIGNATURE_FLAG;
	
	if(sign_obj){
		hidSignFlag.value = sign_obj.value;
		
		if(sign_obj.value == "true"){
			div_signature.style.display = "inline";
		}else{
			div_signature.style.display = "none";
		}
		
		parent.formXml.SIGNATURE_FLAG.value = "false";
	}
	
	set_parameter();
		
	if(sign_obj){	
		parent.formXml.SIGNATURE_FLAG.value = 	hidSignFlag.value;
	}
	*/
}

function set_parameter(){
	var strTemp = "{";
	for( var intElement = 0 ; intElement < parent.formXml.elements.length ; intElement++ ){
		if( strTemp != "{" ){
			strTemp += " , ";
		}
		strTemp += " \"" + parent.formXml.elements[ intElement ].name + "\" : \"" + parent.formXml.elements[ intElement ].value + "\" ";
	}

	strTemp += "}";

	objParameter = eval( "(" + strTemp + ")" );	
}

function window_onload(){
	initForm();
	if( strMethod == "SUCCESS" ) {
		eval( "opener.afterExport();" );
		window.close();
	}
}

function window_onunload(){	
}

function set_sign(){
	var hid_sign_flag	= form1.SIGN_DOC.value;
	
	if(form1.check_sign.checked){
		parent.formXml.SIGNATURE_FLAG.value = "true";
	}else{
		parent.formXml.SIGNATURE_FLAG.value = "false";
	}
	set_parameter();
	
	parent.formXml.SIGNATURE_FLAG.value = hid_sign_flag;
}

function set_code_flag(){
	
	if(form1.check_code.checked){
		parent.formXml.CODE_FLAG.value = "Y";
	}else{
		parent.formXml.CODE_FLAG.value = "N";
	}
	set_parameter();
}

function btnbpath_onclick() {
	outPath = edmso.browserDirectory;
    if( outPath == "" ) {
        return;
    }
//    exportform.expPath.value =outPath;
	txtExportPath.value = outPath;
}

function btnexport_onclick() {
	form1.MODE.value	= "EXP";
	form1.method		= "post";
	form1.action			= "export_xmldata.jsp";
	form1.submit();
}

</script>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onload="MM_preloadImages('../images/btt_export_over.gif');window_onload();" onunload="window_onunload();">
<form method="post" name="form1">
<table width="500" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td width="23"><img src="../images/popup_01.gif" width="23" height="271"></td>
    <td width="457" valign="top" background="../images/popup_02.gif"><table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td colspan="2" valign="bottom"><img src="../images/exportxml.gif" height="41"></td>
        </tr>
        <tr> 
          <td height="50" colspan="2">&nbsp;</td>
        </tr>
        <tr> 
          <td width="88"><div align="right"><img src="../images/select.gif" width="88" height="29">&nbsp;</div></td>
          <td width="*">
          	<input id="EXPORT_PATH"  name="EXPORT_PATH"  type="text"  size="37"  value="C:\\">
	            <a href="javascript:btnbpath_onclick()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('browse','','../images/btt_browse_over.gif',0)">
	            	<img src="../images/btt_browse.gif" name="browse" width="100" height="32" border="0" align="absmiddle"></a>
          </td>
        </tr>
        <tr> 
          <td height="45" colspan="2">
          	<div align="center">
          		<a href="javascript:btnexport_onclick()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('export','','../images/btt_export_over.gif',1)">
          			<img src="../images/btt_export.gif" name="export" height="22" border="0"></a>
          	</div>
          </td>
        </tr>
      </table></td>
    <td width="20">
    	<img src="../images/popup_04.gif" width="22" height="271">
    	<input id="MODE" 					name="MODE"					type="hidden"  value="<%=strMode %>">
		<input id="PROJECT_CODE" 	name="PROJECT_CODE" 	type="hidden"  value="<%=strProjectCode %>">
    </td>
  </tr>
</table>
</form>
<span style="display:none">
<OBJECT id=edmso classid=clsid:6C8D2BFF-C660-472D-AC2C-04E019E4A105 name=edmso codebase="webinstall/setup.cab#version=1,0,0,1" VIEWASTEXT></OBJECT>
</span>
</body>
</html>
<%  if (!strmsg.equals("")) {  %>
<script language="javaScript">
    <%=strmsg%>
</script>
<%  }   %>