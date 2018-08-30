<%@ page contentType="text/html; charset=tis-620"%>
<%@ page import="com.scc.security.UserInfo"%>
<%@ include file="inc/checkUser.jsp" %>
<%@ include file="inc/constant.jsp" %>
<%@ include file="inc/utils.jsp" %>
<jsp:useBean id="con" scope="session" class="edms.cllib.EABConnector"/>
<jsp:useBean id="con2" scope="session" class="edms.cllib.EABConnector"/>
<%
	con.setRemoteServer("EAS_SERVER");
	con2.setRemoteServer("EAS_SERVER");
	
	String strClassName = "FIELD_MANAGER";

	UserInfo userInfo     = (UserInfo)session.getAttribute( "USER_INFO" );
	String strProjectCode = userInfo.getProjectCode();
	String user_role      = getField(request.getParameter("user_role"));
	String app_name       = getField(request.getParameter("app_name"));
	String app_group      = getField(request.getParameter("app_group"));
	String screenname     = getField(request.getParameter("screenname"));
	String strMode        = getField(request.getParameter("MODE"));
	String strResult	  = getField(request.getParameter("RESULT") );

	if( user_role == null || user_role.equals("") ) {
		user_role = (String)request.getAttribute( "user_role" );
	}
	if( app_name == null || app_name.equals("") ) {
		app_name = (String)request.getAttribute( "app_name" );
	}
	if( app_group == null || app_group.equals("") ) {
		app_group = (String)request.getAttribute( "app_group" );
	}
	if( screenname == null || screenname.equals("") ) {
		screenname = (String)request.getAttribute( "screenname" );
	}
	if( strResult == null || strResult.equals("") ) {
		strResult = (String)request.getAttribute( "RESULT" );
	}
	if( strResult == null ) {
		strResult = "";
	}
	
	String strCurrentPage = request.getParameter( "CURRENT_PAGE" );
	if( strCurrentPage == null || Integer.parseInt( strCurrentPage ) == 0 ) {
	    strCurrentPage = "1";
	}
	
	String  strmsg          = "";
	boolean bolnSuccess     = true;
	boolean bolnSuccess2    = true;
	String  strErrorCode    = null;
	String  strErrorMessage = null;
	int     intSeq          = 0;
	
    String  strFieldCodeTemp     = getField(request.getParameter( "FIELD_CODE_TEMP" ));
    String  strFieldOrderTemp    = getField(request.getParameter( "FIELD_ORDER_TEMP" ));
    String  strFieldTypeTemp     = getField(request.getParameter( "FIELD_TYPE_TEMP" ));
	String  strFieldSeqnData     = getField(request.getParameter( "USER_ID_TEMP" ));
    String  strFieldCode1Choose  = getField(request.getParameter( "FIELD_CODE1_CHOOSE" ));
    String  strFieldOrder1Choose = getField(request.getParameter( "FIELD_ORDER1_CHOOSE" ));
    String  strFieldCode2Choose  = getField(request.getParameter( "FIELD_CODE2_CHOOSE" ));
    String  strFieldOrder2Choose = getField(request.getParameter( "FIELD_ORDER2_CHOOSE" ));
    String  strLastRowSelect     = getField(request.getParameter( "last_row_select" ));
    String  strFieldOrderData    = "";
    String  strFieldCodeData     = "";
    String  strFieldTypeData     = "";
    String  strFieldLengthData   = "";
    String  strFieldLabelData    = "";
    String  strIsNotNullData     = "";
    String  strIsPkData          = "";
	String  strFieldCode         = "";
	String  fieldCode            = "fieldCode";
    
	String  strScript          = "";
    String  strImgIsNotNull    = "";
    String  strImgIsPk         = "";
    String  strbttEdit         = "";
    String  strbttDelete       = "";
	String	strPermission	   = "";
	
	if( strResult.equals("success") ) {
		strmsg	= "showMsg(0,0,\" " + lc_import_xml_successfull + "\")";
	    strMode	= "SEARCH";
	}

    if( strMode == null || strMode.equals("")){
        strMode = "SEARCH";
   	}
    
    con2.addData("USER_ROLE", 		  "String", user_role);
	con2.addData("APPLICATION", 	  "String", app_name);
    con2.addData("APPLICATION_GROUP", "String", app_group);
    bolnSuccess2 = con2.executeService( strContainerName, "DOCUMENT_TYPE", "findPermission" );
    
    if(bolnSuccess2) {
    	strPermission = con2.getHeader( "PERMIT_FUNCTION" );
    }
    
	if( strMode.equals("ORDERUP") ) {
        con.addData( "PROJECT_CODE", "String", strProjectCode );
        con.addData( "FIELD_CODE1", "String",  strFieldCode1Choose );
        con.addData( "FIELD_ORDER1", "String", strFieldOrder1Choose );
        con.addData( "FIELD_CODE2", "String",  strFieldCode2Choose );
        con.addData( "FIELD_ORDER2", "String", strFieldOrder2Choose );
        
        bolnSuccess = con.executeService( strContainerName, strClassName, "orderFieldManager" );
        
        if( !bolnSuccess ) {
            strErrorCode    = con.getRemoteErrorCode();
            strErrorMessage = con.getRemoteErrorMesage();
        }
        strMode = "SEARCH";
    }
    
    if( strMode.equals("ORDERDOWN") ) {
        con.addData( "PROJECT_CODE", "String", strProjectCode );
        con.addData( "FIELD_CODE1", "String",  strFieldCode1Choose );
        con.addData( "FIELD_ORDER1", "String", strFieldOrder1Choose );
        con.addData( "FIELD_CODE2", "String",  strFieldCode2Choose );
        con.addData( "FIELD_ORDER2", "String", strFieldOrder2Choose );
        
        bolnSuccess = con.executeService( strContainerName, strClassName, "orderFieldManager" );
        
        if( !bolnSuccess ) {
            strErrorCode    = con.getRemoteErrorCode();
            strErrorMessage = con.getRemoteErrorMesage();
        }
        strMode = "SEARCH";
    }
    
    if( strMode.equals("DELETE") ) {
    	con.addData( "PROJECT_CODE", "String", strProjectCode );
    	con.addData( "FIELD_CODE",   "String", strFieldCodeTemp );
    	con.addData( "FIELD_ORDER",  "String", strFieldOrderTemp );
    	con.addData( "FIELD_TYPE",   "String", strFieldTypeTemp );
		
		bolnSuccess = con.executeService( strContainerName, strClassName, "deleteFieldManager" );
		if( !bolnSuccess ){
			strErrorCode    = con.getRemoteErrorCode();
			strErrorMessage = con.getRemoteErrorMesage();
			if( strErrorCode.equals("ERR00007") ) {
            	strmsg = "showMsg(0,0,\" " + lc_can_not_delete_field_manager + "\")";
            }else {
            	strmsg = "showMsg(0,0,\" " + lc_can_not_delete_data + "\")";
            }
			//strmsg  = "showMsg(0,0,\" " + lc_can_not_delete_data + "\")";
			strMode = "SEARCH";
		}else{
		    strmsg  = "showMsg(0,0,\" " + lc_delete_data_successfull + "\")";
		    strMode = "SEARCH";
		}
	}
    
    if( strMode.equals("SEARCH") ) {
        con.addData( "PROJECT_CODE", "String", strProjectCode );
        
        bolnSuccess = con.executeService( strContainerName, strClassName, "findFieldManager" );
        
        if( !bolnSuccess ) {
            strErrorCode    = con.getRemoteErrorCode();
            strErrorMessage = con.getRemoteErrorMesage();
        }
    }

