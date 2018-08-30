<%@page import="com.scc.edms.conf.ImageConfUtil"%>
<%@ page contentType="text/html; charset=tis-620"%>
<%@ page import="com.scc.security.UserInfo"%>
<%@ include file="inc/checkUser.jsp" %>
<%@ include file="inc/constant.jsp" %>
<%@ include file="inc/label.jsp" %>
<%@ include file="inc/utils.jsp" %>
<jsp:useBean id="conLog" scope="session" class="edms.cllib.EABConnector"/>
<jsp:useBean id="conDoc" scope="session" class="edms.cllib.EABConnector"/>
<%

	conLog.setRemoteServer("EAS_SERVER");
	conDoc.setRemoteServer("EAS_SERVER");
	
	UserInfo userInfo = (UserInfo)session.getAttribute( "USER_INFO" );
	String strUserId        	= userInfo.getUserId();
	String strProjectCodeInfo 	= userInfo.getProjectCode(); //00000007
	
	String	strBatchNo			= checkNull( request.getParameter( "BATCH_NO" ) );
    String	strDocumentRunning	= checkNull( request.getParameter( "DOCUMENT_RUNNING" ) );
    String	strCheckFlag		= checkNull( request.getParameter( "ACTION_FLAG" ) );
    String	strProjectCodeMove	= checkNull( request.getParameter( "PROJECT_CODE" ) ); //00000002
    
    String	strProjectCode = "";
    
    if(!strProjectCodeMove.equals("")){
    	strProjectCode = strProjectCodeMove;
    }else{
    	strProjectCode = strProjectCodeInfo;
    }
    
