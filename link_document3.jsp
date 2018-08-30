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
    String strProjectCode   = userInfo.getProjectCode();
    String strUserEmail 	= checkNull(session.getAttribute("USER_EMAIL"));

    String strProjectCodeLink	= checkNull( request.getParameter( "PROJECT_CODE_LINK" ) );
    String strProjectNameLink	= getField( request.getParameter( "PROJECT_NAME_LINK" ) );

    String strSortField = checkNull( request.getParameter( "SORT_FIELD" ) );
    String strOrderBy 	= checkNull( request.getParameter( "ORDER_BY" ) );

    String strAccessType    = (String)session.getAttribute( "ACCESS_TYPE" );
    String strUserGroup     = (String)session.getAttribute( "USER_GROUP" );
    String strSecurityFlag  = (String)session.getAttribute( "SECURITY_FLAG" );
    String strCount         = "";

    String 	strClassName 	 = "EDIT_DOCUMENT";
    String 	strErrorMessage  = "";

    String 	strConcatTableZoom	= "";
    String	strSQLHeader 		= "";
    String	strSQLJoinTable 	= "";
    String	strSQLcondition 	= "";
    String	strSQLWhere 		= "";
    String	strDistinct		= "";
    String	strFieldType 		= "";
    String	strFieldCode 		= "";
    String	strFieldLabel		= "";
    String	strTableZoom		= "";
    String  strWaterMarkFlag = "";

    String	strCurrentDate  = "";
    String strVersionLang  = ImageConfUtil.getVersionLang();
    String  strContainerType = ImageConfUtil.getInetContainerType();


    if( strVersionLang.equals("thai") ) {
            strCurrentDate = getTodayDateThai();
    }else{
            strCurrentDate = getTodayDate();
    }

    String strMethod 	= request.getParameter( "METHOD" );
    String strOldMethod = request.getParameter( "OLD_METHOD" );

    String	strBatchNo 		   = checkNull(request.getParameter("BATCH_NO"));
    String	strDocumentRunning = checkNull(request.getParameter("DOCUMENT_RUNNING"));

    String strConcatBatchnoLink 		= checkNull( request.getParameter( "CONCAT_BATCH_NO_LINK" ) );
    String strConcatDocumentRunningLink = checkNull( request.getParameter( "CONCAT_DOCUMENT_RUNNING_LINK" ) );

    String strConcatFieldLabel	 = checkNull( request.getParameter( "CONCAT_FIELD_LABEL" ) );
    String strConcatFieldIndex 	 = checkNull( request.getParameter( "CONCAT_FIELD_INDEX" ) );
    String strDocumentDataValue  = getField( request.getParameter( "DOCUMENT_DATA_VALUE" ) );
    String strDocumentFieldValue = getField( request.getParameter( "DOCUMENT_FIELD_VALUE" ) );
    String strDocumentDesc 		 = getField( request.getParameter( "DOCUMENT_DESC" ) );
    String strSearchDesc 		 = getField( request.getParameter( "SEARCH_DESC" ) );

    String strOrderType     = checkNull(request.getParameter("ORDER_TYPE"));
    String strSearchDisPlay = checkNull(request.getParameter("SEARCH_DISPLAY"));
    String strCountRecord   = checkNull(request.getParameter("COUNT_RECORD"));
    
    String user_role = getField(request.getParameter("user_role"));
    String app_name  = getField(request.getParameter("app_name"));
    String app_group = getField(request.getParameter("app_group"));

    String strInsertBatchnoLink[] 	  = {};
    String strInsertDocumentRunningLink[] = {};

    String strPageNumber = checkNull(request.getParameter("PAGENUMBER"));
    String strPageSize   = checkNull(request.getParameter("PAGE_SIZE"));
    String strTotalPage  = "1";	
    String strTotalSize  = "0";
    String strPermission  = "";

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
    boolean bolSuccesccSearch    = false;
    boolean bolSuccessAddLink    = false;
    boolean bolnWaterMarkSuccess = false;
    boolean bolnAccType          = false;

    con.addData("USER_ROLE", 	"String", user_role);
    con.addData("APPLICATION", 	"String", app_name);
    con.addData("APPLICATION_GROUP", "String", app_group);
    if(con.executeService(strContainerName, "DOCUMENT_TYPE", "findPermission")) {
        while(con.nextRecordElement()) {
            strPermission = con.getColumn("PERMIT_FUNCTION");
        }
    }

    con.addData("PROJECT_CODE", "String", strProjectCode);
    bolnWaterMarkSuccess = con.executeService(strContainerName, "PROJECT_MANAGER", "findWaterMarkFlag");
    if(bolnWaterMarkSuccess){
            strWaterMarkFlag = con.getHeader("WATERMARK_FLAG");
    }else{
            strWaterMarkFlag = "N";
    }

    String	strBttFunction	= "<a href=\"javascript:click_new()\" onMouseOut=\"MM_swapImgRestore()\" onMouseOver=\"MM_swapImage('i_new','','images/i_new_over.jpg',1)\"><img src=\"images/i_new.jpg\" name=\"i_new\" width=\"56\" height=\"62\" border=0></a>";
                    strBttFunction += "<a href=\"javascript:click_search_all()\" onMouseOut=\"MM_swapImgRestore()\" onMouseOver=\"MM_swapImage('i_search','','images/i_search_over.jpg',1)\"><img src=\"images/i_search.jpg\" name=\"i_search\" width=\"56\" height=\"62\" border=0></a>";    
	
    if(strMethod == null){
    	strMethod = "";
    }
    
    if(strMethod.equals("ADD_LINK")){
    	
    	con.addData( "PROJECT_CODE" 	, "String" , strProjectCode );
    	con.addData( "BATCH_NO" 		, "String" , strBatchNo );
    	con.addData( "DOCUMENT_RUNNING" , "String" , strDocumentRunning );
        con.addData( "USER_ID" 			, "String" , strUserId );
        con.addData( "CURRENT_DATE" 	, "String" , strCurrentDate );

        strInsertBatchnoLink 		 = strConcatBatchnoLink.split( "</>" );
        strInsertDocumentRunningLink = strConcatDocumentRunningLink.split( "</>" );
        
        if( strConcatBatchnoLink.length() > 0 ){

            for( int intArr = 0 ; intArr < strInsertBatchnoLink.length ; intArr++ ){
                con.addData( "DETAIL_LINK." + ( intArr + 1 ) + ".PROJECT_CODE_LINK" 	   , "String" , strProjectCodeLink );
                con.addData( "DETAIL_LINK." + ( intArr + 1 ) + ".BATCH_NO_LINK" 		   , "String" , strInsertBatchnoLink[ intArr ] );
                con.addData( "DETAIL_LINK." + ( intArr + 1 ) + ".DOCUMENT_RUNNING_LINK"    , "String" , strInsertDocumentRunningLink[ intArr ] );
            }
        }
        
        bolSuccessAddLink = con.executeService(strContainerName, "MASTER_LINK", "createMasterLink");
        if( !bolSuccessAddLink ){
            strErrorMessage = lc_cannot_save_data_link;
        }

        strMethod = strOldMethod;
    }
    
