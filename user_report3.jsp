<%@page import="com.scc.edms.conf.ImageConfUtil"%>
<%@ page contentType="text/html; charset=tis-620"%>
<%@ page import="com.scc.security.UserInfo"%>
<%@ include file="inc/checkUser.jsp" %>
<%@ include file="inc/constant.jsp" %>
<%@ include file="inc/label.jsp" %>
<%@ include file="inc/utils.jsp" %>
<jsp:useBean id="con" scope="session" class="edms.cllib.EABConnector"/>
<jsp:useBean id="con1" scope="session" class="edms.cllib.EABConnector"/>
<%
    con.setRemoteServer("EAS_SERVER");
    con1.setRemoteServer("EAS_SERVER");

    UserInfo userInfo     = (UserInfo)session.getAttribute( "USER_INFO" );
	String strProjectCode = userInfo.getProjectCode();
    String strProjectName = userInfo.getProjectName();

    String screenname   = getField(request.getParameter("screenname"));
    String strClassName = "USER_REPORT";
    String strMode      = getField(request.getParameter("MODE"));

    String strLangFlag    = "";
    String strMsg         = ""; 
    String strVersionLang = ImageConfUtil.getVersionLang();

    if( strVersionLang.equals("thai") ) {
            strLangFlag = "1";
    }else {
            strLangFlag = "0";
    }

	String strUserActionData   = getField(request.getParameter("hidUserAction"));
	String strProjectOwnerData = getField(request.getParameter("txtProjectOwner"));
	String strAddDateData      = getField(request.getParameter("ADD_DATE"));
    String strToAddDateData    = getField(request.getParameter("TO_ADD_DATE"));
	String strtxtDocNumData    = getField(request.getParameter("txtDocNum"));
	String strtxtDataData      = getField(request.getParameter("txtData"));
    String strWhereCause       = getField(request.getParameter("P_WHERE"));
    String strDateCause        = getField(request.getParameter("P_DATE"));
    
    boolean bolnSuccess     = true;
    boolean bolnZoomSuccess = true;
    
	String strCurrentDate	= "";
	int iCount = 0;

	if( strVersionLang.equals("thai") ) {
		strCurrentDate = getServerDateThai();
	}else {
		strCurrentDate = getServerDateEng();
	}
	
    if( strMode == null ){
        strMode = "ONLOAD";
    }
    
    if(strMode.equals("COUNT")){
        con.addData( "PROJECT_CODE", "String", strProjectCode);
        if( !strUserActionData.equals("") ) {
        	con.addData( "ACTION_FLAG", "String", strUserActionData);
        }
        if( !strProjectOwnerData.equals("") ) {
        	con.addData( "ACTION_USER", "String", strProjectOwnerData);
        }
        if( !strAddDateData.equals("") ) {
        	con.addData( "ADD_DATE",     "String", strAddDateData);
        }
        if( !strToAddDateData.equals("") ) {
        	con.addData( "TO_ADD_DATE",  "String", strToAddDateData);
        }
        if( !strtxtDocNumData.equals("") ) {
        	con.addData( "BATCH_NO", "String", strtxtDocNumData);
        }
        if( !strtxtDataData.equals("") ) {
        	con.addData( "KEYFIELD", "String", strtxtDataData);
        }
        bolnSuccess = con.executeService( strContainerName , strClassName , "selectUserReport3" );

        
        if( bolnSuccess ) {
                iCount = con.getRecordTotal();
                if( iCount > 4000 ) {
                        strMsg  = "error";
                        strMode = "SEARCH";
                }else if( iCount == 0 ) {
                        strMode = "SEARCH";
                }else {
                        strMode = "REPORT";
                }
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
var strMsg       = "<%=strMsg %>";
var strAddDate   = "<%=strAddDateData %>";
var strToAddDate = "<%=strToAddDateData %>";

function window_onload() {
	lb_user_action.innerHTML  = lbl_user_action;
    lb_user_id_name.innerHTML = lbl_user_id_name;
    lb_from_date.innerHTML    = lbl_from_date;
    lb_to_date.innerHTML      = lbl_to_date;
    lb_doc_num.innerHTML      = lbl_doc_num;
    lb_data.innerHTML         = lbl_data;
    lb_user_report_warning3.innerHTML = lbl_user_report_warning3;
    lb_user_report_warning4.innerHTML = lbl_user_report_warning4;
    
    if( mode == "REPORT" ) {
    	openReport();
    }else if( mode == "SEARCH" ) {
    	if( strMsg == "error" ) {
    		alert( lc_admin_report_over_size );
    	}else {
    		alert( lc_report_data_not_found );
    	}
    	obj_add_date.value    = dateToScreen( strAddDate );
    	obj_to_add_date.value = dateToScreen( strToAddDate );
    }
}

function openReport() {
	strAddDate   = dateToDb( "<%=strAddDateData %>" );
	strToAddDate = dateToDb( "<%=strToAddDateData %>" );

	lp_new_window( "report" );
	formReport.P_DISPLAYDATE.value = "<%=dateToDisplay( strCurrentDate, "/" ) %>";
    formReport.target = "report";
	formReport.submit();
}

function getValueAction() {
	var optSelected = document.getElementById("optUserAction").selectedIndex;
	var optValue    = document.getElementById("optUserAction").value;
	
	if( optSelected == 0 ) {
		obj_hidUserAction.value = "";
	}else {
		obj_hidUserAction.value = optValue;
	}
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
	if( obj_field.value.length == 8 && sccUtils.isDateValid( obj_field.value ) == "VALID_DATE" ) {
		obj_field.value = sccUtils.formatDate( obj_field.value );
	}else {
		if( obj_field.value != "" && sccUtils.isDateValid( obj_field.value ) != "VALID_DATE" ){
			alert( lc_fill_date_correct );
			obj_field.value = "";
		}
	}
}

function field_press( objField ) {
	if( sccUtils.isEnter() ){
		window.event.keyCode = 0;
		switch( objField.name ){
			case "ADD_DATE" : 
				obj_to_add_date.focus();
				break;
			case "TO_ADD_DATE" : 
				obj_txtDocNum.focus();
				break;
		}
	}
}

function openZoom( strZoomType ) {
	var strPopArgument   = "scrollbars=yes,status=no";
	var strWidth         = ",width=370px";
	var strHeight        = ",height=420px";
	var strUrl           = "";
	var strConcatField   = "";

	strPopArgument += strWidth + strHeight;

	switch( strZoomType ){
		case "default" :
				strUrl = "inc/zoom_user_profile.jsp";
				strConcatField = "TABLE=ORG" + "&TABLE_LABEL=" + lbl_user_profile2_7;
				strConcatField += "&RESULT_FIELD=txtProjectOwner,txtProjectOwnerName";
				break;
	}

	objZoomWindow = window.open( strUrl + "?" + strConcatField, strZoomType, strPopArgument );
	objZoomWindow.focus();
}

function clearDefault() {
	obj_optUserAction.value       = "";
	obj_hidUserAction.value       = "";
	obj_txtProjectOwner.value     = "";
	obj_txtProjectOwnerName.value = "";
	obj_add_date.value            = "";
	obj_to_add_date.value         = "";
	obj_txtDocNum.value           = "";
	obj_txtData.value             = "";
}

function verify_form() {
	var strAddDate   = dateToDb( obj_add_date.value );
	var strToAddDate = dateToDb( obj_to_add_date.value );
	var strPdate     = "";
	var whereCon     = "WHERE A.PROJECT_CODE='"+obj_projectcode.value+"' ";
	
	if( obj_hidUserAction.value.length == 0 && obj_txtProjectOwner.value.length == 0 && 
		obj_add_date.value.length == 0 && obj_to_add_date.value.length == 0 && 
		obj_txtDocNum.value.length == 0 && obj_txtData.value.length == 0 ) {
		
		alert( lc_check_atlease_one_defind );
		return false;
	}
	if( obj_hidUserAction.value.length != 0 ) {
		whereCon += "AND A.ACTION_FLAG='"+obj_hidUserAction.value+"' ";
	}
	if( obj_txtProjectOwner.value.length != 0 ) {
		whereCon += "AND A.ACTION_USER='"+obj_txtProjectOwner.value+"' ";
	}
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
	    whereCon += "AND A.ACTION_DATE>='"+strAddDate+"' AND A.ACTION_DATE<='"+strToAddDate+"' ";
    	if( strVerLang == "thai" ) {
    		strPdate = lbl_from_date + displayFullDateThai(strAddDate) + lbl_to_date + displayFullDateThai(strToAddDate);
    	}else {
    		strPdate = lbl_from_date + displayFullDateEng(strAddDate) + lbl_to_date + displayFullDateEng(strToAddDate);
    	}
		form1.P_DATE.value    = strPdate;
		obj_add_date.value    = strAddDate;
		obj_to_add_date.value = strToAddDate;
    }else {
    	if( strVerLang == "thai" ) {
			strPdate = lbl_head_admin_report1_1 + " <%=dateToDisplay(getServerDateThai())%>";
		}else {
			strPdate = lbl_head_admin_report1_1 + " <%=dateToDisplay(getServerDateEng())%>";
		}
		form1.P_DATE.value = strPdate;
    }
    if( obj_txtDocNum.value.length != 0 ) {
    	whereCon += "AND A.BATCH_NO='"+obj_txtDocNum.value+"' ";
    }
    if( obj_txtData.value.length != 0 ) {
    	whereCon += "AND CONTAINS(A.KEYFIELD,'"+obj_txtData.value+"',1)>0 ";
    }
	form1.P_WHERE.value = whereCon;
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
            		<table width="530" border="0" cellspacing="0" cellpadding="0">
		                <tr>
		                  	<td height="25" colspan="4">&nbsp;</td>
		                </tr>
		                <tr>
<%
		String strTagOption      = "";
		String strZoomUserAction = "";
		String strZoomActionName = "";
		strTagOption = "\n<select id=\"optUserAction\" name=\"optUserAction\" class=\"combobox\" onchange=\"getValueAction();\">";
		strTagOption += "\n<option value=\"\"></option>";
		
		bolnZoomSuccess = con1.executeService( strContainerName, strClassName, "findUserActionCombo" );
		
		if( bolnZoomSuccess ){
			while( con1.nextRecordElement() ){
				strZoomUserAction = con1.getColumn( "USER_ACTION" );
				strZoomActionName = con1.getColumn( "USER_ACTION_NAME" );
		
				strTagOption += "\n<option value=\"" + strZoomUserAction + "\">" + strZoomActionName + "</option>";
			}
		}
		
		strTagOption += "\n</select>";
%>
		                	<td width="30%" height="25" class="label_bold2"><span id="lb_user_action"></span></td>
			                <td colspan="3">
			               		<span id="user_action"></span><%=strTagOption %>
			               		<input id="hidUserAction" name="hidUserAction" type="hidden" >
			                </td>
	                	</tr>
                       	<tr>
                            <td class="label_bold2"><span id="lb_user_id_name" class="label_bold2"></span></td>
                            <td colspan="3">
                            	<input id="txtProjectOwner" name="txtProjectOwner" type="text" size="14" maxlength="20" class="input_box_disable" readOnly >&nbsp;
			                	<a href="javascript:openZoom('default');">
			                		<img id="imgZoomDocLevel" src="images/search.gif" width="16" height="16" border="0">&nbsp;</a>
			                	<input id="txtProjectOwnerName" name="txtProjectOwnerName" type="text" size="41" maxlength="50" class="input_box_disable" readOnly >
		                	</td>
			            </tr>
		                <tr>
		                	<td height="25" class="label_bold2"><span id="lb_from_date"></span></td>
			                <td width="30%">
			               		<input id="ADD_DATE" name="ADD_DATE" type="text" class="input_box" size="10" maxlength="10" onkeypress="keypress_number();field_press( this );" onBlur="checkFromDate( this );set_format_date( this );"> 
					        	<a href="javascript:showCalendar(form1.ADD_DATE,<%=strLangFlag %>)">
					        		<img src="images/calendar.gif" width=16 height=16 align="absmiddle" border=0 ></a>
			                </td>
			                <td width="13%" height="25" class="label_bold2"><span id="lb_to_date"></span></td>
			                <td>
			                	<input id="TO_ADD_DATE" name="TO_ADD_DATE" type="text" class="input_box" size="10" maxlength="10" onkeypress="keypress_number();field_press( this );" onBlur="checkTodayDate( this );set_format_date( this );"> 
					            <a href="javascript:showCalendar(form1.TO_ADD_DATE,<%=strLangFlag %>)">
					            	<img src="images/calendar.gif" width=16 height=16 border=0 ></a>
					    	</td>
	                	</tr>
	                	<tr>
	                		<td height="25" class="label_bold2"><span id="lb_doc_num"></span></td>
			                <td colspan="3">
			                	<input id="txtDocNum" name="txtDocNum" type="text" size="15" maxlength="20" class="input_box" value="" >
			                </td>
	                	</tr>
	                	<tr>
	                		<td height="25" class="label_bold2"><span id="lb_data"></span></td>
			                <td colspan="3">
			                	<input id="txtData" name="txtData" type="text" size="67" maxlength="70" class="input_box" value="" >
			                </td>
	                	</tr>
	                  	<tr>
	                  		<td height="25" colspan="4">&nbsp;</td>
	                  	</tr>
	                	<tr>
	                  		<td height="25" colspan="4" class="label_bold2" align="center">
	                  			<span id="lb_user_report_warning3"></span>
	                  		</td>
	                  	</tr>
	                	<tr>
	                  		<td height="25" colspan="4" class="label_bold2" align="center">
	                  			<span id="lb_user_report_warning4"></span>
	                  		</td>
	                  	</tr>
	                  	<tr>
	                  		<td height="25" colspan="4">&nbsp;</td>
	                  	</tr>
			            <tr>
				           	<td align="center" colspan="4">
				           		<a href="#" onclick= "buttonClick('searh')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('bttSearch','','images/btt_search_over.gif',1)">
				           			<img src="images/btt_search.gif" id="bttSearch" name="bttSearch" width="67" height="22" border="0"></a>&nbsp;
				           		<a href="#" onclick= "clearDefault()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new','','images/btt_new_over.gif',1)">
				           			<img src="images/btt_new.gif" name="new" width="67" height="22" border="0"></a>
				           	</td>
			            </tr>
 						<tr>
				           	<td align="center" colspan="4">
					            <input type="hidden" name="MODE"         value="<%=strMode%>">
		              			<input type="hidden" name="screenname"   value="<%=screenname%>">
								<input type="hidden" id="txtTodayDate"   name="txtTodayDate"   value="<%=strCurrentDate %>">
								<input type="hidden" id="PROJECT_CODE"   name="PROJECT_CODE"   value="<%=strProjectCode %>">
								<input type="hidden" id="P_DATE"         name="P_DATE"         value="">
								<input type="hidden" id="P_WHERE"        name="P_WHERE"        value="<%=strWhereCause %>">
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
<iframe name="frameGetFullDate" style="display:none;"></iframe>
</form>

<form id="frameFullDate" name="frameFullDate" method="post" action="">
	<input type="hidden" name="ADD_DATE"    value="">
	<input type="hidden" name="TO_ADD_DATE" value="">
</form>

<%-- <form id="formReport" action="<%=ConfUtil.getReportActionURL()%>" method="post"> --%>
<%-- <input type="hidden" id="P_PROJECT_CODE" name="P_PROJECT_CODE" value="<%=strProjectCode%>"> --%>
<%-- <input type="hidden" id="P_PROJECT_NAME" name="P_PROJECT_NAME" value="<%=strProjectName %>"> --%>
<%-- <input type="hidden" id="P_DATE"         name="P_DATE"         value="<%=strDateCause %>"> --%>
<!-- <input type="hidden" id="P_DISPLAYDATE"  name="P_DISPLAYDATE"  value=""> -->
<%-- <input type="hidden" id="P_WHERE"        name="P_WHERE"        value="<%=strWhereCause %>"> --%>
<%-- <input type="hidden" id="JDBC_NAME"      name="JDBC_NAME"      value="<%=ConfUtil.getReportJdbcName()%>"> --%>
<%-- <input type="hidden" id="REPORT_NAME"    name="REPORT_NAME"    value="<%=ConfUtil.getReportPath()%>EDAS3_11.jasper"> --%>
<!-- </form> -->
<form id="formReport" action="<%=request.getScheme()%>://<%=request.getServerName()+ ":" + request.getServerPort() %>/jrw510/jrq" method="post">
<input type="hidden" id="P_PROJECT_CODE" name="P_PROJECT_CODE" value="<%=strProjectCode%>">
<input type="hidden" id="P_PROJECT_NAME" name="P_PROJECT_NAME" value="<%=strProjectName %>">
<input type="hidden" id="P_DATE"         name="P_DATE"         value="<%=strDateCause %>">
<input type="hidden" id="P_DISPLAYDATE"  name="P_DISPLAYDATE"  value="">
<input type="hidden" id="P_WHERE"        name="P_WHERE"        value="<%=strWhereCause %>">
<input type="hidden" id="init"           name="init"           value="pdf">
<input type="hidden" id="report"         name="report"         value="EDAS3_11">
</form>

</body>
</html>
<script language="JavaScript" type="text/javascript">
<!--

var mode                    = "<%=strMode%>";
var obj_optUserAction       = document.getElementById("optUserAction");
var obj_hidUserAction       = document.getElementById("hidUserAction");
var obj_txtProjectOwner     = document.getElementById("txtProjectOwner");
var obj_txtProjectOwnerName = document.getElementById("txtProjectOwnerName");
var obj_add_date            = document.getElementById("ADD_DATE");
var obj_to_add_date         = document.getElementById("TO_ADD_DATE");
var obj_txtDocNum           = document.getElementById("txtDocNum");
var obj_txtData             = document.getElementById("txtData");
var obj_txtTodayDate        = document.getElementById("txtTodayDate");

var obj_projectcode    = document.getElementById("PROJECT_CODE");
var obj_whereCondition = document.getElementById("P_WHERE");
var obj_bttSearch      = document.getElementById("bttSearch");

//-->
</script>