%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
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
<script language="JavaScript" src="js/jquery-1.9.1.js"></script>
<script language="JavaScript" src="js/function/page-utils.js"></script>
<script language="JavaScript" src="js/label/lb_field_manager.js"></script>
<script language="JavaScript" src="js/util.js"></script>
<script language="JavaScript" src="js/constant.js"></script>
<script language="JavaScript" type="text/javascript">
<!--

var permission	  = "<%=strPermission %>";
var intSeq	  = "<%=intSeq %>";
var strProjCode	  = "<%=strProjectCode %>";
var lastRowSelect = "<%=strLastRowSelect %>";

$(document).ready(window_onload);

function window_onload() {
    set_label();
    set_background("screen_div");
    set_message();
    
    checkedPermission();
    if( lastRowSelect != "" ) {
    	rowSelected( lastRowSelect );
    }
}

function set_label(){
    $("#lb_change_field_order").text(lbl_change_field_order);
    $("#lb_field_seqn").text(lbl_field_seqn);
    $("#lb_field_label").text(lbl_field_label);
    $("#lb_field_code").text(lbl_field_code);
    $("#lb_field_type").text(lbl_field_type);
    $("#lb_field_length").text(lbl_field_length);
    $("#lb_field_null").text(lbl_field_null);
}

function set_message(){
    
<%  if (!strmsg.equals("")) {  %>
    <%=strmsg%>
<%  }   %>
}

