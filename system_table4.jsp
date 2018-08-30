<%@ page contentType="text/html; charset=tis-620"%>
<%@ include file="inc/checkUser.jsp" %>
<%@ include file="inc/constant.jsp" %>
<%@ include file="inc/label.jsp" %>
<%@ include file="inc/utils.jsp" %>
<jsp:useBean id="con" scope="session" class="edms.cllib.EABConnector"/>
<%
    con.setRemoteServer("EAS_SERVER");

    String strClassName = "ZOOM_TABLE_MANAGER";
    String strMode      = checkNull(request.getParameter("MODE"));
    String strOldMode   = checkNull(request.getParameter("OLD_MODE"));
    String screenname   = getField(request.getParameter("screenname"));

    String strCurrentPage = request.getParameter( "CURRENT_PAGE" );
    String strPageSize    = request.getParameter( "PAGE_SIZE" );
    
    if( strCurrentPage == null || Integer.parseInt( strCurrentPage ) == 0 ) {
        strCurrentPage = "1";
    }
    if( strPageSize == null || Integer.parseInt( strPageSize ) == 0 ) {
            strPageSize = "10";
    }
    
    String  strmsg          = "";
    boolean bolnSuccess     = true;
    boolean searchmod       = false;
    String  strErrorCode    = null;
    String  strErrorMessage = null;

    String mode_parent         = checkNull(request.getParameter( "mode_parent" ));
    String current_page_parent = checkNull(request.getParameter( "current_page_parent" ));
    String page_size_parent    = checkNull(request.getParameter( "page_size_parent" ));
    String sortby_parent       = checkNull(request.getParameter( "sortby_parent" ));
    String sortfield_parent    = checkNull(request.getParameter( "sortfield_parent" ));

    String strTableCodeKey       = checkNull(request.getParameter( "TABLE_CODE_KEY" ));
    String strTableNameKey       = getField(request.getParameter( "TABLE_NAME_KEY" ));
    String strTableLevelKey      = checkNull(request.getParameter( "TABLE_LEVEL_KEY" ));
    String strTableLevel1Key     = checkNull(request.getParameter( "TABLE_LEVEL1_KEY" ));
    String strTableLevel2Key     = checkNull(request.getParameter( "TABLE_LEVEL2_KEY" ));
    String strTableLevel1NameKey = getField(request.getParameter( "TABLE_LEVEL1_NAME_KEY" ));
    String strTableLevel2NameKey = getField(request.getParameter( "TABLE_LEVEL2_NAME_KEY" ));
    
    String strFieldLevel1Code = checkNull(request.getParameter( "FIELD_LEVEL1_CODE" ));
    String strFieldLevel1Name = getField(request.getParameter( "FIELD_LEVEL1_NAME" ));
    String strFieldLevel2Code = checkNull(request.getParameter( "FIELD_LEVEL2_CODE" ));
    String strFieldLevel2Name = getField(request.getParameter( "FIELD_LEVEL2_NAME" ));
    
    String strTableLevelCodeSearch = checkNull(request.getParameter( "TABLE_LEVEL_CODE_SEARCH" ));
    String strTableLevelNameSearch = getField(request.getParameter( "TABLE_LEVEL_NAME_SEARCH" ));

    String strTableLevelSearch = checkNull(request.getParameter("TABLE_LEVEL_SEARCH"));
    String strTableCodeSearch  = checkNull(request.getParameter("TABLE_CODE_SEARCH"));
    String strTableNameSearch  = getField(request.getParameter("TABLE_NAME_SEARCH"));

    String  strTableCodeData   = checkNull(request.getParameter( "TABLE_CODE_DEL" ));
    String  strNotDropFlagData = checkNull(request.getParameter( "NOT_DROP_FLAG_TEMP" ));
    String  strTableLevelData  = "";
    String  strTableNameData   = "";
    String  strTableLevel1Data = "";
    String  strTableLevel2Data = "";
    
    String  strScript    = "";
    String  strbttEdit   = "";
    String  strbttDelete = "";
    String  strTotalPage = "1";
    String  strTotalSize = "0";
    String  sortby       = "";
    String  sortbyd      = "";
    String  sortfield    = "";
    
    sortby    = checkNull( request.getParameter("sortby") );                          
    sortfield = checkNull( request.getParameter("sortfield") );
    
    int i         = 0;
    int intfield  = 0;
    int intclm    = 0;

    if( strMode == null || strMode.equals("")){
        strMode = "SEARCH";
    }
    
    if( strMode.equals("DELETE") ) {
    	con.addData( "TABLE_CODE",       "String", strTableCodeKey );
    	con.addData( "TABLE_CODE_VALUE", "String", strTableCodeData );
		
        bolnSuccess = con.executeService( strContainerName, strClassName, "deleteTableCodeDetail" );
        if( !bolnSuccess ){
            strErrorCode    = con.getRemoteErrorCode();
            strErrorMessage = con.getRemoteErrorMesage();
            if( strErrorCode.equals("ERR00006") ) {
                strmsg = "showMsg(0,0,\" " + lc_can_not_delete_detail + "\")";
            }else {
                strmsg = "showMsg(0,0,\" " + lc_can_not_delete_data + "\")";
            }
            strMode = "SEARCH";
        }else{
            strmsg  = "showMsg(0,0,\" " + lc_delete_data_successfull + "\")";
            strMode = "SEARCH";
        }
    }
    
    if( strMode.equals("SEARCH") ) {
    	if( sortfield.equals("") ) {
            sortfield="0";
        }
        if( sortby.equals("") ) {
            sortby="ASC";
        }
        if( sortby.equals("ASC") ) {
            sortbyd="ASC";
        }else {
            sortbyd="DESC";
        }

        if( strTableLevelKey.equals("1") ) {
            con.addData( "TABLE_CODE",   "String", strTableCodeKey );
            con.addData( "TABLE_NAME",   "String", strTableNameKey );
            con.addData( "TABLE_LEVEL",  "String", strTableLevelKey );
            con.addData( "SORTFIELD",    "String", sortfield );
            con.addData( "SORTBY",       "String", sortbyd );
            con.addData( "PAGENUMBER",   "String", strCurrentPage );
            con.addData( "PAGESIZE",     "String", strPageSize );
            bolnSuccess = con.executeService( strContainerName, strClassName, "findTableCodeLevel1Sort" );
        }else if( strTableLevelKey.equals("2") ) {
            if( !strTableLevel1Key.equals("") ) {
                con.addData( "TABLE_CODE",   "String", strTableCodeKey );
            	con.addData( "TABLE_NAME",   "String", strTableNameKey );
            	con.addData( "TABLE_LEVEL1",  "String", strTableLevel1Key );
            	con.addData( "FIELD_LEVEL1", "String", strFieldLevel1Code );
            	con.addData( "SORTFIELD",    "String", sortfield );
                con.addData( "SORTBY",       "String", sortbyd );
                con.addData( "PAGENUMBER",   "String", strCurrentPage );
                con.addData( "PAGESIZE",     "String", strPageSize );
                bolnSuccess = con.executeService( strContainerName, strClassName, "findTableCodeLevel2Sort" );
            }
        }else if( strTableLevelKey.equals("3") ) {
            if( !strTableLevel2Key.equals("") && !strTableLevel1Key.equals("") ) {
            	con.addData( "TABLE_CODE",   "String", strTableCodeKey );
            	con.addData( "TABLE_NAME",   "String", strTableNameKey );
            	con.addData( "TABLE_LEVEL1", "String", strTableLevel1Key );
            	con.addData( "TABLE_LEVEL2", "String", strTableLevel2Key );
            	con.addData( "FIELD_LEVEL1", "String", strFieldLevel1Code );
            	con.addData( "FIELD_LEVEL2", "String", strFieldLevel2Code );
            	con.addData( "SORTFIELD",    "String", sortfield );
                con.addData( "SORTBY",       "String", sortbyd );
                con.addData( "PAGENUMBER",   "String", strCurrentPage );
                con.addData( "PAGESIZE",     "String", strPageSize );
                bolnSuccess = con.executeService( strContainerName, strClassName, "findTableCodeLevel3Sort" );
            }
        }
        
        if( !bolnSuccess ) {
            strErrorCode    = con.getRemoteErrorCode();
            strErrorMessage = con.getRemoteErrorMesage();
        }else {
            searchmod    = bolnSuccess;
            strTotalPage = con.getHeader( "PAGE_COUNT" );
            strTotalSize = con.getHeader( "TOTAL_RECORD" );
            if( !strTotalSize.equals("0") ) {
                strCurrentPage = con.getHeader( "CURRENT_PAGE" );
            }else {
                strCurrentPage = "0";
            }
        }
    }
    
    if( strMode.equals("FIND") ) {
    	if( !strTableCodeKey.equals("") ) {
    		con.addData( "TABLE_CODE",  "String", strTableCodeKey);
    	}
    	if( !strTableLevelCodeSearch.equals("") ) {
    		con.addData( "TABLE_CODE_VALUE",  "String", strTableLevelCodeSearch);
    	}
    	if( !strTableLevelNameSearch.equals("") ) {
        	con.addData( "TABLE_NAME",  "String", strTableLevelNameSearch);
    	}
    	if( sortfield.equals("") ) {
            sortfield="0";
        }
        if( sortby.equals("") ) {
            sortby="ASC";
        }
        if( sortby.equals("ASC") ) {
            sortbyd="ASC";
        }else {
            sortbyd="DESC";
        }
        
    	con.addData( "SORTFIELD",  "String", sortfield );
        con.addData( "SORTBY",     "String", sortbyd );
        con.addData( "PAGENUMBER", "String", strCurrentPage );
        con.addData( "PAGESIZE",   "String", strPageSize );
        bolnSuccess = con.executeService( strContainerName, strClassName, "findTableCodeDetailSort" );
        if( !bolnSuccess ) {
            strErrorCode    = con.getRemoteErrorCode();
            strErrorMessage = con.getRemoteErrorMesage();
        }else {
        	strTotalPage = con.getHeader( "PAGE_COUNT" );
            strTotalSize = con.getHeader( "TOTAL_RECORD" );
            if( !strTotalSize.equals("0") ) {
                strCurrentPage = con.getHeader( "CURRENT_PAGE" );
            }else {
                strCurrentPage = "0";
            }
        }
    }
    
