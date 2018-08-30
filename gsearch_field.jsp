<%@page import="com.scc.edms.conf.ImageConfUtil"%>
<%@ page contentType="text/html; charset=tis-620"%>
<%@ page import="com.scc.security.UserInfo"%>
<%@ page import="java.math.BigDecimal"%>
<%@ include file="inc/checkUser.jsp" %>
<%@ include file="inc/constant.jsp" %>
<%@ include file="inc/label.jsp" %>
<%@ include file="inc/utils.jsp" %>
<jsp:useBean id="con" scope="session" class="edms.cllib.EABConnector"/>
<jsp:useBean id="con1" scope="session" class="edms.cllib.EABConnector"/>

<%!
	public String getStringDisplay( Hashtable hDisplay, String code ) {
       	return (String)hDisplay.get( code );
    }

	public String getOriginalField( Hashtable hOriginalField, String field ) {
	   	return (String)hOriginalField.get( field );
	}

	public String changeFormatToDisplay( String strFormat ) {
		strFormat = strFormat.replaceAll( "<SCRIPT LANGUAGE=\"javascript\"> ", "" );
		strFormat = strFormat.replaceAll( "<SCRIPT LANGUAGE=javascript> ", "" );
		strFormat = strFormat.replaceAll( "\"", "" );
		strFormat = strFormat.replaceAll( "\\(", "" );
		strFormat = strFormat.replaceAll( "\\)", "" );
		strFormat = strFormat.replaceAll( "dateFormat3", "" );
		strFormat = strFormat.replaceAll( ";</SCRIPT>", "" );
		
		return strFormat;
	}

	public String changeFormatToServer( String strFormat ) {
		strFormat = strFormat.replaceAll( "1x1", "<SCRIPT LANGUAGE=javascript> dateFormat3" );
		strFormat = strFormat.replaceAll( "2x2", "\\(" );
		strFormat = strFormat.replaceAll( "4x4", "\\)" );
		strFormat = strFormat.replaceAll( "5x5", ";</SCRIPT>" );
		strFormat = strFormat.replaceAll( "\\$<", "<" );
		return strFormat;
	}
	
	public String subStringComma( String strField ) {
		if( strField.substring(0,2).equals(", ") ) {
			strField = strField.substring( 2, strField.length() );
    	}
    	if( strField.substring(strField.length()-2, strField.length()).equals(", ") ) {
    		strField = strField.substring( 0, strField.length()-2 );
    	}
    	strField = strField.replaceAll( ",,", ", " );
    	
    	return strField;
	}
