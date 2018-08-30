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
	
	String screenname     = getField(request.getParameter("screenname"));
	String strClassName   = "JLDAP";
	String strClassName2  = "ZOOM_TABLE_MANAGER";
	String strMode        = getField(request.getParameter("MODE"));
    String strUserIdKey   = getField(request.getParameter("USER_ID_AD"));
    String strPasswordKey = getField(request.getParameter("PASSWORD_AD"));
    String strAdId        = "uobkh1";
    String strAdPass      = "u0bkh1@Summit";
    
    String strAdUserName    = "";
    String strAdUserSname   = "";
    String strAdUserOrg     = "";
    String strAdUserOrgName = "";
    String strAdEmail       = "";
    String strAdFlag        = "";
	
	boolean bolnSuccess     = false;
	String  strResult       = "";	
	
	if( strMode == null || strMode.equals("")){
        strMode = "SEARCH";
   	}
	
	if( strMode.equals("SEARCH") ) {
        con.addData( "USER_ID",    "String", strAdId );
        con.addData( "PASSWORD",   "String", strAdPass );
        con.addData( "USER_ID_AD", "String", strUserIdKey );
        bolnSuccess = con.executeService( strContainerName, strClassName, "getDetailFromAd" );
        if( bolnSuccess ) {
        	strAdUserName    = getField( con.getHeader("USER_NAME") );
        	strAdUserSname   = getField( con.getHeader("USER_SNAME") );
        	strAdUserOrgName = getField( con.getHeader("USER_ORG_NAME") );
        	strAdEmail       = getField( con.getHeader("USER_EMAIL") );
        	strAdFlag        = getField( con.getHeader("FLAG_AD") );
        }
        
        con.addData( "ORG_NAME", "String", strAdUserOrgName );
        bolnSuccess = con.executeService( strContainerName, strClassName2, "getOrgCode" );
        if( bolnSuccess ) {
        	strAdUserOrg = getField( con.getHeader("ORG") );
        }else {
        	strAdUserOrg = "";
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
	//var strUserName = "<%=strAdUserName %>";
	var strFlag     = "<%=strAdFlag %>";
	
	//parent.form1.txtUserName.value  = "<%=strAdUserName %>";
	//parent.form1.txtUserSname.value = "<%=strAdUserSname %>";
	//parent.form1.txtOrgCode.value   = "<%=strAdUserOrg %>";
	//parent.form1.txtOrgName.value   = "<%=strAdUserOrgName %>";
	//parent.form1.txtOrgCode.value   = "00000001";
	//parent.form1.txtOrgName.value   = "ADMIN";
	//parent.form1.txtUserEmail.value = "<%=strAdEmail %>";
	//if( strUserName != "" ) {
    //	parent.afterAuthenPass();
    //}
    if( strFlag == "true" ) {
    	parent.afterAuthenPass();
    }
    
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