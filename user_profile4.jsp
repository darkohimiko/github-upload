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
<%
	con.setRemoteServer("EAS_SERVER");
	con1.setRemoteServer("EAS_SERVER");
	con2.setRemoteServer("EAS_SERVER");

	UserInfo userInfo     = (UserInfo)session.getAttribute( "USER_INFO" );
	String strUserId      = userInfo.getUserId();
	String strProjectCode = userInfo.getProjectCode();
	
	String user_role = getField(request.getParameter("user_role"));
	String app_name  = getField(request.getParameter("app_name"));
	String app_group = getField(request.getParameter("app_group"));
	
	String screenname   = getField(request.getParameter("screenname"));
	String strClassName = "USER_PROFILE";
	
	String strCurrentPage = request.getParameter( "CURRENT_PAGE" );
	String strPageSize    = request.getParameter( "PAGE_SIZE" );
	if( strCurrentPage == null || Integer.parseInt( strCurrentPage ) == 0 ) {
	    strCurrentPage = "1";
	}
	if( strPageSize == null || Integer.parseInt( strPageSize ) == 0 ) {
		strPageSize = "10";
	}
	boolean bolnSuccess     = true;
	boolean bolnSuccess2    = true;
	boolean bolnZoomSuccess = true;
    boolean searchmod       = false;
	
	String strmsg          = "";
	
	int intSeq   = 0;
	int i        = 0;
    int intfield = 0;
    int intclm   = 0;

    String strUserIdKey    = getField(request.getParameter( "USER_ID_KEY" ));
    String strUserFnameKey = getField(request.getParameter( "USER_FNAME_KEY" ));
    String strProjCodeData = getField(request.getParameter( "hidConProjCode" ));
    String strUserRoleData = getField(request.getParameter( "hidUserRole" ));
    String strDspTypeData  = getField(request.getParameter( "hidDspType" ));
    
    if( strDspTypeData.equals("") || strDspTypeData == null ) {
    	strDspTypeData = "user";
    }

	String strMode                  = getField( request.getParameter("MODE") );
    String mode_parent              = getField(request.getParameter( "mode_parent" ));
    String current_page_parent      = getField(request.getParameter( "current_page_parent" ));
    String sortby_parent            = getField(request.getParameter( "sortby_parent" ));
    String sortfield_parent         = getField(request.getParameter( "sortfield_parent" ));
    String strFieldUserIdSearch     = getField(request.getParameter( "USER_ID_SEARCH" ));
    String strFieldUserNameSearch   = getField(request.getParameter( "USER_NAME_SEARCH" ));
    String strFieldUserSnameSearch  = getField(request.getParameter( "USER_SNAME_SEARCH" ));
    String strFieldUserLevelSearch  = getField(request.getParameter( "USER_LEVEL_SEARCH" ));
    String strFieldOrgCodeSearch    = getField(request.getParameter( "ORG_CODE_SEARCH" ));
    String strFieldUserStatusSearch = getField(request.getParameter( "USER_STATUS_SEARCH" ));
        
    String strFieldProjectNameData = "";
    String strFieldProjectCodeData = "";
    String strFieldOrgNameData     = "";
    String strFieldUserRoleData    = "";
    String strFieldRoleNameData    = "";
    String strFieldAccessTypeData  = "";
    String strFieldAccDocTypeData  = "";
    
	String strScript      = "";
	String strbttEdit     = "";
    String strTotalPage   = "1";
    String strTotalSize   = "0";
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
    
    if( strMode.equals("PERMIT") ) {
    	con.addData( "USER_ID",      "String", strUserIdKey );
    	con.addData( "PROJECT_CODE", "String", strProjCodeData );
    	con.addData( "USER_ROLE",    "String", strUserRoleData );
        con.addData( "ADD_USER",     "String", strUserId);
        con.addData( "ADD_DATE",     "String", strCurrentDate);
        con.addData( "UPD_USER",     "String", strUserId);
		bolnSuccess = con.executeService( strContainerName, strClassName, "commitRightsUserProfile" );
		if( !bolnSuccess ){
                    strmsg  = "showMsg(0,0,\" " + lc_can_not_update_data + "\")";
                    strMode = "SEARCH";
		}else{
		    strmsg  = "showMsg(0,0,\" " + lc_update_data_successfull + "\")";
		    strMode = "SEARCH";
		}
	}
    
    if( strMode.equals("UNPERMIT") ) {
    	con.addData( "USER_ID",      "String", strUserIdKey );
    	con.addData( "PROJECT_CODE", "String", strProjCodeData );
    	con.addData( "ADD_USER",     "String", strUserId);
        con.addData( "ADD_DATE",     "String", strCurrentDate);
        con.addData( "UPD_USER",     "String", strUserId);
		bolnSuccess = con.executeService( strContainerName, strClassName, "cancelRightUserProfile" );
		if( !bolnSuccess ){
			strmsg  = "showMsg(0,0,\" " + lc_can_not_update_data + "\")";
			strMode = "SEARCH";
		}else{
		    strmsg  = "showMsg(0,0,\" " + lc_update_data_successfull + "\")";
		    strMode = "SEARCH";
		}
	}
    
            
    if( strMode.equals("SEARCH") || strMode.equals("FIND") ) {
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
        if( strDspTypeData.equals("admin") ) {
        	con.addData( "CONDITION", "String", "A.PROJECT_FLAG='1' " );
        }else {
        	con.addData( "CONDITION", "String", "A.PROJECT_FLAG<>'1' " );
        }
        bolnSuccess = con.executeService( strContainerName, strClassName, "findUserProfilePermit" );
        
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
    var per_page = '<%=strPageSize %>';
    var dsp_type = "<%=strDspTypeData %>";
    
	lb_user_id_name.innerHTML  = lbl_user_id_name;
	lb_group_cabinet.innerHTML = lbl_group_cabinet;
	lb_user_role4_1.innerHTML  = lbl_user_role4_1;
    lb_user_role1.innerHTML    = lbl_user_role2;
    lb_doc_cabinet.innerHTML   = lbl_doc_cabinet;
    lb_user_cabinet.innerHTML  = lbl_user_cabinet;
    lb_user_role2.innerHTML    = lbl_user_role2;
    lb_total_record.innerHTML  = lbl_total_record;
    lb_record.innerHTML        = lbl_record;

	form1.PAGE_SIZE.value = per_page;
	if( dsp_type == "user" ) {
		obj_rdoDspType[0].checked = true;
	}else {
		obj_rdoDspType[1].checked = true;
	}
	obj_hidDspType.value = dsp_type;
        
        set_background();
}