%>
<%
	con.setRemoteServer("EAS_SERVER");
	con1.setRemoteServer("EAS_SERVER");

    UserInfo userInfo     = (UserInfo)session.getAttribute( "USER_INFO" );
    String strUserId      = userInfo.getUserId();
	String strProjectCode = userInfo.getProjectCode();
	String strSite        = userInfo.getSite();
	
	String user_role = getField(request.getParameter("user_role"));
	String app_name  = getField(request.getParameter("app_name"));
	String app_group = getField(request.getParameter("app_group"));

    String screenname         = getField(request.getParameter("screenname"));
	String screenLabel        = lb_field_global_search;
    String strClassName       = "FIELD_MANAGER";
    String strClassName2      = "GSEARCH_MANAGER";
    String strMode            = getField(request.getParameter("MODE"));
	String strProjectCodeData = getField(request.getParameter( "PROJECT_CODE" ));
	String strCurrentDate     = "";
	String strVersionLang  = ImageConfUtil.getVersionLang();

        if( strVersionLang.equals("thai") ) {
            strCurrentDate = getServerDateThai();
        }else{
            strCurrentDate = getServerDateEng();
        }

    String strmsg             = "";
    String strFieldCodeData   = "";
    String strFieldLabelData  = "";
    String strFieldTypeData   = "";
    String strFieldLengthData = "";
    String strTableZoomData   = "";
    String strGroupDescData   = "";
    String strTempDisplay     = "";

    String strFieldDisplay           = "";
    String strFieldTemplate          = "";
    String strFieldTemplateHeader    = "";
    String strFieldSort              = "";
    String strFieldTemplateOri       = "";
    String strFieldTemplateHeaderOri = "";
    String strFieldSortOri           = "";
    
    String strSortMethod             = "";
    String strConFieldDisplay        = "";
    String strConFieldTemplate       = "";
    String strConFieldTemplateHeader = "";
    String strConFieldSort           = "";
	String strFieldCode              = "";
	String strOriginalField          = "";
	String arrTemplateHeader []      = {};
	String arrTemplate []            = {};
	String arrFieldSort []           = {};
	String arrOriginalField []       = {};
	String fieldTemplateHeader       = "templateHeader_";
	String fieldTemplate             = "header_";
	String fieldSort                 = "fieldSort_";

	Hashtable hDisplay        = new Hashtable();
	Hashtable hOriginalField  = new Hashtable();
    boolean   bolnSuccess     = false;
    boolean   bolnSuccess1    = false;
    String    strErrorCode    = null;
    String    strErrorMessage = null;
	String    strScript       = "";
	int       intSeq          = 0;

    String strFieldDisplayData      = getField( request.getParameter("field_display") );
    String strGsearchGroupData      = getField( request.getParameter("txtGsearchGroup") );
    String strSortMethodData        = getField( request.getParameter("hidSortMethod") );
    String strTemplateHeaderOriData = getField( request.getParameter("template_header_ori") );
    String strTemplateOriData       = getField( request.getParameter("template_ori") );
    String strFieldSortOriData      = getField( request.getParameter("field_sort_ori") );
    
    if( !strFieldDisplayData.equals("") ) {
    	strFieldDisplayData = strFieldDisplayData.substring( 0, strFieldDisplayData.length()-1 );
    }

    if( strMode == null || strMode.equals("")){
         strMode = "SEARCH";
    }

    if( strMode.equals( "INSERT" ) ) {
        con.addData( "PROJECT_CODE",  "String", strProjectCodeData );
        con.addData( "FIELD_DISPLAY", "String", strFieldDisplayData );
        if( !strTemplateHeaderOriData.equals("") ) {
        	con.addData( "TEMPLATE_HEADER", "String", changeFormatToServer(strTemplateHeaderOriData) );
        }
        if( !strTemplateOriData.equals("") ) {
            con.addData( "TEMPLATE", "String", changeFormatToServer(strTemplateOriData) );
        }
        if( !strFieldSortOriData.equals("") ) {
            con.addData( "FIELD_SORT", "String", strFieldSortOriData );
        }
        if( strProjectCode.equals("00000004") && strSite.equals("RDLAW") ) {
        	con.addData( "IS_AUTOCHECK", "String", "Y" );
        }else {
            con.addData( "IS_AUTOCHECK", "String", "N" );
        }
        con.addData( "GROUP_DESCRIPTION", "String", strGsearchGroupData );
        con.addData( "SORT_METHOD",       "String", strSortMethodData );
        con.addData( "ADD_USER",          "String", strUserId );
        con.addData( "ADD_DATE",          "String", strCurrentDate );
        con.addData( "UPD_USER",          "String", strUserId );

        bolnSuccess = con.executeService( strContainerName , strClassName2 , "insertGsearchManager"  );
		if( !bolnSuccess ){
            strErrorCode    = con.getRemoteErrorCode();
            strErrorMessage = con.getRemoteErrorMesage();
            strmsg  = "showMsg(0,0,\" " + lc_can_not_update_data + "\")";
            strMode = "SEARCH";
        }else{
            strmsg  = "showMsg(0,0,\" " + lc_update_data_successfull + "\")";
            strMode = "SEARCH";
        }
    }

    if( strMode.equals( "UPDATE" ) ) {
    	if( !strTemplateHeaderOriData.equals("") ) {
    		strTemplateHeaderOriData = subStringComma( strTemplateHeaderOriData );
    	}
    	if( !strTemplateOriData.equals("") ) {
    		strTemplateOriData = subStringComma( strTemplateOriData );
    	}
        if( !strFieldSortOriData.equals("") ) {
        	strFieldSortOriData = subStringComma( strFieldSortOriData );
        }
        if( strProjectCode.equals("00000004") && strSite.equals("RDLAW") ) {
        	con.addData( "IS_AUTOCHECK", "String", "Y" );
        }else {
        	con.addData( "IS_AUTOCHECK", "String", "N" );
        }
        
        con.addData( "PROJECT_CODE",      "String", strProjectCodeData );
        con.addData( "FIELD_DISPLAY",     "String", strFieldDisplayData );
		con.addData( "TEMPLATE_HEADER",   "String", changeFormatToServer(strTemplateHeaderOriData) );
		con.addData( "TEMPLATE",          "String", changeFormatToServer(strTemplateOriData) );
		con.addData( "FIELD_SORT",        "String", strFieldSortOriData );
        con.addData( "GROUP_DESCRIPTION", "String", strGsearchGroupData );
        con.addData( "SORT_METHOD",       "String", strSortMethodData );
        con.addData( "EDIT_USER",         "String", strUserId );
        con.addData( "EDIT_DATE",         "String", strCurrentDate );
        con.addData( "UPD_USER",          "String", strUserId );

        bolnSuccess = con.executeService( strContainerName , strClassName2 , "updateGsearchManager"  );
		if( !bolnSuccess ){
            strErrorCode    = con.getRemoteErrorCode();
            strErrorMessage = con.getRemoteErrorMesage();
            strmsg  = "showMsg(0,0,\" " + lc_can_not_update_data + "\")";
            strMode = "SEARCH";
        }else{
            strmsg  = "showMsg(0,0,\" " + lc_update_data_successfull + "\")";
            strMode = "SEARCH";
        }
    }
    
    if(strMode.equals("SEARCH")){
        con.addData( "PROJECT_CODE", "String", strProjectCodeData );
        bolnSuccess = con.executeService( strContainerName , strClassName , "findFieldManager" );
        if( !bolnSuccess ) {
            strErrorCode    = con.getRemoteErrorCode();
            strErrorMessage = con.getRemoteErrorMesage();
        }else {
        	while( con.nextRecordElement() ) {
	        	strFieldCodeData   = con.getColumn( "FIELD_CODE" );
	            strFieldLabelData  = con.getColumn( "FIELD_LABEL" );
	            strFieldTypeData   = con.getColumn( "FIELD_TYPE" );
	            strFieldLengthData = con.getColumn( "FIELD_LENGTH" );
	            strTableZoomData   = con.getColumn( "TABLE_ZOOM" );

	            strOriginalField = strFieldCodeData + "|" + strFieldLabelData + "|" + strFieldTypeData + "|" + strFieldLengthData + "|" + strTableZoomData;
	            hOriginalField.put( strFieldCodeData, strOriginalField );
	            
	            if( strFieldTypeData.equals("LIST") || strFieldTypeData.equals("ZOOM") || strFieldTypeData.equals("MONTH") || strFieldTypeData.equals("MONTH_ENG") ) {
	            	strFieldCodeData = strTableZoomData + "_NAME";
	            	strTempDisplay = strFieldCodeData + "|" + strFieldLabelData + "|" + strFieldTypeData + "|" + strFieldLengthData + "|" + strTableZoomData;
		            hDisplay.put( strFieldCodeData, strTempDisplay);
	            }else {
	            	strTempDisplay = strFieldCodeData + "|" + strFieldLabelData + "|" + strFieldTypeData + "|" + strFieldLengthData + "|" + strTableZoomData;
		            hDisplay.put( strFieldCodeData, strTempDisplay);
	            }
        	}
        }
        //out.println(hDisplay.toString());
        
        con1.addData( "PROJECT_CODE", "String", strProjectCodeData );
        bolnSuccess1 = con1.executeService( strContainerName , strClassName2 , "selectGsearchManager" );

        if( !bolnSuccess1 ) {
            strErrorCode    = con1.getRemoteErrorCode();
            strErrorMessage = con1.getRemoteErrorMesage();
            strMode         = "INSERT";
        }else {
        	strMode                   = "UPDATE";
        	strFieldDisplay           = con1.getHeader( "FIELD_DISPLAY" );
        	strFieldTemplateHeader    = con1.getHeader( "TEMPLATE_HEADER" );
        	strFieldTemplate          = con1.getHeader( "TEMPLATE" );
        	strFieldSort              = con1.getHeader( "FIELD_SORT" );
        	strSortMethod             = con1.getHeader( "SORT_METHOD" );
            strGroupDescData          = con1.getHeader( "GROUP_DESCRIPTION" );
        	strFieldTemplateHeaderOri = changeFormatToDisplay(strFieldTemplateHeader);
        	strFieldTemplateOri       = changeFormatToDisplay(strFieldTemplate);
        	strFieldSortOri           = strFieldSort;
        	//out.println(strFieldTemplateHeader);
        	if( strFieldTemplateHeader.indexOf("javascript") != -1 ) {
        		strFieldTemplateHeader = changeFormatToDisplay( strFieldTemplateHeader );
        	}
        	if( strFieldTemplate.indexOf("javascript") != -1 ) {
        		strFieldTemplate = changeFormatToDisplay( strFieldTemplate );
        	}
        	strFieldTemplateHeader = strFieldTemplateHeader.replaceAll( "\\$", "" );
        	strFieldTemplate       = strFieldTemplate.replaceAll( "\\$", "" );
        }
	}

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@page import="java.util.Hashtable"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=TIS-620">
<title><%=lc_site_name%></title>
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
var sccUtils = new SCUtils;

function window_onload() {
	var sort_method = "<%=strSortMethod %>";
	var groupDesc   = "<%=strGroupDescData %>";
    var wScreen     = screen.availWidth  - 250;
    var hScreen     = screen.availHeight - 230;
	
    //lb_gsearch_gruop.innerHTML        = lbl_gsearch_gruop;
    
    lb_gsearch_all.innerHTML          = lbl_gsearch_all;
    lb_gsearch_all2.innerHTML         = lbl_gsearch_all;
    lb_gsearch_all3.innerHTML         = lbl_gsearch_all;
    
    lb_gsearch_header.innerHTML       = lbl_gsearch_header;
    lb_gsearch_detail.innerHTML       = lbl_gsearch_detail;
    lb_gsearch_sort.innerHTML         = lbl_gsearch_sort;
    lb_gsearch_sort_method.innerHTML  = lbl_gsearch_sort_method;
    lb_gsearch_asending.innerHTML     = lbl_gsearch_asending;
    lb_gsearch_desending.innerHTML    = lbl_gsearch_desending;
    
    lb_gsearch_header2.innerHTML      = lbl_gsearch_header;
    lb_gsearch_detail2.innerHTML      = lbl_gsearch_detail;
    lb_gsearch_sort2.innerHTML        = lbl_gsearch_sort;
    
	lb_field_label.innerHTML          = lbl_field_label;
    lb_field_type_length.innerHTML    = lbl_field_type_length;
	lb_field_label2.innerHTML         = lbl_field_label;
    lb_field_type_length2.innerHTML   = lbl_field_type_length;
	lb_field_label3.innerHTML         = lbl_field_label;
    lb_field_type_length3.innerHTML   = lbl_field_type_length;
	lb_field_label4.innerHTML         = lbl_field_label;
    lb_field_type_length4.innerHTML   = lbl_field_type_length;
	lb_field_label5.innerHTML         = lbl_field_label;
    lb_field_type_length5.innerHTML   = lbl_field_type_length;
	lb_field_label6.innerHTML         = lbl_field_label;
    lb_field_type_length6.innerHTML   = lbl_field_type_length;
    
    screen_div.style.width  = wScreen + "px";
    screen_div.style.height = hScreen + "px";
    
    if( sort_method == "DESC" ) {
    	obj_rdoSortMethod[1].checked = true;
		obj_hidSortMethod.value = sort_method;
    }else {
    	sort_method = "ASC"
    	obj_rdoSortMethod[0].checked = true;
		obj_hidSortMethod.value = sort_method;
    }
    
    if( groupDesc == "" ) {
    	obj_txtGsearchGroup.value = "EDAS";
    }
}

