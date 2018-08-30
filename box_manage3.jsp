<%@page import="com.scc.edms.conf.ImageConfUtil"%>
<%@ page contentType="text/html; charset=tis-620"%>
<%@ page import="com.scc.security.UserInfo"%>
<%@ include file="inc/checkUser.jsp" %>
<%@ include file="inc/constant.jsp" %>
<%@ include file="inc/label.jsp" %>
<%@ include file="inc/utils.jsp" %>
<jsp:useBean id="con" scope="session" class="edms.cllib.EABConnector"/>
<jsp:useBean id="con2" scope="session" class="edms.cllib.EABConnector"/>
<%
    String securecode = "";
    con.setRemoteServer("EAS_SERVER");
    con2.setRemoteServer("EAS_SERVER");

    if (!con.executeService("EASSYSTEM", "SECURECODE", "genSecurityCode")){
        out.println("Create Image Login Session Fail");
        return;
    }
    securecode = con.getHeader("SECURECODE");
    
%>
<%
    UserInfo userInfo = (UserInfo)session.getAttribute( "USER_INFO" );
    String strProjectCode = userInfo.getProjectCode();
    String strProjectName = userInfo.getProjectName();
    String strUserName    = userInfo.getUserName();
    String strUserLevel   = userInfo.getUserLevel();

    String strMethod = request.getParameter( "METHOD" );
    String screenname  = getField(request.getParameter("screenname"));

    String user_role  = checkNull(request.getParameter("user_role"));
    String app_group  = checkNull(request.getParameter("app_group"));
    String app_name   = checkNull(request.getParameter("app_name"));

    if(strMethod == null){
            strMethod = "";
    }

    String strYearData 	  = checkNull(request.getParameter( "YEAR" ));
    String strBoxSeqnData = checkNull(request.getParameter( "BOX_SEQN" ));

    String strBoxNoData       = "";
    String strOpenBoxDateData = "";
    String strExpireDateData  = "";
    String strBoxLabelData    = "";
	
    String strBatchNo 	      = checkNull(request.getParameter( "BATCH_NO" ));
    String strDocumentRunning = checkNull(request.getParameter( "DOCUMENT_RUNNING" ));

    String strConcatDeleteBatchNo	  = checkNull( request.getParameter( "CONCAT_DELETE_BATCH_NO" ) );
    String strConcatDeleteDocumentRunning = checkNull( request.getParameter( "CONCAT_DELETE_DOCUMENT_RUNNING" ) );

    String strPageNumber = checkNull(request.getParameter("PAGENUMBER"));
    String strPageSize   = checkNull(request.getParameter("PAGE_SIZE"));
    String strTotalPage  = "1";	
    String strTotalSize  = "0";

    String strDeleteBatchNo[] , strDeleteDocumentRunning[];
	
    String strClassName = "BOX_MANAGE";
    String strErrorMessage = "";
    String strFieldType = "";
    String strFieldCode = "";
    String strTableZoom = "";

    String strSQLHeader    = "";
    String strSQLJoinTable = "";		

    String strConcatFieldIndex = "";
    String strConcatFieldType  = "";
    String strCurrentDate      = "";
    String strPermission      = "";

    String strContainerType = ImageConfUtil.getInetContainerType();
    String strVersionLang   = ImageConfUtil.getVersionLang();

    if( strVersionLang.equals("thai") ) {
        strCurrentDate = getServerDateThai();
    }else{
        strCurrentDate = getServerDateEng();
    }

    boolean bolSuccess 	      = false;
    boolean bolnDeleteSuccess     = false;
    boolean bolnSearchDataSuccess = false;

    if(strPageNumber.equals("")){
            strPageNumber = "1";
    }
    if(strPageSize.equals("")){
            strPageSize = "10";
    }
    
    con.addData("USER_ROLE", 	"String", user_role);
    con.addData("APPLICATION", 	"String", app_name);
    con.addData("APPLICATION_GROUP", "String", app_group);
    if(con.executeService(strContainerName, "DOCUMENT_TYPE", "findPermission")) {
        while(con.nextRecordElement()) {
            strPermission = con.getColumn("PERMIT_FUNCTION");
        }
    }

    String strWaterMarkFlag = "";

    con.addData("PROJECT_CODE", "String", strProjectCode);
    boolean bolnWaterMarkSuccess = con.executeService(strContainerName, "PROJECT_MANAGER", "findWaterMarkFlag");
    if(bolnWaterMarkSuccess){
            strWaterMarkFlag = con.getHeader("WATERMARK_FLAG");
    }else{
            strWaterMarkFlag = "N";
    }

    con.addData("PROJECT_CODE", "String", strProjectCode);
    con.addData("INDEX_TYPE", 	"String", "S");
    boolean bolFieldSuccess = con.executeService(strContainerName, "EDIT_DOCUMENT", "findDocumentIndex");


    if( strMethod.equals( "DELETE" ) ){

            con.addData( "PROJECT_CODE" 	, "String" , strProjectCode );

            strDeleteBatchNo = strConcatDeleteBatchNo.split( "</>" );
            strDeleteDocumentRunning = strConcatDeleteDocumentRunning.split( "</>" );

            if( strConcatDeleteBatchNo.length() > 0 ){

                    for( int intArr = 0 ; intArr < strDeleteBatchNo.length ; intArr++ ){
                            con.addData( "DETAIL." + ( intArr + 1 ) + ".BATCH_NO" 		  , "String" , strDeleteBatchNo[ intArr ] );
                            con.addData( "DETAIL." + ( intArr + 1 ) + ".DOCUMENT_RUNNING" , "String" , strDeleteDocumentRunning[ intArr ] );
                    }
            }

            bolnDeleteSuccess = con.executeService( strContainerName , strClassName , "deleteBoxDetail" );

            if( !bolnDeleteSuccess ){
                    strErrorMessage = lc_can_not_delete_data;
            }
    }

    con.addData( "PROJECT_CODE"  , "String" , strProjectCode);
    con.addData( "YEAR" 	 	 , "String" , strYearData);
    con.addData( "BOX_SEQN" 	 , "String" , strBoxSeqnData);
    
    bolnSearchDataSuccess = con.executeService( strContainerName , strClassName , "findBoxManage"  );
    if( !bolnSearchDataSuccess){
    	strErrorMessage = con.getRemoteErrorMesage();
    }else{
    	strBoxNoData 		= con.getHeader("BOX_NO");
    	strBoxLabelData 	= con.getHeader("BOX_LABEL");
    	strOpenBoxDateData 	= con.getHeader("OPEN_BOX_DATE");
    	strExpireDateData 	= con.getHeader("EXPIRE_DATE");
    }
    
    con.addData("PROJECT_CODE", "String", strProjectCode);
	con.addData("YEAR",	 		"String", strYearData);
	con.addData("BOX_SEQN", 	"String", strBoxSeqnData);
	con.addData("PAGESIZE", 	 "String", strPageSize);
    con.addData("PAGENUMBER", 	 "String", strPageNumber);
	
    bolSuccess = con.executeService(strContainerName, strClassName, "findBoxDetail");
    if(!bolSuccess) {
    	strErrorMessage = con.getRemoteErrorMesage();
    }else{
    	strTotalPage = con.getHeader( "PAGE_COUNT" );
        strTotalSize = con.getHeader( "TOTAL_RECORD" );
    }	
    
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=TIS-620">
<title><%=lc_system_name %> <%=lc_site_name%></title>
<link rel="shortcut icon" href="images/favicon/EDAS.ico" type="image/x-icon" />
<link href="css/edas.css" type="text/css" rel="stylesheet">
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
<script language="javaScript" type="text/javascript">
<!--

