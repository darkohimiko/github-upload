<%@ page contentType="text/html; charset=tis-620"%>
<%@ include file="inc/constant.jsp" %>
<%@page import="edms.cllib.EABConnector"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%
	EABConnector con = new EABConnector();
	con.setRemoteServer("EAS_SERVER");
	
	boolean bolnSuccess = con.executeService(strContainerName , "PURGE_DOCUMENT", "startProcess");
	if(bolnSuccess){
		out.println("purge document success");
	}else{
		out.println("error : " + con.getRemoteErrorMesage());		
	}


%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Test Delete Blob</title>
</head>
<body>

</body>
</html>