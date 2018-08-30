<%@page import="com.scc.edms.conf.ImageConfUtil"%>
<%@ page contentType="text/html; charset=tis-620"%>
<%@ page import="com.scc.security.UserInfo"%>
<%@ include file="inc/checkUser.jsp" %>
<%@ include file="inc/constant.jsp" %>
<%@ include file="inc/label.jsp" %>
<%@ include file="inc/utils.jsp" %>
<jsp:useBean id="con" scope="session" class="edms.cllib.EABConnector"/>
<%
    con.setRemoteServer("EAS_SERVER");

    UserInfo userInfo     = (UserInfo)session.getAttribute( "USER_INFO" );
    String strProjectCode = userInfo.getProjectCode();
    String strProjectName = userInfo.getProjectName();

    String screenname   = getField(request.getParameter("screenname"));
    String strClassName = "USER_REPORT";
    String strMode      = getField(request.getParameter("MODE"));

    String strWhereCause    = getField(request.getParameter("P_WHERE"));
    String  strFinishDate   = getField(request.getParameter("FINISH_DATE"));
    String  strFinishTime   = getField(request.getParameter("FINISH_TIME"));
    
    boolean bolnSuccess = true;
    	
    if( strMode == null || strMode == "" ){
        strMode = "ONLOAD";
    }
    
    if(strMode.equals("ONLOAD")){
    	con.addData( "REPORT_TYPE", "String", "ARCHIVE");
        bolnSuccess = con.executeService( strContainerName , strClassName , "selectUserReportOnLoad" );

        if( bolnSuccess ){
        	strFinishDate = con.getHeader("FINISH_DATE");
        	strFinishTime = con.getHeader("FINISH_TIME");
        	strMode       = "ONLOAD";
        }
	}
    
    if(strMode.equals("COUNT")){
        con.addData( "PROJECT_CODE", "String", strProjectCode);
        bolnSuccess = con.executeService( strContainerName , strClassName , "selectUserReport" );

        if( bolnSuccess ){
            strMode = "REPORT";
        }
     }
    
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title><%=lc_site_name%></title>
<meta http-equiv="Content-Type" content="text/html; charset=windows-874">
<script language="JavaScript" type="text/JavaScript">
<!--
function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}

function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
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
<script language="JavaScript" src="js/sccUtils.js"></script>
<script language="JavaScript" src="js/util.js"></script>
<script language="JavaScript" src="js/constant.js"></script>
<script language="JavaScript" src="js/label.js"></script>
<script language="JavaScript" type="text/javascript">
<!--

var sccUtils   = new SCUtils();
var mode       = "<%=strMode %>";
var strVerLang = "<%=strVersionLang %>";
var finishDate = "<%=strFinishDate%>";
var finishTime = "<%=strFinishTime%>";

function window_onload() {
    if( mode == "REPORT" ) {
    	openReport();
    }else if( mode == "SEARCH" ) {
    	alert( lc_report_data_not_found );
    }else if( mode == "ONLOAD" ) {
    	if( finishDate != "" ) {
    		if( strVerLang == "thai" ) {
    			lb_user_report_warning.innerHTML = lbl_report_date + displayFullDateThai(finishDate) + lbl_report_time + finishTime + ")";
    		}else {
    			lb_user_report_warning.innerHTML = lbl_report_date + displayFullDateEng(finishDate) + lbl_report_time + finishTime + ")";
    		}
    	}
    }
}

function openReport() {
	if( finishDate != "" ) {
		if( strVerLang == "thai" ) {
			lb_user_report_warning.innerHTML = lbl_report_date + displayFullDateThai(finishDate) + lbl_report_time + finishTime + ")";
		}else {
			lb_user_report_warning.innerHTML = lbl_report_date + displayFullDateEng(finishDate) + lbl_report_time + finishTime + ")";
		}
	}
	if( strVerLang == "thai" ) {
    	formReport.P_DATE.value = lbl_report_date + displayFullDateThai(finishDate) + lbl_report_time + finishTime + ")";
		formReport.P_DISPLAYDATE.value = "<%=dateToDisplay( getServerDateThai(), "/" )%>";
    }else {
    	formReport.P_DATE.value = lbl_report_date + displayFullDateEng(finishDate) + lbl_report_time + finishTime + ")";
		formReport.P_DISPLAYDATE.value = "<%=dateToDisplay( getServerDateEng(), "/" )%>";
    }
    lp_new_window("report");
    formReport.target = "report";
	formReport.submit();
}

