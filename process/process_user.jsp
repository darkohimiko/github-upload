<%@page import="com.scc.edms.conf.ImageConfUtil"%>
<%@ page contentType="text/html; charset=tis-620"%>
<%@ page import="com.scc.security.UserInfo"%>
<%@ page import="java.net.URLEncoder"%>
<%@ include file="../inc/constant.jsp" %>
<%@ include file="../inc/utils.jsp" %>
<jsp:useBean id="con" scope="session" class="edms.cllib.EABConnector"/>
<jsp:useBean id="con1" scope="session" class="edms.cllib.EABConnector"/>
<jsp:useBean id="con2" scope="session" class="edms.cllib.EABConnector"/>
<%
	con.setRemoteServer( "EAS_SERVER" );
	con1.setRemoteServer( "EAS_SERVER" );
	con2.setRemoteServer( "EAS_SERVER" );
		
    String  strEmailServer   = "";
    String  strEmailUser     = "";
    String  strEmailPassword = "";
    String  strExpire_Days   = "";
    String  strWarning_Days  = "";
    String  strSite          = "";
    String  strSiteName      = "";
//    String  strAdFlag        = getAdFlag();
    String  strAdFlag        = ImageConfUtil.getLoginAD();
    boolean bolnSuccess      = true;

    String strUserId     = request.getParameter( "USER_ID" );
    String strPassword   = request.getParameter( "PASSWORD" );
    String strUserName   = "";
    String strUserSname  = "";
    String strFullName   = "";
    String strUserTitle  = "";
    String strUserEMail  = "";
    String strSecFlag    = "";
    String strChangeDate = "";
    String strUserOrg    = "";
    String strOrgName    = "";
    String strUserIp     = request.getRemoteAddr();
    String strIpAddress  = "";
    String  strImportServer     = "";
    String  strImportWebServer  = "";
    String  strImportServerPort = "";
    String  strImportWebPort    = "";

    String strMethod      = request.getParameter( "METHOD" );
    String strOldPassword = request.getParameter( "OLD_PASSWORD" );
    String strNewPassword = request.getParameter( "NEW_PASSWORD" );
    
    if( strMethod == null ){
        response.sendRedirect( "../index.jsp" );
        return;
    }
    
    if( strMethod.equals("LOGIN") ) {
    	if( strAdFlag.equals("on") && !strUserId.equals("edaadm") ) {
    		con.addData( "USER_ID",  "String", strUserId );
             con.addData( "PASSWORD", "String", strPassword );
    		bolnSuccess = con.executeService( strContainerName, "JLDAP", "authenUserFromAd" );
    		if( !bolnSuccess ) {
                response.sendRedirect( "../index.jsp?ERROR_MESSAGE=NOT_FOUND_USER");
                return;
            }
    		
    		con.addData( "USER_ID",  "String", strUserId );
            con.addData( "PASSWORD", "String", strPassword );
    		bolnSuccess = con.executeService( strContainerName, "USER_PROFILE", "updatePasswordUserProfile" );
    		if( !bolnSuccess ) {
    			response.sendRedirect( "../index.jsp" );
                return;
            }
    	}
        bolnSuccess = con.executeService( strContainerName, "SYSTEM_CONFIG", "findSystemConfig" );
        if( !bolnSuccess ) {
            response.sendRedirect( "../index.jsp?ERROR_MESSAGE=" + URLEncoder.encode(con.getRemoteErrorMesage() , "TIS-620"));
        }else {
            while( con.nextRecordElement() ) {
                strExpire_Days   = con.getColumn("USER_EXPIRE_DAYS");
                strWarning_Days  = con.getColumn("USER_WARNING_DAYS");
                strSite          = con.getColumn("SITE");
                strSiteName      = con.getColumn("SITE_NAME");
                strEmailServer   = con.getColumn("EMAIL_SERVER");
                strEmailUser     = con.getColumn("EMAIL_USER");
                strEmailPassword = con.getColumn("EMAIL_PASSWORD");
                strImportServer  = con.getColumn("IMPORT_SERVER");
                strImportWebServer  = con.getColumn("IMPORT_WEB_SERVER");
                strImportServerPort = con.getColumn("IMPORT_SERVER_PORT");
                strImportWebPort    = con.getColumn("IMPORT_WEB_PORT");
            }
            
            if( strExpire_Days == null ) {
                strExpire_Days = "0";
            }

            if( strWarning_Days == null ) {
                strWarning_Days = "0";
            }
            
            con1.addData( "USER_ID",  "String", strUserId );
        	con1.addData( "AD_FLAG", "String", strAdFlag );
            if( !strAdFlag.equals("on") && !strUserId.equals("edaadm")) {
            	con1.addData( "PASSWORD", "String", strPassword );
            }
            
            if( !strUserId.equals("GUEST") ) {
            	bolnSuccess = con1.executeService( strContainerName, "USER_PROFILE", "findUser" );
            }else {
            	bolnSuccess = con1.executeService( strContainerName, "USER_PROFILE", "findGuestUserProfile" );
            }
            if( !bolnSuccess ) {
                response.sendRedirect( "../index.jsp?ERROR_MESSAGE=NOT_FOUND_USER");
                return;
            }else {
            	if( !strUserId.equals("GUEST") ) {
                	strIpAddress = con1.getHeader( "IP_ADDRESS" );
                	if( !strIpAddress.equals("") ) {
                		if( strIpAddress.indexOf(strUserIp) == -1 ) {
                			response.sendRedirect( "../index.jsp?ERROR_MESSAGE=CANNOT_LOGIN");
                            return;
                		}
                	}
                }
                UserInfo userInfo = new UserInfo();
                userInfo.setSite( strSite );
                userInfo.setSiteName( strSiteName );
                
                while( con1.nextRecordElement() ) {
                    userInfo.setUserId(        con1.getColumn( "USER_ID"       ) );
                    userInfo.setUserPosition(  con1.getColumn( "USER_POSITION" ) );
                    userInfo.setUserOrg(       con1.getColumn( "USER_ORG"      ) );
                    userInfo.setUserOrgName(   con1.getColumn( "ORG_NAME"      ) );
                    userInfo.setChangeDate(    con1.getColumn( "CHANGE_DATE"   ) );
                    userInfo.setUserLevel(     con1.getColumn( "USER_LEVEL"    ) );
                    userInfo.setUserLevelName( con1.getColumn( "LEVEL_NAME"    ) );
                    
                    strChangeDate = con1.getColumn( "CHANGE_DATE" );
                    strUserName   = con1.getColumn( "USER_NAME"   );
                    strUserSname  = con1.getColumn( "USER_SNAME"  );
                    strUserTitle  = con1.getColumn( "TITLE_NAME"  );
                    strUserEMail  = con1.getColumn( "USER_EMAIL"  );
                    strSecFlag    = con1.getColumn( "SECURITY_FLAG" );
                    
                    if( !strUserId.equals("GUEST") ) {
	                    strFullName = strUserName + " " + strUserSname;
	                    userInfo.setUserName( strFullName );
                    }else {
                    	userInfo.setUserName( strUserName );
                    }
                }

                if( !strAdFlag.equals("on") && !strUserId.equals("edaadm")) {
	                if( Integer.parseInt(strExpire_Days) > 0 ) { //10
	                    int    warning_days = 0;
	                    int    active_days  = 0;
	                    String strEndDate   = "";
	                    String strVersionLang  = ImageConfUtil.getVersionLang();

	                    	if( strVersionLang.equals("thai") ) {
                                    strEndDate = getServerDateThai();
	            		}else {
                                    strEndDate = getServerDateEng();
	            		}
	
	                    //active_days  = calculaNumDate( strChangeDate , getServerDateThai() );
	                    active_days  = calculaNumDate( strChangeDate , strEndDate );
	                    warning_days = Integer.parseInt(strExpire_Days) - Integer.parseInt(strWarning_Days);
	
	                    if( !(active_days < warning_days) ) {
	                    	if( active_days < Integer.parseInt(strExpire_Days) ) {
	                    		int remain_days = Integer.parseInt(strExpire_Days) - active_days;
	                            
	                            session.setAttribute( "ERROR_CODE" , "" );
	                            session.setAttribute( "ALERT_MESSAGE" , lc_password_expired_in + remain_days + lc_day + lc_please_change_password );
	                            session.setAttribute( "REDIRECT_PAGE" , "../change_password.jsp" );
	                            response.sendRedirect( "../inc/warning.jsp" );
	                            return;
	                        }
	                        session.setAttribute( "ERROR_CODE" , "" );
	                        session.setAttribute( "ALERT_MESSAGE", lc_confirm_message + lc_please_change_password);
	                        session.setAttribute( "REDIRECT_PAGE" , "../change_password.jsp" );
	                        response.sendRedirect( "../inc/warning.jsp" );
	                    	return;
	                	}
					}
                }

                session.setAttribute( "USER_ID",        strUserId );
                session.setAttribute( "USER_NAME",      strUserName );
                session.setAttribute( "USER_SNAME",     strUserSname );
                session.setAttribute( "USER_TITLE",     strUserTitle );
                session.setAttribute( "USER_ORG",       strUserOrg );
                session.setAttribute( "ORG_NAME",       strOrgName );
                session.setAttribute( "USER_EMAIL",     strUserEMail );
                session.setAttribute( "EMAIL_SERVER",   strEmailServer );
                session.setAttribute( "EMAIL_USER",     strEmailUser );
                session.setAttribute( "EMAIL_PASSWORD", strEmailPassword );
                session.setAttribute( "SECURITY_FLAG",  strSecFlag );
                session.setAttribute( "IMPORT_SERVER",   strImportServer );
                session.setAttribute( "IMPORT_SERVER_PORT", strImportServerPort );
                session.setAttribute( "IMPORT_WEB_SERVER",  strImportWebServer );
                session.setAttribute( "IMPORT_WEB_PORT",    strImportWebPort );
                session.setAttribute( "USER_INFO",      userInfo );
                
                response.sendRedirect( "../main.jsp" );
            }
        }
    }else if( strMethod.equals("CHANGE_PWD") ) {
        con.addData( "USER_ID",      "String", strUserId );
        con.addData( "OLD_PASSWORD", "String", strOldPassword );
        con.addData( "NEW_PASSWORD", "String", strNewPassword );

        bolnSuccess = con.executeService( strContainerName, "USER_PROFILE", "changePassword" );
        if( !bolnSuccess ) {
        	String strErrCode = con.getRemoteErrorCode();
         //   session.setAttribute( "ERROR_CODE" , con.getRemoteErrorCode() );
         //   session.setAttribute( "ERROR_MESSAGE" , lc_user_cannot_update );
         //   session.setAttribute( "REDIRECT_PAGE" , "../change_password.jsp" );
         //   response.sendRedirect( "../inc/error.jsp");
         	if( strErrCode.equals("ERR00008") ) {
				response.sendRedirect( "../change_password.jsp?ERROR_MESSAGE=USER_PASS_NOT_CORRECT");
         	}else {
        		response.sendRedirect( "../change_password.jsp?ERROR_MESSAGE=USER_NOT_UPDATE");
         	}
        }else {
        	UserInfo userInfo = new UserInfo();
			response.sendRedirect( "../change_password.jsp?SUCCESS_MESSAGE=CHANGE_SUCCESS");
        }

    }
%>

