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

    UserInfo userInfo = (UserInfo)session.getAttribute( "USER_INFO" );
    String  strUserId = userInfo.getUserId();


    String strClassName    = "ZOOM_TABLE_MANAGER";
    String strMode         = checkNull(request.getParameter("MODE"));
    String strOldMode      = checkNull(request.getParameter("OLD_MODE"));
    String strOldModeLevel = checkNull(request.getParameter("OLD_MODE_LEVEL"));
    String screenname      = getField(request.getParameter("screenname"));

    String mode_parent         = checkNull(request.getParameter( "mode_parent" ));
    String current_page_parent = checkNull(request.getParameter( "current_page_parent" ));
    String page_size_parent = checkNull(request.getParameter( "page_size_parent" ));
    String sortby_parent       = checkNull(request.getParameter( "sortby_parent" ));
    String sortfield_parent    = checkNull(request.getParameter( "sortfield_parent" ));

    String mode_tab4         = checkNull(request.getParameter( "mode_tab4" ));
    String current_page_tab4 = checkNull(request.getParameter( "current_page_tab4" ));
    String sortby_tab4       = checkNull(request.getParameter( "sortby_tab4" ));
    String sortfield_tab4    = checkNull(request.getParameter( "sortfield_tab4" ));
    
    String strTableCodeKey       = checkNull(request.getParameter("TABLE_CODE_KEY"));
    String strTableNameKey       = getField(request.getParameter("TABLE_NAME_KEY"));
    String strTableLevelKey      = checkNull(request.getParameter( "TABLE_LEVEL_KEY" ));
    String strTableLevel1Key     = checkNull(request.getParameter( "TABLE_LEVEL1_KEY" ));
    String strTableLevel2Key     = checkNull(request.getParameter( "TABLE_LEVEL2_KEY" ));
    String strTableLevel1NameKey = getField(request.getParameter( "TABLE_LEVEL1_NAME_KEY" ));
    String strTableLevel2NameKey = getField(request.getParameter( "TABLE_LEVEL2_NAME_KEY" ));
    
    String strFieldLevel1Code = checkNull(request.getParameter( "FIELD_LEVEL1_CODE" ));
    String strFieldLevel1Name = getField(request.getParameter( "FIELD_LEVEL1_NAME" ));
    String strFieldLevel2Code = checkNull(request.getParameter( "FIELD_LEVEL2_CODE" ));
    String strFieldLevel2Name = getField(request.getParameter( "FIELD_LEVEL2_NAME" ));

    String strTableCodeEditKey = checkNull(request.getParameter("TABLE_CODE_EDIT_KEY"));
    String strTableNameEditKey = getField(request.getParameter("TABLE_NAME_EDIT_KEY"));
    String nextTableCode       = checkNull(request.getParameter("NEXT_TABLE_CODE"));
    
	String strTableLevelCodeSearch = checkNull(request.getParameter( "TABLE_LEVEL_CODE_SEARCH" ));
    String strTableLevelNameSearch = getField(request.getParameter( "TABLE_LEVEL_NAME_SEARCH" ));

    String strTableLevelSearch = checkNull(request.getParameter("TABLE_LEVEL_SEARCH"));
    String strTableCodeSearch  = checkNull(request.getParameter("TABLE_CODE_SEARCH"));
    String strTableNameSearch  = getField(request.getParameter("TABLE_NAME_SEARCH"));
    
    String strTableCodeData = checkNull(request.getParameter("txtTableCode"));
    String strTableNameData = getField(request.getParameter("txtTableName"));

    strTableNameKey       = strTableNameKey.replaceAll( "'", "&acute;" );
    strTableNameKey       = strTableNameKey.replaceAll( "\"", "&quot;" );
    strFieldLevel1Name    = strFieldLevel1Name.replaceAll( "'", "&acute;" );
    strFieldLevel1Name    = strFieldLevel1Name.replaceAll( "\"", "&quot;" );
    strFieldLevel2Name    = strFieldLevel2Name.replaceAll( "'", "&acute;" );
    strFieldLevel2Name    = strFieldLevel2Name.replaceAll( "\"", "&quot;" );
    strTableLevel1NameKey = strTableLevel1NameKey.replaceAll( "'", "&acute;" );
    strTableLevel1NameKey = strTableLevel1NameKey.replaceAll( "\"", "&quot;" );
    strTableLevel2NameKey = strTableLevel2NameKey.replaceAll( "'", "&acute;" );
    strTableLevel2NameKey = strTableLevel2NameKey.replaceAll( "\"", "&quot;" );
    strTableNameEditKey   = strTableNameEditKey.replaceAll( "'", "&acute;" );
    strTableNameEditKey   = strTableNameEditKey.replaceAll( "\"", "&quot;" );
	
    boolean bolnSuccess     = true;
    String  strErrorCode    = null;  
    String  strmsg          = "";
    String	screenLabel     = "";
	String	strCurrentDate	= "";
	String  classDisplay    = "";
    String strVersionLang  = ImageConfUtil.getVersionLang();

    if( strVersionLang.equals("thai") ) {
		strCurrentDate = getServerDateThai();
	}else {
		strCurrentDate = getServerDateEng();
	}
	
    if( strMode == null ){
        strMode = "SEARCH";
    }

    if( strMode.equals( "pInsert" ) ) {
		con.addData( "TABLE_CODE" , "String" , strTableCodeKey);
        bolnSuccess = con.executeService( strContainerName , strClassName , "findMaxTableCode" );
        if( bolnSuccess ) {
        	nextTableCode = con.getHeader("MAX");
        	if( nextTableCode == null || nextTableCode.equals("") ) {
        		nextTableCode = "00000001";
        	}else {
        		nextTableCode = "0000000" + nextTableCode;
        	}
        	nextTableCode = nextTableCode.substring(nextTableCode.length()-8,nextTableCode.length());
        }
    }else if( strMode.equals( "pEdit" ) ) {
        strTableCodeData = strTableCodeKey;
        strTableNameData = strTableNameKey;
    }

    if(strMode.equals("ADD")){
    	strTableNameData = strTableNameData.replaceAll( "'", "&acute;" );
		strTableNameData = strTableNameData.replaceAll( "\"", "&quot;" );
		
    	con.addData( "TABLE_CODE_KEY", "String", strTableCodeKey);
        con.addData( "TABLE_CODE",     "String", strTableCodeData);
        con.addData( "TABLE_NAME",     "String", strTableNameData);
        if( !strTableLevel1Key.equals("") ) {
        	con.addData( "TABLE_LEVEL1_CODE", "String", strTableLevel1Key);
        }
        if( !strTableLevel1Key.equals("") ) {
        	con.addData( "TABLE_LEVEL1_VALUE", "String", strFieldLevel1Code);
        }
        if( !strTableLevel2Key.equals("") ) {
        	con.addData( "TABLE_LEVEL2_CODE", "String", strTableLevel2Key);
        }
        if( !strTableLevel1Key.equals("") ) {
        	con.addData( "TABLE_LEVEL2_VALUE", "String", strFieldLevel2Code);
        }
        con.addData( "CURRENT_DATE", "String", strCurrentDate);
        con.addData( "UPD_USER",     "String", strUserId);
        con.addData( "ADD_USER",     "String", strUserId);
        bolnSuccess = con.executeService( strContainerName , strClassName , "insertTableCodeDetail" );

        if( !bolnSuccess ){
            strErrorCode    = con.getRemoteErrorCode();
            if(strErrorCode.equals("ERR00002")){
                strmsg  = "showMsg(0,0,\" " + lc_system_table_dup + "\")";
                strMode = "pInsert";
            }else{
                strmsg  = "showMsg(0,0,\" " + lc_can_not_add_data + "\")";
                strMode = "pInsert";
            }
        }else{
            strmsg  = "showMsg(0,0,\" " +  lc_add_data_successfull + "\")";
            strMode = "MAIN";
        }
     }else if(strMode.equals("EDIT")){
    	strTableNameData = strTableNameData.replaceAll( "'", "&acute;" );
		strTableNameData = strTableNameData.replaceAll( "\"", "&quot;" );
		
    	con.addData( "TABLE_CODE_KEY",  "String", strTableCodeKey);
    	con.addData( "TABLE_CODE_EDIT", "String", strTableCodeData);
        con.addData( "TABLE_NAME_EDIT", "String", strTableNameData);
        con.addData( "CURRENT_DATE",    "String", strCurrentDate);
        con.addData( "UPD_USER",        "String", strUserId);
        con.addData( "ADD_USER",        "String", strUserId);
        bolnSuccess = con.executeService( strContainerName , strClassName , "updateTableCodeDetail"  );

        if( !bolnSuccess ){
            strErrorCode = con.getRemoteErrorCode();
            strmsg  = "showMsg(0,0,\" " + lc_can_not_update_data  + "\")";
            strMode = "pEdit";
        }else{
            strmsg  = "showMsg(0,0,\" " + lc_update_data_successfull + "\")";
            strMode = "MAIN";
    	}
    }
	
    if( strMode.equals( "pInsert" ) || strMode.equals("ADD") ) {
    	screenLabel  = lb_add;
		classDisplay = "class=\"input_box\" ";
    }else if( strMode.equals( "pEdit" ) || strMode.equals("EDIT") ) {
    	screenLabel  = lb_edit;
        classDisplay = "class=\"input_box_disable\" ";
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

var mode = "<%=strMode%>";

function window_onload() {
    var nextTableCode   = "<%= nextTableCode%>";
    lb_code.innerHTML   = lbl_code;
    lb_detail.innerHTML = lbl_detail;
    
    if( mode == "MAIN" ) {
        form1.action     = "system_table4.jsp";
        form1.target     = "_self";
	    form1.MODE.value = form1.OLD_MODE_LEVEL.value;
	    form1.CURRENT_PAGE.value = form1.current_page_tab4.value;
		form1.sortfield.value    = form1.sortfield_tab4.value;
		form1.sortby.value       = form1.sortby_tab4.value;
        form1.submit();
    }else if( mode == "pInsert" ) {
    	form1.txtTableCode.readOnly = false;
    	form1.txtTableCode.value    = nextTableCode;
    }
    if( nextTableCode == "" ) {
    	form1.txtTableCode.focus();
    }else {
    	form1.txtTableName.focus();
    }
}

function verify_form() {	
	if( form1.txtTableCode.value.length == 0 ) {
        alert( lc_check_code );
        form1.txtTableCode.focus();
        return false;
    }
    
	if( form1.txtTableName.value.length == 0 ) {
        alert( lc_check_detail );
        form1.txtTableName.focus();
        return false;
    }
    
	return true;
}

function buttonClick( lv_strMethod, lv_strValue ){
    switch( lv_strMethod ){
		case "save" :
		    if(verify_form()){
		        if(form1.MODE.value == "pInsert"){
		            form1.MODE.value = "ADD" ;
		        }else{
		            form1.MODE.value = "EDIT" ;
		        }
				form1.submit();
			}
			break;
		case "cancel" :
			form1.action     = "system_table4.jsp";
			form1.target 	 = "_self";
		    form1.MODE.value = form1.OLD_MODE_LEVEL.value;
		    form1.CURRENT_PAGE.value = form1.current_page_tab4.value;
			form1.sortfield.value    = form1.sortfield_tab4.value;
			form1.sortby.value       = form1.sortby_tab4.value;
		    form1.submit();
			break;
	}
}

//-->
</script>
<link href="css/edas.css" type="text/css" rel="stylesheet">
</head>
<body onLoad="MM_preloadImages('images/btt_save2_over.gif','images/btt_cancel_over.gif');window_onload();">
<form name="form1" method="post" action="" >
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0" align="center">
  <tr>
    <td valign="top">
    	<table width="800" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td height="25" class="label_header01" colspan="4">&nbsp;&nbsp;<%=screenname%>&nbsp;&nbsp;<%=strTableCodeKey %>&nbsp;&nbsp;<%=strTableNameKey %>&nbsp;>>&nbsp;<%=screenLabel %></td>
              </tr>
              <tr>
            	<td height="25" align="center">
            		<table width="622" border="0" cellspacing="0" cellpadding="0">
		                <tr>
		                  	<td height="25" colspan="2">&nbsp;</td>
		                </tr>
	                	<tr>
		                  	<td height="25" width="100" class="label_bold2"><span id="lb_code"></span>&nbsp;
		                  		<img src="images/mark.gif" width="12" height="11">
		                  	</td>
		                  	<td height="25" >
		                  		<input name="txtTableCode" type="text" size="40" maxlength="50" value="<%=strTableCodeEditKey %>" <%=classDisplay %> readonly >
	                  		</td>
	                	</tr>
	                	<tr>
		                  	<td height="25" class="label_bold2"><span id="lb_detail"></span>&nbsp;
		                  		<img src="images/mark.gif" width="12" height="11">
		                  	</td>
		                  	<td height="25" >
		                  		<input name="txtTableName" type="text" class="input_box" size="70" maxlength="500" value="<%=strTableNameEditKey %>">
	                  		</td>
	                	</tr>
	                	<tr>
	                  		<td height="25" colspan="2">&nbsp;</td>
	                  	</tr>
			            <tr>
				           	<td align="center" colspan="2">
				           		<a href="#" onclick= "buttonClick('save')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('save','','images/btt_save2_over.gif',1)">
				           			<img src="images/btt_save2.gif" name="save" width="67" height="22" border="0"></a>&nbsp;
				           		<a href="#" onclick= "buttonClick('cancel')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('cancel','','images/btt_cancel_over.gif',1)">
				           			<img src="images/btt_cancel.gif" name="cancel" width="67" height="22" border="0"></a>
				           	</td>
			            </tr>
              		</table>
            	</td>
            </tr>
        </table>
		<input type="hidden" name="MODE"              value="<%=strMode%>">
	    <input type="hidden" name="screenname"        value="<%=screenname%>">
		<input type="hidden" name="TABLE_LEVEL_KEY"   value="<%=strTableLevelKey %>">
		<input type="hidden" name="TABLE_CODE_KEY"    value="<%=strTableCodeKey%>">
		<input type="hidden" name="TABLE_NAME_KEY"    value="<%=strTableNameKey%>">
		<input type="hidden" name="TABLE_LEVEL1_KEY"  value="<%=strTableLevel1Key %>">
		<input type="hidden" name="TABLE_LEVEL2_KEY"  value="<%=strTableLevel2Key %>">
	
		<input type="hidden" name="FIELD_LEVEL1_CODE" value="<%=strFieldLevel1Code %>">
		<input type="hidden" name="FIELD_LEVEL1_NAME" value="<%=strFieldLevel1Name %>">
		<input type="hidden" name="FIELD_LEVEL2_CODE" value="<%=strFieldLevel2Code %>">
		<input type="hidden" name="FIELD_LEVEL2_NAME" value="<%=strFieldLevel2Name %>">
		
		<input type="hidden" name="TABLE_LEVEL1_NAME_KEY" value="<%=strTableLevel1NameKey %>">
		<input type="hidden" name="TABLE_LEVEL2_NAME_KEY" value="<%=strTableLevel2NameKey %>">
		<input type="hidden" name="NEXT_TABLE_CODE"       value="<%=nextTableCode %>">
			
		<input type="hidden" name="TABLE_LEVEL_CODE_SEARCH" value="<%=strTableLevelCodeSearch %>">
		<input type="hidden" name="TABLE_LEVEL_NAME_SEARCH" value="<%=strTableLevelNameSearch %>">
          			
		<input type="hidden" id="OLD_MODE"           name="OLD_MODE"           value="<%=strOldMode%>">
		<input type="hidden" id="OLD_MODE_LEVEL"     name="OLD_MODE_LEVEL"     value="<%=strOldModeLevel%>">
		<input type="hidden" id="TABLE_LEVEL_SEARCH" name="TABLE_LEVEL_SEARCH" value="<%=strTableLevelSearch%>">
		<input type="hidden" id="TABLE_CODE_SEARCH"  name="TABLE_CODE_SEARCH"  value="<%=strTableCodeSearch%>">
		<input type="hidden" id="TABLE_NAME_SEARCH"  name="TABLE_NAME_SEARCH"  value="<%=strTableNameSearch%>">
        
		<input type="hidden" id="CURRENT_PAGE" name="CURRENT_PAGE" value="">
		<input type="hidden" id="sortby"       name="sortby"       value="">
		<input type="hidden" id="sortfield"    name="sortfield"    value="">

		<input type="hidden" id="mode_parent"         name="mode_parent"         value="<%=mode_parent%>">
		<input type="hidden" id="current_page_parent" name="current_page_parent" value="<%=current_page_parent%>">
			<input type="hidden" id="page_size_parent" name="page_size_parent" value="<%=page_size_parent%>">
		<input type="hidden" id="sortby_parent"       name="sortby_parent"       value="<%=sortby_parent%>">
		<input type="hidden" id="sortfield_parent"    name="sortfield_parent"    value="<%=sortfield_parent%>">

		<input type="hidden" id="mode_tab4"         name="mode_tab4"         value="<%=mode_tab4%>">
		<input type="hidden" id="current_page_tab4" name="current_page_tab4" value="<%=current_page_tab4%>">
		<input type="hidden" id="sortby_tab4"       name="sortby_tab4"       value="<%=sortby_tab4%>">
		<input type="hidden" id="sortfield_tab4"    name="sortfield_tab4"    value="<%=sortfield_tab4%>">
        <p>&nbsp;</p>
      </td>
    </tr>
</table>
</form>
</body>
</html>
<%  if (!strmsg.equals("")) {  %>
<script language="javaScript">
    <%=strmsg%>
</script>
<%  }   %>