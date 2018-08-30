<%@page import="com.scc.edms.conf.ImageConfUtil"%>
<%@ page import="com.scc.security.UserInfo"%>
<%@ page contentType="text/html; charset=tis-620"%>
<%@ include file="inc/constant.jsp" %>
<%@ include file="inc/utils.jsp" %>
<jsp:useBean id="con" scope="session" class="edms.cllib.EABConnector"/>
<jsp:useBean id="conDoc" scope="session" class="edms.cllib.EABConnector"/>
<jsp:useBean id="conAcc" scope="session" class="edms.cllib.EABConnector"/>

<%
    String securecode = "";
    con.setRemoteServer("EAS_SERVER");
    conDoc.setRemoteServer("EAS_SERVER");
    conAcc.setRemoteServer("EAS_SERVER");
    
    if (!con.executeService("EASSYSTEM", "SECURECODE", "genSecurityCode")){
        out.println("Create Image Login Session Fail");
        return;
    }
    securecode = con.getHeader("SECURECODE");
%>
<%
	
    UserInfo userInfo = (UserInfo)session.getAttribute( "USER_INFO" );
    String strUserId = "",strUserLevel = "" , strUserLevelName = "" , strProjectCode = "" ;
    String strUserName = "";

    if( userInfo != null ){
        strUserId 	 = userInfo.getUserId();
        strUserName 	 = userInfo.getUserName();
        strUserLevel 	 = userInfo.getUserLevel();
        strUserLevelName = userInfo.getUserLevelName();
        strProjectCode 	 = userInfo.getProjectCode();		
    }
    String strUserEmail = checkNull(session.getAttribute("USER_EMAIL"));

    String strAccessDocType = (String)session.getAttribute( "ACCESS_DOC_TYPE" );
    String strUserGroup     = (String)session.getAttribute( "USER_GROUP" );
    String strSecurityFlag  = (String)session.getAttribute( "SECURITY_FLAG" );
    String strAndDocTypeCon = "";

    String strBatchNo 	 	  = checkNull( request.getParameter( "batchno" ) );
    String strDocumentRunning = checkNull( request.getParameter( "docrun" ) );

    String strMethodName   = "";
    String strErrorMessage = null;

    String strDocumentType 	= "" , strDocumentTypeName = "" , strBlob = "" , strPict = "";
    
    int intCountRecord = 0;
    int intCheckPermit = 0;

    if( strUserLevel.length() == 0 ){
            strUserLevel = checkNull( request.getParameter( "userLevel" ) );
    }
    strProjectCode = checkNull( request.getParameter( "projectcode" ) );

    String strWaterMarkFlag = "N";
    String strCurrentDate   = "";
    String strContainerType = ImageConfUtil.getInetContainerType();
    String strVersionLang   = ImageConfUtil.getVersionLang();

    if( strVersionLang.equals("thai") ) {
        strCurrentDate = getServerDateThai();
    }else{
        strCurrentDate = getServerDateEng();
    }

    con.addData("PROJECT_CODE", "String", strProjectCode);
    boolean bolnWaterMarkSuccess = con.executeService(strContainerName, "PROJECT_MANAGER", "findWaterMarkFlag");
    if(bolnWaterMarkSuccess){
            strWaterMarkFlag = con.getHeader("WATERMARK_FLAG");
    }
                                                                                                   
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>EDAS</title>
<meta http-equiv="Content-Type" content="text/html; charset=tis-620">
<link rel="shortcut icon" href="images/favicon/EDAS.ico" type="image/x-icon" />
<LINK href="css/edas.css" type="text/css" rel="stylesheet">
<LINK href="script/dtree.css" type="text/css" rel="StyleSheet">
<SCRIPT src="script/dtree_docimage.js" type="text/javaScript"></SCRIPT>
<script language="javascript" src="js/function/inet-utils.js"></script>
<script language="javascript" src="js/sccUtils.js"></script>
<script language="JavaScript" src="js/offlineUtils.js"></script>
<script language="javascript" src="js/util.js"></script>
<script language="javascript" src="js/constant.js"></script>
<script language="JavaScript" src="js/waterMark.js"></script>    
<script language="JavaScript">

