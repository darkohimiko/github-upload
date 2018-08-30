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
    String strUserId      = userInfo.getUserId();
	String strProjectCode = userInfo.getProjectCode();
	String user_role      = getField(request.getParameter("user_role"));
	String app_name       = getField(request.getParameter("app_name"));
	String app_group      = getField(request.getParameter("app_group"));

    String screenname   = getField(request.getParameter("screenname"));
    String strClassName = "FIELD_MANAGER";
    String strMode      = getField(request.getParameter("MODE"));
    
    String strFieldCodeKey   = getField(request.getParameter("FIELD_CODE_KEY"));
    String strFieldOrderKey  = getField(request.getParameter("FIELD_ORDER_KEY"));
    String strFieldSeqnKey   = getField(request.getParameter("FIELD_SEQN_KEY"));


	String strProjectCodeData      = getField(request.getParameter("PROJECT_CODE"));
    String strFieldSeqnData        = getField(request.getParameter("hidFieldSeqn"));
    String strFieldOrderData       = getField(request.getParameter("hidFieldOrder"));
    String strFieldCodeData        = getField(request.getParameter("hidFieldCode"));
    String strFieldLabelData       = getField(request.getParameter("txtFieldLabel"));
    String strFieldTypeData        = getField(request.getParameter("hidFieldType"));
    String strFieldLengthData      = getField(request.getParameter("txtFieldLength"));
    String strFieldNullData        = getField(request.getParameter("hidFieldNull"));
    String strTableCodeData        = getField(request.getParameter("hidTableCode"));
    String strTableNameData        = getField(request.getParameter("hidTableName"));
    String strFieldDefaultData     = getField(request.getParameter("txtFieldDefault"));
    String strFieldDefaultNameData = getField(request.getParameter("txtFieldDefaultName"));
    String strFieldDefDateData     = getField(request.getParameter("hidFieldDefDate"));
    
    boolean bolnSuccess     = true;
    String  strErrorCode    = null;
    String  strmsg          = "";
    String  screenLabel     = "";
    String  strCurrentDate  = "";
    String  strVersionLang  = ImageConfUtil.getVersionLang();

    if( strVersionLang.equals("thai") ) {
        strCurrentDate = getTodayDateThai();
    }else{
        strCurrentDate = getTodayDate();
    }
	
    if( strMode == null ){
        strMode = "SEARCH";
    }

    if( strMode.equals( "pInsert" ) ) {
		screenLabel = lb_add_new_field;
		
        con.addData( "PROJECT_CODE", "String", strProjectCode );
		bolnSuccess = con.executeService( strContainerName , strClassName , "findNextFieldSeqn" );
		strFieldSeqnKey = con.getHeader( "SEQN" );
		if( strFieldSeqnKey == null || strFieldSeqnKey.equals("") ) {
			strFieldSeqnKey = "1";
		}
		strFieldCodeKey = "DOCUMENT_INDEX" + strFieldSeqnKey;
		strFieldCodeData = strFieldCodeKey;
		
		con1.addData( "PROJECT_CODE", "String", strProjectCode );
		bolnSuccess = con1.executeService( strContainerName , strClassName , "findNextFieldOrder" );
		strFieldOrderKey = con1.getHeader( "FIELD_ORDER" );
		if( strFieldOrderKey == null || strFieldOrderKey.equals("") ) {
			strFieldOrderKey = "1";
		}
    }else if( strMode.equals( "pEdit" ) ) {
    	screenLabel         = lb_edit_field;
        con.addData( "PROJECT_CODE", "String", strProjectCode );
        con.addData( "FIELD_CODE",   "String", strFieldCodeKey );
    	bolnSuccess = con.executeService( strContainerName , strClassName , "findFieldManagerDetail" );
    	strFieldCodeData    = con.getHeader( "FIELD_CODE" );
    	strFieldLabelData   = con.getHeader( "FIELD_LABEL" );
    	strTableCodeData    = con.getHeader( "TABLE_ZOOM" );
    	strTableNameData    = con.getHeader( "TABLE_NAME" );
    	strFieldTypeData    = con.getHeader( "FIELD_TYPE" );
    	strFieldLengthData  = con.getHeader( "FIELD_LENGTH" );
    	strFieldNullData    = con.getHeader( "IS_NOTNULL" );
    	strFieldDefaultData = con.getHeader( "DEFAULT_VALUE" );
    	
    	if( strFieldTypeData.equals("ZOOM") || strFieldTypeData.equals("LIST") ) {
    		con1.addData( "TABLE_ZOOM",    "String", strTableCodeData );
    		con1.addData( "DEFAULT_VALUE", "String", strFieldDefaultData );
    		bolnSuccess = con1.executeService( strContainerName , strClassName , "findFieldManagerDefaultName" );
    		if( !bolnSuccess ) {
    			strFieldDefaultNameData = "";
    		}else {
    			strFieldDefaultNameData = con1.getHeader( "DEFAULT_VALUE_NAME" );
    		}
    	}
    }
    