function checkedPermission() {
	var subPermission  = permission.indexOf("insert");
	var obj_bttNew     = document.getElementById("new");
	var obj_bttKeys    = document.getElementById("keys");
	var obj_bttSearch  = document.getElementById("search");
	var obj_bttReport  = document.getElementById("report");
	var obj_bttLink    = document.getElementById("link");
	var obj_bttLog     = document.getElementById("log");
	var obj_bttExport  = document.getElementById("export");
	var obj_bttImport  = document.getElementById("import");
	var obj_bttGsearch = document.getElementById("gsearch");

	if( subPermission != -1 ) {
		obj_bttNew.style.display     = "inline";
		obj_bttKeys.style.display    = "inline";
		obj_bttSearch.style.display  = "inline";
		obj_bttReport.style.display  = "inline";
		obj_bttLink.style.display    = "inline";
		obj_bttLog.style.display     = "inline";
<%
	if( bolnSuccess ) {
%>
		obj_bttExport.style.display  = "inline";
<%
    }else {
%>
		obj_bttImport.style.display  = "inline";
<%
    }
%>
		obj_bttGsearch.style.display = "inline";
	}
}

function mouseOver( rowObjOver ) {
    if( rowObjOver.style.background != '#9999ff' ) {
		rowObjOver.style.background = '#b0e0e6';
	}
}

function mouseOut( rowObjOut ){
    if( rowObjOut.style.background != '#9999ff' ) {
		rowObjOut.style.background = '#E6e6fa';
	}
}

function rowSelected( lv_rowIndex, lv_strValue ) {
	var tbResultTable = document.getElementById("resultTable");
	
	if( lv_strValue != null ) {
		form1.FIELD_ORDER1_CHOOSE.value = lv_rowIndex;
		form1.FIELD_CODE1_CHOOSE.value  = lv_strValue.getAttribute("FIELD_CODE");
	}
	if( tbResultTable.rows[ lv_rowIndex ] != null ) {
		tbResultTable.rows[ lv_rowIndex ].style.background = "#e2e9c8";
	}
	if( form1.last_row_select.value != lv_rowIndex ) {
		if( form1.last_row_select.value != "" ) {
			if( form1.last_row_select.value % 2 != 0 ) {
				tbResultTable.rows[ form1.last_row_select.value ].style.background = "#FFFFFF";
			}else {
				tbResultTable.rows[ form1.last_row_select.value ].style.background = "#f9eac7";
			}
		}
	}
	form1.last_row_select.value = lv_rowIndex; 
}

