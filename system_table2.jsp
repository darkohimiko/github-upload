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

    UserInfo userInfo = (UserInfo)session.getAttribute( "USER_INFO" );
    String  strUserId = userInfo.getUserId();

    String strClassName = "ZOOM_TABLE_MANAGER";
    String strMode      = checkNull(request.getParameter("MODE"));
    String strOldMode   = checkNull(request.getParameter("OLD_MODE"));
    String screenname   = getField(request.getParameter("screenname"));
    String screenLabel  = getField(request.getParameter("screenLabel"));
    
    String strTableCodeKey   = checkNull(request.getParameter("TABLE_CODE_KEY"));
    String strTableNameKey   = getField(request.getParameter("TABLE_NAME_KEY"));
    String strTableLevelKey  = checkNull(request.getParameter("TABLE_LEVEL_KEY"));
    String strTableLevel1Key = checkNull(request.getParameter("TABLE_LEVEL1_KEY"));
    String strTableLevel2Key = checkNull(request.getParameter("TABLE_LEVEL2_KEY"));

    String strTableLevelSearch = checkNull(request.getParameter("TABLE_LEVEL_SEARCH"));
    String strTableCodeSearch  = checkNull(request.getParameter("TABLE_CODE_SEARCH"));
    String strTableNameSearch  = getField(request.getParameter("TABLE_NAME_SEARCH"));

    String strTableCodeData       = checkNull(request.getParameter("txtTableCode"));
    String strTableNameData       = getField(request.getParameter("txtTableName"));
    String strTableLevelData      = checkNull(request.getParameter("hidTableLevel"));
    String strTableLevel1Data     = checkNull(request.getParameter("txtTableLevel1"));
    String strTableLevel1NameData = getField(request.getParameter("txtTableLevel1Name"));
    String strTableLevel2Data     = checkNull(request.getParameter("txtTableLevel2"));
    String strTableLevel2NameData = getField(request.getParameter("txtTableLevel2Name"));
    
    String mode_parent         = checkNull(request.getParameter( "mode_parent" ));
    String current_page_parent = checkNull(request.getParameter( "current_page_parent" ));
    String page_size_parent = checkNull(request.getParameter( "page_size_parent" ));
    String sortby_parent       = checkNull(request.getParameter( "sortby_parent" ));
    String sortfield_parent    = checkNull(request.getParameter( "sortfield_parent" ));
    
    boolean bolnSuccess     = true;
    String  strErrorCode    = null;
    String  strmsg          = "";
    String	strCurrentDate	= "";
    String strVersionLang  = ImageConfUtil.getVersionLang();

    if( strVersionLang.equals("thai") ) {
            strCurrentDate = getServerDateThai();
    }else {
            strCurrentDate = getServerDateEng();
    }
	
    if( strMode == null ){
        strMode = "SEARCH";
    }

    if( strMode.equals( "pInsert" ) ) {
		screenLabel = lb_add_new_table;
		
    }else if( strMode.equals( "pEdit" ) ) {
    	screenLabel            = lb_edit_table;
        strTableCodeData       = strTableCodeKey;
        strTableNameData       = strTableNameKey;
        strTableLevelData      = strTableLevelKey;
        strTableLevel1Data     = strTableLevel1Key;
        strTableLevel2Data     = strTableLevel2Key;
        
        if( !strTableLevel1Data.equals("") ) {
	        con1.addData( "TABLE_CODE",  "String", strTableLevel1Data);
	        bolnSuccess = con1.executeService( strContainerName , strClassName , "getTableLevelName" );
	        strTableLevel1NameData = con1.getHeader( "TABLE_NAME" );
        }
        
        if( !strTableLevel2Data.equals("") ) {
	        con1.addData( "TABLE_CODE",  "String", strTableLevel2Data);
	        bolnSuccess = con1.executeService( strContainerName , strClassName , "getTableLevelName" );
	        strTableLevel2NameData = con1.getHeader( "TABLE_NAME" );
        }
    }

    if(strMode.equals("ADD")){
        con.addData( "TABLE_CODE",  "String", strTableCodeData);
        con.addData( "TABLE_NAME",  "String", strTableNameData);
        con.addData( "TABLE_LEVEL", "String", strTableLevelData);
        if( !strTableLevel1Data.equals("") ) {
        	con.addData( "TABLE_LEVEL1", "String", strTableLevel1Data);
        }
        if( !strTableLevel2Data.equals("") ) {
        	con.addData( "TABLE_LEVEL2", "String", strTableLevel2Data);
        }
        con.addData( "NOT_DROP_FLAG", "String", "N");
        con.addData( "CURRENT_DATE",  "String", strCurrentDate);
        con.addData( "UPD_USER",      "String", strUserId);
        con.addData( "ADD_USER",      "String", strUserId);
        
        con.addData( "DESC",  		  "String", strTableCodeData.toUpperCase() + "-" + strTableNameData );
    	con.addData( "USER_ID",  	 "String", strUserId );
        con.addData( "ACTION_FLAG",  "String", "AT" );             

        bolnSuccess = con.executeService( strContainerName , strClassName , "insertZoomTableManager" );

        if( !bolnSuccess ){
            strErrorCode    = con.getRemoteErrorCode();
            if(strErrorCode.equals("ERR00002")){
                strmsg  = "showMsg(0,0,\" " + lc_system_table_dup + "\")";
                strMode = "pInsert";
            }else{
                strmsg  = "showMsg(0,0,\" " + lc_can_not_insert_system_table + "\")";
                strMode = "pInsert";

            }

        }else{
            strmsg  = "showMsg(0,0,\" " +  lc_insert_system_table_successfull + "\")";
            strMode = "MAIN";
        }
     }else if(strMode.equals("EDIT")){
    	 con.addData( "TABLE_CODE",  "String", strTableCodeData);
         con.addData( "TABLE_NAME",  "String", strTableNameData);
         con.addData( "TABLE_LEVEL", "String", strTableLevelData);
         if( !strTableLevel1Data.equals("") ) {
         	con.addData( "TABLE_LEVEL1", "String", strTableLevel1Data);
         }
         if( !strTableLevel2Data.equals("") ) {
         	con.addData( "TABLE_LEVEL2", "String", strTableLevel2Data);
         }
         con.addData( "CURRENT_DATE", "String", strCurrentDate);
         con.addData( "UPD_USER",     "String", strUserId);
         con.addData( "ADD_USER",     "String", strUserId);
         
         con.addData( "DESC",  		  "String", strTableCodeData.toUpperCase() + "-" + strTableNameData );
     	 con.addData( "USER_ID",  	  "String", strUserId );
         con.addData( "ACTION_FLAG",  "String", "ET" );           

        bolnSuccess = con.executeService( strContainerName , strClassName , "updateZoomTableManager"  );

        if( !bolnSuccess ){
            strErrorCode = con.getRemoteErrorCode();
            strmsg  = "showMsg(0,0,\" " + lc_can_not_update_data  + "\")";
            strMode = "pEdit";
        }else{
            strmsg  = "showMsg(0,0,\" " + lc_edit_system_table_successfull + "\")";
            strMode = "MAIN";
        }
     }
    