%>

<!DOCTYPE HTML>
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
<script language="JavaScript" src="js/label/lb_system_table.js"></script>
<script language="JavaScript" src="js/function/page-utils.js"></script>
<script language="JavaScript" src="js/function/table-utils.js"></script>
<script language="JavaScript" src="js/util.js"></script>
<script language="JavaScript" src="js/constant.js"></script>
<script language="JavaScript" type="text/javascript">
<!--
var tableLevel         = '<%=strTableLevelKey%>';
var tableLevel1Key     = '<%=strTableLevel1Key%>';
var tableLevel1NameKey = '<%=strTableLevel1NameKey%>';
var tableLevel2Key     = '<%=strTableLevel2Key%>';
var tableLevel2NameKey = '<%=strTableLevel2NameKey%>';
var objZoomWindow;

$(document).ready(window_onload);

function window_onload() {
    set_label();
    set_background("screen_div");
    set_message();
    set_field_table();
    set_init();
    display_HTML( tableLevel );
    
    totalPage = '<%=strTotalPage%>';
    mode      = '<%=strMode%>';
}

function set_init(){        
    var per_page = '<%=strPageSize%>';

    form1.PAGE_SIZE.value = per_page;
	
    if( mode == "SEARCH" ) {
    	var obj_imgAdd = document.getElementById("add");
    	if( tableLevel == "2" ) {
            if( form1.txtTableLevel1.value.length == 0 ) {
                obj_imgAdd.style.display = "none";
            }
    	}
    	if( tableLevel == "3" ) {
            if( form1.txtTableLevel2.value.length == 0 ) {
                obj_imgAdd.style.display = "none";
            }
    	}
    }
}

