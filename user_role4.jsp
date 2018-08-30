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

    String screenname   = getField(request.getParameter("screenname"));
    String strClassName = "USER_ROLE";
    String strMode      = getField(request.getParameter("MODE"));

    boolean bolnSuccess	 = false;
    boolean bolnSuccess1 = false;
    
    String strmsg         = "";
    String strCurrentDate = "";
    String strVersionLang = ImageConfUtil.getVersionLang();

    if( strVersionLang.equals("thai") ) {
        strCurrentDate = getTodayDateThai();
    }else{
        strCurrentDate = getTodayDate();
    }
		
    String strUserRoleKey = getField(request.getParameter( "USER_ROLE_KEY" ));
    String strRoleNameKey = getField(request.getParameter( "ROLE_NAME_KEY" ));
    String strDefRoleKey  = getField(request.getParameter( "DEFAULT_ROLE_KEY" ));
    
    String strUserRoleData         = getField(request.getParameter( "USER_ROLE_KEY" ));
    String strApplicationData      = getField(request.getParameter( "hidApplication" ));
    String strApplicationGroupData = getField(request.getParameter( "hidAppGroup" ));
    String strApplicationNameData  = "";
    String strFunctionAvalData     = "";
    String strPermitFunctionData   = "";
    
    String strScript    = "";
    String strPermit    = "";
    String strbttRole   = "<img src=\"images/True.gif\" width=\"16\" height=\"16\" border=\"0\" id=\"role\">";

    if( strMode == null || strMode.equals("")){
        strMode = "SEARCH";
    }
    
    if( strMode.equals("PERMIT") ) {
    	con.addData( "USER_ROLE",   "String", strUserRoleData );
    	con.addData( "APPLICATION", "String", strApplicationData );
        con.addData( "ADD_USER",    "String", strUserId);
        con.addData( "ADD_DATE",    "String", strCurrentDate);
        con.addData( "UPD_USER",    "String", strUserId);
        bolnSuccess = con.executeService( strContainerName, strClassName, "permitUserRoleAdmin" );
        if( !bolnSuccess ) {
            strmsg  = "showMsg(0,0,\" " + lc_can_not_update_data + "\")";
            strMode = "SEARCH";
        }else {
            strmsg  = "showMsg(0,0,\" " + lc_update_data_successfull + "\")";
            strMode = "SEARCH";
        }
    }
    
    if( strMode.equals("UNPERMIT") ) {
    	con.addData( "USER_ROLE",   "String", strUserRoleData );
    	con.addData( "APPLICATION", "String", strApplicationData );
        bolnSuccess = con.executeService( strContainerName, strClassName, "unPermitUserRoleAdmin" );
        if( !bolnSuccess ) {
            strmsg  = "showMsg(0,0,\" " + lc_can_not_update_data + "\")";
            strMode = "SEARCH";
        }else {
            strmsg  = "showMsg(0,0,\" " + lc_update_data_successfull + "\")";
            strMode = "SEARCH";
        }
    }
    
    if( strMode.equals("ALLPERMIT") ) {
    	con.addData( "USER_ROLE", "String", strUserRoleData );
        con.addData( "ADD_USER",  "String", strUserId);
        con.addData( "ADD_DATE",  "String", strCurrentDate);
        con.addData( "UPD_USER",  "String", strUserId);
        bolnSuccess = con.executeService( strContainerName, strClassName, "permitAllUserRoleAdmin" );
        if( !bolnSuccess ) {
            strmsg  = "showMsg(0,0,\" " + lc_can_not_update_data + "\")";
            strMode = "SEARCH";
        }else {
            strmsg  = "showMsg(0,0,\" " + lc_update_data_successfull + "\")";
            strMode = "SEARCH";
        }
    }
    
    if( strMode.equals("UNALLPERMIT") ) {
    	con.addData( "USER_ROLE", "String", strUserRoleData );
        bolnSuccess = con.executeService( strContainerName, strClassName, "unPermitAllUserRoleAdmin" );
        if( !bolnSuccess ) {
            strmsg  = "showMsg(0,0,\" " + lc_can_not_update_data + "\")";
            strMode = "SEARCH";
        }else {
            strmsg  = "showMsg(0,0,\" " + lc_update_data_successfull + "\")";
            strMode = "SEARCH";
        }
    }
    
    if( strMode.equals("SEARCH") ) {
        bolnSuccess = con.executeService( strContainerName, strClassName, "findAllAdminApplication" );
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
<script language="JavaScript" src="js/label/lb_user_role.js"></script>
<script language="JavaScript" src="js/util.js"></script>
<script language="JavaScript" src="js/constant.js"></script>
<script language="JavaScript" type="text/javascript">
<!--

var defaultRole = "<%=strDefRoleKey %>";

$(document).ready(window_onload);

function window_onload(){
    set_label();
    set_init(); 
    set_message();
    hideAllTr();
}

function set_label(){
    lb_function_main.innerHTML = lbl_function_main;
    lb_sub_function.innerHTML  = lbl_sub_function;
    lb_add_table.innerHTML   = lbl_add_table;
    lb_new_role.innerHTML    = lbl_new_role;
    lb_new_level.innerHTML   = lbl_new_level;
    lb_new_profile.innerHTML = lbl_new_profile;
    lb_add_cabinet.innerHTML = lbl_add_cabinet;
    lb_save_data.innerHTML   = lbl_save_data;
    lb_search_data.innerHTML = lbl_search_data;
    lb_edit_data.innerHTML   = lbl_edit_data;
    lb_delete_data.innerHTML = lbl_delete_data;
    lb_insert_data.innerHTML = lbl_insert_data;
    lb_permit.innerHTML      = lbl_permit;
}

function set_init(){
    if( defaultRole == "Y" ) {
        $("#permit").hide();
        $("#unPermit").hide();
        $("#allPermit").hide();
        $("#unAllPermit").hide();
    }
}

function set_message(){
    
<%  if (!strmsg.equals("")) {  %>
    <%=strmsg%>
<%  }   %>
}

function buttonClick( lv_strMethod ){
    switch( lv_strMethod ){
        case "permit" :
            
            if( $("#hidApplication").val() == "" ) {
                alert( lc_not_selected_function );
                return;
            }
            if( $("#hidHadPermit").val() == "yes" ) {
                    return;
            }
            $("#form1").attr('action', "user_role4.jsp");
            $("#form1").attr('target', "_self");
            $("#MODE").val("PERMIT");
            $("#form1").submit();
            break;
        case "unPermit" :
            if( $("#hidApplication").val() == "" ) {
                alert( lc_not_selected_function );
                return;
            }
            if( $("#hidHadPermit").val() == "no" ) {
                return;
            }
            $("#form1").attr('action', "user_role4.jsp");
            $("#form1").attr('target', "_self");
            $("#MODE").val("UNPERMIT");
            $("#form1").submit();
            break;
        case "allPermit" :
            $("#form1").attr('action', "user_role4.jsp");
            $("#form1").attr('target', "_self");
            $("#MODE").val("ALLPERMIT");
            $("#form1").submit();
            break;
        case "unAllPermit" :
            $("#form1").attr('action', "user_role4.jsp");
            $("#form1").attr('target', "_self");
            $("#MODE").val("UNALLPERMIT");
            $("#form1").submit();
            break;
        case "cancel" :
            $("#form1").attr('action', "user_role1.jsp");
            $("#form1").attr('target', "_self");
            $("#MODE").val("SEARCH");
            $("#form1").submit();
            break;
	}
}

function mouseOver( rowObjOver ) {
    if( rowObjOver.style.backgroundColor != '#b0e0e6' || rowObjOver.style.backgroundColor != 'rgb(176, 224, 230)' ) {
        rowObjOver.style.backgroundColor = '#9999ff';
    }
}

function mouseOut( rowObjOut, intRow ){
    if( intRow % 2 != 0 ) {
        if( rowObjOut.style.backgroundColor != '#b0e0e6' && rowObjOut.style.backgroundColor != 'rgb(176, 224, 230)' ) {
            rowObjOut.style.backgroundColor = '#FFFFFF';
        }
    }else {
        if( rowObjOut.style.backgroundColor != '#b0e0e6' && rowObjOut.style.backgroundColor != 'rgb(176, 224, 230)') {
            rowObjOut.style.backgroundColor = '#f9eac7';
        }
    }
}

function mouseClick( rowObjClick, intRow ) {
    var lastRow = $("#lastRowSelected").val();

    if( lastRow != "" ) {
        if( lastRow % 2 != 0 ) {
            $("#tableResult tr").eq(lastRow).css('background-color','#ffffff');
        }else {
            $("#tableResult tr").eq(lastRow).css('background-color','#f9eac7');
        }
    }

    $("#hidApplication").val(rowObjClick.getAttribute("APPLICATION"));
    $("#hidHadPermit").val(rowObjClick.getAttribute("PERMIT"));
        
    rowObjClick.style.backgroundColor = '#b0e0e6';
    $("#lastRowSelected").val(intRow);
    
    displayCheckBox( rowObjClick );
    
}

function displayCheckBox( lv_obj ) {
    var isChecked = lv_obj.getAttribute("PERMIT");
    var func_aval = lv_obj.getAttribute("FUNCTION_AVAL");

    hideAllTr();
    if( func_aval.indexOf("addTable") != -1 ) {
        $("#trAddTable").show();
        checkedAndDisabled( $("#chkAddTable"), isChecked );
    }
    if( func_aval.indexOf("newRole") != -1 ) {
        $("#trNewRole").show();
        checkedAndDisabled( $("#chkNewRole"), isChecked );
    }
    if( func_aval.indexOf("newLevel") != -1 ) {
        $("#trNewLevel").show();
        checkedAndDisabled( $("#chkNewLevel"), isChecked );
    }
    if( func_aval.indexOf("newProfile") != -1 ) {
        $("#trNewProfile").show();
        checkedAndDisabled( $("#chkNewProfile"), isChecked );
    }
    if( func_aval.indexOf("addCabinte") != -1 ) {
        $("#trAddCabinte").show();
        checkedAndDisabled( $("#chkAddCabinte"), isChecked );
    }
    if( func_aval.indexOf("insertData") != -1 ) {
        $("#trInsertData").show();
        checkedAndDisabled( $("#chkSave"), isChecked );
    }
    if( func_aval.indexOf("permit") != -1 ) {
        $("#trPermit").show();
        checkedAndDisabled( $("#chkPermit"), isChecked );
    }
    if( func_aval.indexOf("insert") != -1 ) {
        $("#trSave").show();
        checkedAndDisabled( $("#chkSave"), isChecked );
    }
    if( func_aval.indexOf("search") != -1 ) {
        $("#trSearch").show();
        checkedAndDisabled( $("#chkSearch"), isChecked );
    }
    if( func_aval.indexOf("update") != -1 ) {
        $("#trUpdate").show();
        checkedAndDisabled( $("#chkUpdate"), isChecked );
    }
    if( func_aval.indexOf("delete") != -1 ) {
        $("#trDel").show();
        checkedAndDisabled( $("#chkDel"), isChecked );
    }
}

function checkedAndDisabled( lv_obj_chk, lv_boln ) {
    if( lv_boln == "yes" ) {
        lv_obj_chk.prop('checked', true);
    }else {
        lv_obj_chk.prop('checked', false);
    }
}

function hideAllTr() {
    $("#trSave").hide();
    $("#trSearch").hide();
    $("#trUpdate").hide();
    $("#trDel").hide();
    $("#trAddTable").hide();
    $("#trNewRole").hide();
    $("#trNewLevel").hide();
    $("#trNewProfile").hide();
    $("#trAddCabinte").hide();
    $("#trInsertData").hide();
    $("#trPermit").hide();
}

//-->
</script>
<link href="css/edas.css" type="text/css" rel="stylesheet">
</head>
<body onLoad="MM_preloadImages('images/btt_all-right_over.gif','images/btt_cancelall-right_over.gif','images/btt_cancelright_over.gif',
			'images/btt_commitrights_over.gif','images/btt_back_over.gif','images/btt_selectall_s_over.gif','images/btt_noselect_over.gif');">
