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

    String strAddDateData   = getField(request.getParameter("ADD_DATE"));
    String strToAddDateData = getField(request.getParameter("TO_ADD_DATE"));
    String strDateCause     = getField(request.getParameter("P_DATE"));
    String strDateCause2    = getField(request.getParameter("P_DATE2"));
    String strFinishDate    = getField(request.getParameter("FINISH_DATE"));
    String strFinishTime    = getField(request.getParameter("FINISH_TIME"));
    String strWhereCause    = "WHERE PROJECT_CODE = '" + strProjectCode + "' ";
    
    boolean bolnSuccess = true;
    
    String strCurrentDate  = "";
    String strLangFlag     = "";
    String strVersionLang  = ImageConfUtil.getVersionLang();

        if( strVersionLang.equals("thai") ) {
		strCurrentDate = getServerDateThai();
		strLangFlag    = "1";
	}else {
		strCurrentDate = getServerDateEng();
		strLangFlag    = "0";
	}
	
    if( strMode == null || strMode == "" ){
        strMode = "ONLOAD";
    }
    
    if(strMode.equals("ONLOAD")){
    	con.addData( "REPORT_TYPE", "String", "LOG");
        bolnSuccess = con.executeService( strContainerName , strClassName , "selectUserReportOnLoad" );

        if( !bolnSuccess ){
            strMode         = "ONLOAD";
        }else{
        	strFinishDate = con.getHeader("FINISH_DATE");
        	strFinishTime = con.getHeader("FINISH_TIME");
        	strMode       = "ONLOAD";
        }
    }
    
    if(strMode.equals("COUNT")){
        con.addData( "PROJECT_CODE", "String", strProjectCode);
        if( strAddDateData.length() != 0 ) {
        	con.addData( "ADD_DATE",     "String", strAddDateData);
                strWhereCause += "AND ACTION_DATE >= '" + strAddDateData + "' ";
        }
        if( strToAddDateData.length() != 0 ) {
        	con.addData( "TO_ADD_DATE",  "String", strToAddDateData);
                strWhereCause += "AND ACTION_DATE <= '" + strToAddDateData + "' ";
        }
        bolnSuccess = con.executeService( strContainerName , strClassName , "selectUserReport2" );

        if( !bolnSuccess ){
            strMode = "SEARCH";
        }else{
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

var sccUtils     = new SCUtils();
var mode         = "<%=strMode %>";
var strAddDate   = "<%=strAddDateData %>";
var strToAddDate = "<%=strToAddDateData %>";
var strVerLang   = "<%=strVersionLang %>";

function window_onload() {
	lb_from_date.innerHTML = lbl_from_date;
    lb_to_date.innerHTML   = lbl_to_date;
    lb_user_report_warning.innerHTML = lbl_user_report_warning2;
    
    if( mode == "REPORT" ) {
    	openReport();
    }else if( mode == "SEARCH" ) {
    	alert( lc_report_data_not_found );
    	obj_add_date.value    = dateToScreen( strAddDate );
    	obj_to_add_date.value = dateToScreen( strToAddDate );
    }
}

function openReport() {
	strAddDate   = dateToDb( "<%=strAddDateData %>" );
	strToAddDate = dateToDb( "<%=strToAddDateData %>" );

	lp_new_window( "report" );
	formReport.P_ADD_DATE.value    = strAddDate;
	formReport.P_TO_ADD_DATE.value = strToAddDate;
	formReport.P_DISPLAYDATE.value = "<%=dateToDisplay( strCurrentDate, "/" ) %>";
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

function checkFromDate( obj_field ) {
	var todayDate = obj_txtTodayDate.value;
	var dateField = sccUtils.formatDate( obj_field.value );
	var dateDb    = dateToDb( dateField );
	
	if( parseInt(dateDb) > parseInt(todayDate) ) {
		alert( lc_from_date_not_over );
		obj_field.value = "";
	}
}

function checkTodayDate( obj_field ) {
	var todayDate = obj_txtTodayDate.value;
	var dateField = sccUtils.formatDate( obj_field.value );
	var dateDb    = dateToDb( dateField );
	var addDate   = dateToDb( obj_add_date.value );
	
	if( parseInt(dateDb) < parseInt(addDate) ) {
		alert( lc_to_date_not_over_add_date );
		obj_field.value = "";
		return;
	}
	if( parseInt(dateDb) > parseInt(todayDate) ) {
		alert( lc_to_date_not_over );
		obj_field.value = "";
		return;
	}
}

function set_format_date( obj_field ){
	if( obj_field.value.length == 8 && sccUtils.isDateValid( obj_field.value ) == "VALID_DATE" ){
		obj_field.value = sccUtils.formatDate( obj_field.value );
	}else {
		if( obj_field.value != "" && sccUtils.isDateValid( obj_field.value ) != "VALID_DATE" ){
			alert( lc_fill_date_correct );
			obj_field.value = "";
		}
	}
}

function field_press( objField ){
	if( sccUtils.isEnter() ){
		window.event.keyCode = 0;
		switch( objField.name ){
			case "ADD_DATE" : 
				obj_to_add_date.focus();
				break;
			case "TO_ADD_DATE" : 
				obj_lnkSearch.focus();
				break;
		}
	}
}

function verify_form() {
	var strAddDate   = dateToDb( obj_add_date.value );
	var strToAddDate = dateToDb( obj_to_add_date.value );
	var strPdate     = "";
	var strPdate2    = "";
    if( strVerLang == "thai" ) {
		strPdate2 = lbl_report_date + displayFullDateThai(obj_FINISH_DATE.value) + lbl_report_time + obj_FINISH_TIME.value + ")";
	}else {
		strPdate2 = lbl_report_date + displayFullDateEng(obj_FINISH_DATE.value) + lbl_report_time + obj_FINISH_TIME.value + ")";
	}
	var whereCon = "WHERE A.PROJECT_CODE='"+form1.P_PROJECT_CODE.value+"' ";
	
	if( obj_add_date.value.length != 0 || obj_to_add_date.value.length != 0 ) {
        if( obj_add_date.value.length == 0 ) {
	        alert( lc_check_from_date_emp );
	        obj_add_date.focus();
	        return false;
		}
		if( obj_to_add_date.value.length == 0 ) {
	        alert( lc_check_to_date_emp );
	        obj_to_add_date.focus();
	        return false;
	    }
	    if( (parseInt(strAddDate)) > (parseInt(strToAddDate)) ) {
	        alert( lc_check_to_date_not_over );
	        obj_to_add_date.focus();
	        return false;
	    }
    	if( strVerLang == "thai" ) {
	    	strPdate = lbl_from_date + displayFullDateThai(strAddDate) + lbl_to_date + displayFullDateThai(strToAddDate);
	    }else {
	    	strPdate = lbl_from_date + displayFullDateEng(strAddDate) + lbl_to_date + displayFullDateEng(strToAddDate);
	    }
	    whereCon += "AND A.ACTION_DATE >= '"+strAddDate+"' AND A.ACTION_DATE <= '"+strToAddDate+"' ";
	    
		form1.P_DATE.value    = strPdate;
		form1.P_DATE2.value   = strPdate2;
		form1.P_DISPLAYDATE.value = "<%=dateToDisplay( strCurrentDate, "/" ) %>";
//		form1.P_WHERE.value   = whereCon;
		obj_add_date.value    = strAddDate;
		obj_to_add_date.value = strToAddDate;
    }else {
    	form1.P_DATE.value  = "-";
		form1.P_DATE2.value = strPdate2;
//		form1.P_WHERE.value = whereCon;
    }
	
	return true;
}

function buttonClick( lv_strMethod ){
    switch( lv_strMethod ){
		case "searh" :
			if( verify_form() ) {
		        form1.MODE.value = "COUNT" ;
				form1.submit();
			}
			break;
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
            		<table width="370" border="0" cellspacing="0" cellpadding="0">
		                <tr>
		                  	<td height="25" colspan="4">&nbsp;</td>
		                </tr>
		                <tr>
		                	<td height="25" class="label_bold2"><span id="lb_from_date"></span></td>
			                <td width="120">
			               		<input id="ADD_DATE" name="ADD_DATE" type="text" class="input_box" size="10" maxlength="10" onkeypress="keypress_number();field_press( this );" onBlur="checkFromDate( this );set_format_date( this );"> 
					        	<a href="javascript:showCalendar(form1.ADD_DATE,<%=strLangFlag %>)">
					        		<img src="images/calendar.gif" width=16 height=16 align="absmiddle" border=0 ></a>
			                </td>
			                <td height="25" class="label_bold2"><span id="lb_to_date"></span></td>
			                <td width="100">
			                	<input id="TO_ADD_DATE" name="TO_ADD_DATE" type="text" class="input_box" size="10" maxlength="10" onkeypress="keypress_number();field_press( this );" onBlur="checkTodayDate( this );set_format_date( this );"> 
					            <a href="javascript:showCalendar(form1.TO_ADD_DATE,<%=strLangFlag %>)">
					            	<img src="images/calendar.gif" width=16 height=16 align="absmiddle" border=0 ></a>
					    	</td>
	                	</tr>
	                  	<tr>
	                  		<td height="25" colspan="4">&nbsp;</td>
	                  	</tr>
	                	<tr>
	                  		<td height="25" colspan="4" align="center" class="label_bold2">
	                  			<span id="lb_user_report_warning"></span>
	                  		</td>
	                  	</tr>
						<tr>
	                  		<td height="25" colspan="4">&nbsp;</td>
	                  	</tr>
			            <tr>
				           	<td align="center" colspan="4">
				           		<a href="#" id="lnkSearch" onclick= "buttonClick('searh')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('bttSearch','','images/btt_search_over.gif',1)">
				           			<img src="images/btt_search.gif" id="bttSearch" name="bttSearch" width="67" height="22" border="0"></a>&nbsp;
				           		<a href="#" onclick= "clearDefault()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new','','images/btt_new_over.gif',1)">
				           			<img src="images/btt_new.gif" name="new" width="67" height="22" border="0"></a>
				           	</td>
			            </tr>
 						<tr>
				           	<td align="center" colspan="4">
					            <input type="hidden" name="MODE"         value="<%=strMode%>">
		              			<input type="hidden" name="screenname"   value="<%=screenname%>">
								<input type="hidden" id="txtTodayDate"   name="txtTodayDate"   value="<%=strCurrentDate%>">
								<input type="hidden" id="P_PROJECT_CODE" name="P_PROJECT_CODE" value="<%=strProjectCode%>">
								<input type="hidden" id="P_DATE"         name="P_DATE"         value="">
								<input type="hidden" id="P_DATE2"        name="P_DATE2"        value="">
								<input type="hidden" id="P_DISPLAYDATE"  name="P_DISPLAYDATE"  value="">
								<input type="hidden" id="P_WHERE"        name="P_WHERE"        value="<%=strWhereCause %>">
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

<%-- <form id="formReport" action="<%=ConfUtil.getReportActionURL()%>" method="post"> --%>
<%-- <input type="hidden" id="P_PROJECT_CODE" name="P_PROJECT_CODE" value="<%=strProjectCode%>"> --%>
<%-- <input type="hidden" id="P_PROJECT_NAME" name="P_PROJECT_NAME" value="<%=strProjectName %>"> --%>
<%-- <input type="hidden" id="P_DATE"         name="P_DATE"         value="<%=strDateCause%>"> --%>
<%-- <input type="hidden" id="P_DATE2"        name="P_DATE2"        value="<%=strDateCause2%>"> --%>
<!-- <input type="hidden" id="P_DISPLAYDATE"  name="P_DISPLAYDATE"  value=""> -->
<!-- <!--  -->
<%-- <input type="hidden" id="P_DATE"         name="P_DATE"         value="<%=dateToDisplay(getServerDateThai())%>"> --%>
<!--  --> -->
<!-- <input type="hidden" id="P_ADD_DATE"     name="P_ADD_DATE"     value=""> -->
<!-- <input type="hidden" id="P_TO_ADD_DATE"  name="P_TO_ADD_DATE"  value=""> -->
<%-- <input type="hidden" id="P_WHERE"        name="P_WHERE"        value="<%=strWhereCause %>"> --%>
<%-- <input type="hidden" id="JDBC_NAME"      name="JDBC_NAME"      value="<%=ConfUtil.getReportJdbcName()%>"> --%>
<%-- <input type="hidden" id="REPORT_NAME"    name="REPORT_NAME"    value="<%=ConfUtil.getReportPath()%>EDAS3_10.jasper"> --%>
<!-- </form> -->
<form id="formReport" action="<%=request.getScheme()%>://<%=request.getServerName()+ ":" + request.getServerPort() %>/jrw510/jrq" method="post">
<input type="hidden" id="P_PROJECT_CODE" name="P_PROJECT_CODE" value="<%=strProjectCode%>">
<input type="hidden" id="P_PROJECT_NAME" name="P_PROJECT_NAME" value="<%=strProjectName %>">
<input type="hidden" id="P_DATE"         name="P_DATE"         value="<%=strDateCause%>">
<input type="hidden" id="P_DATE2"        name="P_DATE2"        value="<%=strDateCause2%>">
<input type="hidden" id="P_DISPLAYDATE"  name="P_DISPLAYDATE"  value="">
<input type="hidden" id="P_ADD_DATE"     name="P_ADD_DATE"     value="">
<input type="hidden" id="P_TO_ADD_DATE"  name="P_TO_ADD_DATE"  value="">
<input type="hidden" id="P_WHERE"        name="P_WHERE"        value="<%=strWhereCause %>">
<input type="hidden" id="init"           name="init"           value="pdf">
<input type="hidden" id="report"         name="report"         value="EDAS3_10">
</form>

</body>
</html>
<script language="JavaScript" type="text/javascript">
<!--

var mode               = "<%=strMode%>";
var obj_add_date       = document.getElementById("ADD_DATE");
var obj_to_add_date    = document.getElementById("TO_ADD_DATE");
var obj_projectcode    = document.getElementById("PROJECT_CODE");
var obj_pDate          = document.getElementById("P_DATE");
var obj_FINISH_DATE    = document.getElementById("FINISH_DATE");
var obj_FINISH_TIME    = document.getElementById("FINISH_TIME");
var obj_txtTodayDate   = document.getElementById("txtTodayDate");

var obj_lnkSearch      = document.getElementById("lnkSearch");
var obj_bttSearch      = document.getElementById("bttSearch");

//-->
</script>