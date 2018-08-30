<%@ page contentType="text/html; charset=tis-620"%>
<%@ include file="inc/checkUser.jsp" %>
<%@ include file="inc/constant.jsp" %>
<%@ include file="inc/utils.jsp" %>
<jsp:useBean id="con" scope="session" class="edms.cllib.EABConnector"/>
<%
	con.setRemoteServer("EAS_SERVER");

	String screenname   = getField(request.getParameter("screenname"));
	String strClassName = "PROJECT_MANAGER";
	
	String strMode         = getField(request.getParameter("MODE"));
	String strPrjTotalSize = checkNull(request.getParameter("PROJ_TOTAL_SIZE"));
	String strMethod 	   = checkNull(request.getParameter("METHOD"));
	String strProjectCode  = checkNull(request.getParameter("PROJECT_CODE"));
	
	boolean bolnSuccess    = true;
	String  strTotalResult = "";
	String  strUsedResult  = "";
	String  strProjResult  = "";
	
	if( strMode == null || strMode.equals("")){
        strMode = "SEARCH";
   	}
	
	if( strMode.equals("SEARCH") ) {
        bolnSuccess = con.executeService( strContainerName, strClassName, "checkedSysTotalSize" );        
        if( bolnSuccess ) {
        	strTotalResult = String.valueOf( Double.parseDouble( con.getHeader("TOTAL_SIZE") )/1000000000 );
        }else {
        	strTotalResult = "";
        }
        
        if(strMethod.equals("EDIT")){
	        con.addData("PROJECT_CODE", "String", strProjectCode);
	        bolnSuccess = con.executeService( strContainerName, strClassName, "checkedProjectSize" );        
	        if( bolnSuccess ) {
	        	strProjResult = String.valueOf( Double.parseDouble( con.getHeader("PROJ_TOTAL_SIZE") )/1000000000 );
	        }else {
	        	strProjResult = "";
	        }
        }else{
        	strProjResult = String.valueOf(Double.parseDouble(strPrjTotalSize)*1000000000);
        }
        
        bolnSuccess = con.executeService( strContainerName, strClassName, "checkedTotalUsedSize" );
        
        if( bolnSuccess ) {
        	strUsedResult  = String.valueOf( Double.parseDouble( con.getHeader("USED_SIZE") )/1000000000 );
        }else {
        	strUsedResult  = "";
        }
        
        if(!strProjResult.equals("") && !strUsedResult.equals("")){
        	strUsedResult = String.valueOf(Double.parseDouble(strUsedResult) - Double.parseDouble(strProjResult)); 
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
	var parentChkResult    = parent.form1.chkResult;
	var parentUsedResult   = parent.form1.usedResult;
	parentChkResult.value  = "<%=strTotalResult %>";
	parentUsedResult.value = "<%=strUsedResult %>";
    parent.checkedResultSize();
}

//-->
</script>
</head>
<body onLoad="window_onload();">
<form name="form1" method="post" action="" >

</form>
</body>
</html>