<form id="form1" name="form1" method="post" action="" >
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
<tr>
    <td valign="top">
    	<table width="700" border="0" cellspacing="0" cellpadding="0">
            <tr>
                <td height="25" class="label_header01" colspan="3">&nbsp;&nbsp;<%=screenname%>&nbsp; >> &nbsp;<%=strRoleNameKey %></td>
            </tr>
            <tr>
                <td height="25" class="label_header01" colspan="3"><BR></td>
            </tr>
            <tr> 
                <td valign="top"><div align="center"> 
                    <table id="tableResult" width="250" border="0" cellpadding="0" cellspacing="0">
                      	<tr class="hd_table">
                            <td width="10"><img src="images/hd_tb_01.gif" width="10" height="28"></td>
                            <td width="30">&nbsp;</td>
                            <td width="210" align="center">
                                <div align="center"><span id="lb_function_main"></span></div>
                            </td>
                            <td align="right" width="10"><img src="images/hd_tb_04.gif" width="10" height="28"></td>
                      	</tr>
<%
    if( bolnSuccess ) {
        int intSeq = 1;
        int idx    = 0;
        while( con.nextRecordElement() ){
            strApplicationData      = con.getColumn( "APPLICATION" );
            strApplicationNameData  = con.getColumn( "APPLICATION_NAME" );
            strFunctionAvalData     = con.getColumn( "FUNCTION_AVAL" );
            strApplicationGroupData = con.getColumn( "APPLICATION_GROUP" );
            
            con1.addData( "USER_ROLE",   "String", strUserRoleKey );
            con1.addData( "APPLICATION", "String", strApplicationData );
    		bolnSuccess1 = con1.executeService( strContainerName, strClassName, "findRoleAdminApplication" );
    		
            if( bolnSuccess1 ) {
            	strbttRole = "<img src=\"images/True.gif\" name=\"role" + intSeq + " \"  width=\"16\" height=\"16\" border=\"0\" id=\"role\">";
            	strPermit  = "yes";
            }else {
            	strbttRole = "<img src=\"images/False.gif\" name=\"role" + intSeq + " \"  width=\"16\" height=\"16\" border=\"0\" id=\"role\">";
            	strPermit  = "no";
            }
            strPermitFunctionData = con1.getHeader( "PERMIT_FUNCTION" );
            
            strScript = "APPLICATION=\"" + strApplicationData + "\" APPLICATION_NAME=\"" + strApplicationNameData + "\" PERMIT=\"" +strPermit+ "\" ";
            strScript += "FUNCTION_AVAL=\"" + strFunctionAvalData + "\" PERMIT_FUNCTION=\"" + strPermitFunctionData + "\" APPLICATION_GROUP=\"" + strApplicationGroupData + "\" ";
			
            idx = 2 - (intSeq % 2);
%> 
                      	<tr class="table_data<%=idx%>" onmouseover="mouseOver(this );" onmouseout="mouseOut(this,'<%=intSeq %>');"
                      		onclick="mouseClick( this, '<%=intSeq %>' );" <%=strScript %>>
	                      	<td width="10">&nbsp;</td>
	                        <td width="30"><%=strbttRole %></td>
	                        <td colspan="2"><div align="left">&nbsp;<%=strApplicationNameData %></div></td>
                      	</tr>
<%
            intSeq++;
        }
     }
 %>
                    </table>
                </div>
                </td>
                <td width="15">&nbsp;</td>
                <td valign="top"><div align="center"> 
                    <table width="250" border="0" cellpadding="0" cellspacing="0">
                        <tr class="hd_table"> 
                            <td width="10"><img src="images/hd_tb_01.gif" width="10" height="28"></td>
                            <td width="230" align="center">
                                <div align="center"><span id="lb_sub_function"></span></div>
                            </td>
                            <td align="right" width="10"><img src="images/hd_tb_04.gif" width="10" height="28"></td>
                        </tr>
                        <tr class="table_data1">
                            <td>&nbsp;</td>
                            <td colspan="2">
                                <table id="tableDataCheck" width="235" border="0" cellpadding="0" cellspacing="0">
                                    <tr id="trAddTable" class="table_data1">
                                        <td align="left">
                                            <div><input type="checkbox" id="chkAddTable" disabled >&nbsp;<span id="lb_add_table"></span></div>
                                        </td>
                                    </tr>
                                    <tr id="trNewRole" class="table_data1">
                                        <td align="left">
                                            <div><input type="checkbox" id="chkNewRole" disabled >&nbsp;<span id="lb_new_role"></span></div>
                                        </td>
                                    </tr>
                                    <tr id="trNewLevel" class="table_data1">
                                        <td align="left">
                                            <div><input type="checkbox" id="chkNewLevel" disabled >&nbsp;<span id="lb_new_level"></span></div>
                                        </td>
                                    </tr>
                                    <tr id="trNewProfile" class="table_data1">
                                        <td align="left">
                                            <div><input type="checkbox" id="chkNewProfile" disabled >&nbsp;<span id="lb_new_profile"></span></div>
                                        </td>
                                    </tr>
                                    <tr id="trAddCabinte" class="table_data1">
                                        <td align="left">
                                            <div><input type="checkbox" id="chkAddCabinte" disabled >&nbsp;<span id="lb_add_cabinet"></span></div>
                                        </td>
                                    </tr>
                                    <tr id="trSave" class="table_data1">
                                        <td align="left">
                                            <div><input type="checkbox" id="chkSave" disabled >&nbsp;<span id="lb_save_data"></span></div>
                                        </td>
                                    </tr>
                                    <tr id="trSearch" class="table_data1">
                                        <td align="left">
                                            <div><input type="checkbox" id="chkSearch" disabled >&nbsp;<span id="lb_search_data"></span></div>
                                        </td>
                                    </tr>
                                    <tr id="trUpdate" class="table_data1">
                                        <td align="left">
                                            <div><input type="checkbox" id="chkUpdate" disabled >&nbsp;<span id="lb_edit_data"></span></div>
                                        </td>
                                    </tr>
                                    <tr id="trDel" class="table_data1">
                                        <td align="left">
                                            <div><input type="checkbox" id="chkDel" disabled >&nbsp;<span id="lb_delete_data"></span></div>
                                        </td>
                                    </tr>
                                    <tr id="trInsertData" class="table_data1">
                                        <td align="left">
                                            <div><input type="checkbox" id="chkLinkDoc" disabled >&nbsp;<span id="lb_insert_data"></span></div>
                                        </td>
                                    </tr>
                                    <tr id="trPermit" class="table_data1">
                                        <td align="left">
                                            <div><input type="checkbox" id="chkPermit" disabled >&nbsp;<span id="lb_permit"></span></div>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </div>
                </td>
            </tr>
            <tr>
                <td height="25" class="label_header01" colspan="3"><BR></td>
            </tr>
            <tr>
                <td height="25" class="label_header01" colspan="3" align="center">
                    <a href="#" onclick= "buttonClick('permit')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('permit','','images/btt_commitrights_over.gif',1)" style="display: inline">
                    	<img src="images/btt_commitrights.gif" id="permit" name="permit" width="67" height="22" border="0"></a>
                    <a href="#" onclick= "buttonClick('unPermit')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('unPermit','','images/btt_cancelright_over.gif',1)" style="display: inline">
                    	<img src="images/btt_cancelright.gif" id="unPermit" name="unPermit" width="102" height="22" border="0"></a>&nbsp;&nbsp;&nbsp;
                    <a href="#" onclick= "buttonClick('allPermit')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('allPermit','','images/btt_all-right_over.gif',1)" style="display: inline">
                    	<img src="images/btt_all-right.gif" id="allPermit" name="allPermit" width="102" height="22" border="0"></a>
                    <a href="#" onclick= "buttonClick('unAllPermit')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('unAllPermit','','images/btt_cancelall-right_over.gif',1)" style="display: inline">
                    	<img src="images/btt_cancelall-right.gif" id="unAllPermit" name="unAllPermit" width="142" height="22" border="0"></a>&nbsp;&nbsp;&nbsp;
                    <a href="#" onclick= "buttonClick('cancel')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('back','','images/btt_back_over.gif',1)">
	           	<img src="images/btt_back.gif" id="back" name="back" width="67" height="22" border="0"></a>
                </td>
            </tr>
        </table>
    </td>
</tr>
</table>
<input type="hidden" id="MODE"             name="MODE"             value="<%=strMode%>">
<input type="hidden" id="screenname"       name="screenname"       value="<%=screenname%>">
<input type="hidden" id="lastRowSelected"  name="lastRowSelected"  value="">
<input type="hidden" id="USER_ROLE_KEY"    name="USER_ROLE_KEY"    value="<%=strUserRoleKey %>">
<input type="hidden" id="ROLE_NAME_KEY"    name="ROLE_NAME_KEY"    value="<%=strRoleNameKey %>">
<input type="hidden" id="DEFAULT_ROLE_KEY" name="DEFAULT_ROLE_KEY" value="<%=strDefRoleKey %>">
<input type="hidden" id="hidApplication"   name="hidApplication"   value="">
<input type="hidden" id="hidHadPermit"     name="hidHadPermit"     value="">
<input type="hidden" id="hidAppGroup"      name="hidAppGroup"      value="">
</form>
</body>
</html>
