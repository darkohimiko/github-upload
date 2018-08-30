<%@page import="com.scc.edms.conf.ImageConfUtil"%>
<%@ page contentType="text/html; charset=tis-620"%>
<%@ page import="com.scc.security.UserInfo"%>
<%@ include file="inc/checkUser.jsp" %>
<%@ include file="inc/constant.jsp" %>
<%@ include file="inc/label.jsp" %>
<%@ include file="inc/utils.jsp" %>
<jsp:useBean id="con" scope="session" class="edms.cllib.EABConnector"/>
<jsp:useBean id="con1" scope="session" class="edms.cllib.EABConnector"/>
<%@page import="java.util.Random"%>
<%
	Random ran = new Random();
	String randomNo=String.valueOf(ran.nextLong());
	String strRand = "&randomNo="+ randomNo;
%>
<%
	con.setRemoteServer("EAS_SERVER");
	con1.setRemoteServer("EAS_SERVER");

	UserInfo userInfo = (UserInfo)session.getAttribute( "USER_INFO" );
	String strUserId        = userInfo.getUserId();
	String strUserName      = userInfo.getUserName();
	String strUserOrgName   = userInfo.getUserOrgName();
	String strUserLevel     = userInfo.getUserLevel();
	String strProjectCode 	= userInfo.getProjectCode();
	String strProjectName   = userInfo.getProjectName();

	String user_role      = checkNull(request.getParameter("user_role"));
	String app_name       = checkNull(request.getParameter("app_name"));
	String app_group      = checkNull(request.getParameter("app_group"));
	String strProjectFlag = checkNull(request.getParameter("project_flag"));
	String screenname     = getField(request.getParameter("screenname"));
        String strMethod      = request.getParameter( "METHOD" );
	
//------------------- Remember Field Search ----------------------------//
	
	String strBatchNo      = checkNull(request.getParameter("BATCH_NO_SEARCH"));
	String strDocumentName = getField(request.getParameter("DOCUMENT_NAME_SEARCH"));
	String strAddDate      = checkNull(request.getParameter("ADD_DATE_SEARCH"));
	String strToAddDate    = checkNull(request.getParameter("TO_ADD_DATE_SEARCH"));
	String strEditDate     = checkNull(request.getParameter("EDIT_DATE_SEARCH"));
	String strToEditDate   = checkNull(request.getParameter("TO_EDIT_DATE_SEARCH"));
	String strDocUser      = checkNull(request.getParameter("txtDocUser_SEARCH"));
	String strDocUserName  = getField(request.getParameter("txtDocUserName_SEARCH"));
	String strAddUser      = checkNull(request.getParameter("ADD_USER_SEARCH"));
	String strAddUserName  = getField(request.getParameter("ADD_USER_NAME_SEARCH"));
	String strEditUser     = checkNull(request.getParameter("EDIT_USER_SEARCH"));
	String strEditUserName = getField(request.getParameter("EDIT_USER_NAME_SEARCH"));
	
	String strSelConA = checkNull(request.getParameter("selConditionA_SEARCH"));
	String strSelConB = checkNull(request.getParameter("selConditionB_SEARCH"));
	String strSelConC = checkNull(request.getParameter("selConditionC_SEARCH"));
	String strSelConD = checkNull(request.getParameter("selConditionD_SEARCH"));
	String strSelConE = checkNull(request.getParameter("selConditionE_SEARCH"));
	String strSelConF = checkNull(request.getParameter("selConditionF_SEARCH"));
	
	if(strSelConA.equals("")){strSelConA = "AND";}
	if(strSelConB.equals("")){strSelConB = "AND";}
	if(strSelConC.equals("")){strSelConC = "AND";}
	if(strSelConD.equals("")){strSelConD = "AND";}
	if(strSelConE.equals("")){strSelConE = "AND";}
	if(strSelConF.equals("")){strSelConF = "AND";}

	String strConcatFieldName  = getField( request.getParameter( "CONCAT_FIELD_NAME" ) );
	String strSearchFieldValue = getField( request.getParameter( "SEARCH_FIELD_VALUE" ) );
	String strSearchCondition  = getField( request.getParameter( "SEARCH_CONDITION" ) );
	String strSearchOperator   = getField( request.getParameter( "SEARCH_OPERATOR" ) );
	
	String[] arrFieldName   = strConcatFieldName.split(",");
	String[] arrSearchField = strSearchFieldValue.split("<&>");
	String[] arrCondition   = strSearchCondition.split(",");
	String[] arrOperator    = strSearchOperator.split(",");
	
	String strDocumentDesc  = getField( request.getParameter("DOCUMENT_DESC"));
	
	//------------------------------------------------------------------------//

	String strClassName  = "EDIT_DOCUMENT";
	
	String strCurrentDate = "";
	String strLangFlag    = "";
        String strVersionLang  = ImageConfUtil.getVersionLang();

        if( strVersionLang.equals("thai") ) {
		strCurrentDate = getTodayDateThai();
		strLangFlag    = "1";
	}else{
		strCurrentDate = getTodayDate(); 
		strLangFlag    = "0";
	}
		
	String	strBttFunction	= "<a href=\"javascript:click_new()\" onMouseOut=\"MM_swapImgRestore()\" onMouseOver=\"MM_swapImage('i_new','','images/i_new_over.jpg',1)\"><img src=\"images/i_new.jpg\" name=\"i_new\" width=\"56\" height=\"62\" border=0></a>";
	
	strBttFunction += "<a href=\"javascript:click_search_all()\" onMouseOut=\"MM_swapImgRestore()\" onMouseOver=\"MM_swapImage('i_search','','images/i_search_over.jpg',1)\"><img src=\"images/i_search.jpg\" name=\"i_search\" width=\"56\" height=\"62\" border=0></a>";
	
    
    con.addData("PROJECT_CODE", "String", strProjectCode);
	con.addData("INDEX_TYPE", 	"String", "S");
	
	boolean bolFieldSuccess = con.executeService(strContainerName, strClassName, "findDocumentIndex");
	if(!bolFieldSuccess){
        session.setAttribute( "REDIRECT_PAGE" , "../caller.jsp?header=header1.jsp&detail=user_menu.jsp" + strRand );
        response.sendRedirect( "inc/check_field.jsp?INDEX_TYPE=S" );
	}
    
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title><%=lc_system_name %> <%=lc_site_name%></title>
<meta http-equiv="Content-Type" content="text/html; charset=tis-620">
<link rel="shortcut icon" href="images/favicon/EDAS.ico" type="image/x-icon" />
<script language="JavaScript" type="text/JavaScript">
<!--
function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
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
<script language="javascript" type="text/javascript">
<!--

var sccUtils = new SCUtils();
var check_current_date = false;

function click_new(){
	clear_all();
	
	form1.METHOD.value = "NEW";
	form1.method = "post";
	form1.action = "search_document2.jsp";
	form1.submit();
}

function click_new_document(){
	formAdd.submit();
}

function click_search_all(){
	if(!showMsg( 0 , 1 , lc_alert_for_search_all )){
		return;
	}
	form1.METHOD.value = "SEARCH_ALL";
	submit_form();
}

function click_search_data(){
	set_document_data_field()

	if(form1.ADD_DATE.value != ""){
		if(!validate_date(form1.ADD_DATE)){
			return;
		}
	}
	
	if(form1.TO_ADD_DATE.value != ""){
		if(form1.ADD_DATE.value == ""){
			alert(lc_check_from_date);
			form1.ADD_DATE.focus();
			return;
		}
		if(!validate_date(form1.TO_ADD_DATE)){
			return;
		}
	}
	
	if(form1.EDIT_DATE.value !=""){
		if(!validate_date(form1.EDIT_DATE)){
			return;
		}
	}
	
	if(form1.TO_EDIT_DATE.value != ""){
		if(form1.EDIT_DATE.value==""){
			alert(lc_check_from_date);
			form1.EDIT_DATE.focus();
			return;
		}
		if(!validate_date(form1.TO_EDIT_DATE)){
			return;
		}
	}

	if(form1.DOCUMENT_DATA_VALUE.value == ""){
		showMsg( 0 , 0 , lc_choose_one_more );
		return;
	}
	
	set_search_field();
	
	form1.METHOD.value = "SEARCH_DETAIL_DATA";
	submit_form();
}

function set_search_field(){
	form1.BATCH_NO_SEARCH.value		  = form1.BATCH_NO.value; 
	form1.DOCUMENT_NAME_SEARCH.value  = form1.DOCUMENT_NAME.value; 
	form1.ADD_DATE_SEARCH.value		  = form1.ADD_DATE.value; 
	form1.TO_ADD_DATE_SEARCH.value	  = form1.TO_ADD_DATE.value; 
	form1.EDIT_DATE_SEARCH.value	  = form1.EDIT_DATE.value; 
	form1.TO_EDIT_DATE_SEARCH.value	  = form1.TO_EDIT_DATE.value; 
	form1.txtDocUser_SEARCH.value 	  = form1.txtDocUser.value; 
	form1.txtDocUserName_SEARCH.value = form1.txtDocUserName.value; 
	form1.ADD_USER_SEARCH.value 	  = form1.ADD_USER.value; 
	form1.ADD_USER_NAME_SEARCH.value  = form1.ADD_USER_NAME.value; 
	form1.EDIT_USER_SEARCH.value 	  = form1.EDIT_USER.value; 
	form1.EDIT_USER_NAME_SEARCH.value = form1.EDIT_USER_NAME.value; 
	form1.selConditionA_SEARCH.value  = form1.selConditionA.value; 
	form1.selConditionB_SEARCH.value  = form1.selConditionB.value; 
	form1.selConditionC_SEARCH.value  = form1.selConditionC.value; 
	form1.selConditionD_SEARCH.value  = form1.selConditionD.value; 
	form1.selConditionE_SEARCH.value  = form1.selConditionE.value; 
	form1.selConditionF_SEARCH.value  = form1.selConditionF.value; 
}

function click_search_index(){
	set_concat_document_field();
	
	if(check_current_date){
		return;
	}
	
	if(form1.DOCUMENT_FIELD_VALUE.value == ""){
		showMsg( 0 , 0 , lc_choose_one_more );
		return;
	}
	
	form1.METHOD.value = "SEARCH_DETAIL_INDEX";
	submit_form();
}