function moveField( lv_strMethod ) {
	var intOrder     = form1.FIELD_ORDER1_CHOOSE.value;
	var strFieldCode = "";
/*	if( intSeq == "0" ) {
		alert( lc_no_field_for_select );
		return;
	}*/
	if( form1.FIELD_ORDER1_CHOOSE.value.length == 0 ) {
		alert( lc_checked_field_select );
		return;
	}
	switch( lv_strMethod ){
		case "up" :
			intOrder     = parseInt(intOrder - 1 );
			strFieldCode = document.getElementById("<%=fieldCode%>"+intOrder);
			if( strFieldCode == null ) {
				alert( lc_can_not_move_field );
				return;
			}
			
			form1.FIELD_ORDER2_CHOOSE.value = intOrder;
			form1.FIELD_CODE2_CHOOSE.value  = strFieldCode.value;
			form1.MODE.value                = "ORDERUP";
			form1.last_row_select.value     = intOrder;
			form1.submit();
			break;
        case "down" :
			intOrder     = parseInt(intOrder) + parseInt( 1 );
			strFieldCode = document.getElementById("<%=fieldCode%>"+intOrder);
			if( strFieldCode == null ) {
				alert( lc_can_not_move_field );
				return;
			}
			
			form1.FIELD_ORDER2_CHOOSE.value = intOrder;
			form1.FIELD_CODE2_CHOOSE.value  = strFieldCode.value;
			form1.MODE.value                = "ORDERDOWN";
			form1.last_row_select.value     = intOrder;
			form1.submit();
			break;
	}
}

function buttonClick( lv_strMethod, lv_strValue ) {
	var strPopArgument = "scrollbars=yes,status=no,toolsbar=no";
	var strWidth       = ",width=530px";
	var strHeight      = ",height=270px";
	var strUrl         = "";
	var strConcatField = "";
	
    switch( lv_strMethod ){
	case "pInsert" :
			formadd.action                 = "field_manager2.jsp";
			formadd.FIELD_CODE_KEY.value   = "";
			formadd.FIELD_LABEL_KEY.value  = "";
			formadd.FIELD_ORDER_KEY.value  = "";
			formadd.FIELD_SEQN_KEY.value   = "";
			formadd.FIELD_TYPE_KEY.value   = "";
			formadd.FIELD_LENGTH_KEY.value = "";
			formadd.MODE.value             = "pInsert";
			formadd.submit();
			break;
        case "pEdit" :
			formadd.action                 = "field_manager2.jsp";
			formadd.FIELD_CODE_KEY.value   = lv_strValue.getAttribute("FIELD_CODE");
			formadd.FIELD_LABEL_KEY.value  = lv_strValue.getAttribute("FIELD_LABEL");
			formadd.FIELD_TYPE_KEY.value   = lv_strValue.getAttribute("FIELD_TYPE");
			formadd.FIELD_LENGTH_KEY.value = lv_strValue.getAttribute("FIELD_LENGTH");
			formadd.FIELD_ORDER_KEY.value  = lv_strValue.getAttribute("FIELD_ORDER");
			formadd.FIELD_SEQN_KEY.value   = lv_strValue.getAttribute("FIELD_SEQN");
			formadd.MODE.value             = "pEdit";
			formadd.submit();
			break;
		case "keysField" :
			//form1.MODE.value = lv_strMethod;
			form1.method     = "post";
			form1.action     = "field_manager3.jsp";
			form1.submit();
			break;
		case "fieldSearch" :
			//form1.MODE.value = lv_strMethod;
			form1.method     = "post";
			form1.action     = "field_manager4.jsp";
			form1.submit();
			break;
		case "fieldReport" :
			//form1.MODE.value = lv_strMethod;
			form1.method     = "post";
			form1.action     = "field_manager5.jsp";
			form1.submit();
			break;
		case "fieldLink" :
			//form1.MODE.value = lv_strMethod;
			form1.method     = "post";
			form1.action     = "field_manager6.jsp";
			form1.submit();
			break;
		case "fieldLog" :
			//form1.MODE.value = lv_strMethod;
			form1.method     = "post";
			form1.action     = "field_manager7.jsp";
			form1.submit();
			break;
		case "fieldGsearch" :
			form1.MODE.value = "SEARCH";
			form1.method     = "post";
			form1.action     = "gsearch_field.jsp";
			form1.submit();
			break;
		case "export" :
			formExport.METHOD_NAME.value = "exportCabinetIndex2XML";
			//formExport.action            = "FieldExportXmlServlet" 
			formExport.submit();
			break;
		case "import" :
			strPopArgument += strWidth + strHeight;
			strUrl         = "inc/import_xmldata.jsp";
			strConcatField = "PROJECT_CODE=" +strProjCode + "&user_role=" + "<%=user_role %>" + "&app_name=" + "<%=app_name %>";
			strConcatField += "&app_group=" + "<%=app_group %>" + "&screenname=" + "<%=screenname %>";
			strConcatField += "&CONTAINER_NAME=" + "<%=strContainerName %>" + "&METHOD_NAME=importXML2Table";
			objZoomWindow  = window.open( strUrl + "?" + strConcatField, "", strPopArgument );
			objZoomWindow.focus();
			break;
		case "DELETE" :
			if( !confirm( lc_confirm_delete_field + lv_strValue.getAttribute("FIELD_LABEL") ) ){
				return;
			}
			form1.MODE.value             = lv_strMethod;
			form1.method                 = "post";
			form1.action                 = "field_manager1.jsp";
			form1.FIELD_CODE_TEMP.value  = lv_strValue.getAttribute("FIELD_CODE");
			form1.FIELD_ORDER_TEMP.value = lv_strValue.getAttribute("FIELD_ORDER");
			form1.FIELD_LABEL_TEMP.value = lv_strValue.getAttribute("FIELD_LABEL");
			form1.FIELD_TYPE_TEMP.value  = lv_strValue.getAttribute("FIELD_TYPE");
			form1.submit();
			break;
	}
}

