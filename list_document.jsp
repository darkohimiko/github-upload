<%@page import="com.scc.edms.conf.ImageConfUtil"%>
<%@ page contentType="text/html; charset=tis-620"%>
<%@ page import="com.scc.security.UserInfo"%>
<%@ include file="inc/checkUser.jsp" %>
<%@ include file="inc/constant.jsp" %>
<%@ include file="inc/label.jsp" %>
<%@ include file="inc/utils.jsp" %>
<jsp:useBean id="con" scope="session" class="edms.cllib.EABConnector"/>
<jsp:useBean id="con2" scope="session" class="edms.cllib.EABConnector"/>
<jsp:useBean id="conDoc" scope="session" class="edms.cllib.EABConnector"/>
<jsp:useBean id="conList" scope="session" class="edms.cllib.EABConnector"/>
<jsp:useBean id="conLV" scope="session" class="edms.cllib.EABConnector"/>
<jsp:useBean id="conResult" scope="session" class="edms.cllib.EABConnector"/>
<jsp:useBean id="conAtt" scope="session" class="edms.cllib.EABConnector"/>
<jsp:useBean id="conAcc" scope="session" class="edms.cllib.EABConnector"/>
<%@page import="java.util.Random"%>
<%
	Random ran = new Random();
	String randomNo=String.valueOf(ran.nextLong());
	String strRand = "&randomNo="+ randomNo;
%>
<%
	con.setRemoteServer("EAS_SERVER");
	con2.setRemoteServer("EAS_SERVER");
	conDoc.setRemoteServer("EAS_SERVER");
	conLV.setRemoteServer("EAS_SERVER");
	conResult.setRemoteServer("EAS_SERVER");
	conAtt.setRemoteServer("EAS_SERVER");
	conAcc.setRemoteServer("EAS_SERVER");
	
	String securecode = "";
	if (!con.executeService("EASSYSTEM", "SECURECODE", "genSecurityCode")){
        out.println("Create Image Login Session Fail");
        return;
    }
    securecode = con.getHeader("SECURECODE");

	UserInfo userInfo = (UserInfo)session.getAttribute( "USER_INFO" );
	String strUserId        = userInfo.getUserId();
	String strUserName      = userInfo.getUserName();
	String strUserOrgName   = userInfo.getUserOrgName();
	String strUserLevel     = userInfo.getUserLevel();
	String strProjectCode 	= userInfo.getProjectCode();
	String strProjectName   = userInfo.getProjectName();
	String strUserEmail	= checkNull(session.getAttribute("USER_EMAIL"));
	
	String user_role      = checkNull(request.getParameter("user_role"));
	String app_name       = checkNull(request.getParameter("app_name"));
	String app_group      = checkNull(request.getParameter("app_group"));
	String screenname  	  = getField(request.getParameter("screenname"));

	String strAccessType    = (String)session.getAttribute( "ACCESS_TYPE" );
	String strAccessDocType = (String)session.getAttribute( "ACCESS_DOC_TYPE" );
	String strUserGroup     = (String)session.getAttribute( "USER_GROUP" );
	String strSecurityFlag  = (String)session.getAttribute( "SECURITY_FLAG" );
	String strAndDocTypeCon = "";
	String strCount         = "";
        String strWaterMarkFlag = "";
	
	String 	strClassName 	 = "EDIT_DOCUMENT";
	String  strLangFlag      = "";
	String	strCurrentDate 	 = "";
        String  strContainerType = ImageConfUtil.getInetContainerType();

        String strVersionLang  = ImageConfUtil.getVersionLang();
	
	if(strVersionLang.equals("thai")){
		strCurrentDate = getTodayDateThai();
		strLangFlag    = "1";
	}else{
		strCurrentDate = getTodayDate();
		strLangFlag    = "0";
	}
	
	String	strPageNumber = checkNull(request.getParameter("PAGENUMBER"));
	String	strPageSize   = checkNull(request.getParameter("PAGE_SIZE"));
	
	String 	strSortField  = checkNull(request.getParameter("SORT_FIELD"));
	String 	strOrderBy 	  = checkNull(request.getParameter("ORDER_BY"));
	String	strOrderType  = checkNull(request.getParameter("ORDER_TYPE"));
	
	String	strMethod = request.getParameter( "METHOD" );
	String	strDocumentType   	= checkNull(request.getParameter("DOCUMENT_TYPE"));
	String	strDocumentTypeName = getField(request.getParameter("DOCUMENT_TYPE_NAME"));
	String 	strConcatFieldName 	= checkNull( request.getParameter( "CONCAT_FIELD_NAME" ) );
	String 	strConcatFieldLabel	= checkNull( request.getParameter( "CONCAT_FIELD_LABEL" ) );
	String 	strConcatFieldIndex = checkNull( request.getParameter( "CONCAT_FIELD_INDEX" ) );
	
	String strDocumentFieldValue = getField( request.getParameter( "DOCUMENT_FIELD_VALUE" ) );
	
	String 	strConcatTableZoom	 = "";
	String 	strConcatFieldType	 = "";
	
	String	strMasterScan = "MASTER_SCAN_" + strProjectCode;
	
	String	strMasterHeader = "";
	String	strSQLHeader 	= "";
	String	strSQLJoinTable = "";
	String	strSQLcondition = "";
	String	strFieldTyp 	= "";
	String	strFieldCode 	= "";
	String	strFieldLbel	= "";
	String	strTableZoom	= "";
	String	strColumnName	= "";
	String	strColumnCode	= "";
	String	strPermission	= "";
	String	strBttFunction	= "";
	
	
	
	String	strTotalPage  = "1";	
	String	strTotalSize  = "0";
	
	if(strPageNumber.equals("")){
		strPageNumber = "1";
	}
	if(strPageSize.equals("")){
		strPageSize = "20";
	}
	
	if(strSortField.equals("")){
		strSortField = "DOCUMENT_NO";		
	}	
	
	if(strOrderBy.equals("")){
		strOrderBy = "DESC";		
	}
	
	if(!strOrderType.equals(strOrderBy)){
		strOrderType = strOrderBy;
	}
	
	if(strMethod == null || strMethod.equals("")){
		strMethod = "INIT";
	}
	
	boolean bolnSuccess 	  = false;
	boolean bolFieldSuccess   = false;
	boolean bolSuccesccSearch = false;
	boolean bolnAccType       = false;
	
	con.addData("USER_ROLE", 		 "String", user_role);
	con.addData("APPLICATION", 	  	 "String", app_name);
    con.addData("APPLICATION_GROUP", "String", app_group);
    bolnSuccess = con.executeService(strContainerName, "DOCUMENT_TYPE", "findPermission");
    if(bolnSuccess) {
    	while(con.nextRecordElement()) {
    		strPermission = con.getColumn("PERMIT_FUNCTION");
    	}
    }
    
    if(strPermission.indexOf("export") != -1){
 	//	strBttFunction = "<a href=\"javascript:click_xml()\" onMouseOut=\"MM_swapImgRestore()\" onMouseOver=\"MM_swapImage('i_export','','images/i_export_over.jpg',1)\"><img src=\"images/i_export.jpg\" name=\"i_export\" width=\"56\" height=\"62\" border=0></a>";
 		strBttFunction += "<a href=\"javascript:click_excel()\" onMouseOut=\"MM_swapImgRestore()\" onMouseOver=\"MM_swapImage('i_export_excel','','images/i_export-excel_over.jpg',1)\"><img src=\"images/i_export-excel.jpg\" name=\"i_export_excel\" width=\"56\" height=\"62\" border=0></a>";
    }
    
    con.addData("PROJECT_CODE", "String", strProjectCode);
    bolnSuccess = con.executeService(strContainerName, "PROJECT_MANAGER", "findWaterMarkFlag");
	if(bolnSuccess){
		strWaterMarkFlag = con.getHeader("WATERMARK_FLAG");
	}else{
		strWaterMarkFlag = "N";
	}
    
    if( strAccessType.equals("A") ) {
    	strSQLcondition += " ";
    }else if( strAccessType.equals("L") ){
		strSQLcondition += " AND MASTER_SCAN_" + strProjectCode + ".DOCUMENT_LEVEL <= " + strUserLevel + " ";
	}else if( strAccessType.equals("O") ){
		//strSQLcondition += " AND MASTER_SCAN_" + strProjectCode + ".SCAN_ORG = '" + strUserOrg + "' ";
		if( strSecurityFlag.equals("I") ) {
			//strSQLcondition += " AND MASTER_SCAN_" + strProjectCode + ".SCAN_ORG IN (SELECT OWNER_ORG FROM USER_ACCESS_BY_OWNER_ORG WHERE PROJECT_CODE='"+ strProjectCode +"' AND USER_ID='"+ strUserId +"') ";
			strSQLcondition += " AND MASTER_SCAN_" + strProjectCode + ".DOCUMENT_ORG IN (SELECT OWNER_ORG FROM USER_ACCESS_BY_OWNER_ORG WHERE PROJECT_CODE='"+ strProjectCode +"' AND USER_ID='"+ strUserId +"') ";

			conAcc.addData( "PROJECT_CODE", strProjectCode );
			conAcc.addData( "USER_ID",      strUserId );
			bolnAccType = conAcc.executeService( strContainerName, strClassName, "countUserAccessByOwnerUser" );
			if( bolnAccType ) {
				while( conAcc.nextRecordElement() ) {
					strCount = conAcc.getColumn( "CNT" );
				}
			}
			if( !strCount.equals("") && !strCount.equals("0") ) {
				strSQLcondition += " AND MASTER_SCAN_" + strProjectCode + ".DOCUMENT_USER IN (SELECT OWNER_USER FROM USER_ACCESS_BY_OWNER_USER WHERE PROJECT_CODE='"+ strProjectCode +"' AND USER_ID='"+ strUserId +"') ";
			}
		}else {
			//strSQLcondition = " AND MASTER_SCAN_" + strProjectCode + ".SCAN_ORG IN (SELECT OWNER_ORG FROM GROUP_ACCESS_BY_OWNER_ORG WHERE PROJECT_CODE='"+ strProjectCode +"' AND USER_GROUP='"+ strUserGroup +"') ";
			strSQLcondition = " AND MASTER_SCAN_" + strProjectCode + ".DOCUMENT_ORG IN (SELECT OWNER_ORG FROM GROUP_ACCESS_BY_OWNER_ORG WHERE PROJECT_CODE='"+ strProjectCode +"' AND USER_GROUP='"+ strUserGroup +"') ";

			conAcc.addData( "PROJECT_CODE", strProjectCode );
			conAcc.addData( "USER_GROUP",   strUserGroup );
			bolnAccType = conAcc.executeService( strContainerName, strClassName, "countGroupAccessByOwnerUser" );
			if( bolnAccType ) {
				while( conAcc.nextRecordElement() ) {
					strCount = conAcc.getColumn( "CNT" );
				}
			}
			if( !strCount.equals("") && !strCount.equals("0") ) {
				strSQLcondition += " AND MASTER_SCAN_" + strProjectCode + ".DOCUMENT_USER IN (SELECT OWNER_USER FROM GROUP_ACCESS_BY_OWNER_USER WHERE PROJECT_CODE='"+ strProjectCode +"' AND USER_GROUP='"+ strUserGroup +"') ";
			}
		}
	}
	
    if( strAccessDocType.equals("A") ) {
    	strAndDocTypeCon = " ";
    }else if( strAccessDocType.equals("L") ) {
		strAndDocTypeCon = " AND MASTER_SCAN_" + strProjectCode + ".DOCUMENT_LEVEL <= '"+ strUserLevel +"'";
	}else {
		if( strSecurityFlag.equals("I") ) {
			strAndDocTypeCon = " AND DOCUMENT_TYPE IN (SELECT DOCUMENT_TYPE FROM DOCUMENT_TYPE_USER WHERE PROJECT_CODE='"+ strProjectCode +"' AND USER_ID='"+ strUserId +"')";
		}else {
			strAndDocTypeCon = " AND DOCUMENT_TYPE IN (SELECT DOCUMENT_TYPE FROM DOCUMENT_TYPE_GROUP WHERE PROJECT_CODE='"+ strProjectCode +"' AND USER_GROUP='"+ strUserGroup +"')";
		}
	}
    
	con.addData( "PROJECT_CODE",            "String", strProjectCode );
	con.addData( "DOCUMENT_TYPE_CONDITION", "String", strAndDocTypeCon );
    bolnSuccess = con.executeService( strContainerName , "DOCUMENT_TYPE" , "findDocumentType" );

    if( !bolnSuccess){
    	out.println("Error :: " + con.getRemoteErrorMesage());
    }else{
    	/*
    	if(con.getRecordTotal() == 1){
    		conResult.addData("DOCUMENT_TYPE", "String", con.getHeader("DOCUMENT_TYPE"));
    	//	strSQLcondition = " AND TO_CHAR(" + strMasterScan + ".UPD_DATE, 'YYYYMMDD') = (SELECT MAX(TO_CHAR("+ strMasterScan + ".UPD_DATE, 'YYYYMMDD')) FROM " + strMasterScan + ") ";
    		strPageNumber 	= "1";
    		if(strMethod.equals("INIT")){
    			strMethod 		= "SEARCH";
			}
    	}
    	*/
    }
    
    strMasterHeader = strMasterScan + ".BATCH_NO," + strMasterScan + ".DOCUMENT_RUNNING";
    
    if(!strMethod.equals("")){
    	con2.addData("PROJECT_CODE", "String", strProjectCode);
    	con2.addData("INDEX_TYPE", 	"String", "R");
        bolFieldSuccess = con2.executeService(strContainerName, "EDIT_DOCUMENT", "findDocumentIndex");
        if(bolFieldSuccess){
        	int cnt = 0;        	
        	while(con2.nextRecordElement()){
        		strFieldLbel = con2.getColumn("FIELD_LABEL");
        		strConcatFieldLabel += strFieldLbel + ",";
        		
        		strFieldCode = con2.getColumn("FIELD_CODE");
        		strConcatFieldIndex += strFieldCode + ",";
        		
        		strFieldTyp = con2.getColumn("FIELD_TYPE");    		
        		strTableZoom = con2.getColumn("TABLE_ZOOM");
        		
        		strConcatFieldType += strFieldTyp + ",";
        		
        		strMasterHeader += "," + strMasterScan + "." + strFieldCode ; 
      		
        		if( strFieldTyp.equals("ZOOM")||strFieldTyp.equals("LIST")||strFieldTyp.equals("MONTH")||strFieldTyp.equals("MONTH_ENG") ){
        			strSQLHeader 	+= 	",T" + cnt + "." + strTableZoom + "_NAME";
        			strSQLJoinTable += 	" LEFT JOIN " + strTableZoom + " T" + cnt
        							+ 	" ON(MASTER_SCAN_" + strProjectCode + "." + strFieldCode + "=" 
        							+ 	"T" + cnt + "." + strTableZoom + " )";
        			
        			strConcatTableZoom += strTableZoom + ",";
        			
        			cnt++;
        			
        		}else if(strFieldTyp.equals("DATE")){
        			strConcatTableZoom += "date,";	
        		}else if(strFieldTyp.equals("DATE_ENG")){
        			strConcatTableZoom += "date_eng,";	
        		}else if(strFieldTyp.equals("NUMBER")){
        			strConcatTableZoom += "number,";
        		}else if(strFieldTyp.equals("CURRENCY")){
        			strConcatTableZoom += "currency,";	
        		}else if(strFieldTyp.equals("TIN")||strFieldTyp.equals("PIN")){
        			if(strFieldTyp.equals("TIN")){
        				strConcatTableZoom += "tin,";
        			}else{
        				strConcatTableZoom += "pin,";
        			}
        		}else {
        			strConcatTableZoom += "not,";	
        		}
        	}
        	strMasterHeader += "," + strMasterScan + ".DOCUMENT_NAME";
        	strMasterHeader += "," + strMasterScan + ".DOCUMENT_USER";
        }
    }
    
    if(strMethod.equals("SEARCH_DOCTYPE")){
    	conResult.addData("DOCUMENT_TYPE", "String", strDocumentType);
    	strPageNumber 	= "1";
    }
    
    if(strMethod.equals("SEARCH_DETAIL_INDEX")){
    	conResult.addData("DOCUMENT_TYPE", "String", strDocumentType);
    	strSQLcondition = " AND " + strDocumentFieldValue;
    }
    
    if(strMethod.equals("SEARCH_ALL")){
    	conResult.addData("DOCUMENT_TYPE", "String", strDocumentType);
    	strSQLcondition = "";
    }
    
    if(!strMethod.equals("INIT")){
    	conResult.addData("PROJECT_CODE", 	 "String", strProjectCode);
    	conResult.addData("PAGESIZE", 		 "String", strPageSize);
    	conResult.addData("PAGENUMBER", 	 "String", strPageNumber);
    	conResult.addData("MASTER_HEADER", 	 "String", strMasterHeader);
    	conResult.addData("QUERY_HEADER", 	 "String", strSQLHeader);
    	conResult.addData("QUERY_CONDITION", "String", strSQLcondition);
    	conResult.addData("JOIN_TABLE", 	 "String", strSQLJoinTable);
    	conResult.addData("ORDER_TYPE", 	 "String", strOrderType);	    
    	conResult.addData("SORT_FIELD" , 	 "String", strSortField );
    	conResult.addData("SORT_BY" , 		 "String", strOrderBy );
    	bolSuccesccSearch = conResult.executeService(strContainerName, "LIST_DOCUMENT", "findMasterScanResult");
        if(bolSuccesccSearch){
        	strTotalPage = conResult.getHeader( "PAGE_COUNT" );
	        strTotalSize = conResult.getHeader( "TOTAL_RECORD" );
        }
    }
   
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title><%=lc_system_name %> <%=lc_site_name%></title>
<meta http-equiv="Content-Type" content="text/html; charset=windows-874">
<script language="JavaScript" type="text/javascript">
<!--
function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
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
<script language="JavaScript" src="js/function/inet-utils.js"></script>
<script language="JavaScript" src="js/sccUtils.js"></script>
<script language="JavaScript" src="js/offlineUtils.js"></script>
<script language="JavaScript" src="js/util.js"></script>
<script language="JavaScript" src="js/constant.js"></script>
<script language="JavaScript" src="js/label.js"></script>
<script language="JavaScript" src="js/waterMark.js"></script>
<script language="javascript" type="text/javascript">
<!--
var sccUtils = new SCUtils();
var offUtils = new offlineUtils();
var waterMk  = new waterMark();
var check_current_date = false;
var objZoomWindow;
var objDocumentDetail;
var objDetailScanWindow;

