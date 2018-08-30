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

	String user_role  = checkNull(request.getParameter("user_role"));
	String app_group  = checkNull(request.getParameter("app_group"));
	String app_name   = checkNull(request.getParameter("app_name"));
	String screenname = getField(request.getParameter("screenname"));

	String 	strClassName 	 = "DOCUMENT_TYPE";
	String 	strmsg           = "";
	String	screenLabel      = "";
	String	strCurrentDate	 = "";
        String  strVersionLang   = ImageConfUtil.getVersionLang();
	
	if(strVersionLang.equals("thai")){
		strCurrentDate = getTodayDateThai();
	}else{
		strCurrentDate = getTodayDate();
	}
	
	UserInfo userInfo = (UserInfo)session.getAttribute( "USER_INFO" );
	String strUserId 	  = userInfo.getUserId();
	String strProjectCode = userInfo.getProjectCode();
	
	String strMode 				  = checkNull(request.getParameter("MODE"));
	String strDocumentTypeKey 	  = checkNull(request.getParameter("DOCUMENT_TYPE_KEY"));
    String strDocumentTypeNameKey = getField(request.getParameter("DOCUMENT_TYPE_NAME_KEY"));
    
    String strDocumentTypeData 	   = checkNull(request.getParameter("txtDocumentType"));
    String strDocumentTypeNameData = getField(request.getParameter("txtDocumentTypeName"));
    
    String	strNewVersion		 = checkNull(request.getParameter("NEW_VERSION"));
    String	strVersionLimit		 = checkNull(request.getParameter("txtVersionLimit"));
    String	strLimitSizeFlag	 = checkNull(request.getParameter("LIMIT_SIZE_FLAG"));
    String	strAccessType		 = checkNull(request.getParameter("ACCESS_TYPE"));
    String	strLimitSize		 = checkNull(request.getParameter("txtLimitSize"));
    String	strLimitFileTypeFlag = checkNull(request.getParameter("LIMIT_FILE_TYPE_FLAG"));
    String	strFileType			 = checkNull(request.getParameter("FILE_TYPE"));
    String	strUserLevel		 = checkNull(request.getParameter("DOCUMENT_LEVEL"));
    String	strLevelName		 = "";
    	
    String	strRdoChecked1 	= "";
    String	strRdoChecked2 	= "";
    String	strRdoChecked3 	= "";
    String	strReadOnly 	= "";
    String	strClassStyle 	= "";
    
	boolean bolnSuccess;
	
	screenLabel = lb_edit;
	
	if(strMode.equals("pEdit")){
		strDocumentTypeData 	= strDocumentTypeKey;
		strDocumentTypeNameData = strDocumentTypeNameKey;
	
		con.addData( "PROJECT_CODE" , "String" , strProjectCode);
		con.addData( "DOCUMENT_TYPE" , "String" , strDocumentTypeData);
		
		bolnSuccess = con.executeService( strContainerName , strClassName , "findDocumentTypeDatail" );
		
		if( !bolnSuccess){
		    strmsg="showMsg(0,0,\" " +  lc_data_not_found + "\")";
		    strMode = "MAIN";
		}else{
			strNewVersion		 = con.getHeader("NEW_VERSION");
			strVersionLimit		 = con.getHeader("VERSION_LIMIT");
		    strLimitSizeFlag	 = con.getHeader("LIMIT_SIZE_FLAG");
		    strAccessType		 = con.getHeader("ACCESS_TYPE");
		    strLimitSize		 = con.getHeader("LIMIT_SIZE");
		    strLimitFileTypeFlag = con.getHeader("LIMIT_FILE_TYPE_FLAG");
		    strFileType			 = con.getHeader("FILE_TYPE");
		    strUserLevel		 = con.getHeader("USER_LEVEL");
		    strLevelName		 = con.getHeader("LEVEL_NAME");
		}
	}
	
	if(strMode.equals("EDIT")){
    	 strDocumentTypeNameData = strDocumentTypeNameData.replaceAll( "'", "''" );
         con.addData( "PROJECT_CODE" 		, "String" , strProjectCode);
         con.addData( "DOCUMENT_TYPE" 		, "String" , strDocumentTypeData);
         con.addData( "DOCUMENT_TYPE_NAME" 	, "String" , strDocumentTypeNameData);
         con.addData( "USER_LEVEL" 		, "String" , strUserLevel);
         con.addData( "NEW_VERSION" 		, "String" , strNewVersion);
         con.addData( "VERSION_LIMIT" 		, "String" , strVersionLimit);
         con.addData( "LIMIT_SIZE_FLAG" 	, "String" , strLimitSizeFlag);
         con.addData( "LIMIT_SIZE" 		, "String" , strLimitSize);
         con.addData( "LIMIT_FILE_TYPE_FLAG"    , "String" , strLimitFileTypeFlag);
         con.addData( "FILE_TYPE" 		, "String" , strFileType);
         con.addData( "USER_ID" 		, "String" , strUserId);
         con.addData( "CURRENT_DATE" 		, "String" , strCurrentDate);

         bolnSuccess = con.executeService( strContainerName , strClassName , "updateDocumentTypeDetail"  );

         if( !bolnSuccess ){
             
             strmsg="showMsg(0,0,\" " + lc_can_not_edit_document_type + "\")";
             strMode = "pEdit";
         }else{
             strmsg="showMsg(0,0,\" " + lc_edit_document_type_successfull  + "\")";
             strMode = "MAIN";
         }
      }
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=tis-620">
<title><%=lc_site_name%></title>
<link href="css/edas.css" type="text/css" rel="stylesheet">
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
<script language="javascript" type="text/javascript">
<!--
var objFileTypeWindow;
var objZoomWindow;
var objUserWindow;