function afterImportSuccess() {
    setTimeout( "refresh_page()", 3000 );
}

function refresh_page() {
    form1.MODE.value   = "SEARCH";
    form1.RESULT.value = "success";
    form1.method       = "post";
    form1.action       = "field_manager1.jsp";
    form1.submit();
}

//-->
</script>
<link href="css/edas.css" type="text/css" rel="stylesheet">
</head>
<body onLoad="MM_preloadImages('images/btt_addfield_over.gif','images/btt_field_over.gif','images/btt_fieldsearch_over.gif',
			'images/btt_report_over.gif','images/btt_fieldlink_over.gif','images/btt_fieldlog_over.gif','images/btt_edit2_over.gif',
			'images/btt_delete_over.gif','images/btt_globalsearch_over.gif','images/btt_export_over.gif','images/btt_import_2_over.gif');" onresize="set_background('screen_div')">

<form name="form1" method="post" action="" >
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
<tr>
<td valign="top">
<div id="screen_div">
<table width="800" height="100%" border="0" cellpadding="0" cellspacing="0">
    <tr>
        <td valign="top">
            <table width="800" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td colspan="2" height="25" class="label_header01" >&nbsp;&nbsp;<%=screenname%></td>
                </tr>
                <tr>
                    <td colspan="2" height="10">&nbsp;</td>
                </tr>
                <tr>
                    <td>
                        <div align="center">                            
                            <table border="0" cellspacing="0" cellpadding="0">
                                <tr class="label_bold2">
                                    <td align="center"><nobr><span id="lb_change_field_order"></span>&nbsp;</nobr></td>
                                </tr>
                                <tr>
                                    <td align="center">
                                        <a href="#" onclick= "moveField('up')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('mv_up','','images/btt_up_over.gif',1)">
                                            <img id="mv_up" src="images/btt_up.gif" width="67" height="22" border="0"></a>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="center">
                                        <a href="#" onclick= "moveField('down')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('mv_down','','images/btt_down_over.gif',1)">
                                        <img id="mv_down" src="images/btt_down.gif" width="67" height="22" align="top" border="0"></a>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </td>
                    <td><!--  div align="left" -->
                        <div id="field_div" style="width:780px;height:400px;overflow-y:scroll;overflow-x:hidden;margin:0px;border:0px;" >
                        <table id="resultTable" width="100%" border="0" cellpadding="0" cellspacing="0" >
                          <tr class="hd_table"> 
                            <td width="10"><img src="images/hd_tb_01.gif" width="10" height="28"></td>
                            <td width="30">&nbsp;</td>
                            <td width="35" align="center"><span id="lb_field_seqn"></span></td>
                            <td width="150" align="left"><span id="lb_field_label"></span></td>
                            <td width="130" align="left"><span id="lb_field_code"></span></td>
                            <td width="70" align="left"><span id="lb_field_type"></span></td>
                            <td width="55" align="center"><span id="lb_field_length"></span></td>
                            <td width="50" align="center"><span id="lb_field_null"></span></td>
                            <td align="right"><img src="images/hd_tb_04.gif" width="10" height="28"></td>
                          </tr>
