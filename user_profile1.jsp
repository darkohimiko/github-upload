<%@ page contentType="text/html; charset=tis-620"%>
<%@ page import="com.scc.edms.conf.ImageConfUtil"%>
<%@ page import="com.scc.security.UserInfo"%>
<%@ include file="inc/checkUser.jsp" %>
<%@ include file="inc/constant.jsp" %>
<%@ include file="inc/label.jsp" %>
<%@ include file="inc/utils.jsp" %>
<jsp:useBean id="con" scope="session" class="edms.cllib.EABConnector"/>
<%
    con.setRemoteServer("EAS_SERVER");

    UserInfo userInfo = (UserInfo)session.getAttribute( "USER_INFO" );
    String strUserId  = userInfo.getUserId();

    String screenname   = getField(request.getParameter("screenname"));
    String strClassName = "USER_PROFILE";
    String strMode      = getField(request.getParameter("MODE"));

    String strCurrentPage = request.getParameter( "CURRENT_PAGE" );
    String strPageSize    = request.getParameter( "PAGE_SIZE" );
    if( strCurrentPage == null || Integer.parseInt( strCurrentPage ) == 0 ) {
        strCurrentPage = "1";
    }
    if( strPageSize == null || Integer.parseInt( strPageSize ) == 0 ) {
        strPageSize = "10";
    }

    String  strmsg      = "";
    boolean bolnSuccess = true;
    boolean searchmod   = false;
    
    int intSeq   = 0;
    int i        = 0;
    int idx      = 0;
    int intfield = 0;
    int intclm   = 0;

    String strFieldUserIdSearch     = getField(request.getParameter( "USER_ID_SEARCH" ));
    String strFieldUserNameSearch   = getField(request.getParameter( "USER_NAME_SEARCH" ));
    String strFieldUserSnameSearch  = getField(request.getParameter( "USER_SNAME_SEARCH" ));
    String strFieldUserLevelSearch  = getField(request.getParameter( "USER_LEVEL_SEARCH" ));
    String strFieldOrgCodeSearch    = getField(request.getParameter( "ORG_CODE_SEARCH" ));
    String strFieldUserStatusSearch = getField(request.getParameter( "USER_STATUS_SEARCH" ));

    String strUserIdDelData  = getField(request.getParameter( "USER_ID_DEL" ));
    String strUserStatusData = getField(request.getParameter( "USER_STATUS_DEL" ));
    String strUserNameData   = getField(request.getParameter( "USER_NAME_DEL" ));
    String strUserSnameData  = getField(request.getParameter( "USER_SNAME_DEL" ));

    String strFieldUserIdData     = "";
    String strFieldTitleNameData  = "";
    String strFieldUserNameData   = "";
    String strFieldUserSnameData  = "";
    String strFullNameData        = "";
    String strFieldOrgNameData    = "";
    String strFieldStatusData 	  = "";
    String strFieldStatusNameData = "";
    String strFieldSecFlagData    = "";
    
    String strScript      = "";
    String strTotalPage   = "1";
    String strTotalSize   = "0";
    String strbttEdit     = "";
    String strbttDelete   = "";
    String strbttRole     = "";
    String sortby         = "";
    String sortbyd        = "";
    String sortfield      = "";
    String strCurrentDate = "";
    String strVersionLang  = ImageConfUtil.getVersionLang();

    if( strVersionLang.equals("thai") ) {
        strCurrentDate = getServerDateThai();
    }else{
        strCurrentDate = getServerDateEng();
    }
    
    sortby    = getField( request.getParameter("sortby") );                          
    sortfield = getField( request.getParameter("sortfield") );

    if( strMode == null || strMode.equals("")){
        strMode = "SEARCH";
    }
    
    if( strMode.equals("DELETE") ) {
    	con.addData( "USER_ID",     "String", strUserIdDelData );
    	con.addData( "USER_STATUS", "String", "D" );
    	con.addData( "ACTION_FLAG", "String", "D" );
    	con.addData( "ACTION_DATE", "String", strCurrentDate );
        con.addData( "ADD_USER",    "String", strUserId);
        con.addData( "ADD_DATE",    "String", strCurrentDate);
        con.addData( "UPD_USER",    "String", strUserId);
        
        con.addData( "DESC",  		  "String", "[" + strUserIdDelData + "][" + strUserStatusData + "] " + strUserNameData + " " + strUserSnameData );
     	con.addData( "ADMIN_USER_ID",  	  "String", strUserId );
        con.addData( "ADMIN_ACTION_FLAG", "String", "DU" );
        con.addData( "CURRENT_DATE", 	  "String", strCurrentDate);
        
        bolnSuccess = con.executeService( strContainerName, strClassName, "deleteUserProfile" );
        if( !bolnSuccess ){
            strmsg  = "showMsg(0,0,\" " + lc_can_not_delete_user_profile + "\")";
            strMode = "SEARCH";
        }else{
            strmsg  = "showMsg(0,0,\" " + lc_delete_user_profile_successfull + "\")";
            strMode = "SEARCH";
        }
    }
    
    if( strMode.equals("FIND") ) {
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

    	if( !strFieldUserIdSearch.equals("") ) {
            con.addData( "USER_ID",  "String", strFieldUserIdSearch);
    	}
    	if( !strFieldUserNameSearch.equals("") ) {
            con.addData( "USER_NAME",  "String", strFieldUserNameSearch);
    	}
    	if( !strFieldUserSnameSearch.equals("") ) {
            con.addData( "USER_SNAME", "String", strFieldUserSnameSearch);
    	}
    	if( !strFieldOrgCodeSearch.equals("") ) {
            con.addData( "USER_ORG", "String", strFieldOrgCodeSearch);
    	}
    	if( !strFieldUserLevelSearch.equals("") ) {
            con.addData( "USER_LEVEL", "String", strFieldUserLevelSearch);
    	}
    	if( !strFieldUserStatusSearch.equals("") ) {
            con.addData( "USER_STATUS", "String", strFieldUserStatusSearch);
    	}
    	con.addData( "SORTFIELD",  "String", sortfield );
        con.addData( "SORTBY",     "String", sortbyd );
        con.addData( "PAGENUMBER", "String", strCurrentPage );
        con.addData( "PAGESIZE",   "String", strPageSize );
        bolnSuccess = con.executeService( strContainerName, strClassName, "findUserProfileSearch" );
        if( bolnSuccess ) {
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
        
    	con.addData( "SORTFIELD",  "String", sortfield );
        con.addData( "SORTBY",     "String", sortbyd );
        con.addData( "PAGENUMBER", "String", strCurrentPage );
        con.addData( "PAGESIZE",   "String", strPageSize );
        bolnSuccess = con.executeService( strContainerName, strClassName, "findUserProfile" );        
        if( bolnSuccess ) {
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
<script language="JavaScript" src="js/label/lb_user_profile.js"></script>
<script language="JavaScript" src="js/function/page-utils.js"></script>
<script language="JavaScript" src="js/function/table-utils.js"></script>
<script language="JavaScript" src="js/util.js"></script>
<script language="JavaScript" src="js/constant.js"></script>
<script language="JavaScript" type="text/javascript">
<!--
var per_page = '<%=strPageSize%>';

$(document).ready(window_onload);

function window_onload() {
    set_label();
    set_init();
    set_field_table();
    set_background('screen_div');
    set_message();
}

function set_label(){
    $("#lb_user_id").text(lbl_user_id);
    $("#lb_user_name").text(lbl_user_name);
    $("#lb_org").text(lbl_org);
    $("#lb_status").text(lbl_status);
    $("#lb_group_status").text(lbl_group_status);
    $("#lb_total_record").text(lbl_total_record);
    $("#lb_record").text(lbl_record);
    $("#lb_group_remark").text(lbl_group_remark);
}

function set_init(){	
    totalPage = '<%=strTotalPage%>';
    mode      = '<%=strMode%>';
    $("#PAGE_SIZE").val(per_page);
}

function set_message(){
    
<%  if (!strmsg.equals("")) {  %>
    <%=strmsg%>
<%  }   %>
}

function concatAllUserId(){
    var strConUserId  = "";
    var strFullUserId = "";
    var strUserId     = "hidUserId_";
    var obj_chkArr    = "";
    var strchkBox     = "chkAllCheck";
    var obj_chkBox    = "";
    var length        = $("#intSeqn").val();

    for( var i=1; i<length; i++ ) {
        obj_chkBox = document.getElementById(strchkBox+i);
        if( obj_chkBox.checked ) {
            strFullUserId = "";
            strFullUserId = strUserId + i;
            obj_chkArr    = document.getElementById(strFullUserId);
            strConUserId  += obj_chkArr.value + ",";
        }
    }
    if( strConUserId.length > 0 ){
            strConUserId = strConUserId.substr( 0, strConUserId.lastIndexOf(",") );
    }
    $("#ConUserId").val(strConUserId);
}

function chkbxClickValue() {
    $("chkAllCheck").prop('checked', false);
}

function getValueRole() {
    var optSelected = $("#optUserRole option:selected").index();
    var optValue    = $("#optUserRole").val();

    if( optSelected == 0 ) {
        $("#hidUserRole").val("");
    }else {
        $("#hidUserRole").val(optValue);
    }
}

function chkAllUserId(){
    var oEle = form1.elements;
    var len = oEle.length;
    if( $("#chkAllCheck").prop('checked') ) {
        for ( var i=0; i<len; i++ ){
            if ( oEle[i].type == "checkbox"){
                oEle[i].checked = true;
            }
        }
    }else {
            for ( var i=0; i<len; i++ ){
            if ( oEle[i].type == "checkbox"){
                oEle[i].checked = false;
            }
        }
    }
}

function buttonClick( lv_strMethod, lv_strValue ){
    switch( lv_strMethod ){
        case "add" :
            formadd.action            = "user_profile2.jsp";
            formadd.MODE.value        = "pInsert";
            formadd.USER_ID_KEY.value = "";
            formadd.submit();
            break;
        case "delete" :
            if( !confirm( lc_confirm_delete ) ){
                    return;
            }
            form1.USER_ID_DEL.value 	= lv_strValue.getAttribute("USER_ID");
            form1.USER_STATUS_DEL.value = lv_strValue.getAttribute("USER_STATUS");
            form1.USER_NAME_DEL.value 	= lv_strValue.getAttribute("USER_NAME");
            form1.USER_SNAME_DEL.value 	= lv_strValue.getAttribute("USER_SNAME");
            form1.action     = "user_profile1.jsp";
            form1.MODE.value = "DELETE";
            form1.submit();
            break;
        case "pEdit" :
            formadd.action            = "user_profile2.jsp";
            formadd.MODE.value        = "pEdit";
            formadd.USER_ID_KEY.value = lv_strValue.getAttribute("USER_ID");
            formadd.submit();
            break;
        case "role" :
            formadd.action               = "user_profile4.jsp";
            formadd.MODE.value           = form1.MODE.value;
            formadd.USER_ID_KEY.value    = lv_strValue.getAttribute("USER_ID");
            formadd.USER_FNAME_KEY.value = lv_strValue.getAttribute("USER_FNAME");
            formadd.submit();
            break;
        case "search" :
            form1.method = "post";
            form1.action = "user_profile3.jsp";
            form1.submit();
            break;
    }
}

//-->
</script>
<link href="css/edas.css" type="text/css" rel="stylesheet">
</head>
<body onLoad="MM_preloadImages('images/btt_commitrights_over.gif','images/btt_cancelright_over.gif','images/btt_search_over.gif','images/btt_add_over.gif');" onresize="set_background('screen_div')">
<form id="form1" name="form1" method="post" action="" >
<table width="100%" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
    <tr><td valign="top">
        <div id="screen_div" >
            <table width="800" height="100%" border="0" cellpadding="0" cellspacing="0">
                <tr>
                    <td valign="top">
                        <table width="800" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td height="25" class="label_header01" >&nbsp;&nbsp;<%=screenname%></td>
                            </tr>
                            <tr> 
                                <td><div align="center"> 
                                    <table width="100%" border="0" cellpadding="0" cellspacing="0">
<%
    intclm = 3;

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
                                        <tr>
                                            <td colspan="10"><BR></td>
                                        </tr>
                                        <tr class="hd_table"> 
                                            <td width="10"><img src="images/hd_tb_01.gif" width="10" height="28"></td>
                                            <td width="90" align="center">
                                                <div align="left"><span id="lb_user_id"></span><%=sortimg[1]%></div>
                                            </td>
                                            <td width="130" align="center">
                                                <div align="left"><span id="lb_user_name"></span><%=sortimg[2]%></div>
                                            </td>
                                            <td align="center">
                                                <div align="left"><span id="lb_org"></span><%=sortimg[3]%></div>
                                            </td>
                                            <td width="70" align="center">
                                                <div align="center"><span id="lb_status"></span></div>
                                            </td>
                                            <td width="70" align="center">
                                                <div align="center"><span id="lb_group_status"></span></div>
                                            </td>
                                            <td width="55" align="center"><div align="center">&nbsp;</div></td>
                                            <td width="55" align="center"><div align="center">&nbsp;</div></td>
                                            <td width="110" align="center"><div align="center">&nbsp;</div></td>
                                            <td width="10" align="right"><img src="images/hd_tb_04.gif" width="10" height="28"></td>
                                        </tr>
<%
    if( (bolnSuccess) ) {
        intSeq = 1;
        idx    = 1;
        while( con.nextRecordElement() ){
            strFieldUserIdData     = con.getColumn( "USER_ID" );
            strFieldTitleNameData  = con.getColumn( "TITLE_NAME" );
            strFieldUserNameData   = con.getColumn( "USER_NAME" );
            strFieldUserSnameData  = con.getColumn( "USER_SNAME" );
            strFieldOrgNameData    = con.getColumn( "ORG_NAME" );
            strFieldStatusData 	   = con.getColumn( "USER_STATUS" );
            strFieldStatusNameData = con.getColumn( "USER_STATUS_NAME" );
            strFieldSecFlagData    = con.getColumn( "SECURITY_FLAG" );
            strFullNameData        = strFieldTitleNameData + strFieldUserNameData + " " + strFieldUserSnameData;    
            
            strbttEdit   = "<img src=\"images/btt_edit2.gif\" name=\"EDIT" + intSeq + "\"  width=\"52\" height=\"18\" border=\"0\">";
            strbttDelete = "<img src=\"images/btt_delete.gif\" name=\"Delete" + intSeq + "\"  width=\"52\" height=\"18\" border=\"0\">";
            strbttRole   = "<img src=\"images/btt_manage.gif\" name=\"role" + intSeq + "\"  height=\"18\" border=\"0\">";
            
            strScript    = "USER_ID=\"" + strFieldUserIdData + "\" TITLE_NAME=\"" + strFieldTitleNameData + "\" ";
            strScript    += "USER_NAME=\"" + strFieldUserNameData + "\" USER_SNAME=\"" + strFieldUserSnameData + "\" USER_FNAME=\"" + strFullNameData + "\" ";
            strScript    += "ORG_NAME=\"" + strFieldOrgNameData + "\" USER_STATUS=\"" + strFieldStatusData + "\" USER_STATUS_NAME=\"" + strFieldStatusNameData + "\" ";

            idx = 2 - (intSeq % 2);
%>                      
                                        <tr class="table_data<%=idx%>">
                                            <td width="10">&nbsp;</td>
                                            <td width="90"><div align="left"><%=strFieldUserIdData %></div></td>
                                            <td width="130"><div align="left"><%=strFullNameData %></div></td>
                                            <td ><div align="left"><%=strFieldOrgNameData %></div></td>
                                            <td width="70"><div align="center"><%=strFieldStatusNameData %></div></td>
                                            <td width="70"><div align="center"><%=strFieldSecFlagData %></div></td>
                                            <td width="55" align="center">
                                                <a href="#" onclick= "buttonClick('pEdit',this)"<%=strScript%> onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('EDIT<%=intSeq %>','','images/btt_edit2_over.gif',1)"><%=strbttEdit%></a>
                                            </td>
                                            <td width="55" align="center">
                                                <a href="#" onclick= "buttonClick('delete',this)"<%=strScript%> onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Delete<%=intSeq %>','','images/btt_delete_over.gif',1)"><%=strbttDelete%></a>
                                            </td>
                                            <td width="110" align="center">
                                            <%	if(strFieldSecFlagData.equals("I")){ %>
                                                <a href="#" onclick= "buttonClick('role',this)"<%=strScript%> onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('role<%=intSeq %>','','images/btt_manage_over.gif',1)"><%=strbttRole%></a>
                                            <%	} %>
                                            </td>
                                            <td width="10">&nbsp;</td>
                                        </tr>
<%
            intSeq++;
        }
    }else{
%>        
                        <tr class="table_data1"> 
                            <td colspan="10" align="center"><%=con.getRemoteErrorMesage()%></td>
                        </tr>
<%
    }
 %>                      
                                    </table>
                                    <table width="100%" height="28" border="0" align="center" cellpadding="0" cellspacing="0">
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
                                                <span id="lb_from"></span>
                                            </td>
                                        </tr>
                                        <tr class="label_bold2">
                                            <td colspan="6"><div align="center"><span id="lb_group_remark"></span></div></td>
                                        </tr>
                                    </table>
                                    <table width="100%" border="0" cellpadding="0" cellspacing="0" class="label_bold2">
                                        <tr>
                                            <td height="10"></td>
                                            <td colspan="3" align="right">
	              				<%=lb_page_per_size %> : 
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
                                    <a href="#" onclick= "buttonClick('add')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('add','','images/btt_add_over.gif',1)">
                                        <img src="images/btt_add.gif" id="add" name="add" width="67" height="22" border="0"></a>
                                    <a href="#" onclick= "buttonClick('search')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('search','','images/btt_search_over.gif',1)">
                                        <img src="images/btt_search.gif" id="search" name="search" width="67" height="22" border="0"></a>
                                    </p>
                                </div></td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </div>
    </td></tr>
</table>
<input type="hidden" id="MODE"       name="MODE"       value="<%=strMode%>">
<input type="hidden" id="screenname" name="screenname" value="<%=screenname%>">
<input type="hidden" id="sortby"     name="sortby"     value="<%=sortby%>">
<input type="hidden" id="sortfield"  name="sortfield"  value="<%=sortfield%>">

<input type="hidden" id="USER_ID_DEL"     name="USER_ID_DEL"  	 value="">
<input type="hidden" id="USER_STATUS_DEL" name="USER_STATUS_DEL" value="">
<input type="hidden" id="USER_TITLE_DEL"  name="USER_TITLE_DEL"  value="">
<input type="hidden" id="USER_NAME_DEL"   name="USER_NAME_DEL"   value="">
<input type="hidden" id="USER_SNAME_DEL"  name="USER_SNAME_DEL"  value="">

<input type="hidden" id="USER_ID_SEARCH"     name="USER_ID_SEARCH"     value="<%=strFieldUserIdSearch %>">
<input type="hidden" id="USER_NAME_SEARCH"   name="USER_NAME_SEARCH"   value="<%=strFieldUserNameSearch %>">
<input type="hidden" id="USER_SNAME_SEARCH"  name="USER_SNAME_SEARCH"  value="<%=strFieldUserSnameSearch %>">
<input type="hidden" id="USER_LEVEL_SEARCH"  name="USER_LEVEL_SEARCH"  value="<%=strFieldUserLevelSearch %>">
<input type="hidden" id="ORG_CODE_SEARCH"    name="ORG_CODE_SEARCH"    value="<%=strFieldOrgCodeSearch %>">
<input type="hidden" id="USER_STATUS_SEARCH" name="USER_STATUS_SEARCH" value="<%=strFieldUserStatusSearch %>">
</form>

<form name="formadd" method="post" action="" target="_self">
	<input type="hidden" id="MODE"           name="MODE"           value="">
	<input type="hidden" id="USER_ID_KEY"    name="USER_ID_KEY"    value="">
	<input type="hidden" id="USER_FNAME_KEY" name="USER_FNAME_KEY" value="">
	<input type="hidden" id="screenname"     name="screenname"     value="<%=screenname%>">
	
	<input type="hidden" id="mode_parent"         name="mode_parent"         value="<%=strMode%>">
	<input type="hidden" id="current_page_parent" name="current_page_parent" value="<%=strCurrentPage%>">
	<input type="hidden" id="sortby_parent"       name="sortby_parent"       value="<%=sortby%>">
	<input type="hidden" id="sortfield_parent"    name="sortfield_parent"    value="<%=sortfield%>">
	
	<input type="hidden" id="USER_ID_SEARCH"     name="USER_ID_SEARCH"     value="<%=strFieldUserIdSearch %>">
	<input type="hidden" id="USER_NAME_SEARCH"   name="USER_NAME_SEARCH"   value="<%=strFieldUserNameSearch %>">
	<input type="hidden" id="USER_SNAME_SEARCH"  name="USER_SNAME_SEARCH"  value="<%=strFieldUserSnameSearch %>">
	<input type="hidden" id="USER_LEVEL_SEARCH"  name="USER_LEVEL_SEARCH"  value="<%=strFieldUserLevelSearch %>">
	<input type="hidden" id="ORG_CODE_SEARCH"    name="ORG_CODE_SEARCH"    value="<%=strFieldOrgCodeSearch %>">
	<input type="hidden" id="USER_STATUS_SEARCH" name="USER_STATUS_SEARCH" value="<%=strFieldUserStatusSearch %>">
</form>
</body>
</html>