function setSortMethod( method ) {
	obj_hidSortMethod.value = method;
}

function rowSelectedFunc( lv_table, lv_rowIndex, lv_strValue ) {
	var tbResultTable1 = document.getElementById("resultTable1");
	var tbResultTable2 = document.getElementById("resultTable2");
	var tbResultTable3 = document.getElementById("resultTable3");
	var tbResultTable4 = document.getElementById("resultTable4");
	var tbResultTable5 = document.getElementById("resultTable5");
	var tbResultTable6 = document.getElementById("resultTable6");
	
	if( lv_strValue != null ) {
		obj_hidRowSelected1.value   = lv_rowIndex;
		obj_indexSeqn.value         = lv_strValue.getAttribute("INDEX_SEQN");
		obj_fieldType.value         = lv_strValue.getAttribute("FIELD_TYPE");
		obj_tableZoom.value         = lv_strValue.getAttribute("TABLE_ZOOM");
		obj_fieldOrder1Choose.value = lv_strValue.getAttribute("HIDDEN_CODE");
		if( lv_table == "1" || lv_table == "3" || lv_table == "5" ) {
			obj_hidFieldCode1.value = lv_strValue.getAttribute("FIELD_CODE");
			obj_hidFieldCode2.value = "";
		}else {
			obj_hidFieldCode1.value = "";
			obj_hidFieldCode2.value = lv_strValue.getAttribute("FIELD_CODE");
		}
		//obj_hidFieldOrder2.value    = "";
		//obj_fieldOrder1Choose.value = "";
		//obj_fieldCode1Choose.value  = "";
	}
		
	eval( "tbResultTable" +lv_table+ ".rows[" +lv_rowIndex+ "].style.background = '#e2e9c8';" );
	if( obj_last_table_select1.value == lv_table ) {
		if( obj_last_row_select1.value != "" && obj_last_row_select1.value != lv_rowIndex ) {
			if( obj_last_row_select1.value % 2 != 0 ) {
				eval( "tbResultTable" +lv_table+ ".rows[" +obj_last_row_select1.value+ "].style.background = '#FFFFFF';" );
			}else {
				eval( "tbResultTable" +lv_table+ ".rows[" +obj_last_row_select1.value+ "].style.background = '#f9eac7';" );
			}
		}
	}else {
		if( obj_last_row_select1.value != "" ) {
			if( obj_last_row_select1.value % 2 != 0 ) {
				eval( "tbResultTable" +obj_last_table_select1.value+ ".rows[" +obj_last_row_select1.value+ "].style.background = '#FFFFFF';" );
			}else {
				eval( "tbResultTable" +obj_last_table_select1.value+ ".rows[" +obj_last_row_select1.value+ "].style.background = '#f9eac7';" );
			}
		}
	}
	obj_last_row_select1.value   = lv_rowIndex;
	obj_last_table_select1.value = lv_table;
}

function setKeyField( lv_field, lv_strMethod ) {
	var lvLastTable = obj_last_table_select1.value;
	var lvTemp1     = obj_hidFieldCode1.value;
	var lvTemp2     = obj_hidTemplateHeader.value;
	var lvTemp3     = obj_hidTemplate.value;
	var lvTemp4     = obj_hidFieldSort.value;
	var lvTemp5     = obj_hidFieldCode2.value;
	
	if( lvLastTable != lv_field ) {
		return;
	}
	switch( lv_strMethod ){
		case "set" :
			if( lvTemp1 == "" ) {
				alert( lc_checked_field_set_select );
				return;
			}
			if( lv_field == "1" ) {
				if( !checkFieldDup(lvTemp1,lvTemp2) ) {
					return;
				}
			}else if( lv_field == "3" ) {
				if( !checkFieldDup(lvTemp1,lvTemp3) ) {
					return;
				}
			}else if( lv_field == "5" ) {
				if( !checkFieldDup(lvTemp1,lvTemp4) ) {
					return;
				}
			}
			setFieldGsearch( lv_field );
			break;
        case "unset" :
			if( lvTemp5 == "" ) {
				alert( lc_checked_field_set_select );
				return;
			}
			unsetFieldGsearch( lv_field );
			break;
	}
}

function checkFieldDup( lvTemp1, lvTemp2 ) {
	if( lvTemp2.indexOf( lvTemp1 ) != -1 ) {
		return false;
	}
	return true;
}

function setFieldGsearch( lv_field ) {
	var strMainTempHeader = obj_hidTemplateHeaderOri.value;
	var strMainTemp       = obj_hidTemplateOri.value;
	var strFieldSort      = obj_hidFieldSortOri.value;
	var strUptempHeader   = obj_hidFieldCode1.value;
	var strFieldType      = obj_fieldType.value;
	var strTableZoom      = obj_tableZoom.value;
	
	var anchor_header = "#";
	
	if( lv_field == "1" || lv_field == "3" ) {
		if( strFieldType == "LIST" || strFieldType == "ZOOM" || strFieldType == "MONTH" || strFieldType == "MONTH_ENG" ) {
			strUptempHeader = "$" + strTableZoom + "_NAME";
		}else if( strFieldType == "DATE" || strFieldType == "DATE_ENG" ) {
			//strUptempHeader = "1x1" + "2x2" + "3x3" + "$" + strUptempHeader + "3x3" + "4x4" + "5x5";
			strUptempHeader = "1x1" + "2x2" + "$" + strUptempHeader + "4x4" + "5x5";
		}else {
			strUptempHeader = "$" + strUptempHeader;
		}
	}
	
	if( lv_field == "1" ) {
		anchor_header = "#lb_gsearch_header";
		if( strMainTempHeader != "" ) {
			strMainTempHeader += ", "+ strUptempHeader;
		}else {
			strMainTempHeader = strUptempHeader;
		}
		obj_hidTemplateHeaderOri.value = strMainTempHeader;
	}else if( lv_field == "3" ) {
		anchor_header = "#lb_gsearch_detail";
		if( strMainTemp != "" ) {
			strMainTemp += ", "+ strUptempHeader;
		}else {
			strMainTemp = strUptempHeader;
		}
		obj_hidTemplateOri.value = strMainTemp;
	}else if( lv_field == "5" ) {
		anchor_header = "#lb_gsearch_sort";
		if( strFieldSort != "" ) {
			strFieldSort += ", "+ strUptempHeader;
		}else {
			strFieldSort = strUptempHeader;
		}
		obj_hidFieldSortOri.value = strFieldSort;
	}
	form1.action = "gsearch_field.jsp" + anchor_header;
        form1.submit();
}