<%
    if( bolnSuccess ) {
        intSeq       = 1;
        while( con.nextRecordElement() ){
            strFieldSeqnData   = con.getColumn( "FIELD_SEQN" );
            strFieldOrderData  = con.getColumn( "FIELD_ORDER" );
            strFieldCodeData   = con.getColumn( "FIELD_CODE" );
            strFieldTypeData   = con.getColumn( "FIELD_TYPE" );
            strFieldLengthData = con.getColumn( "FIELD_LENGTH" );
            strFieldLabelData  = con.getColumn( "FIELD_LABEL" );
            strIsNotNullData   = con.getColumn( "IS_NOTNULL" );
            strIsPkData        = con.getColumn( "IS_PK" );
            
            if( strIsPkData.equals("Y") ) {
            	strImgIsPk = "<img src=\"images/iconkey.gif\" width=\"16\" height=\"16\" border=\"0\">";
            }else {
            	strImgIsPk = "";
            }
            if( strIsNotNullData.equals("N") ) {
            	strImgIsNotNull = "<img src=\"images/True.gif\" width=\"16\" height=\"16\" border=\"0\">";
            }else {
            	strImgIsNotNull = "<img src=\"images/False.gif\" width=\"16\" height=\"16\" border=\"0\">";
            }
            if( strPermission.indexOf( "update" ) != -1 ) {
            	strbttEdit = "<img src=\"images/btt_edit2.gif\" name=\"EDIT" + intSeq + "\"  width=\"52\" height=\"18\" border=\"0\" >";
            }
            if( strPermission.indexOf( "delete" ) != -1 ) {
            	strbttDelete = "<img src=\"images/btt_delete.gif\" name=\"Delete" + intSeq + "\"  width=\"52\" height=\"18\" border=\"0\" >";
            }
            strFieldCode = fieldCode + intSeq;
            strScript    = "FIELD_SEQN=\"" + strFieldSeqnData + "\" FIELD_ORDER=\"" + strFieldOrderData + "\" FIELD_CODE=\"" + strFieldCodeData + "\" ";
			strScript    += "FIELD_TYPE=\"" + strFieldTypeData + "\" FIELD_LENGTH=\"" + strFieldLengthData + "\" ";
			strScript    += "FIELD_LABEL=\"" + strFieldLabelData + "\" IS_NOTNULL=\"" + strIsNotNullData + "\" IS_PK=\"" + strIsPkData + "\" ";

            if( intSeq % 2 != 0 ) {
%>
                      
                      <tr class="table_data1" onclick="rowSelected(this.rowIndex,this)"<%=strScript%> >
                        <td>&nbsp;</td>
                        <td><div align="center"><%=strImgIsPk %></div></td>
                        <td><div align="center"><%=strFieldOrderData %></div></td>
                        <td><div align="left"><%=strFieldLabelData %></div></td>
                        <td><div align="left"><%=strFieldCodeData %></div></td>
                        <td><div align="left"><%=strFieldTypeData %></div></td>
                        <td><div align="center"><%=strFieldLengthData %></div></td>
                        <td><div align="center"><%=strImgIsNotNull %></div>
                        	<input type="hidden" id="" name="" value="<%=strFieldSeqnData %>" >
                        	<input type="hidden" id="<%=strFieldCode %>" name="<%=strFieldCode %>" value="<%=strFieldCodeData %>" >
                        </td>
                        <td colspan="2">&nbsp;
                        	<a href="#" onclick="buttonClick('pEdit',this)"<%=strScript%> onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('EDIT<%=intSeq %>','','images/btt_edit2_over.gif',1)"><%=strbttEdit%></a>&nbsp;
          					<a href="#" onclick="buttonClick('DELETE',this)"<%=strScript%> onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Delete<%=intSeq %>','','images/btt_delete_over.gif',1)"><%=strbttDelete%></a>
          				</td>
                      </tr>
<%
            }else{
%>
                    <tr class="table_data2" onclick="rowSelected(this.rowIndex,this)"<%=strScript%> > 
                        <td>&nbsp;</td>
                        <td><div align="center"><%=strImgIsPk %></div></td>
                        <td><div align="center"><%=strFieldOrderData %></div></td>
                        <td><div align="left"><%=strFieldLabelData %></div></td>
                        <td><div align="left"><%=strFieldCodeData %></div></td>
                        <td><div align="left"><%=strFieldTypeData %></div></td>
                        <td><div align="center"><%=strFieldLengthData %></div></td>
                        <td><div align="center"><%=strImgIsNotNull %></div>
                        	<input type="hidden" id="" name="" value="<%=strFieldSeqnData %>" >
                        	<input type="hidden" id="<%=strFieldCode %>" name="<%=strFieldCode %>" value="<%=strFieldCodeData %>" >
                        </td>
                        <td colspan="2">&nbsp;
                        	<a href="#" onclick="buttonClick('pEdit',this)"<%=strScript%> onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('EDIT<%=intSeq %>','','images/btt_edit2_over.gif',1)"><%=strbttEdit%></a>&nbsp;
          					<a href="#" onclick="buttonClick('DELETE',this)"<%=strScript%> onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Delete<%=intSeq %>','','images/btt_delete_over.gif',1)"><%=strbttDelete%></a>
          				</td>
                      </tr>
<%
            }
            intSeq++;
        }
     }
 %>                      
                    </table>
                  </div></td>
              </tr>
              <tr>
              	<td colspan="2" align="center">	
                    <br>
                    <a href="#" onclick= "buttonClick('pInsert')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new','','images/btt_addfield_over.gif',1)">
                    	<img src="images/btt_addfield.gif" id="new" name="new" height="22" border="0" style="display: none"></a>
                    <a href="#" onclick= "buttonClick('keysField')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('keys','','images/btt_field_over.gif',1)">
                    	<img src="images/btt_field.gif" id="keys" name="keys"  height="22" border="0" style="display: none"></a>
                    <a href="#" onclick= "buttonClick('fieldSearch')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('search','','images/btt_fieldsearch_over.gif',1)">
                    	<img src="images/btt_fieldsearch.gif" id="search" name="search"  height="22" border="0" style="display: none"></a>
                    <a href="#" onclick= "buttonClick('fieldReport')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('report','','images/btt_report_over.gif',1)">
                    	<img src="images/btt_report.gif" id="report" name="report"  height="22" border="0" style="display: none"></a>
                    <a href="#" onclick= "buttonClick('fieldLink')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('link','','images/btt_fieldlink_over.gif',1)">
                    	<img src="images/btt_fieldlink.gif" id="link" name="link"  height="22" border="0" style="display: none"></a>
                    <a href="#" onclick= "buttonClick('fieldLog')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('log','','images/btt_fieldlog_over.gif',1)">
                    	<img src="images/btt_fieldlog.gif" id="log" name="log"  height="22" border="0" style="display: none"></a>
