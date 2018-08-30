<%@page import="com.scc.edms.conf.ImageConfUtil"%>
<%@ page contentType="text/html; charset=tis-620"%>
<%@ page import="com.scc.security.UserInfo"%>
<%@ include file="inc/constant.jsp" %>
<%@ include file="inc/label.jsp" %>
<%@ include file="inc/utils.jsp" %>
<jsp:useBean id="con" scope="session" class="edms.cllib.EABConnector"/>
<%
	con.setRemoteServer("EAS_SERVER");

	UserInfo userInfo = (UserInfo)session.getAttribute("USER_INFO");
	String	strProjectCode  = userInfo.getProjectCode();
	String	strUserId		= userInfo.getUserId();

	String strBatchNo 		  = checkNull(request.getParameter("BATCH_NO"));
	String strDocumentRunning = checkNull(request.getParameter("DOCUMENT_RUNNING"));
	String strMediaLabel 	  = getField(request.getParameter("MEDIA_LABEL"));
	String strMode 		  	  = checkNull(request.getParameter("MODE"));
	
	String 	strCurrentDate  = "";
	String	strReqDate		= "";
	String	strExpireDate	= "";
	String	strTempExpDays	= "0";
	
	String	strDate	= "";
	
	int	iDate = 0;
	String strVersionLang  = ImageConfUtil.getVersionLang();

        if( strVersionLang.equals("thai") ) {
		strCurrentDate = getTodayDateThai();
	}else{
		strCurrentDate = getTodayDate();
	}
	
	boolean bolSuccess 		 = false;
	boolean bolSuccess2 	 = false;
	boolean bolSuccessInsert = false;
	
	con.addData("PROJECT_CODE", 	"String", strProjectCode);
	con.addData("BATCH_NO", 		"String", strBatchNo);
	con.addData("DOCUMENT_RUNNING", "String", strDocumentRunning);
	bolSuccess = con.executeService(strContainerName, "OFFLINE_DOCUMENT", "find");
	if(bolSuccess){
		strReqDate 	  = con.getHeader( "REQ_DATE" );
		strExpireDate = con.getHeader( "EXPIRE_DATE" );		
	}else{
		bolSuccess2 = con.executeService(strContainerName, "SYSTEM_CONFIG", "update");
		if(bolSuccess2){
			strTempExpDays = con.getHeader("TEMP_EXPIRE_DAYS");			
		}
		
		if(strTempExpDays.equals("")){strTempExpDays = "0";}
		
		strDate = strCurrentDate.substring(6,8);
		iDate	= Integer.parseInt(strDate);
		iDate  += Integer.parseInt(strTempExpDays);
		
		strExpireDate = strCurrentDate.substring(0,6) + iDate;
		
	}
	
	if(strMode.equals("INSERT")){
		
		con.addData("PROJECT_CODE", 	"String", strProjectCode);
		con.addData("BATCH_NO", 		"String", strBatchNo);
		con.addData("DOCUMENT_RUNNING", "String", strDocumentRunning);
		con.addData("MEDIA_LABEL", 		"String", strMediaLabel);
		con.addData("REQ_DATE", 		"String", strReqDate);
		con.addData("ADD_USER", 		"String", strUserId);
		con.addData("ADD_DATE", 		"String", strCurrentDate);
		con.addData("UPD_USER", 		"String", strUserId);
		bolSuccessInsert = con.executeService(strContainerName,"OFFLINE_DOCUMENT","insert");		
	}

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>EDAS</title>
<meta http-equiv="Content-Type" content="text/html; charset=tis-620">
<script language="JavaScript" src="js/sccUtils.js"></script>
<script language="JavaScript" src="js/util.js"></script>
<script language="JavaScript" src="js/constant.js"></script>
<script language="JavaScript" type="text/JavaScript">
<!--

function window_onload(){

<% if(strMode.equals("INSERT")){%>

<%	if(bolSuccess){ %>
		showMsg( 0 , 0 , "เอกสารนี้หมดอายุและถูกดึงออกจากระบบแล้ว<br>" + 
						 " ผู้ดูแลระบบจะนำข้อมูลกลับมาภายใน 3 วันทำการ " +
						 " นับจากวันที่ <%=dateToDisplay(strReqDate)%> "
						 " และสามารถดูเอกสารนี้ได้ถึงวันที่ <%=dateToDisplay(strExpireDate)%>" );
<%	} %>

<%	if(bolSuccess){ %>
		if(showMsg( 0 , 1 , "เอกสารนี้หมดอายุและถูกดึงออกจากระบบแล้ว" +
							 " ถ้าต้องการดูเอกสารนี้โปรดลงทะเบียนเพื่อขอดูเอกสาร" +
							 " ผู้ดูแลระบบจะนำข้อมูลกลับมาภายใน 3 วันทำการ " +
							 " และสามารถเข้าไปดูเอกสารนี้ได้ถึงวันที่ <%=dateToDisplay(strExpireDate)%>" +
							 " โปรดยืนยันการลงทะเบียน" )){
			
			register_offline_doc();
		}	
	
<%	} %>

<% }else{ 
		if(bolSuccessInsert){
%>		
			showMsg( 0 , 0 ,"ลงทะเบียนเรียบร้อยแล้ว");		
<% 		}else{ %> 		
			showMsg( 0 , 0 ,"ไม่สามารถลงทะเบียนได้");
<%		} 
		
		strMode = "";
	}
%>
}

function register_offline_doc(){

	form1.MODE.value = "INSERT";
	form1.target	 = "_self";
	form1.action	 = "offline_document.jsp";
	form1.submit();
}

//-->
</script>
</head>
<body onload="window_onload()">
<form name="form1" method="post">
<input type="hidden" name="MODE" />
<input type="hidden" name="BATCH_NO" 		 value="<%=strBatchNo %>" />
<input type="hidden" name="DOCUMENT_RUNNING" value="<%=strDocumentRunning %>" />
<input type="hidden" name="MEDIA_LABEL" 	 value="<%=strMediaLabel %>" />
</form>
</body>
</html>