function unsetFieldGsearch( lv_field ) {
	var strMainTempHeader = obj_hidTemplateHeaderOri.value;
	var strMainTemp       = obj_hidTemplateOri.value;
	var strFieldSort      = obj_hidFieldSortOri.value;
	var strFieldType      = obj_fieldType.value;
	var strTableZoom      = obj_tableZoom.value;
	var strReplace        = obj_hidFieldCode2.value;
	
	if( lv_field != "6" ) {
		if( strFieldType == "LIST" || strFieldType == "ZOOM" || strFieldType == "MONTH" || strFieldType == "MONTH_ENG" ) {
			strReplace = "$" + strTableZoom + "_NAME";
		}else if( strFieldType == "DATE" || strFieldType == "DATE_ENG" ) {
			//strReplace = "<SCRIPT LANGUAGE=javascript> dateFormat3($" + strReplace + ")\;<\/SCRIPT>";
                        //strReplace = "<SCRIPT LANGUAGE=javascript> dateFormat3($" + strReplace + ")\;<\/SCRIPT>";
//		}else {
			strReplace = "$" + strReplace;
		}
	}
	if( lv_field == "2" ) {
		anchor_header = "#lb_gsearch_header";
		strMainTempHeader = ReplaceAll( strMainTempHeader, strReplace, "" );
		obj_hidTemplateHeaderOri.value = strMainTempHeader;
	}else if( lv_field == "4" ) {
		anchor_header = "#lb_gsearch_detail";
		strMainTemp              = ReplaceAll( strMainTemp, strReplace, "" );
		obj_hidTemplateOri.value = strMainTemp;
	}else if( lv_field == "6" ) {
		anchor_header = "#lb_gsearch_sort";
		strFieldSort              = ReplaceAll( strFieldSort, strReplace, "" );
		obj_hidFieldSortOri.value = strFieldSort;
	}
	form1.action = "gsearch_field.jsp" + anchor_header;
        form1.submit();
}

function moveField( lv_strMethod, lv_table ) {
	var strCheckMove   = "";
	var intOrder       = obj_indexSeqn.value;
	var intOrder2      = "";
	var strFieldOri    = "";
	var strNewFieldOri = "";
	var arrFieldOris   = new Array();
	
	if( lv_strMethod == "up" ) {
		intOrder2 = parseInt( intOrder - 1 );
	}else {
		intOrder2 = parseInt( intOrder ) + parseInt( 1 );
	}
	if( lv_table == "2" ) {
		strCheckMove = document.getElementById("<%=fieldTemplateHeader%>"+intOrder2);
		strFieldOri  = obj_hidTemplateHeaderOri.value;
	}else if( lv_table == "4" ) {
		strCheckMove = document.getElementById("<%=fieldTemplate%>"+intOrder2);
		strFieldOri  = obj_hidTemplateOri.value;
	}else if( lv_table == "6" ) {
		strCheckMove = document.getElementById("<%=fieldSort%>"+intOrder2);
		strFieldOri  = obj_hidFieldSortOri.value;
	}
	arrFieldOris = strFieldOri.split(", ");
	
	switch( lv_strMethod ) {
		case "up" :
			if( strCheckMove == null ) {
				alert( lc_can_not_move_up_field_selected );
				return;
			}
			for( var i=0; i<arrFieldOris.length; i++ ) {
				if( i == (intOrder2-1) ) {
					strNewFieldOri += arrFieldOris[ intOrder2 ] + ", ";
				}else if( i == (intOrder-1) ) {
					strNewFieldOri += arrFieldOris[ intOrder - 2 ] + ", ";
				}else {
					strNewFieldOri += arrFieldOris[i] + ", ";
				}
			}
			setValueBeforeUpdate( lv_table, strNewFieldOri );
			form1.submit();
			break;
        case "down" :
			if( strCheckMove == null ) {
				alert( lc_can_not_move_down_field_selected );
				return;
			}
			for( var i=0; i<arrFieldOris.length; i++ ) {
				if( i == (intOrder2-2) ) {
					strNewFieldOri += arrFieldOris[ intOrder ] + ", ";
				}else if( i == (intOrder) ) {
					strNewFieldOri += arrFieldOris[ intOrder2 - 2 ] + ", ";
				}else {
					strNewFieldOri += arrFieldOris[i] + ", ";
				}
			}
			setValueBeforeUpdate( lv_table, strNewFieldOri );
			form1.submit();
			break;
	}
}

function setValueBeforeUpdate( lv_table, lv_value ) {
	if( lv_table == "2" ) {
		obj_hidTemplateHeaderOri.value = lv_value;
	}else if( lv_table == "4" ) {
		obj_hidTemplateOri.value = lv_value;
	}else if( lv_table == "6" ) {
		obj_hidFieldSortOri.value = lv_value;
	}
}

function ReplaceAll( Source, stringToFind, stringToReplace ) {
	var temp  = Source;
    var index = temp.indexOf( stringToFind );
    
   	while( index != -1 ) {
		temp  = temp.replace( stringToFind, stringToReplace );
		index = temp.indexOf( stringToFind );
	}
	return temp;
}

function buttonClick( lv_strMethod ){	
    switch( lv_strMethod ){
		case "setIndex" :
			form1.action     = "field_manager4.jsp";
			form1.MODE.value = "SETINDEX";
			form1.submit();
			break;
        case "cancel" :
			formback.action     = "field_manager1.jsp";
			formback.target 	 = "_self";
		    formback.MODE.value = "SEARCH";
		    formback.submit();
			break;
	}
}

//-->
</script>
<link href="css/edas.css" type="text/css" rel="stylesheet">
</head>
<body onLoad="MM_preloadImages('images/btt_back_over.gif','images/btt_down_over.gif','images/btt_up_over.gif','images/put_right_over.gif','images/put_left_over.gif');window_onload()">
<form name="form1" method="post" action="" >
    <table width="769" border="0" cellspacing="0" cellpadding="0">
        <tr>
            <td height="25" class="label_header01">&nbsp;&nbsp;&nbsp;<%=screenname%>&nbsp; >> &nbsp;<%=screenLabel %></td>
        </tr>
        <tr>
        	<td height="10">&nbsp;</td>
        </tr>
   	</table>
   	<div id="screen_div" style="width:730px;height:500px;overflow-y:scroll;overflow-x:hidden;margin-right:0px;margin-bottom:0px;border:1px #ccc solid;" >
   	<table width="720" border="0" cellspacing="0" cellpadding="0" >
        <tr>
            <td height="25" align="center">
            	<table width="670" border="0" align="center" cellpadding="0" cellspacing="0">
            		<!-- tr>
            			<td>
            				<span id="lb_gsearch_gruop" class="label_bold2"></span>&nbsp;&nbsp;
            					<input type="text" id="txtGsearchGroup" name="txtGsearchGroup" class="input_box" size="30" value="<%=strGroupDescData %>">
            			</td>
            		</tr-->
                    <tr>
                        <td height="25">
                            <fieldset><legend class="label_bold2"><span id="lb_gsearch_header"></span></legend>
                                <table width="100%" border="0">
                                	<tr>
					                	<td height="25" class="label_bold2">&nbsp;</td>
					                	<td height="25" class="label_bold2">
					                		<span id="lb_gsearch_all"></span>
						                </td>
					                	<td height="25" class="label_bold2">&nbsp;</td>
						                <td width="275" height="25" class="label_bold2">
						                	<span id="lb_gsearch_header2"></span>
						                </td>
				                	</tr>
                                    <tr>
			                            <td height="25" class="label_bold2">&nbsp;</td>
						                <td height="25">
						                	<table id="resultTable1" width="300" border="0" cellpadding="0" cellspacing="0">
						                		<tr class="hd_table">
						                			<td width="10"><img src="images/hd_tb_01.gif" width="10" height="28"></td>
							                        <td width="150" align="left"><span id="lb_field_label"></span></td>
							                        <td width="130" align="left"><span id="lb_field_type_length"></span></td>
							                        <td align="right"><img src="images/hd_tb_04.gif" width="10" height="28"></td>
						                		</tr>