///////////// Button Function /////////////////
function click_new(){
	
	form1.METHOD.value 				 = "NEW";
	form1.PAGENUMBER.value 		  	 = "1";
	form1.DOCUMENT_TYPE.value 	  	 = "";
	form1.DOCUMENT_TYPE_NAME.value 	 = "";
	form1.DOCUMENT_FIELD_VALUE.value = "";
	submit_form();
}

function click_excel(){
	showExportExcelWindow();
	//formExcel.submit();
}

function click_xml(){
	showExportXMLWindow();
}

function click_search_all(){
	if(check_document_typ()){
		return;
	}	
	if(!showMsg( 0 , 1 , lc_alert_for_search_all )){
		return;
	}
	form1.PAGENUMBER.value 	= "1";
	form1.METHOD.value 		= "SEARCH_ALL";
	submit_form();
}

function click_cancel(){
	top.location = "caller.jsp?header=header1.jsp&detail=user_menu.jsp<%=strRand%>";
}

function clear_search_index(){
	var arrField = form1.CONCAT_FIELD_NAME.value.split( "," );
	var objDocumentField;
	for( var intCount = 0 ; intCount < arrField.length ; intCount++ ){
		objDocumentField = eval( "form1." + arrField[ intCount ]);
		objDocumentField.value = "";
		
		if(eval( "form1.TO_" + arrField[ intCount ]) != null){
			openToDate(arrField[ intCount ]);
		}
	
		if(eval("form1.selOperator" + (intCount+1)) != null ){
			eval("form1.selOperator" + (intCount+1) + ".selectedIndex = 0");
		}
		
		if(eval("form1.selCondition" + (intCount+1)) != null ){
			eval("form1.selCondition" + (intCount+1) + ".selectedIndex = 0");
		}
	}
	
	form1.hidDocumentUser.value    = "";
	form1.chkDocumentUser2.checked = false;
	check_current_date = false;
}

function click_search_index(){
	if(check_document_typ()){
		return;
	}
	set_concat_document_field();
	
	if(check_current_date){
		return;
	}
	
	if(form1.DOCUMENT_FIELD_VALUE.value == ""){
		showMsg( 0 , 0 , lc_choose_one_more );
		return;
	}
	
	form1.METHOD.value = "SEARCH_DETAIL_INDEX";
	submit_form();
}

function submit_form(){
	form1.method = "post";
	form1.action = "_self";
	form1.action = "list_document.jsp";
	form1.submit();
}

///////////// Index Function ////////////////////

