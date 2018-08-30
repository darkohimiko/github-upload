<%@page import="com.scc.edms.conf.ImageConfUtil"%>
<%@ page contentType="text/html; charset=tis-620"%>	
<%@ page import="com.scc.security.UserInfo"%>
<%@ include file="inc/checkUser.jsp" %>
<%@ include file="inc/constant.jsp" %>
<%@ include file="inc/utils.jsp" %>
<jsp:useBean id="con" scope="session" class="edms.cllib.EABConnector"/>
<%
    con.setRemoteServer("EAS_SERVER");

    UserInfo  userInfo  = (UserInfo)session.getAttribute( "USER_INFO" );
    String    strUserId = userInfo.getUserId();

    String screenname   = getField(request.getParameter("screenname"));
    String strClassName = "USER_LEVEL";
    String strMode      = getField(request.getParameter("MODE"));
    
    String strmsg = "";
    
    String strCurrentDate = "";
    String strVersionLang = ImageConfUtil.getVersionLang();

    if( strVersionLang.equals("thai") ) {
        strCurrentDate = getServerDateThai();
    }else{
        strCurrentDate = getServerDateEng();
    }
    
    boolean bolnSuccess = false;
    
    String strUserLevelSearch = getField(request.getParameter( "USER_LEVEL_SEARCH" ));
    String strLevelNameSearch = getField(request.getParameter( "LEVEL_NAME_SEARCH" ));
    
    String strUserLevelDel = getField(request.getParameter( "USER_LEVEL_DEL" ));
    String strLevelNameDel = getField(request.getParameter( "LEVEL_NAME_DEL" ));

    String strUserLevelData = "";
    String strLevelNameData = "";
    
    String strScript    = "";
    String strbttEdit   = "";
    String strbttDelete = "";

    if( strMode == null || strMode.equals("")){
        strMode = "SEARCH";
    }
    
    if( strMode.equals("DELETE") ) {
    	con.addData( "USER_LEVEL", "String", strUserLevelDel );
    	con.addData( "DESC",  	     "String", strUserLevelDel + "-" + strLevelNameDel );
     	con.addData( "USER_ID",      "String", strUserId );
        con.addData( "ACTION_FLAG",  "String", "DL" );
        con.addData( "CURRENT_DATE", "String", strCurrentDate);
        bolnSuccess = con.executeService( strContainerName, strClassName, "deleteUserLevel" );
        if( !bolnSuccess ){
                strmsg  = "showMsg(0,0,\" " + lc_can_not_delete_data + "\")";
                strMode = "SEARCH";
        }else{
            strmsg  = "showMsg(0,0,\" " + lc_delete_data_successfull + "\")";
            strMode = "SEARCH";
        }
    }
    
    if( strMode.equals("SEARCH") ) {
        bolnSuccess = con.executeService( strContainerName, strClassName, "findUserLevel" );
    }
    
    if( strMode.equals("FIND") ) {
    	if( !strUserLevelSearch.equals("") ) {
                con.addData( "USER_LEVEL",  "String", strUserLevelSearch);
    	}
    	if( !strLevelNameSearch.equals("") ) {
            con.addData( "LEVEL_NAME",  "String", strLevelNameSearch);
    	}
        
        bolnSuccess = con.executeService( strContainerName, strClassName, "findUserLevelSearch" );
        
    }
%>
<!DOCTYPE HTML>
<html>
<head>
<title><%=lc_site_name%></title>
<meta http-equiv="Content-Type" content="text/html; charset=windows-874">
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
<script language="JavaScript" src="js/jquery-1.9.1.js"></script>
<script language="JavaScript" src="js/label/lb_user_level.js"></script>
<script language="JavaScript" src="js/function/page-utils.js"></script>
<script language="JavaScript" src="js/util.js"></script>
<script language="JavaScript" src="js/constant.js"></script>
<script language="JavaScript" type="text/javascript">
<!--

$(document).ready(window_onload);

function window_onload() {
    set_label();
    set_background("screen_div");
    set_message();
}

function set_label(){
    $("#lb_user_level").text(lbl_level_code);
    $("#lb_level_name").text(lbl_level_name);
}

function set_message(){
    
<%  if (!strmsg.equals("")) {  %>
    <%=strmsg%>
<%  }   %>
}