<%
	con.addData( "PROJECT_CODE", "String", strProjectCodeData );
	bolnSuccess = con.executeService( strContainerName , strClassName , "findFieldManager" );
	if( !bolnSuccess ) {
	    strErrorCode    = con.getRemoteErrorCode();
	    strErrorMessage = con.getRemoteErrorMesage();
	}else {
    //if( (bolnSuccess) ) {
        intSeq = 1;
        while( con.nextRecordElement() ){
        	strFieldCodeData   = con.getColumn( "FIELD_CODE" );
            strFieldLabelData  = con.getColumn( "FIELD_LABEL" );
            strFieldTypeData   = con.getColumn( "FIELD_TYPE" );
            strFieldLengthData = con.getColumn( "FIELD_LENGTH" );
            strTableZoomData   = con.getColumn( "TABLE_ZOOM" );
            
            strScript = "FIELD_TYPE=\"" + strFieldTypeData + "\" FIELD_LENGTH=\"" + strFieldLengthData + "\" ";
            strScript += "FIELD_LABEL=\"" + strFieldLabelData + "\" TABLE_ZOOM=\"" + strTableZoomData + "\" ";
            if( strFieldTypeData.equals("LIST") || strFieldTypeData.equals("ZOOM") || strFieldTypeData.equals("MONTH") ) {
            	strScript += "FIELD_CODE=\"" + strTableZoomData + "_NAME\" ";
            }else {
            	strScript += "FIELD_CODE=\"" + strFieldCodeData + "\" ";
            }
            
            if( strFieldTypeData.equals("LIST") || strFieldTypeData.equals("ZOOM") || strFieldTypeData.equals("MONTH") || strFieldTypeData.equals("MONTH_ENG") ) {
            	strConFieldDisplay += strTableZoomData + "_NAME" + ",";
            }else {
            	strConFieldDisplay += strFieldCodeData + ",";
            }

            if( intSeq % 2 != 0 ) {
%>
												<tr class="table_data1" onclick="rowSelectedFunc('1',this.rowIndex,this)"<%=strScript%> >
							                        <td>&nbsp;</td>
							                        <td><div><%=strFieldLabelData %></div></td>
							                        <td colspan="2"><div><%=strFieldTypeData %>(<%=strFieldLengthData %>)</div></td>
							                    </tr>
<%
            }else{
%>
							                    <tr class="table_data2" onclick="rowSelectedFunc('1',this.rowIndex,this)"<%=strScript%> > 
							                        <td>&nbsp;</td>
							                        <td><div><%=strFieldLabelData %></div></td>
							                        <td colspan="2"><div><%=strFieldTypeData %>(<%=strFieldLengthData %>)</div></td>
							                    </tr>
<%
            }
            intSeq++;
        }
     }
%>
						                	</table>
						                </td>
						                <td>
						                	<table align="center">
						                		<tr>
						                			<td align="center">
						                				<div align="center">
							                				<a href="#lb_gsearch_header" onclick= "setKeyField('1','set')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('right1','','images/put_right.gif',1)">
											           			<img src="images/put_right.gif" id="right1" name="right1" width="26" height="19" border="0"></a>
											           	</div>
											           	<div align="center">
											           		<a href="#lb_gsearch_header" onclick= "setKeyField('2','unset')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('left1','','images/put_left.gif',1)">
											           			<img src="images/put_left.gif" id="left1" name="left1" width="26" height="19" border="0"></a>
											           	</div>
						                			</td>
						                		</tr>
						                	</table>
						                </td>			                
						                <td align="center" valign="top">
						                	<table id="resultTable2" width="300" border="0" cellpadding="0" cellspacing="0">
						                		<tr class="hd_table">
						                			<td width="10"><img src="images/hd_tb_01.gif" width="10" height="28"></td>
							                        <td width="150" align="left"><span id="lb_field_label2"></span></td>
							                        <td width="130" align="left"><span id="lb_field_type_length2"></span></td>
							                        <td align="right"><img src="images/hd_tb_04.gif" width="10" height="28"></td>
						                		</tr>
<%
	//TEMPLATE HEADER
    if( (bolnSuccess1) && !strFieldTemplateHeader.equals("") ) {
    	intSeq = 1;
        arrTemplateHeader = strFieldTemplateHeader.split( ", " );
        if( arrTemplateHeader.length > 0 ) {
	        for( int i=0; i<arrTemplateHeader.length; i++ ) {
	            String strTemp            = arrTemplateHeader[i];
	            String strFuncDisplay     = getStringDisplay( hDisplay, arrTemplateHeader[i] );
	            String arrFuncDisplay []  = strFuncDisplay.split( "\\|" );
	            String strFuncCode        = arrFuncDisplay[0];
	            String strFuncLable       = arrFuncDisplay[1];
	            String strFuncType        = arrFuncDisplay[2];
	            String strFuncLength      = arrFuncDisplay[3];
	            String strFuncZoom        = "";
	            if( arrFuncDisplay.length == 5 ) {
	            	strFuncZoom = arrFuncDisplay[4];
	            }
	            
	            strConFieldTemplateHeader += strTemp + ";";
				strFieldCode              = fieldTemplateHeader + intSeq;
	            
	            strScript = "FIELD_TYPE=\"" + strFuncType + "\" FIELD_LENGTH=\"" + strFuncLength + "\" FIELD_LABEL=\"" + strFuncLable + "\" ";
	            strScript += "FIELD_CODE=\"" + strFuncCode + "\" HIDDEN_CODE=\"" + strFieldCode + "\" INDEX_SEQN=\"" + intSeq + "\"";
	            if( arrFuncDisplay.length == 5 ) {
	            	strScript += "TABLE_ZOOM=\"" + strFuncZoom + "\" ";
	            }
	
	            if( intSeq % 2 != 0 ) {
%>
												<tr class="table_data1" onclick="rowSelectedFunc('2',this.rowIndex,this)"<%=strScript%> >
							                        <td>&nbsp;</td>
							                        <td><div><%=strFuncLable %></div></td>
							                        <td colspan="2">
							                        	<div><%=strFuncType %>(<%=strFuncLength %>)</div>
							                        	<input type="hidden" id="<%=strFieldCode %>" name="<%=strFieldCode %>" value="<%=strTemp %>" >
							                        </td>
							                    </tr>
<%
            }else{
%>
							                    <tr class="table_data2" onclick="rowSelectedFunc('2',this.rowIndex,this)"<%=strScript%> > 
							                        <td>&nbsp;</td>
							                        <td><div><%=strFuncLable %></div></td>
							                        <td colspan="2">
							                        	<div><%=strFuncType %>(<%=strFuncLength %>)</div>
							                        	<input type="hidden" id="<%=strFieldCode %>" name="<%=strFieldCode %>" value="<%=strTemp %>" >
							                        </td>
							                    </tr>
<%
	            }
	            intSeq++;
	        }
        }
     }