function set_label(){
    lb_code.innerHTML         = lbl_code;
    lb_detail.innerHTML       = lbl_detail;
    lb_total_record.innerHTML = lbl_total_record;
    lb_record.innerHTML       = lbl_record;
    lb_page_per_size.innerHTML = lbl_page_per_size;
}

function set_message(){
    
<%  if (!strmsg.equals("")) {  %>
    <%=strmsg%>
<%  }   %>
}

function display_HTML( lv_selectedValue ) {
	var obj_trLevel1           = document.getElementById("trLevel1");
	var obj_trLevel2           = document.getElementById("trLevel2");
	var obj_txtTableLevel1     = document.getElementById("txtTableLevel1");
	var obj_txtTableLevel1Name = document.getElementById("txtTableLevel1Name");
	var obj_searchLV1          = document.getElementById("searchLV1");
	var obj_txtTableLevel2     = document.getElementById("txtTableLevel2");
	var obj_txtTableLevel2Name = document.getElementById("txtTableLevel2Name");
	var obj_searchLV2          = document.getElementById("searchLV2");
	var obj_bttSearch          = document.getElementById("search");
	
	if( lv_selectedValue == 1 ) {
            obj_trLevel1.style.display   = "none";
            obj_trLevel2.style.display   = "none";
            obj_bttSearch.style.display  = "inline";
	}
	
	if( lv_selectedValue == 2 ) {
            obj_trLevel1.style.display   = "inline";
            obj_trLevel2.style.display   = "none";
            obj_searchLV1.style.display  = "inline";
		//obj_bttSearch.display        = "none";
	}
	
	if( lv_selectedValue == 3 ) {
            obj_trLevel1.style.display   = "inline";
            obj_trLevel2.style.display   = "inline";
		//obj_bttSearch.display        = "none";
	}
}

function buttonClick( lv_strMethod, lv_strValue ){
    switch( lv_strMethod ){
		case "pInsert" :
			formadd.MODE.value                  = lv_strMethod;
			formadd.TABLE_LEVEL1_CODE_KEY.value = form1.txtTableLevel1.value;
			formadd.TABLE_LEVEL2_CODE_KEY.value = form1.txtTableLevel2.value;
			formadd.submit();
			break;
		case "pSearch" :
			formsearch.method = "post";
			formsearch.target = "_self"
			formsearch.action = "system_table6.jsp";
			formsearch.submit();
			break;
        case "pEdit" :
			formadd.TABLE_CODE_EDIT_KEY.value = lv_strValue.getAttribute("TABLE_CODE");
			formadd.TABLE_NAME_EDIT_KEY.value = lv_strValue.getAttribute("TABLE_NAME");
			formadd.MODE.value = lv_strMethod;
			formadd.submit();
			break;
		case "DELETE" :
			if( !confirm(lc_confirm_delete) ) {
				return;
			}
			form1.MODE.value = lv_strMethod;
			form1.method = "post";
			form1.action = "system_table4.jsp";
			form1.TABLE_CODE_DEL.value = lv_strValue.getAttribute("TABLE_CODE");
			form1.submit();
			break;
		case "cancel" :
		    form1.CURRENT_PAGE.value = form1.current_page_parent.value;
                    form1.PAGE_SIZE.value = form1.page_size_parent.value;
			form1.sortfield.value    = form1.sortfield_parent.value;
			form1.sortby.value       = form1.sortby_parent.value;
		    form1.MODE.value         = form1.mode_parent.value;
			form1.action             = "system_table1.jsp";
			form1.target 	         = "_self";
		    form1.submit();
			break;
	}
}

