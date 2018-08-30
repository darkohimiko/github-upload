<%@page import="com.scc.edms.conf.ImageConfUtil"%>
<%@ page contentType="text/html; charset=tis-620"%>
<%@ page import="com.scc.security.UserInfo"%>
<%@ include file="inc/checkUser.jsp" %>
<%@ include file="inc/constant.jsp" %>
<%@ include file="inc/label.jsp" %>
<%@ include file="inc/utils.jsp" %>
<jsp:useBean id="con" scope="session" class="edms.cllib.EABConnector"/>
<jsp:useBean id="con2" scope="session" class="edms.cllib.EABConnector"/>
<jsp:useBean id="con3" scope="session" class="edms.cllib.EABConnector"/>
<jsp:useBean id="con4" scope="session" class="edms.cllib.EABConnector"/>
<%
	con.setRemoteServer("EAS_SERVER");
	con2.setRemoteServer("EAS_SERVER");
	con3.setRemoteServer("EAS_SERVER");
	con4.setRemoteServer("EAS_SERVER");

	UserInfo userInfo     = (UserInfo)session.getAttribute( "USER_INFO" );
	String strUserId      = userInfo.getUserId();
	String strProjectCode = userInfo.getProjectCode();
	
	String screenname        = getField(request.getParameter("screenname"));
	String strClassName      = "USER_PROFILE";
	String strClassUserGroup = "USER_GROUP";
	String strMode           = getField(request.getParameter("MODE"));
	String strDisplay        = getField( request.getParameter("DISPLAY") );

	boolean bolnSuccess     = false;
	boolean bolnSuccess2    = false;
	boolean bolnSuccess3    = false;
	boolean bolnSuccess4    = false;
    boolean searchmod       = false;
    
	String strmsg          = "";
	
	int intSeq   = 0;
	int intSeq2  = 0;
	int i        = 0;
    int intfield = 0;
    int intclm   = 0;

    String strUserIdKey        = getField( request.getParameter("USER_ID_KEY") );
    String strUserFnameKey     = getField( request.getParameter("USER_FNAME_KEY") );
    String strProjectCodeKey   = getField( request.getParameter("PROJECT_CODE_KEY") );
    String strProjectNameKey   = getField( request.getParameter("PROJECT_NAME_KEY") );
    String strAccessTypeKey    = getField( request.getParameter("ACCESS_TYPE_KEY") );
    String strAccessDocTypeKey = getField( request.getParameter("ACCESS_DOC_TYPE_KEY") );
    String strUserRoleKey      = getField( request.getParameter("USER_ROLE_KEY") );
    String strRoleNameKey      = getField( request.getParameter("ROLE_NAME_KEY") );
    String strPageKey          = getField( request.getParameter("PAGE_KEY") );
    String strConOrgData       = getField( request.getParameter("hidConOrg" ) );
    String strConDocTypeData   = getField( request.getParameter("hidConDocType" ) );

    String mode_parent          = getField(request.getParameter( "mode_parent" ));
    String current_page_parent  = getField(request.getParameter( "current_page_parent" ));
    String sortby_parent        = getField(request.getParameter( "sortby_parent" ));
    String sortfield_parent     = getField(request.getParameter( "sortfield_parent" ));
    String current_page_parent2 = getField(request.getParameter( "current_page_parent2" ));
    String strDspTypeData       = getField(request.getParameter( "hidDspType" ));
    
    String strFieldOrgCodeData     = "";
    String strFieldOrgNameData     = "";
    String strFieldCountData       = "";
    String strFieldCountDocData    = "";
    String strChkBox               = "";
    String strFieldDocTypeData     = "";
    String strFieldDocTypeNameData = "";
    String strChkBox2              = "";
    
    String strScript      = "";
    String strbttEdit     = "";
    String strTotalPage   = "1";
    String sortby         = "";
    String sortbyd        = "";
    String sortfield      = "";
    String strCurrentDate = "";
    String strVersionLang = ImageConfUtil.getVersionLang();

    String strCurrentPage = request.getParameter( "CURRENT_PAGE" );
    String strPageSize    = request.getParameter( "PAGE_SIZE" );
    
    if( strCurrentPage == null || Integer.parseInt( strCurrentPage ) == 0 ) {
        strCurrentPage = "1";
    }
    if( strPageSize == null || Integer.parseInt( strPageSize ) == 0 ) {
            strPageSize = "10000";
    }

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
    
    if( strMode.equals("UPDATE") ) {
    	con.addData( "PROJECT_CODE",    "String", strProjectCodeKey );
    	con.addData( "USER_ID",         "String", strUserIdKey );
    	con.addData( "ACCESS_TYPE",     "String", strAccessTypeKey );
    	con.addData( "ACCESS_DOC_TYPE", "String", strAccessDocTypeKey );
    	con.addData( "CON_ORG",         "String", strConOrgData );
    	con.addData( "CON_DOC_TYPE",    "String", strConDocTypeData );
        con.addData( "ADD_USER",        "String", strUserId);
        con.addData( "ADD_DATE",        "String", strCurrentDate);
        con.addData( "EDIT_USER",       "String", strUserId);
        con.addData( "EDIT_DATE",       "String", strCurrentDate);
        con.addData( "UPD_USER",        "String", strUserId);
		bolnSuccess = con.executeService( strContainerName, strClassName, "updateUserAccessByOwner" );
		if( !bolnSuccess ) {
			strmsg  = "showMsg(0,0,\" " + lc_can_not_update_data + "\")";
			strMode = "SEARCH";
		}else {
		    strmsg  = "showMsg(0,0,\" " + lc_update_data_successfull + "\")";
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
        if( strAccessTypeKey.equals("O") ) {
	        con.addData( "PROJECT_CODE", "String", strProjectCodeKey );
	        bolnSuccess = con.executeService( strContainerName, strClassUserGroup, "findAccessTypeUserGroup" );
	        if( !bolnSuccess ) {
	            //strErrorCode    = con.getRemoteErrorCode();
	            //strErrorMessage = con.getRemoteErrorMesage();
	        }
        }

        if( strAccessDocTypeKey.equals("O") ) {
	        con3.addData( "PROJECT_CODE", "String", strProjectCodeKey );
	        bolnSuccess3 = con3.executeService( strContainerName, strClassUserGroup, "findAccessDocTypeUserGroup" );
	        if( !bolnSuccess3 ) {
	            //strErrorCode    = con.getRemoteErrorCode();
	            //strErrorMessage = con.getRemoteErrorMesage();
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
<script language="JavaScript" src="js/jquery-1.9.1.js"></script>
<script language="JavaScript" src="js/function/page-utils.js"></script>
<script language="JavaScript" src="js/sccUtils.js"></script>
<script language="JavaScript" src="js/util.js"></script>
<script language="JavaScript" src="js/constant.js"></script>
<script language="JavaScript" src="js/label.js"></script>
<script language="JavaScript" type="text/javascript">
<!--

var intSeq    = "<%=intSeq %>";
var mode      = '<%=strMode%>';
var totalPage = '<%=strTotalPage%>';
var accessType    = "<%=strAccessTypeKey %>";
var accessDocType = "<%=strAccessDocTypeKey %>";

$(document).ready(window_onload);

function window_onload() {
    set_label();
    set_background("screen_div");
    set_init();
    set_message();    
}
    
function set_label(){    
    lb_group_name.innerHTML            = lbl_group_name;
    lb_doc_cabinet.innerHTML           = lbl_doc_cabinet;
    lb_user_role2.innerHTML            = lbl_user_role2;
    lb_head_doc_entry.innerHTML        = lbl_head_doc_entry;
    lb_group_access_doc_type.innerHTML = lbl_group_access_doc_type;
    lb_all_access.innerHTML            = lbl_all_access;
    lb_group_doc_level.innerHTML       = lbl_group_doc_level;
    lb_group_doc_org.innerHTML         = lbl_group_doc_org;
    lb_all_access2.innerHTML           = lbl_all_access;
    lb_group_doc_level2.innerHTML      = lbl_group_doc_level;
    lb_group_doc_type.innerHTML        = lbl_group_doc_type;
    lb_group_owner_org.innerHTML       = lbl_group_owner_org;
    lb_doc_type.innerHTML              = lbl_doc_type;
    lb_doc_type_name.innerHTML         = lbl_doc_type_name;
}

function set_init(){
    obj_hidDocumentFlag.value = "F";
    obj_hidDocTypeFlag.value  = "F";
    if( accessType == "A" ) {
    	obj_rdoAccessType[0].checked = true;
    }else if( accessType == "L" ) {
    	obj_rdoAccessType[1].checked = true;
    }else if( accessType == "O" ) {
    	obj_rdoAccessType[2].checked = true;
    	obj_hidDocumentFlag.value    = "T";
    }

    if( accessDocType == "A" ) {
    	obj_rdoAccessDocType[0].checked = true;
    }else if( accessDocType == "L" ) {
    	obj_rdoAccessDocType[1].checked = true;
    }else if( accessDocType == "O" ) {
    	obj_rdoAccessDocType[2].checked = true;
        obj_hidDocTypeFlag.value        = "T";
    }
}

function set_message(){
    
<%  if (!strmsg.equals("")) {  %>
    <%=strmsg%>
<%  }   %>
}

function concatAllValueUpdate() {
	var strConDocument  = "";
	var strFullDocument = "";
	var strDocument     = "hidDocument_";
	var obj_arrDocument = "";
	var strchkBox       = "chkAllDocument";
	var obj_chkBox      = "";
	var length          = obj_intSeqn.value;

	var strConDocType  = "";
	var strFullDocType = "";
	var strDocType     = "hidDocType_";
	var obj_arrDocType = "";
	var strchkBox2     = "chkAllDocType";
	var obj_chkBox2    = "";
	var length2        = obj_intSeqn2.value;

	if( obj_hidDocumentFlag.value == "T" ) {
		for( var i=1; i<length; i++ ) {
			obj_chkBox = document.getElementById( strchkBox+i );
			if( obj_chkBox.checked ) {
				strFullDocument = "";
				strFullDocument = strDocument + i;
				obj_arrDocument = document.getElementById( strFullDocument );
				strConDocument  += obj_arrDocument.value + ",";
			}
		}
		if( strConDocument.length > 0 ){
			strConDocument = strConDocument.substr( 0, strConDocument.lastIndexOf(",") );
		}
		obj_hidConOrg.value = strConDocument;
	}
	if( obj_hidDocTypeFlag.value == "T" ) {
		for( var j=1; j<length2; j++ ) {
			obj_chkBox2 = document.getElementById( strchkBox2+j );
			if( obj_chkBox2.checked ) {
				strFullDocType = "";
				strFullDocType = strDocType + j;
				obj_arrDocType = document.getElementById( strFullDocType );
				strConDocType  += obj_arrDocType.value + ",";
			}
		}
		if( strConDocType.length > 0 ){
			strConDocType = strConDocType.substr( 0, strConDocType.lastIndexOf(",") );
		}
		obj_hidConDocType.value = strConDocType;
	}
}

function chkbxClickValue( lv_docType ) {
	if( lv_docType == "1" ) {
		obj_chkAllDocument.checked = false;
	}else {
		obj_chkAllDocType.checked = false;
	}
}

function selectAllDocument( lv_value ) {
	var strDoc = "chkAllDocument";
	var length = obj_intSeqn.value;
	var docId  = "";
	
	var strType = "chkAllDocType";
	var lenType = obj_intSeqn2.value;
	var typeId  = "";

	if( lv_value == "1" ) {
		if( obj_chkAllDocument.checked ) {
		    for( var i=1; i<length; i++ ) {
			    docId = document.getElementById( strDoc+i );
			    docId.checked = true;
		    }
		}else {
			for( var i=1; i<length; i++ ) {
				docId = document.getElementById( strDoc+i );
			    docId.checked = false;
		    }
		}
	}else {
		if( obj_chkAllDocType.checked ) {
		    for( var i=1; i<lenType; i++ ) {
		    	typeId = document.getElementById( strType+i );
		    	typeId.checked = true;
		    }
		}else {
			for( var i=1; i<lenType; i++ ) {
				typeId = document.getElementById( strType+i );
				typeId.checked = false;
		    }
		}
	}
}

function getRadioValue( lv_type, lv_value ) {	
	if( lv_type == "1" ) {
		obj_hidAccessType.value = lv_value;
	}else {
		obj_hidAccessDocType.value = lv_value;
	}

	form1.action     = "user_profile5.jsp";
	form1.MODE.value = "SEARCH";
	form1.submit();
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

function buttonClick( lv_strMethod ) {
	switch( lv_strMethod ){
		case "save" :
			concatAllValueUpdate();
			if( (obj_hidAccessType.value == "O") && (obj_hidConOrg.value == "") ) {
				alert( lc_user_group_access_by_org );
				return;
			}
			if( (obj_hidAccessDocType.value == "O") && (obj_hidConDocType.value == "") ) {
				alert( lc_user_group_access_by_document_type );
				return;
			}
			form1.action     = "user_profile5.jsp";
			form1.MODE.value = "UPDATE";
			form1.submit();
			break;
		case "cancel" :
//			form1.sortfield.value      = form1.sortfield_parent.value;
//			form1.sortby.value         = form1.sortby_parent.value;
//		    form1.CURRENT_PAGE.value   = form1.current_page_parent.value;
//		    form1.CURRENT_PAGE_2.value = form1.current_page_parent2.value;
//		    form1.MODE.value           = form1.mode_parent.value;
			form1.action               = "<%=strPageKey %>";
			form1.target 	           = "_self";
		    form1.submit();
			break;
	}
}

function openZoom( lv_value ) {
	var strPopArgument   = "scrollbars=yes,status=no";
	var strWidth         = ",width=450px";
	var strHeight        = ",height=520px";
	var strUrl           = "";
	var strConcatField   = "";

	strPopArgument += strWidth + strHeight;
	strUrl         = "user_profile6.jsp";
	strConcatField = "ORG=" + lv_value.getAttribute("ORG") + "&ORG_NAME=" + lv_value.getAttribute("ORG_NAME") + "&PROJECT_CODE=" + lv_value.getAttribute("PROJECT_CODE") + "&USER_ID_ARG=" + lv_value.getAttribute("USER_ID_ARG");
	objZoomWindow  = window.open( strUrl + "?" + strConcatField, "ORG", strPopArgument );
	objZoomWindow.focus();
}

//-->
</script>
<link href="css/edas.css" type="text/css" rel="stylesheet">
</head>
<body onLoad="MM_preloadImages('images/btt_save2_over.gif','images/btt_back_over.gif');" onresize="set_background('screen_div')">
<form name="form1" method="post" action="" >
<table width="100%" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
	<tr><td valign="top">
		<div id="screen_div">
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
  <tr>
    <td valign="top">
    	<table width="530" border="0" cellspacing="0" cellpadding="0">
              <tr>
              	<td width="30">&nbsp;</td>
                <td height="25" class="label_header01" colspan="2"><%=screenname%>&nbsp;<%=lb_user_group_permit %>&nbsp;<%=lb_user_group_access %></td>
              </tr>
              <tr> 
              	<td width="15">&nbsp;</td>
              	<td width="15">&nbsp;</td>
                <td><div align="left">
                    <table width="430" border="0" cellpadding="0" cellspacing="0">
<%
    intclm = 1;

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
                        <td colspan="6"><BR></td>
                      </tr>
                      <tr>
                        <td class="label_bold4" width="430" colspan="6">
							<div align="left">
			                	<span id="lb_group_name"></span>&nbsp;:&nbsp;&nbsp;<%=strUserFnameKey %>
			                </div>
			            </td>
                      </tr>
                      <tr>
                        <td colspan="6" class="label_bold4">
							<div align="left">
			                	<span id="lb_doc_cabinet"></span>&nbsp;:&nbsp;&nbsp;<%=strProjectNameKey %>
			                </div>
			            </td>
                      </tr>
                      <tr>
                        <td colspan="6" class="label_bold4">
							<div align="left">
			                	<span id="lb_user_role2"></span>&nbsp;:&nbsp;&nbsp;<%=strRoleNameKey %>
			                </div>
			            </td>
                      </tr>
                      <tr>
                        <td colspan="6" class="label_bold4">
							<div align="left">
			                	<span id="lb_head_doc_entry"></span>&nbsp;:
			                </div>
			            </td>
                      </tr>
                      
                      <!-- ###################### DOCUMENT PART ###################### -->
                      
                      <tr>
                      	<td colspan="6">
                      		<table border="0" cellpadding="0" cellspacing="0">
                      			<tr>
                      				<td width="30">&nbsp;</td>
                      				<td>
                      					<table border="0" cellpadding="0" cellspacing="0">
                      						<tr>
                        						<td colspan="6" class="label_bold4">
                        							<input type="radio" id="rdoAccessType" name="rdoAccessType" onclick="getRadioValue('1','A');"><span id="lb_all_access"></span>
                        						</td>
                      						</tr>
                      						<tr>
                        						<td colspan="6" class="label_bold4">
                        							<input type="radio" id="rdoAccessType" name="rdoAccessType" onclick="getRadioValue('1','L');"><span id="lb_group_doc_level"></span>
			            						</td>
                      						</tr>
                      						<tr>
                        						<td colspan="6" class="label_bold4">
                        							<input type="radio" id="rdoAccessType" name="rdoAccessType" onclick="getRadioValue('1','O');"><span id="lb_group_doc_org"></span>
			            						</td>
                      						</tr>
                      						<tr class="hd_table">
                      							<td width="10"><img src="images/hd_tb_01.gif" width="10" height="28"></td>
						                        <td width="30"><input type="checkbox" id="chkAllDocument" name="chkAllDocument" onclick="selectAllDocument('1')" ></td>
						                        <td width="400" align="center" colspan="2">
						                        	<div align="center"><span id="lb_group_owner_org"></span><%=sortimg[1]%></div>
						                        </td>
						                        <td align="right"><img src="images/hd_tb_04.gif" width="10" height="28"></td>
						                    </tr>
<%
    if( bolnSuccess ) {
        intSeq = 1;
        while( con.nextRecordElement() ) {
        	strFieldOrgCodeData = con.getColumn( "ORG" );
            strFieldOrgNameData = con.getColumn( "ORG_NAME" );

            con2.addData( "PROJECT_CODE", "String", strProjectCodeKey );
            con2.addData( "USER_ID",      "String", strUserIdKey );
            con2.addData( "ORG",          "String", strFieldOrgCodeData );
            strScript = "ORG=\"" + strFieldOrgCodeData + "\" ORG_NAME=\"" + strFieldOrgNameData + "\" PROJECT_CODE=\"" + strProjectCodeKey + "\" USER_ID_ARG=\"" + strUserIdKey+ "\" ";
			strChkBox = "<input type=\"checkbox\" id=\"chkAllDocument" +intSeq+ "\" name=\"chkAllDocument" +intSeq +"\" onclick=\"chkbxClickValue('1')\" >";
			
            bolnSuccess2 = con2.executeService( strContainerName, strClassName, "countUserIdOrg" );
            if( bolnSuccess2 ) {
            	strFieldCountData = con2.getHeader( "CNT" );
				if( !strFieldCountData.equals("0") ) {
					strChkBox = "<input type=\"checkbox\" id=\"chkAllDocument" +intSeq+ "\" name=\"chkAllDocument" +intSeq +"\" onclick=\"chkbxClickValue('1')\" checked=\"checked\">";
				}
			}
			strbttEdit = "<a href=\"#\" onclick=\"openZoom(this)\"" + strScript + " onMouseOut=\"MM_swapImgRestore()\" onMouseOver=\"MM_swapImage('defind" +intSeq+ "','','images/btt_specify_over.gif',1)\"><img src=\"images/btt_specify.gif\" name=\"defind" + intSeq + "\"  width=\"109\" height=\"18\" border=\"0\"></a>";
			if( intSeq % 2 != 0 ) {
%>
                      						<tr class="table_data1">
						                        <td>&nbsp;</td>
						                        <td>
						                        	<div align="center"><%=strChkBox %></div>
						                        </td>
						                        <td width="280"><div align="left">&nbsp;<%=strFieldOrgNameData %><input type="hidden" id="hidDocument_<%=intSeq%>" value="<%=strFieldOrgCodeData %>"></div></td>
						                        <td width="120" align="center">
						                        	<div align="center"><%=strbttEdit %></div>
						                        </td>
						                        <td>&nbsp;</td>
                      						</tr>
<%
            }else {
%>
                      						<tr class="table_data2">
						                        <td>&nbsp;</td>
						                        <td>
						                        	<div align="center"><%=strChkBox %></div>
						                        </td>
						                        <td width="280"><div align="left">&nbsp;<%=strFieldOrgNameData %><input type="hidden" id="hidDocument_<%=intSeq%>" value="<%=strFieldOrgCodeData %>"></div></td>
						                        <td width="120" align="center">
						                        	<div align="center"><%=strbttEdit %></div>
						                        </td>
						                        <td>&nbsp;</td>
                      						</tr>
<%
            }
            intSeq++;
        }
     }else {
%>
											<tr class="table_data1">
						                        <td colspan="5">&nbsp;</td>
						                    </tr>
<%
     }
 %>
                      					</table>
                        
                      				</td>
                      			</tr>
                      		</table>
                      	</td>
                      </tr>
                      
					<!-- ###################### DOCUMENT TYPE PART ###################### -->
                      <tr>
                        <td colspan="6"><BR></td>
                      </tr>
                      <tr>
                        <td colspan="6" class="label_bold4">
							<div align="left">
			                	<span id="lb_group_access_doc_type"></span>:
			                </div>
			            </td>
                      </tr>
                      <tr>
                      	<td colspan="6">
                      		<table border="0" cellpadding="0" cellspacing="0">
                      			<tr>
                      				<td width="30">&nbsp;</td>
                      				<td>
                      					<table border="0" cellpadding="0" cellspacing="0">
                      						<tr>
                        						<td colspan="6" class="label_bold4">
                        							<input type="radio" id="rdoAccessDocType" name="rdoAccessDocType" onclick="getRadioValue('2','A');"><span id="lb_all_access2"></span>
			            						</td>
                      						</tr>
                      						<tr>
                        						<td colspan="6" class="label_bold4">
                        							<input type="radio" id="rdoAccessDocType" name="rdoAccessDocType" onclick="getRadioValue('2','L');"><span id="lb_group_doc_level2"></span>
			            						</td>
                      						</tr>
                      						<tr>
                        						<td colspan="6" class="label_bold4">
                        							<input type="radio" id="rdoAccessDocType" name="rdoAccessDocType" onclick="getRadioValue('2','O');"><span id="lb_group_doc_type"></span>
			            						</td>
                      						</tr>
                      						<tr class="hd_table">
                      							<td width="10"><img src="images/hd_tb_01.gif" width="10" height="28"></td>
						                        <td width="30"><input type="checkbox" id="chkAllDocType" name="chkAllDocType" onclick="selectAllDocument('2')" ></td>
						                        <td width="110" align="center">
						                        	<div align="center"><span id="lb_doc_type"></span></div>
						                        </td>
						                        <td width="250" align="center">
						                        	<div align="center"><span id="lb_doc_type_name"></span></div>
						                        </td>
						                        <td align="right"><img src="images/hd_tb_04.gif" width="10" height="28"></td>
						                    </tr>
<%
    if( bolnSuccess3 ) {
        intSeq2 = 1;
        while( con3.nextRecordElement() ) {
        	strFieldDocTypeData     = con3.getColumn( "DOCUMENT_TYPE" );
            strFieldDocTypeNameData = con3.getColumn( "DOCUMENT_TYPE_NAME" );

            con4.addData( "PROJECT_CODE",  "String", strProjectCodeKey );
            con4.addData( "USER_ID",       "String", strUserIdKey );
            con4.addData( "DOCUMENT_TYPE", "String", strFieldDocTypeData );
            bolnSuccess4 = con4.executeService( strContainerName, strClassName, "countUserIdDocType" );
            
            strChkBox2 = "<input type=\"checkbox\" id=\"chkAllDocType" +intSeq2+ "\" name=\"chkAllDocType" +intSeq2 +"\" onclick=\"chkbxClickValue('2')\" >";
            if( bolnSuccess4 ) {
                    strFieldCountDocData = con4.getHeader( "CNT" );
                    if( !strFieldCountDocData.equals("0")) {
                            strChkBox2 = "<input type=\"checkbox\" id=\"chkAllDocType" +intSeq2+ "\" name=\"chkAllDocType" +intSeq2 +"\" onclick=\"chkbxClickValue('2')\" checked=\"checked\">";
                    }
            }
			
            if( intSeq2 % 2 != 0 ) {
%>
                      						<tr class="table_data1">
						                        <td>&nbsp;</td>
						                        <td>
						                        	<div align="center"><%=strChkBox2 %></div>
						                        </td>
						                        <td><div align="left">&nbsp;<%=strFieldDocTypeData %><input type="hidden" id="hidDocType_<%=intSeq2%>" value="<%=strFieldDocTypeData %>"></div></td>
						                        <td><div align="left">&nbsp;<%=strFieldDocTypeNameData %></div></td>
						                        <td>&nbsp;</td>
                      						</tr>
<%
            }else {
%>
                      						<tr class="table_data2">
						                        <td>&nbsp;</td>
						                        <td>
						                        	<div align="center"><%=strChkBox2 %></div>
						                        </td>
						                        <td><div align="left">&nbsp;<%=strFieldDocTypeData %><input type="hidden" id="hidDocType_<%=intSeq2%>" value="<%=strFieldDocTypeData %>"></div></td>
						                        <td><div align="left">&nbsp;<%=strFieldDocTypeNameData %></div></td>
						                        <td>&nbsp;</td>
                      						</tr>
<%
            }
			intSeq2++;
        }
     }else {
%>
											<tr class="table_data1">
             									<td colspan="5">&nbsp;</td>
         									</tr>
<%
	}
 %>
                      					</table>
                        
                      				</td>
                      			</tr>
                      		</table>
                      	</td>
                      </tr>
                    </table>
					<BR>
					<div align="center">
		           		<a href="#" onclick= "buttonClick('save')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('save','','images/btt_save2_over.gif',1)">
		           			<img src="images/btt_save2.gif" name="save" width="67" height="22" border="0"></a>&nbsp;
		           		<a href="#" onclick= "buttonClick('cancel')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('back','','images/btt_back_over.gif',1)">
		           			<img src="images/btt_back.gif" name="back" width="67" height="22" border="0"></a>
		           	</div>
                                        <br>
                                        <br>
              	</div></td>
              </tr>
            </table>
            <input type="hidden" name="MODE"         value="<%=strMode%>">
			<input type="hidden" name="screenname"   value="<%=screenname%>">
			<input type="hidden" name="PROJECT_CODE" value="<%=strProjectCode%>">
			<input type="hidden" name="sortby"       value="<%=sortby%>">
			<input type="hidden" name="sortfield"    value="<%=sortfield%>">
			
			<input type="hidden" id="seqn"            name="seqn"            value="<%=intSeq%>">
			<input type="hidden" id="seqn2"           name="seqn2"           value="<%=intSeq2%>">
			<input type="hidden" id="hidConOrg"       name="hidConOrg"       value="">
			<input type="hidden" id="hidConDocType"   name="hidConDocType"   value="">
			<input type="hidden" id="hidDocumentFlag" name="hidDocumentFlag" value="">
			<input type="hidden" id="hidDocTypeFlag"  name="hidDocTypeFlag"  value="">
			
			<input type="hidden" id="USER_ID_KEY"         name="USER_ID_KEY"         value="<%=strUserIdKey%>">
			<input type="hidden" id="USER_FNAME_KEY"      name="USER_FNAME_KEY"      value="<%=strUserFnameKey%>">
			<input type="hidden" id="PROJECT_CODE_KEY"    name="PROJECT_CODE_KEY"    value="<%=strProjectCodeKey %>">
			<input type="hidden" id="PROJECT_NAME_KEY"    name="PROJECT_NAME_KEY"    value="<%=strProjectNameKey %>">
			<input type="hidden" id="ACCESS_TYPE_KEY"     name="ACCESS_TYPE_KEY"     value="<%=strAccessTypeKey %>">
			<input type="hidden" id="ACCESS_DOC_TYPE_KEY" name="ACCESS_DOC_TYPE_KEY" value="<%=strAccessDocTypeKey %>">
			<input type="hidden" id="USER_ROLE_KEY"       name="USER_ROLE_KEY"       value="<%=strUserRoleKey %>">
			<input type="hidden" id="ROLE_NAME_KEY"       name="ROLE_NAME_KEY"       value="<%=strRoleNameKey %>">
			<input type="hidden" id="PAGE_KEY"            name="PAGE_KEY"            value="<%=strPageKey %>">
			<input type="hidden" id="DISPLAY"             name="DISPLAY"             value="<%=strDisplay %>">
			
			<input type="hidden" id="CURRENT_PAGE"         name="CURRENT_PAGE"         value="<%=strCurrentPage %>">
			<input type="hidden" id="CURRENT_PAGE_2"       name="CURRENT_PAGE_2"       value="<%=strCurrentPage %>">
			<input type="hidden" id="mode_parent"          name="mode_parent"          value="<%=mode_parent%>">
			<input type="hidden" id="current_page_parent"  name="current_page_parent"  value="<%=current_page_parent%>">
			<input type="hidden" id="current_page_parent2" name="current_page_parent2" value="<%=current_page_parent2%>">
			<input type="hidden" id="sortby_parent"        name="sortby_parent"        value="<%=sortby_parent%>">
			<input type="hidden" id="sortfield_parent"     name="sortfield_parent"     value="<%=sortfield_parent%>">
			<input type="hidden" id="hidDspType"           name="hidDspType"           value="<%=strDspTypeData %>">
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

var obj_bttPermit        = document.getElementById( "permit" );
var obj_bttUnpermit      = document.getElementById( "unpermit" );
var obj_bttSearch        = document.getElementById( "search" );
var obj_chkAllDocument   = document.getElementById( "chkAllDocument" );
var obj_chkAllDocType    = document.getElementById( "chkAllDocType" );
var obj_intSeqn          = document.getElementById( "seqn" );
var obj_intSeqn2         = document.getElementById( "seqn2" );
var obj_rdoAccessType    = document.getElementsByName( "rdoAccessType" );
var obj_rdoAccessDocType = document.getElementsByName( "rdoAccessDocType" );
var obj_hidAccessType    = document.getElementById( "ACCESS_TYPE_KEY" );
var obj_hidAccessDocType = document.getElementById( "ACCESS_DOC_TYPE_KEY" );
var obj_hidConOrg        = document.getElementById( "hidConOrg" );
var obj_hidConDocType    = document.getElementById( "hidConDocType" );
var obj_hidDocumentFlag  = document.getElementById( "hidDocumentFlag" );
var obj_hidDocTypeFlag   = document.getElementById( "hidDocTypeFlag" );

//-->
</script>