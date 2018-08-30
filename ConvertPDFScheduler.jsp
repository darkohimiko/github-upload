
<%@page import="edms.cllib.EABConnector"%>
<%@ include file="inc/constant.jsp" %>
<html>
<head>
<title>ConvertToDatabase</title>
</head>
<body>

<%
	EABConnector eacon = new EABConnector();
	eacon.setRemoteServer( "EAS_SERVER" );
	
	boolean success = eacon.executeService( strContainerName , "REPORT_MANAGEMENT" , "convertToDatabase" );
	
	if( !success ){
		out.print( "<pre>" + eacon.getRemoteErrorMesage() + "</pre>" );
	}else{
		out.print( "<b>Convert To Database Started</b>" );
	}

%>

</body>
</html>