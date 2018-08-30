<%@page import="com.scc.edms.conf.ImageConfUtil"%>
<%@ page contentType="text/html; charset=tis-620"%>
<%@ page import="com.scc.security.UserInfo"%>
<%@ include file="inc/checkUser.jsp" %>
<%@ include file="inc/constant.jsp" %>
<%@ include file="inc/label.jsp" %>
<%@ include file="inc/utils.jsp" %>
<jsp:useBean id="con" scope="session" class="edms.cllib.EABConnector"/>
<%
	con.setRemoteServer("EAS_SERVER");

	UserInfo userInfo     = (UserInfo)session.getAttribute( "USER_INFO" );
	String strUserId      = userInfo.getUserId();
	
	String screenname   = getField(request.getParameter("screenname"));
	String strClassName = "USER_GROUP";
	String strMode      = getField(request.getParameter("MODE"));
	
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
	int     intSeq          = 0;
	
	int     i         = 0;
    int     intfield  = 0;
    int     intclm    = 0;

    String strUserGroupDelData = getField(request.getParameter( "USER_GROUP_DEL" ));
    String strGroupNameDelData = getField(request.getParameter( "GROUP_NAME_DEL" ));
        
    String strFieldUserGroupData = "";
    String strFieldGroupNameData = "";
    
    String strScript      = "";
    String strTotalPage   = "1";
    String strTotalSize   = "0";
    String strbttEdit     = "";
    String strbttDelete   = "";
    String strbttManage   = "";
    String strbttRole     = "";
    String sortby         = "";
    String sortbyd        = "";
    String sortfield      = "";
    String strCurrentDate = "";
    String strVersionLang = ImageConfUtil.getVersionLang();

	if( strVersionLang.equals("thai") ) {
		strCurrentDate = getServerDateThai();
	}else {
		strCurrentDate = getServerDateEng();
	}
    
    sortby    = getField( request.getParameter("sortby") );                          
    sortfield = getField( request.getParameter("sortfield") );

    if( strMode == null || strMode.equals("")){
        strMode = "SEARCH";
   	}
    
    if( strMode.equals("DELETE") ) {
    	con.addData( "USER_GROUP", "String", strUserGroupDelData );
    	
    	con.addData( "DESC",         "String", strUserGroupDelData + "-" + strGroupNameDelData );
     	con.addData( "USER_ID",      "String", strUserId );
        con.addData( "ACTION_FLAG",  "String", "DG" );
        con.addData( "CURRENT_DATE", "String", strCurrentDate);
        
		bolnSuccess = con.executeService( strContainerName, strClassName, "deleteUserGroup" );
		if( !bolnSuccess ){
            strErrorCode    = con.getRemoteErrorCode();
            strErrorMessage = con.getRemoteErrorMesage();
            if( strErrorCode.equals("ERR00005") ){
                strmsg  = "showMsg(0,0,\" " + lc_can_not_delete_group + "\")";
                strMode = "SEARCH";
            }else{
            	strmsg  = "showMsg(0,0,\" " + lc_can_not_delete_data_2 + "\")";
    			strMode = "SEARCH";
            }
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
        
    	con.addData( "SORT_FIELD", "String", sortfield );
        con.addData( "SORT_BY",    "String", sortbyd );
        con.addData( "PAGENUMBER", "String", strCurrentPage );
        con.addData( "PAGESIZE",   "String", strPageSize );
        bolnSuccess = con.executeService( strContainerName, strClassName, "selectUserGroup" );
        
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

//var intSeq     = parseInt( "<%=intSeq %>" );
var intSeq    = "<%=intSeq %>";
var mode      = '<%=strMode%>';
var totalPage = '<%=strTotalPage%>';

function window_onload() {
    var per_page = '<%=strPageSize%>';
    
    lb_doc_type.innerHTML     = lbl_doc_type;
    lb_group_name.innerHTML   = lbl_group_name;
    lb_total_record.innerHTML = lbl_total_record;
    lb_record.innerHTML       = lbl_record;

    form1.PAGE_SIZE.value = per_page;
        
    set_background();
}

function concatAllUserId(){
	var strConUserId  = "";
	var strFullUserId = "";
	var strUserId     = "hidUserId_";
	var obj_chkArr    = "";
	var strchkBox     = "chkAllCheck";
	var obj_chkBox    = "";
	var length        = obj_intSeqn.value;
	
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
	obj_ConUserId.value = strConUserId;
}

function chkbxClickValue() {
	obj_chkAllCheck.checked = false;
}

function getValueRole() {
	var optSelected = document.getElementById("optUserRole").selectedIndex;
	var optValue    = document.getElementById("optUserRole").value;
	
	if( optSelected == 0 ) {
		obj_hidUserRole.value = "";
	}else {
		obj_hidUserRole.value = optValue;
	}
}

function chkAllUserId(){
    var oEle = form1.elements;
    var len = oEle.length;
    if( obj_chkAllCheck.checked ) {
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

function sortsearch( lv_sortType, lv_sort ) {
	if( mode == "SEARCH" ) {
        form1.MODE.value = "SEARCH";
    }else {
        form1.MODE.value = "FIND";
    }

    form1.sortfield.value = lv_sort;
    form1.sortby.value    = lv_sortType;
    form1.submit();
}

function navigatorClick( lv_event ){
//    if( form1.action == "TestExcelServlet" ){
//        form1.action = "user_group1.jsp" ;
//        form1.submit;
//    }
//    var lv_objActive    = document.activeElement;
	var lv_intCurrPage  = parseInt( form1.CURRENT_PAGE.value );
	var lv_intTotalPage = totalPage;

    if( lv_intTotalPage == null || lv_intTotalPage == "" ) {
        lv_intTotalPage = 0;
    }

    switch( lv_event ){
		case "firstP" :
            if( lv_intCurrPage == 1 ) {
                return false;
            }
            lv_intCurrPage = 1;
            break;
		case "previousP" :
            if( lv_intCurrPage == 1 ) {
                return false;
            }
            lv_intCurrPage--;
            break;
		case "nextP" :
            if( lv_intCurrPage == lv_intTotalPage ) {
                return false;
            }
            lv_intCurrPage++;
            break;
		case "lastP" :
            if( lv_intCurrPage == lv_intTotalPage ) {
                return false;
            }
            lv_intCurrPage = lv_intTotalPage;
            break;
	}
	form1.CURRENT_PAGE.value = lv_intCurrPage;
    form1.submit();
}

function buttonClick( lv_strMethod, lv_strValue ){
	switch( lv_strMethod ){
		case "add" :
			formadd.action               = "user_group2.jsp";
			formadd.MODE.value           = "pInsert";
			formadd.USER_GROUP_KEY.value = "";
			formadd.submit();
			break;
        case "pEdit" :
			formadd.action               = "user_group2.jsp";
			formadd.MODE.value           = "pEdit";
			formadd.USER_GROUP_KEY.value = lv_strValue.getAttribute("USER_GROUP");
			formadd.submit();
			break;
        case "delete" :
			if( !confirm( lc_confirm_delete + " '" + lv_strValue.getAttribute("GROUP_NAME") + "'" ) ) {
				return;
			}
			form1.USER_GROUP_DEL.value = lv_strValue.getAttribute("USER_GROUP");
			form1.GROUP_NAME_DEL.value = lv_strValue.getAttribute("GROUP_NAME");
			form1.action               = "user_group1.jsp";
			form1.MODE.value           = "DELETE";
			form1.submit();
			break;
		case "user" :
			//form1.MODE.value = lv_strMethod;
			formadd.USER_GROUP_KEY.value = lv_strValue.getAttribute("USER_GROUP");
			formadd.GROUP_NAME_KEY.value = lv_strValue.getAttribute("GROUP_NAME");
			formadd.MODE.value           = "SEARCH";
			formadd.action               = "user_group3.jsp";
			formadd.submit();
			break;
        case "role" :
			formadd.USER_GROUP_KEY.value = lv_strValue.getAttribute("USER_GROUP");
			formadd.GROUP_NAME_KEY.value = lv_strValue.getAttribute("GROUP_NAME");
			formadd.MODE.value           = form1.MODE.value;
			formadd.action               = "user_group5.jsp";
			formadd.submit();
			break;
	}
}

function change_result_per_page(){
        form1.CURRENT_PAGE.value = 1;
	form1.submit();	
}

function set_background(){    
    var header_height = getDocHeight();
    
    if(header_height == 0){
        header_height = document.documentElement.offsetHeight;
    }
    
    screen_div.style.height = header_height;      
}

function getDocHeight() {
    var D = document;
    return Math.min(
        D.body.scrollHeight, D.documentElement.scrollHeight,
        D.body.offsetHeight, D.documentElement.offsetHeight,
        D.body.clientHeight, D.documentElement.clientHeight
    );
}

//-->
</script>
<link href="css/edas.css" type="text/css" rel="stylesheet">
</head>
<body onLoad="MM_preloadImages('images/btt_addgroup_over.gif');window_onload();" onresize="set_background()">
<form name="form1" method="post" action="" >
<table width="100%" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
	<tr><td valign="top">
<!--		<div id="screen_div" style="width:100%;height:100%;overflow-y:scroll;overflow-x:hidden;margin-right:0px;margin-bottom:0px;border:0px #ccc solid;" >-->
<div id="screen_div" style="width:100%;margin-right:0px;margin-bottom:0px;border:0px #ccc solid;overflow: auto;" >
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
  <tr>
    <td valign="top">
    	<table width="800" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td height="25" class="label_header01" >&nbsp;&nbsp;<%=screenname%></td>
              </tr>
              <tr> 
                <td><div align="center"> 
                    <table width="700" border="0" cellpadding="0" cellspacing="0">
<%
    intclm = 2;

    String[] sortimg = new String[intclm+1];
    String[] strrec  = new String[intclm+1];

    for( i=1; i<=intclm; i++ ) {
        sortimg[i] = "";
    }

    if( searchmod ) {
        if ( sortfield.equals("0") ) {
            for( i=1; i<=intclm; i++ ) {
                sortimg[i]="<img src=\"images/updown.gif\" onclick=\"sortsearch('ASC',"+i+")\" name=\"img1\" style=\"cursor:pointer\">";
            }
        }else {
            intfield=Integer.parseInt( sortfield );
            for( i=1; i<=intclm; i++ ) {
                if ( i==intfield ) {
                    if ( sortby.equals("ASC") ) {
                        sortimg[i]="<img src=\"images/sort_down.gif\" onclick=\"sortsearch('DESC',"+i+")\" name=\"img1\" style=\"cursor:pointer\">";
                    }else {
                        sortimg[i]="<img src=\"images/sort_up.gif\" onclick=\"sortsearch('ASC',"+i+")\" name=\"img1\" style=\"cursor:pointer\">";
                    }
                }else {
                    sortimg[i]="<img src=\"images/updown.gif\" onclick=\"sortsearch('ASC',"+i+")\" name=\"img1\" style=\"cursor:pointer\">";
                }
            }
        }
    }
%>
                      <tr>
                        <td colspan="8"><BR></td>
                      </tr>
                      <tr class="hd_table"> 
                        <td width="10"><img src="images/hd_tb_01.gif" width="10" height="28"></td>
                        <td width="100" align="center">
                        	<div align="left"><span id="lb_doc_type"></span><%=sortimg[1]%></div>
                        </td>
                        <td width="352" align="center">
                        	<div align="left"><span id="lb_group_name"></span><%=sortimg[2]%></div>
                        </td>
                        <td width="57" align="center"><div align="center">&nbsp;</div></td>
                        <td width="57" align="center"><div align="center">&nbsp;</div></td>
                        <td align="center"><div align="center">&nbsp;</div></td>
                        <td align="center"><div align="center">&nbsp;</div></td>
                        <td width="10" align="right"><img src="images/hd_tb_04.gif" width="10" height="28"></td>
                      </tr>
<%
    if( (bolnSuccess) ) {
        intSeq       = 1;
        while( con.nextRecordElement() ){
            strFieldUserGroupData = con.getColumn( "USER_GROUP" );
            strFieldGroupNameData = con.getColumn( "GROUP_NAME" );   
            
            strbttEdit   = "<img src=\"images/btt_edit2.gif\" name=\"EDIT" + intSeq + "\"  width=\"52\" height=\"18\" border=\"0\">";
            strbttDelete = "<img src=\"images/btt_delete.gif\" name=\"Delete" + intSeq + "\"  width=\"52\" height=\"18\" border=\"0\">";
            strbttManage = "<img src=\"images/btt_manageuser.gif\" name=\"manage" + intSeq + "\"  height=\"18\" border=\"0\">";
            strbttRole   = "<img src=\"images/btt_manage.gif\" name=\"role" + intSeq + "\"  height=\"18\" border=\"0\">";
            
            strScript    = "USER_GROUP=\"" + strFieldUserGroupData + "\" GROUP_NAME=\"" + strFieldGroupNameData + "\" ";
			
			if( intSeq % 2 != 0 ) {
%>                      
                      <tr class="table_data1">
                        <td width="10">&nbsp;</td>
                        <td width="100"><div align="left"><%=strFieldUserGroupData %></div></td>
                        <td width="352"><div align="left"><%=strFieldGroupNameData %></div></td>
                        <td width="57" align="center">
                        	<a href="#" onclick= "buttonClick('pEdit',this)"<%=strScript%> onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('EDIT<%=intSeq %>','','images/btt_edit2_over.gif',1)"><%=strbttEdit%></a>
                        </td>
                        <td width="57" align="center">
                        	<a href="#" onclick= "buttonClick('delete',this)"<%=strScript%> onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Delete<%=intSeq %>','','images/btt_delete_over.gif',1)"><%=strbttDelete%></a>
                        </td>
                        <td align="center">
                        	<a href="#" onclick= "buttonClick('user',this)"<%=strScript%> onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('manage<%=intSeq %>','','images/btt_manageuser_over.gif',1)"><%=strbttManage%></a>
                        </td>
                        <td align="center">
                        	<a href="#" onclick= "buttonClick('role',this)"<%=strScript%> onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('role<%=intSeq %>','','images/btt_manage_over.gif',1)"><%=strbttRole%></a>
                        </td>
                        <td width="10">&nbsp;</td>
                      </tr>
<%
            }else{
%>
                      <tr class="table_data2">
                        <td width="10">&nbsp;</td>
                        <td width="100"><div align="left"><%=strFieldUserGroupData %></div></td>
                        <td width="352"><div align="left"><%=strFieldGroupNameData %></div></td>
                        <td width="57" align="center">
                        	<a href="#" onclick= "buttonClick('pEdit',this)"<%=strScript%> onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('EDIT<%=intSeq %>','','images/btt_edit2_over.gif',1)"><%=strbttEdit%></a>
                        </td>
                        <td width="57" align="center">
                        	<a href="#" onclick= "buttonClick('delete',this)"<%=strScript%> onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Delete<%=intSeq %>','','images/btt_delete_over.gif',1)"><%=strbttDelete%></a>
                        </td>
                        <td align="center">
                        	<a href="#" onclick= "buttonClick('user',this)"<%=strScript%> onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('manage<%=intSeq %>','','images/btt_manageuser_over.gif',1)"><%=strbttManage%></a>
                        </td>
                        <td align="center">
                        	<a href="#" onclick= "buttonClick('role',this)"<%=strScript%> onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('role<%=intSeq %>','','images/btt_manage_over.gif',1)"><%=strbttRole%></a>
                        </td>
                        <td width="10">&nbsp;</td>
                      </tr>
<%
            }
            intSeq++;
        }
     }
 %>                      
                    </table>
                    <table width="700" height="28" border="0" align="center" cellpadding="0" cellspacing="0">
	                    <tr class="footer_table">
	                        <td width="68%" align="left" >&nbsp;&nbsp;<span id="lb_total_record"></span>&nbsp;&nbsp;<%=strTotalSize%>&nbsp;&nbsp;<span id="lb_record"></span></td>
	                        <td width="4%" height="28" align="right">
	                            <a href="#" name="firstP" onClick="navigatorClick('firstP');">
	                                <img src="images/first.gif" width="22" height="22" border="0"></a>
	                        </td>
	                        <td width="4%" height="28" align="right">
	                            <a href="#" name="previousP" onClick="navigatorClick('previousP');">
	                                <img src="images/prv.gif" width="22" height="22" border="0"></a>
	                        </td>
	                        <td width="16%" height="28" align="center">
	                            <input name="CURRENT_PAGE" type="text" class="input_box_disable" style="text-align:center" size="3" value="<%=strCurrentPage%>" readonly>/
	                            <input name="TOTAL_PAGE" type="text" class="input_box_disable" style="text-align:center" size="3" value="<%=strTotalPage%>" readonly>
	                        </td>
	                        <td width="4%" height="28">
	                            <a href="#" name="nextP" onClick="navigatorClick('nextP');">
	                                <img src="images/next.gif" width="22" height="22" border="0"></a>
	                        </td>
	                        <td width="4%" height="28">
	                            <a href="#" name="lastP" onClick="navigatorClick('lastP');"><img src="images/last.gif" width="22" height="22" border="0"></a>
	                            <span id="lb_from"></span>
	                        </td>
	                    </tr>
	                </table>
		            <table width="700" border="0" cellpadding="0" cellspacing="0" class="label_bold2">
		            	<tr>
		              		<td height="10"></td>
		              		<td colspan="3" align="right"><%=lb_page_per_size %> : 
	              				<select name="PAGE_SIZE"  class="combobox" onchange="change_result_per_page();">
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
                    <a href="#" onclick= "buttonClick('add')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('add','','images/btt_addgroup_over.gif',1)">
                    	<img src="images/btt_addgroup.gif" id="add" name="add" width="102" height="22" border="0"></a>
                    </p>
                  </div></td>
              </tr>
            </table>
            <input type="hidden" name="MODE"         value="<%=strMode%>">
			<input type="hidden" name="screenname"   value="<%=screenname%>">
			<input type="hidden" name="sortby"       value="<%=sortby%>">
			<input type="hidden" name="sortfield"    value="<%=sortfield%>">
			<input type="hidden" id="USER_GROUP_DEL" name="USER_GROUP_DEL" value="">
			<input type="hidden" id="GROUP_NAME_DEL" name="GROUP_NAME_DEL" value="">
        <p>&nbsp;</p> </td>
    </tr>
</table>
		</div>
	</td></tr>
</table>
</form>

<form name="formadd" method="post" action="" target="_self">
	<input type="hidden" id="MODE"           name="MODE"           value="">
	<input type="hidden" id="USER_GROUP_KEY" name="USER_GROUP_KEY" value="">
	<input type="hidden" id="GROUP_NAME_KEY" name="GROUP_NAME_KEY" value="">
	<input type="hidden" id="screenname"     name="screenname"     value="<%=screenname%>">
	
	<input type="hidden" id="mode_parent"         name="mode_parent"         value="<%=strMode%>">
	<input type="hidden" id="current_page_parent" name="current_page_parent" value="<%=strCurrentPage%>">
	<input type="hidden" id="sortby_parent"       name="sortby_parent"       value="<%=sortby%>">
	<input type="hidden" id="sortfield_parent"    name="sortfield_parent"    value="<%=sortfield%>">
</form>
</body>
</html>
<%  if (!strmsg.equals("")) {  %>
<script language="javaScript">
    <%=strmsg%>
</script>
<%  }   %>