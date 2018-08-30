<%@page import="com.scc.edms.conf.ImageConfUtil"%>
<%@ page contentType="text/html; charset=tis-620"%>
<%@ page import="com.scc.security.UserInfo"%>
<%@ include file="inc/checkUser.jsp" %>
<%@ include file="inc/constant.jsp" %>
<%@ include file="inc/label.jsp" %>
<%@ include file="inc/utils.jsp" %>
<jsp:useBean id="con" scope="session" class="edms.cllib.EABConnector"/>
<jsp:useBean id="conList" scope="session" class="edms.cllib.EABConnector"/>
<jsp:useBean id="conLV" scope="session" class="edms.cllib.EABConnector"/>
<jsp:useBean id="conCode" scope="session" class="edms.cllib.EABConnector"/>
<jsp:useBean id="conDoc" scope="session" class="edms.cllib.EABConnector"/>
<jsp:useBean id="conDetail" scope="session" class="edms.cllib.EABConnector"/>
<%
    String securecode = "";
    con.setRemoteServer("EAS_SERVER");
    conList.setRemoteServer("EAS_SERVER");
    conLV.setRemoteServer("EAS_SERVER");
    conCode.setRemoteServer("EAS_SERVER");
    conDoc.setRemoteServer("EAS_SERVER");
    conDetail.setRemoteServer("EAS_SERVER");
	
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
    String strUserOrg	    = userInfo.getUserOrg();
    String strUserOrgName   = userInfo.getUserOrgName();
    String strUserLevel     = userInfo.getUserLevel();
    String strProjectCode   = userInfo.getProjectCode();
    String strProjectName   = userInfo.getProjectName();

    String strXML = "<?xml version=\"1.0\"?>";
    strXML += "<Fields>";

    String user_role      = getField(request.getParameter("user_role"));
    String app_name       = getField(request.getParameter("app_name"));
    String app_group      = getField(request.getParameter("app_group"));
    String screenname     = getField(request.getParameter("screenname"));
    String strProjectFlag = getField(request.getParameter("project_flag"));

    String strAccessDocTypeData = (String)session.getAttribute( "ACCESS_DOC_TYPE" );
    String strUserGroup         = (String)session.getAttribute( "USER_GROUP" );
    String strSecurityFlag      = (String)session.getAttribute( "SECURITY_FLAG" );
    String strAndDocTypeCon     = "";

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

    //------------------------------------------------------------------------//

    String strMethod 	= checkNull(request.getParameter( "METHOD" ));
    String strMethod2 	= checkNull(request.getParameter( "METHOD2" ));
    String strOldMethod = checkNull(request.getParameter( "OLD_METHOD" ));

    if(strOldMethod.equals("")){strOldMethod = strMethod;}

    String strConcatFieldName	= getField( request.getParameter( "CONCAT_FIELD_NAME" ) );
    String strTextIndex         = getField( request.getParameter( "TEXT_INDEX" ) );
    String strDocumentSetField 	= getField( request.getParameter( "DOCUMENT_SET_FIELD" ) );

    String strConcatDocumentType    = getField( request.getParameter( "CONCAT_DOCUMENT_TYPE" ) );
    String strConcatDocumentLevel   = getField( request.getParameter( "CONCAT_DOCUMENT_LEVEL" ) );
    String strConcatVersionLimit    = getField( request.getParameter( "CONCAT_VERSION_LIMIT" ) );
    String strConcatNewVersion      = getField( request.getParameter( "CONCAT_NEW_VERSION" ) );
    String strConcatBlobID          = getField( request.getParameter( "CONCAT_BLOBID" ) );
    String strConcatBlobPart        = getField( request.getParameter( "CONCAT_BLOBPART" ) );
    String strConcatUsedSizeArg     = getField( request.getParameter( "CONCAT_USED_SIZE_ARG" ) );
    String strConcatScanNo          = getField( request.getParameter( "CONCAT_SCAN_NO" ) );
    String strConcatXmlTag          = getField( request.getParameter( "CONCAT_XML_TAG" ) );
    String strConcatBlobFlag        = getField( request.getParameter( "CONCAT_BLOB_FLAG" ) );
    String strConcatFileType        = getField( request.getParameter( "CONCAT_FILE_TYPE" ) );
    String strConcatFileName        = getField( request.getParameter( "CONCAT_FILE_NAME" ) );
    String strConcatContent        = getField( request.getParameter( "CONCAT_CONTENT" ) );
   
    String strDocumentFieldInsert   = getField( request.getParameter( "DOCUMENT_FIELD_INSERT" ) );
    String strDocumentValueInsert   = getField( request.getParameter( "DOCUMENT_VALUE_INSERT" ) );

    String strDocumentNo        = checkNull( request.getParameter( "DOCUMENT_NO" ) );
    String strDocumentLevel 	= checkNull( request.getParameter( "txtDocLevel" ) );
    String strDspExpireDate 	= checkNull( request.getParameter( "txtExpireDate" ) );
    String strStorehouse 	= checkNull( request.getParameter( "STORE_HOUSE" ) );
    String strExpireDate 	= checkNull( request.getParameter( "EXPIRE_DATE" ) );
    String strStorehouseName 	= getField( request.getParameter( "txtStoreHouse" ) );
    String strDocumentName      = getField( request.getParameter( "txtDocName" ) );
    String strDocumentUser      = getField( request.getParameter( "txtDocUser" ) );
    String strDocumentOrg       = checkNull( request.getParameter( "txtDocOrg" ) );

    String strDocUserName     = "";
    String strDocUserSname    = "";
    String strDocUserTitle    = "";
    String strDocUserFullName = "";

    String strPageSize		= checkNull( request.getParameter( "PAGE_SIZE" ) );
    String strPageNumber	= checkNull( request.getParameter( "PAGENUMBER" ) );
    String strTotalPage		= checkNull( request.getParameter( "TOTALPAGE" ) );
    String strOrderType		= checkNull( request.getParameter( "ORDER_TYPE" ) );
    String strSearchDisPlay	= getField( request.getParameter( "SEARCH_DISPLAY" ) );
    String strCountRecord	= checkNull( request.getParameter( "COUNT_RECORD" ) );
    String strDocumentDataValue	= getField( request.getParameter( "DOCUMENT_DATA_VALUE" ) );
    String strDocumentFieldValue = getField( request.getParameter( "DOCUMENT_FIELD_VALUE" ) );
    String strDocumentDesc	= getField( request.getParameter( "DOCUMENT_DESC" ) );
    String strSearchDesc 	= getField( request.getParameter( "SEARCH_DESC" ) );

    String strBatchNo         = checkNull( request.getParameter( "BATCH_NO" ) );
    String strDocumentRunning = checkNull( request.getParameter( "DOCUMENT_RUNNING" ) );
    String strCheckStatus     = checkNull( request.getParameter( "CHECK_STATUS" ) );

    String strSortField = checkNull( request.getParameter( "SORT_FIELD" ) );
    String strOrderBy   = checkNull( request.getParameter( "ORDER_BY" ) );	

    String strDocumentTypeDel  = getField( request.getParameter("DOCUMENT_TYPE_DELETE") );
    String strDocumentTypeMove = getField( request.getParameter("hidDocTypeMove") );
    String strActionMove       = getField( request.getParameter("ACTION") );
	
    String strClassName     = "EDIT_DOCUMENT";
    String strErrorMessage  = "";
    String strCurrentDate   = "";
    String strPermission    = "";
    String strConTainerType = ImageConfUtil.getInetContainerType();
    String strVersionLang   = ImageConfUtil.getVersionLang();
    String strSite          = ImageConfUtil.getCustomerSite();
    String strStoreInPDF    = ImageConfUtil.getInetStorePDF();

    String strLevelName	  = "";
    String strPictSizeAll = "0";

    String strAddUserId     = "";
    String strEditUserId    = "";
    String strAddUserName   = "";
    String strEditUserName  = "";
    String strAddDate       = "";
    String strEditDate      = "";
    String strBoxNo         = "";
    String strLangFlag      = "";

    if(strVersionLang.equals("thai")){
        strCurrentDate = getTodayDateThai();
        strLangFlag    = "1";
    }else{
        strCurrentDate = getTodayDate();
        strLangFlag    = "0";
    }
    
    String strUsedSize  = getField( request.getParameter( "USED_SIZE" ) );
    String strAvailSize = getField( request.getParameter( "AVAIL_SIZE" ) );
    String strTotalSize = getField( request.getParameter( "TOTAL_SIZE" ) );
    //String strVerLimitDef = "";
    
    String strDataLabel[]     = {};
    String strDataSeq[]       = {};
    String strDataName[]      = {};
    String strDataType[]      = {};
    String strDataLength[]    = {};
    String strDataTableZoom[] = {};
    String strDataSize[]      = {};
    String strDataValue[]     = {};
    String strDataPK[]        = {};
    String strDataNotNull[] = {};

    String strDataTableLevel[]  = {};
    String strDataTableLevel1[] = {};
    String strDataTableLevel2[] = {};
	
    String strDataDocumentType[] , strDataDocumentLevel[] , strBlob[] , strPict[] , strUsedSizeArg[];
    String strDataVersionLimit[] , strDataNewVersion[] , strDataScanNo[];
    String strXmlTag[] , strBlobFlag[];
    String strFileTypes[] , strFileNames[];
    String strContent[];
    
    String strGenField[] = new String[0];
    
    int intGenField = 0;
    
    String strGenFieldValue[] = null;
	
    long longUsedSize = 0 , longAvailSize = 0 , longTotalSize = 0;

    if( strUsedSize.length() == 0 ){
        strUsedSize = "0";
    }
    
    if( strAvailSize.length() == 0 ){
        strAvailSize = "0";
    }
    
    longAvailSize = Long.parseLong( strAvailSize );

    if( strTotalSize.length() == 0 ){
        strTotalSize = "0";
    }
    longTotalSize = Long.parseLong( strTotalSize );

    
    if( strConcatFieldName.length() > 0 ){
       strGenField = strConcatFieldName.split( "," );
    }
    
    intGenField = strGenField.length;    
    strGenFieldValue = new String[ intGenField ];
    
    for( int intCountField = 0 ; intCountField < intGenField ; intCountField++ ){
       strGenFieldValue[ intCountField ] = getField( request.getParameter( strGenField[ intCountField ] ) );
    }

    if(strMethod == null || strMethod.equals("")){
        strMethod = "INIT";
    }

    String strBttFunction = "";

    boolean bolSuccess           = false;
    boolean bolnUpdateSuccess    = false;
    boolean bolDelSuccess        = false;	
    boolean bolnFieldSuccess     = true;
    boolean bolnCheckSuccess     = false;
    boolean bolnSiteSuccess      = false;
    boolean bolnDetailSuccess    = false;
    
    bolnSiteSuccess = con.executeService(strContainerName, "SYSTEM_CONFIG", "findSystemConfigAll");
    if(!bolnSiteSuccess) {
    	strSite = "SCC";
    }else{
    	strSite = con.getHeader("SITE");
    }
	
    //con.addData("USER_ROLE", 	"String", user_role);
    //con.addData("APPLICATION", 	"String", "EDIT_DOCUMENT");
    
    //bolSuccess = con.executeService(strContainerName, "IMPORTDATA", "findEditPermission");
    //if(!bolSuccess) {
    //	strEditPermit = "true";
    //}else{
    //	strEditPermit = "false";
    //}
    
    con.addData("USER_ROLE",         "String", user_role);
    con.addData("APPLICATION",       "String", app_name);
    con.addData("APPLICATION_GROUP", "String", app_group);
    
    bolSuccess = con.executeService(strContainerName, "DOCUMENT_TYPE", "findPermission");
    if(bolSuccess) {
    	while(con.nextRecordElement()) {
            strPermission = con.getColumn("PERMIT_FUNCTION");
    	}
    }
  
    if(strPermission.indexOf("update") != -1){
        strBttFunction += "<a href=\"javascript:click_save()\" onMouseOut=\"MM_swapImgRestore()\" onMouseOver=\"MM_swapImage('i_save','','images/i_save_over.jpg',1)\"><img src=\"images/i_save.jpg\" name=\"i_save\" width=\"56\" height=\"62\" border=0></a>";
    }