function field_press( objField ){
	if( sccUtils.isEnter() ){
		window.event.keyCode = 0;
		switch( objField.name ){
			case "BATCH_NO" : 
					form1.DOCUMENT_NAME.focus();
					break;
			case "DOCUMENT_NAME" : 
					form1.ADD_DATE.focus();
					break;
			case "ADD_DATE" : 
					form1.TO_ADD_DATE.focus();
					break;
			case "TO_ADD_DATE" : 
					form1.EDIT_DATE.focus();
					break;
			case "EDIT_DATE" : 
					form1.TO_EDIT_DATE.focus();
					break;
			case "TO_EDIT_DATE" : 
					var arrField = form1.CONCAT_FIELD_NAME.value.split( "," );
					var objNextField;
					for( var intCount = 0 ; intCount < arrField.length ; intCount++ ){
						objNextField = eval( "form1." + arrField[ intCount ] );
						if( objNextField != null && !objNextField.readOnly && objNextField.type != "hidden" ){
							objNextField.focus();
							return;
						}
					}
					break;									
			default : 
			
					set_mask(objField,objField.getAttribute("value_type"));
				
					var arrField = form1.CONCAT_FIELD_NAME.value.split( "," );
					var objNextField,objTodate;
					for( var intCount = 0 ; arrField[ intCount ] != objField.name ; intCount++ ){}
					intCount++;
					while( intCount < arrField.length ){
						objNextField = eval( "form1." + arrField[ intCount ] );
						if( objNextField != null && !objNextField.readOnly && objNextField.type != "hidden" ){
							objNextField.focus();
							return;
						}
						intCount++
					}
					break;
		}
	}
}