%>
						                	</table>
						                </td>
                                    </tr>
									<tr>
									  	<td align="right" colspan="4" class="label_bold2">
						                	<span id="lb_change_field"></span>&nbsp;&nbsp;
									  		<a href="#" onclick= "moveField('up','2')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('mv_up1','','images/btt_up_over.gif',1)">
									  			<img id="mv_up1" src="images/btt_up.gif" width="67" height="22" border="0" align="absmiddle"></a>
									  		<a href="#" onclick= "moveField('down','2')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('mv_down1','','images/btt_down_over.gif',1)">
									  			<img id="mv_down1" src="images/btt_down.gif" width="67" height="22" align="absmiddle" border="0"></a>
									  	</td>
									</tr>
                                </table>
                            </fieldset>
                        </td>
                    </tr>
                    <tr>
                        <td height="25">
                            <fieldset><legend class="label_bold2"><span id="lb_gsearch_detail"></span></legend>
                                <table width="100%" border="0">
                                	<tr>
					                	<td height="25" class="label_bold2">&nbsp;</td>
					                	<td height="25" class="label_bold2">
					                		<span id="lb_gsearch_all2"></span>
						                </td>
					                	<td height="25" class="label_bold2">&nbsp;</td>
						                <td width="438" height="25" class="label_bold2">
						                	<span id="lb_gsearch_detail2"></span>
						                </td>
				                	</tr>
                                    <tr>
			                            <td height="25" class="label_bold2">&nbsp;</td>
						                <td height="25">
						                	<table id="resultTable3" width="300" border="0" cellpadding="0" cellspacing="0">
						                		<tr class="hd_table">
						                			<td width="10"><img src="images/hd_tb_01.gif" width="10" height="28"></td>
							                        <td width="150" align="left"><span id="lb_field_label3"></span></td>
							                        <td width="130" align="left"><span id="lb_field_type_length3"></span></td>
							                        <td align="right"><img src="images/hd_tb_04.gif" width="10" height="28"></td>
						                		</tr>
<%
	con.addData( "PROJECT_CODE", "String", strProjectCodeData );
	bolnSuccess = con.executeService( strContainerName , strClassName , "findFieldManager" );
	if( !bolnSuccess ) {
	    strErrorCode    = con.getRemoteErrorCode();
	    strErrorMessage = con.getRemoteErrorMesage();
	}else {
    //if( (bolnSuccess) ) {
        intSeq = 1;
        //con.firstRecordElement();
        while( con.nextRecordElement() ){
        	strFieldCodeData   = con.getColumn( "FIELD_CODE" );
            strFieldLabelData  = con.getColumn( "FIELD_LABEL" );
            strFieldTypeData   = con.getColumn( "FIELD_TYPE" );
            strFieldLengthData = con.getColumn( "FIELD_LENGTH" );
            strTableZoomData   = con.getColumn( "TABLE_ZOOM" );
            
            strScript = "FIELD_TYPE=\"" + strFieldTypeData + "\" FIELD_LENGTH=\"" + strFieldLengthData + "\" ";
            strScript += "FIELD_LABEL=\"" + strFieldLabelData + "\" TABLE_ZOOM=\"" + strTableZoomData + "\" ";
            if( strFieldTypeData.equals("LIST") || strFieldTypeData.equals("ZOOM") || strFieldTypeData.equals("MONTH") || strFieldTypeData.equals("MONTH_ENG") ) {
            	strScript += "FIELD_CODE=\"" + strTableZoomData + "_NAME\" ";
            }else {
            	strScript += "FIELD_CODE=\"" + strFieldCodeData + "\" ";
            }
            
            if( intSeq % 2 != 0 ) {
%>
												<tr class="table_data1" onclick="rowSelectedFunc('3',this.rowIndex,this)"<%=strScript%> >
							                        <td>&nbsp;</td>
							                        <td><div><%=strFieldLabelData %></div></td>
							                        <td colspan="2"><div><%=strFieldTypeData %>(<%=strFieldLengthData %>)</div></td>
							                    </tr>
<%
            }else{
%>
							                    <tr class="table_data2" onclick="rowSelectedFunc('3',this.rowIndex,this)"<%=strScript%> > 
							                        <td>&nbsp;</td>
							                        <td><div><%=strFieldLabelData %></div></td>
							                        <td colspan="2"><div><%=strFieldTypeData %>(<%=strFieldLengthData %>)</div></td>
							                    </tr>
<%
            }
            intSeq++;
        }
     }
%>
						                	</table>
						                </td>
						                <td>
						                	<table align="center">
						                		<tr>
						                			<td align="center">
						                				<div align="center">
							                				<a href="#lb_gsearch_detail" onclick= "setKeyField('3','set')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('right2','','images/put_right.gif',1)">
											           			<img src="images/put_right.gif" id="right2" name="right2" width="26" height="19" border="0"></a>
											           	</div>
											           	<div align="center">
											           		<a href="#lb_gsearch_detail" onclick= "setKeyField('4','unset')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('left2','','images/put_left.gif',1)">
											           			<img src="images/put_left.gif" id="left2" name="left2" width="26" height="19" border="0"></a>
											           	</div>
						                			</td>
						                		</tr>
						                	</table>
						                </td>			                
						                <td align="center" valign="top">
						                	<table id="resultTable4" width="300" border="0" cellpadding="0" cellspacing="0">
						                		<tr class="hd_table">
						                			<td width="10"><img src="images/hd_tb_01.gif" width="10" height="28"></td>
							                        <td width="150" align="left"><span id="lb_field_label4"></span></td>
							                        <td width="130" align="left"><span id="lb_field_type_length4"></span></td>
							                        <td align="right"><img src="images/hd_tb_04.gif" width="10" height="28"></td>
						                		</tr>
<%
	//TEMPLATE
    if( (bolnSuccess1) && !strFieldTemplate.equals("") ) {
        intSeq = 1;
        arrTemplate = strFieldTemplate.split( ", " );
        if( arrTemplate.length > 0 ) {
	        for( int i=0; i<arrTemplate.length; i++ ) {
	        	String strTemp           = arrTemplate[i];
	        	String strFuncDisplay    = getStringDisplay( hDisplay, arrTemplate[i] );
	            String arrFuncDisplay [] = strFuncDisplay.split( "\\|" );
	            String strFuncCode       = arrFuncDisplay[0];
	            String strFuncLable      = arrFuncDisplay[1];
	            String strFuncType       = arrFuncDisplay[2];
	            String strFuncLength     = arrFuncDisplay[3];
	            String strFuncZoom        = "";
	            if( arrFuncDisplay.length == 5 ) {
	            	strFuncZoom = arrFuncDisplay[4];
	            }
	            
	            strConFieldTemplate += strTemp + ", ";
				strFieldCode        = fieldTemplate + intSeq;

	            strScript = "FIELD_TYPE=\"" + strFuncType + "\" FIELD_LENGTH=\"" + strFuncLength + "\" FIELD_LABEL=\"" + strFuncLable + "\" ";
	            strScript += "FIELD_CODE=\"" + strFuncCode + "\" HIDDEN_CODE=\"" + strFieldCode + "\" INDEX_SEQN=\"" + intSeq + "\"";
	            if( arrFuncDisplay.length == 5 ) {
	            	strScript += "TABLE_ZOOM=\"" + strFuncZoom + "\" ";
	            }

	            if( intSeq % 2 != 0 ) {
%>
												<tr class="table_data1" onclick="rowSelectedFunc('4',this.rowIndex,this)"<%=strScript%> >
							                        <td>&nbsp;</td>
							                        <td><div><%=strFuncLable %></div></td>
							                        <td colspan="2">
							                        	<div><%=strFuncType %>(<%=strFuncLength %>)</div>
							                        	<input type="hidden" id="<%=strFieldCode %>" name="<%=strFieldCode %>" value="<%=strTemp %>" >
							                        </td>
							                    </tr>
<%
            	}else{
%>
							                    <tr class="table_data2" onclick="rowSelectedFunc('4',this.rowIndex,this)"<%=strScript%> > 
							                        <td>&nbsp;</td>
							                        <td><div><%=strFuncLable %></div></td>
							                        <td colspan="2">
							                        	<div><%=strFuncType %>(<%=strFuncLength %>)</div>
							                        	<input type="hidden" id="<%=strFieldCode %>" name="<%=strFieldCode %>" value="<%=strTemp %>" >
							                        </td>
							                    </tr>
<%
	            }
	            intSeq++;
	        }
        }
     }