//    if(edaUtils.hasOCR()){
//        strBttFunction += "<a href=\"javascript:click_ocr()\" onMouseOut=\"MM_swapImgRestore()\" onMouseOver=\"MM_swapImage('i_ocr','','images/i_ocr_over.jpg',1)\"><img src=\"images/i_ocr.jpg\" name=\"i_ocr\" width=56 height=62 border=0></a>";		
//    }
	
    strBttFunction +="<a href=\"javascript:click_docmove()\" onMouseOut=\"MM_swapImgRestore()\" onMouseOver=\"MM_swapImage('i_movedoc','','images/i_movedoc_over.jpg',1)\"><img src=\"images/i_movedoc.jpg\" name=\"i_movedoc\" width=56 height=62 border=0></a>";

    con.addData( "PROJECT_CODE" , "String" , strProjectCode );

    bolnFieldSuccess = con.executeService(strContainerName, "IMPORTDATA", "findFieldDocument");

    if( bolnFieldSuccess ){
	
        int intTotalField = con.getRecordTotal();
        int intCountField = 0;

        strDataLabel 	  = new String[ intTotalField ];
        strDataSeq 	 	  = new String[ intTotalField ];
        strDataName 	  = new String[ intTotalField ];
        strDataType 	  = new String[ intTotalField ];
        strDataLength 	  = new String[ intTotalField ];
        strDataTableZoom  = new String[ intTotalField ];
        strDataSize 	  = new String[ intTotalField ];
        strDataValue 	  = new String[ intTotalField ];
        strDataPK         = new String[ intTotalField ];
        strDataNotNull 	  = new String[ intTotalField ];

        strDataTableLevel  = new String[ intTotalField ];
        strDataTableLevel1 = new String[ intTotalField ];
        strDataTableLevel2 = new String[ intTotalField ];

        strConcatFieldName = "";

        while( con.nextRecordElement() ){
            strDataLabel[ intCountField ] 	= con.getColumn( "FIELD_LABEL" );
            strDataSeq[ intCountField ] 	= con.getColumn( "FIELD_SEQN" );
            strDataName[ intCountField ] 	= con.getColumn( "FIELD_CODE" );
            strDataType[ intCountField ] 	= con.getColumn( "FIELD_TYPE" );
            strDataLength[ intCountField ] 	= con.getColumn( "FIELD_LENGTH" );
            strDataTableZoom[ intCountField ] 	= con.getColumn( "TABLE_ZOOM" );
            strDataTableLevel[ intCountField ] 	= con.getColumn( "TABLE_LEVEL" );
            strDataPK[ intCountField ] 		= con.getColumn( "IS_PK" );
            strDataNotNull[ intCountField ] 	= con.getColumn( "IS_NOTNULL" );
            strDataTableLevel1[ intCountField ]	= con.getColumn( "TABLE_LEVEL1" );
            strDataTableLevel2[ intCountField ]	= con.getColumn( "TABLE_LEVEL2" );
            strDataSize[ intCountField ] 	= strDataLength[ intCountField ];

            if( Integer.parseInt( strDataSize[ intCountField ] ) > 40 ){
                strDataSize[ intCountField ] = "40";
            }else{
                strDataSize[ intCountField ] = String.valueOf( Integer.parseInt( strDataSize[ intCountField ] ) + 2 );
            }
            
            strConcatFieldName += strDataName[ intCountField ] + ",";
            intCountField++;
        }
    }
	
    if(strMethod.equals("UPDATE")){

        if(strMethod2.equals("CHECKIN")){
                strCheckStatus = "CHECKIN";
        }

        String strCheckUser = "";
        
        if(strCheckStatus.equals("CHECKOUT")){
                strCheckUser = "'" +strUserId + "'";
        }else{
                strCheckUser = "NULL";
        }	
        con.addData( "PROJECT_CODE", 	"String", strProjectCode );
        con.addData( "CURRENT_DATE", 	"String", strCurrentDate );
        con.addData( "DOCUMENT_LEVEL", 	"String", strDocumentLevel );
        con.addData( "DOCUMENT_NAME", 	"String", strDocumentName );
        con.addData( "DOCUMENT_USER", 	"String", strDocumentUser );
        con.addData( "DOCUMENT_ORG", 	"String", strDocumentOrg );
        con.addData( "EXPIRE_DATE", 	"String", strExpireDate );
        con.addData( "USER_ID", 	"String", strUserId );
        con.addData( "CHECK_STATUS", 	"String", strCheckStatus );
        con.addData( "CHECKOUT_USER", 	"String", strCheckUser );
        con.addData( "SCAN_ORG", 	"String", strUserOrg );
        con.addData( "STOREHOUSE", 	"String", strStorehouse );
        con.addData( "CONTAINER_TYPE", 	"String", strConTainerType );
        con.addData( "SITE", 		"String", strSite );
        
        con.addData( "BATCH_NO", 	 "String", strBatchNo );
        con.addData( "DOCUMENT_RUNNING", "String", strDocumentRunning );
		
        if( strDocumentFieldInsert.length() > 0 ){
            con.addData( "DOCUMENT_FIELD_INSERT" , "String" , strDocumentFieldInsert );
            con.addData( "DOCUMENT_VALUE_INSERT" , "String" , strDocumentValueInsert );
        }
        
        if( strTextIndex.length() > 0 ){
            con.addData( "TEXT_INDEX" , "String" , strTextIndex );
        }

        if( strDocumentSetField.length() > 0 ){
            con.addData( "DOCUMENT_SET_FIELD" , "String" , strDocumentSetField );
        }

        for( int intCountField = 0 ; intCountField < strGenField.length ; intCountField++ ){
            if( strGenFieldValue[ intCountField ].length() > 0 ){
                con.addData( strGenField[ intCountField ].replaceAll( "DSP_" , "" ) , "String" , strGenFieldValue[ intCountField ] );
            }
        }
		
        strDataDocumentType  = strConcatDocumentType.split( "," );
        strDataDocumentLevel = strConcatDocumentLevel.split( "," );
        strDataVersionLimit  = strConcatVersionLimit.split( "," );
        strDataNewVersion 	 = strConcatNewVersion.split( "," );
        strBlob 		 = strConcatBlobID.split( "," );
        strPict 		 = strConcatBlobPart.split( "," );
        strUsedSizeArg 		 = strConcatUsedSizeArg.split( "," );
        strDataScanNo 		 = strConcatScanNo.split( "," );
        strXmlTag 		 = strConcatXmlTag.split( "," );
        strBlobFlag 		 = strConcatBlobFlag.split( "," );
        strFileTypes 		 = strConcatFileType.split( "," );
        strFileNames 		 = strConcatFileName.split( "," );
        strContent 		 = strConcatContent.split( "," );

        if( strConcatDocumentType.length() > 0 ){
            for( int intArr = 0 ; intArr < strDataDocumentType.length ; intArr++ ){
                con.addData( "DETAIL." + ( intArr + 1 ) + ".DOCUMENT_TYPE" 	, "String" , strDataDocumentType[ intArr ] );
                con.addData( "DETAIL." + ( intArr + 1 ) + ".DOCUMENT_LEVEL" , "String" , strDataDocumentLevel[ intArr ] );
                con.addData( "DETAIL." + ( intArr + 1 ) + ".SCAN_NO" 		, "String" , strDataScanNo[ intArr ] );
                con.addData( "DETAIL." + ( intArr + 1 ) + ".VERSION_LIMIT" 	, "String" , strDataVersionLimit[ intArr ] );
                con.addData( "DETAIL." + ( intArr + 1 ) + ".NEW_VERSION" 	, "String" , strDataNewVersion[ intArr ] );
                con.addData( "DETAIL." + ( intArr + 1 ) + ".BLOB" 		, "String" , strBlob[ intArr ] );
                con.addData( "DETAIL." + ( intArr + 1 ) + ".PICT" 		, "String" , strPict[ intArr ] );
                con.addData( "DETAIL." + ( intArr + 1 ) + ".PICT_SIZE" 		, "String" , strUsedSizeArg[ intArr ] );
                con.addData( "DETAIL." + ( intArr + 1 ) + ".XML_TAG" 		, "String" , strXmlTag[ intArr ] );
                con.addData( "DETAIL." + ( intArr + 1 ) + ".BLOB_FLAG" 		, "String" , strBlobFlag[ intArr ] );		
                con.addData( "DETAIL." + ( intArr + 1 ) + ".FILE_TYPE" 		, "String" , strFileTypes[ intArr ] );
                con.addData( "DETAIL." + ( intArr + 1 ) + ".FILE_NAME" 		, "String" , strFileNames[ intArr ] );
                con.addData( "DETAIL." + ( intArr + 1 ) + ".CONTENT" 		, "String" , strContent[ intArr ] );

                longUsedSize += Long.parseLong( strUsedSizeArg[ intArr ] );
            }
        }

        if( longUsedSize >= longAvailSize ){
            strErrorMessage = lc_total_size_full;
        }else{

        con.addData( "FULLTEXT_SEARCH" , "String" , lc_fulltext_search );
        con.addData("JCR_PORT",          "String" , lc_port_jackrabbit);
        bolnUpdateSuccess = con.executeService(strContainerName, strClassName, "updateMasterScan");
            if( !bolnUpdateSuccess ){
                strErrorMessage = con.getRemoteErrorMesage();
            }else{
                if(strMethod2.equals("CHECKIN")){
                        strMethod = "CHECK_STATUS";
                }				
            }
        }
    }
	
    if(strMethod.equals("DELETE_DOCTYPE")){

        con.addData("PROJECT_CODE", 	"String", strProjectCode );
        con.addData("BATCH_NO", 	"String", strBatchNo );
        con.addData("DOCUMENT_RUNNING", "String", strDocumentRunning );
        con.addData("DOCUMENT_TYPE", 	"String", strDocumentTypeDel );
        bolDelSuccess = con.executeService(strContainerName, strClassName, "deleteDocumentType");
        if(!bolDelSuccess){
            strErrorMessage = lc_delete_document;
        }
    }
	
    if( strMethod.equals("UPDATE_DOCTYPE") ) {
        con.addData( "PROJECT_CODE",       "String", strProjectCode );
        con.addData( "BATCH_NO",           "String", strBatchNo );
        con.addData( "DOCUMENT_RUNNING",   "String", strDocumentRunning );
        con.addData( "DOCUMENT_TYPE",      "String", strDocumentTypeDel );
        con.addData( "DOCUMENT_TYPE_MOVE", "String", strDocumentTypeMove );
        con.addData( "CURRENT_DATE",       "String", strCurrentDate );
        con.addData( "USER_ID",            "String", strUserId );
        bolDelSuccess = con.executeService( strContainerName, strClassName, "updateDocumentTypeMove" );
        if(!bolDelSuccess){
            strErrorMessage = lc_delete_document;
        }
    }
	
    if(strMethod.equals("CHECK_STATUS")){
        String 	strCheckFlag = "";
        String	strCheckOutUser = "";
        
        if(strCheckStatus.equals("CHECKIN")){
            strCheckFlag 	= "I";
            strCheckOutUser = "NULL";
        }else{
            strCheckFlag 	= "O";
            strCheckOutUser = "'" + strUserId + "'";
        }

        con.addData("PROJECT_CODE", 	"String", strProjectCode );
        con.addData("CHECK_STATUS", 	"String", strCheckStatus );
        con.addData("CHECKOUT_USER", 	"String", strCheckOutUser );
        con.addData("CURRENT_DATE", 	"String", strCurrentDate );
        con.addData("USER_ID", 			"String", strUserId );
        con.addData("ACTION_FLAG", 		"String", strCheckFlag );
        con.addData("BATCH_NO", 		"String", strBatchNo );
        con.addData("DOCUMENT_RUNNING", "String", strDocumentRunning );

        bolnCheckSuccess = con.executeService(strContainerName, strClassName, "updateCheckStatus");
        if(!bolnCheckSuccess){

            if(!strMethod2.equals("CHECKIN")){

                if(strCheckStatus.equals("CHECKIN")){
                        strErrorMessage = lc_cannot_check_in;
                }else{
                        strErrorMessage = lc_cannot_check_out;
                }
            }
        }
    }
	
    String  strFieldCode 	= "";
    String  strFieldTyp 	= "";
    String  strTableZoom 	= "";
    String  strSQLHeader 	= "";	
    String  strSQLJoinTable = "";
	
    con.addData("PROJECT_CODE", "String", strProjectCode);
    con.addData("INDEX_TYPE", 	"String", "R");
    bolSuccess = con.executeService(strContainerName, strClassName, "findDocumentIndex");
    if(!bolSuccess){
        strErrorMessage = con.getRemoteErrorMesage();
    }else{
    	int cnt = 0;
    	
    	while(con.nextRecordElement()){
    		
            strFieldCode = con.getColumn("FIELD_CODE");
            strFieldTyp  = con.getColumn("FIELD_TYPE");    		
            strTableZoom = con.getColumn("TABLE_ZOOM");

            if( strFieldTyp.equals("ZOOM")||strFieldTyp.equals("LIST")||strFieldTyp.equals("MONTH")||strFieldTyp.equals("MONTH_ENG") ){
                strSQLHeader 	+= ",T" + cnt + "." + strTableZoom + "_NAME";
                strSQLJoinTable += " LEFT JOIN " + strTableZoom + " T" + cnt
                                +  " ON(MASTER_SCAN_" + strProjectCode + "." + strFieldCode + "=" 
                                +  "T" + cnt + "." + strTableZoom + " )";
                cnt++;
            }
    	}    	     
    }

    con.addData("PROJECT_CODE", 	"String", strProjectCode);
    con.addData("BATCH_NO",	 		"String", strBatchNo);
    con.addData("DOCUMENT_RUNNING", "String", strDocumentRunning);
    con.addData("QUERY_HEADER", 	"String", strSQLHeader);
    con.addData("JOIN_TABLE", 		"String", strSQLJoinTable);
    
    bolSuccess = con.executeService(strContainerName, strClassName, "findEachMasterScanByBatchNo");
    if(!bolSuccess) {
    	
    }else {
        strDocumentNo 	    = con.getHeader("DOCUMENT_NO");
        strDocumentLevel 	= con.getHeader("DOCUMENT_LEVEL");
        strDocumentName     = con.getHeader("DOCUMENT_NAME");
        strDocumentUser     = con.getHeader("DOCUMENT_USER");
        strDocumentOrg      = con.getHeader("DOCUMENT_ORG");
        strLevelName	 	= con.getHeader("LEVEL_NAME");
        strAddUserId 	 	= con.getHeader("ADD_USER");
        strEditUserId 	 	= con.getHeader("EDIT_USER");
        strAddDate 	 	 	= con.getHeader("ADD_DATE");
        strEditDate 	 	= con.getHeader("EDIT_DATE");
        strExpireDate 	 	= con.getHeader("EXPIRE_DATE");
        strStorehouse 	 	= con.getHeader("STOREHOUSE");
        strStorehouseName	= con.getHeader("STOREHOUSE_NAME");
   		
        if( strDocumentUser != null ) {
            if( !strDocumentUser.equals("") ) {
                conDetail.addData( "USER_ID", strDocumentUser );
                bolnDetailSuccess = conDetail.executeService( strContainerName, strClassName, "findDocumentUserDetail" );
                if( bolnDetailSuccess ) {
                        strDocUserName  = conDetail.getHeader( "USER_NAME" );
                        strDocUserSname = conDetail.getHeader( "USER_SNAME" );
                        strDocUserTitle = conDetail.getHeader( "TITLE_NAME" );
                        strDocUserFullName = strDocUserTitle + strDocUserName + " " + strDocUserSname;
                }
            }
        }else{
            out.println("Warnning : Field 'DOCUMENT_USER' doesn't exist.");
        }
   		
        for( int intCountField = 0 ; intCountField < strDataName.length ; intCountField++ ){
                strDataValue[ intCountField ] = con.getHeader( strDataName[ intCountField ] );				
        }
    }	
    
    if(!strAddUserId.equals("")){
    	con.addData("USER_ID", "String", strAddUserId);
        
        bolSuccess = con.executeService(strContainerName, "USER_PROFILE", "findUserById");
        if(bolSuccess) {
        	strAddUserName = con.getHeader("USER_NAME") + " " + con.getHeader("USER_SNAME");
        }else {
        	strAddUserName = "";
        }
    }
    
    if(!strEditUserId.equals("")){
    	con.addData("USER_ID", "String", strEditUserId);
        
        bolSuccess = con.executeService(strContainerName, "USER_PROFILE", "findUserById");
        if(bolSuccess) {
        	strEditUserName = con.getHeader("USER_NAME") + " " + con.getHeader("USER_SNAME");
        }else {
        	strEditUserName = "";
        }
    }
	
    if(!strExpireDate.equals("-")&&!strExpireDate.equals("")) {
    	strDspExpireDate  = dateToDisplay(strExpireDate, "/");    	
    }
    if(!strEditDate.equals("")) {
    	strEditDate = dateToDisplay(strEditDate, "/");    	
    }
    if(!strAddDate.equals("")) {
    	strAddDate  = dateToDisplay(strAddDate, "/");    	
    }
    
    con.addData("PROJECT_CODE",     "String", strProjectCode);
    con.addData("BATCH_NO",         "String", strBatchNo);
    con.addData("DOCUMENT_RUNNING", "String", strDocumentRunning);
    bolSuccess = con.executeService(strContainerName, "BOX_MANAGE", "findBoxDesc");
    if(bolSuccess) {
    	strBoxNo = con.getHeader("BOX_NO");
    }else {
    	strBoxNo = "";
    }
    
    con.addData("PROJECT_CODE", "String", strProjectCode);
    
    boolean bolSizeSuccess = con.executeService(strContainerName, "IMPORTDATA", "findDocumentInfo");
    if(!bolSizeSuccess) {
    	out.println("error : " + con.getRemoteErrorMesage());
    }else {
        strTotalSize	 = con.getHeader("TOTAL_SIZE");
        strAvailSize	 = con.getHeader("AVIAIL_SIZE");
        strUsedSize	 = con.getHeader("USED_SIZE");
        //strVerLimitDef = con.getHeader("VERSION_LIMIT");
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
<script language="JavaScript" src="js/XML.js"></script>
<script language="JavaScript" src="js/imageTemplate.js"></script>
<script language="JavaScript" src="js/waterMark.js"></script>
<script language="JavaScript" src="js/jquery-1.9.1.js"></script>
<script language="javascript" type="text/javascript">
<!--

var sccUtils 		= new SCUtils();
var waterMk  		= new waterMark();
var offUtils 		= new offlineUtils();
var imgTemplate 	= new imageTemplate();
var fullTextSearch 	= "<%=lc_fulltext_search%>";
var temp_check_date = "";

var strActiveBlobSeq;
var strActiveDocumentType;

var objZoomWindow;
var objDocMoveWindow;
var objVersionWindow;

function change_version(ver_obj, rdo_idx, doc_type){

    var ver_limit = document.getElementById(ver_obj);

    if(rdo_idx == 1 ){
        ver_limit.className = "input_box";
        ver_limit.readOnly  = false;
        eval("form1.NEW_VERSION" + doc_type + ".value = 'Y'");
    }else{
        ver_limit.className = "input_box_disable";
        ver_limit.readOnly  = true;
        eval("form1.NEW_VERSION" + doc_type + ".value = 'N'");
    }		
}

function click_cancel(){
	
//	form1.CHECK_STATUS.value = "CHECKIN";
//	form1.METHOD.value = "CHECK_STATUS";
//	form1.method = "post";
//	form1.action = "edit_document3.jsp";
//	form1.submit();

    var batch_no	 = "<%=strBatchNo%>";
    var document_running = <%=strDocumentRunning%>;
    
    $.ajaxSetup({ cache : false});
    
    $.getJSON( 
        "edasservlet" , 
        { 
            "PROJECT_CODE" : "<%=strProjectCode%>",
            "CHECK_STATUS" : "CHECKIN", 
            "CURRENT_DATE" : "<%=strCurrentDate%>", 
            "USER_ID" : "<%=strUserId%>", 
            "BATCH_NO" : batch_no, 
            "DOCUMENT_RUNNING" : document_running,
            "CONTAINER_NAME" : "<%=strContainerName%>",
            "METHOD" : "updateCheckStatus"
        },			 
        function( data ){
            if(data.SUCCESS == 'success'){
                if(batch_no != ""){
                    get_log(batch_no,document_running,"I");
                }
                 click_back();
            }else{
                  showMsg( 0 , 0 , "<%=lc_cannot_check_in%>" );
            }
    });
}

function click_save(){
    temp_check_date = "";
    get_concat_blob_ID();
    set_concat_document_field();

    if( validate_mandatory_field() ){

    if(temp_check_date =="N"){
        showMsg( 0 , 0 , lc_day_invalid );
        return;        	
    }
        submit_form();
    }	
}

function click_ocr(){
    try{
            getOCRResult();
    }catch( e ){
    }
}

function submit_form(){
    
    open_loading();

//    form1.METHOD.value 	= "UPDATE";
//<% if(strCheckStatus.equals("CHECKOUT")){%>
//
//    form1.METHOD2.value	= "CHECKIN";
//
//<% } %>	
//    form1.method = "post";
//    form1.action = "edit_document3.jsp";
//    form1.submit();

    update_document();
}

function update_document() {
    $.ajaxSetup({cache: false});
    $.getJSON(
        "addeditservlet",
        {
            "PROJECT_CODE": "<%=strProjectCode%>",
            "BATCH_NO": form1.BATCH_NO.value,
            "DOCUMENT_RUNNING": form1.DOCUMENT_RUNNING.value,
            "CURRENT_DATE": "<%=strCurrentDate%>",
            "USER_ID": "<%=strUserId%>",
            "SCAN_ORG": "<%=strUserOrg%>",
            "CONTAINER_TYPE": "<%=strConTainerType%>",
            "FULLTEXT_SEARCH": "<%=lc_fulltext_search%>",
            "DOCUMENT_LEVEL": form1.txtDocLevel.value,
            "STORE_HOUSE": form1.STORE_HOUSE.value,
            "EXPIRE_DATE": form1.EXPIRE_DATE.value,
            "DOCUMENT_NAME": form1.txtDocName.value,
            "DOCUMENT_USER": form1.txtDocUser.value,
            "DOCUMENT_ORG": form1.txtDocOrg.value,
            "DOCUMENT_FIELD_INSERT": form1.DOCUMENT_FIELD_INSERT.value,
            "DOCUMENT_VALUE_INSERT": form1.DOCUMENT_VALUE_INSERT.value,
            "DOCUMENT_VALUE_DUPLICATE": form1.DOCUMENT_VALUE_DUPLICATE.value,
            "CONCAT_FIELD_NAME": form1.CONCAT_FIELD_NAME.value,
            "CONCAT_DOCUMENT_TYPE": form1.CONCAT_DOCUMENT_TYPE.value,
            "CONCAT_DOCUMENT_LEVEL": form1.CONCAT_DOCUMENT_LEVEL.value,
            "CONCAT_VERSION_LIMIT": form1.CONCAT_VERSION_LIMIT.value,
            "CONCAT_NEW_VERSION": form1.CONCAT_NEW_VERSION.value,
            "CONCAT_BLOBID": form1.CONCAT_BLOBID.value,
            "CONCAT_BLOBPART": form1.CONCAT_BLOBPART.value,
            "CONCAT_USED_SIZE_ARG": form1.CONCAT_USED_SIZE_ARG.value,
            "CONCAT_XML_TAG": form1.CONCAT_XML_TAG.value,
            "CONCAT_FILE_TYPE": form1.CONCAT_FILE_TYPE.value,
            "CONCAT_FILE_NAME": form1.CONCAT_FILE_NAME.value,
            "CONCAT_SCAN_NO": form1.CONCAT_SCAN_NO.value,
            "CONCAT_BLOB_FLAG": form1.CONCAT_BLOB_FLAG.value,
            "CONCAT_DOCTYPE_DELETE": form1.CONCAT_DOCTYPE_DELETE.value,
            "USED_SIZE": "<%=strUsedSize%>",
            "AVAIL_SIZE": "<%=strAvailSize%>",
            "TOTAL_SIZE": "<%=strTotalSize%>",
            "CHECK_STATUS": "CHECK_OUT",
            "DOCUMENT_SET_FIELD": form1.DOCUMENT_SET_FIELD.value,
            "TEXT_INDEX": form1.TEXT_INDEX.value,
            "JCR_PORT": "<%=lc_port_jackrabbit%>",
            "CONTAINER_NAME": "<%=strContainerName%>",
            "METHOD": "updateDocument"
        },
    function(data) {
        if (data.SUCCESS == 'success') {

            close_loading();

            showMsg(0, 0, lc_process_complete);

            var batch_no = form1.BATCH_NO.value;
            var document_running = form1.DOCUMENT_RUNNING.value;

            if (batch_no != "") {
                get_log(batch_no, document_running, "U");
            }

            click_back();
        } else {
            close_loading();

            showMsg( 0 , 0 , data.ERROR );
        }
    });
}

function click_back(){
    formEdit.METHOD.value = form1.OLD_METHOD.value;
    formEdit.submit();
}	

function validate_mandatory_field(){

    if(!validate_expire_date()){
            return false;
    }
    if(!validate_NotNull_field()){
            return false;
    }

    if(!validate_tin_pin_field()){
            return false;
    }
    if(!validate_gen_field()){
            return false;
    }
    return true; 
}

function validate_expire_date(){
    var strExpireDate = form1.txtExpireDate.value;
    var strStartDate  = form1.txtAddDate.value;


    if( strExpireDate.length == 0 ){
            form1.EXPIRE_DATE.value = "-";
            return true;
    }
    if( new SCUtils().isDateValid( strExpireDate ) != "VALID_DATE" ){
    showMsg( 0 , 0 , lc_expire_day_invalid );

    div_info.style.display = "inline";
    document.getElementById('tab_img_data').src = "images/tab_img_data_down.gif";
    form1.txtExpireDate.focus();
    return false;
    }
    if( new SCUtils().dateToDb( strExpireDate ) < new SCUtils().dateToDb( strStartDate ) ){
    showMsg( 0 , 0 , lc_expire_day_more_create_day );

    div_info.style.display = "inline";
    document.getElementById('tab_img_data').src = "images/tab_img_data_down.gif";
    form1.txtExpireDate.focus();
    return false;
    }
    form1.EXPIRE_DATE.value = new SCUtils().dateToDb( strExpireDate );
    return true;
}

function validate_NotNull_field(){
    var arrField = form1.CONCAT_FIELD_NAME.value.split( "," );
    var objField;
    for( var intCount = 0 ; intCount < arrField.length ; intCount++ ){
        if(arrField[ intCount ] != ""){
            objField = eval( "form1." + arrField[ intCount ] );
            if( objField != null && objField.getAttribute("is_NotNull") == "Y" && objField.value.length == 0 ){
                showMsg( 0 , 0 , lc_check_key + eval( arrField[ intCount ] + "_span.innerText" ) );
                if(objField.getAttribute("value_type") != "zoom"){
                    objField.focus();
                }			
                return false;
            }
            if( objField != null && (objField.getAttribute("value_type") == "date" || objField.getAttribute("value_type") == "date_eng") && objField.value.length > 0 ){
                if( objField.value.length < 8 ){
                    showMsg( 0 , 0 , lc_check_key + eval( arrField[ intCount ] + "_span.innerText" ) );
                    return false;
                }
                if( new SCUtils().isDateValid( objField.value )  != "VALID_DATE" ){
                    showMsg( 0 , 0 , lc_check_key + eval( arrField[ intCount ] + "_span.innerText" ) + lc_check_correct );
                    return false;
                }
            }
        }
    }
    return true;
}

function validate_tin_pin_field(){

    var arrField = form1.CONCAT_FIELD_NAME.value.split( "," );
    var objField;
    for( var intCount = 0 ; intCount < arrField.length ; intCount++ ){
        if(arrField[ intCount ] != ""){
            objField = eval( "form1." + arrField[ intCount ] );

            if( objField != null && objField.getAttribute("value_type") == "tin" && objField.value.length != 0 ){
                if( !new SCUtils().isTIN( new SCUtils().unMask( objField.value ) ) ){
                        objField.focus();
                        return false;
                }
            }
            if( objField != null && objField.getAttribute("value_type") == "pin" && objField.value.length != 0 ){
                if( !new SCUtils().isPIN( new SCUtils().unMask( objField.value ) ) ){
                        objField.focus();
                        return false;
                }
            }
        }
    }
    return true;
}

function validate_gen_field(){

    var arrField = form1.CONCAT_FIELD_NAME.value.split( "," );
    var objField;
    for( var intCount = 0 ; intCount < arrField.length ; intCount++ ){
        if(arrField[ intCount ] != ""){
            objField = eval( "form1." + arrField[ intCount ] );
            if( objField != null && (objField.getAttribute("value_type") == "date" || objField.getAttribute("value_type") == "date_eng") && objField.value.length > 0 ){
                if( objField.value.length < 8 ){
                        showMsg( 0 , 0 , lc_check_key + eval( arrField[ intCount ] + "_span.innerText" ) );
                        return false;
                }
                if( new SCUtils().isDateValid( objField.value )  != "VALID_DATE" ){
                        showMsg( 0 , 0 , lc_check_key + eval( arrField[ intCount ] + "_span.innerText" ) + lc_check_correct );
                        return false;
                }
            }
        }
    }
    return true;
}

function div_click(div_tab,img_tab,idx){

    var div_obj = document.getElementById(div_tab);
    var img_obj,header_obj;

    if(idx == 0){
        img_obj = document.getElementById(img_tab);
    }else {
        img_obj = document.getElementById(img_tab + idx);
        header_obj = document.getElementById("div_header" + idx);
    }

    if(header_obj != null && header_obj != ""){
        if(div_obj.style.display == "none"){
                header_obj.className = "label_bold3";			
        }else{
                header_obj.className = "label_bold2";
        }	
    }

    if(div_obj.style.display == "none"){
        div_obj.style.display = "inline";
        img_obj.src = "images/" + img_tab + "_down.gif";

    }else{
        div_obj.style.display = "none";
        img_obj.src = "images/" + img_tab + ".gif";

    }
}

function field_press( objField ){
    
    var obj_name = objField.name;
    
    $("#" + obj_name ).keyup(function(e){
        if(e.keyCode==13){
        
//	if( new SCUtils().isEnter() ){
//		window.event.keyCode = 0;
            switch( obj_name ){
                case "txtExpireDate" : 
                var arrField = form1.CONCAT_FIELD_NAME.value.split( "," );
                var objNextField;
                for( var intCount = 0 ; intCount < arrField.length ; intCount++ ){
                    if(arrField[ intCount ] != ""){
                        objNextField = eval( "form1." + arrField[ intCount ] );
                        if( objNextField != null && !objNextField.readOnly && objNextField.type != "hidden" ){
                                objNextField.focus();
                                return;
                        }
                    }
                }
                break;
            default : 
                set_mask(objField,objField.getAttribute("value_type"));

                var arrField = form1.CONCAT_FIELD_NAME.value.split( "," );
                var objNextField;
                for( var intCount = 0 ; arrField[ intCount ] != objField.name ; intCount++ ){}
                intCount++;
                while( intCount < arrField.length ){
                    if(arrField[ intCount ] != ""){
                        objNextField = eval( "form1." + arrField[ intCount ] );
                        if( objNextField != null && !objNextField.readOnly && objNextField.type != "hidden" ){
                            objNextField.focus();
                            return;
                        }
                    }

                    intCount++
                }
                break;
            }
	}
    });
        
}

function set_unmask(objField){ 
    objField.value = new SCUtils().unMask( objField.value );
}

function set_mask(objField,objType){ 

    objField.value = new SCUtils().unMask( objField.value );
    if( objType == "tin" && objField.value.length == 10 ){
        objField.value = new SCUtils().maskTIN( objField.value );
    }

    if( objType == "pin" && objField.value.length == 13 ){		
        objField.value = new SCUtils().maskPIN( objField.value );
    }
}

function init_form(){
    set_JSP_value();	
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

function set_JSP_value(){

    form1.txtDocNum.value     = "<%=strBatchNo%>";
    form1.txtExpireDate.value = "<%=strDspExpireDate%>";
    form1.EXPIRE_DATE.value   = "<%=strExpireDate%>";
    form1.txtStoreHouse.value = "<%=strStorehouseName%>";
    form1.STORE_HOUSE.value   = "<%=strStorehouse%>";

<%
    for( int intField = 0 ; intField < strDataName.length ; intField++ ){

        if( strDataValue[ intField ].indexOf( "\n" ) != -1 ){
                strDataValue[ intField ] = strDataValue[ intField ].replaceAll( "\r\n" , "\\\\n" );
        }
        if( strDataValue[ intField ].indexOf( "\"" ) != -1 ){
                strDataValue[ intField ] = strDataValue[ intField ].replaceAll( "\"" , "\\\\\"" );
        }
        if( strDataValue[ intField ].indexOf( "<n>" ) != -1 ){
                strDataValue[ intField ] = strDataValue[ intField ].replaceAll( "<n>" , "\\\\n\\\\r" );
        }
        if( strDataValue[ intField ].indexOf( "<t>" ) != -1 ){
                strDataValue[ intField ] = strDataValue[ intField ].replaceAll( "<t>" , " " );
        }

        if(strDataType[ intField ].equals("CURRENCY") && strDataValue[ intField ].length() > 0){
                strDataValue[ intField ] = setComma(strDataValue[ intField ]);
        }

        if((strDataType[ intField ].equals("DATE")||strDataType[ intField ].equals("DATE_ENG")) && strDataValue[ intField ].length() > 0){
            if(strDataValue[ intField ].indexOf("/") == -1){
                out.print("form1." + strDataName[ intField ] + ".value = new SCUtils().dateToDisplay(\"" + strDataValue[ intField ] + "\");\n");
            }else{
                out.print("form1." + strDataName[ intField ] + ".value = \"" + strDataValue[ intField ] + "\";\n");
            }
        }else if(strDataType[ intField ].equals("ZOOM") && strDataValue[ intField ].length() > 0){
            out.print("form1." + strDataName[ intField ] + ".value = \"" + strDataValue[ intField ] + "\";\n");

            if(!strDataValue[ intField ].equals("")&&strDataType[ intField ].equals("ZOOM")){
                conCode.addData("FIELD_CODE", "String", strDataValue[ intField ]);
                conCode.addData("TABLE_NAME", "String", strDataTableZoom[ intField ]);
                boolean bolSuccessCode = conCode.executeService(strContainerName, strClassName, "findFieldCode");
                if(bolSuccessCode){
                    strDataValue[ intField ] = conCode.getHeader(strDataTableZoom[ intField ] + "_NAME");
                }
                out.print("form1.DSP_" + strDataName[ intField ] + ".value = \"" + strDataValue[ intField ] + "\";\n");
            }   
        }else if(strDataType[ intField ].equals("TIN") && strDataValue[ intField ].length() > 0){
            out.print("form1." + strDataName[ intField ] + ".value = new SCUtils().maskTIN(\"" + strDataValue[ intField ] + "\");\n");
        }else if(strDataType[ intField ].equals("PIN") && strDataValue[ intField ].length() > 0){
            out.print("form1." + strDataName[ intField ] + ".value = new SCUtils().maskPIN(\"" + strDataValue[ intField ] + "\");\n");        
        }else if(strDataType[ intField ].equals("LIST")){
            out.println("//" + strDataTableLevel[ intField ]);
            out.print("form1." + strDataName[ intField ] + ".value = \"" + strDataValue[ intField ] + "\";\n");
           // if(strDataTableLevel[ intField ].equals("1") ){
           //     out.print("get_table_level2('" + strDataName[ intField ] + "' , '" + strDataTableZoom[ intField ] + "');\n");
           // }else{
           //     out.print("form1." + strDataName[ intField ] + "_DATA.value = \"" + strDataValue[ intField ] + "\";\n");
           // }
            
        }else{
            out.print("form1." + strDataName[ intField ] + ".value = \"" + strDataValue[ intField ] + "\";\n");
        }
    }
%>
}


function set_format_date( obj_field ){
    if( obj_field.value.length == 8 && new SCUtils().isDateValid( obj_field.value ) == "VALID_DATE" ){
            obj_field.value = new SCUtils().formatDate( obj_field.value );
    }
}

function set_format_date_eng( obj_field ){
    if( obj_field.value.length == 8 && new SCUtils().isDateValid( obj_field.value ) == "VALID_DATE" ){
            obj_field.value = new SCUtils().formatDateEng( obj_field.value );
    }
}

function set_unformat_date(obj_field){
    obj_field.value = new SCUtils().unFormatDate( obj_field.value );
}

function window_onload() {
    var batch_no 		 = "<%=strBatchNo %>";
    var document_running = <%=strDocumentRunning%>;
    var action_move      = "<%=strActionMove %>";
    
    document_name.innerHTML  =  lbl_document_name;
    document_user.innerHTML  =  lbl_document_user;
    document_level.innerHTML =  lbl_document_level;
    add_user.innerHTML 		 =	lbl_add_user;
    add_date.innerHTML		 = 	lbl_add_date;
    upd_user.innerHTML		 = 	lbl_upd_user;
    upd_date.innerHTML		 =	lbl_upd_date;
    expire_date.innerHTML	 =	lbl_expire_date;
    doc_status.innerHTML	 =	lbl_status;
    carbinet_no.innerHTML	 =  lbl_carbinet_no;
    storehouse.innerHTML   	 =	lbl_doc_location;

    init_form();
//    check_inet_version();
	
<%
    if( !strErrorMessage.equals( "" ) ){
%>
	showMsg( 0 , 0 , "<%=strErrorMessage.replaceAll( "\"" , "'" ).replaceAll( "\r" , "" ).replaceAll( "\n" , "<br>" )%>" );

        /*  Eas Error Message Section
        <%=strErrorMessage%>
        */
<%
    }else if( bolnUpdateSuccess ){
%>
        $('#load_screen_div').css({ 'opacity' : 0.7 });
        $('#load_screen_div').show();
        $('#load_screen_div').css("height",$(document).height());
        $('#progess_div').show();
        
        showMsg( 0 , 0 , lc_process_complete );
    
        if(batch_no != ""){
            get_log(batch_no,document_running,"U");
        }
    
        return_page();
    
<%
    }else if( bolDelSuccess ){
%>
	if( action_move == "MOVE" ) {
            showMsg( 0 , 0 , lc_move_document_success );
	}else {
            showMsg( 0 , 0 , lc_delete_document_success );
	}
	
	if(batch_no != ""){
            get_log(batch_no,document_running,"U");
        }
<%
    }else if( bolnCheckSuccess ){
        if(strCheckStatus.equals("CHECKIN")){
%>
            if(batch_no != ""){
                get_log(batch_no,document_running,"I");
            }
            click_back();
<%
        }else{
%>
            if(batch_no != ""){
                get_log(batch_no,document_running,"O");
            }		   
<%			
        }
    }	
%>	
}

function clear_screen(){
    $('#load_screen_div').hide();
    $('#progess_div').hide();
}

function return_page(){
    click_cancel();
}

function window_onunload(){
    if( objZoomWindow != null && !objZoomWindow.closed ){
        objZoomWindow.close();
    }

    if( objDocMoveWindow != null && !objDocMoveWindow.closed ){
        objDocMoveWindow.close();
    }

    if( objVersionWindow != null && !objVersionWindow.closed ){
        objVersionWindow.close();
    }

    try{
        inetdocview.Close();
    }catch( e ){
    }
}

function openVersion( document_type, scan_no, document_level ){
        var strPopArgument = "scrollbars=yes,status=no";
        var strWidth       = ",width=370px";
        var strHeight      = ",height=400px";
	var strUrl         = "inc/show_version.jsp";
	var strConcatField  = "BATCH_NO=<%=strBatchNo%>" 
                            + "&DOCUMENT_RUNNING=<%=strDocumentRunning%>"
                            + "&PROJECT_CODE=<%=strProjectCode%>"
                            + "&DOCUMENT_TYPE=" + document_type
                            + "&DOCUMENT_LEVEL=" + document_level
                            + "&SCAN_NO=" + scan_no;
							
	strPopArgument += strWidth + strHeight;						
	
	objVersionWindow = window.open( strUrl + "?" + strConcatField , "version" + document_type , strPopArgument );
	objVersionWindow.focus();
}

function openZoom( strZoomType , strZoomLabel , objDisplayText , objDisplayValue, strTableLevel ){
    var strPopArgument = "scrollbars=yes,status=no";
    var strWidth       = ",width=370px";
    var strHeight      = ",height=420px";
    var strUrl         = "";
    var strConcatField = "";

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

function openDocUserZoom( strZoomType , strZoomLabel ){
    var strPopArgument 	= "scrollbars=yes,status=no";
    var strWidth 		= ",width=470px";
    var strHeight 		= ",height=490px";
    var strUrl 			= "";
    var strConcatField 	= "";
    var strProjectCode  = "<%=strProjectCode %>";

    strPopArgument += strWidth + strHeight;
    strUrl         = "inc/zoom_document_user.jsp";
    strConcatField = "TABLE=" + strZoomType;
    strConcatField += "&TABLE_LABEL=" + strZoomLabel;
    strConcatField += "&RESULT_FIELD=txtDocUser,txtDocUserName,txtDocOrg";

    objZoomWindow = window.open( strUrl + "?" + strConcatField , "zm" + strZoomType , strPopArgument );
    objZoomWindow.focus();
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

function get_table_level2(field_id , table_level1){
    $.post( 
        "listlevelservlet" , 
        { 
            "CONTAINER_NAME" : "<%=strContainerName%>",
            "PROJECT_CODE" : "<%=strProjectCode%>",
            "TABLE" : table_level1,
            "METHOD" : "findTableLevel2"  
        },			 
        function( data ){            
            if(data != ""){                
                var lv_field = data.split(",");                
                for(var idx=0; idx<lv_field.length; idx++){
                    list_change_lv2(lv_field[idx] , table_level1 , field_id);            
                    $("#" + lv_field[idx] + "_TABLE_LEVEL1").val(field_id);
                }
            }
            
//            list_change_lv2(data , table_level1 , field_id);            
//            $("#" + data + "_TABLE_LEVEL1").val(field_id);           
        }
    );
}

function get_table_level3(field_id , table_level2){

    var field_lv1 =  $("#" + field_id + "_TABLE_LEVEL1").val();
    var table_level1 = $("#" + field_lv1 + "_TABLEZOOM").val();
    if(!table_level1){
        return;
    }

    $.post( 
        "listlevelservlet" , 
        { 
            "CONTAINER_NAME" : "<%=strContainerName%>",
            "PROJECT_CODE" : "<%=strProjectCode%>",
            "TABLE" : table_level1,
            "TABLE2" : table_level2,
            "METHOD" : "findTableLevel3"  
        },			 
        function( data ){
            if(data != ""){                
                var lv_field = data.split(",");                
                for(var idx=0; idx<lv_field.length; idx++){
                    list_change_lv3( field_lv1, field_id,  lv_field[idx] , table_level1 , table_level2 );
                }
            }
//                    list_change_lv3( field_lv1, field_id,  data , table_level1 , table_level2 );
        }
    );
}

function list_change_lv2( field_lv2 , table_lv1 , field_lv1){
    var table_lv2 = $("#" + field_lv2 + "_TABLEZOOM").val();
    var lv1_value = $("#" + field_lv1).val();
    
    if(lv1_value == ""){
        $( "#" + field_lv2 ).html( "<option value=\"\"></option>" );
        return;
    }
    
    $.post( 
        "listlevelservlet" , 
        { 
            "CONTAINER_NAME" : "<%=strContainerName%>",
            "TABLE" : table_lv2,
            "TABLE_LV1_CODE" : lv1_value,
            "TABLE_LV1" : table_lv1,
            "METHOD" : "getTableLevel2List"  
        },			 
        function( data ){
            $( "#" + field_lv2 ).html( data );
        }
    );
}

function list_change_lv3( field_lv1, field_lv2,  field_lv3, table_lv1, table_lv2){
    var table_lv3 = $("#" + field_lv3 + "_TABLEZOOM").val();
    var lv1_value = $("#" + field_lv1).val();
    var lv2_value = $("#" + field_lv2).val();
    
    if(lv1_value == "" || lv2_value == ""){
        $( "#" + field_lv3 ).html( "<option value=\"\"></option>" );
        return;
    }
   
    $.post( 
        "listlevelservlet" , 
        { 
            "CONTAINER_NAME" : "<%=strContainerName%>",
            "TABLE" : table_lv3, //TEST3
            "TABLE_LV1_CODE" : lv1_value, // 10
            "TABLE_LV1" : table_lv1, //TEST1
            "TABLE_LV2_CODE" : lv2_value, // 10001
            "TABLE_LV2" : table_lv2, // TEST2
            "METHOD" : "getTableLevel3List"  
        },			 
        function( data ){
            $( "#" + field_lv3 ).html( data );
        }
    );
}

function set_currency_format(input_obj){
    var strValue 	= input_obj.value;
    var delimiter 	= ",";
    var iInteger, iDecimal;
    var minus 		= '';


    var arrCurrency = strValue.split('.');

    iInteger = parseInt(arrCurrency[0]);
    if(arrCurrency[1]){
        iDecimal = arrCurrency[1];
    }else{
        iDecimal = '00';
    }

    if(isNaN(iInteger)) { 
        return ''; 
    }

    if(iInteger < 0) { 
        minus = '-'; 
    }

    iInteger = Math.abs(iInteger);
    var strNum = new String(iInteger);
    var arrNum = [];
    while(strNum.length > 3){
        var nTriNum = strNum.substr(strNum.length-3);
        arrNum.unshift(nTriNum);
        strNum = strNum.substr(0,strNum.length-3);
    }

    if(strNum.length > 0) { 
        arrNum.unshift(strNum); 
    }

    strNum = arrNum.join(delimiter);
    if(iDecimal.length < 1) {
        strValue = strNum; 
    }else { 
        strValue = strNum + '.' + iDecimal; 
    }

    strValue = minus + strValue;
    input_obj.value = strValue;
}

function change_format_currency(input_obj){
    var iValue = input_obj.value;

    if(iValue.indexOf(',') != -1){
        iValue = new SCUtils().replaceString(iValue,',','');
    }

    input_obj.value = iValue;
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

function get_last_blob_ID(){
	if( form1.CURRENT_DOC.value != "" && inetdocview.BlobId() != "" ){
		var strBlobId 	   = inetdocview.BlobId();
		var strBlobPart	   = inetdocview.Part();
		var strUsedSizeArg = inetdocview.BlobSize();

		if( strUsedSizeArg == null || strUsedSizeArg.length == 0 || isNaN( strUsedSizeArg ) ){
			strUsedSizeArg = "100000";
		}

		eval( "form1.BLOB_ID" 		+ form1.CURRENT_DOC.value + ".value = strBlobId;" );
		eval( "form1.BLOB_PART" 	+ form1.CURRENT_DOC.value + ".value = strBlobPart;" );
		eval( "form1.USED_SIZE_ARG" + form1.CURRENT_DOC.value + ".value = strUsedSizeArg;" );
	}
}

function get_concat_blob_ID(){

	form1.CONCAT_DOCUMENT_TYPE.value  = "";
	form1.CONCAT_DOCUMENT_LEVEL.value = "";
	form1.CONCAT_VERSION_LIMIT.value  = "";
	form1.CONCAT_NEW_VERSION.value    = "";
	form1.CONCAT_BLOBID.value 		  = "";
	form1.CONCAT_BLOBPART.value		  = "";
	form1.CONCAT_USED_SIZE_ARG.value  = "";
	form1.CONCAT_SCAN_NO.value  	  = "";
	form1.CONCAT_XML_TAG.value  	  = "";
	form1.CONCAT_BLOB_FLAG.value  	  = "";
	form1.CONCAT_FILE_TYPE.value  	  = "";
	form1.CONCAT_FILE_NAME.value  	  = "";
	form1.CONCAT_CONTENT.value  	  = "";
	
	if( form1.TOTAL_DOCUMENT != null ){
		var intTotalDoc = parseInt( form1.TOTAL_DOCUMENT.value );
		var strBlob , strPart , strUsedSizeArg , strDocumentType , strImageProp, strDocumentLevel;
		var strNewVersion , strVersionLimit, strScanNo;
		var strXmlTag , strBlobFlag;
		var strFileType, strFileName;
		var strContent;
		var cnt_temp;

		for( var countDoc = 0 ; countDoc < intTotalDoc ; countDoc++ ){
	//		cnt_temp = "000" + (countDoc + 1);
	//		cnt_temp = cnt_temp.substring(cnt_temp.length-3,cnt_temp.length);
			cnt_temp = eval(  "form1.DOCTYPE_CODE" 	+ (countDoc + 1) ).value;
			
			if(eval( "form1.DOCUMENT_TYPE" + cnt_temp )){
				eval(  "strDocumentType  = form1.DOCUMENT_TYPE" 	+ cnt_temp + ".value;" );
				eval(  "strDocumentLevel = form1.DOCUMENT_LEVEL" 	+ cnt_temp + ".value;" );
				eval(  "strVersionLimit  = form1.VERSION_LIMIT" 	+ cnt_temp + ".value;" );
				eval(  "strNewVersion	 = form1.NEW_VERSION" 		+ cnt_temp + ".value;" );
				eval(  "strBlob 	 = form1.BLOB_ID"               + cnt_temp + ".value;" );
				eval(  "strPart 	 = form1.BLOB_PART" 		+ cnt_temp + ".value;" );
				eval(  "strUsedSizeArg 	 = form1.USED_SIZE_ARG" 	+ cnt_temp + ".value;" );
				eval(  "strScanNo 	 = form1.SCAN_NO" 		+ cnt_temp + ".value;" );
				eval(  "strXmlTag 	 = form1.XML_TAG" 		+ cnt_temp + ".value;" );
				eval(  "strBlobFlag 	 = form1.BLOB_FLAG" 		+ cnt_temp + ".value;" );
				eval(  "strFileType 	 = form1.FILE_TYPE" 		+ cnt_temp + ".value;" );
				eval(  "strFileName 	 = form1.FILE_NAME" 		+ cnt_temp + ".value;" );
				eval(  "strContent 	 = form1.CONTENT" 		+ cnt_temp + ".value;" );
				
				if(strXmlTag == ""){strXmlTag = "NOT"};
	           
				if( strBlob.length > 0 ){
					form1.CONCAT_DOCUMENT_TYPE.value  += strDocumentType + ",";
					form1.CONCAT_DOCUMENT_LEVEL.value += strDocumentLevel + ",";
					form1.CONCAT_NEW_VERSION.value 	  += strNewVersion + ",";
					if(strNewVersion == 'Y'){
						if(strVersionLimit == ""){
							strVersionLimit = "0";
						}
					}else {
						strVersionLimit = "null";
					}
					
					if(strFileType == ""){
						strFileType = "NONE";
					}
					if(strContent == ""){
						strContent = "-";
					}
                                                                                
                                        strFileType = strFileType.replace(/,/g,";");
                                        
                                        if(strFileName == ""){
                                            if(strFileType == "NONE"){
						strFileName = "NONE";
                                            }else{
                                                strFileName = "N/A";
                                            }
					}
					form1.CONCAT_VERSION_LIMIT.value  += strVersionLimit + ",";
					form1.CONCAT_BLOBID.value 	  += strBlob + ",";
					form1.CONCAT_BLOBPART.value	  += strPart + ",";
					form1.CONCAT_USED_SIZE_ARG.value  += strUsedSizeArg + ",";
					form1.CONCAT_SCAN_NO.value  	  += strScanNo + ",";  
					form1.CONCAT_XML_TAG.value  	  += strXmlTag + ",";
					form1.CONCAT_BLOB_FLAG.value  	  += strBlobFlag + ",";
					form1.CONCAT_FILE_TYPE.value  	  += strFileType + ",";
					form1.CONCAT_FILE_NAME.value  	  += strFileName + ",";
					form1.CONCAT_CONTENT.value  	  += strContent + ",";
				}
			}
		}
	}

	var strConcatDocumentType  = form1.CONCAT_DOCUMENT_TYPE.value;
	var strConcatDocumentLevel = form1.CONCAT_DOCUMENT_LEVEL.value;
	var strConcatVersionLimit  = form1.CONCAT_VERSION_LIMIT.value; 
	var strConcatNewVersion    = form1.CONCAT_NEW_VERSION.value;
	var strConcatBlobID 	   = form1.CONCAT_BLOBID.value;
	var strConcatBlobPart	   = form1.CONCAT_BLOBPART.value;
	var strConcatUsedSizeArg   = form1.CONCAT_USED_SIZE_ARG.value;
	var strConcatScanNo   	   = form1.CONCAT_SCAN_NO.value;
	var strConcatXmlTag   	   = form1.CONCAT_XML_TAG.value;
	var strConcatBlobFlag      = form1.CONCAT_BLOB_FLAG.value;
	var strConcatFileType      = form1.CONCAT_FILE_TYPE.value;
	var strConcatFileName      = form1.CONCAT_FILE_NAME.value;
	var strConcatContent       = form1.CONCAT_CONTENT.value;
    
	if( strConcatDocumentType.length > 0 ){
		form1.CONCAT_DOCUMENT_TYPE.value = strConcatDocumentType.substring( 0 , strConcatDocumentType.length - 1 );
	}
	if( strConcatDocumentLevel.length > 0 ){
		form1.CONCAT_DOCUMENT_LEVEL.value = strConcatDocumentLevel.substring( 0 , strConcatDocumentLevel.length - 1 );
	}
	if( strConcatVersionLimit.length > 0 ){
		form1.CONCAT_VERSION_LIMIT.value = strConcatVersionLimit.substring( 0 , strConcatVersionLimit.length - 1 );
	}
	if( strConcatNewVersion.length > 0 ){
		form1.CONCAT_NEW_VERSION.value = strConcatNewVersion.substring( 0 , strConcatNewVersion.length - 1 );
	}
	if( strConcatBlobID.length > 0 ){
		form1.CONCAT_BLOBID.value = strConcatBlobID.substring( 0 , strConcatBlobID.length - 1 );
	}
	if( strConcatBlobPart.length > 0 ){
		form1.CONCAT_BLOBPART.value = strConcatBlobPart.substring( 0 , strConcatBlobPart.length - 1 );
	}
	if( strConcatUsedSizeArg.length > 0 ){
		form1.CONCAT_USED_SIZE_ARG.value = strConcatUsedSizeArg.substring( 0 , strConcatUsedSizeArg.length - 1 );
	}
	
	if( strConcatScanNo.length > 0 ){
		form1.CONCAT_SCAN_NO.value = strConcatScanNo.substring( 0 , strConcatScanNo.length - 1 );
	}
	if( strConcatXmlTag.length > 0 ){
		form1.CONCAT_XML_TAG.value = strConcatXmlTag.substring( 0 , strConcatXmlTag.length - 1 );
	}
	
	if( strConcatBlobFlag.length > 0 ){
		form1.CONCAT_BLOB_FLAG.value = strConcatBlobFlag.substring( 0 , strConcatBlobFlag.length - 1 );
	}
	
	if( strConcatFileType.length > 0 ){
		form1.CONCAT_FILE_TYPE.value = strConcatFileType.substring( 0 , strConcatFileType.length - 1 );
	}
	
	if( strConcatFileName.length > 0 ){
		form1.CONCAT_FILE_NAME.value = strConcatFileName.substring( 0 , strConcatFileName.length - 1 );
	}
        
	if( strConcatContent.length > 0 ){
		form1.CONCAT_CONTENT.value = strConcatContent.substring( 0 , strConcatContent.length - 1 );
	}
}

function set_concat_document_field(){

    var arrField = form1.CONCAT_FIELD_NAME.value.split( "," );
    var strFieldValue  	  = "";
    var strConcatSetField = "";
    var strConcatField 	  = "";
    var strConcatValue    = "";
    var strConcatDup   	  = "";
    var strTextIndex   	  = "";

    var objDocumentField;
    var objDspDocumentField;

	for( var intCount = 0 ; intCount < arrField.length ; intCount++ ){
	
            if(arrField[ intCount ] != ""){
                objDocumentField = eval( "form1." + arrField[ intCount ] );

                if( objDocumentField != null && objDocumentField.name.indexOf( "DSP_" ) == -1 ){
                    switch( objDocumentField.getAttribute("value_type") ){
                        case "number" :
                            strFieldValue = new SCUtils().replaceString(objDocumentField.value,',','');
                            objDocumentField.value = strFieldValue;

                            if(strFieldValue.length == 0){
                                    strFieldValue = "NULL";
                            }
                            break;
                        case "date" :
                        case "date_eng" :
                            if(new SCUtils().dateToDb( objDocumentField.value ).length != 8){
                                    temp_check_date = "N";
                            }
                            if(objDocumentField.value.length == 0){
                                    temp_check_date = "Y";
                            }
                            strFieldValue = "'" + new SCUtils().dateToDb( objDocumentField.value ) + "'";

                            break;
                        case "zoom" :
                            objDspDocumentField = eval( "form1." + objDocumentField.name );
                            strFieldValue = "'" + objDspDocumentField.value + "'";
                            break;
                        case "memo" :
                            strFieldValue = objDocumentField.value.replace(/'/g,"''");
                            strFieldValue = new SCUtils().replaceString(strFieldValue,"\n","<n>");
//						strFieldValue = new SCUtils().replaceString(strFieldValue,"\t","<t>");
//						strFieldValue = new SCUtils().replaceString(strFieldValue," ","<t>");

                            if(strFieldValue.length > 4000){
                                    strFieldValue = strFieldValue.substr( 0 , 3997 ) + "...";
                            }
                            strFieldValue = "'" + strFieldValue + "'";						
                            break;	
                        case "tin" :
                        case "pin" :
                            strFieldValue = "'" + new SCUtils().unMask( objDocumentField.value ) + "'";
                            break;
                        case "currency" :	
                            if(strFieldValue.length == 0){
                                    strFieldValue = "NULL";
                            }
                        default :
                            strFieldValue = "'" + objDocumentField.value.replace(/'/g,"''") + "'";
                            break;
                    }
                    if( objDocumentField.getAttribute("is_PK") == "Y" ){
                        strConcatDup += objDocumentField.name + "=" + strFieldValue + " AND ";
                    }

                    strConcatField 	  += objDocumentField.name + ",";
                    strConcatValue 	  += strFieldValue + ",";
                    strTextIndex   	  += strFieldValue + " ";
                    strConcatSetField += objDocumentField.name +  " = " + strFieldValue + ","; 
                }
            }
	}
	
    if( strConcatField.length > 0 ){
        strConcatField = strConcatField.substr( 0 , strConcatField.length - 1 );
    }
    if( strConcatValue.length > 0 ){
        strConcatValue = strConcatValue.substr( 0 , strConcatValue.length - 1 );
    }
    if (strConcatDup.length > 0) {
        strConcatDup = strConcatDup.substr(0, strConcatDup.lastIndexOf("AND"));
    }
    if (strTextIndex.length > 0) {
        strTextIndex = strTextIndex.substr(0, strTextIndex.lastIndexOf(" "));
    }
	
    form1.DOCUMENT_FIELD_INSERT.value = strConcatField;
    form1.DOCUMENT_VALUE_INSERT.value = strConcatValue;
    form1.DOCUMENT_VALUE_DUPLICATE.value = strConcatDup;
    form1.TEXT_INDEX.value 		   = strTextIndex;
    form1.DOCUMENT_SET_FIELD.value = strConcatSetField;
}

function openAddEditView( strDocumentType , strFileSizeFlag ,  strFileSize , strFileTypeFlag , strFileType ){
    
    form1.CURRENT_DOC.value = strDocumentType;
    
    initAndShow( strFileSizeFlag ,  strFileSize , strFileTypeFlag , strFileType );
    retrieveImage( strDocumentType );
}

function initAndShow(strFileSizeFlag ,  strFileSize , strFileTypeFlag , strFileType){
    var x,y,w,h, sessionId;
    var permit = set_inet_permission("<%=strPermission%>");
    
    x = screen.width /2;
    y = 0;
    w = screen.width;
    h = screen.height;
    inetdocview.Close();
    sessionId = inetdocview.Open();
    inetdocview.Resize(x, y, w, (h-30));
    inetdocview.ContainerType("<%=strConTainerType%>");
    inetdocview.SetProperty("RemoveToolBar",permit);
    inetdocview.SetProperty("UnRemoveToolBar","Menu.View.Facing");
    inetdocview.SetProperty("CloseWhenSave", "true");
    
    set_file_property(strFileSizeFlag, strFileSize, strFileTypeFlag, strFileType);
    set_store_pdf();
}

function set_store_pdf(){
    var pdf_flag = <%=strStoreInPDF%>;
    if(pdf_flag){
        inetdocview.SetProperty( "STOREINPDF", "true");
    }
}

function retrieveImage( strDocumentType ){
    
    form1.CURRENT_DOC.value = strDocumentType;
    
    var blobid,parts;
    
    eval( "blobid = form1.BLOB_ID"   + form1.CURRENT_DOC.value + ".value;" );
    eval( "parts  = form1.BLOB_PART" + form1.CURRENT_DOC.value + ".value;" );
    
    if ((blobid != "") && (parts != "")){
        inetdocview.Retrieve(blobid, parts);
    }
}

function set_file_property(size_flag, sizes, type_flag, types){
	var arrType;
	var file_size = "";
	if(size_flag == 'Y'){
		file_size = "," + sizes;
	}
	
	inetdocview.SetProperty("ADDTYPESIZE","Null");
	inetdocview.SetProperty("ADDTYPESIZE","chkedoc");
        
	if(type_flag == 'Y'){
		arrType = types.split(",");
		for(var idx=0; idx<arrType.length; idx++){
			if(size_flag == 'Y'){
				inetdocview.SetProperty("ADDTYPESIZE",arrType[idx] + file_size + "M");
			}else{
				inetdocview.SetProperty("ADDTYPESIZE",arrType[idx]);
			}
		}
	}else{
		if(size_flag == 'Y'){
			inetdocview.SetProperty("ADDTYPESIZE","all" + file_size + "M");
		}
		
		inetdocview.SetProperty("FORCE_SAVE","true");
	}
}

function afterCheck(msg){
	var message_check;
	
	if(msg.indexOf("not allow") != -1){
		message_check = lc_check_file_type;
		alert(message_check);
	}else if(msg.indexOf("more than") != -1){
		message_check = lc_check_file_size;
		alert(message_check);
	}
}

function onHasLimitInfo(limitInfo){
	//alert(limitInfo);
}

function afterSaveFinish(strBlobId, strBlobPart)  {
   	eval( "form1.BLOB_ID" 		+ form1.CURRENT_DOC.value).value = strBlobId;
 	eval( "form1.BLOB_PART" 	+ form1.CURRENT_DOC.value).value = strBlobPart;
	eval( "form1.XML_TAG" 		+ form1.CURRENT_DOC.value).value = "0"; 
	eval( "form1.BLOB_FLAG" 	+ form1.CURRENT_DOC.value).value = 'Y';
	eval( "PICT_CNT" + form1.CURRENT_DOC.value).innerHTML = "(" + strBlobPart + ")";
	eval( "clear_" + form1.CURRENT_DOC.value).style.display = "inline";
	eval( "copy_" + form1.CURRENT_DOC.value).style.display  = "inline";
	eval( "paste_" + form1.CURRENT_DOC.value).style.display = "none";
	
        inetdocview.GetPropertyValue("BlobSize","");
        inetdocview.GetPropertyValue("AllType","");
//        inetdocview.GetPropertyValue("DocProperties","");        
}

function successNotify(cmd, res1, res2){
     
    if(cmd === inetdocview.InetMessages.GetProperty){
        var file_type = "";
        
        if(res1 == "BlobSize"){
            eval( "form1.USED_SIZE_ARG" + form1.CURRENT_DOC.value).value = res2; 
        }
        
        if(res1 == "AllType"){
            file_type = res2;
            
            if(file_type.length > 0 && file_type.lastIndexOf(",") != -1){
                    file_type = file_type.substring(0,file_type.length-1);
            }
            file_type = file_type.toUpperCase();

            eval( "form1.FILE_TYPE" + form1.CURRENT_DOC.value).value = file_type;
        }
//        
//        if(res1 == "DocProperties"){
//            var data_xml = res2;            
//            var filename = "";
//            var xmlDocument = null;
//            
//            eval( "form1.CONTENT" + form1.CURRENT_DOC.value).value = data_xml;
//            
//            
//            xmlDocument = new ActiveXObject("MSXML2.DOMDocument");
//            xmlDocument.loadXML(data_xml);
//
////		alert(xmlDocument.xml);
//		nodeList = xmlDocument.selectNodes("//Part");
//		filename = nodeList.item(0).getAttribute("name");
//			
//		eval( "form1.FILE_NAME" + form1.CURRENT_DOC.value).value = filename;    
//        }
    }
}

function delete_doctype(doctype_label,lv_docType) {
    
    var concat_del_doctype = form1.CONCAT_DOCTYPE_DELETE.value;
    
    if(!showMsg( 0 , 1 , lc_confirm_delete + doctype_label + lc_all_in_document )){
        return;
    }

    var pict_init = eval("form1.PICT_INIT" + lv_docType).value;

    if (pict_init == "") {
        eval("form1.BLOB_FLAG" + lv_docType).value = "N";
    } else {
        eval("form1.BLOB_FLAG" + lv_docType).value = "D";

        if (concat_del_doctype != "") {
            if (concat_del_doctype.indexOf(lv_docType) == -1) {
                form1.CONCAT_DOCTYPE_DELETE.value += "," + lv_docType;
            }
        } else {
            form1.CONCAT_DOCTYPE_DELETE.value += lv_docType;
        }
    }

    eval("form1.BLOB_ID" + lv_docType).value = "";
    eval("form1.BLOB_PART" + lv_docType).value = "0";
    eval("PICT_CNT" + lv_docType).innerHTML = "";
    eval("clear_" + lv_docType).style.display = "none";
    eval("copy_" + lv_docType).style.display = "none";
    eval("paste_" + lv_docType).style.display = "inline";
    eval("form1.FILE_TYPE" + lv_docType).value = "";
    eval("form1.FILE_NAME" + lv_docType).value = "";
    eval("form1.PICT_INIT" + lv_docType).value = "";
}

function pasteBlobPict(lv_docType) {
    var doc_type_move = form1.hidDocTypeMove.value;
    var blob_move = form1.hidBlobMove.value;
    var pict_move = form1.hidPictMove.value;
    var filetype_move = form1.hidFileTypeMove.value;
    var filename_move = form1.hidFileNameMove.value;
    var blobsize_move = form1.hidBlobSizeMove.value;
    var pictinit_move = form1.hidPictInitMove.value;
    var blobflag_move = form1.hidBlobFlagMove.value;
    var pict_init = eval("form1.PICT_INIT" + lv_docType).value;
    var filter_file_type = eval("form1.FILE_TYPE_FILTER" + lv_docType).value;
    var file_type_flag = eval("form1.FILE_TYPE_FLAG" + lv_docType).value;
    var filter_file_size = eval("form1.FILE_SIZE_FILTER" + lv_docType).value;
    var file_size_flag = eval("form1.FILE_SIZE_FLAG" + lv_docType).value;

    if (pict_init != "") {
        alert(lc_edit_document_doctype_not_empty);
        return;
    }


    if (doc_type_move == "") {
        alert(lc_new_document_doctype_empty);
        return;
    }

    if (!showMsg(0, 1, lc_confirm_paste_document_type)) {
        return;
    }

    if (filter_file_type != "" && file_type_flag == 'Y') {
        var arr_file_type = filetype_move.split(",");
        for (var idx = 0; idx < arr_file_type.length; idx++) {
            if (filter_file_type.indexOf(arr_file_type[idx]) == -1) {
                alert(lc_file_not_match_cannot_move_doctype);
                return;
            }
        }
    }

    if (filter_file_size != "" && file_size_flag == 'Y') {
        if (parseInt(filter_file_size) * 1000 < parseInt(blobsize_move)) {
            alert(lc_file_more_size_cannot_move_doctype);
            return;
        }
    }

    //--- New Doc Type
    eval("form1.BLOB_ID" + lv_docType).value = blob_move;
    eval("form1.BLOB_PART" + lv_docType).value = pict_move;
    eval("PICT_CNT" + lv_docType).innerHTML = "(" + pict_move + ")";
    eval("form1.USED_SIZE_ARG" + lv_docType).value = blobsize_move;
    eval("form1.XML_TAG" + lv_docType).value = "0";
    eval("copy_" + lv_docType).style.display = "inline";
    eval("paste_" + lv_docType).style.display = "none";
    eval("clear_" + lv_docType).style.display = "inline";
    eval("form1.FILE_TYPE" + lv_docType).value = filetype_move;
    eval("form1.FILE_NAME" + lv_docType).value = filename_move;
    if (blobflag_move == 'Y') {
        eval("form1.BLOB_FLAG" + lv_docType).value = "Y";
    } else if (blobflag_move == 'M') {
        if (lv_docType == doc_type_move) {
            eval("form1.BLOB_FLAG" + lv_docType).value = "N";
        } else {
            eval("form1.BLOB_FLAG" + lv_docType).value = doc_type_move;
        }
    } else {
        eval("form1.BLOB_FLAG" + lv_docType).value = doc_type_move;
    }
    eval("form1.PICT_INIT" + lv_docType).value = pictinit_move;

    //--- Old Doc Type
    eval("form1.BLOB_ID" + doc_type_move).value = "";
    eval("form1.BLOB_PART" + doc_type_move).value = "0";
    eval("PICT_CNT" + doc_type_move).innerHTML = "";
    eval("form1.USED_SIZE_ARG" + doc_type_move).value = "0";
    eval("form1.XML_TAG" + doc_type_move).value = "0";
    eval("copy_" + doc_type_move).style.display = "none";
    eval("paste_" + doc_type_move).style.display = "inline";
    eval("clear_" + doc_type_move).style.display = "none";
    eval("form1.FILE_TYPE" + doc_type_move).value = "";
    eval("form1.FILE_NAME" + doc_type_move).value = "";
    if (blobflag_move == 'Y') {
        eval("form1.BLOB_FLAG" + doc_type_move).value = "N";
    } else if (blobflag_move == 'M') {
        if (lv_docType == doc_type_move) {
            eval("form1.BLOB_FLAG" + lv_docType).value = "N";
        } else {
            eval("form1.BLOB_FLAG" + doc_type_move).value = "M";
        }
    } else {
        eval("form1.BLOB_FLAG" + doc_type_move).value = "M";
    }
    eval("form1.PICT_INIT" + doc_type_move).value = "";

    form1.hidDocTypeMove.value = "";
    form1.hidBlobMove.value = "";
    form1.hidPictMove.value = "";
    form1.hidFileTypeMove.value = "";
    form1.hidFileNameMove.value = "";
    form1.hidBlobSizeMove.value = "";
    form1.hidPictInitMove.value = "";
}

function copyBlobPict(lv_docType) {
    if (!showMsg(0, 1, lc_confirm_copy_document_type)) {
        return;
    }

    var lv_blob = eval("form1.BLOB_ID" + lv_docType).value;
    var lv_pict = eval("form1.BLOB_PART" + lv_docType).value;
    var lv_filetype = eval("form1.FILE_TYPE" + lv_docType).value;
    var lv_filename = eval("form1.FILE_NAME" + lv_docType).value;
    var lv_blobsize = eval("form1.USED_SIZE_ARG" + lv_docType).value;
    var lv_pictinit = eval("form1.PICT_INIT" + lv_docType).value;
    var lv_blobflag = eval("form1.BLOB_FLAG" + lv_docType).value;

    form1.hidDocTypeMove.value = lv_docType;
    form1.hidBlobMove.value = lv_blob;
    form1.hidPictMove.value = lv_pict;
    form1.hidFileTypeMove.value = lv_filetype;
    form1.hidFileNameMove.value = lv_filename;
    form1.hidBlobSizeMove.value = lv_blobsize;
    form1.hidPictInitMove.value = lv_pictinit;
    form1.hidBlobFlagMove.value = lv_blobflag;
}

function get_log(batch_no,document_running,action_flag){
	formLog.BATCH_NO.value 		   = batch_no;
	formLog.DOCUMENT_RUNNING.value = document_running;
	formLog.ACTION_FLAG.value	   = action_flag;
	formLog.target = "frameLog";
	formLog.action = "master_log.jsp";
	formLog.submit();
}

function hadAttach() {
	form1.hidHadAttach.value = "YES";
}

//**************************** OCR Section ***********************************//

function afterLoadFinish(){

}

function setOCRFieldList(){
	try{
		inetdocview.OCRFieldList( strXml );
	}catch( e ){
		alert( e.message );
	}
}

function ocrFocus( objField ){
	var strFieldName = objField.name;

	try{
		inetdocview.OCRHighLightField( strFieldName );
	}catch( e ){
	}
}

function afterOcrFinish(){
//	getOCRTemplate();   //   always keep OCR Template when do OCR
	setOCRResult();
}

function getOCRTemplate(){
	strXmlTemplate = inetdocview.OCRTemplate();
}

function setOCRTemplate(){
	if( strXmlTemplate.length > 0 ){
		inetdocview.OCRAddTemplate( strXmlTemplate );
	}
}

function getOCRResult(){
	inetdocview.OCRRecognize();
}

function setOCRResult(){
	var strXMLResult = inetdocview.OCRResult();
	var objXml = new XML();
	var objFieldName = form1.CONCAT_FIELD_NAME.value.split( "," );
	var objField;
	var strFieldValue = "";

	objXml.loadXML( strXMLResult );

	for( var intCount = 0 ; intCount < objFieldName.length ; intCount++ ){
		objField = eval( "form1." + objFieldName[ intCount ] );
		if( objField != null ){
			strFieldValue = objXml.getNodeValue( objFieldName[ intCount ] );
			if( strFieldValue != "" ){
				objField.value = strFieldValue;
			}
		}
	}
}

function ocr_focus( objField ){
	var strFieldName = objField.name;

	try{
		inetdocview.OCRHighLightField( strFieldName );
	}catch( e ){
	}
}

function requestOfflineDoc(volume_label){
	var batch_no		 = "<%=strBatchNo%>";
	var document_running = <%=strDocumentRunning%>;
	
	if(batch_no != ""){
		formOffline.BATCH_NO.value 		   = batch_no;
		formOffline.DOCUMENT_RUNNING.value = document_running;
		formOffline.MEDIA_LABEL.value 	   = volume_label;
		
		formOffline.target = "frameOffline";
		formOffline.action = "offline_document.jsp";
		formOffline.submit();
	}
}

function click_docmove(){
	var strPopArgument = "scrollbars=yes,status=yes";
	var strWidth 	   = ",width=550px";
	var strHeight 	   = ",height=250px";
	var strUrl 	   = "";
	var strConcatField = "";
	var strDocumentNo  = "<%=strDocumentNo %>";
	
	strPopArgument += strWidth + strHeight;
	strUrl          = "inc/show_project_target.jsp";
	strConcatField += "&BATCH_NO=<%=strBatchNo%>"; 
	strConcatField += "&DOCUMENT_RUNNING=<%=strDocumentRunning%>";
	strConcatField += "&DOCUMENT_NO=" + strDocumentNo;
        
        open_loading();
	
	objDocMoveWindow = window.open( strUrl + "?" + strConcatField , "docmove", strPopArgument );
	objDocMoveWindow.focus();
}

function clear_screen(){
    $('#load_screen_div').hide();
    $('#progess_div').hide();
}

function open_loading(){
    $('#load_screen_div').css({'opacity': 0.7});
    $('#load_screen_div').show();
    $('#load_screen_div').css("height", $(document).height());
    $('#progess_div').show();
}

function close_loading(){
    $('#load_screen_div').hide();
    $('#progess_div').hide();
}

//-->
</script>
<link href="css/edas.css" type="text/css" rel="stylesheet">
<link href="css/loading.css" type="text/css" rel="stylesheet">
</head>
<body onLoad="MM_preloadImages('images/btt_keepdoc_over.gif','images/i_new_over.jpg','images/i_save_over.jpg','images/i_import_over.jpg','images/i_ocr_over.jpg','images/i_edit_del_over.jpg','images/i_out_over.jpg','images/btt_attached_over.gif','images/doc.gif');window_onload()" onunload="window_onunload();">
<form name="form1" action="" method="post">
<jsp:include page="inc/loading_div.jsp"></jsp:include>
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
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
		          <td width="*" height="29" background="images/inner_img_07.jpg" valign="middle">
		          	<span class="navbar_02">(<%=strUserOrgName%>)</span> <span class="navbar_01"><%=lb_user_name %> : <%=strUserName %> (<%=strUserId%> / <%=strUserLevel%>)</span> 
		          </td>
		          <td width="170" class="navbar_01" align="right" style="padding-right: 30px"><%=dateToDisplay(strCurrentDate)%>&nbsp;</td>
		        </tr>
		   	</table>
       	</td>
  	</tr>
  	<tr> 
    	<td valign="top" style="border: 1px solid #FFF">
    		<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#F4F1DD">
		        <tr>
	          		<td width="50%" height="21">
	          			<table width="100%" border="0" cellspacing="0" cellpadding="0" style="border: 1px solid #FFF">
			              	<tr>
			                	<td onclick="div_click('div_info','tab_img_data',0)" style="cursor:pointer" background="images/tab_img_01.gif"><img id="tab_img_data" src="images/tab_img_data.gif" width="128" height="21"></td>
			              	</tr>
		            	</table>
	            	</td>
	          		<td>
		          		<table width="100%" border="0" cellspacing="0" cellpadding="0" style="border: 1px solid #FFF">
			              	<tr> 
			                	<td background="images/tab_img_04.jpg"><img src="images/tab_img_doc.gif" width="128" height="21"></td>
			              	</tr>
            			</table>
			     	</td>
				</tr>
			    <tr> 
			        <td width="50%" valign="top" style="border: 1px solid #FFF">
			        	<!-- -------------------------- Document information ----------------------------------------- -->
			        	<div id="div_info" name="div_info" style="display:none;clear: left;">
                                            <table width="460" border="0" align="left" cellpadding="0" cellspacing="0" class="label_bold2" style="margin-left: 15px;">
			              	<tr> 
				                <td width="145">Document-Number</td>
				                <td colspan="2">
				                	<input id="txtDocNum" name="txtDocNum" type="text" class="input_box_disable" value="<%=strBatchNo %>" size="20" maxlength="13" readonly>
				                	<input id="txtDocRunning" name="txtDocRunning" type="hidden" value="<%=strDocumentRunning %>" >
				                </td>
			              	</tr>
			              	<tr> 
				                <td width="145"><span id="document_name"></span></td>
				                <td colspan="2">
				                	<input id="txtDocName" name="txtDocName" type="text" class="input_box" value="<%=strDocumentName %>" size="56" maxlength="500">
				                </td>
			              	</tr>
			              	<tr> 
			                	<td><span id="document_user"></span></td>
			                	<td colspan="2">
			                		<input id="txtDocUser" name="txtDocUser" type="text" class="input_box_disable" value="<%=strDocumentUser %>" size="12" readonly> 
			                  		<a href="javascript:openDocUserZoom('DOC_USER', '<%=lb_doc_user %>');"><img src="images/search.gif" width="16" height="16" border="0" align="absmiddle"></a> 
		                			<input id="txtDocUserName" name="txtDocUserName" type="text" class="input_box_disable" value="<%=strDocUserFullName %>" size="35" readonly>
		                			<input id="txtDocOrg" name="txtDocOrg" type="hidden" value="<%=strDocumentOrg %>" >
	                			</td>
			              	</tr>
			              	<tr> 
			                	<td><span id="document_level"></span></td>
			                	<td colspan="2">
			                		<input  id="txtDocLevel" name="txtDocLevel" type="text" class="input_box_disable" value="<%=strDocumentLevel %>" size="6" maxlength="4" style="text-align:right" readonly> 
			                  		<a href="javascript:openZoom('USER_LEVEL' , '<%=lb_level_doc %>' , form1.txtDocLevelName , form1.txtDocLevel,'1');"><img src="images/search.gif" width="16" height="16" border="0" align="absmiddle"></a> 
		                			<input id="txtDocLevelName" name="txtDocLevelName" type="text" class="input_box_disable" value="<%=strLevelName %>" size="41" readonly>
	                			</td>
			              	</tr>
			              	<tr> 
			                	<td><span id="add_user"></span></td>
			                	<td>
			                		<input id="txtAddUserId" name="txtAddUserId" type="text" class="input_box_disable" value="<%=strAddUserId %>" size="15" readonly>
		                		</td>
			                	<td>
			                		<input id="txtAddUserName" name="txtAddUserName" type="text" class="input_box_disable" value="<%=strAddUserName%>" size="35" readonly>
		                		</td>
			              	</tr>
			              	<tr> 
				                <td><span id="add_date"></span></td>
				                <td colspan="2">
				                	<input id="txtAddDate" name="txtAddDate" type="text" class="input_box_disable" value="<%=strAddDate %>" size="15" readonly>
			                	</td>
			              	</tr>
			              	<tr> 
				            	<td><span id="upd_user"></span></td>
				                <td>
				                	<input id="txtEditUserId" name="txtEditUserId" type="text" class="input_box_disable" value="<%=strEditUserId %>" size="15" readonly>
			                	</td>
				                <td>
				                	<input id="txtEditUserName" name="txtEditUserName" type="text" class="input_box_disable" value="<%=strEditUserName %>" size="35" readonly>
			                	</td>
			              	</tr>
			              	<tr> 
				                <td><span id="upd_date"></span></td>
				                <td colspan="2">
				                	<input id="txtEditDate" name="txtEditDate" type="text" class="input_box_disable" value="<%=strEditDate %>" size="15" readonly>
			                	</td>
				           	</tr>
				            <tr> 
				                <td><span id="expire_date"></span></td>
				                <td colspan="2">
				                	<input id="txtExpireDate" name="txtExpireDate" type="text" class="input_box" value="<%=strExpireDate %>" size="15" maxlength="8" onkeypress="keypress_number();field_press(this)" onblur="set_format_date(this)">
				                	<input type="hidden" id="EXPIRE_DATE" name="EXPIRE_DATE">
				                	<a href="javascript:showCalendar(form1.txtExpireDate,<%=strLangFlag %>)"><img src="images/calendar.gif" width="16" height="16" align="absmiddle" border="0"></a>
				                </td>
				            </tr>
			              	<tr> 
				                <td><span id="doc_status"></span></td>
				                <td colspan="2">
				                	<input id="txtDocStatus" name="txtDocStatus" type="text" class="input_box_disable" value="<%=strCheckStatus %>" size="15" readonly>
				                </td>				                
			              	</tr>
			              	<tr> 
				                <td><span id="carbinet_no"></span></td>
				                <td colspan="2">
				                	<input id="txtCarbinetNo" name="txtCarbinetNo" type="text" class="input_box_disable" value="<%=strBoxNo %>" size="15" readonly>
			                	</td>
			              	</tr>
			              	<tr> 
				                <td><span id="storehouse"></span></td>
				                <td colspan="2">
				                	<input id="txtStoreHouse" name="txtStoreHouse" type="text" class="input_box_disable" value="<%=strStorehouseName %>" size="50" readonly>
				                	<input id="STORE_HOUSE" name="STORE_HOUSE" type="hidden" value="<%=strStorehouse %>">
				                	<a href="javascript:openZoom('STOREHOUSE' , '<%=lb_doc_store %>' , form1.txtStoreHouse , form1.STORE_HOUSE, '1');"><img src="images/search.gif" width="16" height="16" border="0" align="absmiddle"></a>
			                	</td>
			              	</tr>
			              	<tr>
			              		<td colspan="3">
			              			<input type="hidden" name="TOTAL_SIZE" 		value="<%=strTotalSize %>" />
			              			<input type="hidden" name="AVAIL_SIZE" 		value="<%=strAvailSize %>" />
			              			<input type="hidden" name="USED_SIZE" 		value="<%=strUsedSize %>" />
			              			<input type="hidden" name="PICT_SIZE_ALL" 	value="<%=strPictSizeAll %>" />
			              			<input type="hidden" id="hidHadAttach"      name="hidHadAttach"      value="" >
			              		</td>
			              	</tr>
			            </table>
			            </div>
			            <!-- -------------------------- End Document Information ----------------------------------------------- -->
                                    <table width="100%" border="0" cellspacing="0" cellpadding="0" style="border: 1px solid #FFF;clear: left;">
			              <tr> 
			                <td onclick="div_click('div_index','tab_img_index',0)" style="cursor:pointer" background="images/tab_img_01.gif"><img id="tab_img_index" src="images/tab_img_index_down.gif" width="128" height="21"></td>
			              </tr>
			            </table>
			            <!-- ------------------------------ Document Index ------------------------------------------------------ -->
	
						<div id="div_index" name="div_index" style="display:inline;clear: left">
                                                    <table width="460" border="0" align="left" cellpadding="0" cellspacing="0" class="label_bold2" style="margin-left: 15px;">
			            	<tr><td height="15"></td></tr>
			            	
<%
			String strTag 		= "";
			String strPrefix 	= "";
			String strClass 	= "text_normal";
			String strReadonly 	= "";
			String strDisabled 	= "";
			
			String strTableLv1  	= "";
			String strTableLv1Label = "";
			String strTableLv2  	= "";
			String strTableLv2Label = "";
			
			boolean bolnPK = false;
			
			for( int intCountField = 0 ; intCountField < strDataName.length ; intCountField++ ){
				
				if( strDataPK[ intCountField ].equals( "Y" ) ){
		        	if(strDataValue[ intCountField ].length()>0){
						strClass = "input_box_disable";
			            strReadonly = "readonly";
			            strDisabled = "disabled";
			            bolnPK = true;
		        	}else{
		        		strClass = "input_box";
			            strReadonly = "";
			            strDisabled = "";
			            bolnPK = false;
		        	}
		        }else{
		            strClass = "input_box";
		            strReadonly = "";
		            strDisabled = "";
		            bolnPK = false;
		        }
				
				if( strDataType[ intCountField ].equals( "CHAR" ) ){
					strTag = "<input type=\"text\" " +
		                    "id=\"" + strDataName[ intCountField ] + "\" " +
		                    "name=\"" + strDataName[ intCountField ] + "\" " +
		                    "class=\"" + strClass + "\" " +
		                    "size=\"" +  strDataSize[ intCountField ] + "\" " +
		                    "maxlength=\"" + strDataLength[ intCountField ] + "\" " +
		                    "value_type=\"" + strDataType[ intCountField ].toLowerCase() + "\" " +
		                    "is_PK=\"" + strDataPK[ intCountField ] + "\" " +
		                    "is_NotNull=\"" + strDataNotNull[ intCountField ] + "\" " +
		                    "onKeypress=\"field_press( this );\" " + strReadonly +  
		                    " onFocus=\"ocr_focus( this );\">";

		        }else if( strDataType[ intCountField ].equals( "NUMBER" ) ){
					strTag = "<input type=\"text\" " +
                                    "id=\"" + strDataName[ intCountField ] + "\" " +
		                    "name=\"" + strDataName[ intCountField ] + "\" " +
		                    "class=\"" + strClass + "\" " +
		                    "size=\"" + strDataSize[ intCountField ] + "\" " +
		                    "maxlength=\"" + strDataLength[ intCountField ] + "\" " +
		                    "value_type=\"number\" " +
		                    "is_PK=\"" + strDataPK[ intCountField ] + "\" " +
		                    "is_NotNull=\"" + strDataNotNull[ intCountField ] + "\" " +
		                    "onKeypress=\"keypress_number();field_press( this );\" " + strReadonly + 
		                    " onFocus=\"ocr_focus( this );\">";
		                    
        		}else if( strDataType[ intCountField ].equals( "TIN" ) ){
					strTag = "<input type=\"text\" " +
                                    "id=\"" + strDataName[ intCountField ] + "\" " +
		                    "name=\"" + strDataName[ intCountField ] + "\" " +
		                    "class=\"" + strClass + "\" " +
		                    "size=\"" + ( Integer.parseInt( strDataSize[ intCountField ] ) + 5 ) + "\" " +
		                    "maxlength=\"" + strDataLength[ intCountField ] + "\" " +
		                    "value_type=\"" + strDataType[ intCountField ].toLowerCase() + "\" " +
		                    "is_PK=\"" + strDataPK[ intCountField ] + "\" " +
		                    "is_NotNull=\"" + strDataNotNull[ intCountField ] + "\" " +
		                    "onKeypress=\"keypress_number();field_press( this );\" " + 
                                    "onfocus=\"set_unmask(this)\" " +
		                    "onblur=\"set_mask(this,'tin')\" " + strReadonly + ">";
		
		        }else if( strDataType[ intCountField ].equals( "PIN" ) ){
					strTag = "<input type=\"text\" " +
                                    "id=\"" + strDataName[ intCountField ] + "\" " +
		                    "name=\"" + strDataName[ intCountField ] + "\" " +
		                    "class=\"" + strClass + "\" " +
		                    "size=\"" + ( Integer.parseInt( strDataSize[ intCountField ] ) + 5 ) + "\" " +
		                    "maxlength=\"" + strDataLength[ intCountField ] + "\" " +
		                    "value_type=\"" + strDataType[ intCountField ].toLowerCase() + "\" " +
		                    "is_PK=\"" + strDataPK[ intCountField ] + "\" " +
		                    "is_NotNull=\"" + strDataNotNull[ intCountField ] + "\" " +
		                    "onKeypress=\"keypress_number();field_press( this );\" " +
                                    "onfocus=\"set_unmask(this)\" " +
		                    "onblur=\"set_mask(this,'pin')\" " + strReadonly + ">";
		
		        }else if( strDataType[ intCountField ].equals( "DATE" ) ){
					strTag = "<input type=\"text\" " +
                                    "id=\"" + strDataName[ intCountField ] + "\" " +
		                    "name=\"" + strDataName[ intCountField ] + "\" " +
		                    "class=\"" + strClass + "\" " +
		                    "size=\"" + strDataSize[ intCountField ] + "\" " +
		                    "maxlength=\"" + strDataLength[ intCountField ] + "\" " +
		                    "value_type=\"date\" " +
		                    "is_PK=\"" + strDataPK[ intCountField ] + "\" " +
		                    "is_NotNull=\"" + strDataNotNull[ intCountField ] + "\" " +
		                    "onKeypress=\"keypress_number();field_press( this );\" " +
                                    "onFocus=\"set_unformat_date( this );\" " +
		                    "onBlur=\"set_format_date( this );\" " + strReadonly + ">";
		
		            if( !bolnPK ){
		                strTag += " <a href=\"javascript:showCalendar(form1." + strDataName[ intCountField ] + ",1)\">" + 
		                "<img src=\"images/calendar.gif\" align=\"absmiddle\" border=\"0\"></a>";
		            }
		        }else if( strDataType[ intCountField ].equals( "DATE_ENG" ) ){
					strTag = "<input type=\"text\" " +
                                    "id=\"" + strDataName[ intCountField ] + "\" " +
		                    "name=\"" + strDataName[ intCountField ] + "\" " +
		                    "class=\"" + strClass + "\" " +
		                    "size=\"" + strDataSize[ intCountField ] + "\" " +
		                    "maxlength=\"" + strDataLength[ intCountField ] + "\" " +
		                    "value_type=\"date_eng\" " +
		                    "is_PK=\"" + strDataPK[ intCountField ] + "\" " +
		                    "is_NotNull=\"" + strDataNotNull[ intCountField ] + "\" " +
		                    "onKeypress=\"keypress_number();field_press( this );\" " +
		                    "onFocus=\"set_unformat_date( this );\" " +
		                    "onBlur=\"set_format_date_eng( this );\" " + strReadonly + ">";
		
		            if( !bolnPK ){
		                strTag += " <a href=\"javascript:showCalendar(form1." + strDataName[ intCountField ] + ",0)\">" + 
		                "<img src=\"images/calendar.gif\" align=\"absmiddle\" border=\"0\"></a>";
		            }
		        }else if( strDataType[ intCountField ].equals( "MONTH" ) ){
					if(!bolnPK){
		        		strClass = "combobox";
		        	}
					strTag = "\n<select id=\"" + strDataName[ intCountField ] + "\" name=\"" + strDataName[ intCountField ] + "\" " +
		                    "class=\"" + strClass + "\" " +
		                    "value_type=\"list\" " +
		                    "is_PK=\"" + strDataPK[ intCountField ] + "\" " +
		                    "is_NotNull=\"" + strDataNotNull[ intCountField ] + "\" " +
		                    "onKeypress=\"fieldPress( this );\" " + strDisabled + ">";
		
		            strTag += "\n<option value=\"\"></option>";
					
					String strZoomDisplayValue = "";
					String strZoomDisplayText  = "";
					String strSelected 	= "";
					
					//conList.addData( "TABLE_ZOOM" , "String" , strDataTableZoom[ intCountField ] );
					boolean bolnZoomSuccess = conList.executeService( strContainerName , "IMPORTDATA" , "findMonthCombo" );

					if( bolnZoomSuccess ){
						while( conList.nextRecordElement() ){
							strZoomDisplayValue = conList.getColumn( strDataTableZoom[ intCountField ] );
							strZoomDisplayText  = conList.getColumn( strDataTableZoom[ intCountField ] + "_NAME" );
							
						/*	if( strZoomDisplayValue.equals( strDefaultValue ) ){
								strSelected = " selected";
							}else{
								strSelected = "";
							}
						*/
							strTag += "\n<option value=\"" + strZoomDisplayValue + "\"" + strSelected + ">" + strZoomDisplayText + "</option>";
						}
					}
					strTag += "\n</select>";
		        }else if( strDataType[ intCountField ].equals( "MONTH_ENG" ) ){
					if(!bolnPK){
		        		strClass = "combobox";
		        	}
					strTag = "\n<select name=\"" + strDataName[ intCountField ] + "\" " +
                                    "id=\"" + strDataName[ intCountField ] + "\" " +                                                
		                    "class=\"" + strClass + "\" " +
		                    "value_type=\"list\" " +
		                    "is_PK=\"" + strDataPK[ intCountField ] + "\" " +
		                    "is_NotNull=\"" + strDataNotNull[ intCountField ] + "\" " +
		                    "onKeypress=\"fieldPress( this );\" " + strDisabled + ">";
		
		            strTag += "\n<option value=\"\"></option>";
					
					String strZoomDisplayValue = "";
					String strZoomDisplayText  = "";
					String strSelected 	= "";
					
					conList.addData( "TABLE_ZOOM" , "String" , "MONTH_ENG" );
					boolean bolnZoomSuccess = conList.executeService( strContainerName , "IMPORTDATA" , "findTableCode" );

					if( bolnZoomSuccess ){
						while( conList.nextRecordElement() ){
							strZoomDisplayValue = conList.getColumn( "MONTH_ENG" );
							strZoomDisplayText  = conList.getColumn( "MONTH_ENG_NAME" );
							
						/*	if( strZoomDisplayValue.equals( strDefaultValue ) ){
								strSelected = " selected";
							}else{
								strSelected = "";
							}
						*/
							strTag += "\n<option value=\"" + strZoomDisplayValue + "\"" + strSelected + ">" + strZoomDisplayText + "</option>";
						}
					}
					strTag += "\n</select>";
				}else if( strDataType[ intCountField ].equals( "YEAR" ) ){
					strTag = "<input type=\"text\" " +
                                    "id=\"" + strDataName[ intCountField ] + "\" " +
                    "name=\"" + strDataName[ intCountField ] + "\" " +
                    "class=\"" + strClass + "\" " +
                    "size=\"" +  strDataSize[ intCountField ] + "\" " +
                    "maxlength=\"" + strDataLength[ intCountField ] + "\" " +
                    "value_type=\"" + strDataType[ intCountField ].toLowerCase() + "\" " +
                    "is_PK=\"" + strDataPK[ intCountField ] + "\" " +
                    "is_NotNull=\"" + strDataNotNull[ intCountField ] + "\" " +
                    "onKeypress=\"field_press( this );\" " + strReadonly +  
                    " onFocus=\"ocr_focus( this );\">";

        		}else if( strDataType[ intCountField ].equals( "MEMO" ) ){
		        	if(!bolnPK){
		        		strClass = "input_box_multi";
		        	}
					strTag = "<textarea " +
                                    "id=\"" + strDataName[ intCountField ] + "\" " +
		                    "name=\"" + strDataName[ intCountField ] + "\" " +
		                    "cols=\"65\" " +
		                    "rows=\"8\" " +
		                    "is_PK=\"" + strDataPK[ intCountField ] + "\" " +
		                    "is_NotNull=\"" + strDataNotNull[ intCountField ] + "\" " +
		                    "value_type=\"" + strDataType[ intCountField ].toLowerCase() + "\" " +
		                    "class=\"" + strClass + "\"" + strReadonly  + 
		                    " onFocus=\"ocr_focus( this );\">" +
		                    "</textarea>";
				}else if( strDataType[ intCountField ].equals( "CURRENCY" ) ){
					strTag = "<input type=\"text\" " +
                                    "id=\"" + strDataName[ intCountField ] + "\" " +
		                    "name=\"" + strDataName[ intCountField ] + "\" " +
		                    "class=\"" + strClass + "\" " +
		                    "size=\"" + strDataSize[ intCountField ] + "\" " +
		                    "maxlength=\"" + strDataLength[ intCountField ] + "\" " +
		                    "value_type=\"number\" " +
		                    "is_PK=\"" + strDataPK[ intCountField ] + "\" " +
		                    "is_NotNull=\"" + strDataNotNull[ intCountField ] + "\" " +
		                    "onKeypress=\"keypress_currency(this);field_press( this );\" " +
		                    "onFocus=\"ocr_focus( this );\" " +
		                    "onclick=\"change_format_currency(this)\" " +
		                    "onblur=\"set_currency_format(this)\"" + strReadonly + ">";
		                    
				}else if( strDataType[ intCountField ].equals( "ZOOM" ) ){
					strTag = "<input type=\"hidden\" " +
		                    "id=\"" + strDataName[ intCountField ] + "\" " +
		                    "name=\"" + strDataName[ intCountField ] + "\" " +
		                    "value_type=\"zoom\" " +
		                    "is_PK=\"" + strDataPK[ intCountField ] + "\" " +
		                    "is_NotNull=\"" + strDataNotNull[ intCountField ] + "\">";
		              
		            strTag += "\n<input type=\"text\" " +
		                    "name=\"DSP_" + strDataName[ intCountField ] + "\" " +
		                    "id=\"DSP_" + strDataName[ intCountField ] + "\" " +
		                    "class=\"input_box_disable\" " +
		                    "size=\"40\" readonly>";
		            
		            if( !bolnPK ){
		                strTag += " \n<a href=\"javascript:openZoom('" + strDataTableZoom[ intCountField ] + "' , '" + strDataLabel[ intCountField ] + "' , form1.DSP_" + strDataName[ intCountField ] + " , form1." + strDataName[ intCountField ] + ", '" + strDataTableLevel[ intCountField ] + "');\">" +
		                		"<img src=\"images/search.gif\" width=16 height=16 align=\"absmiddle\" border=0></a>";
		            }
		            
		            if(strDataTableLevel.equals("1")){
						strTag += "\n<input type=\"hidden\" name=\"FIELD_" + strDataTableZoom[ intCountField ] + "\" value=\"" + strDataName[ intCountField ] + "\">";
					
					}
					
					if(strDataTableLevel[ intCountField ].equals("2")){
						conLV.addData("PROJECT_CODE", "String", strProjectCode);
						conLV.addData("TABLE_CODE"  , "String", strDataTableLevel1[ intCountField ]);
					    boolean bolSuccessLv2 = conLV.executeService(strContainerName, "IMPORTDATA", "findFieldTableZoom");
					    if(bolSuccessLv2){
					    	strTableLv1 	 = conLV.getHeader("FIELD_CODE");
					    	strTableLv1Label = conLV.getHeader("FIELD_LABEL");
					    	
					    	strTag += "\n<input type=\"hidden\" name=\"FIELD_" + strDataTableZoom[ intCountField ] + "_LV1\" value=\"" + strTableLv1 + "\">";
							strTag += "\n<input type=\"hidden\" name=\"FIELD_" + strDataTableZoom[ intCountField ] + "_LV1_LABEL\" value=\"" + strTableLv1Label + "\">";
							strTag += "\n<input type=\"hidden\" name=\"FIELD_" + strDataTableZoom[ intCountField ] + "_LV1_CODE\" value=\"" + strDataTableLevel1[ intCountField ] + "\">";
							strTag += "\n<input type=\"hidden\" name=\"FIELD_" + strDataTableLevel1[ intCountField ] + "_LV2\" value=\"" + strDataName[ intCountField ] + "\">";
					    }						    
						strTag += "\n<input type=\"hidden\" name=\"FIELD_" + strDataTableZoom[ intCountField ] + "\" value=\"" + strDataName[ intCountField ] + "\">";
					
					}

					if(strDataTableLevel[ intCountField ].equals("3")){
						conLV.addData("PROJECT_CODE", "String", strProjectCode);
						conLV.addData("TABLE_CODE"  , "String", strDataTableLevel1[ intCountField ]);
					    boolean bolSuccessLv3 = conLV.executeService(strContainerName, "IMPORTDATA", "findFieldTableZoom");
					    if(bolSuccessLv3){
					    	strTableLv1 	 = conLV.getHeader("FIELD_CODE");
					    	strTableLv1Label = conLV.getHeader("FIELD_LABEL");
					    	
					    	strTag += "\n<input type=\"hidden\" name=\"FIELD_" + strDataTableZoom[ intCountField ] + "_LV1\" value=\"" + strTableLv1 + "\">";
							strTag += "\n<input type=\"hidden\" name=\"FIELD_" + strDataTableZoom[ intCountField ] + "_LV1_LABEL\" value=\"" + strTableLv1Label + "\">";
							strTag += "\n<input type=\"hidden\" name=\"FIELD_" + strDataTableZoom[ intCountField ] + "_LV1_CODE\" value=\"" + strDataTableLevel1[ intCountField ] + "\">";
							strTag += "\n<input type=\"hidden\" name=\"FIELD_" + strDataTableLevel1[ intCountField ] + "_LV3\" value=\"" + strDataName[ intCountField ] + "\">";
					    }
					    conLV.addData("PROJECT_CODE", "String", strProjectCode);
						conLV.addData("TABLE_CODE"  , "String", strDataTableLevel2[ intCountField ]);
						
					    bolSuccessLv3 = conLV.executeService(strContainerName, "IMPORTDATA", "findFieldTableZoom");
					    if(bolSuccessLv3){
					    	strTableLv2 	 = conLV.getHeader("FIELD_CODE");
					    	strTableLv2Label = conLV.getHeader("FIELD_LABEL");
					    	
					    	strTag += "\n<input type=\"hidden\" name=\"FIELD_" + strDataTableZoom[ intCountField ] + "_LV2\" value=\"" + strTableLv2 + "\">";
							strTag += "\n<input type=\"hidden\" name=\"FIELD_" + strDataTableZoom[ intCountField ] + "_LV2_LABEL\" value=\"" + strTableLv2Label + "\">";
							strTag += "\n<input type=\"hidden\" name=\"FIELD_" + strDataTableZoom[ intCountField ] + "_LV2_CODE\" value=\"" + strDataTableLevel2[ intCountField ] + "\">";
							strTag += "\n<input type=\"hidden\" name=\"FIELD_" + strDataTableLevel2[ intCountField ] + "_LV3\" value=\"" + strDataName[ intCountField ] + "\">";
					    }
						strTag += "\n<input type=\"hidden\" name=\"FIELD_" + strDataTableZoom[ intCountField ] + "\" value=\"" + strDataName[ intCountField ] + "\">";
						
					}
		            if( strDataTableZoom[ intCountField ].equalsIgnoreCase( "province" ) ){
						strTag += "\n<input type=\"hidden\" name=\"FIELD_PROVINCE\" value=\"" + strDataName[ intCountField ] + "\">";
					}
					if( strDataTableZoom[ intCountField ].equalsIgnoreCase( "amphur" ) ){
						strTag += "\n<input type=\"hidden\" name=\"FIELD_AMPHUR\" value=\"" + strDataName[ intCountField ] + "\">";
					}
					if( strDataTableZoom[ intCountField ].equalsIgnoreCase( "tumbon" ) ){
						strTag += "\n<input type=\"hidden\" name=\"FIELD_TUMBON\" value=\"" + strDataName[ intCountField ] + "\">";
					}
		
					strConcatFieldName += "DSP_" + strDataName[ intCountField ] + ",";
					
				}else if( strDataType[ intCountField ].equals( "LIST" ) ){
					if(!bolnPK){
                                            strClass = "combobox";
                                        }
                                        
                                        String strOnChangeEvent = "";
                                            
                                            if(strDataTableLevel[ intCountField ].equals("1")){
                                                strOnChangeEvent = "onchange=\"get_table_level2('" + strDataName[ intCountField ] + "','" + strDataTableZoom[ intCountField ] + "')\"";
                                            }else if(strDataTableLevel[ intCountField ].equals("2")){
                                                strOnChangeEvent = "onchange=\"get_table_level3('" + strDataName[ intCountField ] + "','" + strDataTableZoom[ intCountField ] + "')\"";
                                            }else{
                                                strOnChangeEvent = "";
                                            }
                                        
					strTag = "\n<select name=\"" + strDataName[ intCountField ] + "\" " +
                                    "id=\"" + strDataName[ intCountField ] + "\" " +
		                    "class=\"" + strClass + "\" " +
		                    "value_type=\"list\" " +
		                    "is_PK=\"" + strDataPK[ intCountField ] + "\" " +
		                    "is_NotNull=\"" + strDataNotNull[ intCountField ] + "\" " +
                                    "style=\"max-width : 450px\" " +
                                    strOnChangeEvent + " " +
		                    "onKeypress=\"fieldPress( this );\" " + strDisabled + ">";
		
		            strTag += "\n<option value=\"\"></option>";
					
					String strZoomDisplayValue = "";
					String strZoomDisplayText  = "";
					
                                   // if(strDataTableLevel[ intCountField ].equals("1")){    
					conList.addData( "TABLE_ZOOM" , "String" , strDataTableZoom[ intCountField ] );

					boolean bolnZoomSuccess = conList.executeService( strContainerName , "IMPORTDATA" , "findTableCode" );

					if( bolnZoomSuccess ){
						while( conList.nextRecordElement() ){
							strZoomDisplayValue = conList.getColumn( strDataTableZoom[ intCountField ] );
							strZoomDisplayText  = conList.getColumn( strDataTableZoom[ intCountField ] + "_NAME" );
							
							strTag += "\n<option value=\"" + strZoomDisplayValue + "\" >" + strZoomDisplayText + "</option>";
						}
					}
                                    //}else{
                                     //   strTag += "\n<option value=\"\">&nbsp;</option>";
                                    //}
		
                                    strTag += "\n</select>";
                                    strTag += "\n<input type=\"hidden\" id=\"" + strDataName[ intCountField ] + "_TABLEZOOM\" name=\"" + strDataName[ intCountField ] + "_TABLEZOOM\" value=\"" + strDataTableZoom[ intCountField ] + "\">\n";

                                    if(strDataTableLevel[ intCountField ].equals("2")){
                                        strTag += "\n<input type=\"hidden\" id=\"" + strDataName[ intCountField ] + "_TABLE_LEVEL1\" name=\"" + strDataName[ intCountField ] + "_TABLE_LEVEL1\" value=\"\">\n";
                                        strTag += "\n<input type=\"hidden\" id=\"" + strDataName[ intCountField ] + "_DATA\" name=\"" + strDataName[ intCountField ] + "_DATA\" value=\"\">\n";
                                    }else if(strDataTableLevel[ intCountField ].equals("3")){
                                        //strTag += "\n<input type=\"text\" id=\"" + strDataName[ intCountField ] + "_TABLE_LEVEL1\" name=\"" + strDataName[ intCountField ] + "_TABLE_LEVEL1\" value=\"\">\n";
                                        //strTag += "\n<input type=\"text\" id=\"" + strDataName[ intCountField ] + "_TABLE_LEVEL2\" name=\"" + strDataName[ intCountField ] + "_TABLE_LEVEL2\" value=\"\">\n";
                                        strTag += "\n<input type=\"hidden\" id=\"" + strDataName[ intCountField ] + "_DATA\" name=\"" + strDataName[ intCountField ] + "_DATA\" value=\"\">\n";
                                    }
				}
				
				strPrefix = "";
				if( strDataPK[ intCountField ].equals( "Y" ) ){
					strPrefix += "<img src=\"images/iconkey.gif\">";
				}
				if( strDataNotNull[ intCountField ].equals( "Y" ) ){
					strPrefix += "<img src=\"images/mark.gif\" width=12 height=11>";
				}
%>
			    <tr> 
                	<td> 
                  		<%=strPrefix %> <span id="<%=strDataName[ intCountField ]%>_span"><%=strDataLabel[ intCountField ] %></span> 
                	</td>
	            </tr>
	            <tr> 
	                <td><%=strTag %> 
	                </td>
	            </tr>
<%				
				if( strDataType[ intCountField ].equals( "CHAR" )||strDataType[ intCountField ].equals( "NUMBER" )||strDataType[ intCountField ].equals( "CURRENCY" )||strDataType[ intCountField ].equals( "MEMO" ) ){
					strXML += "<Item>";
					strXML += "<name>" + strDataName[ intCountField ] + "</name>";
					strXML += "<description>" + strDataLabel[ intCountField ] + "</description>";
					strXML += "</Item>";
				}
			}
			
			if( strConcatFieldName.length() > 0 ){
				strConcatFieldName = strConcatFieldName.substring( 0 , strConcatFieldName.length() - 1 );
			}			
%>			            
			            	<tr> 
				                <td>&nbsp;</td>
				            </tr>	
			            </table>
			        	</div>
			        	<!-- --------------------------------- End Document Index -------------------------------------------- -->    
		            </td>
                            <td valign="top" style="border: 1px solid #FFF"><br>
			        <!-- ----------------------------------- Document Type ------------------------------------------------------- -->    
                                <table width="95%" border="0" align="left" cellpadding="0" cellspacing="0" class="label_bold3" style="margin-left: 15px;">
<%
			if( strAccessDocTypeData.equals("A") ) {
				strAndDocTypeCon = " ";
			}else if( strAccessDocTypeData.equals("L") ) {
				strAndDocTypeCon = " AND USER_LEVEL <= '"+ strUserLevel +"'";
			}else {
				if( strSecurityFlag.equals("I") ) {
					strAndDocTypeCon = " AND DOCUMENT_TYPE IN (SELECT DOCUMENT_TYPE FROM DOCUMENT_TYPE_USER WHERE PROJECT_CODE='"+ strProjectCode +"' AND USER_ID='"+ strUserId +"')";
				}else {
					strAndDocTypeCon = " AND DOCUMENT_TYPE IN (SELECT DOCUMENT_TYPE FROM DOCUMENT_TYPE_GROUP WHERE PROJECT_CODE='"+ strProjectCode +"' AND USER_GROUP='"+ strUserGroup +"')";
				}
			}
			
			con.addData( "PROJECT_CODE",            "String", strProjectCode );
			con.addData( "DOCUMENT_TYPE_CONDITION", "String", strAndDocTypeCon );
			boolean	bolnSuccess = con.executeService( strContainerName , "DOCUMENT_TYPE" , "findDocumentType" );
			
			if(bolnSuccess){
			
				String	strDocTypeName 	= "";
				String	strDocType	= "";
				String	strAccessType	= "";
				String	strNewVersion	= "";
				String	strVersionLimit	= "";
				String	strDocUserLevel	= "";
				String	strUserLevelTmp	= "";
				String	strPermitUsers	= "";
				String	strFileSizeFlag	= "";
				String	strFileTypeFlag	= "";
				String	strFileSize	= "";
				String	strFileType	= "";
				int 	idx		= 1;
				
				while(con.nextRecordElement()){
					strUserLevelTmp = "0";
					strPermitUsers 	= "";
					
					strDocTypeName 	= con.getColumn("DOCUMENT_TYPE_NAME");
					strDocType 	= con.getColumn("DOCUMENT_TYPE");
					strAccessType 	= con.getColumn("ACCESS_TYPE");
					strNewVersion 	= con.getColumn("NEW_VERSION");
					strVersionLimit = con.getColumn("VERSION_LIMIT");
					strDocUserLevel = con.getColumn("USER_LEVEL");
					strFileSizeFlag = con.getColumn("LIMIT_SIZE_FLAG");
					strFileTypeFlag	= con.getColumn("LIMIT_FILE_TYPE_FLAG");
					strFileSize 	= con.getColumn("LIMIT_SIZE");
					strFileType 	= con.getColumn("FILE_TYPE");
				
					if(strAccessType.equals("")){
						strAccessType = "A";
					}
					if(!strAccessType.equals("A")){
						if(strAccessType.equals("L")){
							strUserLevelTmp = strDocUserLevel;
							
							if(strUserLevelTmp.equals("")){
								strUserLevelTmp = "0";
							}
						}else if(strAccessType.equals("U")){
							conDoc.addData( "PROJECT_CODE" , "String" , strProjectCode );
							conDoc.addData( "DOCUMENT_TYPE" , "String" , strDocType );
							boolean	bolnUserSuccess = conDoc.executeService( strContainerName , "DOCUMENT_TYPE" , "findDocumentTypeUser" );
							if( bolnUserSuccess ){	
						    	while(conDoc.nextRecordElement()){
						    		strPermitUsers += conDoc.getColumn("USER_ID") + ",";
						    	}						    	
						    	if(strPermitUsers.length() > 0){
						    		strPermitUsers = strPermitUsers.substring(0,strPermitUsers.length()-1);
						    	}
						    }
						}
					}
%>
					<tr id="doc_row<%=idx %>" style="display: none;"><td>
                                                <table width="500" border="0" align="left" cellpadding="0" cellspacing="0" class="label_bold2">
				              	<tr>
                                                    <td><img id="doc<%=idx %>" src="images/doc.gif" width="27" height="23" align="middle">
				                		<span id="div_header<%=idx %>" style="height: 30px;cursor: pointer;" class="label_bold2" onclick="div_click('div_doc_type<%=idx %>','doc',<%=idx %>)" style="cursor:pointer"><%=strDocTypeName %></span> 
				                 		<span name="PICT_CNT" id="PICT_CNT<%=strDocType %>" style="height: 30px" class="label_bold2"></span>&nbsp;
				                 	</td>
								</tr>
			            		<%
			            			String	strBlobData	= "";
			            			String	strPictData	= "";
			            			String	strScanNo	= "";
			            			String	strPictSize	= "";
			            			String	strFileTypeData	= "";
			            			String	strFileNameData	= "";
//			            			String	strContentData	= "";
			            		
			            			conDoc.addData("PROJECT_CODE", 		"String", strProjectCode);
			            			conDoc.addData("BATCH_NO", 			"String", strBatchNo);
			            			conDoc.addData("DOCUMENT_RUNNING", 	"String", strDocumentRunning);
			            			conDoc.addData("DOCUMENT_TYPE", 	"String", strDocType);
			            			boolean bolSuccessDocLevel = conDoc.executeService(strContainerName, strClassName, "findDocumentLevel");
			            			if(bolSuccessDocLevel){
			            				strBlobData 	= conDoc.getHeader("BLOB");
			            				strPictData 	= conDoc.getHeader("PICT");
			            				strScanNo 		= conDoc.getHeader("SCAN_NO");
			            				strPictSize		= conDoc.getHeader("PICT_SIZE");
			            				strFileTypeData	= conDoc.getHeader("FILE_TYPE");
			            				strFileNameData	= conDoc.getHeader("FILE_NAME");
			            			//	strContentData	= conDoc.getHeader("CONTENT");
			            			}
                                                        
                                                        strFileTypeData = strFileTypeData.replaceAll(";", ",");
                                                        
			            				if(strPictData.equals("")){strPictData = "0";}
			            				if(strScanNo.equals("")){strScanNo = "1";}
			            		%>
			            		<tr>
									<td>
										<div  style="padding-left: 10px;padding-bottom:2px;border-bottom: dotted 1px #0e80a9">
					                 		<label  id="btt_clip01<%=idx %>" 
					                 				style="height: 20px;cursor:pointer;padding-right: 3px;"><a href="#" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('i_attach<%=idx %>','','images/i_attach_over.gif',1)"><img name="i_attach<%=idx %>" 
					                 				src="images/i_attach.gif"  width="25" height="25" border="0" align="textmiddle" 
					                 				onclick="openAddEditView('<%=strDocType%>','<%=strFileSizeFlag %>','<%=strFileSize %>','<%=strFileTypeFlag %>','<%=strFileType %>')" title="<%=lb_tooltip_attach %>"></a></label><label id="clear_<%=strDocType %>" 
							                 		style="height: 20px;display:none;cursor: pointer;padding-right: 3px;"><a href="#" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('i_delete<%=idx %>','','images/i_delete_over.gif',1)"><img name="i_delete<%=idx %>" 
							                 		src="images/i_delete.gif" width="25" height="25" border="0" align="textmiddle" 
							                 		onclick="event.cancelBubble=true;delete_doctype('<%=strDocTypeName %>','<%=strDocType %>')" title="<%=lb_tooltip_delete %>"></a></label><label id="copy_<%=strDocType %>" 
							                 		style="height: 20px;display:none;cursor: pointer;padding-right: 3px;"><a href="#" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('i_cut<%=idx %>','','images/i_cut_over.gif',1)"><img name="i_cut<%=idx %>" 
							                 		src="images/i_cut.gif" width="25" height="25" border="0" align="textmiddle" 
							                 		onclick="event.cancelBubble=true;copyBlobPict('<%=strDocType %>')" title="<%=lb_tooltip_cut %>"></a></label><label id="paste_<%=strDocType %>" 
							                 		style="height: 20px;display:inline;cursor: pointer;padding-right: 3px;"><a href="#" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('i_paste<%=idx %>','','images/i_paste_over.gif',1)"><img name="i_paste<%=idx %>" 
							                 		src="images/i_paste.gif" width="25" height="25" border="0" align="textmiddle" 
							                 		onclick="event.cancelBubble=true;pasteBlobPict('<%=strDocType %>')" title="<%=lb_tooltip_paste %>"></a></label><label id="version_<%=strDocType %>" 
							                 		style="height: 20px;display:inline;cursor: pointer;padding-right: 3px;"><a href="#" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('i_version<%=idx %>','','images/i_version_over.gif',1)"><img name="i_version<%=idx %>" 
							                 		src="images/i_version.gif" width="25" height="25" border="0" align="textmiddle" 
							                 		onclick="event.cancelBubble=true;openVersion( '<%=strDocType %>', <%=strScanNo %>, '<%=strUserLevelTmp %>' )" title="<%=lb_version_doc %>"></a></label>
					                 	</div>
									</td>
								</tr>
								<tr>
			            			<td style="padding-top: 10px;padding-bottom: 10px">
						            	<div id="div_doc_type<%=idx %>" name="div_doc_type<%=idx %>" style="display:none">
							            	<div align="center">
									  			<div class="roundcont" ><div class="roundtop"> 
									            <div align="left">
									            	<img src="images/tl.gif" width="6" height="6" class="corner" style="display: none" /> </div>
									            </div>
									            <div style="display: none">
									                <table width="97%" border="0" align="center" cellpadding="0" cellspacing="0" class="label_bold2">
									                  	<tr> 
										                    <td width="25%"><%=lb_level_doc %><img src="images/mark.gif" width=12 height=11></td>
										                    <td colspan="3">
										                    	<input name="DOCUMENT_LEVEL<%=strDocType %>" type="text" class="input_box_disable" value="<%=strUserLevelTmp %>" size="8" maxlength="6" readonly /> 
									                      	</td>
									                  	</tr>
									                  	<%
									                  	
									                  		String 	strRdoSelected1 = "";
									                  		String 	strRdoSelected2 = "checked";
									                  	//	String 	strRdoValue 	= "";
									                  		String	strClassStyle	= "class=\"input_box_disable\" readonly";
									                  		
									                  		if(strNewVersion.equals("Y")){
									                  			strRdoSelected1 = "checked";
									                  			strRdoSelected2 = "";
									                  			strClassStyle	= "class=\"input_box\" ";
									                  		//	strRdoValue		= "Y";
									                  		}else{
									                  			strRdoSelected1 = "";
									                  			strRdoSelected2 = "checked";
									                  			strClassStyle	= "class=\"input_box_disable\" readonly";
									                  		//	strRdoValue		= "N";
									                  		}
									                  	%>
									                  	<tr> 
										                    <td><a href="javascript:openVersion( '<%=strDocType %>', <%=strScanNo %>, '<%=strUserLevelTmp %>' )"><span style="text-decoration:underline;font-weight:bold;"><%=lb_version_doc %></span></a> <img src="images/mark.gif" width=12 height=11></td>
										                    <td width="39%">
										                    	<input type="radio" name="rdoCheckVersion<%=strDocType %>" <%=strRdoSelected1 %> onclick="change_version('VERSION_LIMIT<%=strDocType %>','1','<%=strDocType %>')">
										                      	<%=lb_keep_old_version %> <%=lb_add_version %></td>
										                    <td width="8%"><input id="VERSION_LIMIT<%=strDocType %>" name="VERSION_LIMIT<%=strDocType %>" type="text" <%=strClassStyle %> value="<%=strVersionLimit %>" size="3" maxlength="2" style="text-align:right" onkeypress="keypress_number(this)"></td>
										                    <td width="32%" class="mark">
										                    	<table width="100%" border="0" cellpadding="0" cellspacing="0" class="mark">
											                        <tr>
											                          <td><div align="center"><%=lb_blank_all_ver %></div></td>
											                        </tr>
										                      	</table>
									                      	</td>
										                </tr>
									                 	<tr> 
										                    <td>&nbsp;</td>
										                    <td colspan="3">
										                    	<input type="radio" name="rdoCheckVersion<%=strDocType%>" <%=strRdoSelected2 %> onclick="change_version('VERSION_LIMIT<%=strDocType %>','2','<%=strDocType %>')">
										                      	<%=lb_not_keep_old_version %>
										                      	<input type="hidden" name="NEW_VERSION<%=strDocType%>" value="<%=strNewVersion %>"> 
									                      	</td>
										                </tr>
										             </table>
										         </div>   
									             <table width="97%" border="0" align="center" cellpadding="0" cellspacing="0" class="label_bold2">   
									                <tr> 
                                                                                            <td><%=lb_doc_attach %> <img src="images/mark.gif" width=12 height=11></td>
                                                                                            <td> 
									                    	<input name="BLOB_ID<%=strDocType %>" type="text" class="input_box_disable" value="<%=strBlobData %>" size="40" readonly />
								                    		&nbsp;<%=lb_attach_count %>
									                    	<input name="BLOB_PART<%=strDocType %>" type="text" class="input_box_disable" value="<%=strPictData %>" size="5" style="text-align: right" readonly />
									                    	<input name="PICT_INIT<%=strDocType %>" type="hidden" value="<%=strBlobData %>"> 
									                    </td>
									                </tr>
									                <tr> 
									                    <td><%=lb_file_type %></td>
									                    <td> 
									                    	<input name="FILE_TYPE<%=strDocType %>" type="text" class="input_box_disable" value="<%=strFileTypeData %>" size="10" readonly />
                                                                                                <% if(!strFileType.equals("")){ %>
                                                                                                    <img src="images/notice.jpg" title="<%=strFileType %>" align="absmiddle">
                                                                                                <% } %>
									                    	<input name="FILE_TYPE_FILTER<%=strDocType %>" type="hidden" value="<%=strFileType %>" />
									                    	<input name="FILE_TYPE_FLAG<%=strDocType %>" type="hidden" value="<%=strFileTypeFlag %>" />
									                    	<input name="FILE_SIZE_FILTER<%=strDocType %>" type="hidden" value="<%=strFileSize %>" />
									                    	<input name="FILE_SIZE_FLAG<%=strDocType %>" type="hidden" value="<%=strFileSizeFlag %>" />
									                    </td>
									                </tr>
<!--									                <tr style="display: inline"> -->
									                <tr> 
									                    <td><%=lb_file_name %></td>
									                    <td> 
									                    	<input name="FILE_NAME<%=strDocType %>" type="text" class="input_box_disable" value="<%=strFileNameData %>" size="59" readonly />
									                    </td>
									                </tr>
						                		</table>
						                		<br>
								                <div class="roundbottom">
												<div align="left">
													<img src="images/bl.gif" width="6" height="6" class="corner" style="display: none" /> </div>
								                </div>
												</div>	
											</div>
					            			<input type="hidden" name="DOCUMENT_TYPE<%=strDocType %>" value="<%=strDocType %>">
										   	<input type="hidden" name="USED_SIZE_ARG<%=strDocType %>" value="<%=strPictSize %>">
										   	<input type="hidden" name="SCAN_NO<%=strDocType %>" 	  value="<%=strScanNo %>">
										   	<input type="hidden" name="XML_TAG<%=strDocType %>" 	  value="">
										   	<input type="hidden" name="BLOB_FLAG<%=strDocType %>" 	  value="N">
										   	<input type="hidden" name="DOCTYPE_CODE<%=idx%>"  value="<%=strDocType %>">
										   	<input type="hidden" name="CONTENT<%=strDocType%>"  value="<!--%=strContentData %-->">
				           				</div>
			           				</td>
		           				</tr>
           					</table>
<script type="text/javascript">
<!--
   
	if(form1.BLOB_ID<%=strDocType %>.value== ""){
		clear_<%=strDocType %>.style.display = "none";
		paste_<%=strDocType %>.style.display = "inline";
		copy_<%=strDocType %>.style.display  = "none";
	}else{
		clear_<%=strDocType %>.style.display = "inline";
		paste_<%=strDocType %>.style.display = "none";
		copy_<%=strDocType %>.style.display  = "inline";
		PICT_CNT<%=strDocType %>.innerHTML   = "(<%=strPictData%>)";
		form1.hidHadAttach.value             = "YES";
	}
	
<%	

	if(strNewVersion.equals("N")){
%>
	version_<%=strDocType %>.style.display  = "none";
<%
	}

	if(strAccessType.equals("L")){
		if(Integer.parseInt(strUserLevel) >= Integer.parseInt(strUserLevelTmp)){ 
%>
			doc_row<%=idx %>.style.display = "block";
<%		} 
	}else 	if(strAccessType.equals("U")){
		if(strPermitUsers.indexOf(strUserId) != -1){ 
%>
			doc_row<%=idx %>.style.display = "block";
<%		} 
	}else{
%>
			doc_row<%=idx %>.style.display = "block";
<%	} 
%>
	
//-->
</script>           					
            			</td></tr>
<%					idx++;
				}	
%>
						<input type="hidden" name="TOTAL_DOCUMENT" value="<%=idx-1%>">
<%				
			}
%>            		
            			</table>
                            </td>
        		</tr>
      		</table>
   		</td>
  	</tr>
</table>
<input type="hidden" name="screenname"   value="<%=screenname%>">
<input type="hidden" name="user_role"    value="<%=user_role%>">
<input type="hidden" name="app_group"    value="<%=app_group%>">
<input type="hidden" name="app_name"     value="<%=app_name%>">
<input type="hidden" name="project_flag" value="<%=strProjectFlag%>">

<input type="hidden" id="hidDocTypeMove"  name="hidDocTypeMove"  value="" >
<input type="hidden" id="hidBlobMove"     name="hidBlobMove"     value="" >
<input type="hidden" id="hidPictMove"     name="hidPictMove"     value="" >
<input type="hidden" id="hidFileTypeMove" name="hidFileTypeMove" value="" >
<input type="hidden" id="hidFileNameMove" name="hidFileNameMove" value="" >
<input type="hidden" id="hidBlobSizeMove" name="hidBlobSizeMove" value="" >
<input type="hidden" id="hidPictInitMove" name="hidPictInitMove" value="" >
<input type="hidden" id="hidBlobFlagMove" name="hidBlobFlagMove" value="" >

<input type="hidden" name="METHOD" 	   	value="<%=strMethod%>">
<input type="hidden" name="METHOD2" 	value="">
<input type="hidden" name="OLD_METHOD" 	value="<%=strOldMethod%>">

<input type="hidden" name="PERMIT_FUNCTION" value="<%=strPermission%>">

<input type="hidden" name="TEXT_INDEX">
<input type="hidden" name="DOCUMENT_SET_FIELD">

<input type="hidden" name="CONCAT_DOCUMENT_TYPE">
<input type="hidden" name="CONCAT_DOCUMENT_LEVEL">
<input type="hidden" name="CONCAT_VERSION_LIMIT">
<input type="hidden" name="CONCAT_NEW_VERSION">
<input type="hidden" name="CONCAT_BLOBID">
<input type="hidden" name="CONCAT_BLOBPART">
<input type="hidden" name="CONCAT_USED_SIZE_ARG">
<input type="hidden" name="CONCAT_SCAN_NO">
<input type="hidden" name="CONCAT_XML_TAG">
<input type="hidden" name="CONCAT_BLOB_FLAG">
<input type="hidden" name="CONCAT_FILE_TYPE">
<input type="hidden" name="CONCAT_FILE_NAME">
<input type="hidden" name="CONCAT_CONTENT">

<input type="hidden" name="DOCUMENT_FIELD_INSERT">
<input type="hidden" name="DOCUMENT_VALUE_INSERT">
<input type="hidden" name="DOCUMENT_VALUE_DUPLICATE">

<input type="hidden" name="CURRENT_DOC">
<input type="hidden" name="CONTAINER_TYPE" value="<%=strConTainerType%>">

<input type="hidden" name="DOCUMENT_NO" 		value="<%=strDocumentNo %>"/>
<input type="hidden" name="BATCH_NO" 			value="<%=strBatchNo %>"/>
<input type="hidden" name="DOCUMENT_RUNNING" 	value="<%=strDocumentRunning %>" />

<input type="hidden" name="DOCUMENT_TYPE_DELETE" value="">
<input type="hidden" name="CHECK_STATUS" value="<%=strCheckStatus %>">

<input type="hidden" name="PAGE_SIZE" value="<%=strPageSize%>">
<input type="hidden" name="PAGENUMBER" value="<%=strPageNumber%>">
<input type="hidden" name="TOTALPAGE"  value="<%=strTotalPage%>">

<input type="hidden" name="ORDER_TYPE" 		value="<%=strOrderType %>">
<input type="hidden" name="SEARCH_DISPLAY" 	value="<%=strSearchDisPlay %>">
<input type="hidden" name="COUNT_RECORD" 	value="<%=strCountRecord %>">

<input type="hidden" name="DOCUMENT_DATA_VALUE" 	value="<%=strDocumentDataValue %>">
<input type="hidden" name="DOCUMENT_FIELD_VALUE" 	value="<%=strDocumentFieldValue %>">
<input type="hidden" name="DOCUMENT_DESC" 			value="<%=strDocumentDesc %>">
<input type="hidden" name="SEARCH_DESC" 			value="<%=strSearchDesc %>">

<input type="hidden" name="SORT_FIELD" 	value="<%=strSortField%>">
<input type="hidden" name="ORDER_BY" 	value="<%=strOrderBy%>">

<input type="hidden" id="ACTION" name="ACTION" value="">

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
<input type="hidden" name="SEARCH_OPERATOR"	value="<%=strSearchOperator %>">
<input type="hidden" name="SEARCH_CONDITION"	value="<%=strSearchCondition %>">

<input type="hidden" name="CONCAT_DOCTYPE_DELETE" value="">

</form>
<form name="formLog">
  <input type="hidden" name="PROJECT_CODE">
  <input type="hidden" name="BATCH_NO">
  <input type="hidden" name="DOCUMENT_RUNNING">
  <input type="hidden" name="ACTION_FLAG">
</form>      
<form name="formEdit" action="edit_document2.jsp" method="post">
	
	<input type="hidden" name="screenname"   value="<%=screenname%>">
	<input type="hidden" name="user_role"    value="<%=user_role%>">
	<input type="hidden" name="app_group"    value="<%=app_group%>">
	<input type="hidden" name="app_name"     value="<%=app_name%>">
	<input type="hidden" name="project_flag" value="<%=strProjectFlag%>">

	<input type="hidden" name="METHOD" 	   value="<%=strMethod%>">
	
	<input type="hidden" name="PAGE_SIZE" value="<%=strPageSize%>">
	<input type="hidden" name="PAGENUMBER" value="<%=strPageNumber%>">
	<input type="hidden" name="TOTALPAGE"  value="<%=strTotalPage%>">
	
	<input type="hidden" name="ORDER_TYPE" 		value="<%=strOrderType %>">
	<input type="hidden" name="SEARCH_DISPLAY" 	value="<%=strSearchDisPlay %>">
	<input type="hidden" name="COUNT_RECORD" 	value="<%=strCountRecord %>">
	
	<input type="hidden" name="DOCUMENT_DATA_VALUE" 	value="<%=strDocumentDataValue %>">
	<input type="hidden" name="DOCUMENT_FIELD_VALUE" 	value="<%=strDocumentFieldValue %>">
	<input type="hidden" name="DOCUMENT_DESC" 			value="<%=strDocumentDesc %>">
	<input type="hidden" name="SEARCH_DESC" 			value="<%=strSearchDesc %>">
	
	<input type="hidden" name="SORT_FIELD" 	value="<%=strSortField%>">
	<input type="hidden" name="ORDER_BY" 	value="<%=strOrderBy%>">

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
<form name="formOffline">
  <input type="hidden" name="BATCH_NO">
  <input type="hidden" name="DOCUMENT_RUNNING">
  <input type="hidden" name="MEDIA_LABEL">
</form>
<iframe name="frameLog"  style="display:none"></iframe>
<iframe name="frameOffline" style="display:none"></iframe>
<iframe scrolling="no" frameborder="0" name="inetdocview" src="/jinetdocarchive/imageproxy?codetype=applet&version=15&securecode=<%=securecode%>" width="32" height="32" marginwidth="0">
</iframe>
</body>
</html>
<%
strXML += "</Fields>";

%>
<script language="JavaScript">
var strXml = '<%=strXML%>';
var strXmlTemplate = "";
</script>