function click_save( ){
    if(verify_form()){
        if(form1.MODE.value == "pEdit"){
            form1.MODE.value = "EDIT";
        }else{
            form1.MODE.value = "MAIN";
        }

        form1.submit();
    }
}

function click_cancel(  ){
    form1.action 	 = "document_type1.jsp";
    form1.target 	 = "_self";
    form1.MODE.value = "SEARCH";
    form1.submit();

}

function verify_form(){
    
    if (form1.txtDocumentTypeName.value.length == 0){
        alert(lc_check_name_document_type);
        form1.txtDocumentTypeName.focus();
        return false;
    }
    
    if (form1.LIMIT_SIZE_FLAG.value == 'Y'){
    	if(form1.txtLimitSize.value.length == 0){
	        alert(lc_check_limit_size);
	        form1.txtLimitSize.focus();
	        return false;
        }
    }else{
    	form1.txtLimitSize.value = 0;
    }
    
    if (form1.LIMIT_FILE_TYPE_FLAG.value == 'Y'){
    	if(form1.FILE_TYPE.value.length == 0){
	        alert(lc_check_limit_file_type);
	        return false;
        }
    }
    
    if(form1.DOCUMENT_LEVEL.value.length == 0){
            alert(lc_check_user_level);
            return false;
    }
 
    if (form1.NEW_VERSION.value == 'Y'){
    	if(form1.txtVersionLimit.value.length == 0){
	       form1.txtVersionLimit.value = "0";
        }
    }else{
    	form1.txtVersionLimit.value = "0";
    }
    return true;
}