<%
    if( bolnSuccess ) {
%>
                    <a href="#" onclick= "buttonClick('export')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('export','','images/btt_export_over.gif',1)">
                    	<img src="images/btt_export.gif" id="export" name="export"  height="22" border="0" style="display: none"></a>
<%
    }else {
%>
					
                    <a href="#" onclick= "buttonClick('import')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('import','','images/btt_import_2_over.gif',1)">
                    	<img src="images/btt_import_2.gif" id="import" name="import"  height="22" border="0" style="display: none"></a>
<%
    }
%>
                    <a href="#" onclick= "buttonClick('fieldGsearch')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('gsearch','','images/btt_globalsearch_over.gif',1)">
                    	<img src="images/btt_globalsearch.gif" id="gsearch" name="gsearch"  height="22" border="0" style="display: none"></a>
            	</td>
              </tr>
            </table>
            <input type="hidden" name="MODE"                value="<%=strMode%>">
			<input type="hidden" name="screenname"          value="<%=screenname%>">
			<input type="hidden" name="PROJECT_CODE"        value="<%=strProjectCode%>">
			<input type="hidden" name="FIELD_ORDER1_CHOOSE" value="<%=strLastRowSelect %>">
			<input type="hidden" name="FIELD_ORDER2_CHOOSE" value="">
			<input type="hidden" name="FIELD_CODE1_CHOOSE"  value="<%=strFieldCode1Choose %>">
			<input type="hidden" name="FIELD_CODE2_CHOOSE"  value="">
			
			<input type="hidden" name="FIELD_CODE_TEMP"     value="">
			<input type="hidden" name="FIELD_ORDER_TEMP"    value="">
			<input type="hidden" name="FIELD_LABEL_TEMP"    value="">
			<input type="hidden" name="FIELD_TYPE_TEMP"     value="">
			
			<input type="hidden" name="FIELD_SEQN"         value="">
			<input type="hidden" name="FIELD_ORDER"        value="">
			<input type="hidden" name="FIELD_TYPE"         value="">
			<input type="hidden" name="FIELD_LENGTH"       value="">
			<input type="hidden" name="IS_NOTNULL"         value="">
			
			<input type="hidden" name="last_row_select" value="">
			<input type="hidden" name="user_role"       value="<%=user_role %>">
			<input type="hidden" name="app_name"        value="<%=app_name %>">
			<input type="hidden" name="app_group"       value="<%=app_group %>">
			<input type="hidden" name="RESULT"          value="<%=strResult %>">
        <p>&nbsp;</p> </td>
    </tr>
