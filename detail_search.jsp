<%@page import="com.scc.edms.conf.ImageConfUtil"%>
<%@ page contentType="text/html; charset=tis-620"%>
<%@ page import="com.scc.security.UserInfo"%>
<%@ include file="inc/checkUser.jsp" %>
<%@ include file="inc/constant.jsp" %>
<%@ include file="inc/label.jsp" %>
<%@ include file="inc/utils.jsp" %>
<jsp:useBean id="con" scope="session" class="edms.cllib.EABConnector"/>
<jsp:useBean id="conCode" scope="session" class="edms.cllib.EABConnector"/>
<jsp:useBean id="conDoc" scope="session" class="edms.cllib.EABConnector"/>
<jsp:useBean id="conVS" scope="session" class="edms.cllib.EABConnector"/>
<jsp:useBean id="conDetail" scope="session" class="edms.cllib.EABConnector"/>
<%
    String securecode = "";
    con.setRemoteServer("EAS_SERVER");
    conCode.setRemoteServer("EAS_SERVER");
	conDoc.setRemoteServer("EAS_SERVER");
	conVS.setRemoteServer("EAS_SERVER");
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
	String strUserOrgName   = userInfo.getUserOrgName();
	String strUserLevel     = userInfo.getUserLevel();
	String strUserEmail 	= checkNull(session.getAttribute("USER_EMAIL"));
			
        String	strProjectCode      = checkNull( request.getParameter( "PROJECT_CODE" ) );
        String	strProjectName      = getField( request.getParameter( "PROJECT_NAME" ) );
        String	strBatchNo          = checkNull( request.getParameter( "BATCH_NO" ) );
        String	strDocumentRunning  = checkNull( request.getParameter( "DOCUMENT_RUNNING" ) );
        String	strDocumentName     = getField( request.getParameter( "DOCUMENT_NAME" ) );
        String	strDocumentUser     = getField( request.getParameter( "DOCUMENT_USER" ) );
        
        String user_role      = getField(request.getParameter("user_role"));
	String app_name       = getField(request.getParameter("app_name"));
	String app_group      = getField(request.getParameter("app_group"));

        String strAccessDocTypeData = (String)session.getAttribute( "ACCESS_DOC_TYPE" );
        String strUserGroup         = (String)session.getAttribute( "USER_GROUP" );
        String strSecurityFlag      = (String)session.getAttribute( "SECURITY_FLAG" );
        String strAndDocTypeCon     = "";

        String 	strClassName 	 = "EDIT_DOCUMENT";
        String 	strErrorMessage	 = "";
        String 	strPermission	 = "";

        String	strAddUserId 	  = "";
        String	strEditUserId 	  = "";
        String	strAddUserName 	  = "";
        String	strEditUserName   = "";
        String	strAddDate        = "";
        String	strEditDate 	  = "";
        String	strBoxNo 	  = "";
        String	strCheckStatus    = "";
        String	strCheckOutUser   = "";
        String  strDocumentLevel  = "";
        String	strLevelName	  = "";
        String  strExpireDate 	  = "";
        String  strStorehouseName = "";
        String	strCurrentDate    = "";
        String	strWaterMarkFlag  = "";
        String  strDocUserName    = "";
        String  strDocUserSname   = "";
        String  strDocUserTitle   = "";
        String  strDocUserFullName = "";

        String	strFieldCode 	= "";
        String	strFieldTyp 	= "";
        String	strTableZoom 	= "";
        String	strSQLHeader 	= "";	
        String	strSQLJoinTable = "";

        String 	strDataLabel[] 		= {};
        String 	strDataName[] 		= {};
        String 	strDataType[] 		= {};
        String 	strDataTableZoom[] 	= {};
        String 	strDataValue[] 		= {};

        String	strConTainerType = ImageConfUtil.getInetContainerType();
        String  strVersionLang   = ImageConfUtil.getVersionLang();
    
        if(strVersionLang.equals("thai")){
		strCurrentDate = getTodayDateThai();
	}else{
		strCurrentDate = getTodayDate();
	}
	
	boolean bolSuccess;
	boolean bolnFieldSuccess  = true;
	boolean bolnWaterMarkSuccess = false;
	boolean bolnDetailSuccess = false;
	
	con.addData("PROJECT_CODE", "String", strProjectCode);
	bolnWaterMarkSuccess = con.executeService(strContainerName, "PROJECT_MANAGER", "findWaterMarkFlag");
	if(bolnWaterMarkSuccess){
		strWaterMarkFlag = con.getHeader("WATERMARK_FLAG");
	}else{
		strWaterMarkFlag = "N";
	}
        
    con.addData("USER_ROLE", 	     "String", user_role);
    con.addData("APPLICATION", 	     "String", app_name);
    con.addData("APPLICATION_GROUP", "String", app_group);
    bolSuccess = con.executeService(strContainerName, "DOCUMENT_TYPE", "findPermission");
    if(bolSuccess) {
        strPermission = con.getHeader("PERMIT_FUNCTION");
    }    
	
	con.addData( "PROJECT_CODE" , "String" , strProjectCode );

	bolnFieldSuccess = con.executeService(strContainerName, "IMPORTDATA", "findFieldDocument");

    if( !bolnFieldSuccess ){
		
	}else{
		int intTotalField = con.getRecordTotal();
		int intCountField = 0;

		strDataLabel 	  = new String[ intTotalField ];
		strDataType 	  = new String[ intTotalField ];
		strDataName 	  = new String[ intTotalField ];
		strDataTableZoom  = new String[ intTotalField ];
		strDataValue 	  = new String[ intTotalField ];
		
		

		while( con.nextRecordElement() ){
			strDataLabel[ intCountField ] 		= con.getColumn( "FIELD_LABEL" );
			strDataName[ intCountField ] 		= con.getColumn( "FIELD_CODE" );
			strDataType[ intCountField ] 		= con.getColumn( "FIELD_TYPE" );
			strDataTableZoom[ intCountField ] 	= con.getColumn( "TABLE_ZOOM" );

			
			intCountField++;
		}
	}
	
	con.addData("PROJECT_CODE", "String", strProjectCode);
	con.addData("INDEX_TYPE",   "String", "R");
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
    		//	strSQLHeader 	+= 	"," + strTableZoom + "." + strTableZoom + "_NAME";
    			strSQLHeader 	+= 	",T" + cnt + "." + strTableZoom + "_NAME";
    		//	strSQLJoinTable += 	" LEFT JOIN " + strTableZoom 
    			strSQLJoinTable += 	" LEFT JOIN " + strTableZoom + " T" + cnt
    							+ 	" ON(MASTER_SCAN_" + strProjectCode + "." + strFieldCode + "=" 
							//	+ 	strTableZoom + "." + strTableZoom + " )";
    							+ 	"T" + cnt + "." + strTableZoom + " )";
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
    	
        strDocumentLevel = con.getHeader("DOCUMENT_LEVEL");
        strLevelName	 = con.getHeader("LEVEL_NAME");
        strAddUserId 	 = con.getHeader("ADD_USER");
        strEditUserId 	 = con.getHeader("EDIT_USER");
        strAddDate       = con.getHeader("ADD_DATE");
        strEditDate 	 = con.getHeader("EDIT_DATE");
        strExpireDate 	 = con.getHeader("EXPIRE_DATE");
        strCheckStatus 	 = con.getHeader("CHECK_STATUS");
        strCheckOutUser	 = con.getHeader("CHECKOUT_USER");	
        strStorehouseName = con.getHeader("STOREHOUSE_NAME");

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
        	strAddUserName = "-";
        }
    }
    
    if(!strEditUserId.equals("")){
    	con.addData("USER_ID", "String", strEditUserId);
        
        bolSuccess = con.executeService(strContainerName, "USER_PROFILE", "findUserById");
        if(bolSuccess) {
        	strEditUserName = con.getHeader("USER_NAME") + " " + con.getHeader("USER_SNAME");
        }else {
        	strEditUserName = "-";
        }
    }
    
    if(!strCheckOutUser.equals("")){
    	con.addData("USER_ID", "String", strCheckOutUser);
        
        bolSuccess = con.executeService(strContainerName, "USER_PROFILE", "findUserById");
        if(bolSuccess) {
        	strCheckOutUser = con.getHeader("USER_NAME") + " " + con.getHeader("USER_SNAME");
        }else {
        	strCheckOutUser = "-";
        }
    }
    
    con.addData("PROJECT_CODE", 	"String", strProjectCode);
    con.addData("BATCH_NO", 		"String", strBatchNo);
    con.addData("DOCUMENT_RUNNING", "String", strDocumentRunning);
    bolSuccess = con.executeService(strContainerName, "BOX_MANAGE", "findBoxDesc");
    if(bolSuccess) {
    	strBoxNo = con.getHeader("BOX_NO");
    }else {
    	strBoxNo = "";
    }
    if( !strDocumentUser.equals("") ) {
   		conDetail.addData( "USER_ID", strDocumentUser );
   		bolnDetailSuccess = conDetail.executeService( strContainerName, strClassName, "findDocumentUserDetail" );
   		if( bolnDetailSuccess ) {
   			strDocUserName  = conDetail.getHeader( "USER_NAME" );
   			strDocUserSname = conDetail.getHeader( "USER_SNAME" );
   			strDocUserTitle = conDetail.getHeader( "TITLE_NAME" );
   			strDocUserFullName = strDocUserTitle + strDocUserName + " " + strDocUserSname;
   		}else {
   			strDocUserFullName = "-";
   		}
	}
	
    if(!strExpireDate.equals("-")&&!strExpireDate.equals("")) {
    	strExpireDate  = dateToDisplay(strExpireDate, "/");    	
    }else{strExpireDate = "-";}
    
    if(!strEditDate.equals("")) {
    	strEditDate = dateToDisplay(strEditDate, "/");    	
    }else{strEditDate = "-";}
    
    if(!strAddDate.equals("")) {
    	strAddDate  = dateToDisplay(strAddDate, "/");    	
    }
    
    if(strBoxNo.equals("")) {
    	strBoxNo  = "-";    	
    }
    
    if( strDocumentName.equals("") ) {
    	strDocumentName = "-";
    }
    
    if(strStorehouseName.equals("")) {
    	strStorehouseName  = "-";    	
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

var offUtils = new offlineUtils();
var waterMk  = new waterMark();

var strActiveBlobSeq;
var strActiveDocumentType;

var objZoomWindow;
var objVersionWindow;

function click_cancel(){
	window.close();
}	

function init_form(){
	set_JSP_value();

	/*if( top.topFrame ){
		top.topFrame.closeProgress();
	}*/
}

function set_JSP_value(){
<%
    for( int intField = 0 ; intField < strDataName.length ; intField++ ){

        if( strDataValue[ intField ].indexOf( "\n" ) != -1 ){
                strDataValue[ intField ] = strDataValue[ intField ].replaceAll( "\r\n" , "\\\\n" );
        }
        if( strDataValue[ intField ].indexOf( "\"" ) != -1 ){
                strDataValue[ intField ] = strDataValue[ intField ].replaceAll( "\"" , "\\\\\"" );
        }

        if(strDataType[ intField ].equals("CURRENCY") && strDataValue[ intField ].length() > 0){
                strDataValue[ intField ] = setComma(strDataValue[ intField ]);
        }

        if(strDataType[ intField ].equals("MEMO")){
                if(strDataValue[ intField ].indexOf("<t>") != -1){
                        strDataValue[ intField ] = strDataValue[ intField ].replaceAll( "<t><t>" , "&nbsp;" );
                        strDataValue[ intField ] = strDataValue[ intField ].replaceAll( "<t>" , " " );
                }
                if(strDataValue[ intField ].indexOf("<n>") != -1){
                        strDataValue[ intField ] = strDataValue[ intField ].replaceAll( "<n>" , "<br>" );
                }
        }

        if( (strDataType[ intField ].equals("DATE")||strDataType[ intField ].equals("DATE_ENG")) && strDataValue[ intField ].length() > 0 ){
            if( strDataValue[ intField ].indexOf( "/" ) == -1 ){
                out.println(strDataName[ intField ] + ".innerHTML = new SCUtils().dateToDisplay(\"" + strDataValue[ intField ] + "\");\n" );
            }else{
                out.println(strDataName[ intField ] + ".innerHTML = \"" + strDataValue[ intField ] + "\";\n" );
            }
        }else if(strDataType[ intField ].equals("MONTH") && strDataValue[ intField ].length() > 0){

            conCode.addData("FIELD_CODE", "String", strDataValue[ intField ]);
            conCode.addData("TABLE_NAME", "String", strDataTableZoom[ intField ]);
            boolean bolSuccessCode = conCode.executeService(strContainerName, strClassName, "findFieldCode");
            if(bolSuccessCode){
                    strDataValue[ intField ] = conCode.getHeader(strDataTableZoom[ intField ] + "_NAME");
            } 
            out.println(strDataName[ intField ] + ".innerHTML = \"" + strDataValue[ intField ] + "\";\n" );

        }else if(strDataType[ intField ].equals("MONTH_ENG") && strDataValue[ intField ].length() > 0){

            conCode.addData("FIELD_CODE", "String", strDataValue[ intField ]);
            conCode.addData("TABLE_NAME", "String", strDataTableZoom[ intField ]);
            boolean bolSuccessCode = conCode.executeService(strContainerName, strClassName, "findFieldCode");
            if(bolSuccessCode){
                    strDataValue[ intField ] = conCode.getHeader(strDataTableZoom[ intField ] + "_NAME");
            } 
            out.println(strDataName[ intField ] + ".innerHTML = \"" + strDataValue[ intField ] + "\";\n" );

        }else if(strDataType[ intField ].equals("ZOOM") && strDataValue[ intField ].length() > 0){
            conCode.addData("FIELD_CODE", "String", strDataValue[ intField ]);
            conCode.addData("TABLE_NAME", "String", strDataTableZoom[ intField ]);
            boolean bolSuccessCode = conCode.executeService(strContainerName, strClassName, "findFieldCode");
            if(bolSuccessCode){
                    strDataValue[ intField ] = conCode.getHeader(strDataTableZoom[ intField ] + "_NAME");
            }
            out.println(strDataName[ intField ] + ".innerHTML = \"" + strDataValue[ intField ] + "\";\n" );

        }else if(strDataType[ intField ].equals("LIST") && strDataValue[ intField ].length() > 0){
            conCode.addData("FIELD_CODE", "String", strDataValue[ intField ]);
            conCode.addData("TABLE_NAME", "String", strDataTableZoom[ intField ]);
            boolean bolSuccessCode = conCode.executeService(strContainerName, strClassName, "findFieldCode");
            if(bolSuccessCode){
                    strDataValue[ intField ] = conCode.getHeader(strDataTableZoom[ intField ] + "_NAME");
            }                    
            out.println(strDataName[ intField ] + ".innerHTML = \"" + strDataValue[ intField ] + "\";\n" );

        }else if(strDataType[ intField ].equals("TIN") && strDataValue[ intField ].length() > 0){                   
            out.println(strDataName[ intField ] + ".innerHTML = new SCUtils().maskTIN(\"" + strDataValue[ intField ] + "\");\n" );

        }else if(strDataType[ intField ].equals("PIN") && strDataValue[ intField ].length() > 0){                    
            out.println(strDataName[ intField ] + ".innerHTML = new SCUtils().maskPIN(\"" + strDataValue[ intField ] + "\");\n" );

        }else{                    
            out.println(strDataName[ intField ] + ".innerHTML = \"" + strDataValue[ intField ] + "\";\n" );
        }
    
        if(strDataValue[ intField ].length() <= 0){
                out.println(strDataName[ intField ] + ".innerHTML = \"-\";\n" );
        }

    }                
%>
            
}

function window_onload(){
    document_level.innerHTML = lbl_document_level;
    document_name.innerHTML  = lbl_document_name;
    document_user.innerHTML  = lbl_document_user;
    add_user.innerHTML       = lbl_add_user;
    add_date.innerHTML       = lbl_add_date;
    upd_user.innerHTML       = lbl_upd_user;
    upd_date.innerHTML       = lbl_upd_date;
    expire_date.innerHTML    = lbl_expire_date;
    doc_status.innerHTML     = lbl_status;
    carbinet_no.innerHTML    = lbl_carbinet_no;
    storehouse.innerHTML     = lbl_doc_location;

	init_form();
//	check_inet_version();
	
<%
	if( !strErrorMessage.equals( "" ) ){
%>
	showMsg( 0 , 0 , "<%=strErrorMessage.replaceAll( "\"" , "'" ).replaceAll( "\r" , "" ).replaceAll( "\n" , "<br>" )%>" );

/*  Eas Error Message Section
<%=strErrorMessage%>
*/
<%
	}
%>
		
}

function window_onunload(){
	if( objZoomWindow != null && !objZoomWindow.closed ){
		objZoomWindow.close();
	}
	if( objVersionWindow != null && !objVersionWindow.closed ){
		objVersionWindow.close();
	}

	try{
		inetdocview.Close();
	}catch( e ){
	}
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
    inetdocview.ContainerType("<%=strConTainerType%>");
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

function openVersion( document_type, scan_no, document_level ){
	var strPopArgument 	= "scrollbars=yes,status=no";
	var strWidth 		= ",width=370px";
	var strHeight 		= ",height=400px";
	var strUrl 			= "inc/show_version.jsp";
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

//-->
</script>
<link href="css/edas.css" type="text/css" rel="stylesheet">
</head>
<body onLoad="MM_preloadImages('images/btt_keepdoc_over.gif','images/i_new_over.jpg','images/i_save_over.jpg','images/i_import_over.jpg','images/i_ocr_over.jpg','images/i_edit_del_over.jpg','images/i_out_over.jpg','images/btt_attached_over.gif','images/doc.gif');window_onload()" onunload="window_onunload();">
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
			                	<td valign="bottom"><a href="#" onclick="click_cancel()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('i_out','','images/i_out_over.jpg',1)"><img src="images/i_out.jpg" name="i_out" width="56" height="62" border="0"></a></td>
			                	<td width="*" align="right"><div class="label_bold1"> 
			                    	<div align="right" style="padding-right: 30px"><span class="label_header02" title="<%=strProjectCode %>"><%=strProjectName %></span><br>
			                      		<span class="label_bold5">(<%=lb_document_detail %>)</span></div>
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
    	<td valign="top" >
            <table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#F4F1DD" style="border: 1px solid #fff">
		        <tr>
	          		<td width="50%" height="21">
	          			<table width="100%" border="0" cellspacing="0" cellpadding="0" style="border: 1px solid #fff">
			              	<tr>
			                	<td background="images/tab_img_01.gif"><img id="tab_img_data" src="images/tab_img_data_down.gif" width="128" height="21"></td>
			              	</tr>
		            	</table>
	            	</td>
	          		<td>
		          		<table width="100%" border="0" cellspacing="0" cellpadding="0" style="border: 1px solid #fff">
			              	<tr> 
			                	<td background="images/tab_img_04.jpg"><img src="images/tab_img_doc.gif" width="128" height="21"></td>
			              	</tr>
            			</table>
			     	</td>
				</tr>
			    <tr> 
			        <td valign="top" style="border: 1px solid #fff">
			        	<!-- -------------------------- Document information ----------------------------------------- -->
			        	<div id="div_info" name="div_info" style="display:inline;clear: left;">
                                            <table width="460" border="0" align="left" cellpadding="0" cellspacing="0" class="label_bold2" style="margin-left: 15px">
			              	<tr> 
				                <td width="145">Document-Number</td>
				                <td colspan="2" >
				                	<label style="font-weight: normal"><%=strBatchNo %></label>
				                	<input name="txtDocNum" type="hidden" value="<%=strDocumentRunning %>" >
				                </td>
			              	</tr>
			              	<tr> 
			                	<td><span id="document_name"></span></td>
			                	<td colspan="2">
			                		<label style="font-weight: normal"><%=strDocumentName %></label>
			                		
	                			</td>
			              	</tr>
			              	<tr> 
			                	<td><span id="document_user"></span></td>
			                	<td colspan="2">
			                		<label style="font-weight: normal"><%=strDocumentUser %>(<%=strDocUserFullName %>)</label>
			                		
	                			</td>
			              	</tr>
			              	<tr> 
			                	<td><span id="document_level"></span></td>
			                	<td colspan="2">
			                		<label style="font-weight: normal"><%=strDocumentLevel %>(<%=strLevelName %>)</label>
			                		
	                			</td>
			              	</tr>
			              	<tr> 
			                	<td><span id="add_user"></span></td>
			                	<td colspan="2">
			                		<label style="font-weight: normal"><%=strAddUserId %>(<%=strAddUserName %>)</label>
		                		</td>
			              	</tr>
			              	<tr> 
				                <td><span id="add_date"></span></td>
				                <td colspan="2">
				                	<label style="font-weight: normal"><%=strAddDate %></label>
			                	</td>
			              	</tr>
			              	<tr> 
				            	<td><span id="upd_user"></span></td>
				                <td colspan="2">
			                		<label style="font-weight: normal">
			                		<% if(!strEditUserId.equals("")){%>
			                		<%=strEditUserId %>(<%=strEditUserName %>)
			                		<%}else{%> - <%} %>
			                		</label>
		                		</td>
			              	</tr>
			              	<tr> 
				                <td><span id="upd_date"></span></td>
				                <td colspan="2">
				                	<label style="font-weight: normal"><%=strEditDate %></label>
			                	</td>
				           	</tr>
				            <tr> 
				                <td><span id="expire_date"></span></td>
				                <td colspan="2">
				                	<label style="font-weight: normal"><%=strExpireDate %></label>
			                	</td>
				            </tr>
			              	<tr> 
				                <td><span id="doc_status"></span></td>
				                <td colspan="2">
				                	<label style="font-weight: normal"><%=strCheckStatus %>
				                	<% if(strCheckStatus.equals("CHECKOUT")){%>
				                		(<%=strCheckOutUser %>)
				                	<% } %>
				                	</label>
			                	</td>				                
			              	</tr>
			              	<tr> 
				                <td><span id="carbinet_no"></span></td>
				                <td colspan="2">
				                	<label style="font-weight: normal"><%=strBoxNo %></label>
			                	</td>
			              	</tr>
			              	<tr> 
				                <td><span id="storehouse"></span></td>
				                <td colspan="2">
				                	<label style="font-weight: normal"><%=strStorehouseName %></label>
			                	</td>
			              	</tr>
			              	<tr>
			              		<td colspan="3">&nbsp;</td>
			              	</tr>
			            </table>
			            </div>
			            <!-- -------------------------- End Document Information ----------------------------------------------- -->
			            <table width="100%" border="0" cellspacing="0" cellpadding="0" style="border: 1px solid #fff;clear: left">
			              <tr> 
			                <td background="images/tab_img_01.gif"><img id="tab_img_index" src="images/tab_img_index_down.gif" width="128" height="21"></td>
			              </tr>
			            </table>
			            <!-- ------------------------------ Document Index ------------------------------------------------------ -->
	
						<div id="div_index" name="div_index" style="display:inline">
                                                    <table width="460" border="0" align="left" cellpadding="0" cellspacing="0" class="label_bold2" style="margin-left: 15px">
			            	<tr><td colspan="2" height="15"></td></tr>
			            	
<%
			String strDataIndexLabel = "";
			String strDataIndexValue = "";
			
			for( int intCountField = 0 ; intCountField < strDataName.length ; intCountField++ ){
				
				strDataIndexLabel = strDataLabel[intCountField];
				strDataIndexValue = strDataValue[intCountField];
				
				if(strDataIndexValue.equals("")){
					strDataIndexValue = "-";
				}
%>
			    <tr> 
	                <td width="145" valign="top"><%=strDataIndexLabel %></td>
	                <td valign="top">
	                	<span id="<%=strDataName[ intCountField ]%>" value_type="<%=strDataType[ intCountField ].toLowerCase() %>" style="font-weight: normal"></span>
	                </td>
              	</tr>
<%				
				
			}
						
%>			            
			            	<tr> 
				                <td colspan="2">&nbsp;</td>
				            </tr>	
			            </table>
			        	</div>
			        	<!-- --------------------------------- End Document Index -------------------------------------------- -->    
		            </td>
			        <td valign="top" style="border: 1px solid #fff">
			        <!-- ----------------------------------- Document Type ------------------------------------------------------- -->    
            			<table width="95%" border="0" align="center" cellpadding="0" cellspacing="0" class="label_bold3">
            			<tr><td  colspan="2" height="10" align="right">&nbsp;</td></tr>
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
				String	strAccessType	= "";
				String	strNewVersion	= "";
				String	strVersionLimit	= "";
				String	strDocUserLevel	= "";
				String	strUserLevelTmp	= "";
				String	strPermitUsers	= "";
			
				String	strDocTypeName 	= "";
				String	strDocType	   	= "";
				String	strDocLevelCode	= "";
				String	strBlobData		= "";
    			String	strPictData		= "";
    			String	strPictSize		= "";
    			String	strDisplayRow	= "";
    			String	strScanNo		= "";
				int 	idx			 = 1;
				
				while(con.nextRecordElement()){
					strUserLevelTmp = "0";
					strPermitUsers 	= "";
					
					strDocTypeName 	= con.getColumn("DOCUMENT_TYPE_NAME");
					strDocType 		= con.getColumn("DOCUMENT_TYPE");
					strAccessType 	= con.getColumn("ACCESS_TYPE");
					strNewVersion 	= con.getColumn("NEW_VERSION");
					strVersionLimit = con.getColumn("VERSION_LIMIT");
					strDocUserLevel = con.getColumn("USER_LEVEL");
					
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
					
					strDocLevelCode = "";
					strBlobData		= "";
	    			strPictData		= "";
	    			strPictSize		= "";
	    			strScanNo		= "";
				
        			conDoc.addData("PROJECT_CODE", 		"String", strProjectCode);
        			conDoc.addData("BATCH_NO", 			"String", strBatchNo);
        			conDoc.addData("DOCUMENT_RUNNING", 	"String", strDocumentRunning);
        			conDoc.addData("DOCUMENT_TYPE", 	"String", strDocType);
        			
        			boolean bolSuccessDocLevel = conDoc.executeService(strContainerName, strClassName, "findDocumentLevel");
        			if(bolSuccessDocLevel){
        				strDocLevelCode = conDoc.getHeader("DOCUMENT_LEVEL");
        				strBlobData 	= conDoc.getHeader("BLOB");
        				strPictData 	= conDoc.getHeader("PICT");
        				strPictSize		= conDoc.getHeader("PICT_SIZE");
        				strScanNo 		= conDoc.getHeader("SCAN_NO");
        			}	
        			
        			if(!strBlobData.equals("")){
        				
            			strDisplayRow = "";
        				
        				if(strAccessType.equals("L")){
        					if(Integer.parseInt(strUserLevel) < Integer.parseInt(strUserLevelTmp)){ 
        						strDisplayRow = "style=\"display:none\"";
        					} 
        				}else 	if(strAccessType.equals("U")){
        					if(strPermitUsers.indexOf(strUserId) == -1){ 
        						strDisplayRow = "style=\"display:none\"";
        					} 
        				}else{        			
        					strDisplayRow = "";
        				} 
%>
		
					<tr <%=strDisplayRow %>>
						<td width="20">&nbsp;</td>
						<td>
                			<a href="javascript:openShowView('<%=strBatchNo%>','<%=strDocumentRunning%>','<%=strDocType%>','<%=strBlobData%>','<%=strPictData%>')"> 
	                 			<span id="div_header<%=idx %>" class="label_bold2"><%=strDocTypeName %></span>
	                 			<span class="label_bold2">(<%=strPictData%>)</span>
	                 		</a> 
	                 		<%
	                 			String	strVersion = ""; 
	                 			conVS.addData("PROJECT_CODE",	  "String", strProjectCode);
	                 			conVS.addData("BATCH_NO", 		  "String", strBatchNo);
	                 			conVS.addData("DOCUMENT_RUNNING", "String", strDocumentRunning);
	                 			conVS.addData("DOCUMENT_TYPE", 	  "String", strDocType);
	                 			boolean bolVSSuccess  = conVS.executeService(strContainerName,"DOCUMENT_TYPE","countVersion");
	                 			if(bolVSSuccess){
	                 				strVersion = conVS.getHeader("VERSION");
	                 			}
	                 			
	                 			if(!strVersion.equals("")&&!strVersion.equals("1")){
	                 		%>
	                 		<a href="javascript:openVersion( '<%=strDocType %>', <%=strScanNo %>, '<%=strDocLevelCode %>' )"> 
	                 			<span class="label_normal2">[<%=lb_version_doc %>]</span>
	                 		</a>
	                 		<%	} %>
	                 		 <input type="hidden" name="BLOB_ID<%=strDocType %>"   value="<%=strBlobData %>" />
				            <input type="hidden" name="BLOB_PART<%=strDocType %>" value="<%=strPictData %>" />
					        
	            			<input type="hidden" name="DOCUMENT_TYPE<%=strDocType %>" value="<%=strDocType %>">
						   	<input type="hidden" name="USED_SIZE_ARG<%=strDocType %>" value="<%=strPictSize %>">
          				</td>
         			</tr>
         			
<%					} 
					idx++;
				}
			}
%>            		
            			</table>
	           		</td>
        		</tr>
      		</table>
   		</td>
  	</tr>
</table>

<input type="hidden" name="PERMIT_FUNCTION" value="prnImg">

<input type="hidden" name="CURRENT_DOC">

<input type="hidden" name="BATCH_NO" 			value="<%=strBatchNo %>"/>
<input type="hidden" name="DOCUMENT_RUNNING" 	value="<%=strDocumentRunning %>" />

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
<iframe name="frameOffline" style="display:none"></iframe>
<iframe scrolling="no" frameborder="0" name="inetdocview" src="/jinetdocarchive/imageproxy?codetype=applet&version=15&securecode=<%=securecode%>" width="32" height="32" marginwidth="0">
</iframe>
</body>
</html>