%>

<!DOCTYPE HTML>
<html>
<head>
<title><%=lc_site_name%></title>
<meta http-equiv="Content-Type" content="text/html; charset=TIS-620">
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
<script language="JavaScript" src="js/util.js"></script>
<script language="JavaScript" src="js/constant.js"></script>
<script language="JavaScript" src="js/label/lb_system_table.js"></script>
<script language="JavaScript" src="js/function/field-utils.js"></script>
<script language="JavaScript" src="js/function/zoom-utils.js"></script>
<script language="JavaScript" type="text/javascript">
<!--

var mode = "<%=strMode%>";
var strTableLevel1   = "<%=strTableLevel1Data%>";
var strTableLevel2   = "<%=strTableLevel2Data%>";
var lv_selectedValue = "";

$(document).ready(window_onload);

function window_onload() {
    set_field();
    set_label();
    set_message();
    set_init();    
    display_HTML( lv_selectedValue );
}

function set_init(){
    if( mode == "MAIN" ) {
        $("#form1").attr('action', 'system_table1.jsp');
        $("#MODE").val($("#OLD_MODE").val());
        $("#CURRENT_PAGE").val($("#current_page_parent").val());
        $("#PAGE_SIZE").val($("#page_size_parent").val());
        $("#sortfield").val($("#sortfield_parent").val());
        $("#sortby").val($("#sortby_parent").val());
        $("#form1").submit();
    }else if( mode == "pEdit" ) {
    	if( strTableLevel2 != "" && strTableLevel1 != "" ) {
    		lv_selectedValue = 3;
    	}else if( strTableLevel2 == "" && strTableLevel1 != "" ) {
    		lv_selectedValue = 2;
    	}else if( strTableLevel2 == "" && strTableLevel1 == "" ) {
    		lv_selectedValue = 1;
    	}
    	$("#txtTableName").focus();
    }else if( mode == "pInsert" ) {
    	lv_selectedValue = 1;
        $("#txtTableCode").focus();
    }
}

