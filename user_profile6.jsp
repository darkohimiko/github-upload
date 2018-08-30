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

	UserInfo userInfo     = (UserInfo)session.getAttribute( "USER_INFO" );
	String strUserId      = userInfo.getUserId();
	
	String strClassName      = "USER_PROFILE";
	String strClassUserGroup = "USER_GROUP";
	String strMode           = getField(request.getParameter("MODE"));
	
	String strCurrentPage = request.getParameter( "CURRENT_PAGE" );
	String strPageSize    = request.getParameter( "PAGE_SIZE" );
	if( strCurrentPage == null || Integer.parseInt( strCurrentPage ) == 0 ) {
	    strCurrentPage = "1";
	}
	if( strPageSize == null || Integer.parseInt( strPageSize ) == 0 ) {
		strPageSize = "10";
	}

	boolean bolnSuccess     = true;
        boolean searchmod       = false;
    
	String strmsg          = "";
	
	int intSeq   = 0;
	int i        = 0;
    int intfield = 0;
    int intclm   = 0;

    String strUserIdArgKey  = getField( request.getParameter("USER_ID_ARG") );
    String strProjCodeKey   = getField( request.getParameter("PROJECT_CODE") );
    String strUserOrgKey    = getField( request.getParameter("ORG") );
    String strOrgNameKey    = getField( request.getParameter("ORG_NAME") );
    String strConUserIdData = getField( request.getParameter("hidConUserId") );

    String strFieldUserIdData    = "";
    String strFieldTitleNameData = "";
    String strFieldUserNameData  = "";
    String strFieldUserSnameData = "";
    
    String strFullIdName  = "";
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
    
    if( strMode.equals("INSERT") ) {
    	con.addData( "USER_ID_CON",  "String", strConUserIdData );
    	con.addData( "PROJECT_CODE", "String", strProjCodeKey );
    	con.addData( "USER_ID_ARG",  "String", strUserIdArgKey );
        con.addData( "ADD_USER",     "String", strUserId);
        con.addData( "ADD_DATE",     "String", strCurrentDate);
        con.addData( "UPD_USER",     "String", strUserId);
		bolnSuccess = con.executeService( strContainerName, strClassName, "insertUserAccessByOwnerUser" );
		if( !bolnSuccess ) {
			strmsg  = "showMsg(0,0,\" " + lc_can_not_update_data + "\")";
			strMode = "SEARCH";
		}else {
		    strmsg  = "showMsg(0,0,\" " + lc_update_data_successfull + "\")";
		    strMode = "FINISH";
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

    	con.addData( "ORG",          "String", strUserOrgKey );
    	con.addData( "PROJECT_CODE", "String", strProjCodeKey );
    	con.addData( "SORT_FIELD",   "String", sortfield );
        con.addData( "SORT_BY",      "String", sortbyd );
        con.addData( "PAGENUMBER",   "String", strCurrentPage );
        con.addData( "PAGESIZE",     "String", strPageSize );
        bolnSuccess = con.executeService( strContainerName, strClassUserGroup, "selectOwnerUserByOrg" );
        
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
    
    lb_group_owner_org.innerHTML = lbl_group_owner_org;
    lb_group_owner.innerHTML   = lbl_group_owner;
    lb_total_record.innerHTML = lbl_total_record;
    lb_record.innerHTML       = lbl_record;
    if( mode == "FINISH" ) {
    	window.close();
    }

	form1.PAGE_SIZE.value = per_page;
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
	obj_hidConUserId.value = strConUserId;
}

function chkbxClickValue() {
	obj_chkAllCheck.checked = false;
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

function buttonClick( lv_strMethod ){
	switch( lv_strMethod ){
		case "save" :
			concatAllUserId();
			if( obj_hidConUserId.value == "" ) {
				alert( lc_select_cabinet );
				return;
			}
			form1.action     = "user_profile6.jsp";
			form1.MODE.value = "INSERT";
			form1.submit();
			break;
		case "cancel" :
			window.close();
			break;
	}
}

//-->
</script>
<link href="css/edas.css" type="text/css" rel="stylesheet">
</head>
<body onLoad="MM_preloadImages('images/btt_save2_over.gif','images/btt_cancel_over.gif');window_onload();">
<form name="form1" method="post" action="" >
<table width="100%" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
	<tr><td valign="top">
		<div id="screen_div" style="width:100%;height:100%;overflow-y:scroll;overflow-x:hidden;margin-right:0px;margin-bottom:0px;border:0px #ccc solid;" >
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
  <tr>
    <td valign="top">
    	<table width="410" border="0" cellspacing="0" cellpadding="0">
              <tr> 
                <td><div align="center">
                    <table width="400" border="0" cellpadding="0" cellspacing="0">
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
                        <td colspan="7" class="label_bold4">
							<div align="left">
			                	<span id="lb_group_owner_org"></span>:&nbsp;&nbsp;<%=strOrgNameKey %>
			                </div>
			            </td>
                      </tr>
                      <tr>
                        <td colspan="7"><BR></td>
                      </tr>
                      <tr class="hd_table"> 
                        <td width="10"><img src="images/hd_tb_01.gif" width="10" height="28"></td>
                        <td width="30"><input type="checkbox" id="chkAllCheck" name="chkAllCheck" onclick="chkAllUserId()" ></td>
                        <td width="380" align="center">
                        	<div align="center"><span id="lb_group_owner"></span><%=sortimg[1]%></div>
                        </td>
                        <td align="right"><img src="images/hd_tb_04.gif" width="10" height="28"></td>
                      </tr>
<%
    if( bolnSuccess ) {
        intSeq = 1;
        while( con.nextRecordElement() ) {
            strFieldUserIdData    = con.getColumn( "USER_ID" );
            //strFieldTitleNameData = con.getColumn( "TITLE_NAME" );
            strFieldUserNameData  = con.getColumn( "USER_NAME" );
            strFieldUserSnameData = con.getColumn( "USER_SNAME" );
            strFullIdName         = strFieldUserIdData + " ( " + strFieldTitleNameData + strFieldUserNameData + " " + strFieldUserSnameData + " )";
			
            if( intSeq % 2 != 0 ) {
%>
                      <tr class="table_data1">
                        <td>&nbsp;</td>
                        <td><div align="center"><input type="checkbox" id="chkAllCheck<%=intSeq%>" name="chkAllCheck<%=intSeq%>" onclick="chkbxClickValue()" ></div></td>
                        <td><div align="left">&nbsp;<%=strFullIdName %><input type="hidden" id="hidUserId_<%=intSeq%>" value="<%=strFieldUserIdData %>"></div></td>
                        <td>&nbsp;</td>
                      </tr>
<%
            }else {
%>
                      <tr class="table_data2">
                        <td>&nbsp;</td>
                        <td><div align="center"><input type="checkbox" id="chkAllCheck<%=intSeq%>" name="chkAllCheck<%=intSeq%>" onclick="chkbxClickValue()" ></div></td>
                        <td><div align="left">&nbsp;<%=strFullIdName %><input type="hidden" id="hidUserId_<%=intSeq%>" value="<%=strFieldUserIdData %>"></div></td>
                        <td>&nbsp;</td>
                      </tr>
<%
            }
            intSeq++;
        }
     }
 %>                      
                    </table>
                    <table width="400" height="28" border="0" align="center" cellpadding="0" cellspacing="0">
	                    <tr class="footer_table">
	                        <td width="50%" align="left" >&nbsp;&nbsp;<span id="lb_total_record"></span>&nbsp;&nbsp;<%=strTotalSize%>&nbsp;&nbsp;<span id="lb_record"></span></td>
	                        <td width="4%" height="28" align="right">
	                            <a href="#" name="firstP" onClick="navigatorClick('firstP');">
	                                <img src="images/first.gif" width="22" height="22" border="0"></a>
	                        </td>
	                        <td width="4%" height="28" align="right">
	                            <a href="#" name="previousP" onClick="navigatorClick('previousP');">
	                                <img src="images/prv.gif" width="22" height="22" border="0"></a>
	                        </td>
	                        <td width="34%" height="28" align="center">
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
	           		<a href="#" onclick= "buttonClick('save')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('save','','images/btt_save2_over.gif',1)">
	           			<img src="images/btt_save2.gif" name="save" width="67" height="22" border="0"></a>&nbsp;
	           		<a href="#" onclick= "buttonClick('cancel')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('back','','images/btt_cancel_over.gif',1)">
	           			<img src="images/btt_cancel.gif" name="back" width="67" height="22" border="0"></a>
              	</div></td>
              </tr>
            </table>
            <input type="hidden" name="MODE"       value="<%=strMode%>">
			<input type="hidden" name="sortby"     value="<%=sortby%>">
			<input type="hidden" name="sortfield"  value="<%=sortfield%>">
			
			<input type="hidden" id="seqn"         name="seqn"         value="<%=intSeq%>">
			<input type="hidden" id="USER_ID_ARG"  name="USER_ID_ARG"  value="<%=strUserIdArgKey %>">
			<input type="hidden" id="PROJECT_CODE" name="PROJECT_CODE" value="<%=strProjCodeKey %>">
			<input type="hidden" id="ORG"          name="ORG"          value="<%=strUserOrgKey %>">
			<input type="hidden" id="ORG_NAME"     name="ORG_NAME"     value="<%=strOrgNameKey %>">
			<input type="hidden" id="hidConUserId" name="hidConUserId" value="">
			<input type="hidden" id="PAGE_SIZE"    name="PAGE_SIZE" value="<%=strPageSize%>">
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

var obj_bttPermit    = document.getElementById("permit");
var obj_bttUnpermit  = document.getElementById("unpermit");
var obj_bttSearch    = document.getElementById("search");
var obj_chkAllCheck  = document.getElementById("chkAllCheck");
var obj_intSeqn      = document.getElementById("seqn");
var obj_hidConUserId = document.getElementById("hidConUserId");

//-->
</script>
<%  if (!strmsg.equals("")) {  %>
<script language="javaScript">
    <%=strmsg%>
</script>
<%  }   %>