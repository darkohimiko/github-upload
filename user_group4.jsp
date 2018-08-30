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
	String strProjectCode = userInfo.getProjectCode();
	
	String screenname   = getField(request.getParameter("screenname"));
	String strClassName = "USER_GROUP";
	String strMode      = getField( request.getParameter("MODE") );
	
	String strCurrentPage = request.getParameter( "CURRENT_PAGE" );
	String strPageSize    = request.getParameter( "PAGE_SIZE" );
	if( strCurrentPage == null || Integer.parseInt( strCurrentPage ) == 0 ) {
	    strCurrentPage = "1";
	}
	if( strPageSize == null || Integer.parseInt( strPageSize ) == 0 ) {
		strPageSize = "10";
	}
	
	String  strmsg          = "";
	boolean bolnSuccess     = false;
        boolean searchmod       = false;
	int     intSeq          = 0;
	int     i               = 0;
    int     intfield        = 0;
    int     intclm          = 0;

    String strUserGroupKey  = getField( request.getParameter("USER_GROUP_KEY") );
    String strGroupNameKey  = getField( request.getParameter("GROUP_NAME_KEY") );

    String mode_parent         = getField(request.getParameter( "mode_parent" ));
    String current_page_parent = getField(request.getParameter( "current_page_parent" ));
    String sortby_parent       = getField(request.getParameter( "sortby_parent" ));
    String sortfield_parent    = getField(request.getParameter( "sortfield_parent" ));
    String strConcatUserId     = getField(request.getParameter( "hidConUserId" ));
    String strUserIdData       = getField(request.getParameter( "txtUserId" ));
    String strUserNameData     = getField(request.getParameter( "txtUserName" ));
    String strUserSnameData    = getField(request.getParameter( "txtUserSname" ));
    String strUserOrgData      = getField(request.getParameter( "txtOrgCode" ));
    String strUserOrgNameData  = getField(request.getParameter( "txtOrgName" ));
    String strTitleNameData    = "";
    String strFullName         = "";
    
    String strTotalPage   = "1";
    String strTotalSize   = "0";
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

    if( strMode == null || strMode.equals("") ) {
        strMode = "SEARCH";
   	}
    
    if( strMode.equals("INSERT") ) {
    	con.addData( "USER_ID_CON", "String", strConcatUserId );
        con.addData( "USER_GROUP",  "String", strUserGroupKey );
    	con.addData( "USER_ID",     "String", strUserId );
    	con.addData( "ADD_USER",    "String", strUserId );
        con.addData( "ADD_DATE",    "String", strCurrentDate );
        con.addData( "UPD_USER",    "String", strUserId );
		bolnSuccess = con.executeService( strContainerName, strClassName, "insertUserGroupUser" );
		if( !bolnSuccess ){
			strmsg  = "showMsg(0,0,\" " + lc_can_not_add_data + "\")";
			strMode = "SEARCH";
		}else{
		    strmsg  = "showMsg(0,0,\" " + lc_add_data_successfull + "\")";
		    strMode = "SUCCESS";
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
        
        if( !strUserIdData.equals("") ) {
        	con.addData( "USER_ID", "String", strUserIdData );
        }
        if( !strUserNameData.equals("") ) {
        	con.addData( "USER_NAME", "String", strUserNameData );
        }
        if( !strUserSnameData.equals("") ) {
        	con.addData( "USER_SNAME",  "String", strUserSnameData );
        }
        if( !strUserOrgData.equals("") ) {
        	con.addData( "USER_ORG",   "String", strUserOrgData );
        }
        con.addData( "USER_GROUP", "String", strUserGroupKey );
    	con.addData( "SORT_FIELD", "String", sortfield );
        con.addData( "SORT_BY",    "String", sortbyd );
        con.addData( "PAGENUMBER", "String", strCurrentPage );
        con.addData( "PAGESIZE",   "String", strPageSize );
        bolnSuccess = con.executeService( strContainerName, strClassName, "searchAllUserIdGroup" );
        
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
    
    lb_group_name.innerHTML      = lbl_group_name;
    lb_user_profile1.innerHTML   = lbl_user_profile1;
    lb_user_profile2.innerHTML   = lbl_user_profile2;
    lb_user_profile3.innerHTML   = lbl_user_profile3;
    lb_user_profile1_1.innerHTML = lbl_user_profile1;
    lb_user_profile2_4.innerHTML = lbl_user_profile2_4;
    lb_user_profile2_5.innerHTML = lbl_user_profile2_5;
    lb_user_profile3_1.innerHTML = lbl_user_profile3;
    lb_total_record.innerHTML    = lbl_total_record;
    lb_record.innerHTML          = lbl_record;

    if( mode == "SUCCESS" ) {
        form1.action             = "user_group3.jsp";
        form1.target             = "_self";
	    form1.CURRENT_PAGE.value = form1.current_page_parent.value;
		form1.sortfield.value    = form1.sortfield_parent.value;
		form1.sortby.value       = form1.sortby_parent.value;
        form1.MODE.value         = "SEARCH";
        form1.submit();
    }

    obj_txtUserId.value    = "<%=strUserIdData %>";
	obj_txtUserName.value  = "<%=strUserNameData %>";
	obj_txtUserSname.value = "<%=strUserSnameData %>";
	obj_txtOrgCode.value   = "<%=strUserOrgData %>";
	obj_txtOrgName.value   = "<%=strUserOrgNameData %>";
	form1.PAGE_SIZE.value  = per_page;
        
        set_background();
}

function concatAllUserId() {
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
	obj_hidConUserId.value = strConUserId;
}

function chkbxClickValue() {
	obj_chkAllCheck.checked = false;
}

function openZoom( strZoomType ) {
	var strPopArgument   = "scrollbars=yes,status=no";
	var strWidth         = ",width=370px";
	var strHeight        = ",height=420px";
	var strUrl           = "";
	var strConcatField   = "";

	strPopArgument += strWidth + strHeight;

	switch( strZoomType ) {
		case "org" :
			strUrl = "inc/zoom_data_table_level1.jsp";
			//strUrl = "inc/zoom_table_level1.jsp";
			strConcatField = "TABLE=ORG" + "&TABLE_LABEL=" + lbl_user_profile2_7;
			strConcatField += "&RESULT_FIELD=txtOrgCode,txtOrgName";
			break;
	}

	objZoomWindow = window.open( strUrl + "?" + strConcatField, strZoomType, strPopArgument );
	objZoomWindow.focus();
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

function clearAllCriteria() {
	obj_txtUserId.value    = "";
	obj_txtUserName.value  = "";
	obj_txtUserSname.value = "";
	obj_txtOrgCode.value   = "";
	obj_txtOrgName.value   = "";
}

function sortsearch( lv_sortType, lv_sort ) {
/*	if( mode == "SEARCH" ) {
        form1.MODE.value = "SEARCH";
    }else {
        form1.MODE.value = "FIND";
    }
*/
    form1.sortfield.value = lv_sort;
    form1.sortby.value    = lv_sortType;
    form1.submit();
}

function navigatorClick( lv_event ){
    //    if( form1.action == "TestExcelServlet" ){
        //        form1.action = "user_profile.jsp" ;
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

function chkCriteriaSearch() {
	if( obj_txtUserId.value.length == 0 && obj_txtUserName.value.length == 0 && obj_txtUserSname.value.length == 0 && obj_txtOrgCode.value.length == 0 ) {
		alert( lc_checked_data_search );
		return false;
	}
	return true;
}

function buttonClick( lv_strMethod, lv_strValue ){
	switch( lv_strMethod ){
		case "search" :
			if( chkCriteriaSearch() ) {
				form1.action     = "user_group4.jsp";
				form1.MODE.value = "SEARCH";
				form1.target 	 = "_self";
				form1.submit();
				break;
			}
        case "all" :
        	clearAllCriteria();
			form1.action     = "user_group4.jsp";
			form1.MODE.value = "SEARCH";
			form1.submit();
			break;
        case "add" :
			concatAllUserId();
			if( obj_hidConUserId.value == "" ) {
				alert( lc_select_user_id );
				return;
			}
			
			if( !confirm( lc_confirm_individual_access_is_delete + obj_hidConUserId.value + lc_was_delete ) ){
				return;
			}
			
			form1.action     = "user_group4.jsp";
			form1.MODE.value = "INSERT";
			form1.target 	 = "_self";
			form1.submit();
			break;
		case "cancel" :
			if( form1.current_page_parent.value == "" ) {
				form1.CURRENT_PAGE.value = "1";
			}else {
				form1.CURRENT_PAGE.value = form1.current_page_parent.value;
			}
			form1.sortfield.value    = form1.sortfield_parent.value;
			form1.sortby.value       = form1.sortby_parent.value;
		    form1.MODE.value         = form1.mode_parent.value;
			form1.action             = "user_group3.jsp";
			form1.target 	         = "_self";
		    //form1.MODE.value         = "SEARCH";
		    form1.submit();
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
<body onLoad="MM_preloadImages('images/btt_save2_over.gif','images/btt_search_over.gif','images/btt_back_over.gif','images/btt_allsearch_over.gif');window_onload();" onresize="set_background()">
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
                <td height="25" class="label_header01" >&nbsp;&nbsp;<%=screenname%>&nbsp;<%=lb_user_group_manage %>&nbsp;<%=lb_user_group_manage_add %></td>
              </tr>
              <tr> 
                <td><div align="center">
                    <table width="800" border="0" cellpadding="0" cellspacing="0">
                      	<tr>
                        	<td colspan="7"><BR></td>
                      	</tr>
                      	<tr>
                        	<td colspan="7" class="label_bold4">
								<div align="left">
			                		<span id="lb_group_name"></span>&nbsp;:&nbsp;<%=strGroupNameKey %>
			                	</div>
			            	</td>
                      	</tr>
	                	<tr>
	                		<td colspan="7" align="center">
	                		<div>
	                			<table width="550" border="0" cellspacing="0" cellpadding="0">
				                	<tr>
					                  	<td height="25" width="70" class="label_bold2"><span id="lb_user_profile1_1"></span></td>
					                  	<td height="25" colspan="3" width="480">
					                  		<input id="txtUserId" name="txtUserId" type="text" class="input_box" size="20">
				                  		</td>
				                	</tr>
				                	<tr>
					                  	<td height="25" class="label_bold2" width="70"><span id="lb_user_profile2_4"></span></td>
					                  	<td height="25" width="190">
					                  		<input id="txtUserName" name="txtUserName" type="text" class="input_box" size="30" >
				                  		</td>
					                  	<td height="25" class="label_bold2" width="60"><span id="lb_user_profile2_5"></span></td>
					                  	<td height="25" width="230">
					                  		<input id="txtUserSname" name="txtUserSname" type="text" class="input_box" size="35" >
				                  		</td>
				                	</tr>
				                	<tr>
					                  	<td height="25" class="label_bold2" width="70"><span id="lb_user_profile3_1"></span></td>
					                  	<td height="25" colspan="3" width="450">
					                  		<input id="txtOrgCode" name="txtOrgCode" type="text" class="input_box_disable" size="15" value="" readOnly>&nbsp;
					                  		<a href="javascript:openZoom('org');"><img id="iZoomOrg" src="images/search.gif" width="16" height="16" border="0" ></a>&nbsp;
					                  		<input id="txtOrgName" name="txtOrgName" type="text" class="input_box_disable" size="55" value="" readOnly>
				                  		</td>
				                	</tr>
				                </table>
			                    <p>
				           		<a href="#" onclick= "buttonClick('search')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('search','','images/btt_search_over.gif',1)">
				           			<img src="images/btt_search.gif" name="search" width="67" height="22" border="0"></a>&nbsp;
				           		<a href="#" onclick= "buttonClick('all')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('all','','images/btt_allsearch_over.gif',1)">
				           			<img src="images/btt_allsearch.gif" name="all" width="102" height="22" border="0"></a>
			                    </p>
			                </div>
	                		</td>
	                	</tr>
                      <tr>
                        <td colspan="7"><BR></td>
                      </tr>
<%
    intclm = 3;

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
                      <tr class="hd_table"> 
                        <td width="10"><img src="images/hd_tb_01.gif" width="10" height="28"></td>
                        <td width="30"><input type="checkbox" id="chkAllCheck" name="chkAllCheck" onclick="chkAllUserId()" ></td>
                        <td width="170" align="center">
                        	<div align="center"><span id="lb_user_profile1"></span><%=sortimg[1]%></div>
                        </td>
                        <td width="240" align="center">
                        	<div align="center"><span id="lb_user_profile2"></span><%=sortimg[2]%></div>
                        </td>
                        <td width="290" align="center">
                        	<div align="center"><span id="lb_user_profile3"></span><%=sortimg[3]%></div>
                        </td>
                        <td align="right"><img src="images/hd_tb_04.gif" width="10" height="28"></td>
                      </tr>
<%
    if( (bolnSuccess) ) {
        intSeq = 1;
        while( con.nextRecordElement() ){
            strUserIdData      = con.getColumn( "USER_ID" );
            strTitleNameData   = con.getColumn( "TITLE_NAME" );
            strUserNameData    = con.getColumn( "USER_NAME" );
            strUserSnameData   = con.getColumn( "USER_SNAME" );
            strUserOrgNameData = con.getColumn( "ORG_NAME" );
            strFullName        = strTitleNameData + " " + strUserNameData + " " + strUserSnameData;
         
            if( intSeq % 2 != 0 ) {
%>
                      
                      <tr class="table_data1">
                        <td>&nbsp;</td>
                        <td>
                        	<div align="center"><input type="checkbox" id="chkAllCheck<%=intSeq%>" name="chkAllCheck<%=intSeq%>" 
                        		onclick="chkbxClickValue()" ></div>
                        </td>
                        <td><div align="left">&nbsp;<%=strUserIdData %><input type="hidden" id="hidUserId_<%=intSeq%>" value="<%=strUserIdData %>"></div></td>
                        <td><div align="left">&nbsp;<%=strFullName %></div></td>
                        <td><div align="left">&nbsp;<%=strUserOrgNameData %></div></td>
                        <td>&nbsp;</td>
                      </tr>
<%
            }else{
%>
                      <tr class="table_data2"> 
                        <td>&nbsp;</td>
                        <td>
                        	<div align="center"><input type="checkbox" id="chkAllCheck<%=intSeq%>" name="chkAllCheck<%=intSeq%>" 
                        		onclick="chkbxClickValue()" ></div>
                        </td>
                        <td><div align="left">&nbsp;<%=strUserIdData %><input type="hidden" id="hidUserId_<%=intSeq%>" value="<%=strUserIdData %>"></div></td>
                        <td><div align="left">&nbsp;<%=strFullName %></div></td>
                        <td><div align="left">&nbsp;<%=strUserOrgNameData %></div></td>
                        <td>&nbsp;</td>
                      </tr>
<%
            }
            intSeq++;
        }
     }
 %>                      
                    </table>			
                    </div>
                </td>
              </tr>
                    </table>
                    <table width="800" height="28" border="0" cellpadding="0" cellspacing="0">
	                    <tr class="footer_table">
	                        <td width="65%" align="left" >&nbsp;&nbsp;<span id="lb_total_record"></span>&nbsp;&nbsp;<%=strTotalSize%>&nbsp;&nbsp;<span id="lb_record"></span></td>
	                        <td width="4%" height="28" align="right">
	                            <a href="#" name="firstP" onClick="navigatorClick('firstP');">
	                                <img src="images/first.gif" width="22" height="22" border="0"></a>
	                        </td>
	                        <td width="4%" height="28" align="right">
	                            <a href="#" name="previousP" onClick="navigatorClick('previousP');">
	                                <img src="images/prv.gif" width="22" height="22" border="0"></a>
	                        </td>
	                        <td width="19%" height="28" align="center">
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
                        <table width="800" border="0" cellpadding="0" cellspacing="0" class="label_bold2">
                            <tr>
                                <td height="10"></td>
                                <td align="right">
                                    <%=lb_page_per_size %> : 
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
                            <tr>
                                <td colspan="2" align="center">
                                    <a href="#" onclick="buttonClick('add')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('add','','images/btt_save2_over.gif',1)"><img src="images/btt_save2.gif" name="add" width="67" height="22" border="0"></a>&nbsp;
                                    <a href="#" onclick="buttonClick('cancel')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('back','','images/btt_back_over.gif',1)"><img src="images/btt_back.gif" name="back" width="67" height="22" border="0"></a>
                                </td>
                            </tr>
                        </table>
    </td>
  </tr>
</table>
              	</div>
            <br>
            </td>
              </tr>
            </table>
            <input type="hidden" name="MODE"         value="<%=strMode%>">
			<input type="hidden" name="screenname"   value="<%=screenname%>">
			<input type="hidden" name="PROJECT_CODE" value="<%=strProjectCode%>">
			<input type="hidden" name="sortby"       value="<%=sortby%>">
			<input type="hidden" name="sortfield"    value="<%=sortfield%>">
			
			<input type="hidden" id="seqn"           name="seqn"           value="<%=intSeq %>">
			<input type="hidden" id="USER_GROUP_KEY" name="USER_GROUP_KEY" value="<%=strUserGroupKey %>">
			<input type="hidden" id="GROUP_NAME_KEY" name="GROUP_NAME_KEY" value="<%=strGroupNameKey %>">
			<input type="hidden" id="hidConUserId"   name="hidConUserId"   value="">
			<input type="hidden" id="hidUserRole"    name="hidUserRole"    value="">
			
			<input type="hidden" id="mode_parent"         name="mode_parent"         value="<%=mode_parent%>">
			<input type="hidden" id="current_page_parent" name="current_page_parent" value="<%=current_page_parent%>">
			<input type="hidden" id="sortby_parent"       name="sortby_parent"       value="<%=sortby_parent%>">
			<input type="hidden" id="sortfield_parent"    name="sortfield_parent"    value="<%=sortfield_parent%>">
        </td>
    </tr>
</table>
		</div>
	</td></tr>
</table>
</form>
</body>
</html>
<script language="JavaScript" type="text/javascript">
<!--

var obj_bttSearch    = document.getElementById( "search" );
var obj_chkAllCheck  = document.getElementById( "chkAllCheck" );
var obj_intSeqn      = document.getElementById( "seqn" );
var obj_hidConUserId = document.getElementById( "hidConUserId" );
var obj_txtUserId    = document.getElementById( "txtUserId" );
var obj_txtUserName  = document.getElementById( "txtUserName" );
var obj_txtUserSname = document.getElementById( "txtUserSname" );
var obj_txtOrgCode   = document.getElementById( "txtOrgCode" );
var obj_txtOrgName   = document.getElementById( "txtOrgName" );

//-->
</script>
<%  if (!strmsg.equals("")) {  %>
<script language="javaScript">
    <%=strmsg%>
</script>
<%  }   %>