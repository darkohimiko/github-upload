<%@page import="com.scc.edms.conf.ImageConfUtil"%>
<%@ page contentType="text/html; charset=tis-620"%>
<%@ page import="com.scc.security.UserInfo"%>
<%@ include file="inc/checkUser.jsp" %>
<%@ include file="inc/constant.jsp" %>
<%@ include file="inc/label.jsp" %>
<%@ include file="inc/utils.jsp" %>
<jsp:useBean id="con" scope="session" class="edms.cllib.EABConnector"/>
<jsp:useBean id="conAtt" scope="session" class="edms.cllib.EABConnector"/>
<jsp:useBean id="conAcc" scope="session" class="edms.cllib.EABConnector"/>
<%@page import="java.util.Random"%>
<%
	Random ran = new Random();
	String randomNo=String.valueOf(ran.nextLong());
	String strRand = "&randomNo="+ randomNo;
%>
<%
    String securecode = "";

    con.setRemoteServer("EAS_SERVER");
    conAtt.setRemoteServer("EAS_SERVER");
    conAcc.setRemoteServer("EAS_SERVER");
	
    if (!con.executeService("EASSYSTEM", "SECURECODE", "genSecurityCode")){
        out.println("Create Image Login Session Fail");
        return;
    }
    securecode = con.getHeader("SECURECODE");
%>
<%
	UserInfo userInfo = (UserInfo)session.getAttribute( "USER_INFO" );
	String strUserId        = userInfo.getUserId();
	String strUserName      = userInfo.getUserName();
	String strUserOrgName   = userInfo.getUserOrgName();
	String strUserLevel     = userInfo.getUserLevel();
	String strProjectCode 	= userInfo.getProjectCode();
	String strProjectName   = userInfo.getProjectName();
	String strUserEmail		= checkNull(session.getAttribute("USER_EMAIL"));
	
	String user_role     = getField(request.getParameter("user_role"));
	String app_name      = getField(request.getParameter("app_name"));
	String app_group     = getField(request.getParameter("app_group"));
	String screenname    = getField(request.getParameter("screenname"));
	String strDocUserCon = getField(request.getParameter("hidDocumentUserCon"));

	String strAccessType    = (String)session.getAttribute( "ACCESS_TYPE" );
	String strAccessDocType = (String)session.getAttribute( "ACCESS_DOC_TYPE" );
	String strUserGroup     = (String)session.getAttribute( "USER_GROUP" );
	String strSecurityFlag  = (String)session.getAttribute( "SECURITY_FLAG" );
	String strAndDocTypeCon = "";
//	String strCount         = "";
	
