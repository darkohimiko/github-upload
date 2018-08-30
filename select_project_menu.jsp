<%@ page contentType="text/html; charset=tis-620"%>
<%@ page import="com.scc.security.UserInfo"%>
<%@ include file="inc/constant.jsp" %>
<%@ include file="inc/utils.jsp" %>
<%@ include file="inc/checkUser.jsp" %>
<jsp:useBean id="con" scope="session" class="edms.cllib.EABConnector"/>
<%
    con.setRemoteServer("EAS_SERVER");
	
    String strSourceName = (String)session.getAttribute( "SOURCE_NAME" );

    UserInfo userInfo = (UserInfo)session.getAttribute( "USER_INFO" );
    String strClassName     = "PROJECT_USER";
    String strUserId        = userInfo.getUserId();
    String strUserLevel     = userInfo.getUserLevel();
    String strUserLevelName = userInfo.getUserLevelName();
    String strSecFlag       = (String)session.getAttribute("SECURITY_FLAG");

    String strUserGroup  = "";
    String strAccessType = "";
    String strAccDocType = "";
    
    boolean bolnSuccess = false;

    con.addData( "USER_ID", "String", strUserId );
    if( strSecFlag.equals("I") ) {
        bolnSuccess = con.executeService( strContainerName, strClassName, "findApplicationByUser" );
    }else {
    	bolnSuccess = con.executeService( strContainerName, strClassName, "findApplicationByGroup" );
    }

%>
<!DOCTYPE HTML>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=TIS-620">
<link href="css/edas.css" type="text/css" rel="stylesheet">
<title>EDAS</title>
<style type="text/css">
    body, html { height: 100%; }
    #bg_allmenu { height: 100%; }
    
</style>    
<script language="JavaScript" type="text/JavaScript">
<!--

function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}
//-->
</script>
<script language="JavaScript" src="js/jquery-1.9.1.js"></script>
<script language="JavaScript" src="js/util.js"></script>
<script language="javascript">
<!--
var user_level = <%=strUserLevel%>;
var strSourceName = "<%=strSourceName%>";

function linkClick( lv_strMenu, lv_value, lv_project_name, lv_project_code, lv_userLevel, lv_Level_name ) {
    switch( lv_strMenu ) {
        case "admin_menu" :
            top.topFrame.location  = "header1.jsp" + "?project_name=" + lv_project_name+"&project_code=" + lv_project_code+"&user_level=" + lv_userLevel+"&level_name=" + lv_Level_name;
            window.location        = "admin_menu.jsp" + "?project_params=" + lv_value + "&project_name=" + lv_project_name;
            top.mainFrame.location = "system1.jsp";
            break;
        case "user_menu" :
            top.topFrame.location  = "header1.jsp" + "?project_name=" + lv_project_name+"&user_level=" + lv_userLevel+ "&level_name=" + lv_Level_name;
            window.location        = "user_menu.jsp" + "?project_params=" + lv_value +  "&project_name=" + lv_project_name;
            top.mainFrame.location = "system1.jsp";
           break;
    }
}

$(document).ready(function(){
    var admin_proj = $("#admin_project").val();
    
    if(admin_proj == "ADMIN"){
        $("#tr_admin").show();
        $("#a_admin").attr("href", $("#admin_link").val());
        td_admin.style.width = "200px";
    }
});

//-->
</script>
</head>
<body onLoad="MM_preloadImages('images/icon_admin.jpg','images/icon_personal.jpg','images/icon_cabinet.jpg')" >
<div id="screen_div" style="width:205px;height:100%;overflow-y:scroll;overflow-x:hidden;margin-right:0px;margin-bottom:0px;border:0px #ccc solid;" >
    <table width="100%" border="0" cellpadding="0" cellspacing="0" id="bg_allmenu">
        <tr>
            <td width="71" valign="top" >
                <table width="188" border="0" cellpadding="0" cellspacing="0" id="leftmenu">
                    <tr> 
                        <td width="188"><img src="images/inner_09.jpg" width="188" height="28"></td>
                    </tr>
                    <tr id="tr_admin" style="display:none">
                        <td id="td_admin" height="26" background="images/inner_11.jpg">
                            <!--  admin project -->
                            <img src="images/icon_admin.jpg" width="35" height="26" align="absmiddle">
                            <a id="a_admin" href="" class="linkBrown" class="hdmenu" ><%=lc_administrator_menu%></a>
                        </td>
                    </tr>
              			         			