%>
						                	</table>
						                </td>
                                    </tr>
									<tr>
									  	<td align="right" colspan="4" class="label_bold2">
						                	<span id="lb_change_field"></span>&nbsp;&nbsp;
									  		<a href="#" onclick= "moveField('up','4')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('mv_up2','','images/btt_up_over.gif',1)">
									  			<img id="mv_up2" src="images/btt_up.gif" width="67" height="22" border="0" align="absmiddle"></a>
									  		<a href="#" onclick= "moveField('down','4')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('mv_down2','','images/btt_down_over.gif',1)">
									  			<img id="mv_down2" src="images/btt_down.gif" width="67" height="22" align="absmiddle" border="0"></a>
									  	</td>
									</tr>
                                </table>
                            </fieldset>
                        </td>
                    </tr>
                    <tr>
                      <td height="25">
                          <fieldset><legend class="label_bold2"><span id="lb_gsearch_sort"></span></legend>
                              <table width="100%" border="0">
                              		<tr>
                                        <td colspan="4">
                                        	<span id="lb_gsearch_sort_method" class="label_bold2"></span>&nbsp;&nbsp;
                                            	<input id="rdoSortMethod" name="rdoSortMethod" type="radio" onclick="setSortMethod('ASC')">&nbsp;&nbsp;
                                            <span id="lb_gsearch_asending" class="label_bold2"></span>&nbsp;&nbsp;
                                            	<input id="rdoSortMethod" name="rdoSortMethod" type="radio" onclick="setSortMethod('DESC')">&nbsp;&nbsp;
                                            <span id="lb_gsearch_desending" class="label_bold2"></span>
                                            	<input type="hidden" id="hidSortMethod" name="hidSortMethod" value="">
                                        </td>
                              		</tr>
                                	<tr>
					                	<td height="25" class="label_bold2">&nbsp;</td>
					                	<td height="25" class="label_bold2">
					                		<span id="lb_gsearch_all3"></span>
						                </td>
					                	<td height="25" class="label_bold2">&nbsp;</td>
						                <td width="438" height="25" class="label_bold2">
						                	<span id="lb_gsearch_sort2"></span>
						                </td>
				                	</tr>
                                    <tr>
			                            <td height="25" class="label_bold2">&nbsp;</td>
						                <td height="25">
						                	<table id="resultTable5" width="300" border="0" cellpadding="0" cellspacing="0">
						                		<tr class="hd_table">
						                			<td width="10"><img src="images/hd_tb_01.gif" width="10" height="28"></td>
							                        <td width="150" align="left"><span id="lb_field_label5"></span></td>
							                        <td width="130" align="left"><span id="lb_field_type_length5"></span></td>
							                        <td align="right"><img src="images/hd_tb_04.gif" width="10" height="28"></td>
						                		</tr>
<%
	con.addData( "PROJECT_CODE", "String", strProjectCodeData );
	bolnSuccess = con.executeService( strContainerName , strClassName , "findFieldManager" );
	if( !bolnSuccess ) {
	    strErrorCode    = con.getRemoteErrorCode();
	    strErrorMessage = con.getRemoteErrorMesage();
	}else {
    //if( (bolnSuccess) ) {
        intSeq = 1;
        //con.firstRecordElement();
        while( con.nextRecordElement() ){
        	strFieldCodeData   = con.getColumn( "FIELD_CODE" );
            strFieldLabelData  = con.getColumn( "FIELD_LABEL" );
            strFieldTypeData   = con.getColumn( "FIELD_TYPE" );
            strFieldLengthData = con.getColumn( "FIELD_LENGTH" );
            strTableZoomData   = con.getColumn( "TABLE_ZOOM" );
            
            strScript = "FIELD_TYPE=\"" + strFieldTypeData + "\" FIELD_LENGTH=\"" + strFieldLengthData + "\" FIELD_CODE=\"" + strFieldCodeData + "\"";
            strScript += "FIELD_LABEL=\"" + strFieldLabelData + "\" TABLE_ZOOM=\"" + strTableZoomData + "\" ";
            
            if( intSeq % 2 != 0 ) {
%>
												<tr class="table_data1" onclick="rowSelectedFunc('5',this.rowIndex,this)"<%=strScript%> >
							                        <td>&nbsp;</td>
							                        <td><div><%=strFieldLabelData %></div></td>
							                        <td colspan="2"><div><%=strFieldTypeData %>(<%=strFieldLengthData %>)</div></td>
							                    </tr>
<%
            }else{
%>
							                    <tr class="table_data2" onclick="rowSelectedFunc('5',this.rowIndex,this)"<%=strScript%> > 
							                        <td>&nbsp;</td>
							                        <td><div><%=strFieldLabelData %></div></td>
							                        <td colspan="2"><div><%=strFieldTypeData %>(<%=strFieldLengthData %>)</div></td>
							                    </tr>
<%
            }
            intSeq++;
        }
     }
%>
						                	</table>
						                </td>
						                <td>
						                	<table align="center">
						                		<tr>
						                			<td align="center">
						                				<div align="center">
							                				<a href="#lb_gsearch_sort" onclick= "setKeyField('5','set')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('right3','','images/put_right.gif',1)">
											           			<img src="images/put_right.gif" id="right3" name="right3" width="26" height="19" border="0"></a>
											           	</div>
											           	<div align="center">
											           		<a href="#lb_gsearch_sort" onclick= "setKeyField('6','unset')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('left3','','images/put_left.gif',1)">
											           			<img src="images/put_left.gif" id="left3" name="left3" width="26" height="19" border="0"></a>
											           	</div>
						                			</td>
						                		</tr>
						                	</table>
						                </td>			                
						                <td align="center" valign="top">
						                	<table id="resultTable6" width="300" border="0" cellpadding="0" cellspacing="0">
						                		<tr class="hd_table">
						                			<td width="10"><img src="images/hd_tb_01.gif" width="10" height="28"></td>
							                        <td width="150" align="left"><span id="lb_field_label6"></span></td>
							                        <td width="130" align="left"><span id="lb_field_type_length6"></span></td>
							                        <td align="right"><img src="images/hd_tb_04.gif" width="10" height="28"></td>
						                		</tr>
<%
	//FIELD SORT
    if( (bolnSuccess1) && !strFieldSort.equals("") ) {
        intSeq = 1;
        arrFieldSort = strFieldSort.split( ", " );
        if( arrFieldSort.length > 0 ) {
	        for( int i=0; i<arrFieldSort.length; i++ ) {
	        	String strTemp           = arrFieldSort[i];
	        	String strFuncDisplay    = getOriginalField( hOriginalField, arrFieldSort[i] );
	            String arrFuncDisplay [] = strFuncDisplay.split( "\\|" );
	            String strFuncCode       = arrFuncDisplay[0];
	            String strFuncLable      = arrFuncDisplay[1];
	            String strFuncType       = arrFuncDisplay[2];
	            String strFuncLength     = arrFuncDisplay[3];
	            
	            strConFieldSort += strTemp + ", ";
				strFieldCode    = fieldSort + intSeq;
	            
	            strScript = "FIELD_TYPE=\"" + strFuncType + "\" FIELD_LENGTH=\"" + strFuncLength + "\" FIELD_LABEL=\"" + strFuncLable + "\" ";
	            strScript += "FIELD_CODE=\"" + strFuncCode + "\" HIDDEN_CODE=\"" + strFieldCode + "\" INDEX_SEQN=\"" + intSeq + "\"";
	            
	            if( intSeq % 2 != 0 ) {
%>
												<tr class="table_data1" onclick="rowSelectedFunc('6',this.rowIndex,this)"<%=strScript%> >
							                        <td>&nbsp;</td>
							                        <td><div><%=strFuncLable %></div></td>
							                        <td colspan="2">
							                        	<div><%=strFuncType %>(<%=strFuncLength %>)</div>
							                        	<input type="hidden" id="<%=strFieldCode %>" name="<%=strFieldCode %>" value="<%=strTemp %>" >
							                        </td>
							                    </tr>
<%
            	}else{
%>
							                    <tr class="table_data2" onclick="rowSelectedFunc('6',this.rowIndex,this)"<%=strScript%> > 
							                        <td>&nbsp;</td>
							                        <td><div><%=strFuncLable %></div></td>
							                        <td colspan="2">
							                        	<div><%=strFuncType %>(<%=strFuncLength %>)</div>
							                        	<input type="hidden" id="<%=strFieldCode %>" name="<%=strFieldCode %>" value="<%=strTemp %>" >
							                        </td>
							                    </tr>
<%
	            }
	            intSeq++;
	        }
        }
     }
