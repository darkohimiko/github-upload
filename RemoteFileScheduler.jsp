
<%@page import="edms.cllib.EABConnector"%>
<%@ include file="inc/constant.jsp" %>
<html>
<head>
<title>GetRemotFile</title>
</head>
<body>

<%
	EABConnector eacon = new EABConnector();
	eacon.setRemoteServer( "EAS_SERVER" );
	
	boolean success = eacon.executeService( strContainerName , "REPORT_MANAGEMENT" , "getRemoteFile" );
	
	if( !success ){
		out.print( "<pre>" + eacon.getRemoteErrorMesage() + "</pre>" );
	}else{
		out.print( "<b>Get Remote File Started</b>" );
	}
	
%>

</body>
</html>