function concatAllUserId(){
	var strConUserId  = "";
	var strFullUserId = "";
	var strUserId     = "hidProjCode_";
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
	obj_hidConProjCode.value = strConUserId;
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

function buttonClick( lv_strMethod, lv_strValue ){
	switch( lv_strMethod ){
		case "permit" :
			concatAllUserId();
			if( obj_hidUserRole.value == "" ) {
				alert( lc_select_right );
				return;
			}
			if( obj_hidConProjCode.value == "" ) {
				alert( lc_select_cabinet );
				return;
			}
			form1.action     = "user_profile4.jsp";
			form1.MODE.value = "PERMIT";
			form1.submit();
			break;
        case "unpermit" :
                concatAllUserId();
                if( obj_hidConProjCode.value == "" ) {
                        alert( lc_select_cabinet );
                        return;
                }
                form1.action     = "user_profile4.jsp";
                form1.MODE.value = "UNPERMIT";
                form1.submit();
                break;
        case "role" :
        	form1.PROJECT_CODE_KEY.value    = lv_strValue.getAttribute("PROJECT_CODE");
                form1.PROJECT_NAME_KEY.value    = lv_strValue.getAttribute("PROJECT_NAME");
                form1.ACCESS_TYPE_KEY.value     = lv_strValue.getAttribute("ACCESS_TYPE");
                form1.ACCESS_DOC_TYPE_KEY.value = lv_strValue.getAttribute("ACCESS_DOC_TYPE");
                form1.USER_ROLE_KEY.value       = lv_strValue.getAttribute("USER_ROLE");
                form1.ROLE_NAME_KEY.value       = lv_strValue.getAttribute("ROLE_NAME");
                form1.PAGE_KEY.value            = "user_profile4.jsp";
                form1.action                    = "user_profile5.jsp";
                form1.target                    = "_self";
                form1.MODE.value                = "SEARCH";
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
                    form1.action             = "user_profile1.jsp";
                    form1.target 	     = "_self";
		    form1.CURRENT_PAGE.value = form1.current_page_parent.value;
                    form1.sortfield.value    = form1.sortfield_parent.value;
                    form1.sortby.value       = form1.sortby_parent.value;
		    form1.MODE.value         = form1.mode_parent.value;
		    form1.submit();
                    break;
	}
}

function getRadioValue( lv_type ) {
	obj_hidDspType.value = lv_type;
	form1.submit();
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
<body onLoad="MM_preloadImages('images/btt_commitrights_over.gif','images/btt_cancelright_over.gif','images/btt_back_over.gif');window_onload();" onsize="set_background()">
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
                <td height="25" class="label_header01" >&nbsp;&nbsp;<%=screenname%>&nbsp;<%=lb_user_group_permit %></td>
              </tr>
              <tr> 
                <td><div align="center">
                    <table width="756" border="0" cellpadding="0" cellspacing="0">
<%
    intclm = 3;

    String[] sortimg = new String[intclm+1];

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
                        <td colspan="7"><BR></td>
                      </tr>
                      <tr>
                        <td colspan="7" class="label_bold4">
							<div align="left">
			                	<span id="lb_user_id_name"></span>:&nbsp;<%=strUserIdKey %>&nbsp;&nbsp;<%=strUserFnameKey %>
			                </div>
			            </td>
                      </tr>
                      <tr>
                        <td colspan="7"><BR></td>
                      </tr>
                      <tr>
                        <td colspan="3" class="label_bold4">
                      		<input type="radio" id="rdoDspType" name="rdoDspType" onclick="getRadioValue('user');"><span id="lb_group_cabinet"></span>
                      	</td>
                        <td colspan="4" class="label_bold4">
	                      	<input type="radio" id="rdoDspType" name="rdoDspType" onclick="getRadioValue('admin');"><span id="lb_user_role4_1"></span>
	                    </td>
                      </tr>
                      <tr>
                        <td colspan="7">&nbsp;</td>
                      </tr>
<%
		String strTagOption    = "";
		String strZoomUserRole = "";
		String strZoomRoleName = "";
		strTagOption = "\n<select id=\"optUserRole\" name=\"optUserRole\" class=\"combobox\" onchange=\"getValueRole();\">";
		strTagOption += "\n<option value=\"\"></option>";
		
		if( strDspTypeData.equals("admin") ) {
			con1.addData( "ROLE_TYPE", "String", "A" );
		}else {
			con1.addData( "ROLE_TYPE", "String", "U" );
		}
		bolnZoomSuccess = con1.executeService( strContainerName, strClassName, "findUserRoleCombo" );
		
		if( bolnZoomSuccess ){
			while( con1.nextRecordElement() ){
				strZoomUserRole = con1.getColumn( "USER_ROLE" );
				strZoomRoleName = con1.getColumn( "ROLE_NAME" );
		
				strTagOption += "\n<option value=\"" + strZoomUserRole + "\">" + strZoomRoleName + "</option>";
			}
		}
		
		strTagOption += "\n</select>";
%>

                      <tr class="hd_table"> 
                        <td width="10"><img src="images/hd_tb_01.gif" width="10" height="28"></td>
                        <td width="30"><input type="checkbox" id="chkAllCheck" name="chkAllCheck" onclick="chkAllUserId()" ></td>
                        <td width="200" align="center">
                        	<div align="left"><span id="lb_doc_cabinet"></span><%=sortimg[1]%></div>
                        </td>
                        <td width="305" align="center">
                        	<div align="left"><span id="lb_user_cabinet"></span><%=sortimg[2]%></div>
                        </td>
                        <td width="150" align="center">
                        	<div align="left"><span id="lb_user_role2"></span></div>
                        </td>
                        <td align="center"><div align="left">&nbsp;</div></td>
                        <td align="right"><img src="images/hd_tb_04.gif" width="10" height="28"></td>
                      </tr>
<%
    if( (bolnSuccess) ) {
        intSeq       = 1;
        while( con.nextRecordElement() ){
            strFieldProjectNameData = con.getColumn( "PROJECT_NAME" );
            strFieldOrgNameData     = con.getColumn( "ORG_NAME" );
            strFieldProjectCodeData = con.getColumn( "PROJECT_CODE" );

            con2.addData( "PROJECT_CODE", "String", strFieldProjectCodeData );
            con2.addData( "USER_ID",      "String", strUserIdKey );            
            bolnSuccess2 = con2.executeService( strContainerName, strClassName, "findUserRoleName" );
            if(bolnSuccess2){
                strFieldUserRoleData = con2.getHeader( "USER_ROLE" );
                strFieldRoleNameData = con2.getHeader( "ROLE_NAME" );
                strFieldAccessTypeData = con2.getHeader( "ACCESS_TYPE" );
            strFieldAccDocTypeData = con2.getHeader( "ACCESS_DOC_TYPE" );
            }else{
                strFieldUserRoleData = "";
                strFieldRoleNameData = "";
                strFieldAccessTypeData = "";
                strFieldAccDocTypeData = "";
            }
            
            strScript = "PROJECT_NAME=\"" + strFieldProjectNameData + "\" ORG_NAME=\"" + strFieldOrgNameData + "\" PROJECT_CODE=\"" + strFieldProjectCodeData + "\" ";
			strScript += "USER_ROLE=\"" + strFieldUserRoleData + "\" ROLE_NAME=\"" + strFieldRoleNameData + "\" ";
			strScript += "ACCESS_TYPE=\"" + strFieldAccessTypeData + "\" ACCESS_DOC_TYPE=\"" + strFieldAccDocTypeData + "\" ";
			if( !strFieldRoleNameData.equals("") ) {
                            if(!strDspTypeData.equals("admin")){
				strbttEdit = "<a href=\"#\" onclick=\"buttonClick('role',this)\"" + strScript + " onMouseOut=\"MM_swapImgRestore()\" onMouseOver=\"MM_swapImage('EDIT" +intSeq+ "','','images/btt_doc_over.gif',1)\"><img src=\"images/btt_doc.gif\" name=\"EDIT" + intSeq + "\"  height=\"18\" border=\"0\"></a>";
                            }else{
                                strbttEdit = "";
                            }
			}else {
                            strbttEdit = "";
			}
			
            if( intSeq % 2 != 0 ) {
%>
                      
                      <tr class="table_data1">
                        <td>&nbsp;</td>
                        <td>
                        	<div align="center"><input type="checkbox" id="chkAllCheck<%=intSeq%>" name="chkAllCheck<%=intSeq%>" 
                        		onclick="chkbxClickValue()" ></div>
                        </td>
                        <td><div align="left"><%=strFieldProjectNameData %><input type="hidden" id="hidProjCode_<%=intSeq%>" value="<%=strFieldProjectCodeData %>"></div></td>
                        <td><div align="left"><%=strFieldOrgNameData %></div></td>
                        <td><div align="left"><%=strFieldRoleNameData %></div></td>
                        <td><div align="center">&nbsp;<%=strbttEdit %></div></td>
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
                        <td><div align="left"><%=strFieldProjectNameData %><input type="hidden" id="hidProjCode_<%=intSeq%>" value="<%=strFieldProjectCodeData %>"></div></td>
                        <td><div align="left"><%=strFieldOrgNameData %></div></td>
                        <td><div align="left"><%=strFieldRoleNameData %></div></td>
                        <td><div align="center">&nbsp;<%=strbttEdit %></div></td>
                        <td>&nbsp;</td>
                      </tr>
<%
            }
            intSeq++;
        }
     }
 %>                      
 					</div>
                    </table>
                    <table width="756" height="28" border="0" align="center" cellpadding="0" cellspacing="0">
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
	                <br>
					<table width="756" border="0" cellpadding="0" cellspacing="0" class="label_bold2">
						<tr>
							<td colspan="3" align="left" valign="middle"><%=lb_page_per_size %> : 
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
			                	<a href="#" onclick= "buttonClick('permit')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('permit','','images/btt_commitrights_over.gif',1)">
			                    	<img src="images/btt_commitrights.gif" id="permit" name="permit" width="67" height="22" border="0" ></a>
			                    <a href="#" onclick= "buttonClick('unpermit')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('unpermit','','images/btt_cancelright_over.gif',1)">
			                    	<img src="images/btt_cancelright.gif" id="unpermit" name="unpermit" width="102" height="22" border="0" ></a>
			                </td>
		              	</tr>
					</table>
                    <p>
		           		<a href="#" onclick= "buttonClick('cancel')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('back','','images/btt_back_over.gif',1)">
		           			<img src="images/btt_back.gif" name="back" width="67" height="22" border="0"></a>
                    </p>
              	</div></td>
              </tr>
            </table>
            <input type="hidden" name="MODE"         value="<%=strMode%>">
			<input type="hidden" name="screenname"   value="<%=screenname%>">
			<input type="hidden" name="PROJECT_CODE" value="<%=strProjectCode%>">
			<input type="hidden" name="sortby"       value="<%=sortby%>">
			<input type="hidden" name="sortfield"    value="<%=sortfield%>">
			
			<input type="hidden" id="seqn"            name="seqn"            value="<%=intSeq%>">
			<input type="hidden" id="USER_ID_KEY"     name="USER_ID_KEY"     value="<%=strUserIdKey%>">
			<input type="hidden" id="USER_FNAME_KEY"  name="USER_FNAME_KEY"  value="<%=strUserFnameKey%>">
			<input type="hidden" id="hidConProjCode"  name="hidConProjCode"  value="">
			<input type="hidden" id="hidUserRole"     name="hidUserRole"     value="">
			<input type="hidden" id="hidDspType"      name="hidDspType"      value="<%=strDspTypeData %>">
			
			<input type="hidden" id="PROJECT_CODE_KEY"    name="PROJECT_CODE_KEY"    value="">
			<input type="hidden" id="PROJECT_NAME_KEY"    name="PROJECT_NAME_KEY"    value="">
			<input type="hidden" id="ACCESS_TYPE_KEY"     name="ACCESS_TYPE_KEY"     value="">
			<input type="hidden" id="ACCESS_DOC_TYPE_KEY" name="ACCESS_DOC_TYPE_KEY" value="">
			<input type="hidden" id="USER_ROLE_KEY"       name="USER_ROLE_KEY"       value="">
			<input type="hidden" id="ROLE_NAME_KEY"       name="ROLE_NAME_KEY"       value="">
			<input type="hidden" id="PAGE_KEY"            name="PAGE_KEY"            value="">
			
			<input type="hidden" id="mode_parent"         name="mode_parent"         value="<%=mode_parent%>">
			<input type="hidden" id="current_page_parent" name="current_page_parent" value="<%=current_page_parent%>">
			<input type="hidden" id="sortby_parent"       name="sortby_parent"       value="<%=sortby_parent%>">
			<input type="hidden" id="sortfield_parent"    name="sortfield_parent"    value="<%=sortfield_parent%>">
			
			<input type="hidden" id="USER_ID_SEARCH"     name="USER_ID_SEARCH"     value="<%=strFieldUserIdSearch %>">
			<input type="hidden" id="USER_NAME_SEARCH"   name="USER_NAME_SEARCH"   value="<%=strFieldUserNameSearch %>">
			<input type="hidden" id="USER_SNAME_SEARCH"  name="USER_SNAME_SEARCH"  value="<%=strFieldUserSnameSearch %>">
			<input type="hidden" id="USER_LEVEL_SEARCH"  name="USER_LEVEL_SEARCH"  value="<%=strFieldUserLevelSearch %>">
			<input type="hidden" id="ORG_CODE_SEARCH"    name="ORG_CODE_SEARCH"    value="<%=strFieldOrgCodeSearch %>">
			<input type="hidden" id="USER_STATUS_SEARCH" name="USER_STATUS_SEARCH" value="<%=strFieldUserStatusSearch %>">
			
			<input type="hidden" name="user_role"    value="<%=user_role %>">
			<input type="hidden" name="app_name"     value="<%=app_name %>">
			<input type="hidden" name="app_group"    value="<%=app_group %>">
        <p>&nbsp;</p> </td>
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

var obj_bttPermit      = document.getElementById( "permit" );
var obj_bttUnpermit    = document.getElementById( "unpermit" );
var obj_bttSearch      = document.getElementById( "search" );
var obj_chkAllCheck    = document.getElementById( "chkAllCheck" );
var obj_intSeqn        = document.getElementById( "seqn" );
var obj_hidConProjCode = document.getElementById( "hidConProjCode" );
var obj_hidUserRole    = document.getElementById( "hidUserRole" );
var obj_hidDspType     = document.getElementById( "hidDspType" );
var obj_rdoDspType     = document.getElementsByName( "rdoDspType" );

//-->
</script>
<%  if (!strmsg.equals("")) {  %>
<script language="javaScript">
    <%=strmsg%>
</script>
<%  }   %>