<%
    String strProjectCode = "",strProjectName = "",strProjectFlag = "",strTotalSize = "0.00";
    String strUsedSize = "0.00",strAvalSize = "0.00",strDocumentAge = "",strProjctOwner="",strUserRole = "",strUserRoleName;
    String value    = "";
    String strImg   = "";
    String proj_temp = "";
    String tooltip	= "";
    String strAdminProj = "";
    String strAdminLink = "";
    
    while( con.nextRecordElement() ) {
        strProjectCode = con.getColumn( "PROJECT_CODE" );
        strProjectName = con.getColumn( "PROJECT_NAME" );
        strProjectFlag = con.getColumn( "PROJECT_FLAG" );
        strTotalSize   = con.getColumn( "TOTAL_SIZE" );
        if(strTotalSize.equals("")){
            strTotalSize = "0" ;
        }
        strUsedSize = con.getColumn( "USED_SIZE" );
        if(strUsedSize.equals("")){
            strUsedSize = "0" ;
        }
        strAvalSize = con.getColumn( "AVIAIL_SIZE" );
        if(strAvalSize.equals("")){
            strAvalSize = "0" ;
        }
        
        strDocumentAge  = con.getColumn( "DOCUMENT_AGE" );
        strProjctOwner  = con.getColumn( "PROJECT_OWNER" );
        strUserRole     = con.getColumn( "USER_ROLE" );
        strUserRoleName = con.getColumn( "ROLE_NAME" );
    	strUserGroup    = con.getColumn( "USER_GROUP" );
    	strAccessType   = con.getColumn( "ACCESS_TYPE" );
    	strAccDocType   = con.getColumn( "ACCESS_DOC_TYPE" );
        
        proj_temp = strProjectName;
        strProjectName = strProjectName.replaceAll( "&", "<Q>" );
        
        if( strSecFlag.equals("I") ) {
            strUserGroup = " ";
        }

        if( strProjectFlag.equals("1") ) {
            
            value = strProjectCode + "|"+ strProjectFlag + "|" + strProjectName + "|" +strTotalSize + "|" +strUsedSize + "|" +strAvalSize + "|" +strDocumentAge + "|" + strProjctOwner + "|" + strUserRole + "|" + strUserRoleName + "|" + strSecFlag + "|" + strUserGroup + "|" + strAccessType + "|" + strAccDocType;
            if(value.indexOf("&")!= -1){
                value = value.replaceAll("&","?");
            }
            strAdminProj = "ADMIN";
            strAdminLink = "javascript:linkClick('admin_menu','ADMIN|1|" + lc_administrator_menu + "|0|0|0|99|00000001|" + strUserRole + "|" + lc_admin + "','" + lc_administrator_menu + "','ADMIN','" + strUserLevel + "','" + strUserLevelName + "');";
   		
        }else {
            value = strProjectCode + "|"+ strProjectFlag + "|" + strProjectName + "|" +strTotalSize + "|" +strUsedSize + "|" +strAvalSize + "|" +strDocumentAge + "|" + strProjctOwner + "|" + strUserRole + "|" + strUserRoleName + "|" + strSecFlag + "|" + strUserGroup + "|" + strAccessType + "|" + strAccDocType;
            if( value.indexOf("&")!= -1 ) {
                value = value.replaceAll("&","?");
            }
            
            if( strProjectFlag.equals("3") ) {
            	strImg = "images/icon_personal.jpg";
            }else {
             	strImg = "images/icon_cabinet.jpg";
            }
             
            String proj_len = proj_temp;
            proj_len = proj_len.replaceAll( "&acute;", "&" );
            proj_len = proj_len.replaceAll( "&quot;", ";" );		
                        
            if( proj_len.length()>20 ) {
            	tooltip = proj_len.substring(0,18) + "...";
            	tooltip = tooltip.replaceAll( "&","&acute;" );
            	tooltip = tooltip.replaceAll( ";","&quot;" );
            }else{
            	tooltip = proj_temp;
            }
%>              
                    <tr> 
                        <td background="images/inner_11.jpg" >
                            <img src="<%=strImg%>" width="35" height="26" align="absmiddle" title="<%=strProjectName%>"> 
                            <a href="javascript:linkClick('user_menu','<%=value%>','<%=strProjectName%>','<%=strProjectCode%>','<%=strUserLevel%>','<%=strUserLevelName%>');" class="hdmenu" title="<%=proj_temp %>"><%=tooltip%></a>
                        </td>
                    </tr>
<%
		}
	}