function window_onload(){
	lb_doc_type.innerHTML 		  = lbl_doc_type;
    lb_doc_type_name.innerHTML    = lbl_doc_type_name;
    lb_doc_type_size.innerHTML	  = lbl_doc_type_size;
    lb_limit_file_type.innerHTML  = lbl_limit_file_type;
    //lb_access_type.innerHTML	  = lbl_access_type;
    lb_document_level.innerHTML   = lbl_document_level;
    lb_doc_type_version.innerHTML = lbl_doc_type_version;
    
    //lb_all_access.innerHTML 		= lbl_all_access;
    //lb_access_from_level.innerHTML 	= lbl_access_from_level;
    //lb_access_from_user.innerHTML 	= lbl_access_from_user;
    lb_all_file_type.innerHTML 		= lbl_all_file_type;
    lb_sel_file_type.innerHTML		= lbl_sel_file_type;
    lb_doc_type_specified.innerHTML = lbl_doc_type_specified;
    lb_doc_type_not_null.innerHTML 	= lbl_doc_type_not_null;
    lb_not_save_old_version.innerHTML = lbl_not_save_old_version;
    lb_save_old_version.innerHTML 	= lbl_save_old_version;
    lb_ext_all_version.innerHTML	= lbl_ext_all_version;
    
	form1.txtDocumentTypeName.focus();
	
	if(form1.MODE.value == "MAIN"){
        form1.action =   "document_type1.jsp";
        form1.target = "_self";
        form1.MODE.value = "SEARCH";
        form1.submit();
    }
}

function keypress_number(){
    var carCode = event.keyCode;
    if ((carCode < 48) || (carCode > 57)){
        if( event.preventDefault ){
            event.preventDefault();
        }else{
            event.returnValue = false;
        }
        return;
    }
}

function select_rdo_click(type_rdo){
	if(type_rdo == 'F'){
		form1.rdoLimitFileType[1].click();
	}else if(type_rdo == 'U'){
		form1.rdoAccessType[2].click();
	}else{
		form1.rdoAccessType[1].click();
	}
}

function open_file_type(){
	select_rdo_click('F');
		
	var curr_file_type = form1.FILE_TYPE.value;
	var url = "document_type4.jsp?FILE_TYPE=" +  curr_file_type;
	objFileTypeWindow = window.open( url,"file_type","scrollbars=no,status=no,width=270px,height=350px");
	objFileTypeWindow.focus();
}

function change_rdo_button(sel_obj, rdo_idx, txt_value){

	var obj_rdovalue = eval("form1." + txt_value);
	var obj_oldvalue = eval("form1." + sel_obj + "_OLD");
	if(!obj_rdovalue){return;}
	
	if(rdo_idx == 'Y' ){
		obj_rdovalue.className = "input_box";
		obj_rdovalue.readOnly  = false;
		obj_rdovalue.focus();
		eval("form1." + sel_obj).value = 'Y';
	}else{
		obj_rdovalue.className = "input_box_disable";
		obj_rdovalue.readOnly  = true;
		obj_rdovalue.value     = obj_oldvalue.value;
		eval("form1." + sel_obj).value = 'N';
	}		
}

function change_access_type( acc_type, obj_value ){

	var obj_rdovalue = eval("form1." + obj_value);
	if(!obj_rdovalue){return;}

	obj_rdovalue.value = acc_type;			
}

function change_file_type( sel_file_type, obj_value ){

	var obj_rdovalue = eval("form1." + obj_value);
	if(!obj_rdovalue){return;}

	obj_rdovalue.value = sel_file_type;			
}


function openZoom( strZoomType , strZoomLabel , objDisplayText , objDisplayValue, strTableLevel ) {
	var strPopArgument 	= "scrollbars=yes,status=no";
	var strWidth 		= ",width=370px";
	var strHeight 		= ",height=400px";
	var strUrl = "inc/zoom_data_table_level1.jsp";
	var strConcatField  = "TABLE=" + strZoomType;
	strConcatField += "&TABLE_LABEL=" + strZoomLabel;
	strConcatField += "&RESULT_FIELD=" + objDisplayValue.name + "," + objDisplayText.name;
							
	strPopArgument += strWidth + strHeight;						
	
	objZoomWindow = window.open( strUrl + "?" + strConcatField , "zm" + strZoomType , strPopArgument );
	objZoomWindow.focus();
}