function openZoom( strZoomType ) {
	var strPopArgument      = "scrollbars=yes,status=no";
	var strWidth            = ",width=370px";
	var strHeight           = ",height=420px";
	var strUrl              = "";
	var strConcatField      = "";

	if( mode == "pEdit" ) {
		return;
	}

	strPopArgument += strWidth + strHeight;

	switch( strZoomType ){
		case "level1" :
				strUrl = "inc/zoom_data_table_level1.jsp";
				strConcatField = "TABLE="+ tableLevel1Key + "&TABLE_LABEL=" + tableLevel1NameKey;
				strConcatField += "&RESULT_FIELD=txtTableLevel1,txtTableLevel1Name";
				if( tableLevel == "2" ) {
                                    strConcatField += "&CALL_FUNC=refreshData";
				}else if(tableLevel == "3"){
                                    strConcatField += "&CALL_FUNC=clearData";
                                }
				break;
		case "level2" :
				if( form1.txtTableLevel1.value.length == 0 ) {
					alert( lc_can_not_choose_data );
					return;
				}
				strUrl = "inc/zoom_data_table_level2.jsp";
				strConcatField = "TABLE=" + tableLevel2Key + "&TABLE_LABEL=" + tableLevel2NameKey;
				strConcatField += "&TABLE_LV1=" + tableLevel1Key + "&TABLE_LV1_CODE=" + form1.txtTableLevel1.value;
				strConcatField += "&TABLE_LV1_LABEL=" + tableLevel1NameKey + "&TABLE_LV1_NAME=" + form1.txtTableLevel1Name.value;
				strConcatField += "&RESULT_FIELD=txtTableLevel2,txtTableLevel2Name";
				strConcatField += "&CALL_FUNC=refreshData";
				break;
	}

	objZoomWindow = window.open( strUrl + "?" + strConcatField, strZoomType, strPopArgument );
	objZoomWindow.focus();
}

function refreshData() {
	form1.FIELD_LEVEL1_CODE.value = form1.txtTableLevel1.value;
	form1.FIELD_LEVEL1_NAME.value = form1.txtTableLevel1Name.value;
	form1.FIELD_LEVEL2_CODE.value = form1.txtTableLevel2.value;
	form1.FIELD_LEVEL2_NAME.value = form1.txtTableLevel2Name.value;
	form1.MODE.value             = "SEARCH";
	form1.submit();
}

function clearData() {
	form1.FIELD_LEVEL1_CODE.value = form1.txtTableLevel1.value;
	form1.FIELD_LEVEL1_NAME.value = form1.txtTableLevel1Name.value;
	form1.FIELD_LEVEL2_CODE.value = "";
	form1.FIELD_LEVEL2_NAME.value = "";
	form1.MODE.value             = "SEARCH";
	form1.submit();
}

function window_onunload(){
    if( objZoomWindow != null && !objZoomWindow.closed ){
        objZoomWindow.close();
    }
}

//-->
</script>
<link href="css/edas.css" type="text/css" rel="stylesheet">
</head>
<body onLoad="MM_preloadImages('images/btt_add_over.gif','images/btt_search_over.gif','images/btt_back_over.gif','images/btt_edit2_over.gif','images/btt_delete_over.gif','images/btt_inputs_over.gif');" onunload="window_onunload()" onresize="set_background('screen_div')">
<form id="form1" name="form1" method="post" action="" >
<table width="100%" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
    <tr><td valign="top">
        <div id="screen_div">
            <table width="800" height="100%" border="0" cellpadding="0" cellspacing="0">
                <tr>
                    <td valign="top">
                        <table width="800" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td height="25" class="label_header01" >&nbsp;&nbsp;<%=strTableCodeKey%>&nbsp;<%=strTableNameKey %></td>
                            </tr>
                            <tr> 
                                <td><div align="center"> 
                                    <table width="696" border="0" cellpadding="0" cellspacing="0">
                                        <tr id="trLevel1" style="display: none">
                                            <td width="130" height="25" class="label_bold2" align="right"><span><%=strTableLevel1NameKey %>&nbsp;&nbsp;</span></td>
                                            <td width="107" height="25">
                                                <input id="txtTableLevel1" name="txtTableLevel1" type="text" value="<%=strFieldLevel1Code %>" class="input_box_disable" size="20" maxlength="30" readonly>
                                            </td>
                                            <td width="25" height="25" align="center">
                                                <a href="javascript:openZoom('level1');"><img src="images/search.gif" id="searchLV1" name="searchLV1" width="16" height="16" border="0"></a>
                                            </td>
                                            <td align="left">
                                                <input id="txtTableLevel1Name" name="txtTableLevel1Name" type="text" value="<%=strFieldLevel1Name %>" class="input_box_disable" size="40" maxlength="50" readonly>
                                            </td>
                                        </tr>
                                        <tr id="trLevel2" style="display: none">
                                            <td width="130" height="25" class="label_bold2" align="right"><span><%=strTableLevel2NameKey %>&nbsp;&nbsp;</span></td>
                                            <td width="107" height="25">
                                                <input id="txtTableLevel2" name="txtTableLevel2" type="text" value="<%=strFieldLevel2Code %>" class="input_box_disable" size="20" maxlength="30" readonly>
                                            </td>
                                            <td width="25" height="25" align="center">
                                                <a href="javascript:openZoom('level2');"><img src="images/search.gif" id="searchLV2" name="searchLV2" width="16" height="16" border="0"></a>
                                            </td>
                                            <td align="left">
                                                <input id="txtTableLevel2Name" name="txtTableLevel2Name" type="text" value="<%=strFieldLevel2Name %>" class="input_box_disable" size="40" maxlength="50" readonly>
                                            </td>
                                        </tr>
                                    </table>
                                    <br>
                                    <table width="636" border="0" cellpadding="0" cellspacing="0">