var sccUtils = new SCUtils();
var offUtils = new offlineUtils();
var waterMk  = new waterMark();

var strPermission = "";

try{
	strPermission = opener.form1.PERMIT_FUNCTION.value;

}catch( e ){
}

function setMainFrameField(){
	var objMain = parent;

	if( objMain.form1 != null && objMain.form1.fieldA2 != null ){
		var strA2 , strA3;
		var strLevelFlag = form1.LEVEL_FLAG.value;

		if( strLevelFlag == "S" ){
			strA2 = form1.DOCUMENT_LEVEL.value;
			strA3 = form1.DOCUMENT_LEVEL_NAME.value;
		}else if( strLevelFlag == "U" ){
			strA2 = "<%=strUserLevel%>";
			strA3 = "<%=strUserLevelName%>";
		}else{
			strA2 = "0";
            strA3 = lc_personal;
        }
		objMain.form1.fieldA2.value = strA2;
		objMain.form1.fieldA3.value = strA3;

	}
}

function openShowView( strBatchno , strDocumentRunning, strDocumentType, strBlobId , strBlobPart ){
    initAndShow();
    setMail();
    setWaterMark();
    setOfflineDoc(strBatchno , strDocumentRunning , strDocumentType);
    retrieveImage( strBlobId , strBlobPart );
}

function initAndShow(){
    var x,y,w,h;
    var permit = set_inet_permission(strPermission);
    
    x = screen.width /2;
    y = 0;
    w = screen.width;
    h = screen.height;
    inetdocview.Close();
    inetdocview.Open();
    inetdocview.UserLevel("<%=strUserLevel%>");
    inetdocview.Resize(x, y, w, (h-30));
    inetdocview.ContainerType("<%=strContainerType%>");    
    inetdocview.SetProperty("RemoveToolBar", rem_toolbar); 
    inetdocview.SetProperty("RemoveToolBar", permit);
    inetdocview.SetProperty("UnRemoveToolBar","Menu.View.Facing");
    inetdocview.SetProperty("CloseWhenSave", "true");
}

function setMail(){
    inetdocview.SetProperty( "UnRemoveToolBar", "Save.Send Mail..." );
    inetdocview.SetProperty( "UserMail", "<%=strUserEmail%>" );
}

function setWaterMark(){
    var wm_flag = "<%=strWaterMarkFlag %>";
    var av_time = getCurrentTime();
    
    if(wm_flag != 'N'){
        waterMk.setWaterMark( wm_flag, "<%=strUserName %>", "<%=dateToDisplay(strCurrentDate, "/")%>", av_time + " ¹." );
    }
}

function setOfflineDoc(strBatchno , strDocumentRunning , strDocumentType){
    offUtils.setOfflineCtrl("<%=strProjectCode%>", "<%=strUserId%>", "<%=strCurrentDate%>", strBatchno, strDocumentRunning, strDocumentType);    
}

function retrieveImage( strBlobId, strBlobPart ){
    
    if ((strBlobId != "") && (strBlobPart != "")){
        inetdocview.Retrieve(strBlobId, strBlobPart);
    }
}

function window_onload(){
	setMainFrameField();
	window.resizeTo( 237 , 250 );
			
}

function window_onunload(){
	try{
		inetdocview.Close();
	}catch( e ){
	}
}

