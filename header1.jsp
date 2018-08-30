<%@ page import="com.scc.security.UserInfo"%>
<%@ include file="inc/checkUser.jsp" %>
<%@ include file="inc/constant.jsp" %>
<%@ include file="inc/label.jsp" %>
<%@ include file="inc/utils.jsp" %>
<%@ page contentType="text/html; charset=tis-620"%>
<%
    UserInfo userInfo = (UserInfo)session.getAttribute( "USER_INFO" );
    String strUserId        = userInfo.getUserId();
    String strUserName      = userInfo.getUserName();
    String strUserOrgName   = userInfo.getUserOrgName();
    String strUserLevel     = userInfo.getUserLevel();
    String strUserLevelName = userInfo.getUserLevelName();

 //   String strProjectCode = getField(request.getParameter("project_code"));
 //   String strProjectName = getField(request.getParameter("project_name"));

//    if(strProjectName.equals("")){
//        strProjectName  = userInfo.getProjectName();
//        strProjectCode  = userInfo.getProjectCode();
//    }else{
//        userInfo.setProjectName(strProjectName);
//        userInfo.setProjectCode(strProjectCode);
 //   }


%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>EDAS </title>
<meta http-equiv="Content-Type" content="text/html; charset=tis-620">
<meta http-equiv="Pragma" content="no-cache">
<link href="css/edas.css" type="text/css" rel="stylesheet">
<style type="text/css">
    .bg_tab {
        background-image: url("images/inner_07.jpg");
        background-repeat: repeat-x;
            
    }
</style>
<script language="JavaScript" src="js/sccUtils.js"></script>
<script language="JavaScript" src="js/util.js"></script>
<script language="javascript" type="text/javascript">
<!--
function logout() {
    var lo_new = window.open( "init","" );
    top.opener = "";
    top.close();
}

//-->
</script>
</head>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<form action="" method="post" name="form1">
    <table width="100%" height="99" border="0" cellpadding="0" cellspacing="0">
        <tr> 
            <td height="62" background="images/inner_03.jpg">
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                        <td><img src="images/inner_01.jpg" height="62"></td>
                        <td valign="bottom" align="right" width="240"><div align="right">
                            <a href="javascript:logout()"><img src="images/exit.jpg" width="72" height="62" border="0"></a></div></td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr> 
            <td>
                <table width="100%" border="0" cellpadding="0" cellspacing="0">
                    <tr valign="top" class="bg_tab"> 
                        <td width="12%" ><img src="images/inner_05.jpg" width="223" height="37"></td>
                        <td width="*" >
                            <span class="navbar_02">(<%=strUserOrgName%>)</span>
                            <span class="navbar_01"><%=lb_user_name %> : <%=strUserName %>
                          <%	if(!strUserLevelName.equals("")){ %>
                           (<%=strUserId%> / <%=strUserLevel%>)</span>
                          <%	} %> 
                        </td>
                        <td width="20%" align="right" >
                            <span class="navbar_01" ><%=dateToDisplay(getTodayDate())%></span>&nbsp;&nbsp;&nbsp;</td>                    
                    </tr>
                </table>
            </td>
        </tr>
    </table>
<iframe name="ichkout" id="ichkout" width="0" height="0" style="visibility:hidden"></iframe>
</form>
</body>
</html>
