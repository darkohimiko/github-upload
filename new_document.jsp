<%@ page contentType="text/html; charset=tis-620"%>
<%@ page import="com.scc.edms.conf.ImageConfUtil"%>
<%@ page import="com.scc.security.UserInfo"%>
<%@ include file="inc/checkUser.jsp" %>
<%@ include file="inc/constant.jsp" %>
<%@ include file="inc/label.jsp" %>
<%@ include file="inc/utils.jsp" %>
<jsp:useBean id="con" scope="session" class="edms.cllib.EABConnector"/>
<jsp:useBean id="con1" scope="session" class="edms.cllib.EABConnector"/>
<%@page import="java.util.Random"%>
<%
    Random ran = new Random();
    String randomNo=String.valueOf(ran.nextLong());
    String strRand = "&randomNo="+ randomNo;
%>
<%
    con.setRemoteServer("EAS_SERVER");
    con1.setRemoteServer("EAS_SERVER");

    String securecode = "";

    if (!con.executeService("EASSYSTEM", "SECURECODE", "genSecurityCode")){
        out.println("Create Image Login Session Fail");
        return;
    }
    securecode = con.getHeader("SECURECODE");
%>
<%	

    UserInfo userInfo = (UserInfo)session.getAttribute( "USER_INFO" );
    String strUserId      = userInfo.getUserId();
    String strUserName    = userInfo.getUserName();
    String strUserOrg	  = userInfo.getUserOrg();
    String strUserOrgName = userInfo.getUserOrgName();
    String strUserLevel   = userInfo.getUserLevel();
    String strProjectCode = userInfo.getProjectCode();
    String strProjectName = userInfo.getProjectName();

    String user_role   = getField(request.getParameter("user_role"));
    String app_name    = getField(request.getParameter("app_name"));
    String app_group   = getField(request.getParameter("app_group"));
    String screenname  = getField(request.getParameter("screenname"));

    String strAccessDocTypeData = (String)session.getAttribute( "ACCESS_DOC_TYPE" );
    String strUserGroup         = (String)session.getAttribute( "USER_GROUP" );
    String strSecurityFlag      = (String)session.getAttribute( "SECURITY_FLAG" );
    String strImportServer      = (String)session.getAttribute( "IMPORT_SERVER" );
    String strImportServerPort  = (String)session.getAttribute( "IMPORT_SERVER_PORT" );
    String strImportWebServer   = (String)session.getAttribute( "IMPORT_WEB_SERVER" );
    String strImportWebPort     = (String)session.getAttribute( "IMPORT_WEB_PORT" );
    String strAndDocTypeCon     = "";

    String strMethod = request.getParameter( "METHOD" );
    String strConcatCheckbox         = getField( request.getParameter( "CONCAT_CHECKBOX" ) );
    String strConcatFieldName        = getField( request.getParameter( "CONCAT_FIELD_NAME" ) );
    String strDocumentFieldInsert    = getField( request.getParameter( "DOCUMENT_FIELD_INSERT" ) );
    String strDocumentValueInsert    = getField( request.getParameter( "DOCUMENT_VALUE_INSERT" ) );
    String strDocumentValueDuplicate = getField( request.getParameter( "DOCUMENT_VALUE_DUPLICATE" ) );

    String strConcatDocumentType  = getField( request.getParameter( "CONCAT_DOCUMENT_TYPE" ) );
    String strConcatDocumentLevel = getField( request.getParameter( "CONCAT_DOCUMENT_LEVEL" ) );
    String strConcatVersionLimit  = getField( request.getParameter( "CONCAT_VERSION_LIMIT" ) );
    String strConcatNewVersion    = getField( request.getParameter( "CONCAT_NEW_VERSION" ) );
    String strConcatBlobID 	  = getField( request.getParameter( "CONCAT_BLOBID" ) );
    String strConcatBlobPart 	  = getField( request.getParameter( "CONCAT_BLOBPART" ) );
    String strConcatUsedSizeArg   = getField( request.getParameter( "CONCAT_USED_SIZE_ARG" ) );
    String strConcatXmlTag 	  = getField( request.getParameter( "CONCAT_XML_TAG" ) );
    String strConcatFileType 	  = getField( request.getParameter( "CONCAT_FILE_TYPE" ) );
    String strConcatFileName 	  = getField( request.getParameter( "CONCAT_FILE_NAME" ) );

    String strDocumentLevel 	= getField( request.getParameter( "txtDocLevel" ) );
    String strDspExpireDate 	= getField( request.getParameter( "txtExpireDate" ) );
    String strStorehouse 	= getField( request.getParameter( "STORE_HOUSE" ) );
    String strExpireDate 	= getField( request.getParameter( "EXPIRE_DATE" ) );
    String strStorehouseName 	= getField( request.getParameter( "txtStoreHouse" ) );
    String strDocumentName      = getField( request.getParameter( "txtDocName" ) );
    String strDocumentUser      = getField( request.getParameter( "txtDocUser" ) );
    String strDocumentOrg       = getField( request.getParameter( "txtDocOrg" ) );
    
    String strClassName   = "IMPORTDATA";
    //String strErrorCode	  = "";
    String strErrorMessage="";
    String strCurrentDate = "";
    String strCurrentYear = "";
    String strPermission  = "";
    String strEditPermit  = "";
	
    String strXML = "<?xml version=\"1.0\"?>";
    strXML += "<Fields>";

    String strContainerType = ImageConfUtil.getInetContainerType();
    String strSite	    = ImageConfUtil.getCustomerSite();
    String strVersionLang   = ImageConfUtil.getVersionLang();
    String strStoreInPDF    = ImageConfUtil.getInetStorePDF();
    
    String strBatchNo	  = "";
    String strLevelName   = "";
    String strDocumentAge = "";
    String strPictSizeAll = "0";
    String  strLangFlag   = "";
    String strMonthOption = "";
    String strMonth       = "";
    String strMonthName   = "";
    	
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
	
    String strDataDocumentType[] , strDataDocumentLevel[] , strBlob[] , strPict[] , strUsedSizeArg[];
    String strDataVersionLimit[] , strDataNewVersion[];
    String strXmlTag[];
    String strFileTypes[];
    String strFileNames[];
	
    long longUsedSize = 0 , longAvailSize = 0 ; //longTotalSize = 0;

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
    //longTotalSize = Long.parseLong( strTotalSize );

    String strGenField[] = new String[0];
    if( strConcatFieldName.length() > 0 ){
        strGenField = strConcatFieldName.split( "," );
    }
    int intGenField = strGenField.length;
    String strGenFieldValue[] = new String[ intGenField ];
    for( int intCountField = 0 ; intCountField < intGenField ; intCountField++ ){
        strGenFieldValue[ intCountField ] = getField( request.getParameter( strGenField[ intCountField ] ) );
    }
	
    if(strMethod == null || strMethod.equals("")){
        strMethod = "INIT";
    }
	
    String strBttFunction = "<a href=\"javascript:click_new()\" onMouseOut=\"MM_swapImgRestore()\" onMouseOver=\"MM_swapImage('i_new','','images/i_new_over.jpg',1)\"><img src=\"images/i_new.jpg\" name=\"i_new\" width=\"56\" height=\"62\" border=0></a>";

    boolean bolSuccess;
    boolean bolnImportSuccess    = false;
    boolean bolnZoomMonthSuccess = false;
    boolean bolnSiteSuccess 	 = false;

    bolnSiteSuccess = con.executeService(strContainerName, "SYSTEM_CONFIG", "findSystemConfigAll");
    if(!bolnSiteSuccess) {
    	strSite = "SCC";
    }else{
    	strSite = con.getHeader("SITE");
    }
	
    con.addData("USER_ROLE", 		 "String", user_role);
    con.addData("APPLICATION", 	  	 "String", "EDIT_DOCUMENT");
    
    bolSuccess = con.executeService(strContainerName, strClassName, "findEditPermission");
    if(!bolSuccess) {
    	strEditPermit = "true";
    }else{
    	strEditPermit = "false";
    }
    
    con.addData("USER_ROLE", 		 "String", user_role);
    con.addData("APPLICATION", 	  	 "String", app_name);
    con.addData("APPLICATION_GROUP", "String", app_group);
    
    bolSuccess = con.executeService(strContainerName, "DOCUMENT_TYPE", "findPermission");
    if(bolSuccess) {
    	while(con.nextRecordElement()) {
    		strPermission = con.getColumn("PERMIT_FUNCTION");
    	}
    }
  
    if(strPermission.indexOf("insert") != -1){
        strBttFunction += "<a href=\"javascript:click_save()\" onMouseOut=\"MM_swapImgRestore()\" onMouseOver=\"MM_swapImage('i_save','','images/i_save_over.jpg',1)\"><img src=\"images/i_save.jpg\" name=\"i_save\" width=\"56\" height=\"62\" border=0></a>";
        strBttFunction += "<a href=\"javascript:openEDASImport('xml')\" onMouseOut=\"MM_swapImgRestore()\" onMouseOver=\"MM_swapImage('i_import','','images/i_import_over.jpg',1)\"><img src=\"images/i_import.jpg\" name=\"i_import\" width=\"56\" height=\"62\" border=0></a>";
        strBttFunction += "<a href=\"javascript:openEDASImport('excel')\" onMouseOut=\"MM_swapImgRestore()\" onMouseOver=\"MM_swapImage('i_importexcel','','images/i_import-excel_over.jpg',1)\"><img src=\"images/i_import-excel.jpg\" name=\"i_importexcel\" width=\"56\" height=\"62\" border=0></a>";
    }
 //   if(edaUtils.hasOCR()){
 //       strBttFunction += "<a href=\"javascript:click_ocr()\" onMouseOut=\"MM_swapImgRestore()\" onMouseOver=\"MM_swapImage('i_ocr','','images/i_ocr_over.jpg',1)\"><img src=\"images/i_ocr.jpg\" name=\"i_ocr\" width=56 height=62 border=0></a>";		
 //   }
    if(strEditPermit.equals("true")){
        strBttFunction += "<a href=\"javascript:click_edit()\" onMouseOut=\"MM_swapImgRestore()\" onMouseOver=\"MM_swapImage('i_edit_del','','images/i_edit_del_over.jpg',1)\"><img src=\"images/i_edit_del.jpg\" name=\"i_edit_del\" width=56 height=62 border=0></a>";
    }
	
    if( strMethod.equals("IMPORT") ) {
        con.addData( "PROJECT_CODE", 	"String", strProjectCode );
        con.addData( "CURRENT_DATE", 	"String", strCurrentDate );
        con.addData( "DOCUMENT_LEVEL", 	"String", strDocumentLevel );
        con.addData( "EXPIRE_DATE", 	"String", strExpireDate );
        con.addData( "STOREHOUSE", 	"String", strStorehouse );
        con.addData( "USER_ID", 	"String", strUserId );
        con.addData( "DOCUMENT_NAME", 	"String", strDocumentName );
        con.addData( "DOCUMENT_USER", 	"String", strDocumentUser );
        con.addData( "DOCUMENT_ORG", 	"String", strDocumentOrg );
        con.addData( "SCAN_ORG", 	"String", strUserOrg );
        con.addData( "CONTAINER_TYPE", 	"String", strContainerType );
        con.addData( "SITE", 		"String", strSite );
		
        if( strDocumentFieldInsert.length() > 0 ){
            con.addData( "DOCUMENT_FIELD_INSERT" , "String" , strDocumentFieldInsert );
            con.addData( "DOCUMENT_VALUE_INSERT" , "String" , strDocumentValueInsert );
        }
        if( strDocumentValueDuplicate.length() > 0 ){
            con.addData( "DOCUMENT_VALUE_DUPLICATE" , "String" , strDocumentValueDuplicate );
        }
		
        for( int intCountField = 0 ; intCountField < strGenField.length ; intCountField++ ){
            if( strGenFieldValue[ intCountField ].length() > 0 ){
                con.addData( strGenField[ intCountField ].replaceAll( "DSP_" , "" ) , "String" , strGenFieldValue[ intCountField ] );
            }
        }
		
        strDataDocumentType  = strConcatDocumentType.split( "," );
        strDataDocumentLevel = strConcatDocumentLevel.split( "," );
        strDataVersionLimit  = strConcatVersionLimit.split( "," );
        strDataNewVersion    = strConcatNewVersion.split( "," );
        strBlob              = strConcatBlobID.split( "," );
        strPict              = strConcatBlobPart.split( "," );
        strUsedSizeArg 	     = strConcatUsedSizeArg.split( "," );
        strXmlTag            = strConcatXmlTag.split( "," );
        strFileTypes         = strConcatFileType.split( "," );
        strFileNames         = strConcatFileName.split( "," );

        if( strConcatDocumentType.length() > 0 ) {
            for( int intArr = 0 ; intArr < strDataDocumentType.length ; intArr++ ) {
                con.addData( "DETAIL." + ( intArr + 1 ) + ".DOCUMENT_TYPE"  , "String" , strDataDocumentType[ intArr ] );
                con.addData( "DETAIL." + ( intArr + 1 ) + ".DOCUMENT_LEVEL" , "String" , strDataDocumentLevel[ intArr ] );
                con.addData( "DETAIL." + ( intArr + 1 ) + ".VERSION_LIMIT"  , "String" , strDataVersionLimit[ intArr ] );
                con.addData( "DETAIL." + ( intArr + 1 ) + ".NEW_VERSION"    , "String" , strDataNewVersion[ intArr ] );
                con.addData( "DETAIL." + ( intArr + 1 ) + ".BLOB"           , "String" , strBlob[ intArr ] );
                con.addData( "DETAIL." + ( intArr + 1 ) + ".PICT"           , "String" , strPict[ intArr ] );
                con.addData( "DETAIL." + ( intArr + 1 ) + ".PICT_SIZE"      , "String" , strUsedSizeArg[ intArr ] );
                con.addData( "DETAIL." + ( intArr + 1 ) + ".XML_TAG"        , "String" , strXmlTag[ intArr ] );				
                con.addData( "DETAIL." + ( intArr + 1 ) + ".FILE_TYPE"      , "String" , strFileTypes[ intArr ] );				
                con.addData( "DETAIL." + ( intArr + 1 ) + ".FILE_NAME"      , "String" , strFileNames[ intArr ] );				
                longUsedSize += Long.parseLong( strUsedSizeArg[ intArr ] );
            }
        }
		
        if( longUsedSize >= longAvailSize ){
            strErrorMessage = lc_total_size_full;
        }else{
            con.addData( "FULLTEXT_SEARCH" , "String" , lc_fulltext_search );
            con.addData("JCR_PORT", "String", lc_port_jackrabbit);
            bolnImportSuccess = con.executeService(strContainerName, strClassName, "importData");
            if( bolnImportSuccess ){
                    strBatchNo = con.getHeader( "BATCH_NO" );
            }else{
                    //strErrorCode    = con.getRemoteErrorCode();
                    strErrorMessage = con.getRemoteErrorMesage();
            }
        }
    }
    // ========== End Import Data ==========
	
    con.addData("PROJECT_CODE", "String", strProjectCode);
    bolSuccess = con.executeService(strContainerName, strClassName, "findDocumentInfo");
    if(bolSuccess) {
    	while(con.nextRecordElement()){
            strDocumentLevel = con.getColumn("DOCUMENT_LEVEL");
            strDocumentName  = con.getColumn("DOCUMENT_NAME");
            strLevelName	 = con.getColumn("LEVEL_NAME");
            strDocumentAge	 = con.getColumn("DOCUMENT_AGE");
            strTotalSize	 = con.getColumn("TOTAL_SIZE");
            strAvailSize	 = con.getColumn("AVIAIL_SIZE");
            strUsedSize		 = con.getColumn("USED_SIZE");
    //	strVersionLimit	 = con.getColumn("VERSION_LIMIT");
    	}
    }
    
    int	iExpireDate 	= 0;
    int	iCurrentYear	= 0;

    if(!strDocumentAge.equals("")&&strDocumentAge != null) {
    	strCurrentYear = strCurrentDate.substring(0,4);
    	iCurrentYear   = Integer.parseInt(strCurrentYear);
    	iExpireDate	   = iCurrentYear + Integer.parseInt(strDocumentAge);
    	
    	if(!strDocumentAge.equals("99")){
    		strExpireDate  = iExpireDate + strCurrentDate.substring(4,8);
    	}
    	
    	if(!strExpireDate.equals("-")){
    		strDspExpireDate = dateToDisplay(strExpireDate, "/");
    	}else{
    		strDspExpireDate = "";
    	}
    }
    
    con.addData("PROJECT_CODE", "String", strProjectCode);
    boolean bolFieldSuccess = con.executeService(strContainerName, strClassName, "findFieldDocument");
    if(!bolFieldSuccess) {
        session.setAttribute( "REDIRECT_PAGE" , "../caller.jsp?header=header1.jsp&detail=user_menu.jsp" + strRand );
    response.sendRedirect( "inc/check_field.jsp?INDEX_TYPE=F" );
    }
    
    
