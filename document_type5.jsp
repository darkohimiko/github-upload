<%@page import="com.scc.edms.conf.ImageConfUtil"%>
<%@ page contentType="text/html; charset=tis-620"%>
<%@ page import="com.scc.security.UserInfo"%>
<%@ include file="inc/checkUser.jsp" %>
<%@ include file="inc/constant.jsp" %>
<%@ include file="inc/label.jsp" %>
<%@ include file="inc/utils.jsp" %>
<jsp:useBean id="con" scope="session" class="edms.cllib.EABConnector"/>
<%
	
	UserInfo userInfo = (UserInfo)session.getAttribute( "USER_INFO" );
	String	strUserId = userInfo.getUserId();
	
	con.setRemoteServer("EAS_SERVER");

	String  strClassName     = "DOCUMENT_TYPE";
	String  strMode          = checkNull(request.getParameter("MODE"));
	String  strOldMode       = checkNull(request.getParameter("OLD_MODE"));
	String	strmsg			 = "";
	String	strErrorMessage  = "";
	String	strPermitUsers	 = "";
	String	strCurrentDate  = "";
        String strVersionLang   = ImageConfUtil.getVersionLang();
	
	if(strVersionLang.equals("thai")){
		strCurrentDate = getTodayDateThai();
	}else{
		strCurrentDate = getTodayDate();
	}
	
	String	strProjectCode 		= userInfo.getProjectCode();
	String	strDocumentType 	= checkNull(request.getParameter("DOCUMENT_TYPE"));
	String	strDocumentTypeName = getField(request.getParameter("DOCUMENT_TYPE_NAME"));
	
	String	strUserIdSearch		= checkNull(request.getParameter("txtUserId"));
	String	strUserNameSearch	= getField(request.getParameter("txtUserName"));
	String	strUserSnameSearch	= getField(request.getParameter("txtUserSname"));
	String	strUserOrgSearch	= checkNull(request.getParameter("txtUserOrg"));
	
	String	strAccUsers = getField(request.getParameter("CONCAT_USER"));
	
	String	strPageNumber = checkNull(request.getParameter("PAGENUMBER"));
	String	strPageSize   = checkNull(request.getParameter("PAGE_SIZE"));
	String	strTotalPage  = "1";	
	String	strTotalSize  = "0";
	
	if(strPageNumber.equals("")){
		strPageNumber = "1";
	}
	if(strPageSize.equals("")){
		strPageSize = "10";
	}
	if(strMode.equals("")){
		strMode = "SEARCH";	
	}
	
	boolean bolnSuccess = false;
	
	if(strMode.equals("SET_PERMIT")) {
            con.addData( "ALL_USERS" 		, "String" , strAccUsers );
            con.addData( "PROJECT_CODE" 	, "String" , strProjectCode );
            con.addData( "DOCUMENT_TYPE" 	, "String" , strDocumentType );
            con.addData( "USER_ID" 		, "String" , strUserId );
            con.addData( "CURRENT_DATE" 	, "String" , strCurrentDate );
        
        bolnSuccess = con.executeService( strContainerName , strClassName , "updateDocumentTypeUser"  );
        if( !bolnSuccess ){	
        	strmsg="showMsg(0,0,\" " + lc_cannot_permit_user + "\")";
        }else{	         
            strmsg="showMsg(0,0,\" " + lc_permit_user_successful + "\")";	         
        }			
		strMode = "SEARCH";
	}
	
	if(strMode.equals("NOT_PERMIT")) {
		con.addData( "ALL_USERS" 		, "String" , strAccUsers );
		con.addData( "PROJECT_CODE" 	, "String" , strProjectCode );
        con.addData( "DOCUMENT_TYPE" 	, "String" , strDocumentType );
        con.addData( "USER_ID" 			, "String" , strUserId );
        con.addData( "CURRENT_DATE" 	, "String" , strCurrentDate );
        
        bolnSuccess = con.executeService( strContainerName , strClassName , "deleteDocumentTypeUser"  );
        if( !bolnSuccess ){	
        	strmsg="showMsg(0,0,\" " + lc_cannot_cancel_permit_user + "\")";
        }else{	         
            strmsg="showMsg(0,0,\" " + lc_cancel_permit_user_successful + "\")";	         
        }			
		strMode = "SEARCH";
	}
	
	con.addData( "PROJECT_CODE" , "String" , strProjectCode );
    con.addData( "DOCUMENT_TYPE" , "String" , strDocumentType );

    bolnSuccess = con.executeService( strContainerName , strClassName , "findDocumentTypeUser"  );
    if( bolnSuccess ){	
    	while(con.nextRecordElement()){
    		strPermitUsers += con.getColumn("USER_ID") + ",";
    	}
    	
    	if(strPermitUsers.length() > 0){
    		strPermitUsers = strPermitUsers.substring(0,strPermitUsers.length()-1);
    	}
    }
    
    if(!strOldMode.equals("")){
    	strMode = strOldMode;
    }
	
	if(strMode.equals("SEARCH_INDEX")) {
		if(!strUserIdSearch.equals("")){
			con.addData( "USER_ID", 	 "String", strUserIdSearch);	
		}
		if(!strUserNameSearch.equals("")){
			con.addData( "USER_NAME", 	 "String", strUserNameSearch);	
		}
		if(!strUserSnameSearch.equals("")){
			con.addData( "USER_SNAME", 	 "String", strUserSnameSearch);	
		}
		if(!strUserOrgSearch.equals("")){
			con.addData( "USER_ORG", 	 "String", strUserOrgSearch);	
		}
		con.addData( "PAGESIZE", 	 "String", strPageSize);
	    con.addData( "PAGENUMBER", 	  "String", strPageNumber);
	    con.addData( "PROJECT_CODE" , "String" , strProjectCode );
        bolnSuccess = con.executeService( strContainerName , strClassName , "findProjectUserByIndex" );

        if( !bolnSuccess){
        	strErrorMessage = con.getRemoteErrorMesage();
        }else{
        	strTotalPage = con.getHeader( "PAGE_COUNT" );
	        strTotalSize = con.getHeader( "TOTAL_RECORD" );
	        
	        strOldMode = strMode;
        }	
	}
    
	if(strMode.equals("SEARCH")) {
		
		con.addData( "PAGESIZE", 	 "String", strPageSize);
	    con.addData( "PAGENUMBER", 	  "String", strPageNumber);
	    con.addData( "PROJECT_CODE" , "String" , strProjectCode );
        bolnSuccess = con.executeService( strContainerName , strClassName , "findProjectUser" );

        if( !bolnSuccess){
        	strErrorMessage = con.getRemoteErrorMesage();
        }else{
        	strTotalPage = con.getHeader( "PAGE_COUNT" );
	        strTotalSize = con.getHeader( "TOTAL_RECORD" );
        }	
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" >
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=TIS-620">
<title><%=lc_permit_user%></title>
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
<script language="javaScript" type="text/javascript">
<!--

function check_not_select_all() {
	document.getElementById("CHECK_ALL").checked = false;
}

function check_select_all(){
	var obj_chkAllCheck = document.getElementById("CHECK_ALL")
	var obj_elements 	= form1.elements;
    var len = obj_elements.length;
    
    if( obj_chkAllCheck.checked ) {
	    for ( var i=0; i<len; i++ ){
	        if ( obj_elements[i].type == "checkbox"){
	            obj_elements[i].checked = true;
	        }
	    }
	}else {
		for ( var i=0; i<len; i++ ){
	        if ( obj_elements[i].type == "checkbox"){
	            obj_elements[i].checked = false;
	        }
	    }
	}
}

function click_navigator( strValue ){

    var strPageNumber = form1.PAGENUMBER.value;
	var strTotalPage  = form1.TOTALPAGE.value;

	var intPageNumber = parseInt( strPageNumber );
	var intTotalPage  = parseInt( strTotalPage );

	switch( strValue ){
		case "first" :
				if( intPageNumber == 1 ){return;}
				form1.PAGENUMBER.value = 1;
				break;
		case "prev" :
				if( intPageNumber == 1 ){return;}
				form1.PAGENUMBER.value = intPageNumber - 1;
				break;
		case "next" :
				if( intPageNumber == intTotalPage ){return;}
				form1.PAGENUMBER.value = intPageNumber + 1;
				break;
		case "last" :
				if( intPageNumber == intTotalPage ){return;}
				form1.PAGENUMBER.value = intTotalPage;
				break;
	}

    form1.submit();
}

function set_check_permit(){
	var objCheckboxSelect = form1.CHK_SELECT;
	var objLabelSelect    = null;
	var bolnCheck 		  = false;
	var strConcatUserId   = "";
	
	if( objCheckboxSelect == null ){
		alert(lc_cannot_find_link_data);	
		return;
	}

	if( objCheckboxSelect.length ){
		for( var intCount = 0 ; intCount < objCheckboxSelect.length ; intCount++ ){
			bolnCheck = bolnCheck || objCheckboxSelect[ intCount ].checked;

			if( objCheckboxSelect[ intCount ].checked ){

				objLabelSelect = eval( "LABEL_SELECT" + intCount );

				if( objLabelSelect ){
					strConcatUserId	+= objLabelSelect.USER_ID + ",";
				}				
			}
		}

		if(strConcatUserId.length == 0){
			alert(lc_check_permit_user);
			return;
		}

		if( strConcatUserId.length > 0 ){
			strConcatUserId = strConcatUserId.substr( 0 , strConcatUserId.length - ",".length );
		}
	}else{
		bolnCheck = objCheckboxSelect.checked;

		objLabelSelect = eval( "LABEL_SELECT0" );

		if( objLabelSelect ){
			strConcatUserId = objLabelSelect.USER_ID;
		}
	}
	
	if(bolnCheck){
		form1.CONCAT_USER.value	= strConcatUserId;
	}
	return bolnCheck;
}
function click_set_permit(){
	if( set_check_permit() ){
		form1.MODE.value 		= "SET_PERMIT";
		form1.method 			= "post";
		form1.action 			= "document_type5.jsp";
		form1.submit();
	}
}

function click_not_permit(){
	if( set_check_permit() ){
		form1.MODE.value 		= "NOT_PERMIT";
		form1.method 			= "post";
		form1.action 			= "document_type5.jsp";
		form1.submit();
	}
}

function click_cancel(){
	var this_win = window.open("","_self","");
	this_win.close();
}

function click_search(){
	formSearch.submit();
}

function window_onload(){
	lb_doc_type_name.innerHTML  = lbl_doc_type_name;
	lb_user_id.innerHTML 		= lbl_user_profile1;
	lb_user_name.innerHTML 		= lbl_user_profile3_1;
	lb_user_org.innerHTML 		= lbl_user_profile3;
	lb_permit_access.innerHTML 	= lbl_permit;
}
//-->
</script>
</head>
<body onLoad="MM_preloadImages('images/btt_cancel_over.gif','images/btt_search_over.gif','images/btt_right_over.gif','images/btt_cancelright_over.gif');window_onload()">
<form name="form1" action="" method="post">	
	<table width="100%" border="0" align="center">
    	<tbody>
    		<col width="10%" />
    		<col width="76%" />
    		<col width="14%" />
    	</tbody>          
       	<tr>
           	<td height="25" colspan="3">
           	&nbsp;&nbsp;&nbsp;
       		</td>
       	</tr>
       	<tr>
       		<td height="25" ></td>
       		<td height="25" >
       			<span class="label_bold2" id="lb_doc_type_name"></span>&nbsp;
       			<input type="text" name="DOCUMENT_TYPE" class="input_box_disable" value="<%=strDocumentType%>" size="4">
       			<input type="text" name="DOCUMENT_TYPE_NAME" class="input_box_disable" value="<%=strDocumentTypeName%>" size="80" >
       		</td>
       		<td height="25" ></td>
       	</tr>
       	<tr>
           	<td height="20" colspan="3">
           	&nbsp;&nbsp;&nbsp;
       		</td>
       	</tr>
        <tr>
            <td align="center" class="label_bold2">&nbsp;</td>
            <td align="center" valign="top">
           		<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
            		<tr class="hd_table">
	                 	<td width="10" align="left"><img src="images/hd_tb_01.gif" width="10" height="28"></td>
	                 	<td width="45"><input type="checkbox" id="CHECK_ALL" onclick="check_select_all()"></td>
	                 	<td width="100"><div align="left"><span id="lb_user_id"></span></div></td>
	                 	<td width="200"><div align="left"><span id="lb_user_name"></span></div></td>
	                 	<td width="*"><div align="left"><span id="lb_user_org"></span></div></td>
	                 	<td width="60"><div align="left"><span id="lb_permit_access"></span></div></td>
	                 	<td width="10" align="right"><img src="images/hd_tb_04.gif" width="10"></td>
	              	</tr>
<%
			
			if((strMode.equals("SEARCH")||strMode.equals("SEARCH_INDEX")) && bolnSuccess){
				String	strUserIdData 		= "";
				String	strTitleName		= "";
				String	strUserName			= "";
				String	strUserSname		= "";
				String	strOrgName			= "";
				String	strFullName			= "";
				String	strPermitFlag		= "";
				int 	idx,count			= 0;
				
				while(con.nextRecordElement()) {
					idx = (count%2) + 1;
					strUserIdData 	= con.getColumn("USER_ID");
					strTitleName 	= con.getColumn("TITLE_NAME");
					strUserName 	= con.getColumn("USER_NAME");
					strUserSname 	= con.getColumn("USER_SNAME");
					strOrgName 		= con.getColumn("ORG_NAME");
					
					if(strTitleName.equals("-")){strTitleName="";}
					
					strFullName = strTitleName + strUserName + " " + strUserSname;
					
					if(strPermitUsers.indexOf(strUserIdData) != -1){
						strPermitFlag = "<img src=\"images/True.gif\" width=\"16\" height=\"16\" border=\"0\" >";
		            }else {
		            	strPermitFlag = "<img src=\"images/False.gif\" width=\"16\" height=\"16\" border=\"0\" >";
					}
%>	              	
	              	<tr class="table_data<%=idx%>">
	                 	<td>&nbsp;</td>
	                 	<td><div align="center"><input type="checkbox" name="CHK_SELECT" onclick="check_not_select_all()"></div></td>
	                 	<td><div align="left"><%=strUserIdData %></div></td>
	                 	<td align="left"><div align="left"><%=strFullName %></div></td>
	                 	<td><div align="left"><%=strOrgName %></div></td>
	                 	<td><div align="center"><%=strPermitFlag %></div></td>
	                 	<td width="10"><label id="LABEL_SELECT<%=count%>" USER_ID="<%=strUserIdData%>" ></label></td>
	              	</tr>
<%
					count++;
				}
			}else {
%>				
					<tr class="table_data1">
	                 	<td colspan="7"><div align="center"><%=strErrorMessage %></div></td>
	                </tr> 					
<%			}
%>	              	
	         	</table>
	         	<table width="100%" border="0" cellpadding="0" cellspacing="0" class="footer_table">
                	<tr> 
	                  	<td width="*" align="left">&nbsp;&nbsp;&nbsp;&nbsp;<%=lb_total_record %> <%=strTotalSize %> <%=lb_records %></td>
		              	<td width="*"><div align="right"><%=lb_page_no %> <%=strPageNumber %>/<%=strTotalPage %></div></td>
		              	<td width="137" align="center">
			              	<img src="images/first.gif" width="22" height="22" onclick="click_navigator('first')" style="cursor:pointer"> 
			                <img src="images/prv.gif" 	width="22" height="22" onclick="click_navigator('prev')" style="cursor:pointer"> 
			                <img src="images/next.gif" 	width="22" height="22" onclick="click_navigator('next')" style="cursor:pointer"> 
			                <img src="images/last.gif" 	width="22" height="22" onclick="click_navigator('last')" style="cursor:pointer">
	                	</td>
                	</tr>
              	</table>
      		</td>
        	<td>&nbsp;</td>
  		</tr>
        <tr>
	       <td colspan="3">&nbsp;</td>
	    </tr>
	    <tr>
	       	<td colspan="3"><div align="center">
	       		<a href="javascript:click_set_permit()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('btt_right','','images/btt_right_over.gif',1)"><img src="images/btt_right.gif" name="btt_right" height="22" border="0"></a>
	       		<a href="javascript:click_not_permit()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('btt_cancelright','','images/btt_cancelright_over.gif',1)"><img src="images/btt_cancelright.gif" name="btt_cancelright" height="22" border="0"></a>
	       		<a href="javascript:click_search()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('btt_search','','images/btt_search_over.gif',1)"><img src="images/btt_search.gif" name="btt_search" height="22" border="0"></a>
	       		<a href="javascript:click_cancel()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('btt_cancel','','images/btt_cancel_over.gif',1)"><img src="images/btt_cancel.gif" name="btt_cancel" height="22" border="0"></a>
	       </div></td>
		</tr>
	</table>
	<input type="hidden" name="MODE" 			value="<%=strMode%>">
	<input type="hidden" name="OLD_MODE" 		value="<%=strOldMode%>">
	
	<input type="hidden" name="DOCUMENT_TYPE" 		value="<%=strDocumentType%>">
	<input type="hidden" name="DOCUMENT_TYPE_NAME" 	value="<%=strDocumentTypeName%>">
	<input type="hidden" name="CONCAT_USER" 	value="" >
	<input type="hidden" name="METHOD" 			value="" >
	<input type="hidden" name="PAGENUMBER" 		value="<%=strPageNumber%>">
	<input type="hidden" name="TOTALPAGE"  		value="<%=strTotalPage%>">
	
	<input type="hidden" name="txtUserId"  	 	value="<%=strUserIdSearch%>">
	<input type="hidden" name="txtUserName"  	value="<%=strUserNameSearch%>">
	<input type="hidden" name="txtUserSname" 	value="<%=strUserSnameSearch%>">
	<input type="hidden" name="txtUserOrg"  	value="<%=strUserOrgSearch%>">
</form>	
<form name="formSearch" method="post" action="document_type6.jsp" target = "_self">
<input type="hidden" name="DOCUMENT_TYPE" 		value="<%=strDocumentType%>">
<input type="hidden" name="DOCUMENT_TYPE_NAME" 	value="<%=strDocumentTypeName%>">     
</form>		
</body>
</html>
<%  if (!strmsg.equals("")) {  %>
<script language="javaScript">
    <%=strmsg%>
</script>
<%  }   %>