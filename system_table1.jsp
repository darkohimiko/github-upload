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
    String screenname   = getField( request.getParameter("screenname") );

    String strCurrentPage = checkNull(request.getParameter( "CURRENT_PAGE" ));
    String strPageSize    = checkNull(request.getParameter( "PAGE_SIZE" ));
    
    if( strCurrentPage.equals("") ) {
        strCurrentPage = "1";
    }
    if( strPageSize.equals("")  ) {
        strPageSize = "10";
    }
	
    String strCurrentDate = "";
    String strVersionLang = ImageConfUtil.getVersionLang();

    if( strVersionLang.equals("thai") ) {
            strCurrentDate = getServerDateThai();
    }else {
            strCurrentDate = getServerDateEng();
    }
    
    String  strmsg          = "";
    boolean bolnSuccess     = true;
    boolean searchmod       = false;
    String  strErrorCode    = null;
    
    String strTableLevelSearch = checkNull(request.getParameter( "TABLE_LEVEL_SEARCH" ));
    String strTableCodeSearch  = checkNull(request.getParameter( "TABLE_CODE_SEARCH" ));
    String strTableNameSearch  = getField(request.getParameter( "TABLE_NAME_SEARCH" ));

    String strTableCodeDel    = checkNull(request.getParameter( "TABLE_CODE_DEL" ));
    String strTableNameDel    = checkNull(request.getParameter( "TABLE_NAME_DEL" ));    
    String strNotDropFlagData = checkNull(request.getParameter( "NOT_DROP_FLAG_TEMP" ));
    
    String  strTableCodeData       = "";
    String  strTableNameData       = "";
    String  strTableLevelData      = "";
    String  strTableLevel1Data     = "";
    String  strTableLevel1NameData = "";
    String  strTableLevel2Data     = "";
    String  strTableLevel2NameData = "";
    
    String  strScript          = "";
    String  strbttInsert       = "";
    String  strbttEdit         = "";
    String  strbttDelete       = "";
    String  strTotalPage       = "1";
    String  strTotalSize       = "0";
    String  sortby             = "";
    String  sortbyd            = "";
    String  sortfield          = "";
    
    sortby    = checkNull( request.getParameter("sortby") );                          
    sortfield = checkNull( request.getParameter("sortfield") );
    
    int i         = 0;
    int intfield  = 0;
    int intclm    = 0;

    if( strMode == null || strMode.equals("")){
        strMode = "SEARCH";
    }
    
    if( strMode.equals("DELETE") ) {
    	if( strNotDropFlagData.equals("N") ) {
            con.addData( "TABLE_CODE", 	 "String", strTableCodeDel.toUpperCase() );
            con.addData( "DESC",  		 "String", strTableCodeDel.toUpperCase() + "-" + strTableNameDel );
            con.addData( "USER_ID",  	 "String", strUserId );
            con.addData( "ACTION_FLAG",  "String", "DT" );
            con.addData( "CURRENT_DATE", "String", strCurrentDate);

            bolnSuccess = con.executeService( strContainerName, strClassName, "deleteZoomTableManager" );
            if( !bolnSuccess ){
                strErrorCode    = con.getRemoteErrorCode();

                if(strErrorCode.equals("ERR000T2")){
                    strmsg  = "showMsg(0,0,\" " + lc_cannot_delete_other_used_table + "\")";
                }else if(strErrorCode.equals("ERR000T1")){
                    strmsg  = "showMsg(0,0,\" " + lc_cannot_delete_table_had_used + "\")";
                }else{
                    strmsg  = "showMsg(0,0,\" " + lc_cannot_delete_system_table + "\")";
                }
                strMode = "SEARCH";
            }else{
                strmsg  = "showMsg(0,0,\" " + lc_delete_system_table_successfull + "\")";
                strMode = "SEARCH";
            }
        }else {
            strmsg  = "showMsg(0,0,\" " + lc_cannot_delete_system_table + "\")";
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
        
    	con.addData( "SORTFIELD",  "String", sortfield );
        con.addData( "SORTBY",     "String", sortbyd );
        con.addData( "PAGENUMBER", "String", strCurrentPage );
        con.addData( "PAGESIZE",   "String", strPageSize );
        
        bolnSuccess = con.executeService( strContainerName, strClassName, "findZoomTableManagerOnload" );
        
        if( !bolnSuccess ) {
            strErrorCode    = con.getRemoteErrorCode();
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
    	if( !strTableCodeSearch.equals("") ) {
            con.addData( "TABLE_CODE",  "String", strTableCodeSearch);
    	}
    	if( !strTableNameSearch.equals("") ) {
            con.addData( "TABLE_NAME",  "String", strTableNameSearch);
    	}
    	if( !strTableLevelSearch.equals("") ) {
            con.addData( "TABLE_LEVEL", "String", strTableLevelSearch);
    	}
    	if( sortfield.equals("") ) {
            sortfield = "0";
        }
        if( sortby.equals("") ) {
            sortby = "ASC";
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
        
        bolnSuccess = con.executeService( strContainerName, strClassName, "findZoomTableManager" );
        
        if( !bolnSuccess ) {
            strErrorCode    = con.getRemoteErrorCode();
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
<script language="JavaScript" src="js/label/lb_system_table.js"></script>
<script language="JavaScript" src="js/function/page-utils.js"></script>
<script language="JavaScript" src="js/function/table-utils.js"></script>
<script language="JavaScript" src="js/util.js"></script>
<script language="JavaScript" src="js/constant.js"></script>
<script language="JavaScript" type="text/javascript">
<!--

var per_page  = '<%=strPageSize%>';

$(document).ready(window_onload);

function window_onload() {
    set_label();
    set_background("screen_div");
    set_field_table();
    set_init();
    set_message();
}    

function set_init(){
    totalPage = '<%=strTotalPage%>';
    mode      = '<%=strMode%>';
    $("#PAGE_SIZE").val(per_page);        
}

function set_label(){
    $("#lb_table_level").text(lbl_table_level);
    $("#lb_table_code").text(lbl_table_code);
    $("#lb_table_name").text(lbl_table_name);
    $("#lb_total_record").text(lbl_total_record);
    $("#lb_record").text(lbl_record);
    $("#lb_page_per_size").text(lbl_page_per_size);
}

function set_message(){
    
<%  if (!strmsg.equals("")) {  %>
    <%=strmsg%>
<%  }   %>
}

function buttonClick( lv_strMethod, lv_strValue ){
    switch( lv_strMethod ){
        case "pInsert" :
            $("#formadd #TABLE_CODE_KEY").val("");
            $("#formadd #TABLE_NAME_KEY").val("");
            $("#formadd #TABLE_LEVEL_KEY").val("");
            $("#formadd #TABLE_LEVEL1_KEY").val("");
            $("#formadd #TABLE_LEVEL2_KEY").val("");
            $("#formadd #NOT_DROP_FLAG_KEY").val("");
            $("#formadd #MODE").val("pInsert");
            $("#formadd").attr('action', 'system_table2.jsp');
            $("#formadd").submit();
            break;
        case "searchTable" :
            $("#form1").attr('action','system_table3.jsp');
            $("#form1").submit();
            break;
        case "pEdit" :
            $("#formadd #TABLE_CODE_KEY").val(lv_strValue.getAttribute("TABLE_CODE"));
            $("#formadd #TABLE_NAME_KEY").val(lv_strValue.getAttribute("TABLE_NAME"));
            $("#formadd #TABLE_LEVEL_KEY").val(lv_strValue.getAttribute("TABLE_LEVEL"));
            $("#formadd #TABLE_LEVEL1_KEY").val(lv_strValue.getAttribute("TABLE_LEVEL1"));
            $("#formadd #TABLE_LEVEL2_KEY").val(lv_strValue.getAttribute("TABLE_LEVEL2"));
            $("#formadd #NOT_DROP_FLAG_KEY").val(lv_strValue.getAttribute("NOT_DROP_FLAG"));
            $("#formadd #MODE").val("pEdit");
            $("#formadd").attr('action', 'system_table2.jsp');
            $("#formadd").submit();
            break;
        case "DELETE" :
            if( !confirm( lc_confirm_delete + " \"" + lv_strValue.getAttribute("TABLE_CODE") + "\"") ){
                    return;
            }
            $("#form1 #MODE").val(lv_strMethod);
            $("#form1 #TABLE_CODE_DEL").val(lv_strValue.getAttribute("TABLE_CODE"));
            $("#form1 #TABLE_NAME_DEL").val(lv_strValue.getAttribute("TABLE_NAME"));
            $("#form1 #NOT_DROP_FLAG_TEMP").val(lv_strValue.getAttribute("NOT_DROP_FLAG"));
            $("#formadd").attr('action', 'system_table1.jsp');
            $("#form1").submit();
            break;
        case "InsertData" :
            $("#formadd #TABLE_CODE_KEY").val(lv_strValue.getAttribute("TABLE_CODE"));
            $("#formadd #TABLE_NAME_KEY").val(lv_strValue.getAttribute("TABLE_NAME"));
            $("#formadd #TABLE_LEVEL_KEY").val(lv_strValue.getAttribute("TABLE_LEVEL"));
            $("#formadd #TABLE_LEVEL1_KEY").val(lv_strValue.getAttribute("TABLE_LEVEL1"));
            $("#formadd #TABLE_LEVEL1_NAME_KEY").val(lv_strValue.getAttribute("TABLE_LEVEL1_NAME"));
            $("#formadd #TABLE_LEVEL2_KEY").val(lv_strValue.getAttribute("TABLE_LEVEL2"));
            $("#formadd #TABLE_LEVEL2_NAME_KEY").val(lv_strValue.getAttribute("TABLE_LEVEL2_NAME"));
            $("#formadd #NOT_DROP_FLAG_KEY").val("");
            $("#formadd #MODE").val("SEARCH");
            $("#formadd").attr('action', 'system_table4.jsp');
            $("#formadd").submit();
            break;
    }
}

//-->
</script>
<link href="css/edas.css" type="text/css" rel="stylesheet">
</head>
<body onLoad="MM_preloadImages('images/btt_newtb_over.gif','images/btt_searchtb_over.gif','images/btt_export_over.gif','images/btt_edit2_over.gif','images/btt_delete_over.gif','images/btt_inputs_over.gif');" onresize="set_background('screen_div')">
<form id="form1" name="form1" method="post" action="system_table1.jsp" >
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
                <td height="10">&nbsp;</td>
            </tr>
            <tr> 
                <td><div align="left"> 
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
                        <tr class="hd_table"> 
                            <td width="10"><img src="images/hd_tb_01.gif" width="10" ></td>
                            <td width="155" align="center">
                                <div align="left"><span id="lb_table_code"></span><%=sortimg[1]%></div>
                            </td>
                            <td width="*" align="center">
                                <div align="left"><span id="lb_table_name"></span><%=sortimg[2]%></div>
                            </td>
                            <td width="110" align="center">
                                <div align="center"><span id="lb_table_level"></span><%=sortimg[3]%></div>
                            </td>
                            <td width="70">&nbsp;</td>
                            <td width="70">&nbsp;</td>
                            <td width="75">&nbsp;</td>
                            <td width="10" align="right"><img src="images/hd_tb_04.gif" width="10" ></td>
                        </tr>
<%
    if( (bolnSuccess) ) {
        int intSeq = 1;
        int idx = 0;
        while( con.nextRecordElement() ){
            strTableCodeData   = con.getColumn( "TABLE_CODE" );
            strTableNameData   = con.getColumn( "TABLE_NAME" );
            strTableLevelData  = con.getColumn( "TABLE_LEVEL" );
            strNotDropFlagData = con.getColumn( "NOT_DROP_FLAG" );
            strTableLevel1Data = con.getColumn( "TABLE_LEVEL1" );
            strTableLevel2Data = con.getColumn( "TABLE_LEVEL2" );
            
            if( !strTableLevel1Data.equals("") ) {
    	        con1.addData( "TABLE_CODE",  "String", strTableLevel1Data);
    	        bolnSuccess = con1.executeService( strContainerName , strClassName , "getTableLevelName" );
    	        strTableLevel1NameData = con1.getHeader( "TABLE_NAME" );
            }else{
                strTableLevel1NameData = "";
            }
            
            if( !strTableLevel2Data.equals("") ) {
    	        con1.addData( "TABLE_CODE",  "String", strTableLevel2Data);
    	        bolnSuccess = con1.executeService( strContainerName , strClassName , "getTableLevelName" );
    	        strTableLevel2NameData = con1.getHeader( "TABLE_NAME" );
            }else{
                strTableLevel2NameData = "";
            }
            
            strbttEdit   = "<img src=\"images/btt_edit2.gif\" name=\"EDIT" + intSeq + "\"  width=\"52\" height=\"18\" border=\"0\">";
            strbttDelete = "<img src=\"images/btt_delete.gif\" name=\"Delete" + intSeq + "\"  width=\"52\" height=\"18\" border=\"0\">";
            strbttInsert = "<img src=\"images/btt_inputs.gif\" name=\"Insert" + intSeq + "\" height=\"18\" border=\"0\">";
            
            strScript = "TABLE_CODE=\"" + strTableCodeData + "\" TABLE_NAME=\"" + strTableNameData + "\" TABLE_LEVEL=\"" + strTableLevelData + "\" ";
            strScript += "NOT_DROP_FLAG=\"" + strNotDropFlagData + "\" TABLE_LEVEL1=\"" + strTableLevel1Data + "\" TABLE_LEVEL2=\"" + strTableLevel2Data + "\" ";
            strScript += "TABLE_LEVEL1_NAME=\"" + strTableLevel1NameData + "\" TABLE_LEVEL2_NAME=\"" + strTableLevel2NameData + "\"";

            idx = 2 - (intSeq % 2);
%>
                        <tr class="table_data<%=idx%>"> 
                            <td width="10">&nbsp;</td>
                            <td width="155"><div align="left"><%=strTableCodeData %></div></td>
                            <td width="*"><div align="left"><%=strTableNameData %></div></td>
                            <td width="110"><div align="center"><%=strTableLevelData %></div></td>
                            <td colspan="3" align="center">
                                <a href="#" onclick= "buttonClick('pEdit',this)"<%=strScript%> onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('EDIT<%=intSeq %>','','images/btt_edit2_over.gif',1)"><%=strbttEdit%></a>&nbsp;
                                <a href="#" onclick= "buttonClick('DELETE',this)"<%=strScript%> onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Delete<%=intSeq %>','','images/btt_delete_over.gif',1)"><%=strbttDelete%></a>&nbsp;
                                <a href="#" onclick= "buttonClick('InsertData',this)"<%=strScript%> onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Insert<%=intSeq %>','','images/btt_inputs_over.gif',1)"><%=strbttInsert%></a>
                            </td>
                            <td width="10">&nbsp;</td>
                        </tr>
<%
            intSeq++;
        }
     }else{
%>        
                        <tr class="table_data1"> 
                            <td colspan="8" align="center"><%=con.getRemoteErrorMesage()%></td>
                        </tr>
<%
    }
 %>                      
                    </table>
                    <table width="100%" height="28" border="0" align="left" cellpadding="0" cellspacing="0">
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
                    </table>
                </div></td>
            </tr>
            <tr>
                <td><div align="left"> 
                    <table width="100%" border="0" cellpadding="0" cellspacing="0" class="label_bold2">
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
                    <table width="696" align="center" border="0" cellpadding="0" cellspacing="0" class="label_bold2">
                        <tr>
                            <td align="center">
                                <p>
                                <a href="#" onclick= "buttonClick('pInsert')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('newtb','','images/btt_newtb_over.gif',1)">
                                    <img src="images/btt_newtb.gif" name="newtb" border="0"></a>
                                <a href="#" onclick= "buttonClick('searchTable')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('searchtb','','images/btt_searchtb_over.gif',1)">
                                    <img src="images/btt_searchtb.gif" name="searchtb" border="0"></a>
                                </p>
                            </td>
                        </tr>
                    </table>
                </div></td>
            </tr>
        </table>
        <input type="hidden" id="MODE"               name="MODE"               value="<%=strMode%>">
        <input type="hidden" id="TABLE_CODE_DEL"     name="TABLE_CODE_DEL"     value="">
        <input type="hidden" id="TABLE_NAME_DEL"     name="TABLE_NAME_DEL"     value="">
        <input type="hidden" id="NOT_DROP_FLAG_TEMP" name="NOT_DROP_FLAG_TEMP" value="<%=strNotDropFlagData%>">
        <input type="hidden" id="TABLE_LEVEL_SEARCH" name="TABLE_LEVEL_SEARCH" value="<%=strTableLevelSearch%>">
        <input type="hidden" id="TABLE_CODE_SEARCH"  name="TABLE_CODE_SEARCH"  value="<%=strTableCodeSearch%>">
        <input type="hidden" id="TABLE_NAME_SEARCH"  name="TABLE_NAME_SEARCH"  value="<%=strTableNameSearch%>">
        <input type="hidden" id="screenname"         name="screenname"         value="<%=screenname%>">
        <input type="hidden" id="sortby"             name="sortby"             value="<%=sortby%>">
        <input type="hidden" id="sortfield"          name="sortfield"          value="<%=sortfield%>">        
    </td>
    </tr>
</table>
    </div>
    </td></tr>
</table>
</form>
<form id="formadd" name="formadd" action="" method="post" target="_self">
<input type="hidden" id="MODE"                  name="MODE"                  value="">
<input type="hidden" id="OLD_MODE"		name="OLD_MODE"              value="<%=strMode%>">
<input type="hidden" id="TABLE_CODE_KEY"        name="TABLE_CODE_KEY"        value="">
<input type="hidden" id="TABLE_NAME_KEY"        name="TABLE_NAME_KEY"        value="">
<input type="hidden" id="TABLE_LEVEL_KEY"       name="TABLE_LEVEL_KEY"       value="">
<input type="hidden" id="TABLE_LEVEL1_KEY"      name="TABLE_LEVEL1_KEY"      value="">
<input type="hidden" id="TABLE_LEVEL1_NAME_KEY" name="TABLE_LEVEL1_NAME_KEY" value="">
<input type="hidden" id="TABLE_LEVEL2_KEY"      name="TABLE_LEVEL2_KEY"      value="">
<input type="hidden" id="TABLE_LEVEL2_NAME_KEY" name="TABLE_LEVEL2_NAME_KEY" value="">
<input type="hidden" id="NOT_DROP_FLAG_KEY"     name="NOT_DROP_FLAG_KEY"     value="">
<input type="hidden" id="screenname"            name="screenname"            value="<%=screenname%>">
<input type="hidden" id="TABLE_LEVEL_SEARCH"    name="TABLE_LEVEL_SEARCH"    value="<%=strTableLevelSearch%>">
<input type="hidden" id="TABLE_CODE_SEARCH"     name="TABLE_CODE_SEARCH"     value="<%=strTableCodeSearch%>">
<input type="hidden" id="TABLE_NAME_SEARCH"     name="TABLE_NAME_SEARCH"     value="<%=strTableNameSearch%>">

<input type="hidden" id="mode_parent"         name="mode_parent"         value="<%=strMode%>">
<input type="hidden" id="current_page_parent" name="current_page_parent" value="<%=strCurrentPage%>">
<input type="hidden" id="page_size_parent"    name="page_size_parent" value="<%=strPageSize%>">
<input type="hidden" id="sortby_parent"       name="sortby_parent"       value="<%=sortby%>">
<input type="hidden" id="sortfield_parent"    name="sortfield_parent"    value="<%=sortfield%>">
</form>
</body>
</html>