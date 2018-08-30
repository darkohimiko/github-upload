<%
    String strServerPath = request.getServletPath();

    if( session.getAttribute( "USER_INFO" ) == null ){
        if( strServerPath.indexOf( "/inc/" ) != -1 || strServerPath.indexOf( "/process/" ) != -1 ){
            response.sendRedirect( "session_timeout.jsp?" );
        }else{
            response.sendRedirect( "inc/session_timeout.jsp" );
        }
        return;
    }
%>