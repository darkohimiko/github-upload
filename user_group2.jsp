<%@page import="com.scc.edms.conf.ImageConfUtil"%>
<%@ page contentType="text/html; charset=tis-620"%>
<%@ page import="com.scc.security.UserInfo"%>
<%@ include file="inc/checkUser.jsp" %>
<%@ include file="inc/constant.jsp" %>
<%@ include file="inc/label.jsp" %>
<%@ include file="inc/utils.jsp" %>
<jsp:useBean id="con" scope="session" class="edms.cllib.EABConnector"/>
<%
    con.setRemoteServer("EAS_SERVER");

    UserInfo userInfo = (UserInfo)session.getAttribute( "USER_INFO" );
    String  strUserId = userInfo.getUserId();

    String screenname   = getField(request.getParameter("screenname"));
    String screenLabel  = getField(request.getParameter("screenLabel"));
    String strClassName = "USER_GROUP";
    String strMode      = getField(request.getParameter("MODE"));
    
    String strUserGroupKey = getField(request.getParameter("USER_GROUP_KEY"));

    String strUserGroupData = getField(request.getParameter("txtUserGroup"));
    String strGroupNameData = getField(request.getParameter("txtGroupName"));
    String strGroupDescData = getField(request.getParameter("txtGroupDesc"));
    
    boolean bolnSuccess     = true;    
    String  strmsg          = "";
    String  strCurrentDate  = "";
    String  nextUserGroup   = "";
    String  strVersionLang  = ImageConfUtil.getVersionLang();

    if( strVersionLang.equals("thai") ) {
        strCurrentDate = getServerDateThai();
    }else{
        strCurrentDate = getServerDateEng();
    }
	
    if( strMode == null ){
        strMode = "SEARCH";
    }

    if( strMode.equals("pInsert") ) {
		screenLabel = lb_user_group_new;
        bolnSuccess = con.executeService( strContainerName , strClassName , "selectMaxUserGroup" );
        if( bolnSuccess ) {
        	nextUserGroup = con.getHeader( "MAX" );
        	if( nextUserGroup == null || nextUserGroup.equals("") ) {
        		nextUserGroup = "00000001";
        	}else {
        		nextUserGroup = "0000000" + nextUserGroup;
        	}
        	nextUserGroup = nextUserGroup.substring(nextUserGroup.length()-8,nextUserGroup.length());
        }
    }else if( strMode.equals("pEdit") ) {
    	screenLabel      = lb_user_group_edit;
    	strUserGroupData = strUserGroupKey;
    	con.addData( "USER_GROUP", "String", strUserGroupData );
    	bolnSuccess = con.executeService( strContainerName, strClassName, "selectUserGroupForUpdate" );
    	if( bolnSuccess ) {
        	strGroupNameData = con.getHeader( "GROUP_NAME" );
        	strGroupDescData = con.getHeader( "DESCRIPTION" );
        }
    }

    if( strMode.equals("ADD") ) {
    	strGroupDescData = strGroupDescData.replaceAll( "\\r\\n", "##" );
        con.addData( "USER_GROUP", "String", strUserGroupData );
        con.addData( "GROUP_NAME", "String", strGroupNameData );
        con.addData( "GROUP_DESC", "String", strGroupDescData );
        con.addData( "ADD_USER",   "String", strUserId );
        con.addData( "ADD_DATE",   "String", strCurrentDate );
        con.addData( "UPD_USER",   "String", strUserId );
        con.addData( "DESC",  	"String", strUserGroupData + "-" + strGroupNameData );
     	con.addData( "USER_ID",  	 "String", strUserId );
        con.addData( "ACTION_FLAG",  "String", "AG" );
        con.addData( "CURRENT_DATE", "String", strCurrentDate);

        bolnSuccess = con.executeService( strContainerName, strClassName, "insertUserGroup" );
        strGroupDescData = strGroupDescData.replaceAll( "\"" , "\\\\\"" );
        if( !bolnSuccess ){
            strmsg  = "showMsg(0,0,\" " + lc_can_not_add_data + "\")";
            strMode = "pInsert";
        }else {
            strmsg  = "showMsg(0,0,\" " +  lc_add_data_successfull + "\")";
            strMode = "MAIN";
        }
     }else if( strMode.equals("EDIT") ) {
    	 strGroupDescData = strGroupDescData.replaceAll( "\\r\\n", "##" );
         con.addData( "USER_GROUP", "String", strUserGroupData );
         con.addData( "GROUP_NAME", "String", strGroupNameData );
         con.addData( "GROUP_DESC", "String", strGroupDescData );
         con.addData( "EDIT_USER",  "String", strUserId );
         con.addData( "EDIT_DATE",  "String", strCurrentDate );
         con.addData( "UPD_USER",   "String", strUserId );
         
         con.addData( "DESC",  		 "String", strUserGroupData + "-" + strGroupNameData );
      	con.addData( "USER_ID",  	 "String", strUserId );
         con.addData( "ACTION_FLAG",  "String", "EG" );
         con.addData( "CURRENT_DATE", "String", strCurrentDate);

        bolnSuccess = con.executeService( strContainerName , strClassName , "updateUserGroup"  );
        strGroupDescData = strGroupDescData.replaceAll( "\"" , "\\\\\"" );
        if( !bolnSuccess ) {
            strmsg  = "showMsg(0,0,\" " + lc_can_not_update_data  + "\")";
            strMode = "pEdit";
        }else {
            strmsg  = "showMsg(0,0,\" " + lc_update_data_successfull + "\")";
            strMode = "MAIN";
        }
     }
    
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
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
<script language="JavaScript" src="js/sccUtils.js"></script>
<script language="JavaScript" src="js/util.js"></script>
<script language="JavaScript" src="js/constant.js"></script>
<script language="JavaScript" src="js/label.js"></script>
<script language="JavaScript" type="text/javascript">
<!--

