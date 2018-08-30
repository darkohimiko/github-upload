<%@ page contentType="text/html; charset=tis-620"%>
<%@ page import="com.scc.security.UserInfo,java.util.Random"%>
<%@ include file="inc/constant.jsp" %>
<%@ include file="inc/utils.jsp" %>
<%
    UserInfo userInfo = (UserInfo)session.getAttribute( "USER_INFO" );
	
	if( session.getAttribute( "USER_INFO" ) == null ){
	        response.sendRedirect( "inc/session_timeout.jsp" );
	    return;
	}


    String strOldProjectFlag = "";
    String strGetUserId = "" , strGetUserName = "" , strGetUserOrg = "" , strGetUserLevel = "" , strGetOrgName = "";
    String strSourceName = "";

    if( session.getAttribute( "SOURCE_NAME" ) == null ){
        strSourceName = checkNull( request.getParameter("sourcename"));
        session.setAttribute( "SOURCE_NAME" , strSourceName );
    }

    if( userInfo != null ){        
        strOldProjectFlag = userInfo.getProjectFlag();
    }else{
        userInfo = new UserInfo();
        
        strOldProjectFlag = getField( request.getParameter("projectflag"));

        strGetUserId = checkNull(request.getParameter("userid"));
        strGetUserName = getField( request.getParameter("username"));
        strGetUserOrg = checkNull( request.getParameter("userorg"));
        strGetUserLevel = checkNull( request.getParameter("userlevel"));
        strGetOrgName = getField( request.getParameter("orgname"));

        strSourceName = checkNull( request.getParameter("sourcename"));

        userInfo.setUserId( strGetUserId );
        userInfo.setUserName( strGetUserName );
        userInfo.setUserOrg( strGetUserOrg );
        userInfo.setUserLevel( strGetUserLevel );
        userInfo.setUserOrgName( strGetOrgName );

        session.setAttribute( "USER_INFO" , userInfo );

        session.setAttribute( "SOURCE_NAME" , strSourceName );
    }


    String strHeader = getField(request.getParameter("header"));
    String strDetail = getField(request.getParameter("detail"));
    String strAdmin =  getField(request.getParameter("ADMIN"));
    String value =  getField(request.getParameter("value"));
    String strPage = "system1.jsp";

    if(!strOldProjectFlag.equals("")){
        if(strOldProjectFlag.equals("1")){
             strPage  = "system1.jsp";
        }else{
             strPage  = "system.jsp";
        }


    }
//
    Random ran = new Random();
    String randomNo=String.valueOf(ran.nextLong());
    strHeader += "?randomNo="+ randomNo;
    strDetail += "?randomNo="+ randomNo;

    String[] arrdata;
    if(strAdmin.equals("T")){
        if(!value.equals("") ){
             arrdata= split(value,"@");
             String strProjectCode =  arrdata[0];
             String strProjectName =  arrdata[1];
             strProjectName = new String(strProjectName.getBytes("ISO8859_1"),"TIS620");
             String strProjectUser =  arrdata[2];
             String strProjectFlag=  arrdata[3];
             String strUserName =  arrdata[4];
             strUserName = new String(strUserName.getBytes("ISO8859_1"),"TIS620");
             String strUserPosition =  arrdata[5];
             strUserPosition = new String(strUserPosition.getBytes("ISO8859_1"),"TIS620");
             String strUserOrg =  arrdata[6];
             String strUserOrgName =  arrdata[7];
             strUserOrgName = new String(strUserOrgName.getBytes("ISO8859_1"),"TIS620");
             String strUserLevel = "98";
             userInfo.setProjectCode(strProjectCode);
             userInfo.setProjectName(strProjectName);
             userInfo.setUserId(strProjectUser);
             userInfo.setProjectFlag(strProjectFlag);
             userInfo.setUserName(strUserName);
             userInfo.setUserPosition(strUserPosition);
             userInfo.setUserOrg(strUserOrg);
             userInfo.setUserOrgName(strUserOrgName);
             userInfo.setUserLevel(strUserLevel);
        }
    }
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title><%=lc_system_name%> <%=lc_site_name%></title>
<link rel="shortcut icon" href="images/favicon/EDAS.ico" type="image/x-icon" />
<meta http-equiv="Content-Type" content="text/html; charset=tis-620">
<link href="css/edas.css" type="text/css" rel="stylesheet">
</head>
<frameset rows="99,*" cols="*" frameborder="NO" border="0" framespacing="0">
  <frame src='<%=strHeader%>' name="topFrame" scrolling="NO" noresize >
  <frameset cols="222,*" align = "center" frameborder="NO" border="0" framespacing="0">
    <frame src='<%=strDetail%>' name="leftFrame" scrolling="NO" noresize>
    <frame src='<%=strPage%>' name="mainFrame" scrolling="no" noresize>
  </frameset>
</frameset>
<noframes><body>
</body></noframes>
</html>