<%
    intclm = 2;

    String[] sortimg = new String[intclm+1];

    for( i=1; i<=intclm; i++ ) {
        sortimg[i] = "";
    }

    if( searchmod ) {
        if ( sortfield.equals("0") ) {
            for( i=1; i<=intclm; i++ ) {
                sortimg[i]="<img src=\"images/updown.gif\" onclick=\"sort_search('ASC',"+i+")\" name=\"img1\" style=\"cursor:pointer\">";
            }
        }else {
            intfield=Integer.parseInt( sortfield );
            for( i=1; i<=intclm; i++ ) {
                if ( i==intfield ) {
                    if ( sortby.equals("ASC") ) {
                        sortimg[i]="<img src=\"images/sort_down.gif\" onclick=\"sort_search('DESC',"+i+")\" name=\"img1\" style=\"cursor:pointer\">";
                    }else {
                        sortimg[i]="<img src=\"images/sort_up.gif\" onclick=\"sort_search('ASC',"+i+")\" name=\"img1\" style=\"cursor:pointer\">";
                    }
                }else {
                    sortimg[i]="<img src=\"images/updown.gif\" onclick=\"sort_search('ASC',"+i+")\" name=\"img1\" style=\"cursor:pointer\">";
                }
            }
        }
    }
%>                                 
                                        <tr class="hd_table"> 
                                            <td width="10"><img src="images/hd_tb_01.gif" width="10" height="28"></td>
                                            <td width="170" align="center">
                                                <div align="left"><span id="lb_code"></span><%=sortimg[1]%></div>
                                            </td>
                                            <td align="center">
                                                <div align="left"><span id="lb_detail"></span><%=sortimg[2]%></div>
                                            </td>
                                            <td width="55">&nbsp;</td>
                                            <td width="55">&nbsp;</td>
                                            <td width="10" align="right"><img src="images/hd_tb_04.gif" width="10" height="28"></td>
                                        </tr>
