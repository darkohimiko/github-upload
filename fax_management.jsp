<%@page import="com.scc.edms.conf.ImageConfUtil"%>
<%@ page contentType="text/html; charset=tis-620"%>
<%@ page import="com.scc.security.UserInfo"%>
<%@ include file="inc/checkUser.jsp" %>
<%@ include file="inc/constant.jsp" %>
<%@ include file="inc/label.jsp" %>
<%@ include file="inc/utils.jsp" %>
<jsp:useBean id="con" scope="session" class="edms.cllib.EABConnector"/>
<jsp:useBean id="con1" scope="session" class="edms.cllib.EABConnector"/>
<%
	con.setRemoteServer("EAS_SERVER");
	con1.setRemoteServer("EAS_SERVER");

    UserInfo userInfo       = (UserInfo)session.getAttribute( "USER_INFO" );
    String   strUserId      = userInfo.getUserId();
	String   strProjectCode = userInfo.getProjectCode();
	
    String screenname   = getField(request.getParameter("screenname"));
    String strClassName = "CABINET_CONFIG";
	String strMode      = getField(request.getParameter("MODE"));
    
    String strFaxPathData     = getField(request.getParameter("txtFaxPath"));
    String strDocTypeData     = getField(request.getParameter("txtDocType"));
    String strDocTypeNameData = getField(request.getParameter("txtDocTypeName"));

    String  screenLabel = lb_fax_management;
    
    boolean bolnSuccess     = true;    
    String  strmsg          = "";
    String  strCurrentDate  = "";
    String  strVersionLang	= ImageConfUtil.getVersionLang();

    if( strVersionLang.equals("thai") ) {
        strCurrentDate = getTodayDateThai();
    }else{
        strCurrentDate = getTodayDate();
    }
	
	if( strMode == null ){
        strMode = "SEARCH";
    }

    if(strMode.equals("ADD")){        
        con.addData( "PROJECT_CODE",  "String", strProjectCode);
       	con.addData( "FAX_PATH",      "String", strFaxPathData);
       	con.addData( "DOCUMENT_TYPE", "String", strDocTypeData);
       	con.addData( "CONFIG_FILE",   "String", "-" );
        con.addData( "ADD_USER",      "String", strUserId);
        con.addData( "ADD_DATE",      "String", strCurrentDate);
        con.addData( "UPD_USER",      "String", strUserId);

        bolnSuccess = con.executeService( strContainerName , strClassName , "insertFaxManagement"  );

        if( !bolnSuccess ){
            strmsg="showMsg(0,0,\" " + lc_can_not_add_data  + "\")";
            strMode = "ADD";
        }else{
            strmsg="showMsg(0,0,\" " + lc_add_data_successfull + "\")";
            strMode = "SEARCH";
        }
	}

    if(strMode.equals("EDIT")){        
        con.addData( "PROJECT_CODE",  "String", strProjectCode);
        con.addData( "FAX_PATH",      "String", strFaxPathData);
        con.addData( "DOCUMENT_TYPE", "String", strDocTypeData);
        con.addData( "EDIT_USER",     "String", strUserId);
        con.addData( "EDIT_DATE",     "String", strCurrentDate);
        con.addData( "UPD_USER",      "String", strUserId);

        bolnSuccess = con.executeService( strContainerName , strClassName , "updateFaxManagement"  );

        if( !bolnSuccess ){
            strmsg="showMsg(0,0,\" " + lc_can_not_update_data  + "\")";
            strMode = "EDIT";
        }else{
            strmsg="showMsg(0,0,\" " + lc_update_data_successfull + "\")";
            strMode = "SEARCH";
        }
	}
    
    if( strMode.equals("SEARCH") ) {
        con.addData( "PROJECT_CODE", "String", strProjectCode );
        //con.addData( "PROJECT_CODE", "String", "00000001" );
        bolnSuccess = con.executeService( strContainerName, strClassName, "findFaxManagement" );
        
        if( !bolnSuccess ) {
            strMode = "ADD";
        }else {
            while( con.nextRecordElement() ) {

            	strFaxPathData     = con.getColumn( "FAX_PATH" );
            	strDocTypeData     = con.getColumn( "DOCUMENT_TYPE" );
            	strDocTypeNameData = con.getColumn( "DOCUMENT_TYPE_NAME" );
            	strFaxPathData     = new String(strFaxPathData.getBytes( "ISO8859_1"),"TIS620");
                strMode = "EDIT";
            }
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

var mode     = "<%=strMode %>";
var sccUtils = new SCUtils;

function window_onload() {	
    lb_fax_path.innerHTML      = lbl_fax_path;
    lb_doc_type_name.innerHTML = lbl_doc_type_name;
    
    obj_txtFaxPath.value     = "<%=strFaxPathData %>";
   	obj_txtDocType.value     = "<%=strDocTypeData %>";
   	obj_txtDocTypeName.value = "<%=strDocTypeNameData %>";
}

function openZoom( strZoomType ) {
	var strPopArgument   = "scrollbars=yes,status=no";
	var strWidth         = ",width=370px";
	var strHeight        = ",height=420px";
	var strUrl           = "";
	var strConcatField   = "";
	var strProjCode      = "<%=strProjectCode %>";
	strPopArgument += strWidth + strHeight;

	switch( strZoomType ){
		case "doc" :
				strUrl = "inc/zoom_data_table_level1.jsp";
				strConcatField = "TABLE=DOCUMENT_TYPE" + "&TABLE_LABEL=" + lbl_doc_type_name;
				strConcatField += "&PROJECT_CODE=" + strProjCode;
				strConcatField += "&RESULT_FIELD=txtDocType,txtDocTypeName";
				break;
	}

	objZoomWindow = window.open( strUrl + "?" + strConcatField, strZoomType, strPopArgument );
	objZoomWindow.focus();
}

function buttonClick( lv_strMethod ){
    switch( lv_strMethod ){
		case "save" :
		    if( verify_form() ){
/*		        if(form1.MODE.value == "pInsert"){
		            form1.MODE.value = "ADD" ;
		        }else{
		            form1.MODE.value = "EDIT" ;
		        }
*/				form1.submit();
			}
			break;
		case "cancel" :
			form1.action     = "cabinet_config1.jsp";
			form1.target 	 = "_self";
		    form1.MODE.value = "SEARCH";
		    form1.submit();
			break;
	}
}

function verify_form() {
	if( obj_txtFaxPath.value.length == 0 ) {
        alert( lc_check_fax_path );
        obj_txtFaxPath.focus();
        return false;
	}
	
	if( obj_txtDocType.value.length == 0 ) {
        alert( lc_check_email_doc_type );
        //obj_hidTagSendOption.focus();
        return false;
	}
	
	return true;
}

//-->
</script>
</head>
<link href="css/edas.css" type="text/css" rel="stylesheet">
<body onLoad="MM_preloadImages('images/btt_save2_over.gif','images/btt_cancel_over.gif','images/btt_newpw_over.gif');window_onload();">
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
            		<table width="502" border="0" cellspacing="0" cellpadding="0">
		                <tr>
		                  	<td height="25" colspan="4">&nbsp;</td>
		                </tr>
	                	<tr>
		                  	<td height="25" class="label_bold2"><span id="lb_fax_path"></span>&nbsp;
		                  		<img src="images/mark.gif" width="12" height="11">
		                  	</td>
		                  	<td height="25" colspan="3">
		                  		<input id="txtFaxPath" name="txtFaxPath" type="text" class="input_box" size="56" maxlength="60"></td>
	                	</tr>
	                	<tr>
		                  	<td height="25" class="label_bold2"><span id="lb_doc_type_name"></span>&nbsp;
		                  		<img src="images/mark.gif" width="12" height="11">
		                  	</td>
		                  	<td height="25" colspan="3">
		                  		<div style="float: left">
		                  			<input id="txtDocType" name="txtDocType" type="text" class="input_box_disable" size="4" maxlength="10" readonly align="right">
		                  			&nbsp;<a href="javascript:openZoom('doc');"><img id="zoomOwner" src="images/search.gif" width="16" height="16" border="0"></a>
		                  			&nbsp;<input id="txtDocTypeName" name="txtDocTypeName" type="text" class="input_box_disable" size="40" maxlength="50" readonly>
	                  			</div>
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
			            <input type="hidden" id="MODE"        name="MODE"        value="<%=strMode%>">
			            <input type="hidden" id="screenname"  name="screenname"  value="<%=screenname%>">
			            <input type="hidden" id="screenLabel" name="screenLabel" value="<%=screenLabel%>">
              		</table>
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

var obj_txtFaxPath     = document.getElementById("txtFaxPath");
var obj_txtDocType     = document.getElementById("txtDocType");
var obj_txtDocTypeName = document.getElementById("txtDocTypeName");
//-->
</script>
<%  if (!strmsg.equals("")) {  %>
<script language="javaScript">
    <%=strmsg%>
</script>
<%  }   %>