var mode = "<%=strMode%>";

function window_onload() {
	lb_doc_type.innerHTML   = lbl_doc_type;
	lb_group_name.innerHTML = lbl_group_name;
	lb_group_mark.innerHTML = lbl_group_mark;
    
    if( mode == "MAIN" ) {
        form1.action     = "user_group1.jsp";
        form1.target     = "_self";
        form1.MODE.value = "SEARCH";
        form1.submit();
    }else if( mode == "pEdit" ) {
    	obj_txtUserGroup.value  = "<%=strUserGroupData %>";
    	obj_txtGroupName.value = "<%=strGroupNameData %>";
    	obj_txtGroupDesc.value = "<%=strGroupDescData %>";
    	if( obj_txtGroupDesc.value != "" ) {
    		obj_txtGroupDesc.value = obj_txtGroupDesc.value.replace( /##/gi , "\r\n" );
    	}
    }else if( mode == "pInsert" ) {
    	obj_txtUserGroup.value = "<%=nextUserGroup %>";
    	obj_txtGroupName.focus();
    }
}

function verify_form() {
	if( obj_txtGroupName.value.length == 0 ) {
        alert( lc_check_role_name );
        obj_txtGroupName.focus();
        return false;
    }    
	return true;
}

function buttonClick( lv_strMethod ){
    switch( lv_strMethod ){
		case "save" :
		    if(verify_form()){
		        if(form1.MODE.value == "pInsert"){
		            form1.MODE.value = "ADD" ;
		        }else{
		            form1.MODE.value = "EDIT" ;
		        }
				form1.submit();
			}
			break;
		case "cancel" :
			form1.action     = "user_group1.jsp";
			form1.target 	 = "_self";
		    form1.MODE.value = "SEARCH";
		    form1.submit();
			break;
	}
}

function limitText(limitField, limitNum) {
    if( limitField.value.length > limitNum ) {
        alert( lc_news_check_area_size );
        limitField.value = limitField.value.substring( 0, limitNum );
    } 
}

//-->
</script>
<link href="css/edas.css" type="text/css" rel="stylesheet">
</head>
<body onLoad="MM_preloadImages('images/btt_save2_over.gif','images/btt_cancel_over.gif');window_onload();">
<form name="form1" method="post" action="" >
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0" align="center">
  <tr>
    <td valign="top">
    	<table width="800" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td height="25" class="label_header01" colspan="4">&nbsp;&nbsp;<%=screenname%>&nbsp; >> &nbsp;<%=screenLabel %></td>
              </tr>
              <tr>
            	<td height="25" align="center">
            		<table width="550" border="0" cellspacing="0" cellpadding="0">
		                <tr>
		                  	<td height="25" colspan="4">&nbsp;</td>
		                </tr>
	                	<tr>
		                  	<td height="25" width="100" class="label_bold2"><span id="lb_doc_type"></span>&nbsp;<img src="images/mark.gif" width="12" height="11"></td>
		                  	<td height="25" colspan="3" width="450">
		                  		<input id="txtUserGroup" name="txtUserGroup" type="text" class="input_box_disable" size="8" maxlength="8" readOnly>
	                  		</td>
	                	</tr>
	                	<tr>
		                  	<td height="25" class="label_bold2"><span id="lb_group_name"></span>&nbsp;<img src="images/mark.gif" width="12" height="11"></td>
		                  	<td height="25" colspan="3">
		                  		<input id="txtGroupName" name="txtGroupName" type="text" class="input_box" size="45" maxlength="50">
	                  		</td>
	                	</tr>
	                	<tr>
		                  	<td height="25" class="label_bold2"><span id="lb_group_mark"></span></td>
		                  	<td height="25" colspan="3">
		                  		<textarea rows="5" cols="80" id="txtGroupDesc" name="txtGroupDesc" class="input_box" onKeyDown="limitText(this,4000);" onKeyUp="limitText(this,4000);"></textarea>
	                  		</td>
	                	</tr>
	                	<tr>
	                  		<td height="25" colspan="4">&nbsp;</td>
	                  	</tr>
			            <tr>
				           	<td align="center" colspan="4">
				           		<a href="#" onclick= "buttonClick('save')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('save','','images/btt_save2_over.gif',1)">
				           			<img src="images/btt_save2.gif" name="save" width="67" height="22" border="0"></a>&nbsp;
				           		<a href="#" onclick= "buttonClick('cancel')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('cancel','','images/btt_cancel_over.gif',1)">
				           			<img src="images/btt_cancel.gif" name="cancel" width="67" height="22" border="0"></a>
				           	</td>
			            </tr>
              		</table>
		            <input type="hidden" name="MODE"     value="<%=strMode%>">
           			<input type="hidden" id="screenname"  name="screenname"  value="<%=screenname%>">
           			<input type="hidden" id="screenLabel" name="screenLabel" value="<%=screenLabel%>">
            	</td>
            </tr>
        </table>
        <p>&nbsp;</p>
      </td>
    </tr>
</table>
</form>
</body>
</html>
<script language="JavaScript" type="text/javascript">
<!--
var obj_txtUserGroup = document.getElementById( "txtUserGroup" );
var obj_txtGroupName = document.getElementById( "txtGroupName" );
var obj_txtGroupDesc = document.getElementById( "txtGroupDesc" );
//-->
</script>
<%  if (!strmsg.equals("")) {  %>
<script language="javaScript">
    <%=strmsg%>
</script>
<%  }   %>