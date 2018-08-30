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
    String strUserId 	  = userInfo.getUserId();
    String strUserName 	  = userInfo.getUserName();
    String strProjectCode = userInfo.getProjectCode();
    String strUserLevel   = userInfo.getUserLevel();
    String strUserEmail   = checkNull(session.getAttribute("USER_EMAIL"));

    String strBatchNo 	  = checkNull(request.getParameter( "BATCH_NO" ));
    String strDocumentRunning = checkNull(request.getParameter( "DOCUMENT_RUNNING" ));
    
    String user_role     = getField(request.getParameter("user_role"));
    String app_name      = getField(request.getParameter("app_name"));
    String app_group     = getField(request.getParameter("app_group"));

    String strClassName 	= "MASTER_LINK";
    String strErrorMessage = "";

    String strFieldType = "";
    String strFieldCode = "";
    String strTableZoom = "";

    String strSQLHeader    = "";
    String strSQLJoinTable = "";		

    String strConcatFieldIndex = "";
    String strConcatFieldType  = "";
    String strWaterMarkFlag    = "";
    String strPermission       = "";

    String strCurrentDate  = "";
    String strContainerType = ImageConfUtil.getInetContainerType();
    String strVersionLang   = ImageConfUtil.getVersionLang();

    if( strVersionLang.equals("thai") ) {
        strCurrentDate = getServerDateThai();
    }else{
        strCurrentDate = getServerDateEng();
    }

    boolean bolSuccess = false;
    boolean bolnWaterMarkSuccess = false;
    
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

    con.addData("PROJECT_CODE", "String", strProjectCode);
    bolSuccess = con.executeService(strContainerName, strClassName, "findFieldManager");
    if(!bolSuccess){
    	strErrorMessage = con.getRemoteErrorMesage();
    	session.setAttribute( "ERROR_CODE" , "" );
        session.setAttribute( "ALERT_MESSAGE", lc_not_set_link_field);
        session.setAttribute( "REDIRECT_PAGE" , "" );
        response.sendRedirect( "inc/warning.jsp" );
    	return;
    }else{
    	int cnt = 0;    	
    	
    	while(con.nextRecordElement()){
    		
    		strFieldCode	= con.getColumn("FIELD_CODE");
    		strFieldType 	= con.getColumn("FIELD_TYPE");    		
    		strTableZoom 	= con.getColumn("TABLE_ZOOM");
  		
    		if(strFieldType.equals("ZOOM")||strFieldType.equals("LIST")||strFieldType.equals("MONTH")||strFieldType.equals("MONTH_ENG")){
    			strSQLHeader 	+= 	",T" + cnt + "." + strTableZoom + "_NAME";
    			strSQLJoinTable += 	" LEFT JOIN " + strTableZoom + " T" + cnt
    							+ 	" ON(MASTER_SCAN_" + strProjectCode + "." + strFieldCode + "=" 
							+ 	"T" + cnt + "." + strTableZoom + " )";
    			cnt++;    							
    		}
    		
    		strConcatFieldIndex +=  strFieldCode + ",";
    		
    	}    	     
    }
    
    con.addData("PROJECT_CODE", 	"String", strProjectCode);
	con.addData("BATCH_NO",	 		"String", strBatchNo);
	con.addData("DOCUMENT_RUNNING", "String", strDocumentRunning);
	
    bolSuccess = con.executeService(strContainerName, strClassName, "findMasterLink");
    if(!bolSuccess) {
    	strErrorMessage = con.getRemoteErrorMesage();
    }	
    
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=TIS-620">
<title><%=lc_data_link%></title>
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
var	objLinkWindow;
var objDocumentDetail;

function click_cancel(){
	window.open('','_self','');
    window.opener = self;
	window.close();
}

function open_project_link(){
	formLink.PROJECT_CODE_LINK.value = form1.PROJECT_CODE_NEW.value;
	formLink.PROJECT_NAME_LINK.value = form1.PROJECT_NAME_NEW.value;
	
	formLink.target = "_self";
	formLink.action = "link_document2.jsp";
	formLink.submit();
}