//function open_access_user(){
//	select_rdo_click('U');
//	var doc_type_code	= "<%=strDocumentTypeKey%>";
//	var doc_type_name 	= "<%=strDocumentTypeNameKey%>";
//	var doc_width		= "800px"; //screen.availWidth;
//	var doc_height		= "500px"; //screen.availHeight;
//	var url = "document_type5.jsp?DOCUMENT_TYPE=" + doc_type_code + "&DOCUMENT_TYPE_NAME=" + doc_type_name; 
//	objUserWindow = window.open( url, "usr", "scrollbars=yes,status=yes,width=" + doc_width + ",height=" + doc_height);
//	objUserWindow.focus();
//}

function window_onunload(){
	if(objFileTypeWindow != null && objFileTypeWindow.closed){
		objFileTypeWindow.close();
	}
	if(objZoomWindow != null && objZoomWindow.closed){
		objZoomWindow.close();
	}
	if(objUserWindow != null && objUserWindow.closed){
		objUserWindow.close();
	}	
}

//-->
</script>
</head>
<body onload="MM_preloadImages('images/btt_save2_over.gif','images/btt_cancel_over.gif','images/btt_filetype_over.gif','images/btt_userspecify_over.gif');window_onload()" onunload="window_onunload()">
<form name="form1" action="" method="post">
	<table width="800" border="0" cellspacing="0" cellpadding="0">
    	<tbody>
    		<col width="80" />
    		<col width="155" />
    		<col width="200" />
    		<col width="*" />
    		<col width="92" />    		
    	</tbody>          
       	<tr>
           	<td height="25" class="label_header01" colspan="5">
           	&nbsp;&nbsp;&nbsp;<%=screenname%> >> <%=screenLabel %>
       		</td>
       	</tr>       
        <tr>
          	<td align="right">&nbsp;</td>
          	<td align="center" valign="top" colspan="4">&nbsp;</td>
        </tr>
        <tr>
          	<td align="right">&nbsp;</td>
          	<td height="25"><span class="label_bold2" id="lb_doc_type"></span>&nbsp;<img src="images/mark.gif" width="12" height="11"></td>
          	<td height="25" colspan="2"><input name="txtDocumentType" type="text" class="input_box_disable" size="5" maxlength="5" value="<%=strDocumentTypeData%>" readonly></td>
          	<td align="center" valign="top">&nbsp;</td>
        </tr>
        <tr>
          	<td align="right">&nbsp;</td>
          	<td height="25"><span class="label_bold2" id="lb_doc_type_name"></span>&nbsp;<img src="images/mark.gif" width="12" height="11"></td>
          	<td height="25" colspan="2">
          		<input name="txtDocumentTypeName" type="text" class="input_box" size="75" maxlength="70" value="<%=strDocumentTypeNameData %>"></td>
          	<td align="center" valign="top">&nbsp;</td>
        </tr>
        <%
        	if(strLimitSizeFlag.equals("N")){
        		strRdoChecked1 = "checked";
        		strRdoChecked2 = "";
        		strReadOnly	   = "readonly";
        		strClassStyle  = "input_box_disable";
        	}else if(strLimitSizeFlag.equals("Y")){
        		strRdoChecked1 = "";
        		strRdoChecked2 = "checked";
        		strReadOnly	   = "";
        		strClassStyle  = "input_box";
        	}else{
        		strRdoChecked1 = "";
        		strRdoChecked2 = "";
        		strReadOnly	   = "readonly";
        		strClassStyle  = "input_box_disable";
        	}        
        %>
        <tr>
          	<td align="right">&nbsp;</td>
          	<td height="25"><span class="label_bold2" id="lb_doc_type_size"></span>&nbsp;<img src="images/mark.gif" width="12" height="11"></td>
          	<td height="25" >
          		<input name="rdoDocumentTypeSize" type="radio" <%=strRdoChecked1 %> onclick="change_rdo_button('LIMIT_SIZE_FLAG','N','txtLimitSize')"><span id="lb_doc_type_not_null" class="label_bold2"></span>
          	</td>
          	<td>	
          		<input name="rdoDocumentTypeSize" type="radio" <%=strRdoChecked2 %> onclick="change_rdo_button('LIMIT_SIZE_FLAG','Y','txtLimitSize')"><span id="lb_doc_type_specified" class="label_bold2"></span>&nbsp;
          		<input type="text" name="txtLimitSize" value="<%=strLimitSize %>" class="<%=strClassStyle %>" size="15" maxlength="20" <%=strReadOnly %> onkeypress="keypress_number();">
          	</td>
          	<td align="center" valign="top">
          		<input type="hidden" name="LIMIT_SIZE_FLAG" value="<%=strLimitSizeFlag %>">
          		<input type="hidden" name="LIMIT_SIZE_FLAG_OLD" value="<%=strLimitSize %>">
          	</td>
        </tr>
        <%
        	if(strLimitFileTypeFlag.equals("N")){
        		strRdoChecked1 = "checked";
        		strRdoChecked2 = "";        		
        	}else if(strLimitFileTypeFlag.equals("Y")){
        		strRdoChecked1 = "";
        		strRdoChecked2 = "checked";
        	}else{
        		strRdoChecked1 = "";
        		strRdoChecked2 = "";
        	}       
        %>
        <tr>
          	<td align="right">&nbsp;</td>
          	<td height="25"><span class="label_bold2" id="lb_limit_file_type"></span>&nbsp;<img src="images/mark.gif" width="12" height="11"></td>
          	<td height="25" >
          		<input name="rdoLimitFileType" type="radio" <%=strRdoChecked1 %> onclick="change_file_type('N','LIMIT_FILE_TYPE_FLAG')"><span id="lb_all_file_type" class="label_bold2" ></span>
          	</td>
          	<td>	
          		<input name="rdoLimitFileType" type="radio" <%=strRdoChecked2 %> onclick="change_file_type('Y','LIMIT_FILE_TYPE_FLAG')"><span id="lb_sel_file_type" class="label_bold2"></span>&nbsp;
          		<a href="#" onclick="open_file_type()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('filetype','','images/btt_filetype_over.gif',1)"><img src="images/btt_filetype.gif" name="filetype" height="22" border="0" align="textmiddle"></a>
          		<input type="hidden" name="FILE_TYPE" value="<%=strFileType %>">
          	</td>
          	<td align="center" valign="top">
				<input type="hidden" name="LIMIT_FILE_TYPE_FLAG" value="<%=strLimitFileTypeFlag %>">
				<input type="hidden" name="LIMIT_FILE_TYPE_FLAG_OLD" value="<%=strLimitFileTypeFlag %>">
			</td>
        </tr>
        <%
        	if(strAccessType.equals("A")){
        		strRdoChecked1 = "checked";
        		strRdoChecked2 = "";
        		strRdoChecked3 = "";
        	}else if(strAccessType.equals("L")){
        		strRdoChecked1 = "";
        		strRdoChecked2 = "checked";
        		strRdoChecked3 = "";
        	}else if(strAccessType.equals("U")){
        		strRdoChecked1 = "";
        		strRdoChecked2 = "";
        		strRdoChecked3 = "checked";
        	}else{
        		strRdoChecked1 = "";
        		strRdoChecked2 = "";
        		strRdoChecked3 = "";
        	}        
        %>
        
        <tr>
          	<td align="right">&nbsp;</td>
          	<td height="25"><span class="label_bold2" id="lb_document_level"></span>&nbsp;<img src="images/mark.gif" width="12" height="11"></td>
          	<td height="25" colspan="2">
          		<input id="DOCUMENT_LEVEL" name="DOCUMENT_LEVEL" type="text" class="input_box_disable" value="<%=strUserLevel %>" size="8" maxlength="6" readonly /> 
                <a href="javascript:openZoom('USER_LEVEL' , '<%=lb_level_doc %>' , form1.LEVEL_NAME , form1.DOCUMENT_LEVEL, '1');"><img src="images/search.gif" width="16" height="16" border="0" align="absmiddle"></a> 
                <input id="LEVEL_NAME" name="LEVEL_NAME" type="text" class="input_box_disable" value="<%=strLevelName %>" size="35" maxlength="13" readonly />
          	</td>
          	<td align="center" valign="top">&nbsp;</td>
        </tr>
        <%
        	if(strNewVersion.equals("N")){
        		strRdoChecked1 = "checked";
        		strRdoChecked2 = "";
        		strReadOnly	   = "readonly";
        		strClassStyle  = "input_box_disable";
        	}else if(strNewVersion.equals("Y")){
        		strRdoChecked1 = "";
        		strRdoChecked2 = "checked";
        		strReadOnly	   = "";
        		strClassStyle  = "input_box";
        	}else{
        		strRdoChecked1 = "";
        		strRdoChecked2 = "";
        		strReadOnly	   = "readonly";
        		strClassStyle  = "input_box_disable";
        	}       
        %>
        <tr>
          	<td align="right">&nbsp;</td>
          	<td height="25"><span class="label_bold2" id="lb_doc_type_version"></span>&nbsp;<img src="images/mark.gif" width="12" height="11"></td>
          	<td height="25" colspan="2" >
          		<input name="rdoDocumentVersion" type="radio" <%=strRdoChecked1 %> onclick="change_rdo_button('NEW_VERSION','N','txtVersionLimit')"><span id="lb_not_save_old_version" class="label_bold2"></span>
          	</td>
          	<td align="center" valign="top">
          		<input type="hidden" name="NEW_VERSION" value="<%=strNewVersion%>">
          		<input type="hidden" name="NEW_VERSION_OLD" value="<%=strVersionLimit%>">
         	</td>
        </tr>
        <tr>
          	<td align="right">&nbsp;</td>
          	<td height="25"></td>
          	<td height="25" colspan="2">
          		<input name="rdoDocumentVersion" type="radio" <%=strRdoChecked2 %> onclick="change_rdo_button('NEW_VERSION','Y','txtVersionLimit')"><span id="lb_save_old_version" class="label_bold2"></span>&nbsp;
          		<input type="text" name="txtVersionLimit" value="<%=strVersionLimit %>" class="<%=strClassStyle %>" size="3" maxlength="2" onkeypress="keypress_number();" <%=strReadOnly %>>
          		<span id="lb_ext_all_version" class="label_bold2" style="color:red;"></span>
          	</td>
          	<td align="center" valign="top">&nbsp;</td>
        </tr>
        <tr>
          	<td align="right">&nbsp;</td>
          	<td align="center">&nbsp;</td>
          	<td colspan="2">&nbsp;</td>
          	<td align="center" valign="top">&nbsp;</td>
        </tr>
        <tr>
          	<td colspan="5"><div align="center">
          	<a href="javascript:click_save()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('btt_save2','','images/btt_save2_over.gif',1)"><img src="images/btt_save2.gif" name="btt_save2" width="67" height="22" border="0"></a>
          	<a href="javascript:click_cancel()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('btt_cancel','','images/btt_cancel_over.gif',1)"><img src="images/btt_cancel.gif" name="btt_cancel" width="67" height="22" border="0"></a>
          	</div></td>
        </tr>
   	</table>
<input type="hidden" name="MODE" 		value="<%=strMode%>">
<input type="hidden" name="screenname"  value="<%=screenname%>">
<input type="hidden" name="user_role" 	value="<%=user_role%>">
<input type="hidden" name="app_group" 	value="<%=app_group%>">            
<input type="hidden" name="app_name" 	value="<%=app_name%>">
</form>
</body>
</html>
<%  if (!strmsg.equals("")) {  %>
<script language="javaScript">
    <%=strmsg%>
</script>
<%  }   %>