function set_field(){
    global_field = "selTableLevel,txtTableCode,txtTableName";
}

function set_label(){
    $("#lb_table_level").text(lbl_table_level);
    $("#lb_table_code").text(lbl_table_code);
    $("#lb_table_name").text(lbl_table_name);
    $("#lb_table_level1").text(lbl_table_level1);
    $("#lb_table_level2").text(lbl_table_level2);
}

function set_message(){    
<%  if (!strmsg.equals("")) {  %>
    <%=strmsg%>
<%  }   %>
}

function display_HTML( lv_selectedValue ) {
	
    if( lv_selectedValue == "" ) {
        lv_selectedValue == 1;
    }

    $("#selTableLevel").val(lv_selectedValue);
    $("#hidTableLevel").val(lv_selectedValue);
    $("#txtTableCode").val("<%=strTableCodeData%>");
    $("#txtTableName").val("<%=strTableNameData%>");

    if( mode == "pEdit" ) {
        $("#selTableLevel").prop('disabled', true);
        $("#selTableLevel").addClass("input_box_disable");
        $("#txtTableCode").prop('readOnly', true);
        $("#txtTableCode").addClass("input_box_disable");
    }

    if( lv_selectedValue == 1 ) {
        $("#trLevel1").hide();
        $("#trLevel2").hide();
    }

    if( lv_selectedValue == 2 ) {
        $("#trLevel1").show();
        $("#trLevel2").hide();
        if( mode != "pEdit" ) {
            $("#searchLV1").show();
        }else{
            $("#searchLV1").hide();
        }
        $("#txtTableLevel1").val("<%=strTableLevel1Data%>");
        $("#txtTableLevel1Name").val("<%=strTableLevel1NameData%>");
    }

    if( lv_selectedValue == 3 ) {
        $("#trLevel1").show();
        $("#trLevel2").show();
        $("#searchLV1").hide();

        if( mode == "pEdit" ) {
            $("#searchLV2").hide();
        }
        $("#txtTableLevel1").val("<%=strTableLevel1Data%>");
        $("#txtTableLevel1Name").val("<%=strTableLevel1NameData%>");
        $("#txtTableLevel2").val("<%=strTableLevel2Data%>");
        $("#txtTableLevel2Name").val("<%=strTableLevel2NameData%>");
    }
}