<%
    if( (bolnSuccess) ) {
        int intSeq = 1;
        int idx    = 0;
        while( con.nextRecordElement() ){
            strTableCodeData   = con.getColumn( strTableCodeKey );
            strTableNameData   = con.getColumn( strTableCodeKey + "_NAME" );
            strTableLevelData  = con.getColumn( "TABLE_LEVEL" );
            strNotDropFlagData = con.getColumn( "NOT_DROP_FLAG" );
            strTableLevel1Data = con.getColumn( "TABLE_LEVEL1" );
            strTableLevel2Data = con.getColumn( "TABLE_LEVEL2" );
            
            strbttEdit         = "<img src=\"images/btt_edit2.gif\" name=\"EDIT" + intSeq + "\"  width=\"52\" height=\"18\" border=\"0\">";
            strbttDelete       = "<img src=\"images/btt_delete.gif\" name=\"Delete" + intSeq + "\"  width=\"52\" height=\"18\" border=\"0\">";
            strScript          = "TABLE_CODE=\"" + strTableCodeData + "\" TABLE_NAME=\"" + strTableNameData + "\" TABLE_LEVEL=\"" + strTableLevelData + "\" ";
            strScript          += "NOT_DROP_FLAG=\"" + strNotDropFlagData + "\" TABLE_LEVEL1=\"" + strTableLevel1Data + "\" TABLE_LEVEL2=\"" + strTableLevel2Data + "\"";

            idx = 2 - (intSeq % 2);
%>
                                        <tr class="table_data<%=idx%>"> 
                                            <td>&nbsp;</td>
                                            <td><div align="left"><%=strTableCodeData %></div></td>
                                            <td><div align="left"><%=strTableNameData %></div>
                                            </td>
                                            <td width="57">
                                                <a href="#" onclick= "buttonClick('pEdit',this)"<%=strScript%> onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('EDIT<%=intSeq %>','','images/btt_edit2_over.gif',1)"><%=strbttEdit%></a>
                                            </td>
                                            <td width="57">
                                                <a href="#" onclick= "buttonClick('DELETE',this)"<%=strScript%> onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Delete<%=intSeq %>','','images/btt_delete_over.gif',1)"><%=strbttDelete%></a>
                                            </td>
                                            <td>&nbsp;</td>
                                        </tr>
<%
            intSeq++;
        }
    }else{
%>        
                                        <tr class="table_data1">
                                            <td colspan="6" align="center"><%=con.getRemoteErrorMesage() %></td>
                                        </tr>
<%
    }
 %>                      
                                    </table>
                                    <table width="636" height="28" border="0" align="center" cellpadding="0" cellspacing="0">
                                        <tr class="footer_table">
                                            <td width="68%" align="left" >&nbsp;&nbsp;<span id="lb_total_record"></span>&nbsp;&nbsp;<%=strTotalSize%>&nbsp;&nbsp;<span id="lb_record"></span></td>
                                            <td width="4%" height="28" align="right">
                                                <a href="#" name="firstP" onClick="navigator_click('first');"><img src="images/first.gif" width="22" height="22" border="0"></a>
                                            </td>
                                            <td width="4%" height="28" align="right">
                                                <a href="#" name="previousP" onClick="navigator_click('previous');"><img src="images/prv.gif" width="22" height="22" border="0"></a>
                                            </td>
                                            <td width="16%" height="28" align="center">
                                                <input id="CURRENT_PAGE" name="CURRENT_PAGE" type="text" class="input_box_disable" style="text-align:center" size="3" value="<%=strCurrentPage%>" readonly>/
                                                <input id="TOTAL_PAGE" name="TOTAL_PAGE" type="text" class="input_box_disable" style="text-align:center" size="3" value="<%=strTotalPage%>" readonly>
                                            </td>
                                            <td width="4%" height="28">
                                                <a href="#" name="nextP" onClick="navigator_click('next');"><img src="images/next.gif" width="22" height="22" border="0"></a>
                                            </td>
                                            <td width="4%" height="28">
                                                <a href="#" name="lastP" onClick="navigator_click('last');"><img src="images/last.gif" width="22" height="22" border="0"></a>
                                            </td>
                                        </tr>
                                    </table>
                                    <table width="636" border="0" cellpadding="0" cellspacing="0" class="label_bold2">
		              		<tr>
                                            <td height="10"></td>
                                            <td colspan="3" align="right">
                                                <span id="lb_page_per_size"></span> : 
                                                <select id="PAGE_SIZE" name="PAGE_SIZE"  class="combobox" onchange="change_result_per_page();">
                                                    <option value="10">10</option>
                                                    <option value="20">20</option>
                                                    <option value="30">30</option>
                                                    <option value="40">40</option>
                                                    <option value="50">50</option>
                                                    <option value="100">100</option>
                                                </select>
                                            </td>
		              		</tr>
                                    </table>                
                                    <p>
                                        <a href="#" onclick="showImportExcelWindow('<%=strTableLevelKey%>')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('import','','images/btt_import_table_over.gif',1)">
                                            <img src="images/btt_import_table.gif" id="import" name="import" width="67" height="22" border="0"></a>
                                        <a href="#" onclick="buttonClick('pInsert')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('add','','images/btt_add_over.gif',1)">
                                            <img src="images/btt_add.gif" id="add" name="add" width="67" height="22" border="0"></a>
                                        <a href="#" onclick= "buttonClick('pSearch')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('search','','images/btt_search_over.gif',1)">
                                            <img src="images/btt_search.gif" id="search" name="search" width="67" height="22" border="0" style="display: none"></a>
                                        <a href="#" onclick= "buttonClick('cancel')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('back','','images/btt_back_over.gif',1)">
                                            <img src="images/btt_back.gif" name="back" width="67" height="22" border="0"></a>
                                    </p>                    
                                </div></td>
                            </tr>
                            <tr>
                                <td>
                                    <%@ include file="inc/table_excel_div.jsp" %>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </div>
    </td></tr>
</table>
<input type="hidden" id="MODE"           name="MODE"                  value="<%=strMode%>">
<input type="hidden" id="TABLE_CODE_DEL" name="TABLE_CODE_DEL"        value="<%=strTableCodeData%>">
<input type="hidden" id="screenname"     name="screenname"            value="<%=screenname%>">
<input type="hidden" id="sortby"         name="sortby"                value="<%=sortby%>">
<input type="hidden" id="sortfield"      name="sortfield"             value="<%=sortfield%>">

<input type="hidden" id="TABLE_CODE_KEY"   name="TABLE_CODE_KEY"        value="<%=strTableCodeKey %>">
<input type="hidden" id="TABLE_NAME_KEY"   name="TABLE_NAME_KEY"        value="<%=strTableNameKey %>">
<input type="hidden" id="TABLE_LEVEL_KEY"  name="TABLE_LEVEL_KEY"       value="<%=strTableLevelKey %>">			
<input type="hidden" id="TABLE_LEVEL1_KEY" name="TABLE_LEVEL1_KEY"      value="<%=strTableLevel1Key %>">
<input type="hidden" id="TABLE_LEVEL2_KEY" name="TABLE_LEVEL2_KEY"      value="<%=strTableLevel2Key %>">

<input type="hidden" id="FIELD_LEVEL1_CODE" name="FIELD_LEVEL1_CODE"     value="<%=strFieldLevel1Code %>">
<input type="hidden" id="FIELD_LEVEL1_NAME" name="FIELD_LEVEL1_NAME"     value="<%=strFieldLevel1Name %>">
<input type="hidden" id="FIELD_LEVEL2_CODE" name="FIELD_LEVEL2_CODE"     value="<%=strFieldLevel2Code %>">
<input type="hidden" id="FIELD_LEVEL2_NAME" name="FIELD_LEVEL2_NAME"     value="<%=strFieldLevel2Name %>">