//------------------- Remember Field Search ----------------------------//
	
	String strBatchNoSerach 	 = checkNull(request.getParameter("BATCH_NO_SEARCH"));
	String strDocumentNameSerach = getField(request.getParameter("DOCUMENT_NAME_SEARCH"));
	String strAddDateSerach      = checkNull(request.getParameter("ADD_DATE_SEARCH"));
	String strToAddDateSerach    = checkNull(request.getParameter("TO_ADD_DATE_SEARCH"));
	String strEditDateSerach     = checkNull(request.getParameter("EDIT_DATE_SEARCH"));
	String strToEditDateSerach   = checkNull(request.getParameter("TO_EDIT_DATE_SEARCH"));
	String strDocUserSerach      = checkNull(request.getParameter("txtDocUser_SEARCH"));
	String strDocUserNameSerach  = getField(request.getParameter("txtDocUserName_SEARCH"));
	String strAddUserSerach      = checkNull(request.getParameter("ADD_USER_SEARCH"));
	String strAddUserNameSerach  = getField(request.getParameter("ADD_USER_NAME_SEARCH"));
	String strEditUserSerach     = checkNull(request.getParameter("EDIT_USER_SEARCH"));
	String strEditUserNameSerach = getField(request.getParameter("EDIT_USER_NAME_SEARCH"));
	
	String strSelConA = checkNull(request.getParameter("selConditionA_SEARCH"));
	String strSelConB = checkNull(request.getParameter("selConditionB_SEARCH"));
	String strSelConC = checkNull(request.getParameter("selConditionC_SEARCH"));
	String strSelConD = checkNull(request.getParameter("selConditionD_SEARCH"));
	String strSelConE = checkNull(request.getParameter("selConditionE_SEARCH"));
	String strSelConF = checkNull(request.getParameter("selConditionF_SEARCH"));

	String strSearchFieldValue = getField( request.getParameter( "SEARCH_FIELD_VALUE" ) );
	String strSearchCondition  = getField( request.getParameter( "SEARCH_CONDITION" ) );
	String strSearchOperator   = getField( request.getParameter( "SEARCH_OPERATOR" ) );
	String strConcatFieldName  = getField( request.getParameter( "CONCAT_FIELD_NAME" ) );
	
	//------------------------------------------------------------------------//
	
	boolean bolnAccType  = false;
	
	String strSortField = getField( request.getParameter( "SORT_FIELD" ) );
	String strOrderBy 	= getField( request.getParameter( "ORDER_BY" ) );
	
	String 	strClassName 	 = "EDIT_DOCUMENT";
	String 	strErrorMessage  = "";
	String	strPermission	 = "";
		
	String	strOrderType 		= getField(request.getParameter("ORDER_TYPE"));
	String	strSearchDisPlay 	= getField(request.getParameter("SEARCH_DISPLAY"));
	String	strCountRecord		= getField(request.getParameter("COUNT_RECORD"));
	
	String 	strConcatTableZoom	 = "";
	String 	strConcatFieldType	 = "";
	
	String	strSQLHeader 	= "";
	String	strSQLJoinTable = "";
	String	strSQLcondition = "";
	String	strSQLWhere 	= "";
	String	strDistinct	= "";
	String	strFieldType 	= "";
	String	strFieldCode 	= "";
	String	strFieldLabel	= "";
	String	strTableZoom	= "";
	String	strColumnName	= "";
	String	strColumnCode	= "";
	
	String	strPageNumber = getField(request.getParameter("PAGENUMBER"));
	String	strPageSize   = getField(request.getParameter("PAGE_SIZE"));
	String	strTotalPage  = "1";	
	String	strTotalSize  = "0";
	
	String	strCurrentDate	 = "";
	String	strContainType	 = ImageConfUtil.getInetContainerType();
	String  strWaterMarkFlag = "";
        String strVersionLang  = ImageConfUtil.getVersionLang();
        String strDocumentNoAll = "";
        String strCntUserAccess = "";
        String strCntGroupAccess = "";

        if( strVersionLang.equals("thai") ) {
            strCurrentDate = getServerDateThai();
        }else{
            strCurrentDate = getServerDateEng();
        }
	
	if(strPageNumber.equals("")){
		strPageNumber = "1";
	}
	if(strPageSize.equals("")){
		strPageSize = "10";
	}
	
	if(strSortField.equals("")){
		strSortField = "DOCUMENT_NO";		
	}	
	
	if(strOrderBy.equals("")){
		strOrderBy = "ASC";		
	}
	
	if(!strOrderType.equals(strOrderBy)){
		strOrderType = strOrderBy;
	}
	
	boolean bolSuccess;
	boolean	bolSuccesccSearch = false;
	boolean bolnWaterMarkSuccess = false;
	
	con.addData("PROJECT_CODE", "String", strProjectCode);
	bolnWaterMarkSuccess = con.executeService(strContainerName, "PROJECT_MANAGER", "findWaterMarkFlag");
	if(bolnWaterMarkSuccess){
		strWaterMarkFlag = con.getHeader("WATERMARK_FLAG");
	}else{
		strWaterMarkFlag = "N";
	}
	
	String strFromPage  = request.getParameter( "FROM_PAGE" );	
	String strMethod 	= request.getParameter( "METHOD" );
	
	String strConcatFieldLabel	 = getField( request.getParameter( "CONCAT_FIELD_LABEL" ) );
	String strConcatFieldIndex 	 = getField( request.getParameter( "CONCAT_FIELD_INDEX" ) );
	String strDocumentDataValue  = getField( request.getParameter( "DOCUMENT_DATA_VALUE" ) );
	String strDocumentFieldValue = getField( request.getParameter( "DOCUMENT_FIELD_VALUE" ) );
	String strDocumentDesc 		 = getField( request.getParameter( "DOCUMENT_DESC" ) );
	String strSearchDesc 		 = getField( request.getParameter( "SEARCH_DESC" ) );
	
	String	strBttFunction	= "<a href=\"javascript:click_new()\" onMouseOut=\"MM_swapImgRestore()\" onMouseOver=\"MM_swapImage('i_new','','images/i_new_over.jpg',1)\"><img src=\"images/i_new.jpg\" name=\"i_new\" width=\"56\" height=\"62\" border=0></a>";
	
	strBttFunction += "<a href=\"javascript:click_search_all()\" onMouseOut=\"MM_swapImgRestore()\" onMouseOver=\"MM_swapImage('i_search','','images/i_search_over.jpg',1)\"><img src=\"images/i_search.jpg\" name=\"i_search\" width=\"56\" height=\"62\" border=0></a>";
	
	con.addData("USER_ROLE", 		 "String", user_role);
	con.addData("APPLICATION", 	  	 "String", app_name);
    con.addData("APPLICATION_GROUP", "String", app_group);
    bolSuccess = con.executeService(strContainerName, "DOCUMENT_TYPE", "findPermission");
    if(bolSuccess) {
    	while(con.nextRecordElement()) {
    		strPermission = con.getColumn("PERMIT_FUNCTION");
    	}
    }
    
    if(strPermission.indexOf("export") != -1){
 		strBttFunction += "<a href=\"javascript:click_excel()\" onMouseOut=\"MM_swapImgRestore()\" onMouseOver=\"MM_swapImage('i_export_excel','','images/i_export-excel_over.jpg',1)\"><img src=\"images/i_export-excel.jpg\" name=\"i_export_excel\" width=\"56\" height=\"62\" border=0></a>";
    }
    
    if(strMethod == null){
    	strMethod = "";
    }
    
    if(strFromPage == null){
    	strFromPage = "";
    }

    	strSQLWhere = "MASTER_SCAN_" + strProjectCode;
    	strDistinct = "";
    
    con.addData("PROJECT_CODE", "String", strProjectCode);
    con.addData("INDEX_TYPE", 	"String", "R");
    bolSuccess = con.executeService(strContainerName, strClassName, "findDocumentIndex");
    if(!bolSuccess){
        session.setAttribute( "REDIRECT_PAGE" , "../caller.jsp?header=header1.jsp&detail=user_menu.jsp" + strRand );
        response.sendRedirect( "inc/check_field.jsp?INDEX_TYPE=R" );
    	return;
    }else{
    	int cnt = 0;
    	
    	while(con.nextRecordElement()){
    		strFieldLabel = con.getColumn("FIELD_LABEL");
    		strConcatFieldLabel += strFieldLabel + ",";
    		
    		strFieldCode = con.getColumn("FIELD_CODE");
    		strConcatFieldIndex += strFieldCode + ",";
    		
    		strFieldType = con.getColumn("FIELD_TYPE");    		
    		strTableZoom = con.getColumn("TABLE_ZOOM");
    		
    		strConcatFieldType += strFieldType + ",";
  		
    		if( strFieldType.equals("ZOOM")||strFieldType.equals("LIST")||strFieldType.equals("MONTH")||strFieldType.equals("MONTH_ENG") ){
    			//strSQLHeader 	+= 	"," + strTableZoom + "." + strTableZoom + "_NAME";
    			strSQLHeader 	+= 	",T" + cnt + "." + strTableZoom + "_NAME";
    			//strSQLJoinTable += 	" LEFT JOIN " + strTableZoom 
    			strSQLJoinTable += 	" LEFT JOIN " + strTableZoom + " T" + cnt
    							+ 	" ON(MASTER_SCAN_" + strProjectCode + "." + strFieldCode + "=" 
							//	+ 	strTableZoom + "." + strTableZoom + " )";
    							+ 	"T" + cnt + "." + strTableZoom + " )";
    			
    			strConcatTableZoom += strTableZoom + ",";
    			
    			cnt++;
    			
    		}else if(strFieldType.equals("DATE")){
    			strConcatTableZoom += "date,";	
    		}else if(strFieldType.equals("DATE_ENG")){
    			strConcatTableZoom += "date_eng,";	
    		}else if(strFieldType.equals("NUMBER")){
    			strConcatTableZoom += "number,";
    		}else if(strFieldType.equals("CURRENCY")){
    			strConcatTableZoom += "currency,";	
    		}else if(strFieldType.equals("TIN")||strFieldType.equals("PIN")){
    			if(strFieldType.equals("TIN")){
    				strConcatTableZoom += "tin,";
    			}else{
    				strConcatTableZoom += "pin,";
    			}
    		}else {
    			strConcatTableZoom += "not,";	
    		}
    	}    	     
//    } //--update alert not field
    
    if( strAccessDocType.equals("A") ) {
    	strAndDocTypeCon = " ";
    }else if( strAccessDocType.equals("L") ) {
		strAndDocTypeCon = " AND DOCUMENT_LEVEL <= '"+ strUserLevel +"'";
	}else {
		if( strSecurityFlag.equals("I") ) {
			strAndDocTypeCon = " AND DOCUMENT_TYPE IN (SELECT DOCUMENT_TYPE FROM DOCUMENT_TYPE_USER WHERE PROJECT_CODE='"+ strProjectCode +"' AND USER_ID='"+ strUserId +"')";
		}else {
			strAndDocTypeCon = " AND DOCUMENT_TYPE IN (SELECT DOCUMENT_TYPE FROM DOCUMENT_TYPE_GROUP WHERE PROJECT_CODE='"+ strProjectCode +"' AND USER_GROUP='"+ strUserGroup +"')";
		}
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
					strCntUserAccess = conAcc.getColumn( "CNT" );
				}
			}
			if( !strCntUserAccess.equals("") && !strCntUserAccess.equals("0") ) {
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
					strCntGroupAccess = conAcc.getColumn( "CNT" );
				}
			}
			if( !strCntGroupAccess.equals("") && !strCntGroupAccess.equals("0") ) {
				strSQLcondition += " AND MASTER_SCAN_" + strProjectCode + ".DOCUMENT_USER IN (SELECT OWNER_USER FROM GROUP_ACCESS_BY_OWNER_USER WHERE PROJECT_CODE='"+ strProjectCode +"' AND USER_GROUP='"+ strUserGroup +"') ";
			}
		}
	}
	
	if(strMethod.equals("SEARCH_TOTAL") || strMethod.equals("SEARCH_DETAIL_DESC")){
	//	strSQLcondition += " AND CONTAINS(" + strSQLWhere +".URL_CONTENT,'" + strSearchDesc + "',1) > 0 ";
            		
            if(strMethod.equals("SEARCH_TOTAL")){
                con.addData("SEARCH_WORDS",   "String", strSearchDesc);
            }else{
                con.addData("SEARCH_WORDS",   "String", strDocumentDesc);
            }

            con.addData("PROJECT_CODE", "String", strProjectCode);
            con.addData("JCR_PORT", "String", lc_port_jackrabbit);
            bolSuccesccSearch = con.executeService(strContainerName, strClassName, "findStoreDocument");
            if(bolSuccesccSearch){
                strDocumentNoAll = con.getHeader( "DOCUMENT_NO" );
            }

            if(!strDocumentNoAll.equals("")){
                strSQLcondition = " AND MASTER_SCAN_" + strProjectCode + ".DOCUMENT_NO IN (" + strDocumentNoAll + ")";
            }else{
                strSQLcondition = " AND MASTER_SCAN_" + strProjectCode + ".DOCUMENT_NO IN ('')";
            }

            if( !strDocUserCon.equals("") ) {
                    strSQLcondition += strDocUserCon + " DOCUMENT_USER='" + strUserId + "'";
            }
		
	}else if(strMethod.equals("SEARCH_DETAIL_DATA")){
		strSQLcondition += " AND " + strDocumentDataValue;
		
	}else if(strMethod.equals("SEARCH_DETAIL_INDEX")){
		strSQLcondition += " AND " + strDocumentFieldValue;		
		
	}
        strSQLcondition += " AND MASTER_SCAN_" + strProjectCode + ".STORE_FLAG <> 'D'";	
	strSQLcondition += " AND MASTER_SCAN_" + strProjectCode + ".INDEX_FLAG = 'C'";
 
    if(!strMethod.equals("") && strMethod != null){
	    con.addData("PAGESIZE", 		"String", strPageSize);
	    con.addData("PAGENUMBER", 		"String", strPageNumber);
	    con.addData("PROJECT_CODE", 	"String", strProjectCode);
	    con.addData("QUERY_HEADER", 	"String", strSQLHeader);
	    con.addData("QUERY_CONDITION", 	"String", strSQLcondition);
	    con.addData("QUERY_WHERE", 		"String", strSQLWhere);
	    con.addData("JOIN_TABLE", 		"String", strSQLJoinTable);
	    con.addData("ORDER_TYPE", 		"String", strOrderType);
	    con.addData("DISTINCT", 		"String", strDistinct);
	    
	    con.addData( "SORT_FIELD" , 	"String" , strSortField );
	   	con.addData( "SORT_BY" , 		"String" , strOrderBy );
	    
	   	if(strSearchDisPlay.equals("ROWNUM")){
	    	con.addData("ROWNUM", "String", strCountRecord);
	    }
	    
	    bolSuccesccSearch = con.executeService(strContainerName, strClassName, "findMasterScanResult");
	    if(!bolSuccesccSearch){
			strErrorMessage = con.getRemoteErrorMesage();
	    }else{
	    	strTotalPage = con.getHeader( "PAGE_COUNT" );
	        strTotalSize = con.getHeader( "TOTAL_RECORD" );
	    }
    }
    }//--update alert not field
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title><%=lc_system_name %> <%=lc_site_name%></title>
<meta http-equiv="Content-Type" content="text/html; charset=tis-620">
<link rel="shortcut icon" href="images/favicon/EDAS.ico" type="image/x-icon" />
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