function verify_form() {
    var strTableCode = $("#txtTableCode").val();
    if( $("#hidTableLevel").val() == 2 ) {
        if( $("#txtTableLevel1").val().length == 0 ) {
            alert( lc_check_table_level1 );
            $("#txtTableLevel1").focus();
            return false;
        }		
    }

    if( $("#hidTableLevel").val() == 3 ) {
        if( $("#txtTableLevel2").val().length == 0 ) {
            alert( lc_check_table_level2 );
            $("#txtTableLevel2").focus();
            return false;
        }
    }	
	
    if( strTableCode.length == 0 ) {
        alert( lc_check_table_code );
        $("#txtTableCode").focus();
        return false;
    }
    
    if( strTableCode.indexOf(" ") != -1 ) {
        alert( lc_check_space_table_name );
        $("#txtTableCode").focus();
        return false;
    }
    
    if( $("#txtTableName").val().length == 0 ) {
        alert( lc_check_table_name );
        $("#txtTableName").focus();
        return false;
    }
    
    return true;
}

function button_click( lv_strMethod ){
    switch( lv_strMethod ){
        case "save" :
            if(verify_form()){
                if($("#MODE").val() == "pInsert"){
                    $("#MODE").val("ADD") ;
                }else{
                    $("#MODE").val("EDIT") ;
                }
                $("#form1").submit();
            }
            break;
        case "cancel" :
            $("#form1").attr('action',"system_table1.jsp");
            $("#form1").attr('target' ,"_self");
            $("#CURRENT_PAGE").val($("#current_page_parent").val());
            $("#PAGE_SIZE").val($("#page_size_parent").val());
            $("#sortfield").val($("#sortfield_parent").val());
            $("#sortby").val($("#sortby_parent").val());
            $("#MODE").val($("#OLD_MODE").val());
            $("#form1").submit();
            break;
    }
}

function window_onunload(){
    close_zoom_popup();
}

//-->
</script>
<link href="css/edas.css" type="text/css" rel="stylesheet">
</head>
<body onLoad="MM_preloadImages('images/btt_save2_over.gif','images/btt_cancel_over.gif');">
<form id="form1" name="form1" method="post" action="" >
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0" align="center">
    <tr>
        <td valign="top">
            <table width="800" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td height="25" class="label_header01" colspan="2">&nbsp;&nbsp;<%=screenname%>&nbsp; >> &nbsp;<%=screenLabel %></td>
                </tr>
                <tr>
                    <td width="20">&nbsp;</td>
                    <td height="25" align="left">
            		<table width="622" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td height="25" colspan="4">&nbsp;</td>
                            </tr>
                            <tr>
                                <td width="99" height="25" class="label_bold2"><span id="lb_table_level"></span>&nbsp;<img src="images/mark.gif" width="12" height="11"></td>
                                <td height="25" colspan="3">
                                    <select id="selTableLevel" name="selTableLevel" class="input_box" onchange="display_HTML(this.options[this.selectedIndex].value)" onkeypress="key_press(this);">
<%
				if( strVersionLang.equals("thai") ) {
%>
                                        <option value ="1">�дѺ 1</option>
                                        <option value ="2">�дѺ 2</option>
                                        <option value ="3">�дѺ 3</option>
<%
                                }else {
%>
                                        <option value ="1">Level 1</option>
                                        <option value ="2">Level 2</option>
                                        <option value ="3">Level 3</option>
<%
                                }