function open_detail( row_obj){
	var batch_no 	= row_obj.getAttribute("BATCH_NO");
	var doc_running = row_obj.getAttribute("DOCUMENT_RUNNING");
	var project_code = row_obj.getAttribute("PROJECT_CODE");
	var project_name = row_obj.getAttribute("PROJECT_NAME");
	
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
    var x,y,w,h, sessionId;
    var permit = set_inet_permission("<%=strPermission%>");
    x = screen.width /2;
    y = 0;
    w = screen.width;
    h = screen.height;
    inetdocview.Close();
    sessionId = inetdocview.Open();
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

function window_onload() {

	lb_doc_cabinet.innerHTML = lbl_doc_cabinet;
	lb_data_link.innerHTML   = lbl_data_link;
	
//	check_inet_version();
	
	<%	if( !strErrorMessage.equals( "" ) ){ %>
	//showMsg( 0 , 0 , "<%=strErrorMessage.replaceAll( "\"" , "'" ).replaceAll( "\r" , "" ).replaceAll( "\n" , "<br>" )%>" );
	<% 	}%>
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
    	<td valign="top" align="center">
	    	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		        <tr>
		        	<td width="30"></td> 
		          	<td> 
		          	<div align="left"><br>
		              	<table width="700" border="0" cellpadding="0" cellspacing="0">
			                <tr class="hd_table"> 
			                 	<td width="10"><img src="images/hd_tb_01.gif" width="10" height="28"></td>
			                  	<td align="center" width="150"><span id="lb_doc_cabinet"></span></td> 
								<td align="center" width="100">DOC-NUM</td>
								<td align="center" width="*"><span id="lb_data_link"></span></td>
		                      	<td align="right" width="16">&nbsp;</td>
		                      	<td align="right" width="16">&nbsp;</td>
			                  	<td align="right" width="10"><img src="images/hd_tb_04.gif" width="10" height="28"></td>
			                </tr>
			            </table>
			            <div style="width:auto;height:280px;overflow:auto">    
			            <table width="700" border="0" cellpadding="0" cellspacing="0">    
<%
			if(!bolSuccess){
%>				
							<tr class="table_data1"> 
			                	<td colspan="7" align="center"><%=strErrorMessage %></td>
			                </tr>				
<% 				
			}else{
				
				int cnt = 0;
				
				String	strProjectNameLinkData  = "";
				String	strProjectCodeLinkData 	= "";
				String	strBatchNoLinkData 		= "";
				String	strDocRunningLinkData	= "";
				
				String	strDataLink 	= "";
				String  arrFieldIndex[] = null;
				String  arrFieldType[]  = null;
				
				while(con.nextRecordElement()){
					
					strProjectCodeLinkData 	= con.getColumn("PROJECT_CODE_LINK");
					strProjectNameLinkData 	= con.getColumn("PROJECT_NAME");
					strBatchNoLinkData 	= con.getColumn("BATCH_NO_LINK");
					strDocRunningLinkData 	= con.getColumn("DOCUMENT_RUNNING_LINK");
					
%>
							<tr class="table_data<%=(cnt%2)+1%>"> 
				                <td width="10" >&nbsp;</td>
				                <td width="150" align="left">&nbsp;<%=strProjectNameLinkData %></td>
				                <td width="100" align="center"><%=strBatchNoLinkData %></td>
<%
							
							con2.addData("PROJECT_CODE", "String", strProjectCodeLinkData);
							boolean bolSuccessField = con2.executeService(strContainerName, strClassName, "findFieldManager");
							if(!bolSuccessField){
								strErrorMessage = con2.getRemoteErrorMesage();
							}else{
								
								int cnt2 = 0;
								
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
										strSQLHeader 	+= 	",T" + cnt2 + "." + strTableZoom + "_NAME";
									//	strSQLJoinTable += 	" LEFT JOIN " + strTableZoom 
										strSQLJoinTable += 	" LEFT JOIN " + strTableZoom + " T" + cnt2
														+ 	" ON(MASTER_SCAN_" + strProjectCodeLinkData + "." + strFieldCode + "=" 
													//	+ 	strTableZoom + "." + strTableZoom + " )";
														+ 	"T" + cnt2 + "." + strTableZoom + " )";
										cnt2++;
									}
									
									strConcatFieldType  += strFieldType + ",";
									
									if(strFieldType.equals("ZOOM")||strFieldType.equals("LIST")||strFieldType.equals("MONTH")||strFieldType.equals("MONTH_ENG")){
										strFieldCode = strTableZoom + "_NAME";
									}
									
									strConcatFieldIndex +=  strFieldCode + ",";
									
								}    	     
							}

							strDataLink = "";

							con2.addData("PROJECT_CODE", 			"String", strProjectCodeLinkData);
							con2.addData("QUERY_HEADER", 			"String", strSQLHeader);
							con2.addData("JOIN_TABLE", 				"String", strSQLJoinTable);
							con2.addData("BATCH_NO_LINK", 			"String", strBatchNoLinkData);
							con2.addData("DOCUMENT_RUNNING_LINK",	"String", strDocRunningLinkData);
							
							boolean bolSuccessLink = con2.executeService(strContainerName, strClassName, "findLinkData");
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
										strDataLink += dateToDisplay(con2.getHeader(arrFieldIndex[idx]),"/") + " ";
									
									}else if(arrFieldType.equals("TIN")){
										strDataLink += "<script> document.write(sccUtils.maskTIN('" + con2.getHeader(arrFieldIndex[idx]) + "'));</script>" + " ";
									
									}else if(arrFieldType.equals("PIN")){
										strDataLink += "<script> document.write(sccUtils.maskPIN('" + con2.getHeader(arrFieldIndex[idx]) + "'));</script>" + " ";
									
									}else{
										strDataLink += con2.getHeader(arrFieldIndex[idx]) + " ";
									}  	
								}
								
							}else{
								strDataLink = lc_data_deleted;
							}
		