function clearDefault() {
	obj_add_date.value    = "";
	obj_to_add_date.value = "";
	
	obj_add_date.focus();
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

function set_format_date( obj_field ){
	if( obj_field.value.length == 8 && sccUtils.isDateValid( obj_field.value ) == "VALID_DATE" ){
		obj_field.value = sccUtils.formatDate( obj_field.value );
	}
}

function field_press( objField ){
	if( sccUtils.isEnter() ){
		window.event.keyCode = 0;
		switch( objField.name ){
			case "ADD_DATE" : 
				obj_to_add_date.focus();
				break;
		}
	}
}

function verify_form() {
	if( obj_add_date.value.length != 0 && obj_to_add_date.value.length == 0 ) {
        alert( lc_check_to_date );
        obj_to_add_date.focus();
        return false;
    }
	return true;
}

function buttonClick( lv_strMethod ){
	var sql      = "";
	var whereCon = "";
	
	sql = "SELECT TOTAL_RECORD, TOTAL_FILE,";
	sql += "ROUND(TOTAL_SIZE/(1000000000),2) TOTAL_SIZE,";
	sql += "ROUND(USED_SIZE/(1000000000),2) USED_SIZE,";
	sql += "ROUND(AVIAIL_SIZE/(1000000000),2) AVIAIL_SIZE,";
	sql += "ROUND((USED_SIZE/TOTAL_SIZE)*100,2) PERCENT ";
	sql += "FROM PROJECT_MANAGER ";
	
    whereCon = "WHERE A.PROJECT_CODE='" + form1.P_PROJECT_CODE.value + "' ";
    
    switch( lv_strMethod ){
		case "searh" :
//			if(verify_form()){
				form1.P_WHERE.value = whereCon;
		        form1.MODE.value    = "COUNT" ;
				form1.submit();
				break;
//			}
	}
}

//-->
</script>
<link href="css/edas.css" type="text/css" rel="stylesheet">
</head>
<body onLoad="MM_preloadImages('images/btt_new_over.gif','images/btt_search_over.gif','images/btt_printreport_over.gif');window_onload();">
<form name="form1" method="post" >
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0" align="center">
  <tr>
    <td valign="top">
    	<table width="800" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td height="25" class="label_header01" colspan="4">&nbsp;&nbsp;<%=screenname%></td>
              </tr>
              <tr>
            	<td height="25" align="center">
            		<table width="495" border="0" cellspacing="0" cellpadding="0">
		                <tr>
		                  	<td height="25" colspan="4">&nbsp;</td>
		                </tr>             	
	                	<tr>
	                  		<td height="25" colspan="4" align="center" class="label_bold2">
	                  			<!-- 
	                  			<span id="lb_user_report_warning"></span><%=dateToDisplay(getServerDateThai())%>
	                  			-->
	                  			<span id="lb_user_report_warning"></span>
	                  		</td>
	                  	</tr>
	                  	<tr>
	                  		<td height="25" colspan="4">&nbsp;</td>
	                  	</tr>
 		            	<tr>
				           	<td align="center" colspan="4">
				           		<a href="#" onclick= "buttonClick('searh')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('searh','','images/btt_printreport_over.gif',1)">
				           			<img src="images/btt_printreport.gif" name="searh" width="102" height="22" border="0"></a>
				           	</td>
			            </tr>
 						<tr>
				           	<td align="center" colspan="4">
					            <input type="hidden" name="MODE"         value="<%=strMode%>">
		              			<input type="hidden" name="screenname"   value="<%=screenname%>">
		    					<input type="hidden" id="P_PROJECT_CODE" name="P_PROJECT_CODE" value="<%=strProjectCode%>">
								<input type="hidden" id="P_PROJECT_NAME" name="P_PROJECT_NAME" value="<%=strProjectName %>">
								<input type="hidden" id="P_WHERE"        name="P_WHERE"        value="<%=strWhereCause %>">
								<input type="hidden" id="P_DATE"         name="P_DATE"         value="<%=dateToDisplay(getServerDateThai())%>">
								<input type="hidden" id="FINISH_DATE"    name="FINISH_DATE"    value="<%=strFinishDate %>">
								<input type="hidden" id="FINISH_TIME"    name="FINISH_TIME"    value="<%=strFinishTime %>">
							</td>
			            </tr>
              		</table>
            	</td>
            </tr>
        </table>
        <p>&nbsp;</p>
      </td>
    </tr>
</table>
</form>
<form id="formReport" action="<%=request.getScheme()%>://<%=request.getServerName()+ ":" + request.getServerPort() %>/jrw510/jrq" method="post">
<input type="hidden" id="P_PROJECT_CODE" name="P_PROJECT_CODE" value="<%=strProjectCode%>">
<input type="hidden" id="P_PROJECT_NAME" name="P_PROJECT_NAME" value="<%=strProjectName %>">
<input type="hidden" id="P_WHERE"        name="P_WHERE"        value="<%=strWhereCause %>">
<input type="hidden" id="P_DATE"         name="P_DATE"         value="">
<input type="hidden" id="P_DISPLAYDATE"  name="P_DISPLAYDATE"  value="">
<input type="hidden" id="init"           name="init"           value="pdf">
<input type="hidden" id="report"         name="report"         value="EDAS3_9">
</form>

</body>
</html>
<script language="JavaScript" type="text/javascript">
<!--

var mode            = "<%=strMode%>";
//var obj_add_date    = document.getElementById("ADD_DATE");
//var obj_to_add_date = document.getElementById("TO_ADD_DATE");
var obj_projectcode    = document.getElementById("PROJECT_CODE");
var obj_whereCondition = document.getElementById("P_WHERE");

//-->
</script>