%>   
<%
	if( strSecFlag.equals("G") ) {

            con.addData( "USER_ID", "String", strUserId );
            bolnSuccess = con.executeService( strContainerName, strClassName, "findPrivateApplication" );
            if(bolnSuccess){
                while( con.nextRecordElement() ) {
                    strProjectCode = con.getColumn( "PROJECT_CODE" );
                    strProjectName = con.getColumn( "PROJECT_NAME" );
                    strProjectFlag = con.getColumn( "PROJECT_FLAG" );
                    strTotalSize   = con.getColumn( "TOTAL_SIZE" );
                    if(strTotalSize.equals("")){
                        strTotalSize = "0" ;
                    }
                    strUsedSize = con.getColumn( "USED_SIZE" );
                    if(strUsedSize.equals("")){
                        strUsedSize = "0" ;
                    }
                    strAvalSize = con.getColumn( "AVIAIL_SIZE" );
                    if(strAvalSize.equals("")){
                        strAvalSize = "0" ;
                    }

                    strDocumentAge  = con.getColumn( "DOCUMENT_AGE" );
                    strProjctOwner  = con.getColumn( "PROJECT_OWNER" );
                    strUserRole     = con.getColumn( "USER_ROLE" );
                    strUserRoleName = con.getColumn( "ROLE_NAME" );
                    strAccessType   = con.getColumn( "ACCESS_TYPE" );
                    strAccDocType   = con.getColumn( "ACCESS_DOC_TYPE" );

                    proj_temp = strProjectName;
                    strProjectName = strProjectName.replaceAll( "&", "<Q>" );

                    value = strProjectCode + "|"+ strProjectFlag + "|" + strProjectName + "|" +strTotalSize + "|" +strUsedSize + "|" +strAvalSize + "|" +strDocumentAge + "|" + strProjctOwner + "|" + strUserRole + "|" + strUserRoleName + "|" + strSecFlag + "|" + strUserGroup + "|" + strAccessType + "|" + strAccDocType;
                    if( value.indexOf("&")!= -1 ) {
                        value = value.replaceAll("&","?");
                    }

                    strImg = "images/icon_personal.jpg";

                    String proj_len = proj_temp;
                    proj_len = proj_len.replaceAll( "&acute;", "&" );
                    proj_len = proj_len.replaceAll( "&quot;", ";" );		


                    if( proj_len.length()>20 ) {
                        tooltip = proj_len.substring(0,18) + "...";
                        tooltip = tooltip.replaceAll( "&","&acute;" );
                        tooltip = tooltip.replaceAll( ";","&quot;" );
                    }else{
                        tooltip = proj_temp;
                    }
%>              
                    <tr> 
                        <td background="images/inner_11.jpg" >
                            <img src="<%=strImg%>" width="35" height="26" align="absmiddle" title="<%=strProjectName%>"> 
                            <a href="javascript:linkClick('user_menu','<%=value%>','<%=strProjectName%>','<%=strProjectCode%>','<%=strUserLevel%>','<%=strUserLevelName%>');" class="hdmenu" title="<%=proj_temp %>"><%=tooltip%></a>
                        </td>
                    </tr>
<%
                }
            }
	}

%>
          
                </table>
            </td>
            <td>&nbsp;</td>
        </tr>
    </table>
</div>
<input type="hidden" id="admin_project" value="<%=strAdminProj%>">
<input type="hidden" id="admin_link" value="<%=strAdminLink%>">
</body>
</html>
