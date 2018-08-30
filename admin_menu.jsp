<%@ page import="com.scc.security.UserInfo"%>
<%@ include file="inc/checkUser.jsp" %>
<%@ include file="inc/constant.jsp" %>
<%@ include file="inc/utils.jsp" %>
<jsp:useBean id="con" scope="session" class="edms.cllib.EABConnector"/>
<jsp:useBean id="con2" scope="session" class="edms.cllib.EABConnector"/>
<%
	con.setRemoteServer( "EAS_SERVER" );
	con2.setRemoteServer( "EAS_SERVER" );

    String strClassName	= "ROLE_APPLICATION";

    UserInfo userInfo = (UserInfo)session.getAttribute( "USER_INFO" );
    
    String strProjectFlag  = "";
    String strUserRole     = "";
    String strProjectCode  = "";
    String strProjectName  = "";
    String strTotalSize    = "";
    String strUsedSize     = "";
    String strAvalSize     = "";
    String strDocumentAge  = "";
    String strProjctOwner  = "";
    String strUserRoleName = "";
    String strSecFlag      = "";
    String strUserGroup    = "";
    String strAccessType   = "";
    String strAccDocType   = "";
    
    boolean bolSuccess	= false;
    boolean bolSuccess2	= false;

    String[] arrdata;
    String value           = getField(request.getParameter("project_params"));
    String strProject_name = getField(request.getParameter("project_name"));

    if( strProject_name.equals("") ) {
        strProject_name = userInfo.getProjectName();
    }

    if( !value.equals("") ) {
    	int i = 0;
        arrdata = split(value,"|");
        strProjectCode = arrdata[0];
        strProjectFlag = arrdata[1];
        strProjectName = arrdata[2];
        
//         strProjectName = new String(strProjectName.getBytes("ISO8859_1"),"TIS620");
        strTotalSize    = arrdata[3];
        strUsedSize     = arrdata[4];
        strAvalSize     = arrdata[5];
        strDocumentAge  = arrdata[6];
        strProjctOwner  = arrdata[7];
        strUserRole     = arrdata[8];
        strUserRoleName = arrdata[9];
        
        userInfo.setProjectCode(  strProjectCode );
        userInfo.setProjectFlag(  strProjectFlag );
        userInfo.setProjectName(  strProjectName );
        userInfo.setTotalSize(    strTotalSize );
        userInfo.setUsedSize(     strUsedSize );
        userInfo.setAvalSize(     strAvalSize );
        userInfo.setDocumentAge(  strDocumentAge );
        userInfo.setProjectOwner( strProjctOwner );
        userInfo.setUserRole(     strUserRole );
        userInfo.setUserRoleName( strUserRoleName );
	}else{
		strUserRole = userInfo.getUserRole();
	}

    con.addData( "USER_ROLE", "String", strUserRole );
	bolSuccess = con.executeService( strContainerName, strClassName, "findAdminApplicationGroup" );
    
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html>
<head>
<title>JSP Page</title>
<meta http-equiv="Content-Type" content="text/html; charset=TIS-620">
<meta http-equiv="Cache-Control:private" content="no-cache, max-age=0,must-revalidate, no-store">
<link href="css/edas.css" type="text/css" rel="stylesheet">    
<LINK href="script/dtree.css" type="text/css" rel="StyleSheet">
<script language="JavaScript" type="text/JavaScript">
<!--
function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}

function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_findObj(n, d) { //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
}

function MM_swapImage() { //v3.0
  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
}
//-->
</script>
<script language="JavaScript" src="js/util.js"></script>
<script language="JavaScript" src="js/constant.js"></script>
<script language="JavaScript" src="js/label.js"></script>
<SCRIPT src="script/dtree_doc.js" type="text/javaScript"></SCRIPT>
<script type="text/javascript" >
<!--
function back_link() {
    window.location = "select_project_menu.jsp";
    top.mainFrame.location =   "system1.jsp";
}
//-->
</script>
</head>
<body onLoad="MM_preloadImages('images/back_over.gif', 'images/txt_manual_over.gif', 'images/txt_install_over.gif')">
    <table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
        <tr>
            <td width="71" valign="top" id="bg_allmenu">
                <table width="188" border="0" cellpadding="0" cellspacing="0" id="bg_leftmenu">
                    <tr> 
                        <td width="188"><img src="images/inner_09.jpg" width="188" height="28"></td>
                    </tr>
                    <tr> 
                        <td height="26" background="images/inner_11.jpg">
                            <img src="images/icon_admin.jpg" width="35" height="26" align="absmiddle">
                            <span style="font-weight:bold;"><%=strProject_name%></span>
                        </td>
                    </tr>
                    <%
                                    if( bolSuccess ) {
                                        String strAppGroup        = "";
                                        String strAppGroupName    = "";
                                        String strApplication     = "";
                                        String strApplicationName = "";
                                        String strApplicationFile = "";
                                        String strTarget          = "mainFrame";

                                        while( con.nextRecordElement() ) {
                                            strAppGroup     = con.getColumn( "APPLICATION_GROUP" );
                                            strAppGroupName = con.getColumn( "APPLICATION_GROUP_NAME" );

                                            out.println( "<tr>" );
                                            out.println( "<td height=\"25\" background=\"images/bar.gif\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" );
                                            out.println( "<span class=\"label_bold5\">" + strAppGroupName + "</span >" );
                                            out.println( "</td>" );
                                            out.println( "</tr>" );

                                            con2.addData( "USER_ROLE", "String", strUserRole );
                                            con2.addData( "APPLICATION_GROUP", "String", strAppGroup );
                                            bolSuccess2 = con2.executeService( strContainerName, strClassName, "findAdminApplicationName" );
                                            if( bolSuccess2 ) {
                                                out.println( "<tr>" );
                                                out.println( "<td>" );
                                                out.println( "<ol>" );

                                                while( con2.nextRecordElement() ) {
                                                    strApplication     = con2.getColumn( "APPLICATION" );
                                                    strApplicationName = con2.getColumn( "APPLICATION_NAME" );
                                                    strApplicationFile = con2.getColumn( "APPLICATION_FILE" );

                                                    out.println( "<li>" );
                                                    out.println( "<a href=\"" + strApplicationFile + "?screenname=" + strApplicationName + "&app_name=" + strApplication + "&user_role=" + strUserRole + "&app_group=" + strAppGroup + "&project_flag=" + strProjectFlag + "&user_group=" + strUserGroup + "&security_flag=" + strSecFlag + "\" target=\"" + strTarget + "\" class=\"menu\">" + strApplicationName + "</a >" );
                                                    out.println( "</li>" );
                                                }

                                                out.println( "" );
                                                out.println( "</ol>" );
                                                out.println( "</td>" );
                                                out.println( "</tr>" );
                                            }
                                        }
                                    }
                    %>

                    <tr>
                        <td height="25" background="images/bar.gif">
                            <a href="manual_admin.jsp" target="mainFrame" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('txt_manual', '', 'images/txt_manual_over.gif', 1)"><img src="images/txt_manual.gif" name="txt_manual" height="25" border="0"></a>
                        </td>
                    </tr>
                    <tr>
                        <td height="25" background="images/bar.gif">
                            <a href="javascript:back_link()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('back', '', 'images/back_over.gif', 1)"><img src="images/back.gif" name="back" width="84" height="25" border="0"></a>
                        </td>
                    </tr>
                </table>
            </td>
            <td>&nbsp;</td>
        </tr>
    </table>
</body>
</html>