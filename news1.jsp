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
		
    UserInfo  userInfo  = (UserInfo)session.getAttribute( "USER_INFO" );
    String    strUserId = userInfo.getUserId();

    String screenname   = getField(request.getParameter("screenname"));
    String strClassName = "NEWS_MANAGER";
    String strMode      = getField(request.getParameter("MODE"));

    String strCurrentPage = request.getParameter( "CURRENT_PAGE" );
    String strPageSize    = request.getParameter( "PAGE_SIZE" );
	
    if( strCurrentPage == null || Integer.parseInt( strCurrentPage ) == 0 ) {
        strCurrentPage = "1";
    }
    if( strPageSize == null || Integer.parseInt( strPageSize ) == 0 ) {
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
    
    String strHeaderSearch   = getField(request.getParameter( "HEADER_SEARCH" ));
    String strSubjectSearch  = getField(request.getParameter( "SUBJECT_SEARCH" ));
    String strSourceSearch   = getField(request.getParameter( "SOURCE_SEARCH" ));
    String strNewsDateSearch = getField(request.getParameter( "NEWS_DATE_SEARCH" ));

    String  strNewsIdData = getField(request.getParameter( "NEWS_ID_TEMP" ));
    String  strHeaderData = getField(request.getParameter( "HEADER_TEMP" ));
    
    String  strScript    = "";
    String  strbttEdit   = "";
    String  strbttDelete = "";
    String  strTotalPage = "1";
    String  strTotalSize = "0";
    String  sortby       = "";
    String  sortbyd      = "";
    String  sortfield    = "";
    
    sortby    = getField( request.getParameter("sortby") );                          
    sortfield = getField( request.getParameter("sortfield") );
    
    int i         = 0;
    int intfield  = 0;
    int intclm    = 0;

    if( strMode == null || strMode.equals("")){
        strMode = "SEARCH";
    }
    
    if( strMode.equals("DELETE") ) {
    	con.addData( "NEWS_ID", "String", strNewsIdData );
    	
    	con.addData( "DESC",  		 "String", strNewsIdData + "-" + strHeaderData );
     	con.addData( "USER_ID",  	 "String", strUserId );
        con.addData( "ACTION_FLAG",  "String", "DN" );
        con.addData( "CURRENT_DATE", "String", strCurrentDate);
		
        bolnSuccess = con.executeService( strContainerName, strClassName, "deleteNewsManager" );
        if( !bolnSuccess ){
            strmsg  = "showMsg(0,0,\" " + lc_can_not_delete_news + "\")";
            strMode = "SEARCH";
        }else{
            strmsg  = "showMsg(0,0,\" " + lc_delete_news_successfull + "\")";
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
    	con.addData( "SORT_FIELD", "String", sortfield );
        con.addData( "SORT_BY",    "String", sortbyd );
        con.addData( "PAGENUMBER", "String", strCurrentPage );
        con.addData( "PAGESIZE",   "String", strPageSize );
        
        bolnSuccess = con.executeService( strContainerName, strClassName, "selectAllNewsManager" );
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
        
    	if( !strHeaderSearch.equals("") ) {
    		con.addData( "HEADER", "String", strHeaderSearch);
    	}
    	if( !strSubjectSearch.equals("") ) {
        	con.addData( "SUBJECT", "String", strSubjectSearch);
    	}
    	if( !strSourceSearch.equals("") ) {
        	con.addData( "SOURCE", "String", strSourceSearch);
    	}
    	if( !strNewsDateSearch.equals("") ) {
        	con.addData( "NEWS_DATE", "String", strNewsDateSearch);
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
    	con.addData( "SORT_FIELD", "String", sortfield );
        con.addData( "SORT_BY",    "String", sortbyd );
        con.addData( "PAGENUMBER", "String", strCurrentPage );
        con.addData( "PAGESIZE",   "String", strPageSize );
        
        bolnSuccess = con.executeService( strContainerName, strClassName, "findNewsManager" );
        if( bolnSuccess ) {
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
<script language="JavaScript" src="js/label/lb_news.js"></script>
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
    set_background("screen_div");
    set_field_table();
    set_init();
    set_message();  
}

function set_label(){
    $("#lb_code").text(lbl_code);
    $("#lb_news_header").text(lbl_news_header);
    $("#lb_total_record").text(lbl_total_record);
    $("#lb_record").text(lbl_record);
}

function set_init(){
    totalPage = '<%=strTotalPage%>';
    mode      = '<%=strMode%>';
    $("#form1 #PAGE_SIZE").val(per_page);
}

function set_message(){
    
<%  if (!strmsg.equals("")) {  %>
    <%=strmsg%>
<%  }   %>
}

function buttonClick( lv_strMethod, lv_strValue ){
    switch( lv_strMethod ){
        case "pInsert" :
            $("#formadd").attr('action', "news2.jsp");
            $("#formadd #NEWS_ID_KEY").val("");
            $("#formadd #MODE").val("pInsert");
            $("#formadd").submit();
            break;
        case "search" :
            $("#form1").attr('action', "news3.jsp");
            $("#form1").submit();
            break;
        case "pEdit" :
            $("#formadd").attr('action', "news2.jsp");
            $("#formadd #NEWS_ID_KEY").val(lv_strValue.getAttribute("NEWS_ID"));
            $("#formadd #MODE").val("pEdit");
            $("#formadd").submit();
            break;
        case "DELETE" :
            if( !confirm( lc_confirm_delete ) ){
                return;
            }
            $("#form1 #MODE").val("DELETE");
            $("#form1").attr('action' ,"news1.jsp");
            $("#form1 #NEWS_ID_TEMP").val(lv_strValue.getAttribute("NEWS_ID"));
            $("#form1 #HEADER_TEMP").val(lv_strValue.getAttribute("HEADER"));
            $("#form1").submit();
            break;
    }
}

//-->
</script>
<link href="css/edas.css" type="text/css" rel="stylesheet">
</head>
<body onLoad="MM_preloadImages('images/btt_addnew_over.gif','images/btt_search_over.gif','images/btt_export_over.gif','images/btt_edit2_over.gif','images/btt_delete_over.gif','images/btt_inputs_over.gif');" onresize="set_background('screen_div')">
<form id="form1" name="form1" method="post" action="" >
<table width="100%" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
    <tr><td valign="top">
        <div id="screen_div">
            <table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
                <tr>
                    <td valign="top">
                        <table width="800" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td height="25" class="label_header01" >&nbsp;&nbsp;<%=screenname%></td>
                            </tr>
                            <tr> 
                                <td><div align="center"> 
                                    <table width="750" border="0" cellpadding="0" cellspacing="0">
                                        <tr>
                                            <td colspan="6"><BR></td>
                                        </tr>
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
                                            <td width="110" align="center">
                                                <div align="center"><span id="lb_code"></span><%=sortimg[1]%></div>
                                            </td>
                                            <td align="center" width="480">
                                                <div align="center"><span id="lb_news_header"></span><%=sortimg[2]%></div>
                                            </td>
                                            <td width="140" colspan="2">&nbsp;</td>
                                            <td width="10" align="right"><img src="images/hd_tb_04.gif" width="10" height="28"></td>
                                        </tr>
<%
    if( bolnSuccess ) {
        int intSeq = 1;
        int idx    = 0;
        while( con.nextRecordElement() ) {
            strNewsIdData   = con.getColumn( "NEWS_ID" );
            strHeaderData   = con.getColumn( "HEADER" );
            
            strbttEdit   = "<img src=\"images/btt_edit2.gif\" name=\"EDIT" + intSeq + "\"  width=\"52\" height=\"18\" border=\"0\">";
            strbttDelete = "<img src=\"images/btt_delete.gif\" name=\"Delete" + intSeq + "\"  width=\"52\" height=\"18\" border=\"0\">";
            strScript    = "NEWS_ID=\"" + strNewsIdData + "\" HEADER=\"" + strHeaderData + "\" ";
			//strScript    += "NOT_DROP_FLAG=\"" + strNotDropFlagData + "\" TABLE_LEVEL1=\"" + strTableLevel1Data + "\" TABLE_LEVEL2=\"" + strTableLevel2Data + "\" ";

            idx = 2 - (intSeq % 2);
%>              
                                        <tr class="table_data<%=idx%>"> 
                                            <td width="10">&nbsp;</td>
                                            <td width="110"><div align="center"><%=strNewsIdData %></div></td>
                                            <td width="480"><div align="left"><%=strHeaderData %></div></td>
                                            <td colspan="3">
                                                <a href="#" onclick="buttonClick('pEdit',this)"<%=strScript%> onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('EDIT<%=intSeq %>','','images/btt_edit2_over.gif',1)"><%=strbttEdit%></a>&nbsp;
                                                <a href="#" onclick="buttonClick('DELETE',this)"<%=strScript%> onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Delete<%=intSeq %>','','images/btt_delete_over.gif',1)"><%=strbttDelete%></a>
                                            </td>
                                        </tr>
<%
            intSeq++;
        }
    }else {
%>
                                        <tr class="table_data1"> 
                                            <td colspan="6"><div align="center"><%=lc_data_not_found %></div></td>
                                        </tr>
<%
    }
%>
                                    </table>
                                    <table width="750" height="28" border="0" align="center" cellpadding="0" cellspacing="0">
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
                                    <table width="750" border="0" cellpadding="0" cellspacing="0" class="label_bold2">
                                        <tr>
                                            <td height="10"></td>
                                            <td colspan="3" align="right"><%=lb_page_per_size %> : 
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
                                    <table width="750" border="0" cellpadding="0" cellspacing="0" class="label_bold2">
                                        <tr>
                                            <td align="center"> 
                                                <p>
                                                <a href="#" onclick= "buttonClick('pInsert')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('newtb','','images/btt_addnew_over.gif',1)">
                                                    <img src="images/btt_addnew.gif" name="newtb" border="0"></a>
                                                <a href="#" onclick= "buttonClick('search')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('searchtb','','images/btt_search_over.gif',1)">
                                                    <img src="images/btt_search.gif" name="searchtb" border="0"></a>
                                                </p>
                                            </td>
                                        </tr>
                                    </table>
                                </div></td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </div>
    </td></tr>
</table>
<input type="hidden" id="MODE"         name="MODE"         value="<%=strMode%>">
<input type="hidden" id="screenname"   name="screenname"   value="<%=screenname %>">
<input type="hidden" id="NEWS_ID_TEMP" name="NEWS_ID_TEMP" value="">
<input type="hidden" id="HEADER_TEMP"  name="HEADER_TEMP"  value="">
<input type="hidden" id="sortby"       name="sortby"       value="<%=sortby %>">
<input type="hidden" id="sortfield"    name="sortfield"    value="<%=sortfield %>">
</form>

<form id="formadd" name="formadd" method="post" action="" target = "_self">
<input type="hidden" id="MODE"       name="MODE"       value="">
<input type="hidden" id="NEWS_ID_KEY" name="NEWS_ID_KEY" value="">
<input type="hidden" id="screenname" name="screenname" value="<%=screenname%>">

<input type="hidden" id="mode_parent"         name="mode_parent"         value="<%=strMode%>">
<input type="hidden" id="current_page_parent" name="current_page_parent" value="<%=strCurrentPage%>">
<input type="hidden" id="sortby_parent"       name="sortby_parent"       value="<%=sortby%>">
<input type="hidden" id="sortfield_parent"    name="sortfield_parent"    value="<%=sortfield%>">
</form>
</body>
</html>