function set_mask(objField,objType){
	objField.value = sccUtils.unMask( objField.value );
	if( objType == "tin" ){
		objField.value = sccUtils.maskTIN( objField.value );
	}
	
	if( objField.getAttribute("value_type") == "pin" ){		
		objField.value = sccUtils.maskPIN( objField.value );
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

function keypress_currency( input_obj){
	var carCode = event.keyCode;
	
	if(carCode == 46) {
		if(input_obj.value.indexOf(".")!= -1){
        if( event.preventDefault ){
            event.preventDefault();
        }else{
            event.returnValue = false;
        }
        return;
		}
		
	}else {
		if ((carCode < 48) || (carCode > 57)){
		 	if(carCode != 46) {
        if( event.preventDefault ){
            event.preventDefault();
        }else{
            event.returnValue = false;
        }
        return;
			}
		}
	}
}

function set_format_date( obj_field ){
	if( obj_field.value.length == 8 && sccUtils.isDateValid( obj_field.value ) == "VALID_DATE" ){
		obj_field.value = sccUtils.formatDate( obj_field.value );
	}
}

function openToDate( objTodate){
	var obj_to_date = eval("form1.TO_" + objTodate);
	var obj_img		= document.getElementById("img_" + objTodate)
	if(eval("form1."+ objTodate +".value") != ""){
		obj_to_date.readOnly 	= false;
		obj_to_date.className 	= "input_box";
		obj_to_date.focus();
		obj_img.style.display	='inline';
		
	}else{
		obj_to_date.readOnly = true;
		obj_to_date.className 	= "input_box_disable";
		obj_to_date.value 		= "";
		obj_img.style.display	='none';
	}
}

function openZoom( strZoomType , strZoomLabel , objDisplayText , objDisplayValue, strTableLevel ){
	var strPopArgument 	= "scrollbars=yes,status=no";
	var strWidth 		= ",width=370px";
	var strHeight 		= ",height=420px";
	var strUrl 			= "";
	var strConcatField 	= "";

	strPopArgument += strWidth + strHeight;
	
	var strFieldLV2 = eval("form1.FIELD_" + strZoomType + "_LV2"); 
	var strFieldLV3 = eval("form1.FIELD_" + strZoomType + "_LV3");
	
	switch( strTableLevel ){
		case "1" :
				strUrl = "inc/zoom_data_table_level1.jsp";
				strConcatField  = "TABLE=" + strZoomType;
				strConcatField += "&TABLE_LABEL=" + strZoomLabel;
				
				strConcatField += "&TABLE_LABEL=" + strZoomLabel;
				strConcatField += "&RESULT_FIELD=" + objDisplayValue.name + "," + objDisplayText.name;
				
				if( strFieldLV2 != null ){
					strConcatField += "&CLEAR_FIELD=" + strFieldLV2.value + ",DSP_" + strFieldLV2.value;
				}
				if( strFieldLV3 != null ){
					strConcatField += "," + strFieldLV3.value + ",DSP_" + strFieldLV3.value;
				}
				break;
		case "2" :
				if( !validate_level1(eval("form1.FIELD_" + strZoomType + "_LV1"),eval("form1.FIELD_" + strZoomType + "_LV1_LABEL.value")) ){
					return;
				}
				
				var strTableLv1 = eval("form1.FIELD_" + strZoomType + "_LV1.value");
				
				strUrl = "inc/zoom_data_table_level2.jsp";
				strConcatField  = "TABLE=" + strZoomType;
				strConcatField += "&TABLE_LABEL=" + strZoomLabel;
				
				strConcatField += "&TABLE_LV1=" + eval("form1.FIELD_" + strZoomType + "_LV1_CODE.value");
				strConcatField += "&TABLE_LV1_LABEL=" + eval("form1.FIELD_" + strZoomType + "_LV1_LABEL.value");
				strConcatField += "&TABLE_LV1_CODE=" + eval("form1." + strTableLv1 + ".value");
				strConcatField += "&TABLE_LV1_NAME=" + eval("form1.DSP_" + strTableLv1 + ".value");
				
				strConcatField += "&TABLE_LABEL=" + strZoomLabel;
				strConcatField += "&RESULT_FIELD=" + objDisplayValue.name + "," + objDisplayText.name;
				
				if( strFieldLV3 != null ){
					strConcatField += "&CLEAR_FIELD=" + strFieldLV3.value + ",DSP_" + strFieldLV3.value;
				}
				
				break;
		case "3" :
				if( !validate_level1(eval("form1.FIELD_" + strZoomType + "_LV1"),eval("form1.FIELD_" + strZoomType + "_LV1_LABEL.value")) ){
					return;
				}
				if( !validate_level2(eval("form1.FIELD_" + strZoomType + "_LV2"),eval("form1.FIELD_" + strZoomType + "_LV2_LABEL.value")) ){
					return;
				}
				
				var strTableLv1 = eval("form1.FIELD_" + strZoomType + "_LV1.value");
				var strTableLv2 = eval("form1.FIELD_" + strZoomType + "_LV2.value");
				
				strUrl = "inc/zoom_data_table_level3.jsp";
				strConcatField = "TABLE=" + strZoomType;
				strConcatField += "&TABLE_LABEL=" + strZoomLabel;
				
				strConcatField += "&TABLE_LV1=" + eval("form1.FIELD_" + strZoomType + "_LV1_CODE.value");
				strConcatField += "&TABLE_LV1_LABEL=" + eval("form1.FIELD_" + strZoomType + "_LV1_LABEL.value");
				strConcatField += "&TABLE_LV1_CODE=" + eval("form1." + strTableLv1 + ".value");
				strConcatField += "&TABLE_LV1_NAME=" + eval("form1.DSP_" + strTableLv1 + ".value");
				
				strConcatField += "&TABLE_LV2=" + eval("form1.FIELD_" + strZoomType + "_LV2_CODE.value");
				strConcatField += "&TABLE_LV2_LABEL=" + eval("form1.FIELD_" + strZoomType + "_LV2_LABEL.value");
				strConcatField += "&TABLE_LV2_CODE=" + eval("form1." + strTableLv2 + ".value");
				strConcatField += "&TABLE_LV2_NAME=" + eval("form1.DSP_" + strTableLv2 + ".value");
				
				strConcatField += "&TABLE_LABEL=" + strZoomLabel;
				strConcatField += "&RESULT_FIELD=" + objDisplayValue.name + "," + objDisplayText.name;
				break;
		
		default : 
				strUrl = "inc/zoom_data_table_level1.jsp";
				strConcatField = "TABLE=" + strZoomType;
				strConcatField += "&TABLE_LABEL=" + strZoomLabel;
				strConcatField += "&RESULT_FIELD=" + objDisplayValue.name + "," + objDisplayText.name;
				break;
	}


	objZoomWindow = window.open( strUrl + "?" + strConcatField , "zm" + strZoomType , strPopArgument );
	objZoomWindow.focus();
}

////////////// Validate Function //////////////////////

function check_document_typ(){
	if(form1.DOCUMENT_TYPE.value == ""){
		alert( lc_select_document_type_before_search );
		return true;
	}
	return false;
}

function validate_date(obj_date){

	if(sccUtils.dateToDb(obj_date.value).length < 8){
    	 	alert( lc_day_invalid );
    	 	obj_date.focus();
	        obj_date.select();
	        return false;
    	 }
    	 
    	 if(obj_date.value.length != 10){
    	 	alert( lc_day_invalid );
    	 	obj_date.focus();
	        obj_date.select();
	        return false;
    	 }
    	 
   /* 	 if(sccUtils.dateToDb(obj_date.value)> <%=strCurrentDate%>){
    	 	alert( lc_verify_check_date );
    	 	obj_date.focus();
    	 	obj_date.select();
	        return false;
    	 }
    */	 
   	 return true;   	
}

function validate_level1(obj_lv1,label_lv1){
	if( obj_lv1 != null ){
		var objProv = eval( "form1." + obj_lv1.value );
		if( objProv != null && objProv.value == "" ){
			
            showMsg( 0 , 0 , lc_check + label_lv1 );
            return false;
		}
	}
	return true;
}

function validate_level2(obj_lv2,label_lv2){
	if( obj_lv2 != null ){
		var objAmp = eval( "form1." + obj_lv2.value );
		if( objAmp != null && objAmp.value == "" ){
			
            showMsg( 0 , 0 , lc_check + label_lv2 );
            return false;
		}
	}
	return true;
}

function set_concat_document_field(){
	var arrField = form1.CONCAT_FIELD_NAME.value.split( "," );
	var strFieldValue  			  = "";
	var strConcatFieldValue 	  = "";
	var strConcatToDateFieldValue = "";
	var strOperatorValue 		  = "";
	var strDocumentFieldValue     = "";

	var objDocumentField;
	var objDspDocumentField;
	var objConditionList;
	var objOperatorList;
	
	var intIndex = 0;

	for( var intCount = 0 ; intCount < arrField.length ; intCount++ ){
		objDocumentField = eval( "form1." + arrField[ intCount ] );
		strDocumentFieldValue = objDocumentField.value;

		if(objDocumentField.name.indexOf( "DSP_" ) == -1){
			intIndex++;
		}
				
		if( objDocumentField != null && objDocumentField.name.indexOf( "DSP_" ) == -1 && objDocumentField.value.length > 0 ){
			
			objConditionList = eval("form1.selCondition" + intIndex);
			objOperatorList  = eval("form1.selOperator"  + intIndex);

			if(objOperatorList.value == "%A%"){
				strOperatorValue = " LIKE ";
				strDocumentFieldValue	 = "%" + strDocumentFieldValue + "%"; 
			}else if(objOperatorList.value == "A%"){
				strOperatorValue = " LIKE ";
				strDocumentFieldValue	 = strDocumentFieldValue + "%"; 
			}else{
				strOperatorValue = objOperatorList.value; 
			}
	
			switch( objDocumentField.getAttribute("value_type") ){
				case "number" :
					strFieldValue = strDocumentFieldValue;
					break;
				case "date" :
				case "date_eng" :
					
					if(!validate_date(objDocumentField)){
						check_current_date =  true;
					}else{
						check_current_date = false;
					}
					
					strFieldValue = "'" + sccUtils.dateToDb( objDocumentField.value ) + "'";
					
					objDspDocumentField = eval( "form1.TO_" + objDocumentField.name );
					if(objDspDocumentField.value != "" ){
						strConcatToDateFieldValue = " AND " + objDocumentField.name + "<= '" + sccUtils.dateToDb(objDspDocumentField.value) + "')";
					}
					break;
				case "zoom" :
					objDspDocumentField = eval( "form1." + objDocumentField.name );
					strFieldValue = "'" + objDspDocumentField.value + "'";
					
					break;
				case "tin" :
				case "pin" :
					strFieldValue = sccUtils.unMask( objDocumentField.value );
					if(objOperatorList.value == "%A%"){
						strFieldValue = "'%" + strFieldValue + "%'";
					}else if(objOperatorList.value == "A%"){
						strFieldValue = "'" + strFieldValue + "%'";
					}else{
						strFieldValue = "'" + strFieldValue + "'";
					}
					break;
				default :
					strFieldValue = "'" + strDocumentFieldValue.replace(/'/g,"''") + "'";
					break;
			}
			
			if((objDocumentField.getAttribute("value_type") == "date" || objDocumentField.getAttribute("value_type") == "date_eng")&&(strConcatToDateFieldValue != "")){
				strConcatFieldValue += " (" + objDocumentField.name + ">=" + strFieldValue + strConcatToDateFieldValue + " " + objConditionList.value + " ";
			}else{
				//strConcatFieldValue += " " + objDocumentField.name + strOperatorValue + strFieldValue + " " + objConditionList.value + " ";
				strConcatFieldValue += " " + "LOWER(" + objDocumentField.name + ")" + strOperatorValue + "LOWER(" + strFieldValue + ")" + " " + objConditionList.value + " ";
			}
			
			strConcatToDateFieldValue = "";
		}
	}

	if( strConcatFieldValue.length == 0 ) {
		if( form1.chkDocumentUser2.checked ) {
			strConcatFieldValue += " DOCUMENT_USER='" + form1.USER_ID.value +"'";
		}else {
			strConcatFieldValue += "";
		}
	}else {
		if( form1.chkDocumentUser2.checked ) {
			strConcatFieldValue += " DOCUMENT_USER='" + form1.USER_ID.value +"' " +objConditionList.value;
			strConcatFieldValue = strConcatFieldValue.substr( 0 , strConcatFieldValue.lastIndexOf( objConditionList.value ) );
		}else {
		//if( strConcatFieldValue.length > 0 ){
			strConcatFieldValue = strConcatFieldValue.substr( 0 , strConcatFieldValue.lastIndexOf( objConditionList.value ) );
		}
	}

	form1.DOCUMENT_FIELD_VALUE.value = strConcatFieldValue;
}

///////////// Other Function //////////////////////

function showExportXMLWindow(){
	iframeXML.location =  "importexport/export_xmldata.jsp";
	divXML.style.visibility = "visible";
}

function closeExportXMLWindow( bolnSuccess ){
	if( bolnSuccess != null && bolnSuccess ){
		alert( lc_export_success );
	}
	divXML.style.visibility = "hidden";
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

function change_div( tab_name ) {

	var div_obj = document.getElementById("div_" + tab_name);
	var img_obj = document.getElementById("img_" + tab_name);
	
	if(div_obj.style.display == 'none' ){
		div_obj.style.display = 'inline';
		img_obj.src = "images/" + tab_name + "_down.gif";
	}else {
		div_obj.style.display = 'none';
		img_obj.src = "images/" + tab_name + ".gif";
	}
}

function get_document_type(doc_type,doc_type_name){
	lb_doc_type_selected.innerHTML = doc_type_name;
	form1.DOCUMENT_TYPE.value 	   = doc_type;
	form1.DOCUMENT_TYPE_NAME.value = doc_type_name;
	form1.METHOD.value			   = "SEARCH_DOCTYPE";
	submit_form();
}

function change_result_per_page(){
	form1.submit();	
}

function click_sort( sort_field, order_type) {
	form1.SORT_FIELD.value = sort_field;
	form1.ORDER_BY.value   = order_type;
	
	form1.submit();
}

function open_detail( row_obj){
	var batch_no 	 = row_obj.BATCH_NO;
	var doc_running  = row_obj.DOCUMENT_RUNNING;
	var	project_code = row_obj.PROJECT_CODE;
	var	project_name = row_obj.PROJECT_NAME;
	var	doc_name     = row_obj.DOCUMENT_NAME;
	var	doc_user     = row_obj.DOCUMENT_USER;
	
	if(batch_no == ""){
		return;			
	}
	
	var strUrl = "detail_search.jsp?PROJECT_CODE=" + project_code + "&PROJECT_NAME=" + project_name 
                    + "&user_role=<%=user_role%>&app_name=<%=app_name%>&app_group=<%=app_group%>"
                    + "&BATCH_NO=" + batch_no + "&DOCUMENT_RUNNING=" + doc_running + "&DOCUMENT_NAME=" + doc_name + "&DOCUMENT_USER=" + doc_user;
			   
	objDocumentDetail = sccUtils.openChildWindow( "DOCUMENT_DETAIL" );
	objDocumentDetail.location = strUrl;
	
	get_log(batch_no,doc_running);
}

function openShowView( strBatchno , strDocumentRunning, strDocumentType, strBlobId , strBlobPart ){
    initAndShow();
    setMail();
    setWaterMark();
    setOfflineDoc(strBatchno , strDocumentRunning , strDocumentType);
    retrieveImage( strBlobId , strBlobPart );
}

function initAndShow(){
    var x,y,w,h;
    var permit = set_inet_permission("<%=strPermission%>");
    x = screen.width /2;
    y = 0;
    w = screen.width;
    h = screen.height;
    inetdocview.Close();
    inetdocview.Open();
    inetdocview.UserLevel("<%=strUserLevel%>");
    inetdocview.Resize(x, y, w, (h-30));
    inetdocview.ContainerType("<%=strContainerType%>");
    inetdocview.SetProperty("RemoveToolBar", rem_toolbar);
    inetdocview.SetProperty("RemoveToolBar", permit);
    inetdocview.SetProperty("UnRemoveToolBar","Menu.View.Facing");
    inetdocview.SetProperty("CloseWhenSave", "true");
}

function setMail(){
    inetdocview.SetProperty( "UnRemoveToolBar", "Save.Send Mail..." );
    inetdocview.SetProperty( "UserMail", "<%=strUserEmail%>" );
}

function setWaterMark(){
    var wm_flag = "<%=strWaterMarkFlag %>";
    var av_time = getCurrentTime();
    
    if(wm_flag != 'N'){
        waterMk.setWaterMark( wm_flag, "<%=strUserName %>", "<%=dateToDisplay(strCurrentDate, "/")%>", av_time + " ¹." );
    }
}

function setOfflineDoc(strBatchno , strDocumentRunning , strDocumentType){
    offUtils.setOfflineCtrl("<%=strProjectCode%>", "<%=strUserId%>", "<%=strCurrentDate%>", strBatchno, strDocumentRunning, strDocumentType);
}

function retrieveImage( strBlobId, strBlobPart ){
    
    if ((strBlobId != "") && (strBlobPart != "")){
        inetdocview.Retrieve(strBlobId, strBlobPart);
    }
}

function get_log(batch_no,document_running){
	formLog.BATCH_NO.value 		   = batch_no;
	formLog.DOCUMENT_RUNNING.value = document_running;
	formLog.target = "frameLog";
	formLog.action = "master_log.jsp";
	formLog.submit();
}

//function check_inet_version(){
//	try{
//		var inet_val = inetdocview.GetPropertyValue("VERSION");
//		var version  = inet_val.split(" ");
//		var new_version = version[0] + " " + version[1];
//		
//		if(new_version < lc_inet_version){
//			alert("Please install new version");	
//		}
//	
//	}catch( e ){
//	}
//}

function window_onload(){
	var method = "<%=strMethod%>";
	lb_doc_type_name.innerHTML 	    = lbl_doc_type_name;	
	lb_doc_type_selected.innerHTML  = "<%=strDocumentTypeName%>";
	lb_field_seqn.innerHTML         = lbl_field_seqn;
	lb_sel_doctype_search.innerHTML = lc_select_document_type_before_search;
	<% if(!bolSuccesccSearch){%>
		lb_search_result_data_not_found.innerHTML = lbl_search_result_data_not_found;
	<%}%>
	<% if(!bolFieldSuccess){%>
		alert(lc_add_field_index);
	<%}%>
	
	if(method == "SEARCH_DETAIL_INDEX"){
		change_div('criteria_c');
	}
	var per_page = '<%=strPageSize%>';
	form1.PAGE_SIZE.value = per_page;
	
//	check_inet_version();
}
//-->
</script>
<link href="css/ReportSearch.css" type="text/css" rel="stylesheet">
</head>
<body onLoad="MM_preloadImages('images/i_new_over.jpg','images/i_search_over.jpg','images/i_export_over.jpg','images/i_out_over.jpg','images/btt_new_over.gif','images/btt_search_over.gif');window_onload();" >
<form name="form1" method="post">
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
 	<tr> 
    	<td height="39" valign="top" background="images/pw_07.jpg">
    		<table width="100%" height="62" border="0" cellpadding="0" cellspacing="0">
        		<tr> 
          			<td height="62" background="images/inner_img_03.jpg"> 
          				<table width="990" border="0" cellspacing="0" cellpadding="0">
              				<tr> 
                				<td width="117"><img src="images/inner_img_01.jpg" width="117" height="62"></td>
				                <td valign="bottom"><a href="javascript:click_new()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('i_new','','images/i_new_over.jpg',1)"><img src="images/i_new.jpg" name="i_new" width="56" height="62" border="0"></a><a href="javascript:click_search_all()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('i_search','','images/i_search_over.jpg',1)"><img src="images/i_search.jpg" name="i_search" width="56" height="62" border="0"></a><%=strBttFunction %><a href="javascript:click_cancel()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('i_out','','images/i_out_over.jpg',1)"><img src="images/i_out.jpg" name="i_out" width="56" height="62" border="0"></a></td>
				                <td width="*"><div class="label_bold1"> 
                    				<div align="right" style="padding-right: 30px"><span class="label_header02" title="<%=strProjectCode %>"><%=strProjectName %></span><br>
			                      		<span class="label_bold5">(<%=screenname %>)</span>
			                  		</div>
                  				</div></td>
              				</tr>
            			</table>
           			</td>
        		</tr>
      		</table>
     	</td>
  	</tr>
  	<tr>
    	<td height="29" valign="top" background="images/inner_img_07.jpg">
    		<table width="990" border="0" cellpadding="0" cellspacing="0" class="navbar_01">
        		<tr> 
          			<td width="117"><img src="images/inner_img_05.jpg" width="117" height="29"></td>
          			<td height="29" background="images/inner_img_07.jpg" valign="bottom">
          				<span class="navbar_02">(<%=strUserOrgName%>)</span>
          				<span class="navbar_01"><%=lb_user_name %> : <%=strUserName %> (<%=strUserId%> / <%=strUserLevel%>)</span>
          			</td>
        		</tr>
      		</table>
     	</td>
  	</tr>
  	<tr> 
    	<td valign="top" >
    		<table width="990" height="100%" border="0" cellpadding="0" cellspacing="0">
        		<tr>
          			<td width="219" valign="top">
          				<table width="217" height="100%" border="0" cellpadding="0" cellspacing="0" class="label_normal2">
              				<tr> 
                				<td height="38" background="images/menu_doc.gif">&nbsp;</td>
              				</tr>
              				<tr> 
                				<td valign="top" background="images/menu_02.gif">
                					<ol class="arrowmenu">
<%
						if(bolnSuccess){
							String strDocumentTypeData 		= "";							
							String strDocumentTypeNameData 	= "";
							String strAccessDocTypeNameData = "";
							String strDocumentLevelData 	= "";
							
							while(con.nextRecordElement()){
								strDocumentTypeData 	 = con.getColumn("DOCUMENT_TYPE");
								strDocumentTypeNameData  = con.getColumn("DOCUMENT_TYPE_NAME");
								strAccessDocTypeNameData = con.getColumn("ACCESS_TYPE");
								strDocumentLevelData 	 = con.getColumn("USER_LEVEL");
								
								if(strAccessDocTypeNameData.equals("")){
									strAccessDocTypeNameData = "A";
								}
								if(!strAccessDocTypeNameData.equals("A")){
									if(strAccessDocTypeNameData.equals("U")){
										conDoc.addData( "PROJECT_CODE" , "String" , strProjectCode );
										conDoc.addData( "DOCUMENT_TYPE" , "String" , strDocumentTypeData );
										boolean	bolnUserSuccess = conDoc.executeService( strContainerName , "DOCUMENT_TYPE" , "findDocumentTypeUser" );
										if( bolnUserSuccess ){	
									    	while(conDoc.nextRecordElement()){
									    		if(conDoc.getColumn("USER_ID").equals(strUserId)){
									    			out.println("<li><a href=\"#\" onclick=\"get_document_type('" + strDocumentTypeData + "','" + strDocumentTypeNameData + "')\" >" + strDocumentTypeNameData + "</a></li>");
									    		}
									    	}
									    }
									}else if(strAccessType.equals("L")){										
										if(strDocumentLevelData.equals("")){
											strDocumentLevelData = "0";
										}										
										if(Integer.parseInt(strUserLevel) < Integer.parseInt(strDocumentLevelData)){
											out.println("<li><a href=\"#\" onclick=\"get_document_type('" + strDocumentTypeData + "','" + strDocumentTypeNameData + "')\" >" + strDocumentTypeNameData + "</a></li>");
										}
									}
								}else{
									out.println("<li><a href=\"#\" onclick=\"get_document_type('" + strDocumentTypeData + "','" + strDocumentTypeNameData + "')\" >" + strDocumentTypeNameData + "</a></li>");
								}
							}
						}
%>                				
									</ol>
								</td>
              				</tr>
            			</table>
            		</td>
          		<td width="770" valign="top"> 
          			<div align="center"><br>
	              		<span class="label_bold3">**<span id="lb_sel_doctype_search"></span>**</span></div>
	            		<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
              				<tr> 
                				<td width="18"><img src="images/data_01.gif" width="18" height="37"></td>
                				<td width="760" background="images/data_04.gif"><img id="img_criteria_c" src="images/criteria_c.gif" width="164" height="37" border="0" onclick="change_div('criteria_c')" style="cursor:pointer"></td>
                				<td width="18"><img src="images/data_05.gif" width="18" height="37"></td>
              				</tr>
              				<tr> 
                				<td background="images/data_06.gif"><img src="images/data_06.gif" width="18" height="6"></td>
                				<td bgcolor="#f7f6f2">
                					<div id="div_criteria_c" style="display:inline">
	                					<table width="650" border="0" align="center" cellpadding="0" cellspacing="0" class="label_bold2">
<%
		con.addData("PROJECT_CODE", "String", strProjectCode);
		con.addData("INDEX_TYPE", 	"String", "S");
		
		boolean bolFieldSuccess2 = con.executeService(strContainerName, strClassName, "findDocumentIndex");
		if(bolFieldSuccess2) {
			
			String strFieldLabel , strFieldName , strFieldType , strFieldLength , strFieldTableZoom , strFieldSize , strIsPK , strIsNotNull;
			String strTableLevel, strTableLevel1, strTableLevel2;
			String strTag 		= "";
			String strPrefix 	= "";
			String strSelected 	= "";
			
			String strTableLv1  	= "";
			String strTableLv1Label = "";
			String strTableLv2  	= "";
			String strTableLv2Label = "";
		
			strConcatFieldName = "";
			
			int	cnt = 0;
		
			while( con.nextRecordElement() ){
				strFieldLabel 	  = con.getColumn( "FIELD_LABEL" );
				strFieldName	  = con.getColumn( "FIELD_CODE" );
				strFieldType	  = con.getColumn( "FIELD_TYPE" );
				strFieldLength	  = con.getColumn( "FIELD_LENGTH" );
				strFieldTableZoom = con.getColumn( "TABLE_ZOOM" );
				strIsPK		      = con.getColumn( "IS_PK" );
				strIsNotNull	  = con.getColumn( "IS_NOTNULL" );
				strTableLevel	  = con.getColumn( "TABLE_LEVEL" );
				
				strTableLevel1	  = con.getColumn( "TABLE_LEVEL1" );
				strTableLevel2	  = con.getColumn( "TABLE_LEVEL2" );
				
				strPrefix = "";
				if( strIsPK.equals( "Y" ) ){
					strPrefix += "<img src=\"images/iconkey.gif\">";
				}
				if( strIsNotNull.equals( "Y" ) ){
					strPrefix += "<img src=\"images/mark.gif\" width=12 height=11>";
				}
				
				strFieldSize = strFieldLength ;
				if( Integer.parseInt( strFieldSize ) > 40 ){
					strFieldSize = "40";
				}else{
					strFieldSize = String.valueOf( Integer.parseInt( strFieldSize ) + 2 );
				}
				
				strConcatFieldName += strFieldName + ",";
				
				if( strFieldType.equals( "CHAR" ) ){
					strTag = "\n<input type=\"text\" name=\"" + strFieldName + "\" class=\"input_box\" size=\"" + strFieldSize + "\" maxlength=\"" + strFieldLength + "\" is_PK=\"" + strIsPK + "\" is_NotNull=\"" + strIsNotNull + "\" onKeypress=\"field_press( this );\" />"; //onFocus=\"ocrFocus( this );\">";
				}else if( strFieldType.equals( "TIN" ) ){
					strTag = "\n<input type=\"text\" name=\"" + strFieldName + "\" class=\"input_box\" size=\"" + ( Integer.parseInt( strFieldSize ) + 5 ) + "\" maxlength=\"" + strFieldLength + "\" value_type=\"tin\" is_PK=\"" + strIsPK + "\" is_NotNull=\"" + strIsNotNull + "\" onKeypress=\"keypress_number();field_press( this );\" onblur=\"set_mask(this,'tin')\">";
				}else if( strFieldType.equals( "PIN" ) ){
					strTag = "\n<input type=\"text\" name=\"" + strFieldName + "\" class=\"input_box\" size=\"" + ( Integer.parseInt( strFieldSize ) + 5 ) + "\" maxlength=\"" + strFieldLength + "\" value_type=\"pin\" is_PK=\"" + strIsPK + "\" is_NotNull=\"" + strIsNotNull + "\" onKeypress=\"keypress_number();field_press( this );\" onblur=\"set_mask(this,'pin')\">";
				}else if( strFieldType.equals( "DATE" ) ){
					
					strTag  = "\n<input type=\"text\" name=\"" + strFieldName + "\" value=\"\" class=\"input_box\" size=\"10\" maxlength=\"10\" value_type=\"date\" is_PK=\"" + strIsPK + "\" is_NotNull=\"" + strIsNotNull + "\" onKeypress=\"keypress_number();field_press( this );\" onBlur=\"set_format_date( this );openToDate('" + strFieldName+ "')\">";
					strTag += "\n<a href=\"javascript:showCalendar(form1." + strFieldName + "," + strLangFlag + ")\"><img src=\"images/calendar.gif\" width=16 height=16 align=\"absmiddle\" border=0 ></a>";
					strTag += "\n &nbsp;&nbsp;" + lb_to_date + " &nbsp;<input type=\"text\" name=\"TO_" + strFieldName + "\" value=\"\" class=\"input_box_disable\" size=\"10\" maxlength=\"10\" value_type=\"date\" is_PK=\"" + strIsPK + "\" is_NotNull=\"" + strIsNotNull + "\" onKeypress=\"keypress_number();set_format_date( this )\" onBlur=\"set_format_date( this );\" readOnly>";
					strTag += "\n<a href=\"javascript:showCalendar(form1.TO_" + strFieldName + ",1)\"><img id=\"img_" + strFieldName + "\" src=\"images/calendar.gif\" width=16 height=16 align=\"absmiddle\" border=0 style=\"display:none\" ></a>";
				}else if( strFieldType.equals( "DATE_ENG" ) ){
					
					strTag  = "\n<input type=\"text\" name=\"" + strFieldName + "\" value=\"\" class=\"input_box\" size=\"10\" maxlength=\"10\" value_type=\"date_eng\" is_PK=\"" + strIsPK + "\" is_NotNull=\"" + strIsNotNull + "\" onKeypress=\"keypress_number();field_press( this );\" onBlur=\"set_format_date( this );openToDate('" + strFieldName+ "')\">";
					strTag += "\n<a href=\"javascript:showCalendar(form1." + strFieldName + "," + strLangFlag + ")\"><img src=\"images/calendar.gif\" width=16 height=16 align=\"absmiddle\" border=0 ></a>";
					strTag += "\n &nbsp;&nbsp;" + lb_to_date + " &nbsp;<input type=\"text\" name=\"TO_" + strFieldName + "\" value=\"\" class=\"input_box_disable\" size=\"10\" maxlength=\"10\" value_type=\"date_eng\" is_PK=\"" + strIsPK + "\" is_NotNull=\"" + strIsNotNull + "\" onKeypress=\"keypress_number();set_format_date( this )\" onBlur=\"set_format_date( this );\" readOnly>";
					strTag += "\n<a href=\"javascript:showCalendar(form1.TO_" + strFieldName + ",0)\"><img id=\"img_" + strFieldName + "\" src=\"images/calendar.gif\" width=16 height=16 align=\"absmiddle\" border=0 style=\"display:none\" ></a>";
				}else if( strFieldType.equals( "MONTH" ) ){
					
					strTag = "\n<select name=\"" + strFieldName + "\" class=\"combobox\" is_PK=\"" + strIsPK + "\" is_NotNull=\"" + strIsNotNull + "\" onKeypress=\"field_press( this );\">";
					strTag += "\n<option value=\"\"></option>";
					
					String strZoomDisplayValue = "";
					String strZoomDisplayText  = "";
					
					boolean bolnZoomSuccess = conList.executeService( strContainerName , "IMPORTDATA" , "findMonthCombo" );		
					if( bolnZoomSuccess ){
						while( conList.nextRecordElement() ){
							strZoomDisplayValue = conList.getColumn( "MONTH" );
							strZoomDisplayText  = conList.getColumn( "MONTH_NAME" );
						
							strTag += "\n<option value=\"" + strZoomDisplayValue + "\"" + strSelected + ">" + strZoomDisplayText + "</option>";
						}
					}
		
					strTag += "\n</select>";
				}else if( strFieldType.equals( "MONTH_ENG" ) ){
					
					strTag = "\n<select name=\"" + strFieldName + "\" class=\"combobox\" is_PK=\"" + strIsPK + "\" is_NotNull=\"" + strIsNotNull + "\" onKeypress=\"field_press( this );\">";
					strTag += "\n<option value=\"\"></option>";
					
					String strZoomDisplayValue = "";
					String strZoomDisplayText  = "";
					
					conList.addData( "TABLE_ZOOM" , "String" , "MONTH_ENG" );
					boolean bolnZoomSuccess = conList.executeService( strContainerName , "IMPORTDATA" , "findTableCode" );		
					if( bolnZoomSuccess ){
						while( conList.nextRecordElement() ){
							strZoomDisplayValue = conList.getColumn( "MONTH_ENG" );
							strZoomDisplayText  = conList.getColumn( "MONTH_ENG_NAME" );
						
							strTag += "\n<option value=\"" + strZoomDisplayValue + "\"" + strSelected + ">" + strZoomDisplayText + "</option>";
						}
					}
		
					strTag += "\n</select>";
				}else if( strFieldType.equals( "YEAR" ) ){
					strTag = "\n<input type=\"text\" name=\"" + strFieldName + "\" class=\"input_box\" size=\"" + ( Integer.parseInt( strFieldSize ) + 5 ) + "\" maxlength=\"" + strFieldLength + "\" value_type=\"year\" is_PK=\"" + strIsPK + "\" is_NotNull=\"" + strIsNotNull + "\" onKeypress=\"keypress_number();field_press( this );\">";
				}else if( strFieldType.equals( "NUMBER" ) ){
					strTag = "\n<input type=\"text\" name=\"" + strFieldName + "\" value=\"\" class=\"input_box\" size=\"" + strFieldSize + "\" maxlength=\"" + strFieldLength + "\" value_type=\"number\" is_PK=\"" + strIsPK + "\" is_NotNull=\"" + strIsNotNull + "\" onKeypress=\"keypress_number();field_press( this );\" />"; //onFocus=\"ocrFocus( this );\">";
				}else if( strFieldType.equals( "CURRENCY" ) ){
					strTag = "\n<input type=\"text\" name=\"" + strFieldName + "\" value=\"\" class=\"input_box\" size=\"" + strFieldSize + "\" maxlength=\"" + strFieldLength + "\" value_type=\"number\" is_PK=\"" + strIsPK + "\" is_NotNull=\"" + strIsNotNull + "\" onKeypress=\"keypress_currency(this);field_press( this );\" />"; //onFocus=\"ocrFocus( this );\">";
				}else if( strFieldType.equals( "MEMO" ) ){
					strTag = "\n<input type=\"text\" name=\"" + strFieldName + "\" value=\"\" class=\"input_box\" size=\"" + strFieldSize + "\" maxlength=\"" + strFieldLength + "\" is_PK=\"" + strIsPK + "\" is_NotNull=\"" + strIsNotNull + "\" onKeypress=\"field_press( this );\" />"; //onFocus=\"ocrFocus( this );\">";
				}else if( strFieldType.equals( "ZOOM" ) ){
					strTag = "\n<input type=\"hidden\" name=\"" + strFieldName + "\" value=\"\" value_type=\"zoom\" is_PK=\"" + strIsPK + "\" is_NotNull=\"" + strIsNotNull + "\">";
				
					strTag += "\n<input type=\"text\" name=\"DSP_" + strFieldName + "\" value=\"\" class=\"input_box_disable\" size=\"40\" readonly>";
					strTag += "\n<a href=\"javascript:openZoom('" + strFieldTableZoom + "' , '" + strFieldLabel + "' , form1.DSP_" + strFieldName + " , form1." + strFieldName + ", '" + strTableLevel +"');\"><img src=\"images/search.gif\" width=16 height=16 align=\"absmiddle\" border=0></a>";
					
					if(strTableLevel.equals("1")){
						strTag += "\n<input type=\"hidden\" name=\"FIELD_" + strFieldTableZoom + "\" value=\"" + strFieldName + "\">";
					
					}
					
					if(strTableLevel.equals("2")){
						conLV.addData("PROJECT_CODE", "String", strProjectCode);
						conLV.addData("TABLE_CODE"  , "String", strTableLevel1);
					    boolean bolSuccessLv2 = conLV.executeService(strContainerName, "IMPORTDATA", "findFieldTableZoom");
					    if(bolSuccessLv2){
					    	strTableLv1 	 = conLV.getHeader("FIELD_CODE");
					    	strTableLv1Label = conLV.getHeader("FIELD_LABEL");
					    	
					    	strTag += "\n<input type=\"hidden\" name=\"FIELD_" + strFieldTableZoom + "_LV1\" value=\"" + strTableLv1 + "\">";
							strTag += "\n<input type=\"hidden\" name=\"FIELD_" + strFieldTableZoom + "_LV1_LABEL\" value=\"" + strTableLv1Label + "\">";
							strTag += "\n<input type=\"hidden\" name=\"FIELD_" + strFieldTableZoom + "_LV1_CODE\" value=\"" + strTableLevel1 + "\">";
							strTag += "\n<input type=\"hidden\" name=\"FIELD_" + strTableLevel1 + "_LV2\" value=\"" + strFieldName + "\">";
					    }						    
						strTag += "\n<input type=\"hidden\" name=\"FIELD_" + strFieldTableZoom + "\" value=\"" + strFieldName + "\">";
					
					}
		
					if(strTableLevel.equals("3")){
						conLV.addData("PROJECT_CODE", "String", strProjectCode);
						conLV.addData("TABLE_CODE"  , "String", strTableLevel1);
					    boolean bolSuccessLv3 = conLV.executeService(strContainerName, "IMPORTDATA", "findFieldTableZoom");
					    if(bolSuccessLv3){
					    	strTableLv1 	 = conLV.getHeader("FIELD_CODE");
					    	strTableLv1Label = conLV.getHeader("FIELD_LABEL");
					    	
					    	strTag += "\n<input type=\"hidden\" name=\"FIELD_" + strFieldTableZoom + "_LV1\" value=\"" + strTableLv1 + "\">";
							strTag += "\n<input type=\"hidden\" name=\"FIELD_" + strFieldTableZoom + "_LV1_LABEL\" value=\"" + strTableLv1Label + "\">";
							strTag += "\n<input type=\"hidden\" name=\"FIELD_" + strFieldTableZoom + "_LV1_CODE\" value=\"" + strTableLevel1 + "\">";
							strTag += "\n<input type=\"hidden\" name=\"FIELD_" + strTableLevel1 + "_LV3\" value=\"" + strFieldName + "\">";
					    }
					    conLV.addData("PROJECT_CODE", "String", strProjectCode);
						conLV.addData("TABLE_CODE"  , "String", strTableLevel2);
						
					    bolSuccessLv3 = conLV.executeService(strContainerName, "IMPORTDATA", "findFieldTableZoom");
					    if(bolSuccessLv3){
					    	strTableLv2 	 = conLV.getHeader("FIELD_CODE");
					    	strTableLv2Label = conLV.getHeader("FIELD_LABEL");
					    	
					    	strTag += "\n<input type=\"hidden\" name=\"FIELD_" + strFieldTableZoom + "_LV2\" value=\"" + strTableLv2 + "\">";
							strTag += "\n<input type=\"hidden\" name=\"FIELD_" + strFieldTableZoom + "_LV2_LABEL\" value=\"" + strTableLv2Label + "\">";
							strTag += "\n<input type=\"hidden\" name=\"FIELD_" + strFieldTableZoom + "_LV2_CODE\" value=\"" + strTableLevel2 + "\">";
							strTag += "\n<input type=\"hidden\" name=\"FIELD_" + strTableLevel2 + "_LV3\" value=\"" + strFieldName + "\">";
					    }
						strTag += "\n<input type=\"hidden\" name=\"FIELD_" + strFieldTableZoom + "\" value=\"" + strFieldName + "\">";
						
					}
					
					strConcatFieldName += "DSP_" + strFieldName + ",";
				}else if( strFieldType.equals( "LIST" ) ){
					strTag = "\n<select name=\"" + strFieldName + "\" class=\"combobox\" is_PK=\"" + strIsPK + "\" is_NotNull=\"" + strIsNotNull + "\" onKeypress=\"field_press( this );\">";
					strTag += "\n<option value=\"\"></option>";
					
					String strZoomDisplayValue = "";
					String strZoomDisplayText  = "";
					
					conList.addData( "TABLE_ZOOM" , "String" , strFieldTableZoom );
		
					boolean bolnZoomSuccess = conList.executeService( strContainerName , "IMPORTDATA" , "findTableCode" );
		
					if( bolnZoomSuccess ){
						while( conList.nextRecordElement() ){
							strZoomDisplayValue = conList.getColumn( strFieldTableZoom );
							strZoomDisplayText  = conList.getColumn( strFieldTableZoom + "_NAME" );
						
							strTag += "\n<option value=\"" + strZoomDisplayValue + "\"" + strSelected + ">" + strZoomDisplayText + "</option>";
						}
					}
		
					strTag += "\n</select>";
				}
				
				cnt++;

				String selLast = "";
				if(con.getRecordTotal() == cnt){
					selLast = "style=\"display:none\"";
				}
%>		                    					
	                    					<tr> 
						                      	<td width="169"><span id="<%=strFieldName%>_span"><%=strFieldLabel %></span></td>
						                      	<td width="82">
						                      		<select name="selOperator<%=cnt %>" class="combobox" style="width:60px">
						                      	<% if(strFieldType.equals( "CHAR" )||strFieldType.equals( "MEMO" )||strFieldType.equals( "PIN" )||strFieldType.equals( "TIN" )){%> 		
						                          		<option value="%A%">?A?</option>
						                          		<option value="A%">A?</option>
			                          			<%	} %>
						                          		<option value="=">=</option>
			                          			<%	if(strFieldType.equals( "NUMBER" )||strFieldType.equals( "CURRENCY" )||strFieldType.equals( "DATE" )||strFieldType.equals( "DATE_ENG" )||strFieldType.equals( "YEAR" )){ %>		
						                          		<option value=">">&gt;</option>
						                          		<option value="<">&lt;</option>
						                          		<option value=">=">&gt;=</option>
						                          		<option value="<=">&lt;=</option>
						                          		<option value="<>">&lt;&gt;</option>
						                         <%	} %> 		
						                        	</select>
					                        	</td>
						                      	<td ><%=strTag%></td>
						                      	<td width="82">&nbsp;&nbsp;
						                      		<select name="selCondition<%=cnt%>" class="combobox" <%=selLast %>>
						                          		<option value="AND">AND</option>
						                          		<option value="RUE">OR</option>
						                        	</select>
						                        </td>
					                    	</tr>
<%					
			}
			
			if( strConcatFieldName.length() > 0 ){
				strConcatFieldName = strConcatFieldName.substring( 0 , strConcatFieldName.length() - 1 );
			}
		
		}
%>		                    					
	                    					<tr> 
					                      	<td width="169">&nbsp;</td>
					                      	<td colspan="3">
					                      		<input type="checkbox" id="chkDocumentUser2" >&nbsp;<%=lb_chk_document_user %>
					                      		<input type="hidden" id="hidDocumentUser" name="hidDocumentUser" value="">
				                        	</td>
				                    	</tr>
	                    				<tr valign="bottom"> 
	                      						<td height="30" colspan="4">
		                      						<div align="center"> 
		                      							<a href="javascript:click_search_index()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('search1','','images/btt_search_over.gif',1)"><img src="images/btt_search.gif" name="search1" width="67" height="22" border="0" ></a>
					                          			<a href="javascript:clear_search_index()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('btt_new1','','images/btt_new_over.gif',1)"><img src="images/btt_new.gif" name="btt_new1" width="67" height="22" border="0" ></a> 
		                        					</div>
		                        				</td>
	                    					</tr>
	                 					</table>
	                 				</div>	 
                 				</td>
                				<td background="images/data_09.gif"><img src="images/data_09.gif" width="18" height="6"></td>
              				</tr>
              				<tr> 
				                <td><img src="images/data_13.gif" width="18" height="20"></td>
				                <td background="images/data_15.gif"><img src="images/data_15.gif" width="5" height="20"></td>
				                <td><img src="images/data_16.gif" width="18" height="20"></td>
				           	</tr>
				    	</table><br>
				    	<div>
				    		<span style="padding-left:20 px" id="lb_doc_type_name" class="label_bold2"></span> : 
				    		<span id="lb_doc_type_selected" class="label_bold2"></span>
				    	</div><br>
			            <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0">
			              	<tr class="hd_table"> 
			                	<td width="10"><img src="images/hd_tb_01.gif" width="10" height="28"></td>
			                	<td width="23"><span id="lb_field_seqn"></td>
<%	
			String	arrNameHeader[] = null;
			String	arrFieldIndex[] = null;
			String	arrTableZoom[]  = null;
			String	arrFieldType[]  = null;
			int		iColumn			= 0;
			
			if(strConcatFieldLabel.length() > 0){
				strConcatFieldLabel = strConcatFieldLabel.substring(0,strConcatFieldLabel.length() - 1);
				arrNameHeader = strConcatFieldLabel.split(",");
			}
			if(strConcatFieldIndex.length() > 0){
				strConcatFieldIndex = strConcatFieldIndex.substring(0,strConcatFieldIndex.length() - 1);
				arrFieldIndex = strConcatFieldIndex.split(",");
			}
			if(strConcatTableZoom.length() > 0){
				strConcatTableZoom = strConcatTableZoom.substring(0,strConcatTableZoom.length() - 1);
				arrTableZoom = strConcatTableZoom.split(",");
			}
			if(strConcatFieldType.length() > 0){
				strConcatFieldType = strConcatFieldType.substring(0,strConcatFieldType.length() - 1);
				arrFieldType = strConcatFieldType.split(",");
			}
			
			if(arrFieldIndex == null){
				iColumn = 0;
			}else{
				iColumn = arrFieldIndex.length;
			}

			boolean bolSuccessData = bolSuccesccSearch; 
			
			String[] sortImg = new String[iColumn + 1];
			
			if(bolSuccessData){
				
				if(strSortField.equals("DOCUMENT_NO")){					
					for(int idn=0; idn<arrFieldIndex.length+1; idn++){
						if(idn != 0){
							sortImg[idn] = "<img src=\"images/updown.gif\" width=20 height=11 border=0 style=\"cursor:pointer;\" onclick=\"click_sort('" + arrFieldIndex[idn-1] +"','ASC')\">";
						}
					}
				}else{
					
					for(int idx=0; idx<arrFieldIndex.length+1; idx++){
						if(idx != 0){
							if(arrFieldIndex[idx-1].equals(strSortField)){
								if(strOrderBy.equals("ASC")){
									sortImg[idx] = "<img src=\"images/sort_down.gif\" width=16 height=16 border=0 style=\"cursor:pointer;\" onclick=\"click_sort('" + arrFieldIndex[idx-1] + "','DESC')\">";		
								}else{
									sortImg[idx] = "<img src=\"images/sort_up.gif\" width=16 height=16 border=0 style=\"cursor:pointer;\" onclick=\"click_sort('" + arrFieldIndex[idx-1] + "','ASC')\">";		
								}
							
							}else{
								sortImg[idx] = "<img src=\"images/updown.gif\" width=20 height=11 border=0 style=\"cursor:pointer;\" onclick=\"click_sort('" + arrFieldIndex[idx-1] + "','ASC')\">";
							}						
						}
					}
				}
			}else{
				for(int ida=0; ida<iColumn+1; ida++){
					sortImg[ida] = "";
				}
			}
				
			String strHalign = "";
			int iColName 	 = 0;

			for(int arrHead=0; arrHead < iColumn; arrHead++){
				strHalign = "";
				
				if(arrTableZoom[arrHead].equals("number")||arrTableZoom[arrHead].equals("currency")){strHalign = "right";}
				else if(arrTableZoom[arrHead].equals("date")||arrTableZoom[arrHead].equals("date_eng")||arrTableZoom[arrHead].equals("tin_pin")){strHalign = "center";}
				else {strHalign = "left";}
				
				out.println("<td width=\"5\"></td>");
				out.println("<td align=\"" + strHalign + "\">" + arrNameHeader[arrHead] + sortImg[arrHead+1] + "</td>" );
				
				if(arrFieldType[arrHead].equals("DATE")||arrFieldType[arrHead].equals("DATE_ENG")){
					strColumnName += arrNameHeader[arrHead] + ":" + arrFieldIndex[arrHead] + ":DATE;";	
				}else if(arrFieldType[arrHead].equals("ZOOM")||arrFieldType[arrHead].equals("LIST")||arrFieldType[arrHead].equals("MONTH")||arrFieldType[arrHead].equals("MONTH_ENG")){
					strColumnName += arrNameHeader[arrHead] + ":" + arrTableZoom[arrHead] + "_NAME:STRING;";
				}else{
					strColumnName += arrNameHeader[arrHead] + ":" + arrFieldIndex[arrHead] + ":STRING;";
				}
				strColumnCode += arrFieldIndex[arrHead] + ":" + arrFieldIndex[arrHead] + ":STRING;";
			}
		
			if(strColumnName.length() > 0){
				iColName = strColumnName.length() - 1;
			}
				
			strColumnName = strColumnName.substring(0,iColName);			
%>				                	
               					<td width="20">&nbsp;</td>
               					<td width="20">&nbsp;</td>
               					<td align="right"><img src="images/hd_tb_04.gif" width="10" height="28"></td>
           					</tr>
<%
			int intPage   = 0;
			int iPageSize = Integer.parseInt(strPageSize);
			
			if (!strPageNumber.equals("1")) {
			    intPage = iPageSize * (Integer.parseInt(strPageNumber) - 1);
			}
			
			if(!bolSuccesccSearch){
%>				
								<tr class="table_data1"> 
				                	<td colspan="<%=(iColumn*2) + 5 %>" align="center"><span id="lb_search_result_data_not_found"></span></td>
				                </tr>				
<% 				
			}else{
				int cnt = 0;
				String[] strDataIndex = new String[iColumn];
				String	strStoreFlag 		= "";
				String	strBatchNo 			= "";
				String	strDocumentRunning 	= "";
				String  strDocumentName     = "";
				String  strDocumentUser     = "";
				
				while(conResult.nextRecordElement()){
				
				//	strStoreFlag 		= con.getColumn("STORE_FLAG");
					strBatchNo 			= conResult.getColumn("BATCH_NO");
					strDocumentRunning 	= conResult.getColumn("DOCUMENT_RUNNING");
					strDocumentName 	= conResult.getColumn("DOCUMENT_NAME");
					strDocumentUser 	= conResult.getColumn("DOCUMENT_USER");
%>
							<tr class="table_data<%=(cnt%2)+1%>" > 
				                <td>&nbsp;</td>
				                <td><div align="center"><%=(cnt+1)+intPage %></div></td>
					
<%
					String strAlign = "";
						
					for(int idx=0; idx<iColumn; idx++ ){
						strAlign = "";
						if(!arrTableZoom[idx].equals("not")&&!arrTableZoom[idx].equals("date")&&!arrTableZoom[idx].equals("date_eng")&&!arrTableZoom[idx].equals("tin")&&!arrTableZoom[idx].equals("pin")&&!arrTableZoom[idx].equals("number")&&!arrTableZoom[idx].equals("currency")){
							strDataIndex[idx] = conResult.getColumn(arrTableZoom[idx]+ "_NAME");								
							
						}else{
							if(arrTableZoom[idx].equals("date")||arrTableZoom[idx].equals("date_eng")){
								strDataIndex[idx] = dateToDisplay(conResult.getColumn(arrFieldIndex[idx]),"/");									
							}else if(arrTableZoom[idx].equals("tin")){
								strDataIndex[idx] = "<script> document.write(sccUtils.maskTIN('" + conResult.getColumn(arrFieldIndex[idx]) + "'));</script>";
							}else if(arrTableZoom[idx].equals("pin")){
								strDataIndex[idx] = "<script> document.write(sccUtils.maskPIN('" + conResult.getColumn(arrFieldIndex[idx]) + "'));</script>";
							}else if(arrTableZoom[idx].equals("currency")){
								strDataIndex[idx] = conResult.getColumn(arrFieldIndex[idx]);
								if(strDataIndex[idx].equals("")){
									strDataIndex[idx] = "0.00"	;		
								}else{
									strDataIndex[idx] = setComma(strDataIndex[idx]);
								}
							}else{
								strDataIndex[idx] = conResult.getColumn(arrFieldIndex[idx]);
							}
						}
					
						if(arrTableZoom[idx].equals("number")||arrTableZoom[idx].equals("currency")){strAlign = "right";}
						else if(arrTableZoom[idx].equals("date")||arrTableZoom[idx].equals("date_eng")||arrTableZoom[idx].equals("tin_pin")){strAlign = "center";}
						else {strAlign = "left";}
						
						out.println("<td></td>");
						out.println("<td><div align=\"" + strAlign +"\"><span> " + strDataIndex[idx]+ "</span></div></td>");
					}
%>					            <td align="right" width="20">
									<a href="#" onclick="open_detail(this)" PROJECT_CODE="<%=strProjectCode %>" PROJECT_NAME="<%=strProjectName %>" BATCH_NO="<%=strBatchNo %>" DOCUMENT_RUNNING="<%=strDocumentRunning %>" DOCUMENT_NAME="<%=strDocumentName %>" DOCUMENT_USER="<%=strDocumentUser %>" ><img src="images/page_detail.gif" name="detail<%=cnt+1 %>" width="16" height="16" border="0" style="cursor:pointer;" title="<%=lb_detail %>"></a>
								</td>
				            	<td align="right" width="20">	
								<% if(strPermission.indexOf("search") != -1){ %>
								<%
										String strBlobData = "";
										String strPictData = "";
										
										conAtt.addData("PROJECT_CODE", 		"String", strProjectCode);
										conAtt.addData("BATCH_NO", 			"String", strBatchNo);
										conAtt.addData("DOCUMENT_RUNNING", 	"String", strDocumentRunning);
										conAtt.addData("DOCUMENT_TYPE", 	"String", strDocumentType);
										
					        			boolean bolSuccessAttach = conAtt.executeService(strContainerName, strClassName, "findDocumentLevel");
					        			if(bolSuccessAttach){
					        				strBlobData 	= conAtt.getHeader("BLOB");
					        				strPictData 	= conAtt.getHeader("PICT");					        				
					        			}	
					        			
					        			if(!strBlobData.equals("")){
								%>
				                		<a href="javascript:openShowView( '<%=strBatchNo%>','<%=strDocumentRunning%>' , '<%=strDocumentType%>' , '<%=strBlobData%>','<%=strPictData%>' )" ><img src="images/page_attach.gif" name="attach<%=cnt+1 %>" width="16" height="16" border="0" style="cursor:pointer;" title="<%=lb_attachment %>"></a>
				                <%		} %>
				                <% } 
				                
				                %>
				                </td>
				            	<td width="11">&nbsp;</td>
		                	</tr>		                            
<%					
					cnt++;					             
				}
			}
%>				                
            			</table>
            			<table width="95%" border="0" align="center" cellpadding="0" cellspacing="0" class="footer_table">
              				<tr> 
                				<td width="*" align="left"><%=lb_total_record %> <%=strTotalSize %> <%=lb_records %></td>
                				<td width="*"><div align="right"><%=lb_page_no %> <%=strPageNumber %>/<%=strTotalPage %></div></td>
                				<td width="134" align="center">
			                  		<img src="images/first.gif" width="22" height="22" onclick="click_navigator('first')" style="cursor:pointer"> 
					                <img src="images/prv.gif" 	width="22" height="22" onclick="click_navigator('prev')" style="cursor:pointer"> 
					                <img src="images/next.gif" 	width="22" height="22" onclick="click_navigator('next')" style="cursor:pointer"> 
					                <img src="images/last.gif" 	width="22" height="22" onclick="click_navigator('last')" style="cursor:pointer">
	                  			</td>
              				</tr>
            			</table>
            			<table width="95%" border="0" align="center" cellpadding="0" cellspacing="0" class="label_bold2">
		              		<tr>
		              			<td height="10"></td>
		              		</tr>
		              		<tr>	
		              			<td align="right">
		              				<%=lb_page_per_size %> : 
		              				<select name="PAGE_SIZE"  class="combobox" onchange="change_result_per_page();">
										<option value="10">10</option>
										<option value="20">20</option>
										<option value="30">30</option>
										<option value="40">40</option>
										<option value="50">50</option>
										<option value="100">100</option>
									</select>
		              			</td>
		              		</tr>
		              </table>
            		</td>
        		</tr>
      		</table>
    	</td>
	</tr>
</table>
<input type="hidden" name="screenname"   		value="<%=screenname%>">
<input type="hidden" name="user_role"    		value="<%=user_role%>">
<input type="hidden" name="app_group"   	 	value="<%=app_group%>">
<input type="hidden" name="app_name"     		value="<%=app_name%>">
<input type="hidden" name="PAGENUMBER" 			value="<%=strPageNumber%>">
<input type="hidden" name="TOTALPAGE"  			value="<%=strTotalPage%>">
<input type="hidden" name="CONCAT_FIELD_NAME" 	value="<%=strConcatFieldName %>">
<input type="hidden" name="METHOD" 	   			value="<%=strMethod%>">
<input type="hidden" name="DOCUMENT_FIELD_VALUE" value="<%=strDocumentFieldValue%>">
<input type="hidden" name="DOCUMENT_TYPE" 		value="<%=strDocumentType %>">
<input type="hidden" name="DOCUMENT_TYPE_NAME" 	value="<%=strDocumentTypeName %>">
<input type="hidden" name="SORT_FIELD" 			value="<%=strSortField%>">
<input type="hidden" name="ORDER_BY" 			value="<%=strOrderBy%>">
<input type="hidden" name="ORDER_TYPE"  		value="<%=strOrderType %>">
<input type="hidden" name="PERMIT_FUNCTION" 	value="<%=strPermission %>">
<input type="hidden" name="PROJECT_CODE" 		value="<%=strProjectCode %>">
<input type="hidden" name="USER_ID"             value="<%=strUserId%>">
</form>
<form name="formExcel" action="Export2ExcelServlet" method="post">
        <input type="hidden" name="CONTAINER_NAME"  	value="<%=strContainerName %>">
	<input type="hidden" name="PROJECT_CODE"  	value="<%=strProjectCode %>">
	<input type="hidden" name="DOCUMENT_TYPE" 	value="<%=strDocumentType%>">
	<input type="hidden" name="MASTER_HEADER"  	value="<%=strMasterHeader %>">
	<input type="hidden" name="QUERY_HEADER"  	value="<%=strSQLHeader %>">
	<input type="hidden" name="QUERY_CONDITION" value="<%=strSQLcondition %>">
	<input type="hidden" name="JOIN_TABLE"  	value="<%=strSQLJoinTable %>">
	<input type="hidden" name="ORDER_TYPE"  	value="<%=strOrderType %>">
	<input type="hidden" name="SORT_FIELD"  	value="<%=strSortField %>">
	<input type="hidden" name="SORT_BY"  		value="<%=strOrderBy %>">
    <input type="hidden" name="QUERY_TAG"      	value="EXPORT_LIST_SEARCH_RESULT">
    <input type="hidden" name="CONTAINER_NAME" 	value="<%=strContainerName%>">
    <input type="hidden" name="CLASS_NAME"     	value="EXPORT2EXCEL">
    <input type="hidden" name="METHOD_NAME"    	value="exportSearchResult">
    <input type="hidden" name="COLUMN_NAME"    	value="<%=strColumnName %>">
    <input type="hidden" name="COLUMN_CODE"    	value="<%=strColumnCode %>">
    <input type="hidden" name="SET_CODE_FLAG"   value="N">
</form>
<%@ include file="inc/export_excel_div.jsp" %>
<form name="formXml">
	<input type="hidden" name="PROJECT_CODE" 	value="<%=strProjectCode%>">
	<input type="hidden" name="DOCUMENT_TYPE" 	value="<%=strDocumentType%>">
	<input type="hidden" name="MASTER_HEADER"  	value="<%=strMasterHeader %>">
	<input type="hidden" name="QUERY_HEADER"  	value="<%=strSQLHeader %>">
	<input type="hidden" name="QUERY_CONDITION" value="<%=strSQLcondition %>">
	<input type="hidden" name="JOIN_TABLE"  	value="<%=strSQLJoinTable %>">
	<input type="hidden" name="ORDER_TYPE"  	value="<%=strOrderType %>">
	<input type="hidden" name="SORT_FIELD"  	value="<%=strSortField %>">
	<input type="hidden" name="SORT_BY"  		value="<%=strOrderBy %>">
	<input type="hidden" name="CONTAINER_TYPE" 	value="<%=strContainerType%>">
	<input type="hidden" name="INDEX_TYPE" 		value="R">
	<input type="hidden" name="CONTAINER_NAME" 	value="<%=strContainerName%>">
</form>
<form name="formLog">
  <input type="hidden" name="PROJECT_CODE">
  <input type="hidden" name="BATCH_NO">
  <input type="hidden" name="DOCUMENT_RUNNING">
  <input type="hidden" name="ACTION_FLAG" value="V">
</form>
<iframe name="frameLog"  style="display:none"></iframe>
<form name="formOffline">
  <input type="hidden" name="BATCH_NO">
  <input type="hidden" name="DOCUMENT_RUNNING">
  <input type="hidden" name="MEDIA_LABEL">
</form>
<iframe name="frameOffline" style="display:none"></iframe>
<div id="divXML" style="width:500px;height:300px;z-index:1;position:absolute;top:50;left:300;visibility:hidden;background: white ;border: solid 1px black" >
  <table border="0" width="100%">
    <tr>
	  <td width="99%">&nbsp;</td>
	  <td width="1%"><a href="javascript:void(0);" onclick="closeExportXMLWindow();">X</a></td>
	</tr>
  </table>
  <iframe name="iframeXML" frameborder="0" width="100%" height="95%">
  </iframe>
</div>
<iframe scrolling="no" frameborder="0" name="inetdocview" src="/jinetdocarchive/imageproxy?codetype=applet&version=15&securecode=<%=securecode%>" width="32" height="32" marginwidth="0">
</iframe>
</body>
</html>