//    if(strMethod.equals("SEARCH_DETAIL_DESC")||strMethod.equals("SEARCH_TOTAL")){	
//	    strSQLJoinTable += 	"JOIN MASTER_SCAN_" + strProjectCodeLink + " ON "
//		+	"(DOC_ATTACH_" + strProjectCodeLink + ".BATCH_NO="
//		+ 	"MASTER_SCAN_" + strProjectCodeLink + ".BATCH_NO AND "
//		+	"DOC_ATTACH_"  + strProjectCodeLink + ".DOCUMENT_RUNNING="
//		+ 	"MASTER_SCAN_" + strProjectCodeLink + ".DOCUMENT_RUNNING) ";
	    
//	    strSQLWhere = "DOC_ATTACH_" + strProjectCodeLink;
//	    strDistinct = "DISTINCT";
//    }else{
    	strSQLWhere = "MASTER_SCAN_" + strProjectCodeLink;
    	strDistinct = "";
//    }
    
    con.addData("PROJECT_CODE", "String", strProjectCodeLink);
    con.addData("INDEX_TYPE", 	"String", "R");
    bolSuccess = con.executeService(strContainerName, strClassName, "findDocumentIndex");
    if(!bolSuccess){
    	strErrorMessage = con.getRemoteErrorMesage();
    }else{
    	int cnt = 0;
    	
    	while(con.nextRecordElement()){
    		strFieldLabel = con.getColumn("FIELD_LABEL");
    		strConcatFieldLabel += strFieldLabel + ",";
    		
    		strFieldCode = con.getColumn("FIELD_CODE");
    		strConcatFieldIndex += strFieldCode + ",";
    		
    		strFieldType = con.getColumn("FIELD_TYPE");    		
    		strTableZoom = con.getColumn("TABLE_ZOOM");
  		
    		if( strFieldType.equals("ZOOM")||strFieldType.equals("LIST")||strFieldType.equals("MONTH")||strFieldType.equals("MONTH_ENG") ){
    		//	strSQLHeader 	+= 	"," + strTableZoom + "." + strTableZoom + "_NAME";
    			strSQLHeader 	+= 	",T" + cnt + "." + strTableZoom + "_NAME";
    		//	strSQLJoinTable += 	" LEFT JOIN " + strTableZoom
    			strSQLJoinTable += 	" LEFT JOIN " + strTableZoom + " T" + cnt
    							+ 	" ON(MASTER_SCAN_" + strProjectCodeLink + "." + strFieldCode + "=" 
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
	
	if(strMethod.equals("SEARCH_TOTAL") || strMethod.equals("SEARCH_DETAIL_DESC")){
	//	strSQLcondition += " AND CONTAINS(" + strSQLWhere +".URL_CONTENT,'" + strSearchDesc + "',1) > 0 ";
            
            String strDocumentNoAll = "";
			
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
		
	}else if(strMethod.equals("SEARCH_DETAIL_DATA")){
		strSQLcondition += " AND " + strDocumentDataValue;
		
	}else if(strMethod.equals("SEARCH_DETAIL_INDEX")){
		strSQLcondition += " AND " + strDocumentFieldValue;		
		
//	}else if(strMethod.equals("SEARCH_DETAIL_DESC")){
//		strSQLcondition += " AND CONTAINS(" + strSQLWhere + ".URL_CONTENT,'" + strDocumentDesc + "',1) > 0 ";
//		strSQLcondition += " AND " + strSQLWhere + ".CONTAINER_TYPE <> 'ORA'";
	}
	
	strSQLcondition += " AND MASTER_SCAN_" + strProjectCodeLink + ".STORE_FLAG <> 'D'";
	strSQLcondition += " AND MASTER_SCAN_" + strProjectCodeLink + ".INDEX_FLAG = 'C'";
 
    if(!strMethod.equals("") && strMethod != null){
	    con.addData("PAGESIZE", 		"String", strPageSize);
	    con.addData("PAGENUMBER", 		"String", strPageNumber);
	    con.addData("PROJECT_CODE", 	"String", strProjectCodeLink);
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

var	objDetailScanWindow = null;
var objDocumentDetail   = null;

function click_new(){
	form1.action 		= "link_document2.jsp";
	form1.METHOD.value  = "NEW";
	form1.method 		= "post";
	form1.submit();
}

function click_cancel(){
	formBack.target = "_self";
	formBack.submit();
}

function click_search_all(){
	if(!showMsg( 0 , 1 , lc_alert_for_search_all )){
		return;
	}
	form1.PAGENUMBER.value = "1";
	form1.METHOD.value = "SEARCH_ALL";
	form1.method = "post";
	form1.action = "link_document3.jsp";
	form1.submit();
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

function click_save(){
	var objCheckboxSelect = form1.CHK_SELECT;
	var objLabelSelect    = null;
	var bolnCheck 		  = false;
	var strConcatBatchno  = "";
	var strConcatDocumentRunning = "";
	
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
					strConcatBatchno 	 += objLabelSelect.getAttribute("BATCH_NO_LINK") + "</>";
					strConcatDocumentRunning += objLabelSelect.getAttribute("DOCUMENT_RUNNING_LINK") + "</>";
				}				
			}
		}

		if(strConcatBatchno.length == 0){
			alert(lc_check_add_link);
			return;
		}

		if( strConcatBatchno.length > 0 ){
			strConcatBatchno = strConcatBatchno.substr( 0 , strConcatBatchno.length - "</>".length );
		}
		if( strConcatDocumentRunning.length > 0 ){
			strConcatDocumentRunning = strConcatDocumentRunning.substr( 0 , strConcatDocumentRunning.length - "</>".length );
		}

	}else{
		bolnCheck = objCheckboxSelect.checked;

		objLabelSelect = eval( "LABEL_SELECT0" );

		if( objLabelSelect ){
			strConcatBatchno 		 = objLabelSelect.getAttribute("BATCH_NO_LINK");
			strConcatDocumentRunning = objLabelSelect.getAttribute("DOCUMENT_RUNNING_LINK");
		}
	}

	if( bolnCheck ){
		form1.CONCAT_BATCH_NO_LINK.value 	 = strConcatBatchno;
		form1.CONCAT_DOCUMENT_RUNNING_LINK.value = strConcatDocumentRunning;
		
		form1.OLD_METHOD.value = form1.METHOD.value;
		form1.METHOD.value = "ADD_LINK";
		form1.method = "post";
		form1.action = "link_document3.jsp";
		form1.submit();
	}
}

function change_tab_search( tab_name ) {
	
	switch( tab_name ){
		case 'search_all':
			form1.METHOD.value = "SEARCH_TOTAL";
			form1.action = "link_document2.jsp";
			form1.submit();
			break;
		case 'search_index':
			form1.METHOD.value = "SEARCH_INDEX";
			form1.action = "link_document2.jsp";
			form1.submit();
			break;
		case 'search_result':
					
			break;		
	}
	
}

function open_clip( strProjectCode , strBatchno , strDocumentRunning , strStoreFlag ){
/*	if( strStoreFlag == "P" ){
		return;
	}
*/
	if( frameHidden.form1 ){
		frameHidden.form1.PROJECT_CODE.value	 = strProjectCode;
		frameHidden.form1.BATCH_NO.value		 = strBatchno;
		frameHidden.form1.DOCUMENT_RUNNING.value = strDocumentRunning;

		formORABCS.PROJECT_CODE.value	  = strProjectCode;
		formORABCS.BATCH_NO.value		  = strBatchno;
		formORABCS.DOCUMENT_RUNNING.value = strDocumentRunning;

		frameHidden.form1.submit();
	}
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
    var lv_project_link = form1.PROJECT_CODE_LINK.value;
    offUtils.setOfflineCtrl(lv_project_link, "<%=strUserId%>", "<%=strCurrentDate%>", strBatchno, strDocumentRunning, strDocumentType);    
}

function retrieveImage( strBlobId, strBlobPart ){
    
    if ((strBlobId != "") && (strBlobPart != "")){
        inetdocview.Retrieve(strBlobId, strBlobPart);
    }
}

function click_sort( sort_field, order_type) {
	form1.SORT_FIELD.value = sort_field;
	form1.ORDER_BY.value   = order_type;
	
	form1.submit();
}

function open_detail( row_obj){
	var batch_no 	 = row_obj.getAttribute("BATCH_NO");
	var doc_running  = row_obj.getAttribute("DOCUMENT_RUNNING");
	var	project_code = row_obj.getAttribute("PROJECT_CODE");
	var	project_name = row_obj.getAttribute("PROJECT_NAME");

	if(batch_no == ""){
		return;			
	}
	
	var strUrl = "detail_search.jsp?PROJECT_CODE=" + project_code + "&PROJECT_NAME=" + project_name
                    + "&user_role=<%=user_role%>&app_name=<%=app_name%>&app_group=<%=app_group%>"
                    + "&BATCH_NO=" + batch_no + "&DOCUMENT_RUNNING=" + doc_running;
			   
	objDocumentDetail = sccUtils.openChildWindow( "DOCUMENT_DETAIL" );
	objDocumentDetail.location = strUrl;
	
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

function check_not_select_all() {
	document.getElementById("CHECK_ALL").checked = false;
}

function window_onload() {
	
//	check_inet_version();

	<% if(!bolSuccesccSearch){ %>
	lb_search_result_data_not_found.innerHTML = lbl_search_result_data_not_found
	<%}	%>	
	<%	if( !strErrorMessage.equals( "" ) ){ %>
	showMsg( 0 , 0 , "<%=strErrorMessage.replaceAll( "\"" , "'" ).replaceAll( "\r" , "" ).replaceAll( "\n" , "<br>" )%>" );
	<% 	}%>
	
	<% if(bolSuccessAddLink){%>
	showMsg( 0 , 0 , "<%=lc_save_data_link_success%>");
	click_cancel();
	
	<% } %>

	var per_page = '<%=strPageSize%>';

	form1.PAGE_SIZE.value = per_page;
}

function window_onunload(){
	
	if( objDocumentDetail != null && !objDocumentDetail.closed ){
		objDocumentDetail.close();
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
		formOffline.BATCH_NO.value 		   = batch_no;
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
//-->
</script>
<link href="css/edas.css" type="text/css" rel="stylesheet">
</head>
<body onLoad="MM_preloadImages('images/txt_search_over.gif','images/txt_searchtotal_over.gif','images/txt_searchresult_over.gif','images/btt_new_over.gif','images/btt_search_over.gif','images/i_new_over.jpg','images/save2_over.gif','images/i_out_over.jpg');window_onload()" onunload="">
<form name="form1" action="" method="post">
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
  	<tr> 
    	<td height="39" valign="top" background="images/pw_07.jpg">
    		<table width="100%" height="62" border="0" cellpadding="0" cellspacing="0">
	        	<tr> 
	          		<td height="62" background="images/inner_img_03.jpg"> 
	          			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			              	<tr> 
			                	<td width="117"><img src="images/inner_img_01.jpg" width="117" height="62"></td>
			                	<td width="600" valign="bottom">
			                		<%=strBttFunction %><a href="#" onclick="click_cancel()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('i_out','','images/i_out_over.jpg',1)"><img src="images/i_out.jpg" name="i_out" width="56" height="62" border="0"></a></td>
			                	<td width="*"><div class="label_bold1"> 
			                    	<div align="right" style="padding-right: 30px"><span class="label_header02" title="<%=strProjectCodeLink %>"><%=strProjectNameLink %></span><br>
			                      		<span class="label_bold5">(<%=lb_search_document_link %>)</span></div>
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
				
				strButtSearch += "<a href=\"javascript:change_tab_search('search_index')\" onMouseOut=\"MM_swapImgRestore()\" onMouseOver=\"MM_swapImage('search_detail','','images/txt_search_over.gif',1)\"><img id=\"txt_search\" src=\"images/txt_search.gif\" name=\"search_detail\" width=117 height=25 border=0></a>";
				strButtSearch += "<a href=\"javascript:change_tab_search('search_all')\" onMouseOut=\"MM_swapImgRestore()\" onMouseOver=\"MM_swapImage('searchtotal','','images/txt_searchtotal_over.gif',1)\"><img id=\"txt_searchtotal\" src=\"images/txt_searchtotal.gif\" name=\"searchtotal\" width=117 height=25 border=0></a>";
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
		              	<table width="99%" border="0" cellpadding="0" cellspacing="0">
			                <tr class="hd_table"> 
			                 	<td width="10"><img src="images/hd_tb_01.gif" width="10" height="28"></td>
			                  	<td width="45"><input type="checkbox" id="CHECK_ALL" onclick="check_select_all()"></td> 
<%
			String	arrNameHeader[] = null;
			String	arrFieldIndex[] = null;
			String	arrTableZoom[]  = null;
			
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
			}
%>			                
			                  	<td><div align="center"></div></td>
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
				                	<td colspan="<%=arrFieldIndex.length + 7 %>" align="center"><span id="lb_search_result_data_not_found"></span></td>
				                </tr>				
<% 				
			}else{
				
				int cnt = 0;
				String[] strDataIndex = new String[arrFieldIndex.length];
				String	strStoreFlag 				= "";
				String	strBatchNoLinkData 			= "";
				String	strDocumentRunningLinkData 	= "";
				
				while(con.nextRecordElement()){
				
					strStoreFlag 				= con.getColumn("STORE_FLAG");
					strBatchNoLinkData 			= con.getColumn("BATCH_NO");
					strDocumentRunningLinkData 	= con.getColumn("DOCUMENT_RUNNING");
					
%>
							<tr class="table_data<%=(cnt%2)+1%>" > 
				                <td>&nbsp;</td>
				                <td><div align="center"><input type="checkbox" name="CHK_SELECT" onclick="check_not_select_all()"></div></td>
					
<%
						String strAlign = "";
						
						for(int idx=0; idx<arrFieldIndex.length; idx++ ){
							
							strAlign = "";
							
							if(!arrTableZoom[idx].equals("not")&&!arrTableZoom[idx].equals("date")&&!arrTableZoom[idx].equals("date_eng")&&!arrTableZoom[idx].equals("tin")&&!arrTableZoom[idx].equals("pin")&&!arrTableZoom[idx].equals("number")&&!arrTableZoom[idx].equals("currency")){
								strDataIndex[idx] = con.getColumn(arrTableZoom[idx]+ "_NAME");								
								
							}else{
								if(arrTableZoom[idx].equals("date")||arrTableZoom[idx].equals("date_eng")){
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
%>					            <td align="right" width="20">
									<a href="#" onclick="open_detail(this)" PROJECT_CODE="<%=strProjectCodeLink %>" PROJECT_NAME="<%=strProjectNameLink %>" BATCH_NO="<%=strBatchNoLinkData %>" DOCUMENT_RUNNING="<%=strDocumentRunningLinkData %>" ><img src="images/page_detail.gif" name="detail<%=cnt+1 %>" width="16" height="16" border="0" style="cursor:pointer;" title="<%=lb_detail %>"></a>
								</td>
				            	<td align="right" width="20">	
								<%
										conAtt.addData("PROJECT_CODE", 		"String", strProjectCodeLink);
										conAtt.addData("BATCH_NO", 			"String", strBatchNoLinkData);
										conAtt.addData("DOCUMENT_RUNNING", 	"String", strDocumentRunningLinkData);
										
										boolean bolSuccessAttch = conAtt.executeService(strContainerName, strClassName, "hasAttach");
										if(bolSuccessAttch){
								%>
				                		<a href="javascript:open_clip('<%=strProjectCodeLink %>','<%=strBatchNoLinkData %>','<%=strDocumentRunningLinkData %>','<%=strStoreFlag %>')" ><img src="images/page_attach.gif" name="attach<%=cnt+1 %>" width="16" height="16" border="0" style="cursor:pointer;" title="<%=lb_attachment %>"></a>
				                <%		} %>
				                		<label id="LABEL_SELECT<%=cnt%>" BATCH_NO_LINK="<%=strBatchNoLinkData%>" DOCUMENT_RUNNING_LINK="<%=strDocumentRunningLinkData%>" ></label>
				                
				                </td>
				            	<td width="11">&nbsp;</td>
		                	</tr>		                            
<%					
					cnt++;					             
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
            </td>
        </tr>
        <tr>
        	<td height="25">&nbsp;</td>
        </tr>
        <tr>
        	<td align="center">
        		<a href="javascript:click_save()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('save','','images/btt_save2_over.gif',1)"><img src="images/btt_save2.gif" name="save" width="67" height="22" border="0" ></a>
        	</td>
        </tr>
      </table>
    </td>
  </tr>
</table>

<input type="hidden" name="CONCAT_BATCH_NO_LINK" >
<input type="hidden" name="CONCAT_DOCUMENT_RUNNING_LINK" >

<input type="hidden" name="user_role"  value="<%=user_role%>">
<input type="hidden" name="app_group"  value="<%=app_group%>">
<input type="hidden" name="app_name"   value="<%=app_name%>">

<input type="hidden" name="METHOD" value="<%=strMethod%>">
<input type="hidden" name="OLD_METHOD" >
<input type="hidden" name="PERMIT_FUNCTION" value="prnImg">

<input type="hidden" name="PROJECT_CODE_LINK" 	value="<%=strProjectCodeLink%>">
<input type="hidden" name="PROJECT_NAME_LINK"  	value="<%=strProjectNameLink%>">

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

<input type="hidden" name="BATCH_NO" 		 value="<%=strBatchNo %>">
<input type="hidden" name="DOCUMENT_RUNNING" value="<%=strDocumentRunning %>">

</form>
<form name="formORABCS">
  <input type="hidden" name="PROJECT_CODE">
  <input type="hidden" name="BATCH_NO">
  <input type="hidden" name="DOCUMENT_RUNNING">
  <input type="hidden" name="DOCUMENT_TYPE">
</form>
<form name="formOffline">
  <input type="hidden" name="BATCH_NO">
  <input type="hidden" name="DOCUMENT_RUNNING">
  <input type="hidden" name="MEDIA_LABEL">
</form>
<form name="formBack" action="link_document1.jsp" method="post">
<input type="hidden" name="BATCH_NO" 		 value="<%=strBatchNo %>">
<input type="hidden" name="DOCUMENT_RUNNING" value="<%=strDocumentRunning %>">
<input type="hidden" name="user_role"  value="<%=user_role%>">
<input type="hidden" name="app_group"  value="<%=app_group%>">
<input type="hidden" name="app_name"   value="<%=app_name%>">
</form>
<iframe name="frameHidden" src="inc/openClip.jsp" width="0" height="0"></iframe>
<iframe name="frameOffline" style="display:none"></iframe>
<iframe scrolling="no" frameborder="0" name="inetdocview" src="/jinetdocarchive/imageproxy?codetype=applet&version=15&securecode=<%=securecode%>" style="width:0px; height:0px; border: 0px">
</iframe>

</body>
</html>