<input type="hidden" id="TABLE_LEVEL1_NAME_KEY" name="TABLE_LEVEL1_NAME_KEY" value="<%=strTableLevel1NameKey %>">
<input type="hidden" id="TABLE_LEVEL2_NAME_KEY" name="TABLE_LEVEL2_NAME_KEY" value="<%=strTableLevel2NameKey %>">

<input type="hidden" id="TABLE_LEVEL_CODE_SEARCH" name="TABLE_LEVEL_CODE_SEARCH"     value="<%=strTableLevelCodeSearch %>">
<input type="hidden" id="TABLE_LEVEL_NAME_SEARCH" name="TABLE_LEVEL_NAME_SEARCH"     value="<%=strTableLevelNameSearch %>">

<input type="hidden" id="OLD_MODE"           name="OLD_MODE"           value="<%=strOldMode%>">
<input type="hidden" id="TABLE_LEVEL_SEARCH" name="TABLE_LEVEL_SEARCH" value="<%=strTableLevelSearch%>">
<input type="hidden" id="TABLE_CODE_SEARCH"  name="TABLE_CODE_SEARCH"  value="<%=strTableCodeSearch%>">
<input type="hidden" id="TABLE_NAME_SEARCH"  name="TABLE_NAME_SEARCH"  value="<%=strTableNameSearch%>">

<input type="hidden" id="mode_parent"         name="mode_parent"         value="<%=mode_parent%>">
<input type="hidden" id="current_page_parent" name="current_page_parent" value="<%=current_page_parent%>">
<input type="hidden" id="page_size_parent" name="page_size_parent" value="<%=page_size_parent%>">
<input type="hidden" id="sortby_parent"       name="sortby_parent"       value="<%=sortby_parent%>">
<input type="hidden" id="sortfield_parent"    name="sortfield_parent"    value="<%=sortfield_parent%>">
</form>
<form name="formadd" method="post" action="system_table5.jsp" target = "_self">
<input type="hidden" id="MODE"             name="MODE"             value="">
<input type="hidden" id="TABLE_CODE_KEY"   name="TABLE_CODE_KEY"   value="<%=strTableCodeKey%>">
<input type="hidden" id="TABLE_NAME_KEY"   name="TABLE_NAME_KEY"   value="<%=strTableNameKey%>">
<input type="hidden" id="TABLE_LEVEL_KEY"  name="TABLE_LEVEL_KEY"  value="<%=strTableLevelKey %>">
<input type="hidden" id="TABLE_LEVEL1_KEY" name="TABLE_LEVEL1_KEY" value="<%=strTableLevel1Key %>">
<input type="hidden" id="TABLE_LEVEL2_KEY" name="TABLE_LEVEL2_KEY" value="<%=strTableLevel2Key %>">
<input type="hidden" id="TABLE_LEVEL1_CODE_KEY" name="TABLE_LEVEL1_CODE_KEY" value="">
<input type="hidden" id="TABLE_LEVEL2_CODE_KEY" name="TABLE_LEVEL2_CODE_KEY" value="">

<input type="hidden" id="FIELD_LEVEL1_CODE" name="FIELD_LEVEL1_CODE" value="<%=strFieldLevel1Code %>">
<input type="hidden" id="FIELD_LEVEL1_NAME" name="FIELD_LEVEL1_NAME" value="<%=strFieldLevel1Name %>">
<input type="hidden" id="FIELD_LEVEL2_CODE" name="FIELD_LEVEL2_CODE" value="<%=strFieldLevel2Code %>">
<input type="hidden" id="FIELD_LEVEL2_NAME" name="FIELD_LEVEL2_NAME" value="<%=strFieldLevel2Name %>">

<input type="hidden" id="TABLE_LEVEL1_NAME_KEY" name="TABLE_LEVEL1_NAME_KEY" value="<%=strTableLevel1NameKey %>">
<input type="hidden" id="TABLE_LEVEL2_NAME_KEY" name="TABLE_LEVEL2_NAME_KEY" value="<%=strTableLevel2NameKey %>">
<input type="hidden" id="screenname"            name="screenname"            value="<%=screenname%>">

<input type="hidden" id="TABLE_CODE_EDIT_KEY" name="TABLE_CODE_EDIT_KEY"   value="">
<input type="hidden" id="TABLE_NAME_EDIT_KEY" name="TABLE_NAME_EDIT_KEY"   value="">

<input type="hidden" id="OLD_MODE"           name="OLD_MODE"           value="<%=strOldMode%>">
<input type="hidden" id="TABLE_LEVEL_SEARCH" name="TABLE_LEVEL_SEARCH" value="<%=strTableLevelSearch%>">
<input type="hidden" id="TABLE_CODE_SEARCH"  name="TABLE_CODE_SEARCH"  value="<%=strTableCodeSearch%>">
<input type="hidden" id="TABLE_NAME_SEARCH"  name="TABLE_NAME_SEARCH"  value="<%=strTableNameSearch%>">

<input type="hidden" id="OLD_MODE_LEVEL"          name="OLD_MODE_LEVEL"           value="<%=strMode%>">
<input type="hidden" id=TABLE_LEVEL_CODE_SEARCH   name="TABLE_LEVEL_CODE_SEARCH"  value="<%=strTableLevelCodeSearch%>">
<input type="hidden" id="TABLE_LEVEL_NAME_SEARCH" name="TABLE_LEVEL_NAME_SEARCH"  value="<%=strTableLevelNameSearch%>">