%>
						                	</table>
						                </td>
                                    </tr>
									<tr>
									  	<td align="right" colspan="4" class="label_bold2">
						                	<span id="lb_change_field"></span>&nbsp;&nbsp;
									  		<a href="#" onclick= "moveField('up','6')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('mv_up3','','images/btt_up_over.gif',1)">
									  			<img id="mv_up3" src="images/btt_up.gif" width="67" height="22" border="0" align="absmiddle"></a>
									  		<a href="#" onclick= "moveField('down','6')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('mv_down3','','images/btt_down_over.gif',1)">
									  			<img id="mv_down3" src="images/btt_down.gif" width="67" height="22" align="absmiddle" border="0"></a>
									  	</td>
									</tr>
                                </table>
                            </fieldset>
                        </td>
                    </tr>
                    <tr>
			            <td height="25">
			                <table width="100%" border="0">
			                    <tr>
			                        <td align="right">
			                            <div align="center"><br>
			                                <a href="#" onclick= "buttonClick('cancel')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('back','','images/btt_back_over.gif',1)">
           										<img src="images/btt_back.gif" name="back" width="67" height="22" border="0"></a>
			                            </div>
			                        </td>
			                    </tr>
			                    <tr>
			                    	<td>
			                    		<input type="hidden" name="screenname"   value="<%=screenname%>">
		    							<input type="hidden" name="PROJECT_CODE" value="<%=strProjectCode%>">
			                    		<input type="hidden" name="user_role"    value="<%=user_role %>">
										<input type="hidden" name="app_name"     value="<%=app_name %>">
										<input type="hidden" name="app_group"    value="<%=app_group %>">
										
										<input type="hidden" id="hidRowSelected1"    name="hidRowSelected1"    value="">
				              			<input type="hidden" id="hidFieldCode1"      name="hidFieldCode1"      value="">
				              			<input type="hidden" id="last_row_select1"   name="last_row_select1"   value="">
				              			<input type="hidden" id="last_table_select1" name="last_table_select1" value="">
				              			
				              			<input type="hidden" id="hidRowSelected2"  name="hidRowSelected2"  value="">
				              			<input type="hidden" id="hidFieldCode2"    name="hidFieldCode2"    value="">
				              			<input type="hidden" id="hidFieldOrder2"   name="hidFieldOrder2"   value="">
				              			<input type="hidden" id="last_row_select2" name="last_row_select2" value="">
				              			
		              					<input type="hidden" id="INDEX_SEQN"          name="INDEX_SEQN"          value="">
		              					<input type="hidden" id="FIELD_TYPE"          name="FIELD_TYPE"          value="">
		              					<input type="hidden" id="TABLE_ZOOM"          name="TABLE_ZOOM"          value="">
										<input type="hidden" id="FIELD_ORDER1_CHOOSE" name="FIELD_ORDER1_CHOOSE" value="">
										<input type="hidden" id="FIELD_ORDER2_CHOOSE" name="FIELD_ORDER2_CHOOSE" value="">
										<input type="hidden" id="FIELD_CODE1_CHOOSE"  name="FIELD_CODE1_CHOOSE"  value="">
										<input type="hidden" id="FIELD_CODE2_CHOOSE"  name="FIELD_CODE2_CHOOSE"  value="">
										
										<input type="hidden" id="MODE"                name="MODE"                value="<%=strMode%>">
                        				<input type="hidden" id="txtGsearchGroup"     name="txtGsearchGroup"     value="<%=strGroupDescData %>">
										<input type="hidden" id="template_header"     name="template_header"     value="<%=strFieldTemplateHeader%>">
										<input type="hidden" id="template"            name="template"            value="<%=strFieldTemplate%>">
										<input type="hidden" id="field_sort"          name="field_sort"          value="<%=strFieldSort%>">
										<input type="hidden" id="field_display"       name="field_display"       value="<%=strConFieldDisplay%>">
										<input type="hidden" id="template_header_ori" name="template_header_ori" value="<%=strFieldTemplateHeaderOri%>">
										<input type="hidden" id="template_ori"        name="template_ori"        value="<%=strFieldTemplateOri%>">
										<input type="hidden" id="field_sort_ori"      name="field_sort_ori"      value="<%=strFieldSortOri%>">
			                    	</td>
			                    </tr>
			                </table>
			            </td>
			        </tr>
                </table>
                
            </td>
        </tr>
    </table>
    </div>
</form>
<form name="formback">
<input type="hidden" name="MODE">
<input type="hidden" name="screenname"   value="<%=screenname%>">
<input type="hidden" name="PROJECT_CODE" value="<%=strProjectCode%>">
<input type="hidden" name="user_role"    value="<%=user_role %>">
<input type="hidden" name="app_name"     value="<%=app_name %>">
<input type="hidden" name="app_group"    value="<%=app_group %>">
</form>    
</body>
</html>
<script type="text/javascript" language="JavaScript">
<!--
var obj_mode            = document.getElementById("MODE");
var obj_txtGsearchGroup = document.getElementById("txtGsearchGroup");
var obj_hidSortMethod   = document.getElementById("hidSortMethod");
var obj_rdoSortMethod   = document.getElementsByName("rdoSortMethod");

var obj_hidTemplateHeader    = document.getElementById("template_header");
var obj_hidTemplate          = document.getElementById("template");
var obj_hidFieldDisplay      = document.getElementById("field_display");
var obj_hidFieldSort         = document.getElementById("field_sort");
var obj_hidTemplateHeaderOri = document.getElementById("template_header_ori");
var obj_hidTemplateOri       = document.getElementById("template_ori");
var obj_hidFieldSortOri      = document.getElementById("field_sort_ori");

var obj_hidRowSelected1    = document.getElementById("hidRowSelected1");
var obj_hidFieldCode1      = document.getElementById("hidFieldCode1");
var obj_last_row_select1   = document.getElementById("last_row_select1");
var obj_last_table_select1 = document.getElementById("last_table_select1");

var obj_hidRowSelected2  = document.getElementById("hidRowSelected2");
var obj_hidFieldCode2    = document.getElementById("hidFieldCode2");
var obj_last_row_select2 = document.getElementById("last_row_select2");
var obj_hidFieldOrder2   = document.getElementById("hidFieldOrder2");

var obj_indexSeqn         = document.getElementById("INDEX_SEQN");
var obj_fieldType         = document.getElementById("FIELD_TYPE");
var obj_tableZoom         = document.getElementById("TABLE_ZOOM");
var obj_fieldOrder1Choose = document.getElementById("FIELD_ORDER1_CHOOSE");
var obj_fieldOrder2Choose = document.getElementById("FIELD_ORDER2_CHOOSE");
var obj_fieldCode1Choose  = document.getElementById("FIELD_CODE1_CHOOSE");
var obj_fieldCode2Choose  = document.getElementById("FIELD_CODE2_CHOOSE");
//-->
</script>