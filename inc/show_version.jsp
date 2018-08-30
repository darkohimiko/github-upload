<%@page import="com.scc.edms.conf.ImageConfUtil"%>
<%@ page contentType="text/html; charset=tis-620"%>
<%@ page import="com.scc.security.UserInfo" %>
<%@ include file="constant.jsp" %>
<%@ include file="label.jsp" %>
<%@ include file="utils.jsp" %>
<jsp:useBean id="con" scope="session" class="edms.cllib.EABConnector"/>
<jsp:useBean id="con2" scope="session" class="edms.cllib.EABConnector"/>
<%

    String securecode = "";
    con.setRemoteServer("EAS_SERVER");
    con2.setRemoteServer("EAS_SERVER");
    
    if (!con.executeService("EASSYSTEM", "SECURECODE", "genSecurityCode")){
        out.println("Create Image Login Session Fail");
        return;
    }
    securecode = con.getHeader("SECURECODE");
%>
<%
    UserInfo userInfo = (UserInfo)session.getAttribute( "USER_INFO" );
    String strUserName      = userInfo.getUserName();

    String strClassName  = "EDIT_DOCUMENT";
    String strMethodName = "findVersionDocument";

    String strBatchNo 	= checkNull(request.getParameter("BATCH_NO"));
    String strDocumentRunning = checkNull(request.getParameter("DOCUMENT_RUNNING"));
    String strScanNo       = checkNull(request.getParameter("SCAN_NO"));
    String strDocumentType = checkNull(request.getParameter("DOCUMENT_TYPE"));
    String strProjectCode  = checkNull(request.getParameter("PROJECT_CODE"));

    String strWaterMarkFlag = "";
    String strCurrentDate   = "";
    String strContainerType = ImageConfUtil.getInetContainerType();
    String strVersionLang   = ImageConfUtil.getVersionLang();
    
    if( strVersionLang.equals("thai") ) {
        strCurrentDate = getServerDateThai();
    }else{
        strCurrentDate = getServerDateEng();
    }



    String  strErrorMessage = "";
    boolean bolSuccess = false;
    boolean bolnWaterMarkSuccess = false;

    con.addData("PROJECT_CODE", "String", strProjectCode);
    bolnWaterMarkSuccess = con.executeService(strContainerName, "PROJECT_MANAGER", "findWaterMarkFlag");
    if(bolnWaterMarkSuccess){
            strWaterMarkFlag = con.getHeader("WATERMARK_FLAG");
    }else{
            strWaterMarkFlag = "N";
    }	

    con.addData( "BATCH_NO"		, "String", strBatchNo );
    con.addData( "SCAN_NO"		, "String", strScanNo );
    con.addData( "DOCUMENT_RUNNING"	, "String", strDocumentRunning );
    con.addData( "DOCUMENT_TYPE"	, "String", strDocumentType );
    con.addData( "PROJECT_CODE"		, "String", strProjectCode );

    bolSuccess = con.executeService( strContainerName, strClassName, strMethodName );
    if(!bolSuccess){
            strErrorMessage = lc_data_not_found;
    }
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=tis-620">
<title><%=lb_version_doc %></title>
<link href="../css/edas.css" rel="stylesheet" type="text/css">
<style type="text/css">
<!--
body {
	margin-left: 0px;
	margin-top: 0px;
}
-->
</style>
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
<script language="JavaScript" src="../js/constant.js"></script>
<script language="JavaScript" src="../js/label.js"></script>
<script language="JavaScript" src="../js/sccUtils.js"></script>
<script language="JavaScript" src="../js/util.js"></script>
<script language="JavaScript" src="../js/waterMark.js"></script>
<script type="text/javascript">
<!--

var sccUtils = new SCUtils();
var waterMk  = new waterMark();

function row_click( row_obj ){

    var strBlobId   = row_obj.getAttribute("BLOB");
    var strBlobPart = row_obj.getAttribute("PICT");

    openShowView( strBlobId , strBlobPart );
        
}

function openShowView( strBlobId , strBlobPart ){
    initAndShow();
    inetdocview.SetProperty("RemoveToolBar", rem_toolbar);
    inetdocview.SetProperty("CloseWhenSave", "true");
    setWaterMark();
    retrieveImage( strBlobId , strBlobPart );
}

function initAndShow(){
    var x,y,w,h;
    x = screen.width /2;
    y = 0;
    w = screen.width;
    h = screen.height;
    inetdocview.Close();
    inetdocview.Open();
    inetdocview.Resize(x, y, w, (h-30));
    inetdocview.ContainerType("<%=strContainerType%>");
}

