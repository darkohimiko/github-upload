<%@page import="com.scc.edms.conf.ImageConfUtil"%>
<%@ page contentType="text/html; charset=tis-620"%>
<%@ page import="com.scc.security.UserInfo"%>
<%@ include file="inc/checkUser.jsp" %>
<%@ include file="inc/constant.jsp" %>
<%@ include file="inc/label.jsp" %>
<%@ include file="inc/utils.jsp" %>
<jsp:useBean id="con" scope="session" class="edms.cllib.EABConnector"/>
<jsp:useBean id="con1" scope="session" class="edms.cllib.EABConnector"/>
<jsp:useBean id="con2" scope="session" class="edms.cllib.EABConnector"/>
<jsp:useBean id="conGroup" scope="session" class="edms.cllib.EABConnector"/>
<jsp:useBean id="conGroup2" scope="session" class="edms.cllib.EABConnector"/>
<%
	con.setRemoteServer("EAS_SERVER");
	con1.setRemoteServer("EAS_SERVER");
	con2.setRemoteServer("EAS_SERVER");
	conGroup.setRemoteServer("EAS_SERVER");
	conGroup2.setRemoteServer("EAS_SERVER");

	UserInfo userInfo     = (UserInfo)session.getAttribute( "USER_INFO" );
	String strUserId      = userInfo.getUserId();
	String strUserOrg     = userInfo.getUserOrg();
	String strProjectCode = userInfo.getProjectCode();
	String strProjectName = userInfo.getProjectName();
	String strProjectFlag = userInfo.getProjectFlag();
	
	String user_role = getField(request.getParameter("user_role"));
	String app_name  = getField(request.getParameter("app_name"));
	String app_group = getField(request.getParameter("app_group"));
	
	String screenname   = getField(request.getParameter("screenname"));
	
	String strClassName = "PERMIT_USER";
	String strMode      = getField( request.getParameter("MODE") );
	String strDisplay   = getField( request.getParameter("DISPLAY") );
	
	String strCurrentPage = request.getParameter( "CURRENT_PAGE" );
	String strPageSize    = request.getParameter( "PAGE_SIZE" );
	if( strCurrentPage == null || Integer.parseInt( strCurrentPage ) == 0 ) {
	    strCurrentPage = "1";
	}
	if( strPageSize == null || Integer.parseInt( strPageSize ) == 0 ) {
		strPageSize = "10";
	}
	
	String strCurrentPage2 = request.getParameter( "CURRENT_PAGE_2" );
	String strPageSize2    = request.getParameter( "PAGE_SIZE_2" );
	if( strCurrentPage2 == null || Integer.parseInt( strCurrentPage2 ) == 0 ) {
	    strCurrentPage2 = "1";
	}
	if( strPageSize2 == null || Integer.parseInt( strPageSize2 ) == 0 ) {
		strPageSize2 = "10";
	}
	
	String  strmsg           = "";
	boolean bolnSuccess      = false;
	boolean bolnSuccess1     = false;
	boolean bolnZoomSuccess  = false;
    boolean searchmod        = false;
    boolean searchmod2       = false;
	boolean bolnGroup        = false;
	
	int intSeq    = 0;
	int i         = 0;
    int intfield  = 0;
    int intclm    = 0;
	
	int intSeq2    = 0;
	int j          = 0;
    int intfield2  = 0;
    int intclm2    = 0;

	String strFieldUserIdSearch    = getField(request.getParameter( "USER_ID_SEARCH" ));
    String strFieldUserNameSearch  = getField(request.getParameter( "USER_NAME_SEARCH" ));
    String strFieldUserSnameSearch = getField(request.getParameter( "USER_SNAME_SEARCH" ));
    String strFieldOrgCodeSearch   = getField(request.getParameter( "ORG_CODE_SEARCH" ));

    String strProjectCodeData = getField(request.getParameter( "PROJECT_CODE" ));
    String strUserIdData      = getField(request.getParameter( "hidConUserId" ));
    String strUserRoleData    = getField(request.getParameter( "hidUserRole" ));
        
    String strFieldUserIdData     = "";
    String strFieldTitleNameData  = "";
    String strFieldUserNameData   = "";
    String strFieldUserSnameData  = "";
    String strFullNameData        = "";
    String strFieldOrgNameData    = "";
    String strFieldUserRoleData   = "";
    String strFieldRoleNameData   = "";
    String strFieldAccessTypeData = "";
    String strFieldAccDocTypeData = "";
    
    String strFieldUserGroupData   = "";
    String strFieldGroupNameData   = "";
    String strFieldUserRole2Data   = "";
    String strFieldRoleName2Data   = "";
    String strFieldAccessType2Data = "";
    String strFieldAccDocType2Data = "";
    
	String strScript      = "";
	String strbttEdit     = "";
	String strbttUserList = "";
	String strPermission  = "";
    String strTotalPage   = "1";
    String strTotalSize   = "0";
    String sortby         = "";
    String sortbyd        = "";
    String sortfield      = "";
	String strCurrentDate = "";
    
    sortby    = getField( request.getParameter("sortby") );                          
    sortfield = getField( request.getParameter("sortfield") );

    String strTotalPage2 = "1";
    String strTotalSize2 = "0";
    String sortby2       = "";
    String sortbyd2      = "";
    String sortfield2    = "";
    
    sortby2    = getField( request.getParameter("sortby2") );                          
    sortfield2 = getField( request.getParameter("sortfield2") );
    String strVersionLang  = ImageConfUtil.getVersionLang();

        if( strVersionLang.equals("thai") ) {
		strCurrentDate = getServerDateThai();
	}else {
		strCurrentDate = getServerDateEng();
	}

    if( strMode == null || strMode.equals("")){
        strMode    = "SEARCH";
   	}
    if( strDisplay == null || strDisplay.equals("")){
        strDisplay = "USER";
   	}
    
    con1.addData("USER_ROLE", 		  "String", user_role);
    con1.addData("APPLICATION", 	  "String", app_name);
    con1.addData("APPLICATION_GROUP", "String", app_group);
    bolnSuccess1 = con1.executeService( strContainerName, "DOCUMENT_TYPE", "findPermission" );
    
    if(bolnSuccess1) {
    	strPermission = con1.getHeader( "PERMIT_FUNCTION" );
    }
    
    if( strMode.equals("PERMIT") ) {
    	if( strDisplay.equals("USER") ) {
    		con.addData( "USER_ID", "String", strUserIdData );
    	}else {
    		con.addData( "USER_GROUP", "String", strUserIdData );
    	}
    	con.addData( "PROJECT_CODE", "String", strProjectCodeData );
    	con.addData( "USER_ROLE",    "String", strUserRoleData );
        con.addData( "ADD_USER",     "String", strUserId);
        con.addData( "ADD_DATE",     "String", strCurrentDate);
        con.addData( "UPD_USER",     "String", strUserId);
    	if( strDisplay.equals("USER") ) {
			bolnSuccess = con.executeService( strContainerName, strClassName, "commitRightsPermitUser" );
    	}else {
    		bolnSuccess = con.executeService( strContainerName, strClassName, "commitRightsPermitGroup" );
    	}
		if( !bolnSuccess ){
			strmsg  = "showMsg(0,0,\" " + lc_can_not_update_data + "\")";
			strMode = "SEARCH";
		}else{
		    strmsg  = "showMsg(0,0,\" " + lc_update_data_successfull + "\")";
		    strMode = "SEARCH";
		}
	}
    
    if( strMode.equals("UNPERMIT") ) {
    	if( strDisplay.equals("USER") ) {
    		con.addData( "USER_ID", "String", strUserIdData );
    	}else {
    		con.addData( "USER_GROUP", "String", strUserIdData );
    	}
    	con.addData( "PROJECT_CODE", "String", strProjectCodeData );
        con.addData( "ADD_USER",     "String", strUserId);
        con.addData( "ADD_DATE",     "String", strCurrentDate);
        con.addData( "UPD_USER",     "String", strUserId);
    	if( strDisplay.equals("USER") ) {
			bolnSuccess = con.executeService( strContainerName, strClassName, "cancelRightPermitUser" );
    	}else {
    		bolnSuccess = con.executeService( strContainerName, strClassName, "cancelRightPermitGroup" );
    	}
		if( !bolnSuccess ){
			strmsg  = "showMsg(0,0,\" " + lc_can_not_update_data + "\")";
			strMode = "SEARCH";
		}else{
		    strmsg  = "showMsg(0,0,\" " + lc_update_data_successfull + "\")";
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
    		con.addData( "USER_ID",  "String", strFieldUserIdSearch );
    	}
    	if( !strFieldUserNameSearch.equals("") ) {
        	con.addData( "USER_NAME",  "String", strFieldUserNameSearch );
    	}
    	if( !strFieldUserSnameSearch.equals("") ) {
        	con.addData( "USER_SNAME", "String", strFieldUserSnameSearch );
    	}
    	if( !strFieldOrgCodeSearch.equals("") ) {
        	con.addData( "ORG_CODE", "String", strFieldOrgCodeSearch );
    	}
    	con.addData( "SORTFIELD",  "String", sortfield );
        con.addData( "SORTBY",     "String", sortbyd );
        con.addData( "PAGENUMBER", "String", strCurrentPage );
        con.addData( "PAGESIZE",   "String", strPageSize );
		bolnSuccess = con.executeService( strContainerName, strClassName, "findPermitSearchUser" );
		if( !bolnSuccess ) {
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
        con.addData( "USER_ORG",   "String", strUserOrg );
        bolnSuccess = con.executeService( strContainerName, strClassName, "findPermitUser" );
        
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

	if( sortfield2.equals("") ) {
        sortfield2="0";
    }
    if( sortby2.equals("") ) {
        sortby2="ASC";
    }
    if( sortby2.equals("ASC") ) {
        sortbyd2="ASC";
    }else {
        sortbyd2="DESC";
    }
    conGroup.addData( "SORTFIELD",  "String", sortfield2 );
    conGroup.addData( "SORTBY",     "String", sortbyd2 );
    conGroup.addData( "PAGENUMBER", "String", strCurrentPage2 );
    conGroup.addData( "PAGESIZE",   "String", strPageSize2 );
    bolnGroup = conGroup.executeService( strContainerName, strClassName, "findPermitGroupUser" );
    
    if( bolnGroup ) {
    	searchmod2    = bolnGroup;
    	strTotalPage2 = conGroup.getHeader( "PAGE_COUNT" );
        strTotalSize2 = conGroup.getHeader( "TOTAL_RECORD" );
        if( !strTotalSize.equals("0") ) {
            strCurrentPage2 = conGroup.getHeader( "CURRENT_PAGE" );
        }else {
            strCurrentPage2 = "0";
        }
    }
    
    String strDisplayFlag = "";
    
    if(strProjectFlag.equals("3")){
    	strDisplayFlag = "none";
    }else{
    	strDisplayFlag = "inline";
    }
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title><%=lc_site_name%></title>
<meta http-equiv="Content-Type" content="text/html; charset=tis-620">
<script language="JavaScript" type="text/javascript">
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

var intSeq     = "<%=intSeq %>";
var mode       = '<%=strMode %>';
var display    = "<%=strDisplay %>";
var totalPage  = '<%=strTotalPage %>';
var intSeq2    = "<%=intSeq2 %>";
var totalPage2 = '<%=strTotalPage2 %>';
var per_page   = '<%=strPageSize%>';

function window_onload() {
	var lv_type = "";
//	var lv_name = "";
	
    lb_user_profile2_1.innerHTML = lbl_user_profile2_1;
    lb_user_profile3_1.innerHTML = lbl_user_profile3_1;
    lb_user_profile3.innerHTML   = lbl_user_profile3;
    lb_user_role1.innerHTML      = lbl_user_role2;
    lb_user_role2.innerHTML      = lbl_user_role2;
    lb_total_record.innerHTML    = lbl_total_record;
    lb_record.innerHTML          = lbl_record;

    lb_code.innerHTML          = lbl_code;
    lb_group_name.innerHTML    = lbl_group_name;
    lb_user_role.innerHTML     = lbl_user_role2;
    lb_total_record2.innerHTML = lbl_total_record;
    lb_record2.innerHTML       = lbl_record;
    
	form1.PAGE_SIZE.value = per_page;
    	//change_tab_search();
    if( display == "USER" ) {
    	lv_type = "div_user";
//    	lv_name = "imgDivUser";
    }else {
    	lv_type = "div_group";
//    	lv_name = "imgDivGroup";
    }
    checkedPermission();
    change_tab_search( lv_type );
    
    set_background();
    
<%  if (!strmsg.equals("")) {  %>
    <%=strmsg%>
<%  }   %>
}

function checkedPermission() {
	var permission = "<%=strPermission %>";
	var perInsert  = permission.indexOf("insert");
	var perDelete  = permission.indexOf("delete");
	var perSearch  = permission.indexOf("search");
	
	if( perInsert != -1 ) {
		obj_bttPermit.style.display = "inline";
	}
	if( perDelete != -1 ) {
		obj_bttUnpermit.style.display = "inline";
	}
	if( perSearch != -1 ) {
		obj_bttSearch.style.display = "inline";
	}
}

function change_tab_search( div_name ) {
	var div_obj = document.getElementById( div_name );
//	var img_obj = document.getElementById( img_name );
	
	switch( div_name ) {
		case 'div_user':
			div_obj.style.display = 'inline';
			document.getElementById('div_group').style.display = 'none';
			//img_obj.src = "images/btt_user_over.gif";
//                        obj_liSearch.style.display = 'inline';
                    $("#liSearch").show();
	    	obj_display.value          = "USER";
			break;
		case 'div_group':
			div_obj.style.display = 'inline';
			document.getElementById('div_user').style.display = 'none';
			//img_obj.src = "images/btt_usergroup_over.gif";
//			obj_liSearch.style.display = "none";
                    $("#liSearch").hide();
	    	obj_display.value          = "GROUP";
			break;	
	}
	obj_ConUserId.value = "";
	change_tab_img( div_name );
}

function change_tab_img(lv_div) {
//	if( document.getElementById('div_user').style.display == "inline" ) {
        if(lv_div == "div_user"){
			document.getElementById('imgDivUser').src  = "images/btt_user_over.gif";
			document.getElementById('imgDivGroup').src = "images/btt_usergroup.gif";
	}else {
			document.getElementById('imgDivUser').src  = "images/btt_user.gif";
			document.getElementById('imgDivGroup').src = "images/btt_usergroup_over.gif";
	}
}

function concatAllUserId() {
	var strConUserId  = "";
	var strFullUserId = "";
	var strUserId     = "hidUserId_";
	var obj_chkArr    = "";
	var strchkBox     = "chkAllUser";
	var obj_chkBox    = "";
	var length        = obj_intSeqn.value;

	var strConUserGroup  = "";
	var strFullUserGroup = "";
	var strUserGroup     = "hidUserGroup_";
	var obj_chkGroupArr  = "";
	var strGroupChkBox   = "chkAllGroup";
	var obj_groupChkBox  = "";
	var lenGroup         = obj_intSeqn2.value;

	if( obj_display.value == "USER" ) {
		for( var i=1; i<length; i++ ) {
			obj_chkBox = document.getElementById( strchkBox+i );
			if( obj_chkBox.checked ) {
				strFullUserId = "";
				strFullUserId = strUserId + i;
				obj_chkArr    = document.getElementById( strFullUserId );
				strConUserId  += obj_chkArr.value + ",";
			}
		}
		if( strConUserId.length > 0 ){
			strConUserId = strConUserId.substr( 0, strConUserId.lastIndexOf(",") );
		}
		obj_ConUserId.value = strConUserId;
	}else {
		for( var j=1; j<lenGroup; j++ ) {
			obj_groupChkBox = document.getElementById( strGroupChkBox+j );
			if( obj_groupChkBox.checked ) {
				strFullUserGroup = "";
				strFullUserGroup = strUserGroup + j;
				obj_chkGroupArr    = document.getElementById( strFullUserGroup );
				strConUserGroup  += obj_chkGroupArr.value + ",";
			}
		}
		if( strConUserGroup.length > 0 ){
			strConUserGroup = strConUserGroup.substr( 0, strConUserGroup.lastIndexOf(",") );
		}
		obj_ConUserId.value = strConUserGroup;
	}
}

function chkbxClickValue() {
	if( obj_display.value == "USER" ) {
		obj_chkAllUser.checked = false;
	}else {
		obj_chkAllGroup.checked = false;
	}
}

function selectAllDocument( lv_value ) {
	var strUser = "chkAllUser";
	var lenUser = obj_intSeqn.value;
	var userId  = "";
	
	var strGroup = "chkAllGroup";
	var lenGroup = obj_intSeqn2.value;
	var groupId  = "";

	if( lv_value == "USER" ) {
		if( obj_chkAllUser.checked ) {
		    for( var i=1; i<lenUser; i++ ) {
		    	userId = document.getElementById( strUser+i );
		    	userId.checked = true;
		    }
		}else {
			for( var i=1; i<lenUser; i++ ) {
				userId = document.getElementById( strUser+i );
				userId.checked = false;
		    }
		}
	}else {
		if( obj_chkAllGroup.checked ) {
		    for( var i=1; i<lenGroup; i++ ) {
		    	groupId = document.getElementById( strGroup+i );
		    	groupId.checked = true;
		    }
		}else {
			for( var i=1; i<lenGroup; i++ ) {
				groupId = document.getElementById( strGroup+i );
				groupId.checked = false;
		    }
		}
	}
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

function navigatorClick(lv_event){
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

function sortsearch2( lv_sortType, lv_sort ) {
	if( mode == "SEARCH" ) {
        form1.MODE.value = "SEARCH";
    }else {
        form1.MODE.value = "FIND";
    }

    form1.sortfield2.value = lv_sort;
    form1.sortby2.value    = lv_sortType;
    form1.submit();
}

function navigatorClick2( lv_event ){
//    var lv_objActive    = document.activeElement;
	var lv_intCurrPage  = parseInt( form1.CURRENT_PAGE_2.value );
	var lv_intTotalPage = totalPage2;

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
	form1.CURRENT_PAGE_2.value = lv_intCurrPage;
    form1.submit();
}

function buttonClick( lv_strMethod, lv_strValue ){
	switch( lv_strMethod ){
		case "permit" :
			concatAllUserId();
			if( obj_hidUserRole.value == "" ) {
				alert( lc_select_right );
				return;
			}
			if( obj_ConUserId.value == "" ) {
				alert( lc_select_user_id );
				return;
			}
			form1.action     = "permit_user1.jsp";
			form1.MODE.value = "PERMIT";
			form1.submit();
			break;
                case "unpermit" :
			concatAllUserId();
			if( obj_ConUserId.value == "" ) {
				alert( lc_select_user_id );
				return;
			}
			form1.action     = "permit_user1.jsp";
			form1.MODE.value = "UNPERMIT";
			form1.submit();
			break;
		case "role" :
		    form1.USER_ID_KEY.value         = lv_strValue.getAttribute("USER_ID");
		    form1.USER_FNAME_KEY.value      = lv_strValue.getAttribute("TITLE_NAME") + lv_strValue.getAttribute("USER_NAME") + " " + lv_strValue.getAttribute("USER_SNAME");
		    form1.PROJECT_CODE_KEY.value    = "<%=strProjectCode %>";
		    form1.PROJECT_NAME_KEY.value    = "<%=strProjectName %>";
		    form1.ACCESS_TYPE_KEY.value     = lv_strValue.getAttribute("ACCESS_TYPE");
		    form1.ACCESS_DOC_TYPE_KEY.value = lv_strValue.getAttribute("ACCESS_DOC_TYPE");
		    form1.USER_ROLE_KEY.value       = lv_strValue.getAttribute("USER_ROLE");
		    form1.ROLE_NAME_KEY.value       = lv_strValue.getAttribute("ROLE_NAME");
		    form1.PAGE_KEY.value            = "permit_user1.jsp";
                    form1.action                    = "user_profile5.jsp";
                    form1.target 	            = "_self";
		    form1.MODE.value                = "SEARCH";
		    form1.submit();
			break;
		case "list" :
		    form1.USER_GROUP_KEY.value = lv_strValue.getAttribute("USER_GROUP");
		    form1.GROUP_NAME_KEY.value = lv_strValue.getAttribute("GROUP_NAME");
		    form1.sortby.value         = "";
		    form1.sortfield.value      = "";
		    form1.CURRENT_PAGE.value   = "0";
                    form1.action               = "user_list.jsp";
                    form1.target 	       = "_self";
		    form1.MODE.value           = "SEARCH";
		    form1.submit();
			break;
		case "group" :
		    form1.USER_GROUP_KEY.value      = lv_strValue.getAttribute("USER_GROUP");
		    form1.GROUP_NAME_KEY.value      = lv_strValue.getAttribute("GROUP_NAME");
		    form1.PROJECT_CODE_KEY.value    = "<%=strProjectCode %>";
		    form1.PROJECT_NAME_KEY.value    = "<%=strProjectName %>";
		    form1.ACCESS_TYPE_KEY.value     = lv_strValue.getAttribute("ACCESS_TYPE");
		    form1.ACCESS_DOC_TYPE_KEY.value = lv_strValue.getAttribute("ACCESS_DOC_TYPE");
		    form1.USER_ROLE_KEY.value       = lv_strValue.getAttribute("USER_ROLE");
		    form1.ROLE_NAME_KEY.value       = lv_strValue.getAttribute("ROLE_NAME");
		    form1.PAGE_KEY.value            = "permit_user1.jsp";
                    form1.action                    = "user_group6.jsp";
                    form1.target 	            = "_self";
		    form1.MODE.value                = "SEARCH";
		    form1.submit();
			break;
		case "search" :
			//form1.MODE.value = lv_strMethod;
			form1.method = "post";
			form1.action = "permit_user2.jsp";
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
<body onLoad="MM_preloadImages('images/btt_commitrights_over.gif','images/btt_cancelright_over.gif','images/btt_search_over.gif');window_onload();" onresize="set_background()">
<form name="form1" method="post" action="" >
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
	<tr><td valign="top">
<!--    	<div id="screen_div" style="width:100%;height:100%;overflow-y:scroll;overflow-x:hidden;margin-right:0px;margin-bottom:0px;border:0px #ccc solid;" >-->
<div id="screen_div" style="width:100%;margin-right:0px;margin-bottom:0px;border:0px #ccc solid;overflow: auto;" >
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
  <tr>
    <td valign="top">
    	<table width="800" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td height="25" class="label_header01" >&nbsp;&nbsp;<%=screenname%></td>
              </tr>
              <tr>
              	<td>&nbsp;</td>
              </tr>
              <tr>
              	<td align="left">
	                <table border="0" cellspacing="0" cellpadding="0">
	                	<tr>
	                		<td align="left">
	                			<a href="javascript:change_tab_search('div_user')" onMouseOut="change_tab_img('div_user')" 
	                				onMouseOver="MM_swapImage('imgDivUser','','images/btt_user_over.gif',1)"><img id="imgDivUser" src="images/btt_user.gif" width="112" height="30" border="0"></a>
	                			<span style="display: <%=strDisplayFlag%>">	
	                			<a href="javascript:change_tab_search('div_group')" onMouseOut="change_tab_img('div_group')" 
	                				onMouseOver="MM_swapImage('imgDivGroup','','images/btt_usergroup_over.gif',1)"><img id="imgDivGroup" src="images/btt_usergroup.gif" width="112" height="30" border="0"></a>
                				</span>
	                		</td>
	                	</tr>
	                </table>
                </td>
              </tr>
              <tr> 
                <td><div align="center" >
                
                <!-- ########## START USER PERMIT ########## -->
                <div id="div_user" style="display:inline" >
                    <table width="780" border="0" cellpadding="0" cellspacing="0">
<%
    intclm = 3;

    String[] sortimg = new String[intclm+1];
    //String[] strrec  = new String[intclm+1];

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
<%
		String strTagOption    = "";
		String strZoomUserRole = "";
		String strZoomRoleName = "";
		strTagOption = "\n<select id=\"optUserRole\" name=\"optUserRole\" class=\"combobox\" onchange=\"getValueRole();\">";
		strTagOption += "\n<option value=\"\"></option>";
		
		con1.addData( "PROJECT_FLAG", "String", strProjectFlag );
		bolnZoomSuccess = con1.executeService( strContainerName, strClassName, "findUserRoleCombo" );
		
		if( bolnZoomSuccess ){
			while( con1.nextRecordElement() ){
				strZoomUserRole = con1.getColumn( "USER_ROLE" );
				strZoomRoleName  = con1.getColumn( "ROLE_NAME" );
				if( !strZoomUserRole.equals("00000001") ) {
					strTagOption += "\n<option value=\"" + strZoomUserRole + "\">" + strZoomRoleName + "</option>";
				}
			}
		}
		
		strTagOption += "\n</select>";
%>

                      <tr class="hd_table"> 
                        <td width="10"><img src="images/hd_tb_01.gif" width="10" height="28"></td>
                        <td width="30"><input type="checkbox" id="chkAllUser" name="chkAllUser" onclick="selectAllDocument('USER')" ></td>
                        <td width="100" align="center">
                        	<div align="center"><span id="lb_user_profile2_1"></span><%=sortimg[1]%></div>
                        </td>
                        <td width="180" align="center">
                        	<div align="center"><span id="lb_user_profile3_1"></span><%=sortimg[2]%></div>
                        </td>
                        <td width="200" align="center">
                        	<div align="center"><span id="lb_user_profile3"></span><%=sortimg[3]%></div>
                        </td>
                        <td width="140" align="center">
                        	<div align="center"><span id="lb_user_role2"></span></div>
                        </td>
                        <td width="110" align="center">
                        	<div align="center">&nbsp;</div>
                        </td>
                        <td width="10" align="right"><img src="images/hd_tb_04.gif" width="10" height="28"></td>
                      </tr>
<%
    if( bolnSuccess ) {
        intSeq       = 1;
        while( con.nextRecordElement() ){
            strFieldUserIdData    = con.getColumn( "USER_ID" );
            strFieldTitleNameData = con.getColumn( "TITLE_NAME" );
            strFieldUserNameData  = con.getColumn( "USER_NAME" );
            strFieldUserSnameData = con.getColumn( "USER_SNAME" );
            strFieldOrgNameData   = con.getColumn( "ORG_NAME" );
            strFullNameData       = strFieldTitleNameData + strFieldUserNameData + " " + strFieldUserSnameData;

            con2.addData( "PROJECT_CODE", "String", strProjectCode );
            con2.addData( "USER_ID",      "String", strFieldUserIdData );            
            boolean bolnSuccess2 = con2.executeService( strContainerName, strClassName, "findUserRolePermitUser" );
            if(bolnSuccess2){
                strFieldAccessTypeData = con2.getHeader( "ACCESS_TYPE" );
                strFieldAccDocTypeData = con2.getHeader( "ACCESS_DOC_TYPE" );
                strFieldUserRoleData = con2.getHeader( "USER_ROLE" );
                strFieldRoleNameData = con2.getHeader( "ROLE_NAME" );
            }else{
                strFieldAccessTypeData = "";
                strFieldAccDocTypeData = "";
                strFieldUserRoleData = "";
                strFieldRoleNameData = "";
            }
            
            strScript    = "USER_ID=\"" + strFieldUserIdData + "\" TITLE_NAME=\"" + strFieldTitleNameData + "\" USER_NAME=\"" + strFieldUserNameData + "\" ";
			strScript    += "USER_SNAME=\"" + strFieldUserSnameData + "\" ORG_NAME=\"" + strFieldOrgNameData + "\" ";
			strScript    += "USER_ROLE=\"" + strFieldUserRoleData + "\" ROLE_NAME=\"" + strFieldRoleNameData + "\" ";
			strScript    += "ACCESS_TYPE=\"" + strFieldAccessTypeData + "\" ACCESS_DOC_TYPE=\"" + strFieldAccDocTypeData + "\" ";
			if( !strFieldUserRoleData.equals("") ) {
				strbttEdit = "<a href=\"#\" onclick=\"buttonClick('role',this)\"" + strScript + " onMouseOut=\"MM_swapImgRestore()\" onMouseOver=\"MM_swapImage('EDIT" +intSeq+ "','','images/btt_doc_over.gif',1)\"><img src=\"images/btt_doc.gif\" name=\"EDIT" + intSeq + "\"  width=\"109\" height=\"18\" border=\"0\"></a>";
			}else {
				strbttEdit = "";
			}
			
			//strFieldConUserId   += strFieldUserIdData + ",";

            if( intSeq % 2 != 0 ) {
%>
                      
                      <tr class="table_data1">
                        <td>&nbsp;</td>
                        <td>
                        	<div align="center"><input type="checkbox" id="chkAllUser<%=intSeq%>" name="chkAllUser<%=intSeq%>" 
                        		onclick="chkbxClickValue()" ></div>
                        </td>
                        <td><div align="left"><%=strFieldUserIdData %><input type="hidden" id="hidUserId_<%=intSeq%>" value="<%=strFieldUserIdData %>"></div></td>
                        <td><div align="left"><%=strFullNameData %></div></td>
                        <td><div align="left"><%=strFieldOrgNameData %></div></td>
                        <td><div align="left"><%=strFieldRoleNameData %></div></td>
                        <td align="center"><%=strbttEdit %></td>
                        <td>&nbsp;</td>
                      </tr>
<%
            }else{
%>
                      <tr class="table_data2"> 
                        <td>&nbsp;</td>
                        <td>
                        	<div align="center"><input type="checkbox" id="chkAllUser<%=intSeq%>" name="chkAllUser<%=intSeq%>" 
                        		onclick="chkbxClickValue()" ></div>
                        </td>
                        <td><div align="left"><%=strFieldUserIdData %><input type="hidden" id="hidUserId_<%=intSeq%>" value="<%=strFieldUserIdData %>"></div></td>
                        <td><div align="left"><%=strFullNameData %></div></td>
                        <td><div align="left"><%=strFieldOrgNameData %></div></td>
                        <td><div align="left"><%=strFieldRoleNameData %></div></td>
                        <td align="center"><%=strbttEdit %></td>
                        <td>&nbsp;</td>
                      </tr>
<%
            }
            intSeq++;
        }
     }
 %>                      
                    </table>
                    <table width="780" height="28" border="0" align="center" cellpadding="0" cellspacing="0">
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
                    
                     
                  </div>
                  <!-- ########## END OF USER PERMIT ########## -->
                  
                  <!-- #################################################################################################### -->
                  
                  <!-- ########## START USER GROUP PERMIT ########## -->
                  <div id="div_group" style="display:inline" >
                    <table width="780" border="0" cellpadding="0" cellspacing="0">
<%
    intclm2 = 2;

    String[] sortimg2 = new String[intclm2+1];
    //String[] strrec2  = new String[intclm2+1];

    for( j=1; j<=intclm2; j++ ) {
        sortimg2[j] = "";
    }

    if( searchmod2 ) {
        if ( sortfield2.equals("0") ) {
            for( j=1; j<=intclm2; j++ ) {
                sortimg2[j]="<img src=\"images/updown.gif\" onclick=\"sortsearch2('ASC',"+j+")\" name=\"img1\" style=\"cursor:pointer\">";
            }
        }else {
            intfield2=Integer.parseInt( sortfield2 );
            for( j=1; j<=intclm2; j++ ) {
                if ( j==intfield2 ) {
                    if ( sortby2.equals("ASC") ) {
                        sortimg2[j]="<img src=\"images/sort_down.gif\" onclick=\"sortsearch2('DESC',"+j+")\" name=\"img1\" style=\"cursor:pointer\">";
                    }else {
                        sortimg2[j]="<img src=\"images/sort_up.gif\" onclick=\"sortsearch2('ASC',"+j+")\" name=\"img1\" style=\"cursor:pointer\">";
                    }
                }else {
                    sortimg2[j]="<img src=\"images/updown.gif\" onclick=\"sortsearch2('ASC',"+j+")\" name=\"img1\" style=\"cursor:pointer\">";
                }
            }
        }
    }
%>
                      <tr>
                        <td colspan="7"><BR></td>
                      </tr>
                      <tr class="hd_table"> 
                        <td width="10"><img src="images/hd_tb_01.gif" width="10" height="28"></td>
                        <td width="30"><input type="checkbox" id="chkAllGroup" name="chkAllGroup" onclick="selectAllDocument('GROUP')" ></td>
                        <td width="100" align="center">
                        	<div align="center"><span id="lb_code"></span><%=sortimg2[1]%></div>
                        </td>
                        <td width="200" align="center">
                        	<div align="center"><span id="lb_group_name"></span><%=sortimg2[2]%></div>
                        </td>
                        <td width="210" align="center">
                        	<div align="center"><span id="lb_user_role"></span></div>
                        </td>
                        <td width="110" align="center">
                        	<div align="center">&nbsp;</div>
                        </td>
                        <td width="110" align="center">
                        	<div align="center">&nbsp;</div>
                        </td>
                        <td width="10" align="right"><img src="images/hd_tb_04.gif" width="10" height="28"></td>
                      </tr>
<%
    if( bolnGroup ) {
        intSeq2 = 1;
        while( conGroup.nextRecordElement() ){
        	strFieldUserGroupData = conGroup.getColumn( "USER_GROUP" );
            strFieldGroupNameData = conGroup.getColumn( "GROUP_NAME" );

            conGroup2.addData( "PROJECT_CODE", "String", strProjectCode );
            conGroup2.addData( "USER_GROUP",   "String", strFieldUserGroupData );            
            boolean bolnGroup2 = conGroup2.executeService( strContainerName, strClassName, "findUserRolePermitGroup" );
            if(bolnGroup2){
                strFieldAccessType2Data = conGroup2.getHeader( "ACCESS_TYPE" );
                strFieldAccDocType2Data = conGroup2.getHeader( "ACCESS_DOC_TYPE" );
                strFieldUserRole2Data   = conGroup2.getHeader( "USER_ROLE" );
                strFieldRoleName2Data   = conGroup2.getHeader( "ROLE_NAME" );
           }
                        
            strScript      = "GROUP_NAME=\"" + strFieldGroupNameData + "\" USER_GROUP=\"" + strFieldUserGroupData + "\" ";
            strScript      += "USER_ROLE=\"" + strFieldUserRoleData + "\" ROLE_NAME=\"" + strFieldRoleName2Data + "\" ";
			strScript      += "ACCESS_TYPE=\"" + strFieldAccessType2Data + "\" ACCESS_DOC_TYPE=\"" + strFieldAccDocType2Data + "\" ";
			strbttUserList = "<a href=\"#\" onclick=\"buttonClick('list',this)\"" + strScript + " onMouseOut=\"MM_swapImgRestore()\" onMouseOver=\"MM_swapImage('LIST" +intSeq2+ "','','images/btt_userlist_over.gif',1)\"><img src=\"images/btt_userlist.gif\" name=\"LIST" + intSeq2 + "\"  width=\"109\" height=\"18\" border=\"0\"></a>";
			if( !strFieldUserRole2Data.equals("") ) {
				strbttEdit = "<a href=\"#\" onclick=\"buttonClick('group',this)\"" + strScript + " onMouseOut=\"MM_swapImgRestore()\" onMouseOver=\"MM_swapImage('EDIT2" +intSeq2+ "','','images/btt_doc_over.gif',1)\"><img src=\"images/btt_doc.gif\" name=\"EDIT2" + intSeq2 + "\"  width=\"109\" height=\"18\" border=\"0\"></a>";
			}else {
				strbttEdit = "";
			}

            if( intSeq2 % 2 != 0 ) {
%>
                      
                      <tr class="table_data1">
                        <td>&nbsp;</td>
                        <td>
                        	<div align="center"><input type="checkbox" id="chkAllGroup<%=intSeq2%>" name="chkAllGroup<%=intSeq2%>" 
                        		onclick="chkbxClickValue()" ></div>
                        </td>
                        <td><div align="left"><%=strFieldUserGroupData %><input type="hidden" id="hidUserGroup_<%=intSeq2%>" value="<%=strFieldUserGroupData %>"></div></td>
                        <td><div align="left"><%=strFieldGroupNameData %></div></td>
                        <td><div align="left"><%=strFieldRoleName2Data %></div></td>
                        <td align="center"><%=strbttUserList %></td>
                        <td align="center"><%=strbttEdit %></td>
                        <td>&nbsp;</td>
                      </tr>
<%
            }else{
%>
                      <tr class="table_data2"> 
                        <td>&nbsp;</td>
                        <td>
                        	<div align="center"><input type="checkbox" id="chkAllGroup<%=intSeq2%>" name="chkAllGroup<%=intSeq2%>" 
                        		onclick="chkbxClickValue()" ></div>
                        </td>
                        <td><div align="left"><%=strFieldUserGroupData %><input type="hidden" id="hidUserGroup_<%=intSeq2%>" value="<%=strFieldUserGroupData %>"></div></td>
                        <td><div align="left"><%=strFieldGroupNameData %></div></td>
                        <td><div align="left"><%=strFieldRoleName2Data %></div></td>
                        <td align="center"><%=strbttUserList %></td>
                        <td align="center"><%=strbttEdit %></td>
                        <td>&nbsp;</td>
                      </tr>
<%
            }
            intSeq2++;
        }
     }
 %>                      
                    </table>
                    <table width="780" height="28" border="0" align="center" cellpadding="0" cellspacing="0">
	                    <tr class="footer_table">
	                        <td width="68%" align="left" >&nbsp;&nbsp;<span id="lb_total_record2"></span>&nbsp;&nbsp;<%=strTotalSize2%>&nbsp;&nbsp;<span id="lb_record2"></span></td>
	                        <td width="4%" height="28" align="right">
	                            <a href="#" name="firstP" onClick="navigatorClick2('firstP');">
	                                <img src="images/first.gif" width="22" height="22" border="0"></a>
	                        </td>
	                        <td width="4%" height="28" align="right">
	                            <a href="#" name="previousP" onClick="navigatorClick2('previousP');">
	                                <img src="images/prv.gif" width="22" height="22" border="0"></a>
	                        </td>
	                        <td width="16%" height="28" align="center">
	                            <input name="CURRENT_PAGE_2" type="text" class="input_box_disable" style="text-align:center" size="3" value="<%=strCurrentPage2%>" readonly>/
	                            <input name="TOTAL_PAGE_2" type="text" class="input_box_disable" style="text-align:center" size="3" value="<%=strTotalPage2%>" readonly>
	                        </td>
	                        <td width="4%" height="28">
	                            <a href="#" name="nextP" onClick="navigatorClick2('nextP');">
	                                <img src="images/next.gif" width="22" height="22" border="0"></a>
	                        </td>
	                        <td width="4%" height="28">
	                            <a href="#" name="lastP" onClick="navigatorClick2('lastP');"><img src="images/last.gif" width="22" height="22" border="0"></a>
	                            <span id="lb_from"></span>
	                        </td>
	                    </tr>
	                </table>
                  </div>
                  <!-- ########## END USER GROUP PERMIT ########## -->
                  
                    <table width="780" border="0" cellpadding="0" cellspacing="0" class="label_bold4">
	              		<tr>
	              			<td height="10"></td>
	              			<td colspan="3" align="left">
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
							<td colspan="3" align="right" valign="middle">
								<span class="label_bold2" id="lb_user_role1"></span>&nbsp;&nbsp;<%=strTagOption %>&nbsp;&nbsp;
								<a href="javascript:buttonClick('permit')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('permit','','images/btt_commitrights_over.gif',1)">
                                                                    <img src="images/btt_commitrights.gif" id="permit" name="permit" width="67" height="22" border="0" style="display: none;"></a>
			                    <a href="javascript:buttonClick('unpermit')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('unpermit','','images/btt_cancelright_over.gif',1)">
                                                <img src="images/btt_cancelright.gif" id="unpermit" name="unpermit" width="102" height="22" border="0" style="display: none"></a>
							</td>
	              		</tr>
	              </table>
                    <p>
                    <a id="liSearch" href="javascript:buttonClick('search')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('search','','images/btt_search_over.gif',1)">
                    	<img src="images/btt_search.gif" id="search" name="search" width="67" height="22" border="0" style="display: none"></a>
                    </p>
                  </div>
                <br>
                <br>
                </td>
              </tr>
            </table>
			<input type="hidden" name="MODE"         value="<%=strMode%>">
			<input type="hidden" name="screenname"   value="<%=screenname%>">
			<input type="hidden" name="PROJECT_CODE" value="<%=strProjectCode%>">
			<input type="hidden" name="sortby"       value="<%=sortby%>">
			<input type="hidden" name="sortfield"    value="<%=sortfield%>">
			<input type="hidden" name="sortby2"      value="<%=sortby2%>">
			<input type="hidden" name="sortfield2"   value="<%=sortfield2%>">
			
			<input type="hidden" id="DISPLAY"              name="DISPLAY"              value="<%=strDisplay %>">
			<input type="hidden" id="mode_parent"          name="mode_parent"          value="<%=strMode%>">
			<input type="hidden" id="sortby_parent"        name="sortby_parent"        value="<%=sortby%>">
			<input type="hidden" id="sortfield_parent"     name="sortfield_parent"     value="<%=sortfield%>">
			<input type="hidden" id="current_page_parent"  name="current_page_parent"  value="<%=strCurrentPage%>">
			<input type="hidden" id="sortby_parent2"       name="sortby_parent2"       value="<%=sortby2%>">
			<input type="hidden" id="sortfield_parent2"    name="sortfield_parent2"    value="<%=sortfield2%>">
			<input type="hidden" id="current_page_parent2" name="current_page_parent2" value="<%=strCurrentPage2%>">
			
			<input type="hidden" id="seqn"            name="seqn"         value="<%=intSeq %>">
			<input type="hidden" id="seqn2"           name="seqn2"        value="<%=intSeq2 %>">
			<input type="hidden" id="hidConUserId"    name="hidConUserId" value="">
			<input type="hidden" id="hidUserRole"     name="hidUserRole"  value="">
			
			<input type="hidden" name="user_role"         value="<%=user_role %>">
			<input type="hidden" name="app_name"          value="<%=app_name %>">
			<input type="hidden" name="app_group"         value="<%=app_group %>">
			
			<input type="hidden" name="USER_ID_SEARCH"    value="<%=strFieldUserIdSearch%>">
			<input type="hidden" name="USER_NAME_SEARCH"  value="<%=strFieldUserNameSearch%>">
			<input type="hidden" name="USER_SNAME_SEARCH" value="<%=strFieldUserSnameSearch%>">
			<input type="hidden" name="ORG_CODE_SEARCH"   value="<%=strFieldOrgCodeSearch%>">
			
			<input type="hidden" id="USER_ID_KEY"          name="USER_ID_KEY"          value="">
			<input type="hidden" id="USER_FNAME_KEY"       name="USER_FNAME_KEY"       value="">
			<input type="hidden" id="USER_GROUP_KEY"       name="USER_GROUP_KEY"       value="">
			<input type="hidden" id="GROUP_NAME_KEY"       name="GROUP_NAME_KEY"       value="">
			<input type="hidden" id="PROJECT_CODE_KEY"     name="PROJECT_CODE_KEY"     value="">
			<input type="hidden" id="PROJECT_NAME_KEY"     name="PROJECT_NAME_KEY"     value="">
			<input type="hidden" id="ACCESS_TYPE_KEY"      name="ACCESS_TYPE_KEY"      value="">
			<input type="hidden" id="ACCESS_DOC_TYPE_KEY"  name="ACCESS_DOC_TYPE_KEY"  value="">
			<input type="hidden" id="USER_ROLE_KEY"        name="USER_ROLE_KEY"        value="">
			<input type="hidden" id="ROLE_NAME_KEY"        name="ROLE_NAME_KEY"        value="">
			<input type="hidden" id="PAGE_KEY"             name="PAGE_KEY"             value="">
		</td>
    </tr>
</table>
            </div>
		</td>
    </tr>
</table>
</form>
</body>
</html>
<script language="JavaScript" type="text/javascript">
<!--

var obj_bttPermit    = document.getElementById( "permit" );
var obj_bttUnpermit  = document.getElementById( "unpermit" );
var obj_bttSearch    = document.getElementById( "search" );
var obj_chkAllUser   = document.getElementById( "chkAllUser" );
var obj_intSeqn      = document.getElementById( "seqn" );
var obj_ConUserId    = document.getElementById( "hidConUserId" );
var obj_hidUserRole  = document.getElementById( "hidUserRole" );
var obj_display      = document.getElementById( "DISPLAY" );
var obj_chkAllGroup  = document.getElementById( "chkAllGroup" );
var obj_intSeqn2     = document.getElementById( "seqn2" );
var obj_div_user     = document.getElementById( "div_user" );
var obj_div_group    = document.getElementById( "div_group" );
var obj_liSearch     = document.getElementById( "liSearch" );

//-->
</script>