%>				                
				                <td width="*"  align="left" ><%=strDataLink %></td>				        
							    <td width="16"><div align="center">
									<a href="#" onclick="open_detail(this)" PROJECT_CODE="<%=strProjectCodeLinkData %>" PROJECT_NAME="<%=strProjectNameLinkData %>" BATCH_NO="<%=strBatchNoLinkData %>" DOCUMENT_RUNNING="<%=strDocRunningLinkData %>" ><img src="images/page_detail.gif" name="detail<%=cnt+1 %>" width="16" height="16" border="0" style="cursor:pointer;" title="<%=lb_detail %>"></a>	
								</div></td>
								<td width="16" align="right">
								<%
										con2.addData("PROJECT_CODE", 		"String", strProjectCodeLinkData);
										con2.addData("BATCH_NO", 			"String", strBatchNoLinkData);
										con2.addData("DOCUMENT_RUNNING", 	"String", strDocRunningLinkData);
										
										boolean bolSuccessAttch = con2.executeService(strContainerName, "EDIT_DOCUMENT", "hasAttach");
										if(bolSuccessAttch){
								%>
									<a href="javascript:open_clip('<%=strProjectCodeLinkData %>','<%=strBatchNoLinkData %>','<%=strDocRunningLinkData %>')"><img src="images/page_attach.gif" name="attach<%=cnt+1 %>" width="16" height="16" border="0" style="cursor:pointer;" title="<%=lb_attachment %>"></a>
				                <% } %>
				                </td>
				            	<td width="10">&nbsp;</td>
		                	</tr>		                            
<%					cnt++;					             
				}
			}
%>			                
              				</table>
              				</div>
            			</div>
            		</td>
        		</tr>
        		<tr><td height="25" colspan="2"></td></tr>
        		<tr>
        			<td align="center" colspan="2">
        				<a href="javascript:click_cancel()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('cancel','','images/btt_cancel_over.gif',1)"><img src="images/btt_cancel.gif" name="cancel" width="67" height="22" border="0" ></a>
        			</td>
        		</tr>
      		</table>
    	</td>
    </tr>
</table>  	
<input type="hidden" name="PROJECT_CODE_NEW" />
<input type="hidden" name="PROJECT_NAME_NEW" />

<input type="hidden" name="BATCH_NO" 		 value="<%=strBatchNo %>" />
<input type="hidden" name="DOCUMENT_RUNNING" value="<%=strDocumentRunning %>" />

<input type="hidden" name="PERMIT_FUNCTION" value="prnImg">

<input type="hidden" name="user_role"  value="<%=user_role%>">
<input type="hidden" name="app_group"  value="<%=app_group%>">
<input type="hidden" name="app_name"   value="<%=app_name%>">
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
<form name="formLink" method="post">
	<input type="hidden" name="PROJECT_CODE_LINK" />
	<input type="hidden" name="PROJECT_NAME_LINK" />
	
	<input type="hidden" name="BATCH_NO" 		 value="<%=strBatchNo %>"/>
	<input type="hidden" name="DOCUMENT_RUNNING" value="<%=strDocumentRunning %>"/>
</form>
<iframe name="frameHidden" src="inc/openClip.jsp" width="0" height="0"></iframe>
<iframe name="frameOffline" style="display:none"></iframe>
<iframe scrolling="no" frameborder="0" name="inetdocview" src="/jinetdocarchive/imageproxy?codetype=applet&version=15&securecode=<%=securecode%>" width="32" height="32" marginwidth="0">
</iframe>
</body>
</html>