<input type="hidden" id="mode_tab4"         name="mode_tab4"         value="<%=strMode%>">
<input type="hidden" id="current_page_tab4" name="current_page_tab4" value="<%=strCurrentPage%>">
<input type="hidden" id="sortby_tab4"       name="sortby_tab4"       value="<%=sortby%>">
<input type="hidden" id="sortfield_tab4"    name="sortfield_tab4"    value="<%=sortfield%>">

<input type="hidden" id="mode_parent"         name="mode_parent"         value="<%=mode_parent%>">
<input type="hidden" id="current_page_parent" name="current_page_parent" value="<%=current_page_parent%>">
<input type="hidden" id="page_size_parent" name="page_size_parent" value="<%=page_size_parent%>">
<input type="hidden" id="sortby_parent"       name="sortby_parent"       value="<%=sortby_parent%>">
<input type="hidden" id="sortfield_parent"    name="sortfield_parent"    value="<%=sortfield_parent%>">
</form>
<form id="formsearch" name="formsearch" method="post">
<input type="hidden" id="MODE"             name="MODE"             value="">
<input type="hidden" id="TABLE_CODE_KEY"   name="TABLE_CODE_KEY"   value="<%=strTableCodeKey%>">
<input type="hidden" id="TABLE_NAME_KEY"   name="TABLE_NAME_KEY"   value="<%=strTableNameKey%>">
<input type="hidden" id="TABLE_LEVEL_KEY"  name="TABLE_LEVEL_KEY"  value="<%=strTableLevelKey %>">
<input type="hidden" id="TABLE_LEVEL1_KEY" name="TABLE_LEVEL1_KEY" value="<%=strTableLevel1Key %>">
<input type="hidden" id="TABLE_LEVEL2_KEY" name="TABLE_LEVEL2_KEY" value="<%=strTableLevel2Key %>">

<input type="hidden" id="FIELD_LEVEL1_CODE" name="FIELD_LEVEL1_CODE" value="<%=strFieldLevel1Code %>">
<input type="hidden" id="FIELD_LEVEL1_NAME" name="FIELD_LEVEL1_NAME" value="<%=strFieldLevel1Name %>">
<input type="hidden" id="FIELD_LEVEL2_CODE" name="FIELD_LEVEL2_CODE" value="<%=strFieldLevel2Code %>">
<input type="hidden" id="FIELD_LEVEL2_NAME" name="FIELD_LEVEL2_NAME" value="<%=strFieldLevel2Name %>">

<input type="hidden" id="TABLE_LEVEL1_NAME_KEY" name="TABLE_LEVEL1_NAME_KEY" value="<%=strTableLevel1NameKey %>">
<input type="hidden" id="TABLE_LEVEL2_NAME_KEY" name="TABLE_LEVEL2_NAME_KEY" value="<%=strTableLevel2NameKey %>">
<input type="hidden" id="screenname"            name="screenname"            value="<%=screenname%>">
           			
<input type="hidden" id="OLD_MODE"           name="OLD_MODE"           value="<%=strOldMode%>">
<input type="hidden" id="TABLE_LEVEL_SEARCH" name="TABLE_LEVEL_SEARCH" value="<%=strTableLevelSearch%>">
<input type="hidden" id="TABLE_CODE_SEARCH"  name="TABLE_CODE_SEARCH"  value="<%=strTableCodeSearch%>">
<input type="hidden" id="TABLE_NAME_SEARCH"  name="TABLE_NAME_SEARCH"  value="<%=strTableNameSearch%>">

<input type="hidden" id="OLD_MODE_LEVEL"          name="OLD_MODE_LEVEL"           value="<%=strMode%>">
<input type="hidden" id=TABLE_LEVEL_CODE_SEARCH   name="TABLE_LEVEL_CODE_SEARCH"  value="<%=strTableLevelCodeSearch%>">
<input type="hidden" id="TABLE_LEVEL_NAME_SEARCH" name="TABLE_LEVEL_NAME_SEARCH"  value="<%=strTableLevelNameSearch%>">

<input type="hidden" id="mode_parent"         name="mode_parent"         value="<%=mode_parent%>">
<input type="hidden" id="current_page_parent" name="current_page_parent" value="<%=current_page_parent%>">
<input type="hidden" id="page_size_parent"    name="page_size_parent"    value="<%=page_size_parent%>">
<input type="hidden" id="sortby_parent"       name="sortby_parent"       value="<%=sortby_parent%>">
<input type="hidden" id="sortfield_parent"    name="sortfield_parent"    value="<%=sortfield_parent%>">

<input type="hidden" id="mode_tab4"         name="mode_tab4"         value="<%=strMode%>">
<input type="hidden" id="current_page_tab4" name="current_page_tab4" value="<%=strCurrentPage%>">
<input type="hidden" id="sortby_tab4"       name="sortby_tab4"       value="<%=sortby%>">
<input type="hidden" id="sortfield_tab4"    name="sortfield_tab4"    value="<%=sortfield%>">
</form>
</body>
</html>