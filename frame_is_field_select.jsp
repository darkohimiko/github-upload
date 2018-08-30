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
	
	String screenname      = getField(request.getParameter("screenname"));
	String strClassName    = "FIELD_MANAGER";
	String strMode         = getField(request.getParameter("MODE"));
    String strIndexCodeKey = getField(request.getParameter("INDEX_CODE"));
    String strIndexTypeKey = getField(request.getParameter("INDEX_TYPE"));
	String strResult       = "";
	
	boolean bolnSuccess = true;
	
	if( strMode == null || strMode.equals("")){
        strMode = "SEARCH";
   	}
	
	if( strMode.equals("SEARCH") ) {
        con.addData( "PROJECT_CODE", "String", strProjectCode );
        con.addData( "INDEX_CODE",   "String", strIndexCodeKey );
        con.addData( "INDEX_TYPE",   "String", strIndexTypeKey );
        bolnSuccess = con.executeService( strContainerName, strClassName, "checkedFieldSelect" );
        
        if( bolnSuccess ) {
        	strResult = "true";
        }else {
        	strResult = "false";
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
	//var parentChkResult   = parent.document.all( chkResult );
	//var parentChkResult   = parent.form1.chkResult;
	//parentChkResult.value = "<%=strResult %>";
    parent.afterCheckSelect( "<%=strResult %>" );
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