</table>
        </div>
        </td>
    </tr>
</table>
</form>

<form name="formadd" method="post" action="" target = "_self">
	<input type="hidden" name="MODE"             value="">
	<input type="hidden" name="FIELD_CODE_KEY"   value="">
	<input type="hidden" name="FIELD_LABEL_KEY"  value="">
	<input type="hidden" name="FIELD_ORDER_KEY"  value="">
	<input type="hidden" name="FIELD_SEQN_KEY"   value="">
	<input type="hidden" name="FIELD_TYPE_KEY"   value="">
	<input type="hidden" name="FIELD_LENGTH_KEY" value="">
	
	<input type="hidden" name="screenname"       value="<%=screenname%>">
	<input type="hidden" name="user_role"        value="<%=user_role %>">
	<input type="hidden" name="app_name"         value="<%=app_name %>">
	<input type="hidden" name="app_group"        value="<%=app_group %>">
</form>

<form name="formExport" method="post" action="FieldExportXmlServlet">
	<input type="hidden" name="PROJECT_CODE"   value="<%=strProjectCode %>">
    <input type="hidden" name="CONTAINER_NAME" value="<%=strContainerName %>">
    <input type="hidden" name="CLASS_NAME"     value="<%=strClassName %>">
    <input type="hidden" name="METHOD_NAME"    value="">
    <input type="hidden" name="REMOTE_SERVER"  value="EAS_SERVER">
    
    <input type="hidden" name="IMPORT_XML_PATH"	value=""  >
    
    <input type="hidden" name="user_role"  value="<%=user_role %>" >
    <input type="hidden" name="app_name"   value="<%=app_name %>" >
    <input type="hidden" name="app_group"  value="<%=app_group %>" >
    <input type="hidden" name="screenname" value="<%=screenname %>" >
</form>
</body>
</html>