out.println("strProjectCode : " + strProjectCode);	
out.println("strBatchNo : " + strBatchNo);	
out.println("strDocumentRunning : " + strDocumentRunning);
out.println("strCheckFlag : " + strCheckFlag);
    
	String 	strClassName 	 = "MASTER_LOG";
	String 	strErrorMessage	 = "";
	String	strCurrentDate	 = "";
	
	String	strSQLHeader 	= "";
	String	strSQLJoinTable = "";
	String	strFieldType 	= "";
	String	strFieldCode 	= "";
	String	strFieldName	= "";
	String	strTableZoom	= "";
	String	strTableName    = "";
	
	String	strDataValue	= "";
	String	strDataTemp 	= "";
	String 	strDocypeValue  = "";
	
	String 	strConcatFieldName	= "";
	String 	strConcatFieldIndex = "";
	String 	strConcatFieldType	= "";
        String strVersionLang  = ImageConfUtil.getVersionLang();
	
	String	arrFieldName[]	= null;
	String	arrFieldIndex[]	= null;
	String	arrFieldType[]	= null;
	
	boolean bolSuccessField   = false;
	boolean	bolSuccesccValue  = false;
	boolean bolnInsertSuccess = false;
		
	

        if( strVersionLang.equals("thai") ) {
		strCurrentDate = getTodayDateThai();
	}else{
		strCurrentDate = getTodayDate();
	}
	
	conLog.addData("PROJECT_CODE", "String", strProjectCode);
	conLog.addData("INDEX_TYPE", 	"String", "G");
    
    bolSuccessField = conLog.executeService(strContainerName, strClassName, "findFieldIndex");
    if(!bolSuccessField){
		strErrorMessage = conLog.getRemoteErrorMesage();
    }else{
    	int cnt = 0;
    	while(conLog.nextRecordElement()){
    		strFieldName  = conLog.getColumn("FIELD_LABEL");
    		strFieldCode  = conLog.getColumn("FIELD_CODE");
    		strFieldType  = conLog.getColumn("FIELD_TYPE");    		
    		strTableZoom  = conLog.getColumn("TABLE_ZOOM");
    		strTableName  = conLog.getColumn("TABLE_NAME");
    		
    		
    		strConcatFieldType  += strFieldType  + ",";
  		
    		if(strFieldType.equals("ZOOM")||strFieldType.equals("LIST")||strFieldType.equals("MONTH")||strFieldType.equals("MONTH_ENG")){
    			strSQLHeader 	+= 	",T" + cnt + "." + strTableZoom + "_NAME";
    			strSQLJoinTable += 	" LEFT JOIN " + strTableZoom + " T" + cnt
    							+ 	" ON(MASTER_SCAN_" + strProjectCode + "." + strFieldCode + "=" 
    							+ 	"T" + cnt + "." + strTableZoom + " )";
    			
    			strConcatFieldName  += strTableName + ",";
    			strConcatFieldIndex += strTableZoom + "_NAME,";
    			
    			cnt++;
    			
    		}else{
    			strConcatFieldName  += strFieldName + ",";
    			strConcatFieldIndex += strFieldCode  + ",";
    		}
    	}
    	
    	if(strConcatFieldName.length() > 0){
        	strConcatFieldName = strConcatFieldName.substring(0,strConcatFieldName.length() - 1);
    		arrFieldName = strConcatFieldName.split(",");
    	}
    	if(strConcatFieldIndex.length() > 0){
    		strConcatFieldIndex = strConcatFieldIndex.substring(0,strConcatFieldIndex.length() - 1);
    		arrFieldIndex = strConcatFieldIndex.split(",");
    	}
    	if(strConcatFieldType.length() > 0){
    		strConcatFieldType = strConcatFieldType.substring(0,strConcatFieldType.length() - 1);
    		arrFieldType = strConcatFieldType.split(",");
    	}
    		
    	conLog.addData("PROJECT_CODE", 	"String", strProjectCode);
    	conLog.addData("QUERY_HEADER", 	"String", strSQLHeader);
    	conLog.addData("JOIN_TABLE", 	"String", strSQLJoinTable);
    	conLog.addData("BATCH_NO", 		"String", strBatchNo );
    	conLog.addData("DOCUMENT_RUNNING", "String", strDocumentRunning );
        
        bolSuccesccValue = conLog.executeService(strContainerName, strClassName, "findFieldValue");
        if(!bolSuccesccValue){
    		strErrorMessage = conLog.getRemoteErrorMesage();
    		
    		out.println("findFieldValue :: strErrorMessage :"  + strErrorMessage);
        }else{
        	
        	strDataValue = "";
        	strDataTemp  = "";
        	
        	for(int idx=0; idx<arrFieldIndex.length; idx++ ){
    			
    			if(arrFieldType[idx].equals("DATE")||arrFieldType[idx].equals("DATE_ENG")){
    				strDataTemp = dateToDisplay(conLog.getHeader(arrFieldIndex[idx]),"/");									
    			}else{
    				strDataTemp = conLog.getHeader(arrFieldIndex[idx]);
    			}
    		
    			strDataValue += "[" + arrFieldName[idx]+ "]" + strDataTemp + "|";
    		}
        	
        	if(strDataValue.length() > 0){
        		strDataValue = strDataValue.substring(0,strDataValue.length() - 1);
        	}
        	
        	//***************** document_type *******//
        	
        	conLog.addData( "PROJECT_CODE" , "String" , strProjectCode );
			boolean	bolnSuccessDocType = conLog.executeService( strContainerName , "DOCUMENT_TYPE" , "findDocumentType" );
			if(bolnSuccessDocType){
				
				String strBlobData    = "";
				String strPictData    = "";
				String strDocTypeName = "";
				String strDocType     = "";
			
				while(conLog.nextRecordElement()){
				
					strDocTypeName 	= conLog.getColumn("DOCUMENT_TYPE_NAME");
					strDocType 		= conLog.getColumn("DOCUMENT_TYPE");
					
					conDoc.addData("PROJECT_CODE", 		"String", strProjectCode);
	    			conDoc.addData("BATCH_NO", 			"String", strBatchNo);
	    			conDoc.addData("DOCUMENT_RUNNING", 	"String", strDocumentRunning);
	    			conDoc.addData("DOCUMENT_TYPE", 	"String", strDocType);
	    			boolean bolSuccessDocLevel = conDoc.executeService(strContainerName, "EDIT_DOCUMENT", "findDocumentLevel");
	    			if(bolSuccessDocLevel){
	    				strBlobData 	= conDoc.getHeader("BLOB");
	    				strPictData 	= conDoc.getHeader("PICT");
	    				
	    				strDocypeValue += "|[" + strDocType + "]" + strBlobData + " " + strPictData;
	    			}else{
	    				strDocypeValue += "";    				
	    				
	    			}
				}
			}
        }
   	}
			
        	
	conLog.addData("PROJECT_CODE", 	"String", strProjectCodeInfo );
	conLog.addData("USER_ID", 		"String", strUserId );
	conLog.addData("KEYFIELD", 		"String", strDataValue + strDocypeValue );
	conLog.addData("CURRENT_DATE", 	"String", strCurrentDate );
	conLog.addData("ACTION_FLAG", 	"String", strCheckFlag );
	conLog.addData("BATCH_NO", 		"String", strBatchNo );
	conLog.addData("DOCUMENT_RUNNING", "String", strDocumentRunning );
	
	bolnInsertSuccess = conLog.executeService(strContainerName, strClassName, "insertMasterLog");
	if(!bolnInsertSuccess){
		strErrorMessage = conLog.getRemoteErrorMesage();
		out.println("insertMasterLog :: strErrorMessage :"  + strErrorMessage);
	}
    
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title><%=lc_system_name %> <%=lc_site_name%></title>
<meta http-equiv="Content-Type" content="text/html; charset=tis-620">
<script language="JavaScript" src="js/sccUtils.js"></script>
<script language="JavaScript" src="js/util.js"></script>
<script language="JavaScript" src="js/constant.js"></script>
<script language="JavaScript" src="js/label.js"></script>
<script language="javascript" type="text/javascript">
<!--

//-->
</script>
</head>
<body>
<form name="form1" action="" method="post">

</form>
</body>
</html>