function setWaterMark(){
    var wm_flag = "<%=strWaterMarkFlag %>";
    var av_time = getCurrentTime();
    
    if(wm_flag != 'N'){
        waterMk.setWaterMark( wm_flag, "<%=strUserName %>", "<%=dateToDisplay(strCurrentDate, "/")%>", av_time + " ¹." );
    }
}

function retrieveImage( strBlobId, strBlobPart ){
    
    if ((strBlobId != "") && (strBlobPart != "")){
        inetdocview.Retrieve(strBlobId, strBlobPart);
    }
}

function cancel_click(){
	window.close();
}

function window_onunload(){
	try{
		inetdocview.Close();
	}catch( e ){
	}
}
	
//-->
</script>
</head>
<body onLoad="MM_preloadImages('../images/btt_cancel_over.gif');" onunload="window_onunload()">
<form name="form1" method="post">
<table width="90%" align="center" class="label_normal2" border="0">
    <tr><td height="20"></td></tr>
    <tr>
        <td align="center" valign="bottom">
            <table border="0" cellspacing="0" width="100%">
                <tr>
                    <td width="15%" height="22" class="hd_table"><%=lb_version %></td>
                    <td width="25%" height="22" class="hd_table"><%=lb_date %></td>
                    <td width="60%" height="22" class="hd_table"><%=lb_edit_user %></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
            <td valign="top"><div style="width:auto;height:280px;overflow:auto">
                    <table width="100%" border="0" cellspacing="0" >			
<%				if(!bolSuccess){%>
				<tr><td class="label_bold2" align="center" colspan="3" bgcolor="#ffffff"><%=strErrorMessage %></td></tr>
<%				}else{
					
					int intRecord = 0;
					String strScript;
				
					String 	strVersion  = "";
					String	strScanDate = "";
					String	strEditName = "";
					
					String	strBlob		= "";
					String	strPict		= "";
					String	strDocLevel	= "";
					
					while(con.nextRecordElement()){
						intRecord++;
						
						strBlob		= "";
						strPict		= "";
						strDocLevel	= "";
						
						strVersion  = con.getColumn("SCAN_NO");
						strScanDate = con.getColumn("SCAN_DATE");
						strEditName = con.getColumn("USER_NAME");
						
						if(!strScanDate.equals("")){
							strScanDate = dateToDisplay(strScanDate,"/");
						}
						
						con2.addData( "BATCH_NO", 	  "String", strBatchNo );
						con2.addData( "DOCUMENT_RUNNING", "String", strDocumentRunning );
						con2.addData( "DOCUMENT_TYPE", 	  "String", strDocumentType );
						con2.addData( "PROJECT_CODE", 	  "String", strProjectCode );
						con2.addData( "SCAN_NO", 	  "String", strVersion );
						
						boolean bolAttachSuccess = con2.executeService( strContainerName, strClassName, "findAttachData" );
						if(bolAttachSuccess){
							while(con2.nextRecordElement()){
								strBlob 	= con2.getColumn("BLOB");
								strPict 	= con2.getColumn("PICT");
								strDocLevel = con2.getColumn("DOCUMENT_LEVEL");
							}
						}
						
						strScript  = "BLOB=\"" + strBlob + "\" " +
									 "PICT=\"" + strPict + "\" " +
									 "DOCUMENT_LEVEL=\"" + strDocLevel + "\" ";
						strScript += "onClick=\"row_click( this );\" ";
						
				if( intRecord % 2 == 1 ){
%>
		  <tr class="table_data1" <%=strScript%> style="cursor:pointer">
		    <td width="15%" height="22" align="right"><%=strVersion%>&nbsp;</td>
		    <td width="25%" height="22" align="center"><%=strScanDate%></td>
		    <td width="60%" height="22"><%=strEditName%></td>
		  </tr>
<%
				}else{
%>
		  <tr class="table_data2" <%=strScript%> style="cursor:pointer">
		    <td width="15%" height="22" align="right"><%=strVersion%>&nbsp;</td>
		    <td width="25%" height="22" align="center"><%=strScanDate%></td>
		    <td width="60%" height="22"><%=strEditName%></td>
		  </tr>
<%
				}}} 
%>				
			</table>
			</div>
		</td>
	</tr>
	<tr>
		<td height="25">&nbsp;</td>
	</tr>
	<tr>
		<td align="center">
			<a href="javascript:cancel_click();" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image2','','../images/btt_cancel_over.gif',1)"><img src="../images/btt_cancel.gif" name="Image2" width="67" height="22" border="0"></a>
		</td>
	</tr>
</table>
<input type="hidden" name="PERMIT_FUNCTION" value="search,prnImg,link,export">
</form>
<iframe scrolling="no" frameborder="0" name="inetdocview" src="/jinetdocarchive/imageproxy?codetype=applet&version=15&securecode=<%=securecode%>" width="32" height="32" marginwidth="0">
</iframe>
</body>
</html>