var objDetailScanWindow = null;
var objDocumentDetail   = null;
var objLinkWindow		= null;

var intSelectedRow = -1;
var strSelectedRowDefaultClassName = "";

function click_new(){
	var strRedirectPage = "<%=strFromPage%>";
	if(strRedirectPage == "SEARCH_TOTAL"){
		form1.action = "search_document1.jsp";
	}else{
		form1.action = "search_document2.jsp";
	}
	form1.METHOD.value = "NEW";
	form1.method = "post";
	form1.submit();
}

function click_search_all(){
	if(!showMsg( 0 , 1 , lc_alert_for_search_all )){
		return;
	}
	form1.PAGENUMBER.value = "1";
	form1.METHOD.value = "SEARCH_ALL";
	form1.method = "post";
	form1.action = "search_result.jsp";
	form1.submit();
}

function click_excel(){
	showExportExcelWindow();
	//formExcel.submit();
}

function click_cancel(){
	top.location = "caller.jsp?header=header1.jsp&detail=user_menu.jsp<%=strRand%>";
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

function change_tab_search( tab_name ) {
	
	switch( tab_name ){
		case 'search_all':
			form1.METHOD.value = "SEARCH_TOTAL";
			form1.action = "search_document1.jsp";
			form1.submit();
			break;
		case 'search_index':
			form1.METHOD.value = "SEARCH_INDEX";     
                        form1.action = "search_document2.jsp";
			form1.submit();
			break;
		case 'search_result':
					
			break;		
	}
	
}

function open_clip( strProjectCode , strBatchno , strDocumentRunning , strStoreFlag ){

	if( frameHidden.form1 ){
		frameHidden.form1.PROJECT_CODE.value	 = strProjectCode;
		frameHidden.form1.BATCH_NO.value		 = strBatchno;
		frameHidden.form1.DOCUMENT_RUNNING.value = strDocumentRunning;
		frameHidden.form1.DOCUMENT_TYPE_CONDITION.value = "<%=strAndDocTypeCon %>";

		formORABCS.PROJECT_CODE.value	  = strProjectCode;
		formORABCS.BATCH_NO.value		  = strBatchno;
		formORABCS.DOCUMENT_RUNNING.value = strDocumentRunning;
		formORABCS.DOCUMENT_TYPE_CONDITION.value = "<%=strAndDocTypeCon %>";

		frameHidden.form1.submit();
	}
	
	get_log(strBatchno,strDocumentRunning);
}


function openDetailScan( strProjectCode , strBatchno , strDocumentRunning ){
	var strUrl = "../detail_scan.jsp?projectcode=" + strProjectCode + "&batchno=" + strBatchno + "&docrun=" + strDocumentRunning;
	objDetailScanWindow = sccUtils.openPopWindow( strUrl , "DETAIL_SCAN"  , 225 , 435 );
	objDetailScanWindow.focus();
}

function openShowView( strBatchno , strDocumentRunning, strDocumentType, strBlobId , strBlobPart ){    
    initAndShow();
    setMail();
    setWaterMark();
    setOfflineDoc(strBatchno , strDocumentRunning , strDocumentType);
    retrieveImage( strBlobId, strBlobPart );
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
    inetdocview.ContainerType("<%=strContainType%>");
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
    
function retrieveImage( blobid, parts ){
   
    if ((blobid != "") && (parts != "")){
        inetdocview.Retrieve(blobid, parts);
    }
}

function click_sort( sort_field, order_type) {
	form1.SORT_FIELD.value = sort_field;
	form1.ORDER_BY.value   = order_type;
	
	form1.submit();
}

function get_log(batch_no,document_running){
	formLog.BATCH_NO.value 		   = batch_no;
	formLog.DOCUMENT_RUNNING.value = document_running;
	formLog.target = "frameLog";
	formLog.action = "master_log.jsp";
	formLog.submit();
}

function open_detail( row_obj){
	var batch_no 	 = row_obj.getAttribute("BATCH_NO");
	var doc_running  = row_obj.getAttribute("DOCUMENT_RUNNING");
	var	project_code = row_obj.getAttribute("PROJECT_CODE");
	var	project_name = row_obj.getAttribute("PROJECT_NAME");
	var	doc_name     = row_obj.getAttribute("DOCUMENT_NAME");
	var	doc_user     = row_obj.getAttribute("DOCUMENT_USER");
	
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

function open_link_doc( project_code, batch_no, doc_running ){
	
	var strPopArgument 	= "scrollbars=yes,status=no";
	var strWidth 		= ",width=800px";
	var strHeight 		= ",height=420px";
	var strUrl 		= "link_document.jsp";
	var strConcatField  = "screenname=<%=screenname%>" +
                            + "&PROJECT_CODE=" + project_code
                            + "&BATCH_NO=" + batch_no 
                            + "&DOCUMENT_RUNNING=" + doc_running
                            + "&user_role=<%=user_role%>&app_name=<%=app_name%>&app_group=<%=app_group%>";
							
	strPopArgument += strWidth + strHeight;						
	
	objLinkWindow = window.open( strUrl + "?" + strConcatField , "link_document" , strPopArgument );
	objLinkWindow.moveTo(0,0);
	objLinkWindow.focus();
	
}

function window_onload() {
	lb_field_seqn.innerHTML  = lbl_field_seqn;
	
//	check_inet_version();
	
	<% if(!bolSuccess){%>
		showMsg( 0 , 0 , lc_add_field_report );
		click_cancel();
		
	<% }else{%>
	
	
	<% if(!bolSuccesccSearch){%>
	lb_search_result_data_not_found.innerHTML = lbl_search_result_data_not_found;
	<%}%>
	<%	if( !strErrorMessage.equals( "" ) ){ %>
	showMsg( 0 , 0 , "<%=strErrorMessage.replaceAll( "\"" , "'" ).replaceAll( "\r" , "" ).replaceAll( "\n" , "<br>" )%>" );
	<% 	}%>

	var per_page = '<%=strPageSize%>';

	form1.PAGE_SIZE.value = per_page;
	
	<%	}%>
}

function window_onunload(){
	
	if( objDocumentDetail != null && !objDocumentDetail.closed ){
		objDocumentDetail.close();
	}
	
	if( objLinkWindow != null && !objLinkWindow.closed ){
		objLinkWindow.close();
	}
	
	if( objDetailScanWindow != null && !objDetailScanWindow.closed ){
		objDetailScanWindow.close();
	}
	try{
		inetdocview.Close();
	}catch( e ){
	}
}

function requestOfflineDoc(volume_label){
	var batch_no		 = formORABCS.BATCH_NO.value;
	var document_running = formORABCS.DOCUMENT_RUNNING.value;
	
	if(batch_no != ""){
		formOffline.BATCH_NO.value 	   = batch_no;
		formOffline.DOCUMENT_RUNNING.value = document_running;
		formOffline.MEDIA_LABEL.value 	   = volume_label;
		
		formOffline.target = "frameOffline";
		formOffline.action = "offline_document.jsp";
		formOffline.submit();
	}
}

function add_commas(obj_value) {
	var rgx = /(\d+)(\d{3})/;
	
	while (rgx.test(obj_value)) {
		obj_value = obj_value.replace(rgx, '$1,$2');	
	}
	return obj_value;
}

function change_result_per_page(){
	form1.submit();	
}

function row_click( objRow ){
	if( intSelectedRow != -1 ){
		table_result.rows[ intSelectedRow ].className = strSelectedRowDefaultClassName;
	}
	intSelectedRow = objRow.rowIndex;
	strSelectedRowDefaultClassName = objRow.className;

	objRow.className = "table_data_mover";
}


//-->
</script>
<link href="css/edas.css" type="text/css" rel="stylesheet">
</head>
<body onLoad="MM_preloadImages('images/txt_condition_over.gif','images/txt_searchresult_over.gif','images/btt_new_over.gif','images/btt_search_over.gif','images/i_new_over.jpg','images/i_search_over.jpg','images/i_export_over.jpg','images/i_doc_over.jpg','images/i_out_over.jpg');window_onload()" onunload="">
<form name="form1" action="" method="post">
<table width="100%" border="0" cellpadding="0" cellspacing="0">
  	<tr> 
    	<td height="39" valign="top" background="images/pw_07.jpg">
    		<table width="100%" height="62" border="0" cellpadding="0" cellspacing="0">
	        	<tr> 
	          		<td height="62" background="images/inner_img_03.jpg"> 
	          			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			              	<tr> 
			                	<td width="117"><img src="images/inner_img_01.jpg" width="117" height="62"></td>
			                	<td valign="bottom">
			                		<%=strBttFunction %><a href="#" onclick="click_cancel()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('i_out','','images/i_out_over.jpg',1)"><img src="images/i_out.jpg" name="i_out" width="56" height="62" border="0"></a></td>
			                	<td width="*" align="right"><div class="label_bold1"> 
			                    	<div align="right" style="padding-right: 30px"><span class="label_header02" title="<%=strProjectCode %>"><%=strProjectName %></span><br>
			                      		<span class="label_bold5">(<%=screenname %>)</span></div>
			                  		</div>
			                  	</td>
			              	</tr>
	            		</table>
            		</td>
        		</tr>
      		</table>
    	</td>
  	</tr>
  	<tr>
    	<td height="29" valign="top" background="images/inner_img_07.jpg">
	    	<table width="100%" border="0" cellpadding="0" cellspacing="0" class="navbar_01">
		        <tr>
		        	<td width="117"><img src="images/inner_img_05.jpg" width="117" height="29"></td>
<%
				String	strButtSearch = "";
				
				if(strFromPage.equals("SEARCH_INDEX")){
					strButtSearch += "<a href=\"javascript:change_tab_search('search_index')\" onMouseOut=\"MM_swapImgRestore()\" onMouseOver=\"MM_swapImage('search_detail','','images/txt_condition_over.gif',1)\"><img id=\"txt_condition\" src=\"images/txt_condition.gif\" name=\"search_detail\" height=25 border=0></a>";
				}else if(strFromPage.equals("SEARCH_TOTAL")){
					strButtSearch += "<a href=\"javascript:change_tab_search('search_all')\" onMouseOut=\"MM_swapImgRestore()\" onMouseOver=\"MM_swapImage('searchtotal','','images/txt_condition_over.gif',1)\"><img id=\"txt_searchtotal\" src=\"images/txt_condition.gif\" name=\"searchtotal\" height=25 border=0></a>";
				}
				strButtSearch += "<a href=\"javascript:change_tab_search('search_result')\" onMouseOut=\"MM_swapImgRestore()\" onMouseOver=\"MM_swapImage('searchresult','','images/txt_searchresult_over.gif',1)\"><img id=\"txt_searchresult\" src=\"images/txt_searchresult_over.gif\" name=\"searchresult\" width=117 height=25 border=0></a>";
%>		          
		          <td width="419" height="29" background="images/inner_img_07.jpg"><%=strButtSearch%></td>
		          <td width="*" class="navbar_01" align="right" style="padding-right: 30px">(<%=strUserOrgName%>) <%=lb_user_name %> : <%=strUserName %> 
		            (<%=strUserId%> / <%=strUserLevel%>)</td>
		        </tr>
	      	</table>
      	</td>
  	</tr>
  	<tr> 
    	<td valign="top" >
	    	<table width="99%" border="0" cellspacing="0" cellpadding="0">
		        <tr> 
		          <td> 
		          	<div align="center"><br>
		              	<table id="table_result" width="99%" border="0" cellpadding="0" cellspacing="0">
			                <tr class="hd_table"> 
			                 	<td width="10"><img src="images/hd_tb_01.gif" width="10" height="28"></td>
			                  	<td width="45"><span id="lb_field_seqn"></span></td> 
<%
		if(bolSuccess){
			
			String	arrNameHeader[] = null;
			String	arrFieldIndex[] = null;
			String	arrTableZoom[]  = null;
			String	arrFieldType[]  = null;
			
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
			
			boolean bolSuccessData = bolSuccesccSearch;
			
			String[] sortImg = new String[arrFieldIndex.length + 1];
			
			if(bolSuccessData){
				
				if(strSortField.equals("DOCUMENT_NO")){					
					for(int idn=0; idn<arrNameHeader.length+1; idn++){
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
				for(int ida=0; ida<arrNameHeader.length+1; ida++){
					sortImg[ida] = "";
				}
			}
				
			String strHalign = "";
			
			for(int arrHead=0; arrHead < arrNameHeader.length; arrHead++){
				strHalign = "";
				
				if(arrTableZoom[arrHead].equals("number")||arrTableZoom[arrHead].equals("currency")){strHalign = "right";}
				else if(arrTableZoom[arrHead].equals("date")||arrTableZoom[arrHead].equals("date_eng")||arrTableZoom[arrHead].equals("tin_pin")){strHalign = "center";}
				else {strHalign = "left";}
				
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
			
			//strColumnName = strColumnName.substring(0,strColumnName.length() - 1);
%>			                
			                  	<td align="right">&nbsp;</td>
			                  	<td align="right">&nbsp;</td>
			                  	<td align="right">&nbsp;</td>
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
				                	<td colspan="<%=arrFieldIndex.length + 6 %>" align="center"><span id="lb_search_result_data_not_found"></span></td>
				                </tr>				
<% 				
			}else{
				
				int cnt = 0;
				String[] strDataIndex = new String[arrFieldIndex.length];
				String	strStoreFlag 		= "";
				String	strBatchNo 			= "";
				String	strDocumentRunning 	= "";
				String  strDocumentName     = "";
				String  strDocumentUser     = "";
				
				while(con.nextRecordElement()){
				
					strStoreFlag 		= con.getColumn("STORE_FLAG");
					strBatchNo 			= con.getColumn("BATCH_NO");
					strDocumentRunning 	= con.getColumn("DOCUMENT_RUNNING");
					strDocumentName 	= con.getColumn("DOCUMENT_NAME");
					strDocumentUser 	= con.getColumn("DOCUMENT_USER");
					
%>
							<tr class="table_data<%=(cnt%2)+1%>" onclick="row_click(this)"> 
				                <td>&nbsp;</td>
				                <td><div align="center"><%=(cnt+1)+intPage %></div></td>
					
<%
						String strAlign = "";
						
						for(int idx=0; idx<arrFieldIndex.length; idx++ ){
							
							strAlign = "";
							
							if(!arrTableZoom[idx].equals("not")&&!arrTableZoom[idx].equals("date")&&!arrTableZoom[idx].equals("date_eng")&&!arrTableZoom[idx].equals("tin")&&!arrTableZoom[idx].equals("pin")&&!arrTableZoom[idx].equals("number")&&!arrTableZoom[idx].equals("currency")){
								strDataIndex[idx] = con.getColumn(arrTableZoom[idx]+ "_NAME");								
								
							}else{
								if(arrTableZoom[idx].equals("date") || arrTableZoom[idx].equals("date_eng")){
									strDataIndex[idx] = dateToDisplay(con.getColumn(arrFieldIndex[idx]),"/");									
								}else if(arrTableZoom[idx].equals("tin")){
									strDataIndex[idx] = "<script> document.write(sccUtils.maskTIN('" + con.getColumn(arrFieldIndex[idx]) + "'));</script>";
								}else if(arrTableZoom[idx].equals("pin")){
									strDataIndex[idx] = "<script> document.write(sccUtils.maskPIN('" + con.getColumn(arrFieldIndex[idx]) + "'));</script>";
								}else if(arrTableZoom[idx].equals("currency")){
									strDataIndex[idx] = con.getColumn(arrFieldIndex[idx]);
									if(strDataIndex[idx].equals("")){
										strDataIndex[idx] = "0.00"	;		
									}else{
										strDataIndex[idx] = setComma(strDataIndex[idx]);
									}
									//strDataIndex[idx] = "<script> document.write(add_commas('" + con.getColumn(arrFieldIndex[idx]) + "'));</script>";
								}else{
									strDataIndex[idx] = con.getColumn(arrFieldIndex[idx]);
								}
							}
						
						if(arrTableZoom[idx].equals("number")||arrTableZoom[idx].equals("currency")){strAlign = "right";}
						else if(arrTableZoom[idx].equals("date")||arrTableZoom[idx].equals("date_eng")||arrTableZoom[idx].equals("tin_pin")){strAlign = "center";}
						else {strAlign = "left";}
						
						out.println("<td><div align=\"" + strAlign +"\"><span style=\"padding-left: 3px\"> " + strDataIndex[idx]+ "</span></div></td>");
					}
%>					        <td align="right" width="20">
                                                    <% if(strPermission.indexOf("search") != -1){ %>
                                                        <a href="#" onclick="open_detail(this)" PROJECT_CODE="<%=strProjectCode %>" PROJECT_NAME="<%=strProjectName %>" BATCH_NO="<%=strBatchNo %>" DOCUMENT_RUNNING="<%=strDocumentRunning %>" DOCUMENT_NAME="<%=strDocumentName %>" DOCUMENT_USER="<%=strDocumentUser %>" ><img src="images/page_detail.gif" name="detail<%=cnt+1 %>" width="16" height="16" border="0" style="cursor:pointer;" title="<%=lb_detail %>"></a>
                                                    <% } %>
                                                </td>
				            	<td align="right" width="20">	
                                                <% if(strPermission.indexOf("search") != -1){ %>
                                                <%
                                                    conAtt.addData("PROJECT_CODE", 	"String", strProjectCode);
                                                    conAtt.addData("BATCH_NO", 		"String", strBatchNo);
                                                    conAtt.addData("DOCUMENT_RUNNING", 	"String", strDocumentRunning);

                                                    boolean bolSuccessAttch = conAtt.executeService(strContainerName, strClassName, "hasAttach");
                                                    if(bolSuccessAttch){
                                                %>
				                		<a href="javascript:open_clip('<%=strProjectCode %>','<%=strBatchNo %>','<%=strDocumentRunning %>','<%=strStoreFlag %>')" ><img src="images/page_attach.gif" name="attach<%=cnt+1 %>" width="16" height="16" border="0" style="cursor:pointer;" title="<%=lb_attachment %>"></a>
				                <%  } %>
				                <% } 
				                
				                %>
				                </td>
				            	<td align="right" width="20">
				                <% if(strPermission.indexOf("link") != -1){ %>
				                <%
						                conAtt.addData("PROJECT_CODE", 		"String", strProjectCode);
										conAtt.addData("BATCH_NO", 			"String", strBatchNo);
										conAtt.addData("DOCUMENT_RUNNING", 	"String", strDocumentRunning);
										
										boolean bolSuccessLink = conAtt.executeService(strContainerName, strClassName, "hasLink");
										if(bolSuccessLink){
				                %>	
				                	<a href="javascript:open_link_doc('<%=strProjectCode%>','<%=strBatchNo%>','<%=strDocumentRunning%>' )"><img src="images/page_link2.gif" name="link<%=cnt+1 %>" width="16" height="16" border="0" style="cursor:pointer;" title="<%=lb_document_link %>"></a>
				                <% 		} %>
				                <% } %>
				                </td>
				            	<td width="11">&nbsp;</td>
		                	</tr>		                            
<%					
					cnt++;					             
				}
			}
		}
%>			                
			                
              	</table>
              	<table width="99%" border="0" cellpadding="0" cellspacing="0" class="footer_table">
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
              <table width="99%" border="0" cellpadding="0" cellspacing="0" class="label_bold2">
              		<tr>
              			<td height="10"></td>
              			<td colspan="3" align="right">
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
            </div>
            <p>&nbsp;</p> </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
<input type="hidden" name="screenname" value="<%=screenname%>">
<input type="hidden" name="user_role"  value="<%=user_role%>">
<input type="hidden" name="app_group"  value="<%=app_group%>">
<input type="hidden" name="app_name"   value="<%=app_name%>">

<input type="hidden" name="METHOD" 	   value="<%=strMethod%>">
<input type="hidden" name="OLD_METHOD" >
<input type="hidden" name="PERMIT_FUNCTION" value="<%=strPermission %>">

<input type="hidden" name="PAGENUMBER" value="<%=strPageNumber%>">
<input type="hidden" name="TOTALPAGE"  value="<%=strTotalPage%>">

<input type="hidden" name="ORDER_TYPE" 		value="<%=strOrderType %>">
<input type="hidden" name="SEARCH_DISPLAY" 	value="<%=strSearchDisPlay %>">
<input type="hidden" name="COUNT_RECORD" 	value="<%=strCountRecord %>">

<input type="hidden" name="DOCUMENT_DATA_VALUE" 	value="<%=strDocumentDataValue %>">
<input type="hidden" name="DOCUMENT_FIELD_VALUE" 	value="<%=strDocumentFieldValue %>">
<input type="hidden" name="DOCUMENT_DESC" 			value="<%=strDocumentDesc %>">
<input type="hidden" name="SEARCH_DESC" 			value="<%=strSearchDesc %>">
<input type="hidden" name="CONCAT_TABLE_ZOOM" />

<input type="hidden" name="SORT_FIELD" 	value="<%=strSortField%>">
<input type="hidden" name="ORDER_BY" 	value="<%=strOrderBy%>">

<input type="hidden" name="FROM_PAGE"  value="<%=strFromPage %>" >

<input type="hidden" name="BATCH_NO_SEARCH"   	  value="<%=strBatchNoSerach %>" >
<input type="hidden" name="DOCUMENT_NAME_SEARCH"  value="<%=strDocumentNameSerach %>" >
<input type="hidden" name="ADD_DATE_SEARCH"  	  value="<%=strAddDateSerach %>" >
<input type="hidden" name="TO_ADD_DATE_SEARCH"    value="<%=strToAddDateSerach %>" >
<input type="hidden" name="EDIT_DATE_SEARCH"  	  value="<%=strEditDateSerach %>" >
<input type="hidden" name="TO_EDIT_DATE_SEARCH"   value="<%=strToEditDateSerach %>" >
<input type="hidden" name="txtDocUser_SEARCH"     value="<%=strDocUserSerach %>" >
<input type="hidden" name="txtDocUser_SEARCH"     value="<%=strDocUserSerach %>" >
<input type="hidden" name="txtDocUserName_SEARCH" value="<%=strDocUserNameSerach %>" >
<input type="hidden" name="ADD_USER_SEARCH"  	  value="<%=strAddUserSerach %>" >
<input type="hidden" name="ADD_USER_NAME_SEARCH"  value="<%=strAddUserNameSerach %>" >
<input type="hidden" name="EDIT_USER_SEARCH"  	  value="<%=strEditUserSerach %>" >
<input type="hidden" name="EDIT_USER_NAME_SEARCH" value="<%=strEditUserNameSerach %>" >
<input type="hidden" name="selConditionA_SEARCH"  value="<%=strSelConA %>" >
<input type="hidden" name="selConditionB_SEARCH"  value="<%=strSelConB %>" >
<input type="hidden" name="selConditionC_SEARCH"  value="<%=strSelConC %>" >
<input type="hidden" name="selConditionD_SEARCH"  value="<%=strSelConD %>" >
<input type="hidden" name="selConditionE_SEARCH"  value="<%=strSelConE %>" >
<input type="hidden" name="selConditionF_SEARCH"  value="<%=strSelConF %>" >

<input type="hidden" name="SEARCH_FIELD_VALUE"  value="<%=strSearchFieldValue %>" >
<input type="hidden" name="CONCAT_FIELD_NAME"   value="<%=strConcatFieldName %>" >
<input type="hidden" name="SEARCH_OPERATOR"		value="<%=strSearchOperator %>">
<input type="hidden" name="SEARCH_CONDITION"	value="<%=strSearchCondition %>">

</form>
<form name="formExcel" action="Export2ExcelServlet" method="post">
        <input type="hidden" name="CONTAINER_NAME"  	value="<%=strContainerName %>">
	<input type="hidden" name="PROJECT_CODE"  	value="<%=strProjectCode %>">
	<input type="hidden" name="QUERY_HEADER"  	value="<%=strSQLHeader %>">
	<!--<input type="hidden" name="QUERY_CONDITION" value="<%=strSQLcondition %>">-->
        <input type="hidden" name="USER_LEVEL"    value="<%=strUserLevel %>">
        <input type="hidden" name="SECURITY_FLAG" value="<%=strSecurityFlag %>">
        <input type="hidden" name="ACCESS_TYPE"   value="<%=strAccessType %>">
        <input type="hidden" name="DOCUMENT_FIELD_VALUE" value="<%=strDocumentFieldValue %>">
        <input type="hidden" name="DOCUMENT_DATA_VALUE"  value="<%=strDocumentDataValue %>">
        <input type="hidden" name="USER_ID"          value="<%=strUserId %>">
        <input type="hidden" name="USER_GROUP"       value="<%=strUserGroup %>">
        <input type="hidden" name="DOC_USER_CON"     value="<%=strDocUserCon %>">
        <input type="hidden" name="METHOD"           value="<%=strMethod %>">
        <input type="hidden" name="CNT_USER_ACCESS"  value="<%=strCntUserAccess %>">
        <input type="hidden" name="CNT_GROUP_ACCESS" value="<%=strCntGroupAccess %>">
        <input type="hidden" name="DOCUMENT_NO_ALL"  value="<%=strDocumentNoAll %>">
        
	<input type="hidden" name="QUERY_WHERE"  	value="<%=strSQLWhere %>">
	<input type="hidden" name="JOIN_TABLE"  	value="<%=strSQLJoinTable %>">
	<input type="hidden" name="ORDER_TYPE"  	value="<%=strOrderType %>">
	<input type="hidden" name="DISTINCT"  		value="<%=strDistinct %>">
	<input type="hidden" name="SORT_FIELD"  	value="<%=strSortField %>">
	<input type="hidden" name="SORT_BY"  		value="<%=strOrderBy %>">
<% if(strSearchDisPlay.equals("ROWNUM")){ %>   	
   	<input type="hidden" name="ROWNUM"  		value="<%=strCountRecord %>">
<%	} %>   
    <input type="hidden" name="QUERY_TAG"      	value="EXPORT_SEARCH_RESULT">
    <input type="hidden" name="CONTAINER_NAME" 	value="<%=strContainerName%>">
    <input type="hidden" name="CLASS_NAME"     	value="EXPORT2EXCEL">
    <input type="hidden" name="METHOD_NAME"    	value="exportSearchResult">
    <input type="hidden" name="COLUMN_NAME"    	value="<%=strColumnName %>">
    <input type="hidden" name="COLUMN_CODE"    	value="<%=strColumnCode %>">
    <input type="hidden" name="SET_CODE_FLAG"   value="N">
</form>
<%@ include file="inc/export_excel_div.jsp" %>
<form name="formLog">
  <input type="hidden" name="PROJECT_CODE">
  <input type="hidden" name="BATCH_NO">
  <input type="hidden" name="DOCUMENT_RUNNING">
  <input type="hidden" name="ACTION_FLAG" value="V">
</form>
<form name="formORABCS">
  <input type="hidden" name="PROJECT_CODE">
  <input type="hidden" name="BATCH_NO">
  <input type="hidden" name="DOCUMENT_RUNNING">
  <input type="hidden" name="DOCUMENT_TYPE_CONDITION">
  <input type="hidden" name="DOCUMENT_TYPE">
</form>
<form name="formOffline">
  <input type="hidden" name="BATCH_NO">
  <input type="hidden" name="DOCUMENT_RUNNING">
  <input type="hidden" name="MEDIA_LABEL">
</form>
<iframe name="frameHidden" src="inc/openClip.jsp" width="0" height="0"></iframe>
<iframe name="frameGuard" src="guard/htmlguard_E2.html" width="0" height="0"></iframe>
<iframe name="frameLog"  	style="display:none"></iframe>
<iframe name="frameOffline" style="display:none"></iframe>
<iframe scrolling="no" frameborder="0" name="inetdocview" src="/jinetdocarchive/imageproxy?codetype=applet&version=15&securecode=<%=securecode%>" style="width:0px; height:0px; border: 0px">
</iframe>

</body>
</html>