function buttonClick( lv_strMethod, lv_strValue ){
    switch( lv_strMethod ){
        case "pInsert" :
//            $("#formadd").attr('action', "user_level2.jsp");
            $("#formadd #USER_LEVEL_KEY").val("");
            $("#formadd #LEVEL_NAME_KEY").val("");
            $("#formadd #MODE").val("pInsert");
            $("#formadd").submit();
            break;
        case "pEdit" :
//            $("#formadd").attr('action', "user_level2.jsp");
            $("#formadd #USER_LEVEL_KEY").val(lv_strValue.getAttribute("USER_LEVEL"));
            $("#formadd #LEVEL_NAME_KEY").val(lv_strValue.getAttribute("LEVEL_NAME"));
            $("#formadd #MODE").val("pEdit");
            $("#formadd").submit();
            break;
        case "DELETE" :
            if( !confirm( lc_confirm_delete ) ){
                return;
            }
            
            $("#form1").attr('action', "user_level1.jsp");
            $("#form1 #USER_LEVEL_DEL").val(lv_strValue.getAttribute("USER_LEVEL"));
            $("#form1 #LEVEL_NAME_DEL").val(lv_strValue.getAttribute("LEVEL_NAME"));
            $("#form1 #MODE").val(lv_strMethod);
            $("#form1").submit();
            break;
    }
}
//-->
</script>
<link href="css/edas.css" type="text/css" rel="stylesheet">
</head>
<body onLoad="MM_preloadImages('images/btt_level_over.gif','images/btt_edit2_over.gif','images/btt_delete_over.gif');" onresize="set_background('screen_div')">
<form id="form1" name="form1" method="post" action="" >
<table width="100%" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
<tr><td valign="top">
    <div id="screen_div">
    <table width="800" border="0" cellpadding="0" cellspacing="0">
        <tr>
            <td valign="top">
                <table width="800" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                        <td height="25" colspan="2" class="label_header01" >&nbsp;&nbsp;<%=screenname%></td>
                    </tr>
                    <tr>
                        <td height="25" colspan="2" class="label_header01" ><BR></td>
                    </tr>
                    <tr>
                        <td width="30">&nbsp;</td>
                        <td><div align="left"> 
                            <table width="496" border="0" cellpadding="0" cellspacing="0">
                                <tr class="hd_table"> 
                                    <td width="10"><img src="images/hd_tb_01.gif" width="10" height="28"></td>
                                    <td width="100" align="center">
                                        <div align="center"><span id="lb_user_level"></span></div>
                                    </td>
                                    <td width="240" align="center">
                                        <div align="left"><span id="lb_level_name"></span></div>
                                    </td>
                                    <td>&nbsp;</td>
                                    <td align="right"><img src="images/hd_tb_04.gif" width="10" height="28"></td>
                                </tr>
<%
    if( (bolnSuccess) ) {
        int intSeq = 1;
        int idx    = 0;
        while( con.nextRecordElement() ){
            strUserLevelData   = con.getColumn( "USER_LEVEL" );
            strLevelNameData   = con.getColumn( "LEVEL_NAME" );
            
            strbttEdit         = "<img src=\"images/btt_edit2.gif\" name=\"EDIT" + intSeq + "\"  width=\"52\" height=\"18\" border=\"0\">";
            strbttDelete       = "<img src=\"images/btt_delete.gif\" name=\"Delete" + intSeq + "\"  width=\"52\" height=\"18\" border=\"0\">";
            strScript          = "USER_LEVEL=\"" + strUserLevelData + "\" LEVEL_NAME=\"" + strLevelNameData + "\" ";
			
            idx = 2 - (intSeq % 2);
%>
                      
                                <tr class="table_data<%=idx%>">
                                    <td>&nbsp;</td>
                                    <td><div align="center"><%=strUserLevelData %></div></td>
                                    <td><div align="left"><%=strLevelNameData %></div></td>
                                    <td colspan="2">
                                        <a href="#" onclick="buttonClick('pEdit',this)"<%=strScript%> onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('EDIT<%=intSeq %>','','images/btt_edit2_over.gif',1)"><%=strbttEdit%></a>&nbsp;
                                        <a href="#" onclick="buttonClick('DELETE',this)"<%=strScript%> onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Delete<%=intSeq %>','','images/btt_delete_over.gif',1)"><%=strbttDelete%></a>
                                    </td>
                                </tr>
<%
            intSeq++;
        }
     }
 %>                      
                                <tr>
                                    <td height="25">&nbsp;</td>
                                </tr>
                                <tr>
                                    <td colspan="5" align="center">
                                        <a href="#" onclick= "buttonClick('pInsert')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('newtb','','images/btt_level_over.gif',1)">
                                        <img src="images/btt_level.gif" name="newtb" height="22" border="0"></a>
                                    </td>
                                </tr>    
                            </table>
                        </div></td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
    </div>
</td></tr>
</table>
<input type="hidden" id="MODE"           name="MODE"           value="<%=strMode%>">
<input type="hidden" id="screenname"     name="screenname"     value="<%=screenname%>">
<input type="hidden" id="USER_LEVEL_DEL" name="USER_LEVEL_DEL" value="">
<input type="hidden" id="LEVEL_NAME_DEL" name="LEVEL_NAME_DEL" value="">
</form>
<form id="formadd" name="formadd" method="post" action="user_level2.jsp" target = "_self">
<input type="hidden" id="MODE"           name="MODE"           value="">
<input type="hidden" id="USER_LEVEL_KEY" name="USER_LEVEL_KEY" value="">
<input type="hidden" id="LEVEL_NAME_KEY" name="LEVEL_NAME_KEY" value="">
<input type="hidden" id="screenname"     name="screenname"     value="<%=screenname%>">
</form>
</body>
</html>