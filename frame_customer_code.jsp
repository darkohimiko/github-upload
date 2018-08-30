<%@ page contentType="text/html; charset=tis-620"%>
<%@ page import="com.scc.security.UserInfo"%>
<%@ include file="inc/checkUser.jsp" %>
<%@ include file="inc/constant.jsp" %>
<%@ include file="inc/utils.jsp" %>
<jsp:useBean id="con" scope="session" class="edms.cllib.EABConnector"/>
<%
	con.setRemoteServer("EAS_SERVER");

	UserInfo userInfo     = (UserInfo)session.getAttribute( "USER_INFO" );
	String strProjectCode = userInfo.getProjectCode();
	
	String screenname   = getField(request.getParameter("screenname"));
	String strClassName = "CUSTOMER_DATA";
	String strMode      = getField(request.getParameter("MODE"));
    String strCustCode  = getField(request.getParameter("CUST_CODE"));
    
    String strDocumentIndex2 = "";
    String strDocumentIndex3 = "";
    String strDocumentIndex4 = "";
    String strDocumentIndex5 = "";
    String strDocumentIndex6 = "";
    String strDocumentIndex7 = "";
    String strDocumentIndex8 = "";
    String strDocumentIndex9 = "";
    String strDocumentIndex11 = "";
	
	boolean bolnSuccess = false;
	String  strResult   = "";	
	
	if( strMode == null || strMode.equals("")){
        strMode = "SEARCH";
   	}
	
	if( strMode.equals("SEARCH") ) {
        con.addData( "DOCUMENT_INDEX1", "String", strCustCode );
        bolnSuccess = con.executeService( strContainerName, strClassName, "findByCustCode" );
        if( bolnSuccess ) {
        	strDocumentIndex2 = checkNull( con.getHeader("DOCUMENT_INDEX2") );
        	strDocumentIndex3 = checkNull( con.getHeader("DOCUMENT_INDEX3") );
        	strDocumentIndex4 = checkNull( con.getHeader("DOCUMENT_INDEX4") );
        	strDocumentIndex5 = checkNull( con.getHeader("DOCUMENT_INDEX5") );
        	strDocumentIndex6 = checkNull( con.getHeader("DOCUMENT_INDEX6") );
        	strDocumentIndex7 = checkNull( con.getHeader("DOCUMENT_INDEX7") );
        	strDocumentIndex8 = checkNull( con.getHeader("DOCUMENT_INDEX8") );
        	strDocumentIndex9 = checkNull( con.getHeader("DOCUMENT_INDEX9") );
        	strDocumentIndex11 = checkNull( con.getHeader("DOCUMENT_INDEX11") );
        }
    }
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=windows-874">
<script language="JavaScript" src="js/sccUtils.js"></script>
<script language="JavaScript" src="js/util.js"></script>
<script language="JavaScript" src="js/constant.js"></script>
<script language="JavaScript" src="js/label.js"></script>
<script language="JavaScript" type="text/javascript">

function window_onload() {
	parent.form1.DOCUMENT_INDEX2.value = "<%=strDocumentIndex2 %>";
	parent.form1.DOCUMENT_INDEX3.value = "<%=strDocumentIndex3 %>";
	parent.form1.DOCUMENT_INDEX4.value = "<%=strDocumentIndex4 %>";
	parent.form1.DOCUMENT_INDEX5.value = "<%=strDocumentIndex5 %>";
	parent.form1.DOCUMENT_INDEX6.value = "<%=strDocumentIndex6 %>";
	parent.form1.DOCUMENT_INDEX7.value = "<%=strDocumentIndex7 %>";
	parent.form1.DOCUMENT_INDEX8.value = "<%=strDocumentIndex8 %>";
	parent.form1.DOCUMENT_INDEX9.value = "<%=strDocumentIndex9 %>";
	parent.form1.DOCUMENT_INDEX11.value = "<%=strDocumentIndex11 %>";
	//if( strUserName != "" ) {
    //	parent.afterAuthenPass();
    //}
    
    //eval( "opener." + strCallFunc + "();" );
}

//-->
</script>
</head>
<body onLoad="window_onload();">
<form name="form1" method="post" action="" >

</form>
</body>
</html>