%>
                                    </select>
                                    <input  type="hidden" id="hidTableLevel" name="hidTableLevel" >
                                </td>
                            </tr>
                            <tr id="trLevel2" style="display: none">
                                <td height="25" class="label_bold2"><span id="lb_table_level2"></span>&nbsp;
                                    <img src="images/mark.gif" width="12" height="11">
                                </td>
                                <td width="107" height="25">
                                    <input id="txtTableLevel2" name="txtTableLevel2" type="text" class="input_box_disable" size="20" maxlength="30" readonly>
                                </td>
                                <td width="20" height="25" align="center">
                                    <a href="javascript:open_zoom_table('2','txtTableLevel2,txtTableLevel2Name,txtTableLevel1,txtTableLevel1Name');"><img src="images/search.gif" id="searchLV2" name="searchLV2" width="16" height="16" border="0"></a>
                                </td>
                                <td width="312">
                                    <input id="txtTableLevel2Name" name="txtTableLevel2Name" type="text" class="input_box_disable" size="40" maxlength="50" readonly>
                                </td>
                            </tr>
                            <tr id="trLevel1" style="display: none">
                                <td height="25" class="label_bold2"><span id="lb_table_level1"></span>&nbsp;
                                    <img src="images/mark.gif" width="12" height="11">
                                </td>
                                <td width="107" height="25">
                                    <input id="txtTableLevel1" name="txtTableLevel1" type="text" class="input_box_disable" size="20" maxlength="30" readonly>
                                </td>
                                <td width="20" height="25" align="center">
                                    <a href="javascript:open_zoom_table('1','txtTableLevel1,txtTableLevel1Name');"><img src="images/search.gif" id="searchLV1" name="searchLV1" width="16" height="16" border="0"></a>
                                </td>
                                <td width="312">
                                    <input id="txtTableLevel1Name" name="txtTableLevel1Name" type="text" class="input_box_disable" size="40" maxlength="50" readonly>
                                </td>
                            </tr>
                            <tr>
                                <td height="25" class="label_bold2"><span id="lb_table_code"></span>&nbsp;<img src="images/mark.gif" width="12" height="11"></td>
                                <td height="25" colspan="3">
                                    <input id="txtTableCode" name="txtTableCode" type="text" class="input_box" onkeypress="checked_keypress(event);key_press(this);" size="20" maxlength="30">
                                </td>
                            </tr>
                            <tr>
                                <td height="25" class="label_bold2"><span id="lb_table_name"></span>&nbsp;<img src="images/mark.gif" width="12" height="11"></td>
                                <td height="25" colspan="3">
                                    <input id="txtTableName" name="txtTableName" type="text" class="input_box" size="30" maxlength="50" onkeypress="key_press(this);">
                                </td>
                            </tr>
                            <tr>
                                <td height="25" colspan="4">&nbsp;</td>
                            </tr>
                            <tr>
                                <td align="center" colspan="4">
                                    <a href="#" onclick= "button_click('save')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('save','','images/btt_save2_over.gif',1)">
                                            <img src="images/btt_save2.gif" name="save" width="67" height="22" border="0"></a>&nbsp;
                                    <a href="#" onclick= "button_click('cancel')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('cancel','','images/btt_cancel_over.gif',1)">
                                            <img src="images/btt_cancel.gif" name="cancel" width="67" height="22" border="0"></a>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>
<input type="hidden" id="MODE"         name="MODE"         value="<%=strMode%>">
<input type="hidden" id="screenname"   name="screenname"   value="<%=screenname%>">
<input type="hidden" id="screenLabel"  name="screenLabel"  value="<%=screenLabel%>">
<input type="hidden" id="CURRENT_PAGE" name="CURRENT_PAGE" value="">
<input type="hidden" id="PAGE_SIZE"    name="PAGE_SIZE"    value="">
<input type="hidden" id="sortby"       name="sortby"       value="">
<input type="hidden" id="sortfield"    name="sortfield"    value="">
<input type="hidden" id="OLD_MODE"            name="OLD_MODE"            value="<%=strOldMode%>">
<input type="hidden" id="TABLE_LEVEL_SEARCH"  name="TABLE_LEVEL_SEARCH"  value="<%=strTableLevelSearch%>">
<input type="hidden" id="TABLE_CODE_SEARCH"   name="TABLE_CODE_SEARCH"   value="<%=strTableCodeSearch%>">
<input type="hidden" id="TABLE_NAME_SEARCH"   name="TABLE_NAME_SEARCH"   value="<%=strTableNameSearch%>">
<input type="hidden" id="mode_parent"         name="mode_parent"         value="<%=mode_parent%>">
<input type="hidden" id="current_page_parent" name="current_page_parent" value="<%=current_page_parent%>">
<input type="hidden" id="page_size_parent"    name="page_size_parent"    value="<%=page_size_parent%>">
<input type="hidden" id="sortby_parent"       name="sortby_parent"       value="<%=sortby_parent%>">
<input type="hidden" id="sortfield_parent"    name="sortfield_parent"    value="<%=sortfield_parent%>">
</form>
</body>
</html>