var sccUtils = new SCUtils();
var offUtils = new offlineUtils();
var waterMk  = new waterMark();

var objDetailScanWindow;
var objLinkWindow;
var objDocumentDetail;

function click_cancel(  ){
    form1.action 	 = "box_manage1.jsp";
    form1.target 	 = "_self";
    form1.MODE.value = "SEARCH";
    form1.PAGENUMBER.value = "1";
    form1.submit();

}

function click_add(){
	//check index
	var check_field = <%=bolFieldSuccess%>;
	
	if(!check_field){
		showMsg( 0 , 0 , "<%=lc_not_set_search_field.replaceAll( "\"" , "&quot;" )%>" );
		return;
	}
//        var concat_box = form1.CONCAT_BOX_DETAIL.value;
	
	var strUrl  = "box_manage4.jsp?screenname=<%=screenname%>&YEAR=<%=strYearData%>&BOX_SEQN=<%=strBoxSeqnData%>"
                    + "&user_role=<%=user_role%>&app_name=<%=app_name%>&app_group=<%=app_group%>"; //&CONCAT_BOX_DETAIL=" + concat_box;
	objLinkWindow = sccUtils.openChildWindow( "BOX_DETAIL" );
	objLinkWindow.location = strUrl;
}

function click_delete(){
	var objCheckboxDelete = form1.CHECK_DELETE;
	var objLabelDelete 	  = null;
	var bolnCheck 		  = false;
	
	var strConcatBatchno 	 	 = "";
	var strConcatDocumentRunning = "";
	
	if( objCheckboxDelete == null ){
		alert(lc_cannot_find_del_data);
		document.getElementById("CHECK_ALL").checked = false;
		return;
	}

	if( objCheckboxDelete.length ){
		for( var intCount = 0 ; intCount < objCheckboxDelete.length ; intCount++ ){
			bolnCheck = bolnCheck || objCheckboxDelete[ intCount ].checked;

			if( objCheckboxDelete[ intCount ].checked ){

				objLabelDelete = eval( "DEL_FLAG" + intCount );

				if( objLabelDelete ){
					strConcatBatchno 	 += objLabelDelete.getAttribute("BATCH_NO") + "</>";
					strConcatDocumentRunning += objLabelDelete.getAttribute("DOCUMENT_RUNNING") + "</>";
				}
			}
		}

		if(strConcatBatchno.length == 0){
			alert(lc_check_del_link);
			return;
		}

		if( strConcatBatchno.length > 0 ){
			strConcatBatchno = strConcatBatchno.substr( 0 , strConcatBatchno.length - "</>".length );
		}
		if( strConcatDocumentRunning.length > 0 ){
			strConcatDocumentRunning = strConcatDocumentRunning.substr( 0 , strConcatDocumentRunning.length - "</>".length );
		}
		
	}else{
		bolnCheck = objCheckboxDelete.checked;

		objLabelDelete = eval( "DEL_FLAG0" );

		if( objLabelDelete ){
                    strConcatBatchno         = objLabelDelete.getAttribute("BATCH_NO");
                    strConcatDocumentRunning = objLabelDelete.getAttribute("DOCUMENT_RUNNING");
		}
	}

	if( bolnCheck ){
		if( !showMsg( 0 , 1 , lc_confirm_delete ) ){
			return;
		}

		form1.CONCAT_DELETE_BATCH_NO.value 	   = strConcatBatchno;
		form1.CONCAT_DELETE_DOCUMENT_RUNNING.value = strConcatDocumentRunning;

		form1.METHOD.value = "DELETE";
		form1.method 	   = "post";
		form1.action	   = "box_manage3.jsp";
		form1.submit();
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


function open_detail( row_obj){
	var batch_no 	= row_obj.getAttribute("BATCH_NO");
	var doc_running = row_obj.getAttribute("DOCUMENT_RUNNING");
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

function open_clip( strProjectCode , strBatchno , strDocumentRunning ){
	
	if( frameHidden.form1 ){
		frameHidden.form1.PROJECT_CODE.value	 = strProjectCode;
		frameHidden.form1.BATCH_NO.value	 = strBatchno;
		frameHidden.form1.DOCUMENT_RUNNING.value = strDocumentRunning;

		formORABCS.PROJECT_CODE.value	  = strProjectCode;
		formORABCS.BATCH_NO.value	  = strBatchno;
		formORABCS.DOCUMENT_RUNNING.value = strDocumentRunning;

		frameHidden.form1.submit();
	}
}

function openDetailScan( strProjectCode , strBatchno , strDocumentRunning ){
	var strUrl = "../detail_scan.jsp?projectcode=" + strProjectCode + "&batchno=" + strBatchno + "&docrun=" + strDocumentRunning;
	objDetailScanWindow = sccUtils.openPopWindow( strUrl , "DETAIL_SCAN"  , 225 , 435 );
	objDetailScanWindow.focus();
}

function openShowView( strBlobId , strBlobPart ){
    initAndShow();
    setWaterMark();
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
    inetdocview.SetProperty("RemoveToolBar", permit);
    inetdocview.SetProperty("RemoveToolBar", rem_toolbar);
    inetdocview.SetProperty("CloseWhenSave", "true");
    
}

function setWaterMark(){
    var wm_flag = "<%=strWaterMarkFlag %>";
    var av_time = getCurrentTime();
    
    if(wm_flag != 'N'){
        waterMk.setWaterMark( wm_flag, "<%=strUserName %>", "<%=dateToDisplay(strCurrentDate, "/")%>", av_time + " ¹." );
    }
}

function retrieveImage( strBlobId, strBlobPart ){
    
    if ((strBlobId != "") && (strBlobPart != "")){
        inetdocview.Retrieve(strBlobId, strBlobPart);
    }
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

function window_onload() {

	lb_box_no.innerHTML 		= lbl_box_no;
    lb_box_label.innerHTML  	= lbl_box_label;
    lb_open_box_date.innerHTML  = lbl_open_box_date;
    lb_doc_expired.innerHTML  	= lbl_doc_expired;
	lb_field_seqn.innerHTML 	= lbl_field_seqn;
	lb_data.innerHTML   		= lbl_data;
	
//	check_inet_version();
	
	<%	if( !strErrorMessage.equals( "" ) && strMethod.equals("DELETE")){ %>
	
		showMsg( 0 , 0 , "<%=strErrorMessage.replaceAll( "\"" , "'" ).replaceAll( "\r" , "<br>" )%>" );
	<%
		}
	
		strMethod = "";
	
		if( bolnDeleteSuccess ){
	%>
	    showMsg( 0 , 0 , "<%=lc_delete_data_successfull%>" );
	<%
		}
	%> 
}

function window_onunload(){
	
	if( objLinkWindow != null && !objLinkWindow.closed ){
		objLinkWindow.close();
	}
	
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

//-->
</script>
</head>
<body onLoad="MM_preloadImages('images/btt_add_over.gif','images/btt_del_over.gif');window_onload()" onunload="window_onunload" >
<form name="form1" method="post" >
<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td height="25" class="label_header01" >
           	&nbsp;&nbsp;&nbsp;<%=screenname%> >> <%=lb_add_data %>
    	</td>
   	</tr>
   	<tr>
   		<td height="20"></td>
   	</tr>
   	<tr>
   		<td>
   			<table width="100%" border="0" cellpadding="0" cellspacing="0">
   				<tr>
   					<td width="100">&nbsp;&nbsp;<span id="lb_box_no" class="label_bold2"></span></td>
   					<td width="150"><input type="text" name="BOX_NO" class="input_box_disable" value="<%=strBoxNoData %>" size="10" readonly></td>
   					<td width="120"><span id="lb_box_label" class="label_bold2"></span></td>
   					<td><input type="text" name="BOX_LABEL" class="input_box_disable" value="<%=strBoxLabelData %>" size="50" readonly></td>
   				</tr>
   				<tr>
   					<td>&nbsp;&nbsp;<span id="lb_open_box_date" class="label_bold2"></span></td>
   					<td><input type="text" name="OPEN_BOX_DATE" class="input_box_disable" value="<%=dateToDisplay(strOpenBoxDateData,"/") %>" size="12" readonly></td>
   					<td><span id="lb_doc_expired" class="label_bold2"></span></td>
   					<td><input type="text" name="EXPIRE_DATE" class="input_box_disable" value="<%=dateToDisplay(strExpireDateData,"/") %>" size="12" readonly></td>
   				</tr>
   			</table>
   		</td>
   	</tr>
  	<tr> 
    	<td valign="top" align="center">
	    	<table width="98%" border="0" cellspacing="0" cellpadding="0">
		        <tr> 
		          <td> 
		          	<div align="center"><br>
		              	<table width="100%" border="0" cellpadding="0" cellspacing="0">
			                <tr class="hd_table"> 
			                 	<td width="10"><img src="images/hd_tb_01.gif" width="10" height="28"></td>
			                  	<td width="20" align="center">
			                  		<input id="CHECK_ALL" type="checkbox" onclick="check_select_all()">	
			                  	</td>
			                  	<td align="center" width="50"><span id="lb_field_seqn"></span></td> 
								<td align="center" width="100">DOC-NUM</td>
								<td align="center" width="*"><span id="lb_data"></span></td>
		                      	<td align="right" width="32">&nbsp;</td>
			                  	<td align="right" width="10"><img src="images/hd_tb_04.gif" width="10" height="28"></td>
			                </tr>
			            </table>
			            <table width="100%" border="0" cellpadding="0" cellspacing="0">    
<%
			if(!bolSuccess){
%>				
							<tr class="table_data1"> 
			                	<td colspan="7" align="center"><%=strErrorMessage %></td>
			                </tr>				
<% 				
			}else{
				
				int cnt 	= 0;
				int iPage 	= 0;
				
				iPage = Integer.parseInt(strPageNumber);
				
				String	strBatchNoData 		= "";
				String	strDocRunningData	= "";
				
				String	strDataValue 	= "";
				String  arrFieldIndex[] = null;
				String  arrFieldType[]  = null;
				
				while(con.nextRecordElement()){
					
					strBatchNoData 		= con.getColumn("BATCH_NO");
					strDocRunningData 	= con.getColumn("DOCUMENT_RUNNING");
                                        
                                        //strConcatBoxDetail += strBatchNoData; 
					
%>
							<tr class="table_data<%=(cnt%2)+1%>"> 
				                <td width="10" >&nbsp;</td>
				                <td width="25" ><div align="center">
				                      <input type="checkbox" name="CHECK_DELETE" onclick="check_not_select_all()">
				                      <label id="DEL_FLAG<%=cnt %>" BATCH_NO="<%=strBatchNoData %>" DOCUMENT_RUNNING="<%=strDocRunningData %>" ></label>
				                </div></td>
				                <td width="50" align="left">&nbsp;<%=((iPage-1)*10)+cnt+1 %></td>
				                <td width="100" align="center"><%=strBatchNoData %></td>
<%
							
							con2.addData("PROJECT_CODE", "String", strProjectCode);
							boolean bolSuccessField = con2.executeService(strContainerName, "MASTER_LINK", "findFieldManager");
							if(!bolSuccessField){
								strErrorMessage = con2.getRemoteErrorMesage();
							}else{
								int cntT = 0;
								
								strConcatFieldIndex = "";
								strConcatFieldType  = "";
								strSQLHeader		= "";
								strSQLJoinTable		= "";
								
								while(con2.nextRecordElement()){
									
									strFieldCode	= con2.getColumn("FIELD_CODE");
									strFieldType 	= con2.getColumn("FIELD_TYPE");    		
									strTableZoom 	= con2.getColumn("TABLE_ZOOM");
									
									if(strFieldType.equals("ZOOM")||strFieldType.equals("LIST")||strFieldType.equals("MONTH")||strFieldType.equals("MONTH_ENG")){
									//	strSQLHeader 	+= 	"," + strTableZoom + "." + strTableZoom + "_NAME";
										strSQLHeader 	+= 	",T" + cntT + "." + strTableZoom + "_NAME";
									//	strSQLJoinTable += 	" LEFT JOIN " + strTableZoom 
										strSQLJoinTable += 	" LEFT JOIN " + strTableZoom + " T" + cntT
														+ 	" ON(MASTER_SCAN_" + strProjectCode + "." + strFieldCode + "=" 
													//	+ 	strTableZoom + "." + strTableZoom + " )";
														+ 	"T" + cntT + "." + strTableZoom + " )";
										
										cntT++;
									}
									
									strConcatFieldType  += strFieldType + ",";
									
									if(strFieldType.equals("ZOOM")||strFieldType.equals("LIST")||strFieldType.equals("MONTH")||strFieldType.equals("MONTH_ENG")){
										strFieldCode = strTableZoom + "_NAME";
									}
									
									strConcatFieldIndex +=  strFieldCode + ",";
									
								}    	     
							}

							strDataValue = "";

							con2.addData("PROJECT_CODE", 			"String", strProjectCode);
							con2.addData("QUERY_HEADER", 			"String", strSQLHeader);
							con2.addData("JOIN_TABLE", 				"String", strSQLJoinTable);
							con2.addData("BATCH_NO_LINK", 			"String", strBatchNoData);
							con2.addData("DOCUMENT_RUNNING_LINK",	"String", strDocRunningData);
							
							boolean bolSuccessLink = con2.executeService(strContainerName, "MASTER_LINK", "findLinkData");
							if(bolSuccessLink){
								
								if(strConcatFieldIndex.length() > 0){
									strConcatFieldIndex = strConcatFieldIndex.substring(0,strConcatFieldIndex.length() - 1);
									arrFieldIndex = strConcatFieldIndex.split(",");
								}
								if(strConcatFieldType.length() > 0){
									strConcatFieldType = strConcatFieldType.substring(0,strConcatFieldType.length() - 1);
									arrFieldType 	   = strConcatFieldType.split(",");
								}
								
								for(int idx=0; idx< arrFieldIndex.length; idx++){
									
									if(arrFieldType.equals("DATE")||arrFieldType.equals("DATE_ENG")){
										strDataValue += dateToDisplay(con2.getHeader(arrFieldIndex[idx]),"/") + " ";
									
									}else if(arrFieldType.equals("TIN")){
										strDataValue += "<script> document.write(sccUtils.maskTIN('" + con2.getHeader(arrFieldIndex[idx]) + "'));</script>" + " ";
									
									}else if(arrFieldType.equals("PIN")){
										strDataValue += "<script> document.write(sccUtils.maskPIN('" + con2.getHeader(arrFieldIndex[idx]) + "'));</script>" + " ";
									
									}else{
										strDataValue += con2.getHeader(arrFieldIndex[idx]) + " ";
									}
								}
								
							}else{
								strDataValue = lc_data_deleted;
							}
%>				                
				                <td width="*"  align="left"><%=strDataValue %></td>				        
							    <td width="16"><div align="center">
							    <% if(bolSuccessLink){%>
										<a href="#" onclick="open_detail(this)" PROJECT_CODE="<%=strProjectCode %>" PROJECT_NAME="<%=strProjectName %>" BATCH_NO="<%=strBatchNoData %>" DOCUMENT_RUNNING="<%=strDocRunningData %>" ><img src="images/page_detail.gif" name="detail<%=cnt+1 %>" width="16" height="16" border="0" style="cursor:pointer;" title="<%=lb_detail %>"></a>
								<%	} %>			
									</div></td>
									<td width="16" align="right">
									<%
										con2.addData("PROJECT_CODE", 	 "String", strProjectCode);
										con2.addData("BATCH_NO", 	 "String", strBatchNoData);
										con2.addData("DOCUMENT_RUNNING", "String", strDocRunningData);
										
										boolean bolSuccessAttch = con2.executeService(strContainerName, "EDIT_DOCUMENT", "hasAttach");
										if(bolSuccessAttch){
									%>	
										<a href="javascript:open_clip('<%=strProjectCode %>','<%=strBatchNoData %>','<%=strDocRunningData %>')"><img src="images/page_attach.gif" name="attach<%=cnt+1 %>" width="16" height="16" border="0" style="cursor:pointer;" title="<%=lb_attachment %>"></a>
					                <%	} %>
					                </td>
					            	<td width="10">&nbsp;</td>
			                	</tr>		                            
<%					cnt++;					             
				}
			}
%>			                
              				</table>
              				<table width="100%" border="0" cellpadding="0" cellspacing="0" class="footer_table">
			                	<tr> 
				                  	<td width="156"><%=lb_total_record %> <%=strTotalSize %> <%=lb_records %></td>
					              	<td width="477"><div align="right"><%=lb_page_no %> <%=strPageNumber %>/<%=strTotalPage %></div></td>
					              	<td width="137">
						              	<img src="images/first.gif" width="22" height="22" onclick="click_navigator('first')" style="cursor:pointer"> 
						                <img src="images/prv.gif" 	width="22" height="22" onclick="click_navigator('prev')" style="cursor:pointer"> 
						                <img src="images/next.gif" 	width="22" height="22" onclick="click_navigator('next')" style="cursor:pointer"> 
						                <img src="images/last.gif" 	width="22" height="22" onclick="click_navigator('last')" style="cursor:pointer">
				                	</td>
			                	</tr>
			              	</table>
              			</div>
            		</td>
        		</tr>
        		<tr><td height="25"></td></tr>
        		<tr>
        			<td align="center">
        			<a href="javascript:click_add()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('add','','images/btt_add_over.gif',1)"><img src="images/btt_add.gif" name="add" width="67" height="22" border="0" ></a>
        			<a href="javascript:click_delete()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('del','','images/btt_del_over.gif',1)"><img src="images/btt_del.gif" name="del" width="67" height="22" border="0" ></a>
        			<a href="javascript:click_cancel()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('cancel','','images/btt_cancel_over.gif',1)"><img src="images/btt_cancel.gif" name="cancel" width="67" height="22" border="0"></a>
        			</td>
        		</tr>
      		</table>
    	</td>
    </tr>
</table>
<input type="hidden" name="screenname"  value="<%=screenname%>">
<input type="hidden" name="user_role" 	value="<%=user_role%>">
<input type="hidden" name="app_group" 	value="<%=app_group%>">            
<input type="hidden" name="app_name" 	value="<%=app_name%>">

<input type="hidden" name="YEAR" 	 value="<%=strYearData%>">
<input type="hidden" name="BOX_SEQN" value="<%=strBoxSeqnData%>">
  	
<input type="hidden" name="PROJECT_CODE_NEW" />
<input type="hidden" name="PROJECT_NAME_NEW" />

<input type="hidden" name="PAGENUMBER" value="<%=strPageNumber%>">
<input type="hidden" name="TOTALPAGE"  value="<%=strTotalPage%>">

<input type="hidden" name="PERMIT_FUNCTION" value="search,prnImg,link,export">

<input type="hidden" name="BATCH_NO" 		 value="<%=strBatchNo %>" />
<input type="hidden" name="DOCUMENT_RUNNING" value="<%=strDocumentRunning %>" />

<input type="hidden" name="METHOD" />
<input type="hidden" name="MODE" />
<input type="hidden" name="CONCAT_DELETE_BATCH_NO" />
<input type="hidden" name="CONCAT_DELETE_DOCUMENT_RUNNING" />

<!--<input type="hidden" name="CONCAT_BOX_DETAIL" value="<%--=strConcatBoxDetail--%>"/>-->

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
<iframe name="frameHidden" src="inc/openClip.jsp" width="0" height="0"></iframe>
<iframe name="frameOffline" style="display:none"></iframe>
<iframe scrolling="no" frameborder="0" name="inetdocview" src="/jinetdocarchive/imageproxy?codetype=applet&version=15&securecode=<%=securecode%>" width="32" height="32" marginwidth="0">
</iframe>
</body>
</html>