%>
<!DOCTYPE HTML>
<html>
<head>
<title><%=lc_system_name %> <%=lc_site_name%></title>
<meta http-equiv="Content-Type" content="text/html; charset=tis-620">
<link rel="shortcut icon" href="images/favicon/EDAS.ico" type="image/x-icon" />
<link href="css/edas.css" type="text/css" rel="stylesheet">
<link href="css/loading.css" type="text/css" rel="stylesheet">
<style type="text/css">
    
 body { background-color: #F4F1DD;}    
    
</style>
<script language="JavaScript" type="text/JavaScript">
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
<script language="JavaScript" src="js/jquery-1.9.1.js"></script>
<script language="JavaScript" src="js/label//lb_new_document.js"></script>
<script language="JavaScript" src="js/function/page-utils.js"></script>
<script language="JavaScript" src="js/sccUtils.js"></script>
<script language="JavaScript" src="js/util.js"></script>
<script language="JavaScript" src="js/constant.js"></script>
<script language="JavaScript" src="js/XML.js"></script>
<script language="JavaScript" src="js/imageTemplate.js"></script>
<script language="javascript" type="text/javascript">
<!--

var sccUtils 		= new SCUtils();
var imgTemplate 	= new imageTemplate();
var fullTextSearch 	= "<%=lc_fulltext_search%>";
var temp_check_date = "";

var strActiveBlobSeq;
var strActiveDocumentType;
var objZoomWindow;

$(document).ready(window_onload);

function window_onload(){
    set_contents("contents");
    set_label();
    init_form();
    set_message();
}

function set_label(){
    $("#document_name").text(lbl_document_name);
    $("#document_user").text(lbl_document_user);
    $("#document_level").text(lbl_document_level);
    $("#add_user").text(lbl_add_user);
    $("#add_date").text(lbl_add_date);
    $("#upd_user").text(lbl_upd_user);
    $("#upd_date").text(lbl_upd_date);
    $("#expire_date").text(lbl_expire_date);
    $("#doc_status").text(lbl_status);
    $("#carbinet_no").text(lbl_carbinet_no);
    $("#storehouse").text(lbl_doc_location);
}
	
function set_message(){	

<%  if( !strErrorMessage.equals( "" ) ){ %>
	showMsg( 0 , 0 , "<%=strErrorMessage.replaceAll( "\"" , "'" ).replaceAll( "\r" , "" ).replaceAll( "\n" , "<br>" )%>" );
/*  Eas Error Message Section
<%=strErrorMessage%>
*/
<%  }else if( bolnImportSuccess ){ %>
        showMsg( 0 , 0 , lc_process_complete );

        var batch_no = "<%=strBatchNo %>";
        var document_running = 1;

        if(batch_no != ""){
            get_log(batch_no,document_running);
        }
        click_new();
<%  }   %>		
}

function openEDASImport(import_type) {
    edasimport.Type= import_type; //importExcel='excel', importXML='xml'
    edasimport.Server= "<%=strImportServer%>"; // EAS_SERVER
    edasimport.Port= "<%=strImportServerPort%>"; //7012
    edasimport.WebServer= "<%=strImportWebServer%>";
    edasimport.WebPort= "<%=strImportWebPort%>";
    edasimport.ProjectCode= "<%=strProjectCode%>";
    edasimport.ContainerType= "<%=strContainerType%>";
    edasimport.UserId= "<%=strUserId%>";
    edasimport.ScanOrg= "<%=strUserOrg%>";
    edasimport.DocumentLevel="<%=strUserLevel%>";
    edasimport.RunImport();
 }

function click_new(){
    form1.txtExpireDate.value = "";
    get_concat_checkbox();

    form1.METHOD.value = "NEW";
    form1.method = "post";
    form1.action = "new_document.jsp";
    form1.submit();
}

function click_edit(){
	formEdit.submit();
}

function click_save(){
	temp_check_date = "";
	
	get_concat_blob_ID();
	set_concat_document_field();
	
	if( validate_mandatory_field() ){
            get_concat_checkbox();

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
    
        $('#load_screen_div').css({ 'opacity' : 0.7 });
	$('#load_screen_div').show();
	$('#load_screen_div').css("height",$(document).height());
	$('#progess_div').show();

	if(form1.CONCAT_BLOBID.value == "" && form1.CONCAT_FIELD_NAME.value == ""){
		alert(lc_vaerify_attach_doc);
		return;
	}
	form1.METHOD.value 	= "IMPORT";
	form1.method 		= "post";
	form1.action 		= "new_document.jsp";
	form1.submit();
}

function click_cancel(){
	top.location = "caller.jsp?header=header1.jsp&detail=user_menu.jsp<%=strRand%>";
}	

function validate_mandatory_field(){

	if(!validate_expire_date()){
		return false;
	}
	if(!validate_PK_field()){
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

function validate_PK_field(){
	var arrField = form1.CONCAT_FIELD_NAME.value.split( "," );
	var objField;
	
	if(form1.CONCAT_FIELD_NAME.value.length > 0 ){
		for( var intCount = 0 ; intCount < arrField.length ; intCount++ ){
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
	
	if(form1.CONCAT_FIELD_NAME.value.length > 0 ){
		for( var intCount = 0 ; intCount < arrField.length ; intCount++ ){
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
	
	if(form1.CONCAT_FIELD_NAME.value.length > 0 ){
		for( var intCount = 0 ; intCount < arrField.length ; intCount++ ){
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
			header_obj.className = "label_bold3"			
		}else{
			header_obj.className = "label_bold2"
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

function field_press( objField ) {
    
    var obj_name = objField.name;
    
    $("#" + obj_name ).keyup(function(e){
        if(e.keyCode==13){
	//if( new SCUtils().isEnter() ){
	//	window.event.keyCode = 0;
		switch( obj_name ){
			case "txtExpireDate" : 
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
                                    var objNextField;
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

	form1.txtExpireDate.value = "<%=strDspExpireDate%>";
	form1.EXPIRE_DATE.value   = "<%=strExpireDate%>";
	
	if( form1.METHOD.value == "IMPORT" ){
		set_JSP_value();
	}

	if( form1.METHOD.value == "NEW" || form1.METHOD.value == "IMPORT" ){
		set_checkbox_JSP_value();
	}
}

function get_concat_checkbox(){
	var arrField = form1.CONCAT_FIELD_NAME.value.split( "," );
	var strConcatCheckbox = "";
	var objCheckboxDocumentField;

	if(form1.CONCAT_FIELD_NAME.value.length > 0){

		for( var intCount = 0 ; intCount < arrField.length ; intCount++ ){
			objDocumentField = eval( "form1." + arrField[ intCount ] );
			objCheckboxDocumentField = eval( "form1." + arrField[ intCount ] + "_CHECK" );
	
			if( objCheckboxDocumentField != null && objCheckboxDocumentField.checked ){
				strConcatCheckbox += objCheckboxDocumentField.name + ",";
				objCheckboxDocumentField = eval( "form1.DSP_" + arrField[ intCount ] );
				if(objCheckboxDocumentField != null){
					strConcatCheckbox += objCheckboxDocumentField.name + ",";
				}
				
			}
		}
	
		if( strConcatCheckbox.length > 0 ){
			strConcatCheckbox = strConcatCheckbox.substr( 0 , strConcatCheckbox.length - 1 );
		}
	}
	form1.CONCAT_CHECKBOX.value = strConcatCheckbox;

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

	form1.txtDocNum.value 	  = "<%=strBatchNo%>";
	form1.txtExpireDate.value = "<%=strDspExpireDate%>";
	form1.EXPIRE_DATE.value   = "<%=strExpireDate%>";
	form1.txtStoreHouse.value = "<%=strStorehouseName%>";
	form1.STORE_HOUSE.value   = "<%=strStorehouse%>";

<%
	for( int intField = 0 ; intField < intGenField ; intField++ ){
%>
	if( form1.<%=strGenField[ intField ]%> != null ){
<%
	if( strGenFieldValue[ intField ].indexOf( "\n" ) != -1 ){
		strGenFieldValue[ intField ] = strGenFieldValue[ intField ].replaceAll( "\r\n" , "\\\\n" );
	}
	if( strGenFieldValue[ intField ].indexOf( "\"" ) != -1 ){
		strGenFieldValue[ intField ] = strGenFieldValue[ intField ].replaceAll( "\"" , "\\\\\"" );
	}
%>
		form1.<%=strGenField[ intField ]%>.value = "<%=strGenFieldValue[ intField ]%>";
	}
<%
	}
%>

}

function set_checkbox_JSP_value(){
	//var strKeepCheckbox = "<%=strConcatCheckbox%>";

<%
		String strTempFieldValue = "";
		for( int intField = 0 ; intField < intGenField ; intField++ ){ 
			if( strConcatCheckbox.indexOf( strGenField[ intField ]) != -1 ){
				strTempFieldValue = strGenFieldValue[ intField ];

				if( strTempFieldValue.indexOf( "\n" ) != -1 ){
					strTempFieldValue = strTempFieldValue.replaceAll( "\r\n" , "\\\\n" );
				}
				if( strTempFieldValue.indexOf( "\"" ) != -1 ){
					strTempFieldValue = strTempFieldValue.replaceAll( "\"" , "\\\"" );
				}
				
				if(strGenField[ intField ].indexOf("DSP_") == -1){
					if(strConcatCheckbox.indexOf( strGenField[ intField ]+ "_CHECK") != -1 ){
%>

	form1.<%=strGenField[ intField ]%>_CHECK.checked = true;

//	if( form1.<%=strGenField[ intField ]%>.value.length == 0 ){
		form1.<%=strGenField[ intField ]%>.value = "<%=strTempFieldValue%>";
//	}

<%
					}
				}else {
%>
		form1.<%=strGenField[ intField ]%>.value = "<%=strTempFieldValue%>";
<%					
				}
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



function window_onunload(){
	if( objZoomWindow != null && !objZoomWindow.closed ){
		objZoomWindow.close();
	}
//	if( objLinkWindow != null && !objLinkWindow.closed ){
//		objLinkWindow.close();
//	}

	try{
		inetdocview.Close();
	}catch( e ){
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
                                if(eval("form1." + strTableLv1 ).getAttribute("value_type") == "zoom"){
                                    strConcatField += "&TABLE_LV1_NAME=" + eval("form1.DSP_" + strTableLv1 + ".value");
                                }else{
                                    strConcatField += "&TABLE_LV1_NAME=" + $("#" + strTableLv1 + " option:selected").html();
                                }
				
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
                                if(eval("form1." + strTableLv1 ).getAttribute("value_type") == "zoom"){
                                    strConcatField += "&TABLE_LV1_NAME=" + eval("form1.DSP_" + strTableLv1 + ".value");
                                }else{
                                    strConcatField += "&TABLE_LV1_NAME=" + $("#" + strTableLv1 + " option:selected").html();
                                }
				
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
            list_change_lv2(data , table_level1 , field_id);            
            $("#" + data + "_TABLELEVEL1").val(field_id);
        }
    );
}

function get_table_level3(field_id , table_level2){
    var field_lv1 =  $("#" + field_id + "_TABLELEVEL1").val();
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
            list_change_lv3( field_lv1, field_id,  data , table_level1 , table_level2 );
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

function get_concat_blob_ID(){

	form1.CONCAT_DOCUMENT_TYPE.value  = "";
	form1.CONCAT_DOCUMENT_LEVEL.value = "";
	form1.CONCAT_VERSION_LIMIT.value  = "";
	form1.CONCAT_NEW_VERSION.value    = "";
	form1.CONCAT_BLOBID.value 		  = "";
	form1.CONCAT_BLOBPART.value		  = "";
	form1.CONCAT_USED_SIZE_ARG.value  = "";
	form1.CONCAT_XML_TAG.value  	  = "";
	form1.CONCAT_FILE_TYPE.value  	  = "";
	form1.CONCAT_FILE_NAME.value  	  = "";
	
	if( form1.TOTAL_DOCUMENT != null ){
		var intTotalDoc = parseInt( form1.TOTAL_DOCUMENT.value );
		var strBlob , strPart , strUsedSizeArg , strDocumentType , strImageProp, strDocumentLevel;
		var strNewVersion , strVersionLimit;
		var strXmlTag;
		var strFileType, strFileName;
		var cnt_temp;

		for( var countDoc = 0 ; countDoc < intTotalDoc ; countDoc++ ){
		//	cnt_temp = "000" + (countDoc + 1);
		//	cnt_temp = cnt_temp.substring(cnt_temp.length-3,cnt_temp.length);
			cnt_temp = eval(  "form1.DOCTYPE_CODE" 	+ (countDoc + 1) ).value;
				
			if(eval( "form1.DOCUMENT_TYPE" + cnt_temp )){
				eval(  "strDocumentType  = form1.DOCUMENT_TYPE" 	+ cnt_temp + ".value;" );
				eval(  "strDocumentLevel = form1.DOCUMENT_LEVEL" 	+ cnt_temp + ".value;" );
				eval(  "strVersionLimit  = form1.VERSION_LIMIT" 	+ cnt_temp + ".value;" );
				eval(  "strNewVersion	 = form1.NEW_VERSION" 		+ cnt_temp + ".value;" );
				eval(  "strBlob 		 = form1.BLOB_ID" 			+ cnt_temp + ".value;" );
				eval(  "strPart 		 = form1.BLOB_PART" 		+ cnt_temp + ".value;" );
				eval(  "strUsedSizeArg 	 = form1.USED_SIZE_ARG" 	+ cnt_temp + ".value;" );
				eval(  "strXmlTag 	 	 = form1.XML_TAG" 			+ cnt_temp + ".value;" );
				eval(  "strFileType 	 = form1.FILE_TYPE" 		+ cnt_temp + ".value;" );
				eval(  "strFileName 	 = form1.FILE_NAME" 		+ cnt_temp + ".value;" );
	            
				if( strBlob.length > 0 ){
					form1.CONCAT_DOCUMENT_TYPE.value  += strDocumentType  + ",";
					form1.CONCAT_DOCUMENT_LEVEL.value += strDocumentLevel + ",";
					form1.CONCAT_NEW_VERSION.value 	  += strNewVersion 	  + ",";
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
                                        
                                        strFileType = strFileType.replace(/,/g,";");
                                        
                                        if(strFileName == ""){
                                            if(strFileType == "NONE"){
						strFileName = "NONE";
                                            }else{
                                                strFileName = "N/A";
                                            }
					}
					form1.CONCAT_VERSION_LIMIT.value  += strVersionLimit + ",";
					form1.CONCAT_BLOBID.value 		  += strBlob 		 + ",";
					form1.CONCAT_BLOBPART.value		  += strPart 		 + ",";
					form1.CONCAT_USED_SIZE_ARG.value  += strUsedSizeArg  + ",";
					form1.CONCAT_XML_TAG.value  	  += strXmlTag  	 + ",";
					form1.CONCAT_FILE_TYPE.value  	  += strFileType  	 + ",";
					form1.CONCAT_FILE_NAME.value  	  += strFileName  	 + ",";
				}
			}
		}
	}

	var strConcatDocumentType  = form1.CONCAT_DOCUMENT_TYPE.value;
	var strConcatDocumentLevel = form1.CONCAT_DOCUMENT_LEVEL.value
	var strConcatVersionLimit  = form1.CONCAT_VERSION_LIMIT.value
	var strConcatNewVersion    = form1.CONCAT_NEW_VERSION.value
	var strConcatBlobID 	   = form1.CONCAT_BLOBID.value;
	var strConcatBlobPart	   = form1.CONCAT_BLOBPART.value;
	var strConcatUsedSizeArg   = form1.CONCAT_USED_SIZE_ARG.value;
	var strConcatXmlTag   	   = form1.CONCAT_XML_TAG.value;
	var strConcatFileType      = form1.CONCAT_FILE_TYPE.value;
	var strConcatFileName      = form1.CONCAT_FILE_NAME.value;
    
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
	if( strConcatXmlTag.length > 0 ){
		form1.CONCAT_XML_TAG.value = strConcatXmlTag.substring( 0 , strConcatXmlTag.length - 1 );
	}
	if( strConcatFileType.length > 0 ){
		form1.CONCAT_FILE_TYPE.value = strConcatFileType.substring( 0 , strConcatFileType.length - 1 );
	}
	if( strConcatFileName.length > 0 ){
		form1.CONCAT_FILE_NAME.value = strConcatFileName.substring( 0 , strConcatFileName.length - 1 );
	}
	
}

function set_concat_document_field(){
	var arrField = form1.CONCAT_FIELD_NAME.value.split( "," );
	var strFieldValue  = "";
	var strConcatField = "";
	var strConcatValue = "";
	var strConcatDup   = "";
	var strTextIndex   = "";


	var objDocumentField;
	var objDspDocumentField;

	if(form1.CONCAT_FIELD_NAME.value.length > 0){

		for( var intCount = 0 ; intCount < arrField.length ; intCount++ ){
			objDocumentField = eval( "form1." + arrField[ intCount ] );
	
			if( objDocumentField != null && objDocumentField.name.indexOf( "DSP_" ) == -1 && objDocumentField.value.length > 0 ){
				switch( objDocumentField.getAttribute("value_type") ){
					case "number" :
						strFieldValue = new SCUtils().replaceString(objDocumentField.value,',','');
						objDocumentField.value = strFieldValue;
						break;
					case "date" :
					case "date_eng" :
                                            
						if(new SCUtils().dateToDb( objDocumentField.value ).length != 8){
							temp_check_date = "N";
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
					default :
						strFieldValue = "'" + objDocumentField.value.replace(/'/g,"''") + "'";
	
						break;
				}
				if( objDocumentField.getAttribute("is_PK") == "Y" ){
					strConcatDup += objDocumentField.name + "=" + strFieldValue + " AND ";
				}
				strConcatField += objDocumentField.name + ",";
				strConcatValue += strFieldValue + ",";
				strTextIndex   += strFieldValue + " ";
			}
		}
	}
	
	if( strConcatField.length > 0 ){
		strConcatField = strConcatField.substr( 0 , strConcatField.length - 1 );
	}
	if( strConcatValue.length > 0 ){
		strConcatValue = strConcatValue.substr( 0 , strConcatValue.length - 1 );
	}
	if( strConcatDup.length > 0 ){
		strConcatDup = strConcatDup.substr( 0 , strConcatDup.lastIndexOf( "AND" ) );
	}
	if( strTextIndex.length > 0 ){
		strTextIndex = strTextIndex.substr( 0 , strTextIndex.lastIndexOf( " " ) );
	}
	form1.DOCUMENT_FIELD_INSERT.value    = strConcatField;
	form1.DOCUMENT_VALUE_INSERT.value    = strConcatValue;
	form1.DOCUMENT_VALUE_DUPLICATE.value = strConcatDup;
	form1.TEXT_INDEX.value 				 = strTextIndex;

}

function openAddEditView( strDocumentType , strFileSizeFlag ,  strFileSize , strFileTypeFlag , strFileType ){
    initAndShow( strFileSizeFlag ,  strFileSize , strFileTypeFlag , strFileType );
    inetdocview.SetProperty("CloseWhenSave", "true");
    retrieveImage( strDocumentType );
}

function initAndShow(strFileSizeFlag ,  strFileSize , strFileTypeFlag , strFileType){
    var x,y,w,h, sessionId;
    x = screen.width /2;
    y = 0;
    w = screen.width;
    h = screen.height;
    inetdocview.Close();
    sessionId = inetdocview.Open();
    inetdocview.Resize(x, y, w, (h-30));
    inetdocview.ContainerType("<%=strContainerType%>");
    
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

function set_file_property(size_flag, sizes, type_flag, types){
	var arrType;
	var file_size = "";
	if(size_flag == 'Y'){
		file_size = "," + sizes;
	}
	
	inetdocview.SetProperty("ADDTYPESIZE","Null");
	
	if(type_flag == 'Y'){
		arrType = types.split(",");
		for(var idx=0; idx<arrType.length; idx++){
			if(size_flag == 'Y'){
				inetdocview.SetProperty("ADDTYPESIZE",arrType[idx] + file_size + "M");
			}else{
				inetdocview.SetProperty("ADDTYPESIZE",arrType[idx]);
			}
		}
		//inetdocview.GetPropertyValue("LIMITINFO");
	}else{
		if(size_flag == 'Y'){
		
			inetdocview.SetProperty("ADDTYPESIZE","all" + file_size + "M");
			
			//inetdocview.GetPropertyValue("LIMITINFO");
		}
		
		inetdocview.SetProperty("FORCE_SAVE","true");
	}
}

function onHasLimitInfo(limitInfo){
	//alert(limitInfo);
}

function afterSaveFinish(strBlobId, strBlobPart)  {
    eval( "form1.BLOB_ID" 		+ form1.CURRENT_DOC.value).value = strBlobId;
 	eval( "form1.BLOB_PART" 	+ form1.CURRENT_DOC.value).value = strBlobPart;
	eval( "form1.XML_TAG" 		+ form1.CURRENT_DOC.value).value = "0"; 
	eval( "PICT_CNT" + form1.CURRENT_DOC.value).innerHTML = "(" + strBlobPart + ")";
	eval( "clear_" + form1.CURRENT_DOC.value).style.display = "inline";
	eval( "copy_" + form1.CURRENT_DOC.value).style.display = "inline";
	eval( "paste_" + form1.CURRENT_DOC.value).style.display = "none";
        
        inetdocview.GetPropertyValue("BlobSize");
        inetdocview.GetPropertyValue("AllType");
        inetdocview.GetPropertyValue("DocProperties");
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
        
        if(res1 == "DocProperties"){
            var data_xml = res2;            
            var filename = "";
            var xmlDocument = null;
            
            
            xmlDocument = new ActiveXObject("MSXML2.DOMDocument");
            xmlDocument.loadXML(data_xml);

//		alert(xmlDocument.xml);
		nodeList = xmlDocument.selectNodes("//Part");
		filename = nodeList.item(0).getAttribute("name");
			
		eval( "form1.FILE_NAME" + form1.CURRENT_DOC.value).value = filename;    
        }
    }
}

function get_log(batch_no,document_running){
	formLog.BATCH_NO.value 		   = batch_no;
	formLog.DOCUMENT_RUNNING.value = document_running;
	formLog.target = "frameLog";
	formLog.action = "master_log.jsp";
	formLog.submit();
}

function delete_doctype( doctype_label, lv_docType ) {
	if(!showMsg( 0 , 1 , lc_confirm_delete + " [" + doctype_label + "]" + lc_all_in_document )){
		return;
	}
	eval( "form1.BLOB_ID" + lv_docType).value    = "";
 	eval( "form1.BLOB_PART" + lv_docType).value  = "0";
	eval( "PICT_CNT" + lv_docType ).innerHTML    = ""; 
	eval( "clear_" + lv_docType ).style.display  = "none";
	eval( "copy_" + lv_docType ).style.display   = "none";
	eval( "paste_" + lv_docType ).style.display  = "inline";
	eval( "form1.FILE_TYPE" + lv_docType ).value = ""; 
	eval( "form1.FILE_NAME" + lv_docType ).value = ""; 
}

function pasteBlobPict( lv_docType ) {
	var doc_type_move = form1.hidDocTypeMove.value;
	var blob_move     = form1.hidBlobMove.value;
	var pict_move     = form1.hidPictMove.value;
	var filetype_move = form1.hidFileTypeMove.value;
	var filename_move = form1.hidFileNameMove.value;
	var blobsize_move = form1.hidBlobSizeMove.value;
	var filter_file_type = eval( "form1.FILE_TYPE_FILTER" + lv_docType ).value;
	var file_type_flag   = eval( "form1.FILE_TYPE_FLAG" + lv_docType ).value;
	var filter_file_size = eval( "form1.FILE_SIZE_FILTER" + lv_docType ).value;
	var file_size_flag   = eval( "form1.FILE_SIZE_FLAG" + lv_docType ).value;

	if( doc_type_move == "" ) {
		alert( lc_new_document_doctype_empty );
		return;
	}
	
	if( !showMsg( 0 , 1 , lc_confirm_paste_document_type ) ) {
		return;
	}
	
	if(filter_file_type != "" && file_type_flag == 'Y'){
            var arr_file_type = filetype_move.split(",");
            for(var idx=0;idx<arr_file_type.length; idx++){
                if(filter_file_type.indexOf(arr_file_type[idx]) == -1){
			alert(lc_file_not_match_cannot_move_doctype);
			return;
		}
            }    
	}
	
	if(filter_file_size != "" && file_size_flag == 'Y'){
		if(parseInt(filter_file_size)*1000 < parseInt(blobsize_move)){
			alert(lc_file_more_size_cannot_move_doctype);
			return;
		}
	}
	
	//--- New Doc Type
	eval( "form1.BLOB_ID" + lv_docType ).value      = blob_move;
	eval( "form1.BLOB_PART" + lv_docType ).value    = pict_move;
	eval( "PICT_CNT" + lv_docType).innerHTML        = "(" + pict_move + ")";
	eval( "form1.USED_SIZE_ARG" + lv_docType).value = blobsize_move;
	eval( "form1.XML_TAG" 		+ lv_docType).value = "0";
	eval( "copy_" + lv_docType ).style.display      = "inline";
	eval( "paste_" + lv_docType ).style.display     = "none";
	eval( "clear_" + lv_docType ).style.display     = "inline";
	eval( "form1.FILE_TYPE" + lv_docType ).value    = filetype_move;
	eval( "form1.FILE_NAME" + lv_docType ).value    = filename_move;

	//--- Old Doc Type
	eval( "form1.BLOB_ID" + doc_type_move).value       = "";
 	eval( "form1.BLOB_PART" + doc_type_move).value     = "0";
	eval( "PICT_CNT" + doc_type_move ).innerHTML       = ""; 
	eval( "form1.USED_SIZE_ARG" + doc_type_move).value = "0";
	eval( "form1.XML_TAG" 		+ doc_type_move).value = "0";
	eval( "copy_" + doc_type_move ).style.display      = "none";
	eval( "paste_" + doc_type_move ).style.display     = "inline";
	eval( "clear_" + doc_type_move ).style.display     = "none";
	eval( "form1.FILE_TYPE" + doc_type_move ).value    = "";
	eval( "form1.FILE_NAME" + doc_type_move ).value    = "";
	
	form1.hidDocTypeMove.value  = "";
	form1.hidBlobMove.value     = "";
	form1.hidPictMove.value     = "";
	form1.hidFileTypeMove.value = "";
	form1.hidFileNameMove.value = "";
	form1.hidBlobSizeMove.value = "";
}

function copyBlobPict( lv_docType ) {
	if( !showMsg( 0 , 1 , lc_confirm_copy_document_type ) ) {
		return;
	}
	
	var lv_blob     = eval( "form1.BLOB_ID" + lv_docType ).value;
	var lv_pict     = eval( "form1.BLOB_PART" + lv_docType ).value;
	var lv_filetype = eval( "form1.FILE_TYPE" + lv_docType ).value;
	var lv_filename = eval( "form1.FILE_NAME" + lv_docType ).value;
	var lv_blobsize = eval( "form1.USED_SIZE_ARG" + lv_docType ).value;

	form1.hidDocTypeMove.value  = lv_docType;
	form1.hidBlobMove.value     = lv_blob;
	form1.hidPictMove.value     = lv_pict;
	form1.hidFileTypeMove.value = lv_filetype;
	form1.hidFileNameMove.value = lv_filename;
	form1.hidBlobSizeMove.value = lv_blobsize;
}

function clearDocTypeMove( lv_docType ) {
	var doc_type_move = form1.hidDocTypeMove.value;
	var blob_move     = form1.hidBlobMove.value;
	var pict_move     = form1.hidPictMove.value;
	var filetype_move = form1.hidFileTypeMove.value;
	var filename_move = form1.hidFileNameMove.value;
	var blobsize_move = form1.hidBlobSizeMove.value;
	
	if( lv_docType == doc_type_move ) {
		
	}
}

//********************** OCR Section *****************************************//

function afterLoadFinish(){

}

function setOCRFieldList(){
	try{
//		alert( strXml );
		inetdocview.OCRFieldList( strXml );
	}catch( e ){
		alert( e.message );
	}
}

function afterOcrFinish(){
// 	alert( "OCR Success" );
//	getOCRTemplate();   //  always keep OCR Template when do OCR
	setOCRResult();
}

function setOCRResult(){
	var strXMLResult = inetdocview.OCRResult();
	var objXml = new XML();
	var objFieldName = form1.CONCAT_FIELD_NAME.value.split( "," );
	var objField;
	var strFieldValue = "";
	
	//alert( "strXMLResult = " + strXMLResult );
	
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

function getOCRResult(){
	inetdocview.OCRRecognize();
}

function getOCRTemplate(){
	strXmlTemplate = inetdocview.OCRTemplate();
}

function setOCRTemplate(){
	if( strXmlTemplate.length > 0 ){
		inetdocview.OCRAddTemplate( strXmlTemplate );
	}
}

function check_inet_version(){
	try{
		var inet_val = inetdocview.GetPropertyValue("VERSION");
		var version  = inet_val.split(" ");
		var new_version = version[0] + " " + version[1];
		
		if(new_version < lc_inet_version){
			alert("Please install new version");	
		}
	
	}catch( e ){
	}
}

//-->
</script>
</head>
<body onLoad="MM_preloadImages('images/btt_keepdoc_over.gif','images/i_new_over.jpg','images/i_save_over.jpg','images/i_import_over.jpg','images/i_ocr_over.jpg','images/i_edit_del_over.jpg','images/i_out_over.jpg','images/btt_attached_over.gif','images/doc.gif');" onunload="window_onunload();">
<form name="form1" method="post">
<jsp:include page="inc/loading_div.jsp"></jsp:include>
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
                    <td width="*" height="29" background="images/inner_img_07.jpg" valign="middle">
                        <span class="navbar_02">(<%=strUserOrgName%>)</span> <span class="navbar_01"><%=lb_user_name %> : <%=strUserName %> (<%=strUserId%> / <%=strUserLevel%>)</span> 
                    </td>
                    <td width="170" class="navbar_01" align="right" style="padding-right: 30px"><%=dateToDisplay(strCurrentDate)%>&nbsp;</td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td valign="top">
            <table id="contents" width="100%" border="0" cellpadding="0" cellspacing="0" >
                <tr> 
                    <td valign="top" width="50%" style="border: 1px solid #FFF"> <!-- column1  -->
                        <table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0" >
                            <tr>
                                <td height="21" valign="top" >
                                    <table width="100%" border="0" cellspacing="0" cellpadding="0" >
                                        <tr>
                                            <td onclick="div_click('div_info','tab_img_data',0)" style="cursor:pointer" background="images/tab_img_01.gif"><img id="tab_img_data" src="images/tab_img_data.gif" width="128" height="21"></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr> 
                                <td valign="top" >
                                    <!-- -------------------------- Document information ----------------------------------------- -->
                                    <div id="div_info" name="div_info" style="display:none;clear: left;" >
                                        <table width="460" border="0" align="left" cellpadding="0" cellspacing="0" class="label_bold2" style="margin-left: 15px;">
                                            <tr> 
                                                <td width="145">Document-Number</td>
                                                <td colspan="2">
                                                    <input id="txtDocNum" name="txtDocNum" type="text" class="input_box_disable" value="<%=strBatchNo %>" size="20" maxlength="13" readonly>
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
                                                    <input id="txtDocUser" name="txtDocUser" type="text" class="input_box_disable" value="<%=strUserId %>" size="12" readonly> 
                                                    <a href="javascript:openDocUserZoom('DOC_USER', '<%=lb_doc_user %>');"><img src="images/search.gif" width="16" height="16" border="0" align="absmiddle"></a> 
                                                    <input id="txtDocUserName" name="txtDocUserName" type="text" class="input_box_disable" value="<%=strUserName %>" size="35" readonly>
                                                    <input name="txtDocOrg" type="hidden" value="" >
                                                </td>
                                            </tr>
                                            <tr>
                                                <td><span id="document_level"></span></td>
                                                <td colspan="2">
                                                    <input id="txtDocLevel" name="txtDocLevel" type="text" class="input_box_disable" value="<%=strDocumentLevel %>" size="6" maxlength="4" style="text-align:right" readonly> 
                                                    <a href="javascript:openZoom('USER_LEVEL' , '<%=lb_level_doc %>' , form1.txtDocLevelName , form1.txtDocLevel,'1');"><img src="images/search.gif" width="16" height="16" border="0" align="absmiddle"></a> 
                                                    <input id="txtDocLevelName" name="txtDocLevelName" type="text" class="input_box_disable" value="<%=strLevelName %>" size="40" readonly>
                                                </td>
                                            </tr>
                                            <tr> 
                                                <td><span id="add_user"></span></td>
                                                <td>
                                                    <input id="txtAddUserId" name="txtAddUserId" type="text" class="input_box_disable" value="<%=strUserId %>" size="15" readonly>
                                                </td>
                                                <td>
                                                    <input id="txtAddUserName" name="txtAddUserName" type="text" class="input_box_disable" value="<%=strUserName %>" size="35" readonly>
                                                </td>
                                            </tr>
                                            <tr> 
                                                <td><span id="add_date"></span></td>
                                                <td colspan="2">
                                                    <input id="txtAddDate" name="txtAddDate" type="text" class="input_box_disable" value="<%=dateToDisplay(strCurrentDate,"/") %>" size="15" readonly>
                                                </td>
                                            </tr>
                                            <tr> 
                                                <td><span id="upd_user"></span></td>
                                                <td>
                                                    <input id="txtEditUserId" name="txtEditUserId" type="text" class="input_box_disable" value="" size="15" readonly>
                                                </td>
                                                <td>
                                                    <input id="txtEditUserName" name="txtEditUserName" type="text" class="input_box_disable" value="" size="35" readonly>
                                                </td>
                                            </tr>
                                            <tr> 
                                                <td><span id="upd_date"></span></td>
                                                <td colspan="2">
                                                   <input id="txtEditDate" name="txtEditDate" type="text" class="input_box_disable" value="" size="15" readonly>
                                                </td>
                                            </tr>
                                            <tr> 
                                                <td><span id="expire_date"></span></td>
                                                <td colspan="2">
                                                    <input name="txtExpireDate" type="text" class="input_box" size="15" maxlength="8" onkeypress="keypress_number();field_press(this)" onblur="set_format_date(this)">
                                                    <input type="hidden" name="EXPIRE_DATE">
                                                    <a href="javascript:showCalendar(form1.txtExpireDate,<%=strLangFlag %>)"><img src="images/calendar.gif" width="16" height="16" align="absmiddle" border="0"></a>
                                                </td>
                                            </tr>
                                            <tr> 
                                                <td><span id="doc_status"></span></td>
                                                <td colspan="2">
                                                    <input id="txtDocStatus" name="txtDocStatus" type="text" class="input_box_disable" value="" size="15" readonly>
                                                </td>				                
                                            </tr>
                                            <tr> 
                                                <td><span id="carbinet_no"></span></td>
                                                <td colspan="2">
                                                    <input id="txtCarbinetNo" name="txtCarbinetNo" type="text" class="input_box_disable" value="" size="15" readonly>
                                                </td>
                                            </tr>
                                            <tr> 
                                                <td><span id="storehouse"></span></td>
                                                <td colspan="2">
                                                    <input id="txtStoreHouse" name="txtStoreHouse" type="text" class="input_box_disable" value="" size="50" readonly>
                                                    <input id="STORE_HOUSE" name="STORE_HOUSE" type="hidden" >
                                                    <a href="javascript:openZoom('STOREHOUSE' , '<%=lb_doc_store %>' , form1.txtStoreHouse , form1.STORE_HOUSE, '1');"><img src="images/search.gif" width="16" height="16" border="0" align="absmiddle"></a>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="3">
                                                    <input type="hidden" name="TOTAL_SIZE" 		value="<%=strTotalSize %>" />
                                                    <input type="hidden" name="AVAIL_SIZE" 		value="<%=strAvailSize %>" />
                                                    <input type="hidden" name="USED_SIZE" 		value="<%=strUsedSize %>" />
                                                    <input type="hidden" name="PICT_SIZE_ALL" 	value="<%=strPictSizeAll %>" />			              			
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
			
			if(bolFieldSuccess) {
				
				String strFieldLabel , strFieldName , strFieldType , strFieldLength , strFieldTableZoom , strFieldSize , strIsPK , strIsNotNull;
				String strTableLevel, strTableLevel1, strTableLevel2;
				String strDefaultValue;
				String strTag 		= "";
				String strPrefix 	= "";
				String strSelected 	= "";
				String strCheckbox 	= "";
				
				String strTableLv1  	= "";
				String strTableLv1Label = "";
				String strTableLv2  	= "";
				String strTableLv2Label = "";

				strConcatFieldName = "";

				while( con.nextRecordElement() ){
					strFieldLabel 	  = con.getColumn( "FIELD_LABEL" );
					strFieldName	  = con.getColumn( "FIELD_CODE" );
					strFieldType	  = con.getColumn( "FIELD_TYPE" );
					strFieldLength	  = con.getColumn( "FIELD_LENGTH" );
					strFieldTableZoom = con.getColumn( "TABLE_ZOOM" );
					strIsPK		  = con.getColumn( "IS_PK" );
					strIsNotNull	  = con.getColumn( "IS_NOTNULL" );
					strTableLevel	  = con.getColumn( "TABLE_LEVEL" );
					strTableLevel1	  = con.getColumn( "TABLE_LEVEL1" );
					strTableLevel2	  = con.getColumn( "TABLE_LEVEL2" );
					strDefaultValue   = con.getColumn( "DEFAULT_VALUE" );
					
					strCheckbox = "<input type=\"checkbox\" name=\"" +  strFieldName+ "_CHECK\" value=\"Y\">";
					
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
						strTag = "\n<input type=\"text\" id=\"" + strFieldName + "\" name=\"" + strFieldName + "\" value=\"" + strDefaultValue + "\" class=\"input_box\" size=\"" + strFieldSize + "\" maxlength=\"" + strFieldLength + "\" is_PK=\"" + strIsPK + "\" is_NotNull=\"" + strIsNotNull + "\" onKeypress=\"field_press( this );\" onFocus=\"ocr_focus( this );\">";
					}else if( strFieldType.equals( "TIN" ) ){
						strTag = "\n<input type=\"text\" id=\"" + strFieldName + "\" name=\"" + strFieldName + "\" class=\"input_box\" size=\"" + ( Integer.parseInt( strFieldSize ) + 5 ) + "\" maxlength=\"" + strFieldLength + "\" value_type=\"tin\" is_PK=\"" + strIsPK + "\" is_NotNull=\"" + strIsNotNull + "\" onKeypress=\"keypress_number();field_press( this );\" onfocus=\"set_unmask(this)\" onblur=\"set_mask(this,'tin')\">";
					}else if( strFieldType.equals( "PIN" ) ){
						strTag = "\n<input type=\"text\" id=\"" + strFieldName + "\" name=\"" + strFieldName + "\" class=\"input_box\" size=\"" + ( Integer.parseInt( strFieldSize ) + 5 ) + "\" maxlength=\"" + strFieldLength + "\" value_type=\"pin\" is_PK=\"" + strIsPK + "\" is_NotNull=\"" + strIsNotNull + "\" onKeypress=\"keypress_number();field_press( this );\" onfocus=\"set_unmask(this)\" onblur=\"set_mask(this,'pin')\">";
					}else if( strFieldType.equals( "DATE" ) ){
                                            if( strDefaultValue.equals("CUR_DATE") ) {
                                                strDefaultValue = dateToDisplay( strCurrentDate,"/" );
                                            }
                                            strTag  = "\n<input type=\"text\" id=\"" + strFieldName + "\" name=\"" + strFieldName + "\" value=\"" + strDefaultValue + "\" class=\"input_box\" size=\"10\" maxlength=\"10\" value_type=\"date\" is_PK=\"" + strIsPK + "\" is_NotNull=\"" + strIsNotNull + "\" onKeypress=\"keypress_number();field_press( this );\" onfocus=\"set_unformat_date( this );\" onBlur=\"set_format_date( this );\">";
                                            strTag += "\n<a href=\"javascript:showCalendar(form1." + strFieldName + ",1)\"><img src=\"images/calendar.gif\" width=16 height=16 align=\"absmiddle\" border=0 ></a>";
					}else if( strFieldType.equals( "DATE_ENG" ) ){
                                            if( strDefaultValue.equals("CUR_DATE") ) {
                                                //strDefaultValue = dateToDisplay( getServerDateEng(),"/" );
                                                strDefaultValue = dateToDisplay( getTodayDate(),"/" );
                                            }
                                            strTag  = "\n<input type=\"text\" id=\"" + strFieldName + "\" name=\"" + strFieldName + "\" value=\"" + strDefaultValue + "\" class=\"input_box\" size=\"10\" maxlength=\"10\" value_type=\"date_eng\" is_PK=\"" + strIsPK + "\" is_NotNull=\"" + strIsNotNull + "\" onKeypress=\"keypress_number();field_press( this );\" onfocus=\"set_unformat_date( this );\" onBlur=\"set_format_date_eng( this );\">";
                                            strTag += "\n<a href=\"javascript:showCalendar(form1." + strFieldName + ",0)\"><img src=\"images/calendar.gif\" width=16 height=16 align=\"absmiddle\" border=0 ></a>";
					}else if( strFieldType.equals( "MONTH" ) ){
                                            if( strDefaultValue.equals("CUR_MONTH") ) {
                                                //strDefaultValue = monthThai( Integer.parseInt(getServerDateEng().substring(4,6)) );
                                                strDefaultValue = strCurrentDate.substring(4,6);
                                            }
                                            strMonthOption = "\n<select id=\"" + strFieldName + "\" name=\"" + strFieldName + "\" class=\"combobox\" is_PK=\"" + strIsPK + "\" is_NotNull=\"" + strIsNotNull + "\" onKeypress=\"field_press( this );\">";
                                            strMonthOption += "\n<option value=\"\"></option>";
                                            bolnZoomMonthSuccess = con1.executeService( strContainerName, strClassName, "findMonthCombo" );
                                            if( bolnZoomMonthSuccess ) {
                                                while( con1.nextRecordElement() ) {
                                                    strMonth     = con1.getColumn( "MONTH" );
                                                    strMonthName = con1.getColumn( "MONTH_NAME" );
                                                    if( strDefaultValue.equals( strMonth )) {
                                                        strMonthOption += "\n<option value=\"" + strMonth + "\" selected>" + strMonthName + "</option>";
                                                    }else {
                                                        strMonthOption += "\n<option value=\"" + strMonth + "\">" + strMonthName + "</option>";
                                                    }
                                                }
                                            }
                                            strMonthOption += "\n</select>";
                                            strTag = strMonthOption;
                                            //strTag  = "\n<input type=\"text\" name=\"" + strFieldName + "\" value=\"" + strDefaultValue + "\" class=\"input_box\" size=\"10\" maxlength=\"10\" value_type=\"date\" is_PK=\"" + strIsPK + "\" is_NotNull=\"" + strIsNotNull + "\" onKeypress=\"keypress_number();field_press( this );\" onBlur=\"set_format_date( this );\">";
                                            //strTag += "\n<a href=\"javascript:showCalendar(form1." + strFieldName + "," + strLangFlag + ")\"><img src=\"images/calendar.gif\" width=16 height=16 align=\"absmiddle\" border=0 ></a>";
					}else if( strFieldType.equals( "MONTH_ENG" ) ){
                                            if( strDefaultValue.equals("CUR_MONTH") ) {
                                                //strDefaultValue = monthThai( Integer.parseInt(getServerDateEng().substring(4,6)) );
                                                strDefaultValue = strCurrentDate.substring(4,6);
                                            }
                                            strMonthOption = "\n<select id=\"" + strFieldName + "\" name=\"" + strFieldName + "\" class=\"combobox\" is_PK=\"" + strIsPK + "\" is_NotNull=\"" + strIsNotNull + "\" onKeypress=\"field_press( this );\">";
                                            strMonthOption += "\n<option value=\"\"></option>";

                                            con1.addData( "TABLE_ZOOM" , "String" , "MONTH_ENG" );
                                            bolnZoomMonthSuccess = con1.executeService( strContainerName, strClassName, "findTableCode" );
                                            if( bolnZoomMonthSuccess ) {
                                                while( con1.nextRecordElement() ) {
                                                    strMonth     = con1.getColumn( "MONTH_ENG" );
                                                    strMonthName = con1.getColumn( "MONTH_ENG_NAME" );
                                                    if( strDefaultValue.equals( strMonth )) {
                                                        strMonthOption += "\n<option value=\"" + strMonth + "\" selected>" + strMonthName + "</option>";
                                                    }else {
                                                        strMonthOption += "\n<option value=\"" + strMonth + "\">" + strMonthName + "</option>";
                                                    }
                                                }
                                            }
                                            strMonthOption += "\n</select>";
                                            strTag = strMonthOption;
					}else if( strFieldType.equals( "YEAR" ) ){
                                            if( strDefaultValue.equals("CUR_YEAR") ) {
                                                strDefaultValue = strCurrentDate.substring(0,4);
                                                //strDefaultValue = dateToDisplay(getServerDateThai()).substring(0,4);
                                            }
                                            strTag  = "\n<input type=\"text\" id=\"" + strFieldName + "\" name=\"" + strFieldName + "\" value=\"" + strDefaultValue + "\" class=\"input_box\" size=\"4\" maxlength=\"4\" value_type=\"number\" is_PK=\"" + strIsPK + "\" is_NotNull=\"" + strIsNotNull + "\" onKeypress=\"keypress_number();field_press( this );\">";
                                            //strTag += "\n<a href=\"javascript:showCalendar(form1." + strFieldName + "," + strLangFlag + ")\"><img src=\"images/calendar.gif\" width=16 height=16 align=\"absmiddle\" border=0 ></a>";
					}else if( strFieldType.equals( "NUMBER" ) ){
                                            strTag = "\n<input type=\"text\" id=\"" + strFieldName + "\" name=\"" + strFieldName + "\" value=\"" + strDefaultValue + "\" class=\"input_box\" size=\"" + strFieldSize + "\" maxlength=\"" + strFieldLength + "\" value_type=\"number\" is_PK=\"" + strIsPK + "\" is_NotNull=\"" + strIsNotNull + "\" onKeypress=\"keypress_number();field_press( this );\" onFocus=\"ocr_focus( this );\">";
					}else if( strFieldType.equals( "CURRENCY" ) ){
                                            strTag = "\n<input type=\"text\" id=\"" + strFieldName + "\" name=\"" + strFieldName + "\" value=\"" + strDefaultValue + "\" class=\"input_box\" size=\"" + strFieldSize + "\" maxlength=\"" + strFieldLength + "\" value_type=\"number\" is_PK=\"" + strIsPK + "\" is_NotNull=\"" + strIsNotNull + "\" onKeypress=\"keypress_currency(this);field_press( this );\" onclick=\"change_format_currency(this)\" onblur=\"set_currency_format(this)\" onFocus=\"ocr_focus( this );\">";
					}else if( strFieldType.equals( "MEMO" ) ){
                                            strTag = "\n<textarea id=\"" + strFieldName + "\" name=\"" + strFieldName + "\" cols=\"80\" rows=\"7\" value_type=\"memo\" is_PK=\"" + strIsPK + "\" is_NotNull=\"" + strIsNotNull + "\" class=\"input_box_multi\" maxlength=\"" + strFieldLength + "\" onFocus=\"ocr_focus( this );\">" + strDefaultValue + "</textarea>";
					}else if( strFieldType.equals( "ZOOM" ) ){
                                            strTag = "\n<input type=\"hidden\" id=\"" + strFieldName + "\" name=\"" + strFieldName + "\" value=\"" + strDefaultValue + "\" value_type=\"zoom\" is_PK=\"" + strIsPK + "\" is_NotNull=\"" + strIsNotNull + "\">";

                                            if(!strDefaultValue.equals("")){
                                                con1.addData("FIELD_CODE", "String", strDefaultValue);
                                                con1.addData("TABLE_NAME", "String", strFieldTableZoom);
                                                boolean bolSuccessCode = con1.executeService(strContainerName, "EDIT_DOCUMENT", "findFieldCode");
                                                if(bolSuccessCode){
                                                        strDefaultValue = con1.getHeader(strFieldTableZoom + "_NAME");
                                                }
                                            }
                                            strTag += "\n<input type=\"text\" id=\"DSP_" + strFieldName + "\" name=\"DSP_" + strFieldName + "\" value=\"" + strDefaultValue + "\" class=\"input_box_disable\" size=\"40\" readonly>";
                                            strTag += "\n<a href=\"javascript:openZoom('" + strFieldTableZoom + "' , '" + strFieldLabel + "' , form1.DSP_" + strFieldName + " , form1." + strFieldName + ", '" + strTableLevel +"');\"><img src=\"images/search.gif\" width=16 height=16 align=\"absmiddle\" border=0></a>";

                                            if(strTableLevel.equals("1")){
                                                strTag += "\n<input type=\"hidden\" name=\"FIELD_" + strFieldTableZoom + "\" value=\"" + strFieldName + "\">";
                                            }
                                            if(strTableLevel.equals("2")){
                                                con1.addData("PROJECT_CODE", "String", strProjectCode);
                                                con1.addData("TABLE_CODE"  , "String", strTableLevel1);
                                                boolean bolSuccessLv2 = con1.executeService(strContainerName, strClassName, "findFieldTableZoom");
                                                if(bolSuccessLv2){
                                                    strTableLv1 	 = con1.getHeader("FIELD_CODE");
                                                    strTableLv1Label = con1.getHeader("FIELD_LABEL");

                                                    strTag += "\n<input type=\"hidden\" name=\"FIELD_" + strFieldTableZoom + "_LV1\" value=\"" + strTableLv1 + "\">";
                                                    strTag += "\n<input type=\"hidden\" name=\"FIELD_" + strFieldTableZoom + "_LV1_LABEL\" value=\"" + strTableLv1Label + "\">";
                                                    strTag += "\n<input type=\"hidden\" name=\"FIELD_" + strFieldTableZoom + "_LV1_CODE\" value=\"" + strTableLevel1 + "\">";
                                                    strTag += "\n<input type=\"hidden\" name=\"FIELD_" + strTableLevel1 + "_LV2\" value=\"" + strFieldName + "\">";
                                                }
                                                
                                                strTag += "\n<input type=\"hidden\" name=\"FIELD_" + strFieldTableZoom + "\" value=\"" + strFieldName + "\">";
                                            }

                                            if(strTableLevel.equals("3")){
                                                con1.addData("PROJECT_CODE", "String", strProjectCode);
                                                con1.addData("TABLE_CODE"  , "String", strTableLevel1);
                                                boolean bolSuccessLv3 = con1.executeService(strContainerName, strClassName, "findFieldTableZoom");
                                                if(bolSuccessLv3){
                                                    strTableLv1 	 = con1.getHeader("FIELD_CODE");
                                                    strTableLv1Label = con1.getHeader("FIELD_LABEL");

                                                    strTag += "\n<input type=\"hidden\" name=\"FIELD_" + strFieldTableZoom + "_LV1\" value=\"" + strTableLv1 + "\">";
                                                    strTag += "\n<input type=\"hidden\" name=\"FIELD_" + strFieldTableZoom + "_LV1_LABEL\" value=\"" + strTableLv1Label + "\">";
                                                    strTag += "\n<input type=\"hidden\" name=\"FIELD_" + strFieldTableZoom + "_LV1_CODE\" value=\"" + strTableLevel1 + "\">";
                                                    strTag += "\n<input type=\"hidden\" name=\"FIELD_" + strTableLevel1 + "_LV3\" value=\"" + strFieldName + "\">";
                                                }
                                                con1.addData("PROJECT_CODE", "String", strProjectCode);
                                                con1.addData("TABLE_CODE"  , "String", strTableLevel2);
                                                bolSuccessLv3 = con1.executeService(strContainerName, strClassName, "findFieldTableZoom");
                                                if(bolSuccessLv3){
                                                    strTableLv2 	 = con1.getHeader("FIELD_CODE");
                                                    strTableLv2Label = con1.getHeader("FIELD_LABEL");

                                                    strTag += "\n<input type=\"hidden\" name=\"FIELD_" + strFieldTableZoom + "_LV2\" value=\"" + strTableLv2 + "\">";
                                                    strTag += "\n<input type=\"hidden\" name=\"FIELD_" + strFieldTableZoom + "_LV2_LABEL\" value=\"" + strTableLv2Label + "\">";
                                                    strTag += "\n<input type=\"hidden\" name=\"FIELD_" + strFieldTableZoom + "_LV2_CODE\" value=\"" + strTableLevel2 + "\">";
                                                    strTag += "\n<input type=\"hidden\" name=\"FIELD_" + strTableLevel2 + "_LV3\" value=\"" + strFieldName + "\">";
                                                }
                                                strTag += "\n<input type=\"hidden\" name=\"FIELD_" + strFieldTableZoom + "\" value=\"" + strFieldName + "\">";
                                            }
                                            strConcatFieldName += "DSP_" + strFieldName + ",";
					}else if( strFieldType.equals( "LIST" ) ){
                                            
                                            String strListLength = "style=\"max-width:450px;\"";
                                            String strOnChangeEvent = "";
                                            
                                            if(strTableLevel.equals("1")){
                                                strOnChangeEvent = "onchange=\"get_table_level2('" + strFieldName + "','" + strFieldTableZoom + "')\"";
                                            }else if(strTableLevel.equals("2")){
                                                strOnChangeEvent = "onchange=\"get_table_level3('" + strFieldName + "','" + strFieldTableZoom + "')\"";
                                            }else{
                                                strOnChangeEvent = "";
                                            }
                                            
//                                            if(Integer.parseInt(strProjectCode, 10) <= 16 && strFieldName.equals("DOCUMENT_INDEX12")){
//                                                strListLength = "style=\"width:450px;max-width:450px;\"";
//                                            }
                                            
                                            strTag = "\n<select id=\"" + strFieldName + "\" name=\"" + strFieldName + "\" class=\"combobox\" defaultValue=\"" + strDefaultValue + "\" value_type=\"list\" is_PK=\"" + strIsPK + "\" is_NotNull=\"" + strIsNotNull + "\" " + strListLength  + " onKeypress=\"field_press( this );\" " + strOnChangeEvent + ">";
                                            strTag += "\n<option value=\"\"></option>";

                                            String strZoomDisplayValue = "";
                                            String strZoomDisplayText  = "";

                                        if(strTableLevel.equals("1")){
                                            con1.addData( "TABLE_ZOOM" , "String" , strFieldTableZoom );
                                            boolean bolnZoomSuccess = con1.executeService( strContainerName , strClassName , "findTableCode" );
                                            if( bolnZoomSuccess ){
                                                while( con1.nextRecordElement() ){
                                                    strZoomDisplayValue = con1.getColumn( strFieldTableZoom );
                                                    strZoomDisplayText  = con1.getColumn( strFieldTableZoom + "_NAME" );

                                                    if( strZoomDisplayValue.equals( strDefaultValue ) ){
                                                        strSelected = " selected";
                                                    }else{
                                                        strSelected = "";
                                                    }
                                                    strTag += "\n<option value=\"" + strZoomDisplayValue + "\"" + strSelected + ">" + strZoomDisplayText + "</option>";
                                                }
                                            }
                                        }else{
                                            strTag += "\n<option value=\"\">&nbsp;</option>";
                                        }

                                            strTag += "\n</select>\n";
                                            strTag += "\n<input type=\"hidden\" id=\"" + strFieldName + "_TABLEZOOM\" name=\"" + strFieldName + "_TABLEZOOM\" value=\"" + strFieldTableZoom + "\">\n";
                                            
                                            if(strTableLevel.equals("2")){
                                                strTag += "\n<input type=\"hidden\" id=\"" + strFieldName + "_TABLELEVEL1\" name=\"" + strFieldName + "_TABLELEVEL1\" value=\"\">\n";
                                            }else if(strTableLevel.equals("3")){
                                                strTag += "\n<input type=\"hidden\" id=\"" + strFieldName + "_TABLELEVEL2\" name=\"" + strFieldName + "_TABLELEVEL2\" value=\"\">\n";
                                            }
					}
%>
                                            <tr> 
                                                <td> <%=strCheckbox %> 
                                                     <%=strPrefix %> 
                                                     <span id="<%=strFieldName%>_span"><%=strFieldLabel %></span> 
                                                </td>
                                            </tr>
                                            <tr> 
                                                <td><%=strTag %></td>
                                            </tr>
<%					
                                if( strFieldType.equals( "CHAR" )||strFieldType.equals( "NUMBER" )||strFieldType.equals( "CURRENCY" )||strFieldType.equals( "MEMO" ) ){
                                    strXML += "<Item>";
                                    strXML += "<name>" + strFieldName + "</name>";
                                    strXML += "<description>" + strFieldLabel + "</description>";
                                    strXML += "</Item>";	
                                }
                            }

                            if( strConcatFieldName.length() > 0 ){
                                strConcatFieldName = strConcatFieldName.substring( 0 , strConcatFieldName.length() - 1 );
                            }
			}				
%>			            
                                            <tr> 
                                                <td>&nbsp;</td>
                                            </tr>	
                                        </table>
                                    </div>
                                    <!-- --------------------------------- End Document Index -------------------------------------------- -->    
                                </td>
                            </tr>
                        </table>
                    </td>
                    <td valign="top" style="border: 1px solid #FFF"> <!-- column2 -->
                        <table width="100%" border="0" cellpadding="0" cellspacing="0" >
                            <tr>
                                <td align="top">
                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr> 
                                            <td background="images/tab_img_04.jpg"><img src="images/tab_img_doc.gif" width="128" height="21"></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td valign="top">
                                    <!-- ----------------------------------- Document Type ------------------------------------------------------- -->    
                                    <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0" class="label_bold3">
                                        <tr height="25"><td>&nbsp;</td></tr>
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
				//String	strFileName	= "";
				int 	idx		= 1;
				
				while(con.nextRecordElement()){
                                    strUserLevelTmp = "0";
                                    strPermitUsers 	= "";

                                    strDocTypeName  = con.getColumn("DOCUMENT_TYPE_NAME");
                                    strDocType      = con.getColumn("DOCUMENT_TYPE");
                                    strAccessType   = con.getColumn("ACCESS_TYPE");
                                    strNewVersion   = con.getColumn("NEW_VERSION");
                                    strVersionLimit = con.getColumn("VERSION_LIMIT");
                                    strDocUserLevel = con.getColumn("USER_LEVEL");
                                    strFileSizeFlag = con.getColumn("LIMIT_SIZE_FLAG");
                                    strFileTypeFlag = con.getColumn("LIMIT_FILE_TYPE_FLAG");
                                    strFileSize     = con.getColumn("LIMIT_SIZE");
                                    strFileType     = con.getColumn("FILE_TYPE");
                                    //strFileName     = con.getColumn("FILE_NAME");

                                    if(strAccessType.equals("")){
                                        strAccessType = "A";
                                    }					
                                    if(strVersionLimit.equals("")){
                                        strVersionLimit="0";
                                    }					
                                    if(!strAccessType.equals("A")){
                                        if(strAccessType.equals("L")){
                                            strUserLevelTmp = strDocUserLevel;

                                            if(strUserLevelTmp.equals("")){
                                                strUserLevelTmp = "0";
                                            }
                                        }else if(strAccessType.equals("U")){
                                            con1.addData( "PROJECT_CODE" , "String" , strProjectCode );
                                            con1.addData( "DOCUMENT_TYPE" , "String" , strDocType );
                                            boolean	bolnUserSuccess = con1.executeService( strContainerName , "DOCUMENT_TYPE" , "findDocumentTypeUser" );
                                            if( bolnUserSuccess ){	
                                                while(con1.nextRecordElement()){
                                                    strPermitUsers += con1.getColumn("USER_ID") + ",";
                                                }						    	
                                                if(strPermitUsers.length() > 0){
                                                    strPermitUsers = strPermitUsers.substring(0,strPermitUsers.length()-1);
                                                }
                                            }
                                        }
                                    }
%>
                                        <tr id="doc_row<%=idx %>" style="display:none;">
                                            <td>
                                                <table width="500" border="0" align="left" cellpadding="0" cellspacing="0" class="label_bold2" style="margin-left: 15px;">
                                                    <tr>
                                                        <td><img id="doc<%=idx %>" src="images/doc.gif" width="27" height="23" align="middle">
                                                             <span id="div_header<%=idx %>" style="height: 30px;cursor: pointer" class="label_bold2" onclick="div_click('div_doc_type<%=idx %>','doc',<%=idx %>)" style="cursor:pointer"><%=strDocTypeName %></span> 
                                                             <span name="PICT_CNT" id="PICT_CNT<%=strDocType %>" style="height: 30px" class="label_bold2"></span>&nbsp;
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <div  style="padding-left: 10px;padding-bottom:2px;border-bottom: dotted 1px #0e80a9">
                                                                <label id="btt_clip01<%=idx %>" 
                                                                    style="height:20px;cursor:pointer;padding-right: 3px;"><a href="#" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('i_attach<%=idx %>','','images/i_attach_over.gif',1)"><img name="i_attach<%=idx %>" 
                                                                    src="images/i_attach.gif"  width="25" height="25" border="0" align="textmiddle" 
                                                                    onclick="openAddEditView('<%=strDocType%>','<%=strFileSizeFlag %>','<%=strFileSize %>','<%=strFileTypeFlag %>','<%=strFileType %>')" title="<%=lb_tooltip_attach %>"></a></label><label id="clear_<%=strDocType %>" 
                                                                    style="height: 20px;display:none;cursor:pointer;padding-right: 3px;"><a href="#" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('i_delete<%=idx %>','','images/i_delete_over.gif',1)"><img name="i_delete<%=idx %>" 
                                                                    src="images/i_delete.gif" width="25" height="25" border="0" align="textmiddle" 
                                                                    onclick="event.cancelBubble=true;delete_doctype('<%=strDocTypeName %>','<%=strDocType %>')" title="<%=lb_tooltip_delete %>"></a></label><label id="paste_<%=strDocType %>" 
                                                                    style="height: 20px;display:inline;cursor:pointer;padding-right: 3px;"><a href="#" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('i_paste<%=idx %>','','images/i_paste_over.gif',1)"><img name="i_paste<%=idx %>" 
                                                                    src="images/i_paste.gif" width="25" height="25" border="0" align="textmiddle" 
                                                                    onclick="event.cancelBubble=true;pasteBlobPict('<%=strDocType %>')" title="<%=lb_tooltip_paste %>"></a></label><label id="copy_<%=strDocType %>" 
                                                                    style="height: 20px;display:none;cursor:pointer;padding-right: 3px;"><a href="#" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('i_cut<%=idx %>','','images/i_cut_over.gif',1)"><img name="i_cut<%=idx %>" 
                                                                    src="images/i_cut.gif" width="25" height="25" border="0" align="textmiddle" 
                                                                    onclick="event.cancelBubble=true;copyBlobPict('<%=strDocType %>')" title="<%=lb_tooltip_cut %>"></a></label>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td style="padding-top: 10px;padding-bottom: 10px">
                                                            <div id="div_doc_type<%=idx %>" style="display:none">
                                                                <div align="left">
                                                                    <div class="roundcont">
                                                                        <div class="roundtop"> 
                                                                            <div align="left">
                                                                                <img src="images/tl.gif" width="6" height="6" class="corner" style="display: none" /> 
                                                                            </div>
                                                                        </div>
                                                                        <table width="97%" border="0" align="center" cellpadding="0" cellspacing="0" class="label_bold2">    
                                                                            <tr> 
                                                                                <td width="100"><%=lb_doc_attach %></td>
                                                                                <td> 
                                                                                    <input name="BLOB_ID<%=strDocType %>" type="text" class="input_box_disable" value="" size="40" readonly />
                                                                                    &nbsp;<%=lb_attach_count %>
                                                                                    <input name="BLOB_PART<%=strDocType %>" type="text" class="input_box_disable" value="0" size="5" style="text-align: right" readonly />
                                                                                    <input name="PICT_INIT<%=strDocType %>" type="hidden" value=""> 
                                                                                </td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td><%=lb_file_type %></td>
                                                                                <td> 
                                                                                    <input name="FILE_TYPE<%=strDocType %>" type="text" class="input_box_disable" value="" size="45" readonly />
                                                                                    <% if(!strFileType.equals("")){ %>
                                                                                    <img src="images/notice.jpg" title="<%=strFileType %>" align="absmiddle">
                                                                                    <% } %>
                                                                                    <input name="FILE_TYPE_FILTER<%=strDocType %>" type="hidden" value="<%=strFileType %>" />
                                                                                    <input name="FILE_TYPE_FLAG<%=strDocType %>" type="hidden" value="<%=strFileTypeFlag %>" />
                                                                                    <input name="FILE_SIZE_FILTER<%=strDocType %>" type="hidden" value="<%=strFileSize %>" />
                                                                                    <input name="FILE_SIZE_FLAG<%=strDocType %>" type="hidden" value="<%=strFileSizeFlag %>" />
                                                                                </td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td><%=lb_file_name %></td>
                                                                                <td> 
                                                                                    <input name="FILE_NAME<%=strDocType %>" type="text" class="input_box_disable" value="" size="59" readonly />
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                        <br>
                                                                        <div class="roundbottom">
                                                                            <div align="left">
                                                                                <img src="images/bl.gif" width="6" height="6" class="corner" style="display: none" /> 
                                                                            </div>
                                                                        </div>
                                                                    </div>													
                                                                </div>
                                                            </div>
                                                            <input type="hidden" name="DOCUMENT_LEVEL<%=strDocType %>" value="<%=strUserLevelTmp %>"> 
                                                            <input type="hidden" name="VERSION_LIMIT<%=strDocType %>"  value="<%=strVersionLimit %>">
                                                            <input type="hidden" name="NEW_VERSION<%=strDocType %>"    value="<%=strNewVersion %>">
                                                            <input type="hidden" name="DOCUMENT_TYPE<%=strDocType %>"  value="<%=strDocType %>">
                                                            <input type="hidden" name="USED_SIZE_ARG<%=strDocType %>"  value="">
                                                            <input type="hidden" name="XML_TAG<%=strDocType %>" 	   value="">
                                                            <input type="hidden" name="DOCTYPE_CODE<%=idx%>"  value="<%=strDocType %>">
                                                        </td>
                                                    </tr>
                                                </table>
<script type="text/javascript">
<!--
	
<%	
	if(strAccessType.equals("L")){
		if(Integer.parseInt(strUserLevel) >= Integer.parseInt(strUserLevelTmp)){ 
%>
			doc_row<%=idx %>.style.display = "inline";
<%		} 
	}else if(strAccessType.equals("U")){
		if(strPermitUsers.indexOf(strUserId) != -1){ 
%>
			doc_row<%=idx %>.style.display = "inline";
<%		} 
	}else {
%>
		doc_row<%=idx %>.style.display = "inline";
<%	}
%>	
	
//-->
</script> 
                                            </td>
                                        </tr>
<%					idx++;
				}	
%>
                                        <tr>
                                            <td>
                                                <input type="hidden" name="TOTAL_DOCUMENT" value="<%=idx-1%>">
                                            </td>
                                        </tr>
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
        </td>
    </tr>
</table>
<input type="hidden" id="hidDocTypeMove"  name="hidDocTypeMove"  value="" >
<input type="hidden" id="hidBlobMove"     name="hidBlobMove"     value="" >
<input type="hidden" id="hidPictMove"     name="hidPictMove"     value="" >
<input type="hidden" id="hidFileTypeMove" name="hidFileTypeMove" value="" >
<input type="hidden" id="hidFileNameMove" name="hidFileNameMove" value="" >
<input type="hidden" id="hidBlobSizeMove" name="hidBlobSizeMove" value="" >

<input type="hidden" name="screenname" value="<%=screenname%>">
<input type="hidden" name="user_role"  value="<%=user_role%>">
<input type="hidden" name="app_group"  value="<%=app_group%>">
<input type="hidden" name="app_name"   value="<%=app_name%>">

<input type="hidden" name="PERMIT_FUNCTION" value="<%=strPermission%>">

<input type="hidden" name="CONCAT_FIELD_NAME" value="<%=strConcatFieldName %>">
<input type="hidden" name="DOCUMENT_FIELD_INSERT">
<input type="hidden" name="DOCUMENT_VALUE_INSERT">
<input type="hidden" name="DOCUMENT_VALUE_DUPLICATE">
<input type="hidden" name="TEXT_INDEX">
<input type="hidden" name="CONCAT_CHECKBOX">
<input type="hidden" name="METHOD" value="<%=strMethod%>">

<input type="hidden" name="CONCAT_DOCUMENT_TYPE">
<input type="hidden" name="CONCAT_DOCUMENT_LEVEL">
<input type="hidden" name="CONCAT_VERSION_LIMIT">
<input type="hidden" name="CONCAT_NEW_VERSION">
<input type="hidden" name="CONCAT_BLOBID">
<input type="hidden" name="CONCAT_BLOBPART">
<input type="hidden" name="CONCAT_USED_SIZE_ARG">
<input type="hidden" name="CONCAT_XML_TAG">
<input type="hidden" name="CONCAT_FILE_TYPE">
<input type="hidden" name="CONCAT_FILE_NAME">

<input type="hidden" name="CURRENT_DOC">
</form>
<form name="formLog">
<input type="hidden" name="PROJECT_CODE">
<input type="hidden" name="BATCH_NO">
<input type="hidden" name="DOCUMENT_RUNNING">
<input type="hidden" name="ACTION_FLAG" value="A">
</form>     
<form name="formEdit" action="edit_document1.jsp" method="post">
<input type="hidden" name="screenname" value="<%=lc_edit_delete_document %>">
<input type="hidden" name="user_role"  value="<%=user_role%>">
<input type="hidden" name="app_group"  value="<%=app_group%>">
<input type="hidden" name="app_name"   value="EDIT_DOCUMENT">
</form>
<iframe name="frameLog"  style="display:none"></iframe>
<iframe scrolling="no" frameborder="0" name="inetdocview" src="/jinetdocarchive/imageproxy?codetype=applet&version=15&securecode=<%=securecode%>" width="32" height="32" marginwidth="0">
</iframe>
<OBJECT id="edasimport" name="edasimport" classid="clsid:2F630065-CA62-4779-8E21-FA8868E4FD1E"  VIEWASTEXT></OBJECT>
</body>
</html>
<%
strXML += "</Fields>";
%>
<script language="JavaScript">
var strXml = '<%=strXML%>';
var strXmlTemplate = "";
//alert( strXml );
</script>
