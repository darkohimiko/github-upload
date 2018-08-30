<%@ page contentType="text/html; charset=tis-620"%>
<%@ page import="com.scc.security.UserInfo"%>
<%@ include file="constant.jsp" %>
<%@ include file="utils.jsp" %>
<jsp:useBean id="con" scope="session" class="edms.cllib.EABConnector"/>
<%
	con.setRemoteServer("EAS_SERVER");

	UserInfo userInfo = (UserInfo)session.getAttribute( "USER_INFO" );
	String strUserLevel	= userInfo.getUserLevel();

    String strBlobID = "" , strBlobPart = "", strDocLevel = "";

	String strErrorCode = null , strErrorMessage = null;

	String strProjectCode 	   = checkNull( request.getParameter( "PROJECT_CODE" ) );
	String strBatchNo          = checkNull( request.getParameter( "BATCH_NO" ) );
	String strDocumentRunning  = checkNull( request.getParameter( "DOCUMENT_RUNNING" ) );
	String strAndAccDocTypeCon = checkNull( request.getParameter( "DOCUMENT_TYPE_CONDITION" ) );
	String strDocumentType	   = "";

	int intTotalRecord = 0;


	if( strProjectCode.length() > 0 ){

		boolean bolnSuccess;

		con.addData( "PROJECT_CODE",	        "String", strProjectCode );
		con.addData( "BATCH_NO",		        "String", strBatchNo );
		con.addData( "DOCUMENT_RUNNING",        "String", strDocumentRunning );
		con.addData( "DOCUMENT_TYPE_CONDITION", "String", strAndAccDocTypeCon );
		con.addData( "GROUP_BY", 		        "String", "GROUP BY DOCUMENT_TYPE" );

		bolnSuccess = con.executeService( strContainerName , "DETAIL_SCAN" , "getDocument_type" );

		if( !bolnSuccess ){
			strErrorCode = con.getRemoteErrorCode();
			strErrorMessage = con.getRemoteErrorMesage();
		}else{
			intTotalRecord = con.getRecordTotal();
			while( con.nextRecordElement() ){
				strDocumentType = con.getColumn( "DOCUMENT_TYPE" );
			}
		}

		con.addData( "PROJECT_CODE",	"String", strProjectCode );
		con.addData( "DOCUMENT_TYPE",	"String", strDocumentType );

		bolnSuccess = con.executeService( strContainerName , "DETAIL_SCAN" , "getDocumentLevel" );

		if( !bolnSuccess ){
// 			strErrorCode = con.getRemoteErrorCode();
// 			strErrorMessage = con.getRemoteErrorMesage();
		}else{
			while( con.nextRecordElement() ){
				strDocLevel = con.getColumn( "USER_LEVEL" );
			}
		}
		
		if(strDocLevel.equals("")){
			strDocLevel = "0";
		}

		if( intTotalRecord <= 1 ){
			con.addData( "PROJECT_CODE" ,           "String" , strProjectCode );
			con.addData( "BATCH_NO" ,               "String" , strBatchNo );
			con.addData( "DOCUMENT_RUNNING" ,       "String" , strDocumentRunning );
			con.addData( "DOCUMENT_TYPE_CONDITION", "String", strAndAccDocTypeCon );
			con.addData( "DOCUMENT_TYPE",           "String" , strDocumentType );

			bolnSuccess = con.executeService( strContainerName , "DETAIL_SCAN" , "getBlobPict" );

			if( !bolnSuccess ){
				strErrorCode = con.getRemoteErrorCode();
				strErrorMessage = con.getRemoteErrorMesage();
			}else{
				while( con.nextRecordElement() ){
					strBlobID 	= con.getColumn( "BLOB" );
					strBlobPart = con.getColumn( "PICT" );
					//strDocLevel = con.getColumn( "DOCUMENT_LEVEL" );
				}
			}

		}
	}

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>EDAS</title>
<meta http-equiv="Content-Type" content="text/html; charset=tis-620">
<LINK href="../css/edas.css" type="text/css" rel="stylesheet">
<script language="JavaScript">

function window_onunload(){
	try{
		inetdocview.Close();
	}catch( e ){
	}
}

</script>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onunload="window_onunload();">
<form name="form1" method="post" action="openClip.jsp">
  <input type="hidden" name="PROJECT_CODE" 		      value="">
  <input type="hidden" name="BATCH_NO" 			      value="">
  <input type="hidden" name="DOCUMENT_RUNNING" 	      value="">
  <input type="hidden" name="DOCUMENT_TYPE_CONDITION" value="">
</form>
</body>
</html>
<script type="text/javascript">

<%
	if( strErrorMessage != null && !strErrorMessage.equals( "" ) ){
%>
		alert( "<%=lc_user_level_access_denied%>" );
	
<%
	}else{
		if( intTotalRecord > 1 ){
%>
			parent.openDetailScan( "<%=strProjectCode%>" , "<%=strBatchNo%>" , "<%=strDocumentRunning%>" );
<%
		}else if( strBlobID.length() > 0 ){
			if(Integer.parseInt(strUserLevel) >= Integer.parseInt(strDocLevel)){
%>
				if( parent.formORABCS ){
					parent.formORABCS.DOCUMENT_TYPE.value = "<%=strDocumentType%>";
				}
				parent.openShowView( "<%=strBatchNo%>" , "<%=strDocumentRunning%>" , "<%=strDocumentType%>" , "<%=strBlobID%>" , "<%=strBlobPart%>" );
<%
			}else{
%>			
				alert( "<%=lc_user_level_access_denied%>.." );
<%			}
		}
	}
%>
</script>