</script>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onload="window_onload();" onunload="window_onunload();">
<form name="form1">

  <table width="210" height="200" border="0" cellpadding="0" cellspacing="0">
    <tr>
      <td valign="top" background="images/bgleftmenu.jpg">
         <table width="210" border="0" bordercolor="white"  cellpadding="0" cellspacing="0">

          <tr >
            <td height="203" valign="top" background="images/menu_02.jpg">
            <table  border="0" align="center" cellpadding="0" cellspacing="0"
                style="table-layout:fixed;width:100%;">
          <colgroup>
              <col width="4"/>
              <col width="16"/>
              <col width="20"/>
              <col width="*"/>
          </colgroup>
          <tr>
            <td ></td>
            <td colspan="3"><br><br>
				<SCRIPT type="text/javaScript">
					d = new dTree('d');

					d.add(0,-1,'','../treedata/WebData.php?txtdocno=0&sTable=  thdoc_report &sPic=hd_tree_doc.gif&sTitle=&prePath=../Doc_report&GroupCode=1','MM','_blank');

<%
	strMethodName = "findBlobWithMaxScanNo";

	if( strAccessDocType.equals("A") ) {
		strAndDocTypeCon = " ";
	}else if( strAccessDocType.equals("L") ) {
		strAndDocTypeCon = " AND B.USER_LEVEL <= '"+ strUserLevel +"' ";
	}else {
		if( strSecurityFlag.equals("I") ) {
			strAndDocTypeCon = " AND A.DOCUMENT_TYPE IN (SELECT DOCUMENT_TYPE FROM DOCUMENT_TYPE_USER WHERE PROJECT_CODE='"+ strProjectCode +"' AND USER_ID='"+ strUserId +"')";
		}else {
			strAndDocTypeCon = " AND A.DOCUMENT_TYPE IN (SELECT DOCUMENT_TYPE FROM DOCUMENT_TYPE_GROUP WHERE PROJECT_CODE='"+ strProjectCode +"' AND USER_GROUP='"+ strUserGroup +"')";
		}
	}

	con.addData( "PROJECT_CODE" ,  	  "String" , strProjectCode );
	con.addData( "BATCH_NO" ,         "String" , strBatchNo );
	con.addData( "DOCUMENT_RUNNING" , "String" , strDocumentRunning );
	con.addData( "AND_CONDITION" ,    "String" , strAndDocTypeCon );

	boolean bolnSuccess = con.executeService( strContainerName , "DETAIL_SCAN" , strMethodName );
	
	if( bolnSuccess ){
            
		while( con.nextRecordElement() ){
			intCountRecord++;

			strDocumentType     = con.getColumn( "DOCUMENT_TYPE" );
			strDocumentTypeName = con.getColumn( "DOCUMENT_TYPE_NAME" );
			strBlob 	= con.getColumn( "BLOB" );
			strPict 	= con.getColumn( "PICT" );
				
%>
                    d.add(<%=intCountRecord%>,0,'<%=strDocumentTypeName%>(<%=strPict%>)' , "javascript:openShowView('<%=strBatchNo%>','<%=strDocumentRunning%>','<%=strDocumentType%>','<%=strBlob%>','<%=strPict%>')" );
<%
					intCheckPermit++;
		}
	}else{
		strErrorMessage = con.getRemoteErrorMesage();
	}
%>
                document.write(d);
                
<%
	if(intCheckPermit < 1){ 
%>
		showMsg( 0 , 0 , "<%=lc_user_level_access_denied%>" );
		window.close()
<%
	}
%>
			</SCRIPT></td>
          </tr>
        </table>
      </td>
      </tr>
     </table>
    </td>
   </tr>
  </table>
</form>
<iframe scrolling="no" frameborder="0" name="inetdocview" src="/jinetdocarchive/imageproxy?codetype=applet&version=15&securecode=<%=securecode%>" width="32" height="32" marginwidth="0">
</iframe>
</body>
</html>
<script type="text/javascript">
<%
	if( strErrorMessage != null && !strErrorMessage.equals( "" ) ){
%>
	showMsg( 0 , 0 , "<%=strErrorMessage.replaceAll( "\"" , "'" ).replaceAll( "\r\n" , "\"+\r\n\"" )%>" );
<%
	}
%>
</script>