function click_search_desc(){
	var strCondition = form1.selConDocUser3.value;
	
	if(form1.txtDOCUMENT_DESC.value == "" && form1.chkDocumentUser3.checked == false ){
		form1.txtDOCUMENT_DESC.focus();
		return;
	}
	
	if(form1.txtDOCUMENT_DESC.value.indexOf("%") != -1){
		alert(lc_wrong_search_keyword);
		form1.DOCUMENT_DESC.value    = "";
		form1.txtDOCUMENT_DESC.value = "";
		form1.txtDOCUMENT_DESC.focus();
		return;
	}

	if( form1.chkDocumentUser3.checked ) {
		form1.hidDocumentUserCon.value = strCondition;
	}
	
	form1.DOCUMENT_DESC.value = form1.txtDOCUMENT_DESC.value;
	form1.DOCUMENT_DESC.value = form1.DOCUMENT_DESC.value.replace(/'/g , "");
	form1.DOCUMENT_DESC.value = form1.DOCUMENT_DESC.value.replace(/"/gi , "" );
	form1.DOCUMENT_DESC.value = form1.DOCUMENT_DESC.value.replace(/ /gi , "+" );
	form1.METHOD.value        = "SEARCH_DETAIL_DESC";
	
	submit_form();
}

function click_cancel(){
	top.location = "caller.jsp?header=header1.jsp&detail=user_menu.jsp<%=strRand%>";
}

function submit_form(){
	form1.method = "post";
	form1.action = "search_result.jsp";
	form1.submit();
}

function clear_all(){
	form1.BATCH_NO.value 		= "";
	form1.DOCUMENT_NAME.value 	= "";
	form1.ADD_DATE.value 		= "";
	form1.TO_ADD_DATE.value 	= "";
	form1.EDIT_DATE.value 		= "";
	form1.TO_EDIT_DATE.value 	= "";
	form1.txtDocUser.value 		= "";
	form1.txtDocUserName.value 	= "";
	form1.ADD_USER.value 		= "";
	form1.ADD_USER_NAME.value 	= "";
	form1.EDIT_USER.value 		= "";
	form1.EDIT_USER_NAME.value 	= "";
	form1.hidDocumentUser.value = "";
	form1.chkDocumentUser1.checked = false;
	
	form1.selConditionA.selectedIndex  = 0;
	form1.selConditionB.selectedIndex  = 0;
	form1.selConditionC.selectedIndex  = 0;
	form1.selConditionD.selectedIndex  = 0;
	form1.selConditionE.selectedIndex  = 0;
	form1.selConditionF.selectedIndex  = 0;
	form1.selConDocUser1.selectedIndex = 0;

	var arrField = form1.CONCAT_FIELD_NAME.value.split( "," );
	var objDocumentField;
	for( var intCount = 0 ; intCount < arrField.length ; intCount++ ){
		objDocumentField = eval( "form1." + arrField[ intCount ]);
		objDocumentField.value = "";
		
		if(eval( "form1.TO_" + arrField[ intCount ]) != null){
			openToDate(arrField[ intCount ]);
		}
		
		if(eval("form1.selOperator" + (intCount+1)) != null ){
			eval("form1.selOperator" + (intCount+1) + ".selectedIndex = 0");
		}
		
		if(eval("form1.selCondition" + (intCount+1)) != null ){
			eval("form1.selCondition" + (intCount+1) + ".selectedIndex = 0");
		}
	}

	form1.hidDocumentUser.value    = "";
	form1.chkDocumentUser2.checked = false;
	check_current_date = false;

	form1.DOCUMENT_DESC.value          = "";
	form1.txtDOCUMENT_DESC.value       = "";
	form1.selConDocUser3.selectedIndex = 0;
	form1.hidDocumentUserCon.value     = "";
	form1.chkDocumentUser3.checked     = false;

}

function clear_search_data(){
	form1.BATCH_NO.value 		= "";
	form1.DOCUMENT_NAME.value 	= "";
	form1.ADD_DATE.value 		= "";
	form1.TO_ADD_DATE.value 	= "";
	form1.EDIT_DATE.value 		= "";
	form1.TO_EDIT_DATE.value 	= "";
	form1.txtDocUser.value 		= "";
	form1.txtDocUserName.value 	= "";
	form1.txtDocOrg.value 		= "";
	form1.ADD_USER.value 		= "";
	form1.ADD_USER_NAME.value 	= "";
	form1.EDIT_USER.value 		= "";
	form1.EDIT_USER_NAME.value 	= "";
	form1.hidDocumentUser.value = "";
	form1.chkDocumentUser1.checked = false;
	
	form1.selConditionA.selectedIndex = 0;
	form1.selConditionB.selectedIndex = 0;
	form1.selConditionC.selectedIndex = 0;
	form1.selConditionD.selectedIndex = 0;
	form1.selConditionE.selectedIndex = 0;
	form1.selConditionF.selectedIndex = 0;
	form1.selConDocUser1.selectedIndex = 0;
	
}

function clear_search_index(){
	var arrField = form1.CONCAT_FIELD_NAME.value.split( "," );
	var objDocumentField;
	for( var intCount = 0 ; intCount < arrField.length ; intCount++ ){
		objDocumentField = eval( "form1." + arrField[ intCount ]);
		objDocumentField.value = "";
		
		if(eval( "form1.TO_" + arrField[ intCount ]) != null){
			openToDate(arrField[ intCount ]);
		}
		
	/*	if(objDocumentField.defaultValue != 'undefine' ){
			objDocumentField.value = objDocumentField.defaultValue;
		}
	*/	
		if(eval("form1.selOperator" + (intCount+1)) != null ){
			eval("form1.selOperator" + (intCount+1) + ".selectedIndex = 0");
		}
		
		if(eval("form1.selCondition" + (intCount+1)) != null ){
			eval("form1.selCondition" + (intCount+1) + ".selectedIndex = 0");
		}
	}
	
	form1.chkDocumentUser2.checked = false;
	
	check_current_date = false;
}

function clear_search_desc(){
	form1.DOCUMENT_DESC.value          = "";
	form1.txtDOCUMENT_DESC.value       = "";
	form1.selConDocUser3.selectedIndex = 0;
	form1.hidDocumentUserCon.value     = "";
	form1.chkDocumentUser3.checked     = false;
	form1.txtDOCUMENT_DESC.focus();
}

function field_press( objField ){
	if( sccUtils.isEnter() ){
		window.event.keyCode = 0;
		switch( objField.name ){
			case "txtDOCUMENT_DESC" : 
				form1.DOCUMENT_DESC.value = form1.txtDOCUMENT_DESC.value;
				click_search_desc();
				break;
			case "BATCH_NO" : 
					form1.DOCUMENT_NAME.focus();
					break;
			case "DOCUMENT_NAME" : 
					form1.ADD_DATE.focus();
					break;
			case "ADD_DATE" : 
					form1.TO_ADD_DATE.focus();
					break;
			case "TO_ADD_DATE" : 
					form1.EDIT_DATE.focus();
					break;
			case "EDIT_DATE" : 
					form1.TO_EDIT_DATE.focus();
					break;
			case "TO_EDIT_DATE" : 
					var arrField = form1.CONCAT_FIELD_NAME.value.split( "," );
					var objNextField;
					for( var intCount = 0 ; intCount < arrField.length ; intCount++ ){
						objNextField = eval( "form1." + arrField[ intCount ] );
						if( objNextField != null && !objNextField.readOnly && objNextField.type != "hidden" ){
							objNextField.focus();
							return;
						}
					}
					break;									
			default : 
			
					set_mask(objField,objField.getAttribute("value_type"));
				
					var arrField = form1.CONCAT_FIELD_NAME.value.split( "," );
					var objNextField,objTodate;
					for( var intCount = 0 ; arrField[ intCount ] != objField.name ; intCount++ ){}
					intCount++;
					while( intCount < arrField.length ){
						objNextField = eval( "form1." + arrField[ intCount ] );
						if( objNextField != null && !objNextField.readOnly && objNextField.type != "hidden" ){
							objNextField.focus();
							return;
						}
						intCount++
					}
					break;
		}
	}
}

function set_mask(objField,objType){

	objField.value = sccUtils.unMask( objField.value );
	if( objType == "tin" ){
		objField.value = sccUtils.maskTIN( objField.value );
	}
	
	if( objField.getAttribute("value_type") == "pin" ){		
		objField.value = sccUtils.maskPIN( objField.value );
	}
}

function change_div( tab_name ) {

	var div_obj = document.getElementById("div_" + tab_name);
	var img_obj = document.getElementById("img_" + tab_name);
	
	if(div_obj.style.display == 'none' ){
		div_obj.style.display = 'inline';
		img_obj.src = "images/" + tab_name + ".gif";
	}else {
		div_obj.style.display = 'none';
		img_obj.src = "images/" + tab_name + "_c.gif";
	}
}

function change_tab_search( div_name, img_name ) {

	var div_obj = document.getElementById(div_name);
	var img_obj = document.getElementById(img_name);
	
	switch(div_name){
		case 'div_search_all':
			div_obj.style.display = 'inline';
			document.getElementById('div_search_index').style.display = 'none';
			img_obj.src = "images/" + img_name + "_over.gif";
			break;
		case 'div_search_index':
			div_obj.style.display = 'inline';
			document.getElementById('div_search_all').style.display = 'none';
			img_obj.src = "images/" + img_name + "_over.gif";
			break;
		case 'div_search_result':
			form1.CHECK_CLICK.value = "click";
			form1.target = "_self";
			form1.action = "search_result.jsp";
			form1.METHOD.value = "";
			form1.submit();		
			break;		
	}
	
}

function change_tab_img(){
	
	if(form1.CHECK_CLICK.value == 'click'){
		document.getElementById('txt_searchresult').src = "images/txt_searchresult_over.gif";
		document.getElementById('txt_condition').src = "images/txt_condition.gif";
		document.getElementById('txt_searchtotal').src = "images/txt_searchtotal.gif";
	}else{	
		if(document.getElementById('div_search_index').style.display == 'inline'){
			document.getElementById('txt_condition').src = "images/txt_condition_over.gif";			
		}else {
			document.getElementById('txt_condition').src = "images/txt_condition.gif";	
			document.getElementById('txt_searchresult').src = "images/txt_searchresult.gif";
		}
		if(document.getElementById('div_search_all').style.display == 'inline'){
			document.getElementById('txt_searchtotal').src = "images/txt_searchtotal_over.gif";	
		}else {
			document.getElementById('txt_searchtotal').src = "images/txt_searchtotal.gif";
			document.getElementById('txt_searchresult').src = "images/txt_searchresult.gif";	
		}
	}
}

function keypress_number(){
    var carCode = event.keyCode;
    if ((carCode < 48) || (carCode > 57)){
        if( event.preventDefault ){
            event.preventDefault();
        }else{
            event.returnValue = false;
        }
        return;
    }
}

function keypress_currency( input_obj){
	var carCode = event.keyCode;
	
	if(carCode == 46) {
		if(input_obj.value.indexOf(".")!= -1){
        if( event.preventDefault ){
            event.preventDefault();
        }else{
            event.returnValue = false;
        }
        return;
		}
		
	}else {
		if ((carCode < 48) || (carCode > 57)){
		 	if(carCode != 46) {
        if( event.preventDefault ){
            event.preventDefault();
        }else{
            event.returnValue = false;
        }
        return;
			}
		}
	}
}

function set_format_date( obj_field ){
	if( obj_field.value.length == 8 && sccUtils.isDateValid( obj_field.value ) == "VALID_DATE" ){
		obj_field.value = sccUtils.formatDate( obj_field.value );
	}
}

function openToDate( objTodate){
	var obj_to_date = eval("form1.TO_" + objTodate);
	var obj_img		= document.getElementById("img_" + objTodate)
	if(eval("form1."+ objTodate +".value") != ""){
		obj_to_date.readOnly 	= false;
		obj_to_date.className 	= "input_box";
		obj_to_date.focus();
		obj_img.style.display	='inline';
		
	}else{
		obj_to_date.readOnly = true;
		obj_to_date.className 	= "input_box_disable";
		obj_to_date.value 		= "";
		obj_img.style.display	='none';
	}
}

function openZoomUserProfile( objDisplayText , objDisplayValue ){
	var strPopArgument 	= "scrollbars=yes,status=no";
	var strWidth 		= ",width=370px";
	var strHeight 		= ",height=400px";
	var strUrl 			= "";
	var strConcatField 	= "";

	strPopArgument += strWidth + strHeight;
	
	strUrl = "inc/zoom_user_profile.jsp";
	strConcatField = "RESULT_FIELD=" + objDisplayValue + "," + objDisplayText;
	
	objZoomWindow = window.open( strUrl + "?" + strConcatField , "zm_userprofile" , strPopArgument );
	objZoomWindow.focus();
}

function openDocUserZoom( strZoomType , strZoomLabel ){
	var strPopArgument 	= "scrollbars=yes,status=no";
	var strWidth 		= ",width=470px";
	var strHeight 		= ",height=490px";
	var strUrl 			= "";
	var strConcatField 	= "";
	var strProjectCode  = "<%=strProjectCode %>";

	strPopArgument += strWidth + strHeight;
	strUrl         = "inc/zoom_document_user.jsp";
	strConcatField = "TABLE=" + strZoomType;
	strConcatField += "&TABLE_LABEL=" + strZoomLabel;
	strConcatField += "&RESULT_FIELD=txtDocUser,txtDocUserName,txtDocOrg";
	
	objZoomWindow = window.open( strUrl + "?" + strConcatField , "zm" + strZoomType , strPopArgument );
	objZoomWindow.focus();
}


function openZoom( strZoomType , strZoomLabel , objDisplayText , objDisplayValue, strTableLevel ){
	var strPopArgument 	= "scrollbars=yes,status=no";
	var strWidth 		= ",width=370px";
	var strHeight 		= ",height=420px";
	var strUrl 			= "";
	var strConcatField 	= "";

	strPopArgument += strWidth + strHeight;
	
	var strFieldLV2 = eval("form1.FIELD_" + strZoomType + "_LV2"); 
	var strFieldLV3 = eval("form1.FIELD_" + strZoomType + "_LV3");
	
	switch( strTableLevel ){
		case "1" :
				strUrl = "inc/zoom_data_table_level1.jsp";
				strConcatField  = "TABLE=" + strZoomType;
				strConcatField += "&TABLE_LABEL=" + strZoomLabel;
				
				strConcatField += "&TABLE_LABEL=" + strZoomLabel;
				strConcatField += "&RESULT_FIELD=" + objDisplayValue.name + "," + objDisplayText.name;
				
				if( strFieldLV2 != null ){
					strConcatField += "&CLEAR_FIELD=" + strFieldLV2.value + ",DSP_" + strFieldLV2.value;
				}
				if( strFieldLV3 != null ){
					strConcatField += "," + strFieldLV3.value + ",DSP_" + strFieldLV3.value;
				}
				break;
		case "2" :
				if( !validate_level1(eval("form1.FIELD_" + strZoomType + "_LV1"),eval("form1.FIELD_" + strZoomType + "_LV1_LABEL.value")) ){
					return;
				}
				
				var strTableLv1 = eval("form1.FIELD_" + strZoomType + "_LV1.value");
				
				strUrl = "inc/zoom_data_table_level2.jsp";
				strConcatField  = "TABLE=" + strZoomType;
				strConcatField += "&TABLE_LABEL=" + strZoomLabel;
				
				strConcatField += "&TABLE_LV1=" + eval("form1.FIELD_" + strZoomType + "_LV1_CODE.value");
				strConcatField += "&TABLE_LV1_LABEL=" + eval("form1.FIELD_" + strZoomType + "_LV1_LABEL.value");
				strConcatField += "&TABLE_LV1_CODE=" + eval("form1." + strTableLv1 + ".value");
				strConcatField += "&TABLE_LV1_NAME=" + eval("form1.DSP_" + strTableLv1 + ".value");
				
				strConcatField += "&TABLE_LABEL=" + strZoomLabel;
				strConcatField += "&RESULT_FIELD=" + objDisplayValue.name + "," + objDisplayText.name;
				
				if( strFieldLV3 != null ){
					strConcatField += "&CLEAR_FIELD=" + strFieldLV3.value + ",DSP_" + strFieldLV3.value;
				}
				
				break;
		case "3" :
				if( !validate_level1(eval("form1.FIELD_" + strZoomType + "_LV1"),eval("form1.FIELD_" + strZoomType + "_LV1_LABEL.value")) ){
					return;
				}
				if( !validate_level2(eval("form1.FIELD_" + strZoomType + "_LV2"),eval("form1.FIELD_" + strZoomType + "_LV2_LABEL.value")) ){
					return;
				}
				
				var strTableLv1 = eval("form1.FIELD_" + strZoomType + "_LV1.value");
				var strTableLv2 = eval("form1.FIELD_" + strZoomType + "_LV2.value");
				
				strUrl = "inc/zoom_data_table_level3.jsp";
				strConcatField = "TABLE=" + strZoomType;
				strConcatField += "&TABLE_LABEL=" + strZoomLabel;
				
				strConcatField += "&TABLE_LV1=" + eval("form1.FIELD_" + strZoomType + "_LV1_CODE.value");
				strConcatField += "&TABLE_LV1_LABEL=" + eval("form1.FIELD_" + strZoomType + "_LV1_LABEL.value");
				strConcatField += "&TABLE_LV1_CODE=" + eval("form1." + strTableLv1 + ".value");
				strConcatField += "&TABLE_LV1_NAME=" + eval("form1.DSP_" + strTableLv1 + ".value");
				
				strConcatField += "&TABLE_LV2=" + eval("form1.FIELD_" + strZoomType + "_LV2_CODE.value");
				strConcatField += "&TABLE_LV2_LABEL=" + eval("form1.FIELD_" + strZoomType + "_LV2_LABEL.value");
				strConcatField += "&TABLE_LV2_CODE=" + eval("form1." + strTableLv2 + ".value");
				strConcatField += "&TABLE_LV2_NAME=" + eval("form1.DSP_" + strTableLv2 + ".value");
				
				strConcatField += "&TABLE_LABEL=" + strZoomLabel;
				strConcatField += "&RESULT_FIELD=" + objDisplayValue.name + "," + objDisplayText.name;
				break;
		
		default : 
				strUrl = "inc/zoom_data_table_level1.jsp";
				strConcatField = "TABLE=" + strZoomType;
				strConcatField += "&TABLE_LABEL=" + strZoomLabel;
				strConcatField += "&RESULT_FIELD=" + objDisplayValue.name + "," + objDisplayText.name;
				break;
	}


	objZoomWindow = window.open( strUrl + "?" + strConcatField , "zm" + strZoomType , strPopArgument );
	objZoomWindow.focus();
}

function validate_level1(obj_lv1,label_lv1){
	if( obj_lv1 != null ){
		var objProv = eval( "form1." + obj_lv1.value );
		if( objProv != null && objProv.value == "" ){
			
            showMsg( 0 , 0 , lc_check + label_lv1 );
            return false;
		}
	}
	return true;
}

function validate_level2(obj_lv2,label_lv2){
	if( obj_lv2 != null ){
		var objAmp = eval( "form1." + obj_lv2.value );
		if( objAmp != null && objAmp.value == "" ){
			
            showMsg( 0 , 0 , lc_check + label_lv2 );
            return false;
		}
	}
	return true;
}

function set_document_data_field(){
	var strMasterScan 		= "MASTER_SCAN_<%=strProjectCode%>.";
	var strConcatFieldValue = "";
	var strStartFieldDate 	= "";
	var strEndFieldDate 	= "";
	
	var objConditionList;
	
	if(form1.BATCH_NO.value != ""){
		objConditionList = form1.selConditionA;		
		strConcatFieldValue +=  " " + strMasterScan + "BATCH_NO='" + form1.BATCH_NO.value + "' " + objConditionList.value;
	}
	
	if(form1.DOCUMENT_NAME.value != ""){
		objConditionList = form1.selConditionE;		
		strConcatFieldValue +=  " " + strMasterScan + "DOCUMENT_NAME LIKE '%" + form1.DOCUMENT_NAME.value + "%' " + objConditionList.value;
	}
	
	if(form1.txtDocUser.value != ""){
		objConditionList = form1.selConditionF;		
		strConcatFieldValue +=  " " + strMasterScan + "DOCUMENT_USER='" + form1.txtDocUser.value + "' " + objConditionList.value;
	}
	
	if(form1.ADD_DATE.value != ""){
		var strOper = "";
		if(form1.TO_ADD_DATE.value != ""){	strOper = ">=";	} 
		else{	strOper = "=";	}
		
		strStartFieldDate =  " " + strMasterScan + "ADD_DATE" + strOper + "'" + sccUtils.dateToDb( form1.ADD_DATE.value ) + "' ";
	}
	if(form1.TO_ADD_DATE.value != ""){
		strEndFieldDate =  " " + strMasterScan + "ADD_DATE<='" + sccUtils.dateToDb( form1.TO_ADD_DATE.value ) + "' ";
	}
	if((form1.ADD_DATE.value != "")&&(form1.TO_ADD_DATE.value != "")){
		objConditionList = form1.selConditionB;
		strConcatFieldValue += " (" + strStartFieldDate + " AND " + strEndFieldDate + ") " + objConditionList.value;
	}else{
		if((form1.ADD_DATE.value != "")||(form1.TO_ADD_DATE.value != "")){
			objConditionList = form1.selConditionB;
			strConcatFieldValue += strStartFieldDate + strEndFieldDate + " " + objConditionList.value;
		}	
	}
	
	strStartFieldDate = "";
	strEndFieldDate   = "";
	
	if(form1.EDIT_DATE.value != ""){
		var strOper = "";
		if(form1.TO_EDIT_DATE.value != ""){	strOper = ">=";	} 
		else{	strOper = "=";	}
		
		strStartFieldDate = " " + strMasterScan + "EDIT_DATE" + strOper + "'" + sccUtils.dateToDb( form1.EDIT_DATE.value ) + "' ";
	}
	if(form1.TO_EDIT_DATE.value != ""){
		strEndFieldDate = " " + strMasterScan + "EDIT_DATE<='" + sccUtils.dateToDb( form1.TO_EDIT_DATE.value ) + "' ";
	}
	if((form1.EDIT_DATE.value != "")&&(form1.TO_EDIT_DATE.value != "")){
		objConditionList = form1.selConditionC;
		strConcatFieldValue += " (" + strStartFieldDate + " AND " + strEndFieldDate + ") " + objConditionList.value;
	}else{
		if((form1.EDIT_DATE.value != "")||(form1.TO_EDIT_DATE.value != "")){
			objConditionList = form1.selConditionC;
			strConcatFieldValue += strStartFieldDate + strEndFieldDate + " " + objConditionList.value;
		}		
	}

	if(form1.ADD_USER.value != ""){
		objConditionList = form1.selConditionD;		
		strConcatFieldValue +=  " " + strMasterScan + "ADD_USER='" + form1.ADD_USER.value + "' " + objConditionList.value;
	}
	
	if(form1.EDIT_USER.value != ""){
		objConditionList = form1.selConDocUser1;		
		strConcatFieldValue +=  " " + strMasterScan + "EDIT_USER='" + form1.EDIT_USER.value + "' " + objConditionList.value;
	}
	/*
	if( strConcatFieldValue.length > 0 ){
		strConcatFieldValue = strConcatFieldValue.substr( 0 , strConcatFieldValue.lastIndexOf( " " + objConditionList.value ) );
	}
	*/

	if( strConcatFieldValue.length == 0 ) {
		if( form1.chkDocumentUser1.checked ) {
			strConcatFieldValue += " DOCUMENT_USER='" + form1.USER_ID.value +"'";
		}else {
			strConcatFieldValue += "";
		}
	}else {
		if( form1.chkDocumentUser1.checked ) {
			strConcatFieldValue += " DOCUMENT_USER='" + form1.USER_ID.value +"' " +objConditionList.value;
			strConcatFieldValue = strConcatFieldValue.substr( 0 , strConcatFieldValue.lastIndexOf( objConditionList.value ) );
		}else {
		//if( strConcatFieldValue.length > 0 ){
			strConcatFieldValue = strConcatFieldValue.substr( 0 , strConcatFieldValue.lastIndexOf( objConditionList.value ) );
		}
	}
	
	form1.DOCUMENT_DATA_VALUE.value = strConcatFieldValue;
}

function set_concat_document_field(){
	var arrField = form1.CONCAT_FIELD_NAME.value.split( "," );
	var strFieldValue  			  = "";
	var strConcatFieldValue 	  = "";
	var strConcatToDateFieldValue = "";
	var strOperatorValue 		  = "";
	var strDocumentFieldValue     = "";
	var strConcatSearchValue      = "";
	var strConcatOperator         = "";
	var strConcatCondition        = "";

	var objDocumentField;
	var objDspDocumentField;
	var objConditionList;
	var objOperatorList;
	
	var intIndex = 0;

	for( var intCount = 0 ; intCount < arrField.length ; intCount++ ){
		objDocumentField = eval( "form1." + arrField[ intCount ] );
		strDocumentFieldValue = objDocumentField.value;
		
		strConcatSearchValue += strDocumentFieldValue + "<&>";

		if(objDocumentField.name.indexOf( "DSP_" ) == -1){
			intIndex++;
		}

		strConcatCondition += eval("form1.selCondition" + intIndex).value + ",";
		strConcatOperator  += eval("form1.selOperator" + intIndex).value + ",";
				
		if( objDocumentField != null && objDocumentField.name.indexOf( "DSP_" ) == -1 && objDocumentField.value.length > 0 ){
			
			objConditionList = eval("form1.selCondition" + intIndex);
			objOperatorList  = eval("form1.selOperator"  + intIndex);

			if(objOperatorList.value == "%A%"){
				strOperatorValue = " LIKE ";
				strDocumentFieldValue	 = "%" + strDocumentFieldValue + "%"; 
			}else if(objOperatorList.value == "A%"){
				strOperatorValue = " LIKE ";
				strDocumentFieldValue	 = strDocumentFieldValue + "%"; 
			}else{
				strOperatorValue = objOperatorList.value; 
			}
	
			switch( objDocumentField.getAttribute("value_type") ){
				case "number" :
					strFieldValue = strDocumentFieldValue;
					break;
				case "date" :
				case "date_eng" :
					
					if(!validate_date(objDocumentField)){
						check_current_date =  true;
					}else{
						check_current_date = false;
					}
					
					strFieldValue = "'" + sccUtils.dateToDb( objDocumentField.value ) + "'";
					
					objDspDocumentField = eval( "form1.TO_" + objDocumentField.name );
					if(objDspDocumentField.value != "" ){
						strConcatToDateFieldValue = " AND " + objDocumentField.name + "<= '" + sccUtils.dateToDb(objDspDocumentField.value) + "')";
					}
					break;
				case "zoom" :
					objDspDocumentField = eval( "form1." + objDocumentField.name );
					strFieldValue = "'" + objDspDocumentField.value + "'";
					
					break;
				case "tin" :
				case "pin" :
					strFieldValue = sccUtils.unMask( objDocumentField.value );
					if(objOperatorList.value == "%A%"){
						strFieldValue = "'%" + strFieldValue + "%'";
					}else if(objOperatorList.value == "A%"){
						strFieldValue = "'" + strFieldValue + "%'";
					}else{
						strFieldValue = "'" + strFieldValue + "'";
					}
					break;
				default :
					strFieldValue = "'" + strDocumentFieldValue.replace(/'/g,"''") + "'";
					break;
			}
			
			if(((objDocumentField.getAttribute("value_type") == "date")||(objDocumentField.getAttribute("value_type") == "date_eng"))&&(strConcatToDateFieldValue != "")){
				strConcatFieldValue += " (" + objDocumentField.name + ">=" + strFieldValue + strConcatToDateFieldValue + " " + objConditionList.value + " ";
			}else{
				//strConcatFieldValue += " " + objDocumentField.name + strOperatorValue + strFieldValue + " " + objConditionList.value + " ";
				strConcatFieldValue += " " + "LOWER(" + objDocumentField.name + ")" + strOperatorValue + "LOWER(" + strFieldValue + ")" + " " + objConditionList.value + " ";
			}
			
			strConcatToDateFieldValue = "";
		}
	}

	if( strConcatFieldValue.length == 0 ) {
		if( form1.chkDocumentUser2.checked ) {
			strConcatFieldValue += " DOCUMENT_USER='" + form1.USER_ID.value +"'";
		}else {
			strConcatFieldValue += "";
		}
	}else {
		if( form1.chkDocumentUser2.checked ) {
			strConcatFieldValue += " DOCUMENT_USER='" + form1.USER_ID.value +"' " +objConditionList.value;
			strConcatFieldValue = strConcatFieldValue.substr( 0 , strConcatFieldValue.lastIndexOf( objConditionList.value ) );
		}else {
		//if( strConcatFieldValue.length > 0 ){
			strConcatFieldValue = strConcatFieldValue.substr( 0 , strConcatFieldValue.lastIndexOf( objConditionList.value ) );
		}
	}

	if( strConcatSearchValue.length != 0 ){
		strConcatSearchValue = strConcatSearchValue.substr( 0 , strConcatSearchValue.lastIndexOf( "<&>" ) );
	}
	
	if( strConcatCondition.length != 0 ){
		strConcatCondition = strConcatCondition.substr( 0 , strConcatCondition.lastIndexOf( "," ) );
	}
	
	if( strConcatOperator.length != 0 ){
		strConcatOperator = strConcatOperator.substr( 0 , strConcatOperator.lastIndexOf( "," ) );
	}

	form1.DOCUMENT_FIELD_VALUE.value = strConcatFieldValue;
	form1.SEARCH_FIELD_VALUE.value   = strConcatSearchValue;
	form1.SEARCH_CONDITION.value     = strConcatCondition;
	form1.SEARCH_OPERATOR.value      = strConcatOperator;
}

function validate_date(obj_date){

	if(sccUtils.dateToDb(obj_date.value).length < 8){
    	 	alert( lc_day_invalid );
	        obj_date.focus();
	        obj_date.select();
	        return false;
    	 }
    	 
    	 if(obj_date.value.length != 10){
    	 	alert( lc_day_invalid );
    	 	obj_date.focus();
	        obj_date.select();
	        return false;
    	 }
    	 
   /* 	 if(sccUtils.dateToDb(obj_date.value)> <%=strCurrentDate%>){
    	 	alert( lc_verify_check_date );
    	 	obj_date.focus();
    	 	obj_date.select();
	        return false;
    	 }
    */	 
   	 return true;   	
}	

function window_onload() {
	change_tab_img();
	
	get_condition();
}

function get_condition(){
	form1.selConditionA.value  = "<%=strSelConA%>"; 
	form1.selConditionB.value  = "<%=strSelConB%>"; 
	form1.selConditionC.value  = "<%=strSelConC%>"; 
	form1.selConditionD.value  = "<%=strSelConD%>"; 
	form1.selConditionE.value  = "<%=strSelConE%>"; 
	form1.selConditionF.value  = "<%=strSelConF%>";
}

function change_rdo(obj_rdo, obj_name){
	eval("form1." + obj_name ).value = obj_rdo.value ;
	
	if(obj_rdo.value == "ROWNUM"){
		form1.COUNT_RECORD.focus();
	}
}

//-->
</script>
<link href="css/edas.css" type="text/css" rel="stylesheet">
</head>
<body onLoad="MM_preloadImages('images/txt_condition_over.gif','images/txt_searchtotal_over.gif','images/txt_searchresult_over.gif','images/btt_new_over.gif','images/btt_search_over.gif','images/i_new_over.jpg','images/i_search_over.jpg','images/i_export_over.jpg','images/i_doc_over.jpg','images/i_out_over.jpg');window_onload()" >
<form name="form1" action="" method="post">
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
    <tr> 
    	<td height="39" valign="top" background="images/pw_07.jpg">
            <table width="100%" height="62" border="0" cellpadding="0" cellspacing="0">
                <tr> 
                    <td height="62" background="images/inner_img_03.jpg"> 
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr> 
                                <td width="117"><img src="images/inner_img_01.jpg" width="117" height="62"></td>
			        <td valign="bottom"><%=strBttFunction %><a href="#" onclick="click_cancel()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('i_out','','images/i_out_over.jpg',1)"><img src="images/i_out.jpg" name="i_out" width="56" height="62" border="0"></a></td>
			        <td width="*" align="right"><div class="label_bold1">
                                    <div align="right" style="padding-right: 30px">
                                        <span class="label_header02" title="<%=strProjectCode %>"><%=strProjectName %></span><br>
			                <span class="label_bold5">(<%=screenname %>)</span></div>
                                    </div>
                                </td>
                            </tr>
	            	</table>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
    	<td height="29" valign="top" background="images/inner_img_07.jpg">
            <table width="100%" border="0" cellpadding="0" cellspacing="0" class="navbar_01">
                <tr> 
                    <td width="117"><img src="images/inner_img_05.jpg" width="117" height="29"></td>
<%
				String	strButtSearch = "";
				strButtSearch += "<a href=\"javascript:change_tab_search('div_search_index','txt_condition')\" onMouseOut=\"change_tab_img()\" onMouseOver=\"MM_swapImage('search_detail','','images/txt_condition_over.gif',1)\"><img id=\"txt_condition\" src=\"images/txt_condition.gif\" name=\"search_detail\" height=25 border=0></a>";
				strButtSearch += "<img id=\"txt_searchtotal\" src=\"images/txt_searchtotal.gif\" name=\"searchtotal\" width=117 height=25 border=0 style=\"display: none\">";
				strButtSearch += "<a href=\"javascript:change_tab_search('div_search_result','txt_searchresult')\" onMouseOut=\"change_tab_img()\" onMouseOver=\"MM_swapImage('searchresult','','images/txt_searchresult_over.gif',1)\"><img id=\"txt_searchresult\" src=\"images/txt_searchresult.gif\" name=\"searchresult\" width=117 height=25 border=0></a>";
%>		          
                    <td width="419" height="29" background="images/inner_img_07.jpg"><%=strButtSearch%></td>
                    <td width="*" class="navbar_01" align="right" style="padding-right: 30px">(<%=strUserOrgName%>) <%=lb_user_name %> : <%=strUserName %> 
		            (<%=strUserId%> / <%=strUserLevel%>)
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td valign="top" align="center">
    	<!-- div id="div_search_index" style="display:inline" > -->
            <table width="790" border="0" cellspacing="0" cellpadding="0">
                <tr> 
                    <td> <br>
                        <table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
                            <tr valign="bottom">
                                <td width="18"><img src="images/data_blank_01.gif" width="18" height="20"></td>
                                <td width="714"><img src="images/data_blank_03.gif" height="20" width="714"></td>
                                <td width="18"><img src="images/data_blank_04.gif" width="18" height="20"></td>
                            </tr>
                            <tr>
                                <td background="images/data_06.gif"><img src="images/data_06.gif" width="18" height="6"></td>
                                <td bgcolor="#f7f6f2">
                                <!-- ---------------------------------------------- Search Option ------------------------------------------- -->           
                                    <table width="700" border="0" align="center" cellpadding="0" cellspacing="0" class="label_bold2">
                                        <tbody> 
                                            <col width="168" />
					    <col width="208" />
                                            <col width="240" />
                                            <col width="84"  />
                                        </tbody>
                                        <tr> 
                                            <td><%=lb_sort_order %></td>
                                            <td>
                                                <input type="radio" name="radiobutton2" value="ASC" onclick="change_rdo(this,'ORDER_TYPE')" checked> <%=lb_sort_asc %> 
                                            </td>
                                            <td>
                                                <input type="radio" name="radiobutton2" value="DESC" onclick="change_rdo(this,'ORDER_TYPE')"> <%=lb_sort_desc %>
                                            </td>
                                            <td><input type="hidden" name="ORDER_TYPE" value="ASC"/></td>
		                    	</tr>
		                    	<tr> 
                                            <td><%=lb_count_record %></td>
                                            <td>
		                      		<input type="radio" name="radiobutton3" value="TOTAL" onclick="change_rdo(this,'SEARCH_DISPLAY')" checked> <%=lb_all_record %>
                                            </td>
                                            <td>
		                      		<input type="radio" name="radiobutton3" value="ROWNUM" onclick="change_rdo(this,'SEARCH_DISPLAY')"> <%=lb_get_record %> 
		                        	<input name="COUNT_RECORD" type="text" class="input_box" size="5" value=50 onkeypress="keypress_number()" style="text-align:right"> <%=lb_records %> 
                                            </td>
                                            <td><input type="hidden" name="SEARCH_DISPLAY" value="TOTAL"/></td>
		                    	</tr>
					<tr> 
                                            <td><%=lb_page_sizes %></td>
                                            <td colspan="3">
                                                <select name="PAGE_SIZE"  class="combobox">
                                                    <option value="10">10</option>
                                                    <option value="20">20</option>
                                                    <option value="30">30</option>
                                                    <option value="40">40</option>
                                                    <option value="50">50</option>
                                                    <option value="100">100</option>
						</select>
						&nbsp;<%=lb_rec_per_page %>
                                            </td>
		                    	</tr>
                                    </table>
                                <!-- -------------------------------------- End Search Option ---------------------------------------- -->				
                 		</td>
                                <td background="images/data_09.gif"><img src="images/data_09.gif" width="18" height="6"></td>
                            </tr>
                            <tr>
                                <td><img src="images/data_13.gif" width="18" height="20"></td>
                                <td background="images/data_15.gif"><img src="images/data_15.gif" width="5" height="20"></td>
                                <td><img src="images/data_16.gif" width="18" height="20"></td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>     		
            <div id="div_search_index" style="display:inline" >
    		<table width="790" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                        <td>	            		
                            <table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
			      	<tr> 
                                    <td width="18"><img src="images/data_01.gif" width="18" height="37"></td>
				    <td width="760" background="images/data_04.gif"><img id="img_data" src="images/data.gif" width="164" height="37" onclick="change_div('data')" style="cursor:pointer"></td>
				    <td width="18"><img src="images/data_05.gif" width="18" height="37"></td>
                                </tr>
                                <tr> 
                                    <td background="images/data_06.gif"><img src="images/data_06.gif" width="18" height="6"></td>
                                    <td bgcolor="#f7f6f2">
                                    <!-- ---------------------------------- DIV DATA-------------------------------------------- -->
                                        <div id="div_data" style="display:inline">
                                            <table width="700" border="0" align="center" cellpadding="0" cellspacing="0" class="label_bold2">
                                                <tr> 
                                                    <td width="169"><%=lb_document_number %></td>
                                                    <td width="184"><input name="BATCH_NO" type="text" class="input_box" maxlength="12" value="<%=strBatchNo %>" onkeypress="keypress_number();field_press( this );"></td>
                                                    <td width="275">&nbsp;</td>
                                                    <td width="72">
                                                        <select name="selConditionA" class="combobox">
                                                            <option value="AND">AND</option>
                                                            <option value="RUE">OR</option>
                                                        </select>
                                                    </td>
                                                </tr>
                                                <tr> 
                                                    <td width="169"><%=lb_document_name %></td>
                                                    <td width="459" colspan="2"><input name="DOCUMENT_NAME" type="text" class="input_box" maxlength="500" size="55" value="<%=strDocumentName %>" onkeypress="field_press( this );"></td>
                                                    <!-- td width="275">&nbsp;</td -->
                                                    <td width="72">
                                                        <select name="selConditionE" class="combobox">
                                                            <option value="AND">AND</option>
                                                            <option value="RUE">OR</option>
                                                        </select>
                                                    </td>
                                                </tr>
                                                <tr> 
                                                    <td><%=lb_create_date %></td>
                                                    <td><input name="ADD_DATE" type="text" class="input_box" maxlength="8" value="<%=strAddDate %>" onkeypress="keypress_number();field_press( this );" onBlur="set_format_date( this );"> 
                                                        <a href="javascript:showCalendar(form1.ADD_DATE,<%=strLangFlag %>)"><img src="images/calendar.gif" width=16 height=16 align="absmiddle" border=0 ></a> 
                                                        <%=lb_to_date %> 
                                                    </td>
                                                    <td><input name="TO_ADD_DATE" type="text" class="input_box" maxlength="8" value="<%=strToAddDate %>" onkeypress="keypress_number();field_press( this );" onBlur="set_format_date( this );"> 
                                                        <a href="javascript:showCalendar(form1.TO_ADD_DATE,<%=strLangFlag %>)"><img src="images/calendar.gif" width=16 height=16 align="absmiddle" border=0 ></a> 
                                                    </td>
                                                    <td>
                                                        <select name="selConditionB" class="combobox">
                                                            <option value="AND">AND</option>
                                                            <option value="RUE">OR</option>
                                                        </select> 
                                                    </td>
                                                </tr>
                                                <tr> 
                                                    <td><%=lb_edit_date %></td>
                                                    <td><input name="EDIT_DATE" type="text" class="input_box" maxlength="8" value="<%=strEditDate %>" onkeypress="keypress_number();field_press( this );" onBlur="set_format_date( this );"> 
                                                        <a href="javascript:showCalendar(form1.EDIT_DATE,<%=strLangFlag %>)"><img src="images/calendar.gif" width=16 height=16 align="absmiddle" border=0 ></a> 
                                                        <%=lb_to_date %> 
                                                    </td>
                                                    <td><input name="TO_EDIT_DATE" type="text" class="input_box" maxlength="8" value="<%=strToEditDate %>" onkeypress="keypress_number();field_press( this );" onBlur="set_format_date( this );"> 
                                                        <a href="javascript:showCalendar(form1.TO_EDIT_DATE,<%=strLangFlag %>)"><img src="images/calendar.gif" width=16 height=16 align="absmiddle" border=0 ></a> 
                                                    </td>
                                                    <td><select name="selConditionC" class="combobox">
                                                            <option value="AND">AND</option>
                                                            <option value="RUE">OR</option>
                                                        </select>
                                                    </td>
                                                </tr>
                                                <tr> 
                                                    <td><%=lb_document_user %></td>
                                                    <td><input id="txtDocUser" name="txtDocUser" type="text" class="input_box_disable" value="<%=strDocUser %>" size="25" readonly> 
                                                            <a href="javascript:openDocUserZoom('DOC_USER', '<%=lb_doc_user %>');"><img src="images/search.gif" width=16 height=16 align="absmiddle" border=0></a> 
                                                    </td>
                                                    <td>
                                                            <input id="txtDocUserName" name="txtDocUserName" type="text" class="input_box_disable" size="45" value="<%=strDocUserName %>" readonly>
                                                            <input name="txtDocOrg" type="hidden" value="" >
                                                    </td>
                                                    <td><select name="selConditionF" class="combobox">
                                                                    <option value="AND">AND</option>
                                                                    <option value="RUE">OR</option>
                                                            </select>
                                                    </td>
                                                </tr>
                                                <tr> 
                                                    <td><%=lb_create_user %></td>
                                                    <td><input id="ADD_USER" name="ADD_USER" type="text" class="input_box_disable" size="25" value="<%=strAddUser %>" readonly> 
                                                            <a href="javascript:openZoomUserProfile('ADD_USER_NAME','ADD_USER');"><img src="images/search.gif" width=16 height=16 align="absmiddle" border=0></a> 
                                                    </td>
                                                    <td><input id="ADD_USER_NAME" name="ADD_USER_NAME" type="text" class="input_box_disable" size="45" value="<%=strAddUserName %>" readonly></td>
                                                    <td><select name="selConditionD" class="combobox">
                                                                    <option value="AND">AND</option>
                                                                    <option value="RUE">OR</option>
                                                            </select>
                                                    </td>
                                                </tr>
                                                <tr> 
                                                    <td><%=lb_edit_user %></td>
                                                    <td><input id="EDIT_USER" name="EDIT_USER" type="text" class="input_box_disable" size="25" value="<%=strEditUser %>" readonly> 
                                                        <a href="javascript:openZoomUserProfile('EDIT_USER_NAME','EDIT_USER');"><img src="images/search.gif" width=16 height=16 align="absmiddle" border=0></a> 
                                                    </td>
                                                    <td><input id="EDIT_USER_NAME" name="EDIT_USER_NAME" type="text" class="input_box_disable" size="45" value="<%=strEditUserName %>" readonly></td>
                                                    <td>
                                                        <select name="selConDocUser1" class="combobox">
                                                            <option value="AND">AND</option>
                                                            <option value="RUE">OR</option>
                                                        </select>
                                                    </td>
                                                </tr>
                                                <tr> 
                                                    <td width="169">&nbsp;</td>
                                                    <td colspan="3">
                                                        <input type="checkbox" id="chkDocumentUser1" >&nbsp;<%=lb_chk_document_user %>
                                                        <input type="hidden" id="hidDocumentUser" name="hidDocumentUser" value="">
                                                    </td>
                                                </tr>
                                                <tr valign="bottom"> 
                                                    <td height="30" colspan="4">
                                                        <div align="center">
                                                            <a href="javascript:click_search_data()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('search','','images/btt_search_over.gif',1)"><img src="images/btt_search.gif" name="search" width="67" height="22" border="0"></a>
                                                            <a href="javascript:clear_search_data()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('btt_new','','images/btt_new_over.gif',1)"><img src="images/btt_new.gif" name="btt_new" width="67" height="22" border="0"></a> 
                                                        </div>
                                                    </td>
                                                </tr>
                                            </table>
                                        </div>
                                    </td>
                                    <td background="images/data_09.gif"><img src="images/data_09.gif" width="18" height="6"></td>
                                </tr>
                                <tr> 
                                    <td><img src="images/data_13.gif" width="18" height="20"></td>
                                    <td background="images/data_15.gif"><img src="images/data_15.gif" width="5" height="20"></td>
                                    <td><img src="images/data_16.gif" width="18" height="20"></td>
                                </tr>
                            </table>			        
                            <!-- ---------------------------------- [END] DIV DATA -------------------------------------------- -->					        
                            <table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
                                <tr> 
                                    <td width="18"><img src="images/data_01.gif" width="18" height="37"></td>
                                    <td width="760" background="images/data_04.gif"><img id="img_index" src="images/index.gif" width="164" height="37" onclick="change_div('index')" style="cursor:pointer"></td>
                                    <td width="18"><img src="images/data_05.gif" width="18" height="37"></td>
                                </tr>
                                <tr> 
                                    <td background="images/data_06.gif"><img src="images/data_06.gif" width="18" height="6"></td>
                                    <td bgcolor="#f7f6f2">
                                    <!-- ---------------------------------- DIV INDEX -------------------------------------------- -->
                                        <div id="div_index" style="display:inline">			                
                                            <table width="700" border="0" align="center" cellpadding="0" cellspacing="0" class="label_bold2">
<%
		
		if(bolFieldSuccess) {
			
			String strFieldLabel , strFieldName , strFieldType , strFieldLength , strFieldTableZoom , strFieldSize , strIsPK , strIsNotNull;
			String strTableLevel, strTableLevel1, strTableLevel2;
			//String strDefaultValue;
			String strTag 		= "";
			String strPrefix 	= "";
			String strSelected 	= "";
			
			String strTableLv1  	= "";
			String strTableLv1Label = "";
			String strTableLv2  	= "";
			String strTableLv2Label = "";
		
			strConcatFieldName = "";
			
			int	cnt = 0;
		
			while( con.nextRecordElement() ){
				strFieldLabel 	  = con.getColumn( "FIELD_LABEL" );
				strFieldName	  = con.getColumn( "FIELD_CODE" );
				strFieldType	  = con.getColumn( "FIELD_TYPE" );
				strFieldLength	  = con.getColumn( "FIELD_LENGTH" );
				strFieldTableZoom = con.getColumn( "TABLE_ZOOM" );
				strIsPK		      = con.getColumn( "IS_PK" );
				strIsNotNull	  = con.getColumn( "IS_NOTNULL" );
				strTableLevel	  = con.getColumn( "TABLE_LEVEL" );
				
				strTableLevel1	  = con.getColumn( "TABLE_LEVEL1" );
				strTableLevel2	  = con.getColumn( "TABLE_LEVEL2" );
		
				//strDefaultValue   = con.getColumn( "DEFAULT_VALUE" );
				
				strPrefix = "";
				if( strIsPK.equals( "Y" ) ){
					strPrefix += "<img src=\"images/iconkey.gif\">";
				}
				if( strIsNotNull.equals( "Y" ) ){
					strPrefix += "<img src=\"images/mark.gif\" width=12 height=11>";
				}
				
				strFieldSize = strFieldLength ;
				if( Integer.parseInt( strFieldSize ) > 40 ){
					strFieldSize = "40";
				}else{
					strFieldSize = String.valueOf( Integer.parseInt( strFieldSize ) + 2 );
				}
				
				strConcatFieldName += strFieldName + ",";
				
				if( strFieldType.equals( "CHAR" ) ){
					strTag = "\n<input type=\"text\" name=\"" + strFieldName + "\" value=\"\" class=\"input_box\" size=\"" + strFieldSize + "\" maxlength=\"" + strFieldLength + "\" is_PK=\"" + strIsPK + "\" is_NotNull=\"" + strIsNotNull + "\" onKeypress=\"field_press( this );\" />"; //onFocus=\"ocrFocus( this );\">";
				}else if( strFieldType.equals( "TIN" ) ){
					strTag = "\n<input type=\"text\" name=\"" + strFieldName + "\" class=\"input_box\" size=\"" + ( Integer.parseInt( strFieldSize ) + 5 ) + "\" maxlength=\"" + strFieldLength + "\" value_type=\"tin\" is_PK=\"" + strIsPK + "\" is_NotNull=\"" + strIsNotNull + "\" onKeypress=\"keypress_number();field_press( this );\" onblur=\"set_mask(this,'tin')\">";
				}else if( strFieldType.equals( "PIN" ) ){
					strTag = "\n<input type=\"text\" name=\"" + strFieldName + "\" class=\"input_box\" size=\"" + ( Integer.parseInt( strFieldSize ) + 5 ) + "\" maxlength=\"" + strFieldLength + "\" value_type=\"pin\" is_PK=\"" + strIsPK + "\" is_NotNull=\"" + strIsNotNull + "\" onKeypress=\"keypress_number();field_press( this );\" onblur=\"set_mask(this,'pin')\">";
				}else if( strFieldType.equals( "DATE" ) ){
					strTag  = "\n<input type=\"text\" name=\"" + strFieldName + "\" value=\"\" class=\"input_box\" size=\"10\" maxlength=\"10\" value_type=\"date\" is_PK=\"" + strIsPK + "\" is_NotNull=\"" + strIsNotNull + "\" onKeypress=\"keypress_number();field_press( this );\" onBlur=\"set_format_date( this );openToDate('" + strFieldName+ "')\">";
					strTag += "\n<a href=\"javascript:showCalendar(form1." + strFieldName + ",1)\"><img src=\"images/calendar.gif\" width=16 height=16 align=\"absmiddle\" border=0 ></a>";
					strTag += "\n &nbsp;&nbsp;" + lb_to_date + " &nbsp;<input type=\"text\" name=\"TO_" + strFieldName + "\" value=\"\" class=\"input_box_disable\" size=\"10\" maxlength=\"10\" value_type=\"date\" is_PK=\"" + strIsPK + "\" is_NotNull=\"" + strIsNotNull + "\" onKeypress=\"keypress_number();set_format_date( this );\" onBlur=\"set_format_date( this );\" readOnly>";
					strTag += "\n<a href=\"javascript:showCalendar(form1.TO_" + strFieldName + ",1)\"><img id=\"img_" + strFieldName + "\" src=\"images/calendar.gif\" width=16 height=16 align=\"absmiddle\" border=0 style=\"display:none\" ></a>";
				}else if( strFieldType.equals( "DATE_ENG" ) ){
					strTag  = "\n<input type=\"text\" name=\"" + strFieldName + "\" value=\"\" class=\"input_box\" size=\"10\" maxlength=\"10\" value_type=\"date_eng\" is_PK=\"" + strIsPK + "\" is_NotNull=\"" + strIsNotNull + "\" onKeypress=\"keypress_number();field_press( this );\" onBlur=\"set_format_date( this );openToDate('" + strFieldName+ "')\">";
					strTag += "\n<a href=\"javascript:showCalendar(form1." + strFieldName + ",0)\"><img src=\"images/calendar.gif\" width=16 height=16 align=\"absmiddle\" border=0 ></a>";
					strTag += "\n &nbsp;&nbsp;" + lb_to_date + " &nbsp;<input type=\"text\" name=\"TO_" + strFieldName + "\" value=\"\" class=\"input_box_disable\" size=\"10\" maxlength=\"10\" value_type=\"date_eng\" is_PK=\"" + strIsPK + "\" is_NotNull=\"" + strIsNotNull + "\" onKeypress=\"keypress_number();set_format_date( this );\" onBlur=\"set_format_date( this );\" readOnly>";
					strTag += "\n<a href=\"javascript:showCalendar(form1.TO_" + strFieldName + ",0)\"><img id=\"img_" + strFieldName + "\" src=\"images/calendar.gif\" width=16 height=16 align=\"absmiddle\" border=0 style=\"display:none\" ></a>";
				}else if( strFieldType.equals( "MONTH" ) ){
					strTag = "\n<select name=\"" + strFieldName + "\" class=\"combobox\" is_PK=\"" + strIsPK + "\" is_NotNull=\"" + strIsNotNull + "\" onKeypress=\"field_press( this );\">";
					strTag += "\n<option value=\"\"></option>";
					
					String strZoomDisplayValue = "";
					String strZoomDisplayText  = "";
					
					boolean bolnZoomSuccess = con1.executeService( strContainerName , "IMPORTDATA" , "findMonthCombo" );		
					if( bolnZoomSuccess ){
						while( con1.nextRecordElement() ){
							strZoomDisplayValue = con1.getColumn( "MONTH" );
							strZoomDisplayText  = con1.getColumn( "MONTH_NAME" );
								
							strTag += "\n<option value=\"" + strZoomDisplayValue + "\"" + strSelected + ">" + strZoomDisplayText + "</option>";
						}
					}		
					strTag += "\n</select>";
				}else if( strFieldType.equals( "MONTH_ENG" ) ){
					strTag = "\n<select name=\"" + strFieldName + "\" class=\"combobox\" is_PK=\"" + strIsPK + "\" is_NotNull=\"" + strIsNotNull + "\" onKeypress=\"field_press( this );\">";
					strTag += "\n<option value=\"\"></option>";
					
					String strZoomDisplayValue = "";
					String strZoomDisplayText  = "";
					
					con1.addData( "TABLE_ZOOM" , "String" , "MONTH_ENG" );
					boolean bolnZoomSuccess = con1.executeService( strContainerName , "IMPORTDATA" , "findTableCode" );		
					if( bolnZoomSuccess ){
						while( con1.nextRecordElement() ){
							strZoomDisplayValue = con1.getColumn( "MONTH_ENG" );
							strZoomDisplayText  = con1.getColumn( "MONTH_ENG_NAME" );
								
							strTag += "\n<option value=\"" + strZoomDisplayValue + "\"" + strSelected + ">" + strZoomDisplayText + "</option>";
						}
					}		
					strTag += "\n</select>";
				}else if( strFieldType.equals( "YEAR" ) ){
					strTag = "\n<input type=\"text\" name=\"" + strFieldName + "\" class=\"input_box\" size=\"" + ( Integer.parseInt( strFieldSize ) + 5 ) + "\" maxlength=\"" + strFieldLength + "\" value_type=\"year\" is_PK=\"" + strIsPK + "\" is_NotNull=\"" + strIsNotNull + "\" onKeypress=\"keypress_number();field_press( this );\">";
				}else if( strFieldType.equals( "NUMBER" ) ){
					strTag = "\n<input type=\"text\" name=\"" + strFieldName + "\" value=\"\" class=\"input_box\" size=\"" + strFieldSize + "\" maxlength=\"" + strFieldLength + "\" value_type=\"number\" is_PK=\"" + strIsPK + "\" is_NotNull=\"" + strIsNotNull + "\" onKeypress=\"keypress_number();field_press( this );\" />"; //onFocus=\"ocrFocus( this );\">";
				}else if( strFieldType.equals( "CURRENCY" ) ){
					strTag = "\n<input type=\"text\" name=\"" + strFieldName + "\" value=\"\" class=\"input_box\" size=\"" + strFieldSize + "\" maxlength=\"" + strFieldLength + "\" value_type=\"number\" is_PK=\"" + strIsPK + "\" is_NotNull=\"" + strIsNotNull + "\" onKeypress=\"keypress_currency(this);field_press( this );\" />"; //onFocus=\"ocrFocus( this );\">";
				}else if( strFieldType.equals( "MEMO" ) ){
					strTag = "\n<input type=\"text\" name=\"" + strFieldName + "\" value=\"\" class=\"input_box\" size=\"" + strFieldSize + "\" maxlength=\"" + strFieldLength + "\" is_PK=\"" + strIsPK + "\" is_NotNull=\"" + strIsNotNull + "\" onKeypress=\"field_press( this );\" />"; //onFocus=\"ocrFocus( this );\">";
				}else if( strFieldType.equals( "ZOOM" ) ){
					strTag = "\n<input type=\"hidden\" id=\"" + strFieldName + "\" name=\"" + strFieldName + "\" value=\"\" value_type=\"zoom\" is_PK=\"" + strIsPK + "\" is_NotNull=\"" + strIsNotNull + "\">";
				
					strTag += "\n<input type=\"text\" id=\"DSP_" + strFieldName + "\" name=\"DSP_" + strFieldName + "\" value=\"\" class=\"input_box_disable\" size=\"40\" readonly>";
					strTag += "\n<a href=\"javascript:openZoom('" + strFieldTableZoom + "' , '" + strFieldLabel + "' , form1.DSP_" + strFieldName + " , form1." + strFieldName + ", '" + strTableLevel +"');\"><img src=\"images/search.gif\" width=16 height=16 align=\"absmiddle\" border=0></a>";
					
					if(strTableLevel.equals("1")){
						strTag += "\n<input type=\"hidden\" name=\"FIELD_" + strFieldTableZoom + "\" value=\"" + strFieldName + "\">";
					
					}
					
					if(strTableLevel.equals("2")){
						con1.addData("PROJECT_CODE", "String", strProjectCode);
						con1.addData("TABLE_CODE"  , "String", strTableLevel1);
					    boolean bolSuccessLv2 = con1.executeService(strContainerName, "IMPORTDATA", "findFieldTableZoom");
					    if(bolSuccessLv2){
					    	strTableLv1 	 = con1.getHeader("FIELD_CODE");
					    	strTableLv1Label = con1.getHeader("FIELD_LABEL");
					    	
					    	strTag += "\n<input type=\"hidden\" name=\"FIELD_" + strFieldTableZoom + "_LV1\" value=\"" + strTableLv1 + "\">";
							strTag += "\n<input type=\"hidden\" name=\"FIELD_" + strFieldTableZoom + "_LV1_LABEL\" value=\"" + strTableLv1Label + "\">";
							strTag += "\n<input type=\"hidden\" name=\"FIELD_" + strFieldTableZoom + "_LV1_CODE\" value=\"" + strTableLevel1 + "\">";
							strTag += "\n<input type=\"hidden\" name=\"FIELD_" + strTableLevel1 + "_LV2\" value=\"" + strFieldName + "\">";
					    }						    
						strTag += "\n<input type=\"hidden\" name=\"FIELD_" + strFieldTableZoom + "\" value=\"" + strFieldName + "\">";
					
					}
		
					if(strTableLevel.equals("3")){
						con1.addData("PROJECT_CODE", "String", strProjectCode);
						con1.addData("TABLE_CODE"  , "String", strTableLevel1);
					    boolean bolSuccessLv3 = con1.executeService(strContainerName, "IMPORTDATA", "findFieldTableZoom");
					    if(bolSuccessLv3){
					    	strTableLv1 	 = con1.getHeader("FIELD_CODE");
					    	strTableLv1Label = con1.getHeader("FIELD_LABEL");
					    	
					    	strTag += "\n<input type=\"hidden\" name=\"FIELD_" + strFieldTableZoom + "_LV1\" value=\"" + strTableLv1 + "\">";
							strTag += "\n<input type=\"hidden\" name=\"FIELD_" + strFieldTableZoom + "_LV1_LABEL\" value=\"" + strTableLv1Label + "\">";
							strTag += "\n<input type=\"hidden\" name=\"FIELD_" + strFieldTableZoom + "_LV1_CODE\" value=\"" + strTableLevel1 + "\">";
							strTag += "\n<input type=\"hidden\" name=\"FIELD_" + strTableLevel1 + "_LV3\" value=\"" + strFieldName + "\">";
					    }
					    con1.addData("PROJECT_CODE", "String", strProjectCode);
						con1.addData("TABLE_CODE"  , "String", strTableLevel2);
						
					    bolSuccessLv3 = con1.executeService(strContainerName, "IMPORTDATA", "findFieldTableZoom");
					    if(bolSuccessLv3){
					    	strTableLv2 	 = con1.getHeader("FIELD_CODE");
					    	strTableLv2Label = con1.getHeader("FIELD_LABEL");
					    	
					    	strTag += "\n<input type=\"hidden\" name=\"FIELD_" + strFieldTableZoom + "_LV2\" value=\"" + strTableLv2 + "\">";
							strTag += "\n<input type=\"hidden\" name=\"FIELD_" + strFieldTableZoom + "_LV2_LABEL\" value=\"" + strTableLv2Label + "\">";
							strTag += "\n<input type=\"hidden\" name=\"FIELD_" + strFieldTableZoom + "_LV2_CODE\" value=\"" + strTableLevel2 + "\">";
							strTag += "\n<input type=\"hidden\" name=\"FIELD_" + strTableLevel2 + "_LV3\" value=\"" + strFieldName + "\">";
					    }
						strTag += "\n<input type=\"hidden\" name=\"FIELD_" + strFieldTableZoom + "\" value=\"" + strFieldName + "\">";
						
					}
					
					strConcatFieldName += "DSP_" + strFieldName + ",";
				}else if( strFieldType.equals( "LIST" ) ){
					strTag = "\n<select name=\"" + strFieldName + "\" class=\"combobox\" is_PK=\"" + strIsPK + "\" is_NotNull=\"" + strIsNotNull + "\" onKeypress=\"field_press( this );\">";
					strTag += "\n<option value=\"\"></option>";
					
					String strZoomDisplayValue = "";
					String strZoomDisplayText  = "";
					
					con1.addData( "TABLE_ZOOM" , "String" , strFieldTableZoom );
		
					boolean bolnZoomSuccess = con1.executeService( strContainerName , "IMPORTDATA" , "findTableCode" );
		
					if( bolnZoomSuccess ){
						while( con1.nextRecordElement() ){
							strZoomDisplayValue = con1.getColumn( strFieldTableZoom );
							strZoomDisplayText  = con1.getColumn( strFieldTableZoom + "_NAME" );
							
						//	if( strZoomDisplayValue.equals( strDefaultValue ) ){
						//		strSelected = " selected";
						//	}else{
						//		strSelected = "";
						//	}
		
							strTag += "\n<option value=\"" + strZoomDisplayValue + "\"" + strSelected + ">" + strZoomDisplayText + "</option>";
						}
					}
		
					strTag += "\n</select>";
				}
				
				cnt++;

%>							                    
                                                <tr> 
                                                    <td width="169"><span id="<%=strFieldName%>_span"><%=strFieldLabel %></span></td>
                                                    <td width="82">
                                                        <select name="selOperator<%=cnt %>" class="combobox" style="width:60px">
                                                    <% if( strFieldType.equals( "CHAR" )||strFieldType.equals( "MEMO" )||strFieldType.equals( "PIN" )||strFieldType.equals( "TIN" ) ) {%> 		
                                                            <option value="%A%">?A?</option>
                                                            <option value="A%">A?</option>
                                                    <%	} %>
                                                            <option value="=">=</option>
                                                    <%	if( strFieldType.equals( "NUMBER" )||strFieldType.equals( "CURRENCY" )||strFieldType.equals( "DATE" )||strFieldType.equals( "DATE_END" )||strFieldType.equals( "YEAR" ) ) { %>
                                                            <option value=">">&gt;</option>
                                                            <option value="<">&lt;</option>
                                                            <option value=">=">&gt;=</option>
                                                            <option value="<=">&lt;=</option>
                                                            <option value="<>">&lt;&gt;</option>
                                                     <%	} %> 		
                                                        </select>
                                                    </td>
                                                    <td><%=strTag%></td>
                                                    <td width="72">
                                                        <select name="selCondition<%=cnt%>" class="combobox">
                                                            <option value="AND">AND</option>
                                                            <option value="RUE">OR</option>
                                                        </select>
                                                    </td>
                                                </tr>
<%					
				}
				
				if( strConcatFieldName.length() > 0 ){
					strConcatFieldName = strConcatFieldName.substring( 0 , strConcatFieldName.length() - 1 );
				}
			}
%>
                                                <tr> 
                                                    <td width="169">&nbsp;</td>
                                                    <td colspan="3">
                                                        <input type="checkbox" id="chkDocumentUser2" >&nbsp;<%=lb_chk_document_user %>
                                                        <input type="hidden" id="hidDocumentUser" name="hidDocumentUser" value="">
                                                    </td>
                                                </tr>
                                                <tr valign="bottom"> 
                                                    <td height="30" colspan="4">
                                                        <div align="center">
                                                                <a href="javascript:click_search_index()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('search1','','images/btt_search_over.gif',1)"><img src="images/btt_search.gif" name="search1" width="67" height="22" border="0" ></a> 
                                                                <a href="javascript:clear_search_index()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('btt_new1','','images/btt_new_over.gif',1)"><img src="images/btt_new.gif" name="btt_new1" width="67" height="22" border="0" ></a> 
                                                        </div>
                                                    </td>
                                                </tr>
                                            </table>
                                        </div>  	
                                    </td>
                                    <td background="images/data_09.gif"><img src="images/data_09.gif" width="18" height="6"></td>
                                </tr>
                                <tr> 
                                    <td><img src="images/data_13.gif" width="18" height="20"></td>
                                    <td background="images/data_15.gif"><img src="images/data_15.gif" width="5" height="20"></td>
                                    <td><img src="images/data_16.gif" width="18" height="20"></td>
                                </tr>
                            </table>       		    	
                            <!-- ---------------------------------- [END] DIV INDEX -------------------------------------------- -->
                            
                            <table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
                                <tr> 
                                    <td width="18"><img src="images/data_01.gif" width="18" height="37"></td>
                                    <td width="760" background="images/data_04.gif"><img id="img_document" src="images/document.gif" width="164" height="37" onclick="change_div('document')" style="cursor:pointer"></td>
                                    <td width="18"><img src="images/data_05.gif" width="18" height="37"></td>
                                </tr>
                                <tr> 
                                    <td background="images/data_06.gif"><img src="images/data_06.gif" width="18" height="6"></td>
                                    <td bgcolor="#f7f6f2">
                                    <!-- ---------------------------------- DIV DOCUMENT -------------------------------------------- -->			                
                                        <div id="div_document" style="display:inline">
                                            <table width="700" border="0" align="center" cellpadding="0" cellspacing="0" class="label_bold2">
                                                <tr> 
                                                    <td width="169"><%=lb_detail_document %></td>
                                                    <td colspan="2"><input name="txtDOCUMENT_DESC" type="text" value="<%=strDocumentDesc %>" class="input_box" size="56" onkeypress="field_press(this)"><input name="DOCUMENT_DESC" type="hidden"></td>
                                                    <td width="72">
                                                        <select name="selConDocUser3" class="combobox">
                                                            <option value="AND">AND</option>
                                                            <option value="RUE">OR</option>
                                                        </select>
                                                    </td>
                                                </tr>
                                                <tr> 
                                                    <td width="169">&nbsp;</td>
                                                    <td colspan="3">
                                                        <input type="checkbox" id="chkDocumentUser3" >&nbsp;<%=lb_chk_document_user %>
                                                        <input type="hidden" id="hidDocumentUserCon" name="hidDocumentUserCon" value="">
                                                    </td>
                                                </tr>
                                                <tr valign="bottom"> 
                                                    <td height="30" colspan="4">
                                                        <div align="center">
                                                            <a href="javascript:click_search_desc()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('search2','','images/btt_search_over.gif',1)"><img src="images/btt_search.gif" name="search2" width="67" height="22" border="0" ></a> 
                                                            <a href="javascript:clear_search_desc()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('btt_new2','','images/btt_new_over.gif',1)"><img src="images/btt_new.gif" name="btt_new2" width="67" height="22" border="0" ></a> 
                                                        </div>
                                                    </td>
                                                </tr>
                                            </table>
                                        </div>
                                    </td>
                                    <td background="images/data_09.gif"><img src="images/data_09.gif" width="18" height="6"></td>
                                </tr>
                                <tr> 
                                    <td><img src="images/data_13.gif" width="18" height="20"></td>
                                    <td background="images/data_15.gif"><img src="images/data_15.gif" width="5" height="20"></td>
                                    <td><img src="images/data_16.gif" width="18" height="20"></td>
                                </tr>
                            </table>
                            <!-- ---------------------------------- [END] DIV INDEX -------------------------------------------- -->   	
                        </td>
                    </tr>
                </table>
            </div>
            <div id="div_search_all" style="display:none"></div>
        </td>
    </tr>
</table>
<script type="text/javascript">
<!--

<%	if(arrFieldName.length > 1){
		
		if(arrSearchField.length > 0){
			for(int idx=0;idx<arrSearchField.length;idx++){
				if(!arrCondition[idx].equals("")){
%>			
					form1.<%=arrFieldName[idx]%>.value = "<%=arrSearchField[idx]%>";		
					form1.selCondition<%=idx+1%>.value = "<%=arrCondition[idx]%>";		
					form1.selOperator<%=idx+1%>.value = "<%=arrOperator[idx]%>";		
<%				}
			}
		} 
	}
%>

//-->
</script>
<input type="hidden" name="screenname" value="<%=screenname%>">
<input type="hidden" name="user_role"  value="<%=user_role%>">
<input type="hidden" name="app_group"  value="<%=app_group%>">
<input type="hidden" name="app_name"   value="<%=app_name%>">
<input type="hidden" name="METHOD" 	   value="<%=strMethod%>">
<input type="hidden" name="FROM_PAGE"  value="SEARCH_INDEX"	>
<input type="hidden" name="CHECK_CLICK" >
<input type="hidden" name="ROW_CLICK" >
<input type="hidden" name="USER_ID"    value="<%=strUserId%>">

<input type="hidden" name="CONCAT_FIELD_NAME" value="<%=strConcatFieldName %>">
<input type="hidden" name="DOCUMENT_FIELD_VALUE">
<input type="hidden" name="DOCUMENT_DATA_VALUE">
<input type="hidden" name="SEARCH_FIELD_VALUE">
<input type="hidden" name="SEARCH_OPERATOR">
<input type="hidden" name="SEARCH_CONDITION">

<input type="hidden" name="BATCH_NO_SEARCH">
<input type="hidden" name="DOCUMENT_NAME_SEARCH">
<input type="hidden" name="ADD_DATE_SEARCH">
<input type="hidden" name="TO_ADD_DATE_SEARCH">
<input type="hidden" name="EDIT_DATE_SEARCH">
<input type="hidden" name="TO_EDIT_DATE_SEARCH">
<input type="hidden" name="txtDocUser_SEARCH">
<input type="hidden" name="txtDocUserName_SEARCH">
<input type="hidden" name="ADD_USER_SEARCH">
<input type="hidden" name="ADD_USER_NAME_SEARCH">
<input type="hidden" name="EDIT_USER_SEARCH">
<input type="hidden" name="EDIT_USER_NAME_SEARCH">
<input type="hidden" name="selConditionA_SEARCH">
<input type="hidden" name="selConditionB_SEARCH">
<input type="hidden" name="selConditionC_SEARCH">
<input type="hidden" name="selConditionD_SEARCH">
<input type="hidden" name="selConditionE_SEARCH">
<input type="hidden" name="selConditionF_SEARCH">

</form>
</body>
</html>