//    if( strFieldType.equals("ZOOM")||strFieldType.equals("LIST")||strFieldType.equals("MONTH") ){
//		strSQLHeader 	+= 	"," + strTableZoom + "." + strTableZoom + "_NAME";
//		strSQLJoinTable += 	" LEFT JOIN " + strTableZoom 
//						+ 	" ON(MASTER_SCAN_" + strProjectCode + "." + strFieldCode + "=" 
//						+ 	strTableZoom + "." + strTableZoom + " )";
//		strConcatTableZoom += strTableZoom + ",";
//	}

    if( strMode.equals("ADD") ) {
        con.addData( "PROJECT_CODE",       "String", strProjectCodeData );
        con.addData( "FIELD_SEQN",         "String", strFieldSeqnData );
        con.addData( "FIELD_ORDER",        "String", strFieldOrderData );
        con.addData( "FIELD_CODE",         "String", strFieldCodeData );
        con.addData( "FIELD_MANAGER_TYPE", "String", "DO" );
        con.addData( "FIELD_LABEL",        "String", strFieldLabelData );
        con.addData( "FIELD_TYPE",         "String", strFieldTypeData );
        con.addData( "FIELD_LENGTH",       "String", strFieldLengthData );
        con.addData( "IS_PK",              "String", "N" );
        con.addData( "IS_NOTNULL",         "String", strFieldNullData );
        if( strFieldTypeData.equals("MONTH") ) {
        	con.addData( "TABLE_ZOOM", "String", "MONTH" );
        }else {
        	con.addData( "TABLE_ZOOM", "String", strTableCodeData );
        }
        if( strFieldTypeData.equals("DATE") || strFieldTypeData.equals("DATE_ENG") || strFieldTypeData.equals("MONTH") || strFieldTypeData.equals("MONTH_ENG") || strFieldTypeData.equals("YEAR") ) {
        	con.addData( "DEFAULT_VALUE", "String", strFieldDefDateData );
        }else {
        	con.addData( "DEFAULT_VALUE", "String", strFieldDefaultData );
        }
        con.addData( "ADD_USER",           "String", strUserId );
        con.addData( "ADD_DATE",           "String", strCurrentDate );
        con.addData( "UPD_USER",           "String", strUserId );

        bolnSuccess = con.executeService( strContainerName , strClassName , "insertFieldManager" );
        if( !bolnSuccess ){
            strErrorCode    = con.getRemoteErrorCode();
            if(strErrorCode.equals("ERR00002")){
                strmsg  = "showMsg(0,0,\" " + lc_field_manager_dup + "\")";
                strMode = "pInsert";
            }else{
                strmsg  = "showMsg(0,0,\" " + lc_can_not_insert_field_manager + "\")";
                strMode = "pInsert";
            }
        }else{
            strmsg  = "showMsg(0,0,\" " +  lc_insert_field_manager_successfull + "\")";
            strMode = "MAIN";
        }
     }else if( strMode.equals("EDIT") ) {
    	con.addData( "PROJECT_CODE",  "String", strProjectCodeData );
        con.addData( "FIELD_CODE",    "String", strFieldCodeData );
        con.addData( "FIELD_LABEL",   "String", strFieldLabelData );
        con.addData( "FIELD_TYPE",    "String", strFieldTypeData );
        con.addData( "FIELD_LENGTH",  "String", strFieldLengthData );
        con.addData( "IS_NOTNULL",    "String", strFieldNullData );
        con.addData( "TABLE_ZOOM",    "String", strTableCodeData );
        if( strFieldTypeData.equals("DATE") || strFieldTypeData.equals("DATE_ENG") || strFieldTypeData.equals("MONTH") || strFieldTypeData.equals("MONTH_ENG") || strFieldTypeData.equals("YEAR") ) {
        	con.addData( "DEFAULT_VALUE", "String", strFieldDefDateData );
        }else {
        	con.addData( "DEFAULT_VALUE", "String", strFieldDefaultData );
        }
        con.addData( "EDIT_USER",     "String", strUserId );
        con.addData( "EDIT_DATE",     "String", strCurrentDate );
        con.addData( "UPD_USER",      "String", strUserId );
        
       	bolnSuccess = con.executeService( strContainerName , strClassName , "updateFieldManager"  );
        if( !bolnSuccess ){
            strErrorCode = con.getRemoteErrorCode();
            strmsg  = "showMsg(0,0,\" " + lc_can_not_update_field_manager  + "\")";
            strMode = "pEdit";
        }else{
            strmsg  = "showMsg(0,0,\" " + lc_edit_field_manager_successfull + "\")";
            strMode = "MAIN";
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
<script language="JavaScript" src="js/jquery-1.9.1.js"></script>
<script language="JavaScript" type="text/javascript">
<!--

function window_onload() {
	lb_field_label.innerHTML    = lbl_field_label;
    lb_field_code.innerHTML     = lbl_field_code;
    lb_field_type.innerHTML     = lbl_field_type;
    lb_field_length.innerHTML   = lbl_field_length;
    lb_field_null.innerHTML     = lbl_field_null;
    lb_field_default.innerHTML  = lbl_field_default;
    lb_field_default2.innerHTML = lbl_field_default;
    
    if( mode == "MAIN" ) {
        form1.action     = "field_manager1.jsp";
        form1.target     = "_self";
        form1.MODE.value = "SEARCH";
        form1.submit();
    }else if( mode == "pEdit" ) {
    	obj_selFieldType.value = "<%=strFieldTypeData %>";
    	if( "<%=strFieldNullData %>" == "N" ) {
    		obj_chkFieldNull.checked = true;
    	}else {
    		obj_chkFieldNull.checked = false;
    	}
    	
    	displayHTMLOnLoad( "<%=strFieldTypeData %>" );
    }else if( mode == "pInsert" ) {
    	displayHTML( "CHAR" );
    }
    form1.txtFieldLabel.focus();
}

function displayHTMLOnLoad( lv_selectedValue ) {
	obj_imgZoomTableCode.style.display    = "none";
	obj_txtFieldDecimal.style.display     = "none";
	obj_imgZoomDefaultValue.style.display = "none";
	obj_imgDefaultValue.style.display     = "none";
	obj_txtFieldDefaultName.style.display = "none";
//	obj_trFieldDefatrult.style.display      = "inline";
//	obj_trDateMonthYear.style.display     = "none";
        $("#trFieldDefatrult").show();
        $("#trDateMonthYear").hide();
	obj_txtFieldLength.readOnly           = false;
	obj_txtFieldDecimal.readOnly          = false;
	obj_txtFieldLength.className          = "input_box";
	obj_txtFieldDecimal.className         = "input_box";
	obj_txtFieldDefault.value             = "";
	divTableCode.innerText                = "";
	divTableName.innerText                = "";
	divDefDate.innerText                  = "";
	
	
	if( lv_selectedValue == "CHAR" ) {
		obj_txtFieldLength.className = "input_box";
	}
	
	if( lv_selectedValue == "DATE" || lv_selectedValue == "DATE_ENG" ) {
		obj_txtFieldLength.readOnly       = "readOnly";
		obj_txtFieldLength.className      = "input_box_disable";
//		obj_trDateMonthYear.style.display = "inline";
//		obj_trFieldDefault.style.display  = "none";
                $("#trFieldDefatrult").hide();
                $("#trDateMonthYear").show();
	}
	
	if( lv_selectedValue == "MONTH" ) {
		obj_txtFieldLength.readOnly       = "readOnly";
		obj_txtFieldLength.className      = "input_box_disable";
//		obj_trFieldDefault.style.display  = "none";
//		obj_trDateMonthYear.style.display = "inline";
                $("#trFieldDefatrult").hide();
                $("#trDateMonthYear").show();
		divTableCode.innerText            = "( MONTH - ";
		divTableName.innerText            = lbl_field_display_month + " )";
	}
	
	if( lv_selectedValue == "MONTH_ENG" ) {
		obj_txtFieldLength.readOnly       = "readOnly";
		obj_txtFieldLength.className      = "input_box_disable";
//		obj_trFieldDefault.style.display  = "none";
//		obj_trDateMonthYear.style.display = "inline";
                $("#trFieldDefatrult").hide();
                $("#trDateMonthYear").show();
		divTableCode.innerText            = "( MONTH ENG - ";
		divTableName.innerText            = lbl_field_display_month + " )";
	}
	
	if( lv_selectedValue == "YEAR" ) {
		obj_txtFieldLength.readOnly       = "readOnly";
		obj_txtFieldLength.className      = "input_box_disable";
//		obj_trFieldDefault.style.display  = "none";
//		obj_trDateMonthYear.style.display = "inline";
                $("#trFieldDefatrult").hide();
                $("#trDateMonthYear").show();
	}
	
	if( lv_selectedValue == "CURRENCY" ) {
		obj_txtFieldDecimal.style.display = "inline";
		obj_txtFieldDecimal.value         = "2";
		obj_txtFieldDecimal.className     = "input_box_disable";
		obj_txtFieldDecimal.readOnly      = true;
	}
	
	if( lv_selectedValue == "MEMO" ) {
		obj_txtFieldLength.className = "input_box_disable";
		obj_txtFieldLength.readOnly  = true;
	}
	
	if( lv_selectedValue == "ZOOM" || lv_selectedValue == "LIST" ) {
		obj_imgZoomTableCode.style.display    = "inline";
		//obj_txtFieldDecimal.style.display     = "inline";
		obj_imgZoomDefaultValue.style.display = "inline";
		obj_imgDefaultValue.style.display     = "inline";
		obj_txtFieldDefaultName.style.display = "inline";
		obj_txtFieldLength.className          = "input_box_disable";
		obj_txtFieldLength.readOnly           = true;
	}
	
	if( lv_selectedValue == "PIN" ) {
		obj_txtFieldLength.className = "input_box_disable";
		obj_txtFieldLength.readOnly  = true;
	}
	
	if( lv_selectedValue == "TIN" ) {
		obj_txtFieldLength.className = "input_box_disable";
		obj_txtFieldLength.readOnly  = true;
	}
	
	//======================== MODE pEdit Only ========================
	if( "<%=strTableCodeData %>" != "" ){
   		divTableCode.innerText = "( " + "<%=strTableCodeData %>";
		divTableName.innerText = " - " + "<%=strTableNameData %>" + " )";
   	}
   		// ======== SET FIELD HIDDEN VALUE ========
   	if( "<%=strFieldDefaultData %>" == "CUR_DATE" || "<%=strFieldDefaultData %>" == "CUR_MONTH" || "<%=strFieldDefaultData %>" == "CUR_YEAR" ) {
   		obj_chkFieldDefDate.checked = true;
   		if( "<%=strFieldDefaultData %>" == "CUR_DATE" ) {
   			obj_hidFieldDefDate.value = "CUR_DATE";
   		}else if( "<%=strFieldDefaultData %>" == "CUR_MONTH" ) {
   			obj_hidFieldDefDate.value = "CUR_MONTH";
   		}else if( "<%=strFieldDefaultData %>" == "CUR_YEAR" ) {
   			obj_hidFieldDefDate.value = "CUR_YEAR";
   		}
   	}else {
   		obj_txtFieldDefault.value = "<%=strFieldDefaultData %>";
   	}
   		// ======== SET DISPLAY LABEL ========
   	if( "<%=strFieldTypeData %>" == "DATE" || "<%=strFieldTypeData %>" == "DATE_ENG" ) {
   		divDefDate.innerText = lbl_display_cur_date;
   	}else if( "<%=strFieldTypeData %>" == "MONTH" || "<%=strFieldTypeData %>" == "MONTH_ENG" ) {
		divDefDate.innerText = lbl_display_cur_month;
   	}else if( "<%=strFieldTypeData %>" == "YEAR" ) {
   		divDefDate.innerText = lbl_display_cur_year;
   	}
   	obj_txtFieldLength.value  = "<%=strFieldLengthData %>";
   	//obj_txtFieldDefault.value = "<%=strFieldDefaultData %>";
}

function displayHTML( lv_selectedValue ) {
	obj_imgZoomTableCode.style.display    = "none";
	obj_txtFieldDecimal.style.display     = "none";
	obj_imgZoomDefaultValue.style.display = "none";
	obj_imgDefaultValue.style.display     = "none";
	obj_txtFieldDefaultName.style.display = "none";
//	obj_trFieldDefault.style.display      = "inline";
//	obj_trDateMonthYear.style.display     = "none";
                $("#trFieldDefatrult").show();
                $("#trDateMonthYear").hide();
	obj_txtFieldLength.readOnly           = false;
	obj_txtFieldDecimal.readOnly          = false;
	obj_txtFieldLength.className          = "input_box";
	obj_txtFieldDecimal.className         = "input_box";
	obj_txtFieldDefault.value             = "";
	obj_hidFieldDefDate.value             = "";
	obj_hidTableCode.value                = "";
	obj_chkFieldDefDate.checked           = false;
	divTableCode.innerText                = "";
	divTableName.innerText                = "";
	divDefDate.innerText                  = "";
	
	if( lv_selectedValue == "" ) {
		lv_selectedValue = "CHAR";
	}
	obj_hidFieldType.value = lv_selectedValue;
	
	//======================== MODE pInsert ========================
	if( lv_selectedValue == "CHAR" ) {
		obj_txtFieldLength.value     = "499";
		obj_txtFieldLength.className = "input_box";
	}
	
	if( lv_selectedValue == "DATE" || lv_selectedValue == "DATE_ENG" ) {
		divDefDate.innerText         = lbl_display_cur_date;
		obj_txtFieldLength.value     = "8";
		obj_txtFieldLength.readOnly  = "readOnly";
		obj_txtFieldLength.className = "input_box_disable";
//		obj_trFieldDefault.style.display  = "none";
//		obj_trDateMonthYear.style.display = "inline";
                $("#trFieldDefatrult").hide();
                $("#trDateMonthYear").show();
	}
	
	if( lv_selectedValue == "MONTH" ) {
		divDefDate.innerText         = lbl_display_cur_month;
		obj_txtFieldLength.value     = "2";
		obj_txtFieldLength.readOnly  = "readOnly";
		obj_txtFieldLength.className = "input_box_disable";
		obj_hidTableCode.value       = "MONTH";
		divTableCode.innerText       = "( MONTH - ";
		divTableName.innerText       = " " + lbl_field_display_month + " )";
//		obj_trFieldDefault.style.display  = "none";
//		obj_trDateMonthYear.style.display = "inline";
                $("#trFieldDefatrult").hide();
                $("#trDateMonthYear").show();
	}
	
	if( lv_selectedValue == "MONTH_ENG" ) {
		divDefDate.innerText         = lbl_display_cur_month;
		obj_txtFieldLength.value     = "2";
		obj_txtFieldLength.readOnly  = "readOnly";
		obj_txtFieldLength.className = "input_box_disable";
		obj_hidTableCode.value       = "MONTH_ENG";
		divTableCode.innerText       = "( MONTH ENG - ";
		divTableName.innerText       = " " + lbl_field_display_month + " )";
//		obj_trFieldDefault.style.display  = "none";
//		obj_trDateMonthYear.style.display = "inline";
                $("#trFieldDefatrult").hide();
                $("#trDateMonthYear").show();
	}
	
	if( lv_selectedValue == "YEAR" ) {
		divDefDate.innerText         = lbl_display_cur_year;
		obj_txtFieldLength.value     = "4";
		obj_txtFieldLength.readOnly  = "readOnly";
		obj_txtFieldLength.className = "input_box_disable";
//		obj_trFieldDefault.style.display  = "none";
//		obj_trDateMonthYear.style.display = "inline";
                $("#trFieldDefatrult").hide();
                $("#trDateMonthYear").show();
	}
	
	if( lv_selectedValue == "NUMBER" ) {
		obj_txtFieldLength.value = "16";
	}
	
	if( lv_selectedValue == "CURRENCY" ) {
		obj_txtFieldDecimal.style.display = "inline";
		obj_txtFieldLength.value      = "16";
		obj_txtFieldDecimal.value     = "2";
		obj_txtFieldDecimal.className = "input_box_disable";
		obj_txtFieldDecimal.readOnly  = true;
	}
	
	if( lv_selectedValue == "MEMO" ) {
		obj_txtFieldLength.value     = "4000";
		obj_txtFieldLength.className = "input_box_disable";
		obj_txtFieldLength.readOnly  = true;
	}
	
	if( lv_selectedValue == "ZOOM" || lv_selectedValue == "LIST" ) {
		obj_imgZoomTableCode.style.display    = "inline";
		//obj_txtFieldDecimal.style.display     = "inline";
		obj_imgZoomDefaultValue.style.display = "inline";
		obj_imgDefaultValue.style.display     = "inline";
		obj_txtFieldDefaultName.style.display = "inline";
		obj_txtFieldLength.value     = "15";
		obj_txtFieldLength.className = "input_box_disable";
		obj_txtFieldLength.readOnly  = true;
	}
	
	if( lv_selectedValue == "PIN" ) {
		obj_txtFieldLength.value     = "13";
		obj_txtFieldLength.className = "input_box_disable";
		obj_txtFieldLength.readOnly  = true;
	}
	
	if( lv_selectedValue == "TIN" ) {
		obj_txtFieldLength.value     = "10";
		obj_txtFieldLength.className = "input_box_disable";
		obj_txtFieldLength.readOnly  = true;
	}
}

function openZoom( strZoomType ) {
	var strPopArgument   = "scrollbars=yes,status=no";
	var strWidth         = ",width=370px";
	var strHeight        = ",height=420px";
	var strUrl           = "";
	var strConcatField   = "";

//	if( mode == "pEdit" ) {
//		return;
//	}

	strPopArgument += strWidth + strHeight;

	switch( strZoomType ){
		case "tableCode" :
				if( obj_hidFieldType.value == "ZOOM" ) {
					strUrl = "inc/zoom_data_table_level.jsp";
					strConcatField = "RESULT_FIELD=hidTableCode,hidTableName,hidTableLevel,hidTableLevel1,hidTableLevel2";
					strConcatField += "&CALL_FUNC=" + "checkLevelBeforeDisplayText" ;
					break;
				}else if( obj_hidFieldType.value == "LIST" ) {
//					strUrl = "inc/zoom_table_level1.jsp";
                                        strUrl = "inc/zoom_data_table_level.jsp";
					strConcatField = "RESULT_FIELD=hidTableCode,hidTableName";
					strConcatField += "&CALL_FUNC=" + "checkLevelBeforeDisplayText" ;
					obj_hidTableLevel.value = "1";
					break;
				}
		case "default" :
				if( obj_hidTableCode.value == "" ) {
					alert( lc_check_field_default );
					return;
				}
				strUrl = "inc/zoom_data_table_level1.jsp";
				strConcatField = "TABLE="+ obj_hidTableCode.value + "&TABLE_LABEL=" + obj_hidTableName.value;
				strConcatField += "&RESULT_FIELD=txtFieldDefault,txtFieldDefaultName";
				break;
	}

	objZoomWindow = window.open( strUrl + "?" + strConcatField, strZoomType, strPopArgument );
	objZoomWindow.focus();
}

function checkLevelBeforeDisplayText() {
	if( obj_hidTableLevel.value != "" ) {
		if( obj_hidTableLevel.value == "1" ) {
			obj_imgZoomDefaultValue.style.display = "inline";
			obj_imgDefaultValue.style.display     = "inline";
			obj_txtFieldDefaultName.style.display = "inline";
			displayText();
		}else {
			obj_trFieldDefault.style.display      = "none";
			checkedTable( obj_hidTableLevel1.value );
		}
	}
}

function checkedTable( lv_tableLevel ) {
	frameCheck.TABLE_CODE.value = lv_tableLevel;
	frameCheck.MODE.value       = "SEARCH";
    frameCheck.target           = "frameCheckedTable";
    frameCheck.action           = "frame_checked_table.jsp";
    frameCheck.submit();	
}

function checkedResultTable( lv_tableLevel ) {
	if( form1.chkResult.value == "false" ) {
		alert( lc_check_table_level_before + lv_tableLevel + lc_check_table_level_before_2 );
		//return false;
	}else {
		if( obj_hidTableLevel.value == "3" ) {
			obj_hidTableLevel.value = "";
			checkedTable( obj_hidTableLevel2.value );
		}
		displayText();
	}
}

function displayText() {	
	if( obj_hidTableCode.value != "" ) {
		divTableCode.innerText = "( " + obj_hidTableCode.value;
	}
	if( obj_hidTableName.value != "" ) {
		divTableName.innerText = " - " + obj_hidTableName.value + " )";
	}
}

function clearDefault() {
	obj_txtFieldDefault.value     = "";
	obj_txtFieldDefaultName.value = "";
}

function controlValue() {
	if( obj_hidFieldType.value == "NUMBER") {
		if(event.keyCode < 45 || event.keyCode > 57) {
                    if( event.preventDefault ){
                        event.preventDefault();
                    }else{
                        event.returnValue = false;
                    }
			alert( lc_check_field_format_number_only );
			return;
		}
	}
}

function setDefaultValue() {
	var objIndex = obj_selFieldType.selectedIndex;
	var objValue = obj_selFieldType.options[objIndex].value;
	if( obj_chkFieldDefDate.checked ) {
		if( objValue == "DATE" || objValue == "DATE_ENG" ) {
			obj_hidFieldDefDate.value = "CUR_DATE";
		}else if( objValue == "MONTH" || objValue == "MONTH_ENG" ) {
			obj_hidFieldDefDate.value = "CUR_MONTH";
		}else if( objValue == "YEAR" ) {
			obj_hidFieldDefDate.value = "CUR_YEAR";
		}
	}else {
		obj_hidFieldDefDate.value = "";
	}
}

function verify_form() {
	if( obj_txtFieldLabel.value.length == 0 ) {
        alert( lc_check_field_label );
        obj_txtFieldLabel.focus();
        return false;
    }
	
	if( obj_txtFieldLength.value.length == 0 ) {
        alert( lc_check_field_length );
        obj_txtFieldLength.focus();
        return false;
    }
    
	if( form1.chkFieldNull.checked ) {
        form1.hidFieldNull.value = "N";
    }else {
    	form1.hidFieldNull.value = "Y";
    }
    
    if( obj_hidFieldType.value == "LIST" || obj_hidFieldType.value == "ZOOM" || obj_hidFieldType.value == "MONTH" || obj_hidFieldType.value == "MONTH_ENG" ) {
    	if( obj_hidTableCode.value == "" ) {
	    	alert( lc_check_ref_table );
	    	return false;
	    }
    }
    
	return true;
}

function buttonClick( lv_strMethod ){
    switch( lv_strMethod ){
		case "save" :
		    if(verify_form()){
		        if(form1.MODE.value == "pInsert"){
		            form1.MODE.value = "ADD" ;
		        }else{
		        	if(!confirm(lc_confirm_delete_edit_field)){
		        		return false;
		        	}
		            form1.MODE.value = "EDIT" ;
		        }
				form1.submit();
			}
			break;
		case "cancel" :
			form1.action     = "field_manager1.jsp";
			form1.target 	 = "_self";
		    form1.MODE.value = "SEARCH";
		    form1.submit();
			break;
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

//-->
</script>
<link href="css/edas.css" type="text/css" rel="stylesheet">
</head>
<body onLoad="MM_preloadImages('images/btt_save2_over.gif','images/btt_cancel_over.gif');window_onload();">
<form name="form1" method="post" action="" >
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0" align="center">
  <tr>
    <td valign="top">
    	<table width="800" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td height="25" class="label_header01" colspan="4">&nbsp;&nbsp;<%=screenname%>&nbsp; >> &nbsp;<%=screenLabel %></td>
              </tr>
              <tr>
            	<td height="25" align="center">
            		<table width="622" border="0" cellspacing="0" cellpadding="0">
		                <tr>
		                  	<td height="25" colspan="4">&nbsp;</td>
		                </tr>
		                <tr>
		                	<td align="right">&nbsp;</td>
			                <td height="25" class="label_bold2"><span id="lb_field_label"></span>&nbsp;
			                	<img src="images/mark.gif" width="12" height="11">
			                </td>
			                <td width="438" height="25">
			                	<input id="txtFieldLabel" name="txtFieldLabel" type="text" class="input_box" size="50" maxlength="50" value="<%=strFieldLabelData %>" >
			                </td>
			                <td align="center" valign="top">&nbsp;</td>
	                	</tr>
		                <tr>
		                	<td align="right">&nbsp;</td>
			                <td height="25" class="label_bold2"><span id="lb_field_code"></span>
			                <td width="438" height="25">
			                	<input id="txtFieldCode" name="txtFieldCode" type="text" class="input_box_disable" size="30" maxlength="30" value="<%=strFieldCodeData %>" readonly>
			                </td>
			                <td align="center" valign="top">&nbsp;</td>
	                	</tr>
	                	<tr>
	                		<td align="right">&nbsp;</td>
			                <td height="25" class="label_bold2"><span id="lb_field_type"></span>&nbsp;
			                	<img src="images/mark.gif" width="12" height="11">
			                </td>
			                <td height="25">
			                	<div style="float: left;">
				                	<select id="selFieldType" name="selFieldType" class="input_box" onchange="displayHTML(this.options[this.selectedIndex].value)">
					                  	<option value ="CHAR"    >CHAR</option>
					                  	<option value ="DATE"    >DATE</option>
					                  	<option value ="DATE_ENG">DATE_ENG</option>
					                  	<option value ="MONTH"   >MONTH</option>
					                  	<option value ="MONTH_ENG">MONTH_ENG</option>
					                  	<option value ="YEAR"    >YEAR</option>
					                  	<option value ="NUMBER"  >NUMBER</option>
					                  	<option value ="CURRENCY">CURRENCY</option>
					                  	<option value ="MEMO"    >MEMO</option>
					                  	<option value ="ZOOM"    >ZOOM</option>
					                  	<option value ="LIST"    >LIST</option>
					                  	<option value ="PIN"     >PIN</option>
					                  	<option value ="TIN"     >TIN</option>
				                	</select>&nbsp;
				                	<a href="javascript:openZoom('tableCode');">
				                		<img id="imgZoomTableCode" src="images/search.gif" width="16" height="16" border="0" style="display: none"></a>&nbsp;
				                </div>
			                	<div id="divTableCode" class="label_bold3" style="float: left;"></div>
			                	<div id="divTableName" class="label_bold3" style="float: left;"></div>
			                </td>
			                <td align="center" valign="top">
			                	<input  type="hidden" id="hidFieldType"   name="hidFieldType" value="<%=strFieldTypeData %>" >
			                	<input  type="hidden" id="hidTableCode"   name="hidTableCode" value="<%=strTableCodeData %>" >
			                	<input  type="hidden" id="hidTableName"   name="hidTableName" value="<%=strTableNameData %>" >
			                	<input  type="hidden" id="hidTableLevel"  name="hidTableLevel"  value="" >
			                	<input  type="hidden" id="hidTableLevel1" name="hidTableLevel1" value="" >
			                	<input  type="hidden" id="hidTableLevel2" name="hidTableLevel2" value="" >
			                </td>
	                	</tr>
	                	<tr>
	                		<td align="right">&nbsp;</td>
			                <td height="25" class="label_bold2"><span id="lb_field_length"></span>&nbsp;
			                	<img src="images/mark.gif" width="12" height="11">
			                </td>
			                <td height="25">
			                	<input id="txtFieldLength" name="txtFieldLength" type="text" size="8" maxlength="8" class="input_box" value="<%=strFieldLengthData %>" onkeypress="keypress_number();">&nbsp;
			                	<input id="txtFieldDecimal" name="txtFieldDecimal" type="text" size="4" maxlength="4" style="display: none" class="input_box" onkeypress="keypress_number();">
			                </td>
			                <td align="center" valign="top">&nbsp;</td>
	                	</tr>
	                	<tr>
	                		<td align="right">&nbsp;</td>
			                <td height="25" class="label_bold2"><span id="lb_field_null"></span></td>
			                <td height="25">
			                	<input type="checkbox" id="chkFieldNull" name="chkFieldNull" value="">
			                	<input type="hidden"   name="hidFieldNull" value="<%=strFieldNullData %>">
			                </td>
			                <td align="center" valign="top">&nbsp;</td>
	                	</tr>
	                	<tr id="trFieldDefault">
	                		<td align="right">&nbsp;</td>
			                <td height="25" class="label_bold2"><span id="lb_field_default"></span></td>
			                <td height="25">
			                	<input id="txtFieldDefault" name="txtFieldDefault" type="text" size="10" maxlength="100" class="input_box"  
			                			onkeypress="controlValue();" value="<%=strFieldDefaultData %>" >&nbsp;
			                	<a href="javascript:openZoom('default');">
			                		<img id="imgZoomDefaultValue" src="images/search.gif" width="16" height="16" border="0" style="display: none">&nbsp;</a>
			                	<a href="javascript:clearDefault();">
			                		<img id="imgDefaultValue" src="images/clear.gif" width="18" height="18" border="0" style="display: none" title="ź">&nbsp;</a>
			                	<input id="txtFieldDefaultName" name="txtFieldDefaultName" type="text" size="20" maxlength="20" 
			                			style="display: none" class="input_box_disable" readOnly value="<%=strFieldDefaultNameData %>">
			                </td>
			                <td align="center" valign="top">&nbsp;</td>
	                	</tr>
	                	<tr id="trDateMonthYear">
	                		<td align="right">&nbsp;</td>
			                <td height="25" class="label_bold2"><span id="lb_field_default2"></span></td>
			                <td height="25">
			                	<div style="float: left">
				                	<input type="checkbox" id="chkFieldDefDate" name="chkFieldDefDate" value="" onclick="setDefaultValue()">
				                	<input type="hidden" id="hidFieldDefDate" name="hidFieldDefDate" value="<%=strFieldDefDateData %>">
				                </div>
				                <div id="divDefDate" class="label_bold3" style="float: left;"></div>
			                </td>
			                <td align="center" valign="top">&nbsp;</td>
	                	</tr>
	                	<tr>
	                  		<td height="25" colspan="4">&nbsp;</td>
	                  	</tr>
			            <tr>
				           	<td align="center" colspan="4">
				           		<a href="#" onclick= "buttonClick('save')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('save','','images/btt_save2_over.gif',1)">
				           			<img src="images/btt_save2.gif" name="save" width="67" height="22" border="0"></a>&nbsp;
				           		<a href="#" onclick= "buttonClick('cancel')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('cancel','','images/btt_cancel_over.gif',1)">
				           			<img src="images/btt_cancel.gif" name="cancel" width="67" height="22" border="0"></a>
				           	</td>
			            </tr>
			            <tr>
				           	<td align="center" colspan="4">
					            <input type="hidden" name="MODE"                value="<%=strMode%>">
		              			<input type="hidden" name="screenname"          value="<%=screenname%>">
		              			<input type="hidden" name="hidZoomFieldType"    value="">
		              			<input type="hidden" name="hidFieldDecimal"     value="">
		              			<input type="hidden" name="hidFieldDefaultName" value="">
		              			<input type="hidden" name="hidFieldSeqn"        value="<%=strFieldSeqnKey %>">
		              			<input type="hidden" name="hidFieldCode"        value="<%=strFieldCodeKey %>">
		              			<input type="hidden" name="hidFieldOrder"       value="<%=strFieldOrderKey %>">
		              			<input type="hidden" name="chkResult"           value="">
		              			
		    					<input type="hidden" name="PROJECT_CODE"        value="<%=strProjectCode%>">
								<input type="hidden" name="user_role"           value="<%=user_role %>">
								<input type="hidden" name="app_name"            value="<%=app_name %>">
								<input type="hidden" name="app_group"           value="<%=app_group %>">
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
<iframe name="frameCheckedTable" style="display:none;"></iframe>
</form>

<form id="frameCheck" name="frameCheck" method="post" action="">
	<input type="hidden" name="MODE"                value="">
    <input type="hidden" name="PROJECT_CODE"        value="<%=strProjectCode%>">
	<input type="hidden" name="TABLE_CODE"          value="">
	<input type="hidden" name="user_role"           value="<%=user_role %>">
	<input type="hidden" name="app_name"            value="<%=app_name %>">
	<input type="hidden" name="app_group"           value="<%=app_group %>">
</form>

</body>
</html>
<script language="JavaScript" type="text/javascript">
<!--

var mode                    = "<%=strMode%>";
var obj_txtFieldLabel       = document.getElementById("txtFieldLabel");
var obj_selFieldType        = document.getElementById("selFieldType");
var obj_txtFieldLength      = document.getElementById("txtFieldLength");
var obj_chkFieldNull        = document.getElementById("chkFieldNull");
var obj_txtFieldDecimal     = document.getElementById("txtFieldDecimal");
var obj_txtFieldDefault     = document.getElementById("txtFieldDefault");
var obj_txtFieldDefaultName = document.getElementById("txtFieldDefaultName");

var obj_hidFieldType        = document.getElementById("hidFieldType");
var obj_hidTableCode        = document.getElementById("hidTableCode");
var obj_hidTableName        = document.getElementById("hidTableName");
var obj_hidTableLevel       = document.getElementById("hidTableLevel");
var obj_hidTableLevel1      = document.getElementById("hidTableLevel1");
var obj_hidTableLevel2      = document.getElementById("hidTableLevel2");

var obj_trFieldDefault      = document.getElementById("trFieldDefault");
var obj_imgZoomTableCode    = document.getElementById("imgZoomTableCode");
var obj_imgZoomDefaultValue = document.getElementById("imgZoomDefaultValue");
var obj_imgDefaultValue     = document.getElementById("imgDefaultValue");

var obj_trDateMonthYear     = document.getElementById("trDateMonthYear");
var obj_chkFieldDefDate     = document.getElementById("chkFieldDefDate");
var obj_hidFieldDefDate     = document.getElementById("hidFieldDefDate");

//-->
</script>
<%  if (!strmsg.equals("")) {  %>
<script language="javaScript">
    <%=strmsg%>
</script>
<%  }   %>