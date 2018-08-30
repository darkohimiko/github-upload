<%@page import="com.scc.edms.conf.ImageConfUtil"%>
<%@ page contentType="text/html; charset=tis-620"%>
<%@ include file="inc/checkUser.jsp" %>
<%@ include file="inc/constant.jsp" %>
<%@ include file="inc/utils.jsp" %>
<jsp:useBean id="con" scope="session" class="edms.cllib.EABConnector"/>
<%
	con.setRemoteServer("EAS_SERVER");
		
	String strClassName    = "FIELD_MANAGER";
	String strMode         = getField(request.getParameter("MODE"));
        String strCurrentDate  = "";
        String strSubCurDate   = "";
        String strVersionLang  = ImageConfUtil.getVersionLang();

        if( strVersionLang.equals("thai") ) {
            strCurrentDate = getServerDateThai();
        }else{
            strCurrentDate = getServerDateEng();
        }
    
	boolean bolnSuccess = false;
	String  strCurYear  = strCurrentDate.substring( 0, 4 );
	String  strResult   = "";
	
	if( strMode == null || strMode.equals("")){
        strMode = "SEARCH";
   	}
	
	if( strMode.equals("SEARCH") ) {
		con.addData( "CUR_YEAR", strCurYear );
        bolnSuccess = con.executeService( strContainerName, strClassName, "getMaxBatchNoMediadept" );        
        if( bolnSuccess ) {
        	strResult = con.getHeader( "MAX" );
        	if( strResult == null || strResult.equals("") ) {
        		strResult = "0001";
        	}else {
        		strResult = "000" + strResult;
        		strResult = strResult.substring( strResult.length() - 4, strResult.length() );
        	}
        }else {
        	strResult = "0000";
        }
    }
	strSubCurDate = strCurrentDate.substring( 0, 6 );
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
    parent.displayCodeValue( "<%=strResult %>", "<%=strSubCurDate %>" );
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