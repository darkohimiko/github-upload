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
	String strUserId 	  = userInfo.getUserId();
	String strProjectCode = userInfo.getProjectCode();
	
	String user_role  = checkNull(request.getParameter("user_role"));
	String app_group  = checkNull(request.getParameter("app_group"));
	String app_name   = checkNull(request.getParameter("app_name"));
	String screenname = getField(request.getParameter("screenname"));
	
	String 	strClassName 	 	= "BOX_MANAGE";
	String 	strmsg 			 	= "", strErrorMessage="";
	String	screenLabel      	= "";
	String	strCurrentDate	 	= "";
	String	strCurrentYear	 	= "";
	String	strDspOpenBoxDate	= "";
	String	strDspExpireDate 	= "";
	String  strLangFlag         = "";
        String strVersionLang = ImageConfUtil.getVersionLang();
	
	String strMode 		 = checkNull(request.getParameter("MODE"));
	String strBoxSeqnKey = checkNull(request.getParameter("BOX_SEQN_KEY"));
    String strYearKey 	 = checkNull(request.getParameter("YEAR_KEY"));

    String strBoxNoData 	  = checkNull(request.getParameter("BOX_NO"));
    String strOpenBoxDateData = checkNull(request.getParameter("OPEN_BOX_DATE"));
    String strDocumentAgeData = checkNull(request.getParameter("DOCUMENT_AGE"));
    String strExpireDateData  = checkNull(request.getParameter("EXPIRE_DATE"));
    String strBoxLabelData 	  = getField(request.getParameter("BOX_LABEL"));
    String strBoxSeqnData 	  = checkNull(request.getParameter("BOX_SEQN"));
    String strYearData 		  = checkNull(request.getParameter("YEAR"));
    
	boolean bolnSuccess;
	boolean bolnSearchDataSuccess = false;
	
	if(strVersionLang.equals("thai")){
		strCurrentDate = getTodayDateThai();
		strLangFlag    = "1";
	}else{
		strCurrentDate = getTodayDate();
		strLangFlag    = "0";
	}
	
	if(strCurrentDate.length() >= 8 ){
		strCurrentYear = strCurrentDate.substring(0,4);
	}
	
	if(strYearData.equals("")){
		strYearData = strCurrentYear;		
	}
	
	if( strMode.equals( "pInsert" ) ) {
		screenLabel = lb_add_new_box;
		strDspOpenBoxDate = dateToDisplay(strCurrentDate,"/");
		
        con.addData( "PROJECT_CODE" , "String" , strProjectCode);
        con.addData( "YEAR" 		, "String" , strCurrentYear);
        bolnSuccess = con.executeService( strContainerName , strClassName , "findBoxNo" );

        if( !bolnSuccess){
            strmsg="showMsg(0,0,\" " +  lc_data_not_found + "\")";
            strMode = "MAIN";
        	
        }else{
        	strBoxSeqnData = con.getHeader( "BOX_NO" );
            while(strBoxSeqnData.length() < 4 ){
            	strBoxSeqnData = "0" + strBoxSeqnData;
            }
            
            if(strBoxSeqnData.equals("0000")){
            	strBoxSeqnData = "0001";
            }
            
            strBoxNoData = strBoxSeqnData + "/" + strCurrentYear;
        }
    }else if( strMode.equals( "pEdit" ) ) {
    	screenLabel 	= lb_edit_box;
    	strBoxSeqnData 	= strBoxSeqnKey;
        strYearData 	= strYearKey;
        
        con.addData( "PROJECT_CODE"  , "String" , strProjectCode);
        con.addData( "YEAR" 	 	 , "String" , strYearData);
        con.addData( "BOX_SEQN" 	 , "String" , strBoxSeqnData);
        
        bolnSearchDataSuccess = con.executeService( strContainerName , strClassName , "findBoxManage"  );
        if( !bolnSearchDataSuccess){
        	strErrorMessage = con.getRemoteErrorMesage();
        	strMode = "MAIN";
        }else{
        	strBoxNoData 		= con.getHeader("BOX_NO");
        	strBoxLabelData 	= con.getHeader("BOX_LABEL");
        	strOpenBoxDateData 	= con.getHeader("OPEN_BOX_DATE");
        	strDocumentAgeData 	= con.getHeader("DOCUMENT_AGE");
        	strExpireDateData 	= con.getHeader("EXPIRE_DATE");
	    }
        
        if(!strOpenBoxDateData.equals("")){
        	strDspOpenBoxDate = dateToDisplay(strOpenBoxDateData, "/");
        }
        
        if(!strExpireDateData.equals("")){
        	strDspExpireDate = dateToDisplay(strExpireDateData, "/");
        }
    }

	if(strMode.equals("ADD")){
        con.addData( "PROJECT_CODE"  , "String" , strProjectCode);
        con.addData( "YEAR" 	 	 , "String" , strYearData);
        con.addData( "BOX_SEQN" 	 , "String" , strBoxSeqnData);
        con.addData( "BOX_NO"		 , "String" , strBoxNoData);
        con.addData( "BOX_LABEL"	 , "String" , strBoxLabelData);
        con.addData( "OPEN_BOX_DATE" , "String" , strOpenBoxDateData);
        con.addData( "DOCUMENT_AGE"	 , "String" , strDocumentAgeData);
        con.addData( "EXPIRE_DATE" 	 , "String" , strExpireDateData);
        con.addData( "USER_ID" 		 , "String" , strUserId);
        con.addData( "CURRENT_DATE"  , "String" , strCurrentDate);

        bolnSuccess = con.executeService( strContainerName , strClassName , "createBox"  );

        if( !bolnSuccess ){
            strmsg  ="showMsg(0,0,\" " + lc_can_not_insert_box_manage + "\")";
            strMode = "pInsert";

        }else{
            strmsg="showMsg(0,0,\" " +  lc_insert_box_manage_successful + "\")";
            strMode = "MAIN";
        }
        
     }else if(strMode.equals("EDIT")){
    	 con.addData( "PROJECT_CODE"  , "String" , strProjectCode);
    	 con.addData( "YEAR" 	 	  , "String" , strYearData);
         con.addData( "BOX_SEQN" 	  , "String" , strBoxSeqnData);
         con.addData( "BOX_NO"		  , "String" , strBoxNoData);
         con.addData( "BOX_LABEL"	  , "String" , strBoxLabelData);
         con.addData( "OPEN_BOX_DATE" , "String" , strOpenBoxDateData);
         con.addData( "DOCUMENT_AGE"  , "String" , strDocumentAgeData);
         con.addData( "EXPIRE_DATE"   , "String" , strExpireDateData);
         con.addData( "USER_ID" 	  , "String" , strUserId);
         con.addData( "CURRENT_DATE"  , "String" , strCurrentDate);

         bolnSuccess = con.executeService( strContainerName , strClassName , "updateBox"  );

         if( !bolnSuccess ){
             
             strmsg="showMsg(0,0,\" " + lc_cannot_edit_box_manage + "\")";
             strMode = "pEdit";
         }else{
             strmsg="showMsg(0,0,\" " + lc_edit_box_manage_successful  + "\")";
             strMode = "MAIN";
         }
      }
	
	
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=tis-620">
<title><%=lc_site_name%></title>
<link href="css/edas.css" type="text/css" rel="stylesheet">
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
<script language="JavaScript" src="js/jquery-1.9.1.js"></script>
<script language="javascript" type="text/javascript">
<!--

var sccUtils = new SCUtils();
var objZoomWindow = null;

function click_save( ){
    if(verify_form()){
    
    	form1.OPEN_BOX_DATE.value	= sccUtils.dateToDb(form1.DSP_OPEN_BOX_DATE.value);
    	form1.EXPIRE_DATE.value		= sccUtils.dateToDb(form1.DSP_EXPIRE_DATE.value);
    	
        if(form1.MODE.value == "pInsert"){
            form1.MODE.value = "ADD" ;
        }else{
            form1.MODE.value = "EDIT" ;
        }

        form1.submit();
    }
}

function click_cancel(  ){
    form1.action 	 = "box_manage1.jsp";
    form1.target 	 = "_self";
    form1.MODE.value = "SEARCH";
    form1.submit();

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

function set_format_date( obj_field ){
	if( obj_field.value.length == 8 && sccUtils.isDateValid( obj_field.value ) == "VALID_DATE" ){
		obj_field.value = sccUtils.formatDate( obj_field.value );
	}
}

function set_label(){
	var box_no 		  = form1.BOX_NO.value;
	var	open_box_date = sccUtils.dateToDb(form1.DSP_OPEN_BOX_DATE.value);
	var expire_date   = sccUtils.dateToDb(form1.DSP_EXPIRE_DATE.value);
	
	if(form1.BOX_LABEL.value != ""){
	//	return;
	}
	
	var box_label = box_no + "-" + open_box_date + "-" + expire_date;
	
	if(form1.DOCUMENT_AGE.value != "" && form1.DSP_OPEN_BOX_DATE.value != "" && form1.DSP_EXPIRE_DATE.value != ""){
		form1.BOX_LABEL.value = box_label;
	}
}

function set_expire_date(){
	var year 		= "";
	var expire_date = "";
	var expire_year = 0;
	var	open_box_date = sccUtils.dateToDb(form1.DSP_OPEN_BOX_DATE.value);
	var	doc_age = sccUtils.dateToDb(form1.DOCUMENT_AGE.value);
	
	if(form1.DSP_EXPIRE_DATE.value != ""){
	//	return;
	}
	
	if(doc_age == ""){
		doc_age = "0";
	}
	
	if(open_box_date.length >= 8 ){
		year 	= open_box_date.substring(0,4);
		expire_year = parseInt(year,10) + parseInt(doc_age,10);
		expire_date =  expire_year + open_box_date.substring(4,8); 
	}
	
	if(form1.DOCUMENT_AGE.value != "" && form1.DSP_OPEN_BOX_DATE.value != ""){
		form1.DSP_EXPIRE_DATE.value = sccUtils.dateToDisplay(expire_date);
	}
}

function verify_form(){
    
    if (form1.DSP_OPEN_BOX_DATE.value.length == 0){
        alert( lc_verify_open_box_date);
        form1.DSP_OPEN_BOX_DATE.focus();
        return false;
    }else{
    	 if(sccUtils.dateToDb(form1.DSP_OPEN_BOX_DATE.value).length < 8){
    	 	alert( lc_day_invalid);
	        form1.DSP_OPEN_BOX_DATE.select();
	        return false;
    	 }
    	 
    	 if(form1.DSP_OPEN_BOX_DATE.value.length != 10){
    	 	alert( lc_day_invalid);
	        form1.DSP_OPEN_BOX_DATE.select();
	        return false;
    	 }
    	 
    	 if(sccUtils.dateToDb(form1.DSP_OPEN_BOX_DATE.value)> <%=strCurrentDate%>){
    	 	alert( lc_verify_current_date );
    	 	form1.DSP_OPEN_BOX_DATE.select();
	        return false;
    	 }   	
    }
    
    if (form1.DOCUMENT_AGE.value.length == 0){
        alert( lc_verify_document_age );
        form1.DOCUMENT_AGE.focus();
        return false;
    }
    
    if (form1.DSP_EXPIRE_DATE.value.length == 0){
        alert( lc_verify_expired_date );
        form1.DSP_EXPIRE_DATE.focus();
        return false;
    }else{
    	if(sccUtils.dateToDb(form1.DSP_EXPIRE_DATE.value).length < 8){
    	 	alert( lc_expire_day_invalid);
	        form1.DSP_EXPIRE_DATE.select();
	        return false;
    	 }
    	 
    	 if(form1.DSP_EXPIRE_DATE.value.length != 10){
    	 	alert( lc_expire_day_invalid);
	        form1.DSP_EXPIRE_DATE.select();
	        return false;
    	 }
    }
    
    var open_date   = sccUtils.dateToDb(form1.DSP_OPEN_BOX_DATE.value);
    var expire_date = sccUtils.dateToDb(form1.DSP_EXPIRE_DATE.value);
    
    if(parseInt(expire_date) < parseInt(open_date)){
    	alert(lc_expire_day_more_create_day);
    	form1.DSP_EXPIRE_DATE.select();
    	return;
    }
    
    if (form1.BOX_LABEL.value.length == 0){
        alert( lc_verify_box_label );
        form1.BOX_LABEL.focus();
        return false;
    }

    return true;
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

function window_onload(){

	lb_box_no.innerHTML 		= lbl_box_no;
    lb_box_label.innerHTML  	= lbl_box_label;
    //storehouse.innerHTML   	 =	lbl_doc_location;
    lb_open_box_date.innerHTML  = lbl_open_box_date;
    lb_doc_expired.innerHTML  	= lbl_doc_expired;
    lb_doc_age.innerHTML  	= lbl_doc_age;
    
    form1.DSP_OPEN_BOX_DATE.focus();

    if(form1.MODE.value == "MAIN"){
	
	<%if(!strErrorMessage.equals("")){ %>
			showMsg(0,0, "<%=strErrorMessage%>");
	<%	}%>		
			
        form1.action 	 = "box_manage1.jsp";
        form1.target 	 = "_self";
        form1.MODE.value = "SEARCH";
        form1.submit();
    }
    
    $("#DSP_OPEN_BOX_DATE").keypress(function(e){
        if(e.keyCode == 13){
            $("#DOCUMENT_AGE").focus();
        }
    });
    $("#DOCUMENT_AGE").keypress(function(e){
        if(e.keyCode == 13){
            $("#DSP_EXPIRE_DATE").focus();
        }
    });
    $("#DSP_EXPIRE_DATE").keypress(function(e){
        if(e.keyCode == 13){
            $("#BOX_LABEL").focus();
        }
    });

}



function field_press( objField ){
	if( sccUtils.isEnter() ){
		window.event.keyCode = 0;
		switch( objField.name ){
			case "DSP_OPEN_BOX_DATE" : 
					form1.DOCUMENT_AGE.focus();
					break;
			case "DOCUMENT_AGE" : 
					form1.DSP_EXPIRE_DATE.focus();
					break;
			case "DSP_EXPIRE_DATE" : 
					form1.BOX_LABEL.focus();
					break;
			case "BOX_LABEL" : 
					//form1.BOX_LABEL.focus();
					break;
		}
	}
}

function window_onunload(){
	if( objZoomWindow != null && !objZoomWindow.closed ){
		objZoomWindow.close();
	}
}

//-->
</script>
</head>
<body onload="MM_preloadImages('images/btt_save2_over.gif','images/btt_cancel_over.gif');window_onload()" onunload="window_onunload();">
<form name="form1" action="" method="post" on>
	<table width="800" border="0" >
    	<tbody>
    		<col width="137" />
    		<col width="115" />
    		<col width="*" />
    		<col width="92" />    		
    	</tbody>          
       	<tr>
           	<td height="25" class="label_header01" colspan="4">
           	&nbsp;&nbsp;&nbsp;<%=screenname%> >> <%=screenLabel %>
       		</td>
       	</tr>       
        <tr>
          	<td width="137" align="right">&nbsp;</td>
          	<td width="150" align="center" valign="top">&nbsp;</td>
          	<td  align="center" valign="top">&nbsp;</td>
          	<td width="92" align="center" valign="top">&nbsp;</td>
        </tr>
        <tr>
          	<td align="right">&nbsp;</td>
          	<td height="25"><span class="label_bold2" id="lb_box_no"></span></td>
          	<td height="25" ><input name="BOX_NO" type="text" class="input_box_disable" size="10" value="<%=strBoxNoData%>" readonly></td>
          	<td align="center" valign="top">&nbsp;</td>
        </tr>
        <tr>
          	<td align="right">&nbsp;</td>
          	<td height="25"><span class="label_bold2" id="lb_open_box_date"></span>&nbsp;<img src="images/mark.gif" width="12" height="11"></td>
          	<td height="25" >
          		<input id="DSP_OPEN_BOX_DATE" name="DSP_OPEN_BOX_DATE" type="text" class="input_box" maxlength="8" size="12" value="<%=strDspOpenBoxDate %>" onkeypress="keypress_number();" onBlur="set_format_date( this );"> 
				<a href="javascript:showCalendar(form1.DSP_OPEN_BOX_DATE,<%=strLangFlag %>)"><img src="images/calendar.gif" width=16 height=16 align="absmiddle" border=0 ></a>
			</td>
          	<td align="center" valign="top">&nbsp;</td>
        </tr>
        <tr>
          	<td align="right">&nbsp;</td>
          	<td height="25"><span class="label_bold2" id="lb_doc_age"></span>&nbsp;<img src="images/mark.gif" width="12" height="11"></td>
          	<td height="25" ><input id="DOCUMENT_AGE" name="DOCUMENT_AGE" type="text" class="input_box" size="3" maxlength="3" value="<%=strDocumentAgeData %>" style="text-align:right;" onkeypress="keypress_number();" ></td>
          	<td align="center" valign="top">&nbsp;</td>
        </tr>
        <tr>
          	<td align="right">&nbsp;</td>
          	<td height="25"><span class="label_bold2" id="lb_doc_expired"></span>&nbsp;<img src="images/mark.gif" width="12" height="11"></td>
          	<td height="25" >
          		<input id="DSP_EXPIRE_DATE" name="DSP_EXPIRE_DATE" type="text" class="input_box" maxlength="8" size="12" value="<%=strDspExpireDate %>" onkeypress="keypress_number();" onBlur="set_format_date( this );" onfocus="set_expire_date()"> 
				<a href="javascript:showCalendar(form1.DSP_EXPIRE_DATE,<%=strLangFlag %>)"><img src="images/calendar.gif" width=16 height=16 align="absmiddle" border=0 ></a>
			</td>
          	<td align="center" valign="top">&nbsp;</td>
        </tr>
        <tr>
          	<td align="right">&nbsp;</td>
          	<td height="25"><span class="label_bold2" id="lb_box_label"></span>&nbsp;<img src="images/mark.gif" width="12" height="11"></td>
          	<td height="25" ><input id="BOX_LABEL" name="BOX_LABEL" type="text" class="input_box" size="50" maxlength="100" value="<%=strBoxLabelData %>" onfocus="set_label()"></td>
          	<td align="center" valign="top">&nbsp;</td>
        </tr>
        <tr>
          	<td align="right">&nbsp;</td>
          	<td align="center">&nbsp;</td>
          	<td >&nbsp;</td>
          	<td align="center" valign="top">&nbsp;</td>
        </tr>
        <tr>
          	<td colspan="4"><div align="center">
          	<a href="javascript:click_save()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('btt_save2','','images/btt_save2_over.gif',1)"><img src="images/btt_save2.gif" name="btt_save2" width="67" height="22" border="0"></a>
          	<a href="javascript:click_cancel()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('btt_cancel','','images/btt_cancel_over.gif',1)"><img src="images/btt_cancel.gif" name="btt_cancel" width="67" height="22" border="0"></a>
          	</div></td>
        </tr>
   	</table>
<input type="hidden" name="MODE" 	value="<%=strMode%>">
<input type="hidden" name="screenname"  value="<%=screenname%>">
<input type="hidden" name="user_role" 	value="<%=user_role%>">
<input type="hidden" name="app_group" 	value="<%=app_group%>">            
<input type="hidden" name="app_name" 	value="<%=app_name%>">

<input type="hidden" name="YEAR_KEY" 		value="<%=strYearKey%>">
<input type="hidden" name="BOX_SEQN_KEY" 	value="<%=strBoxSeqnKey%>">
<input type="hidden" name="YEAR" 			value="<%=strYearData%>">
<input type="hidden" name="BOX_SEQN" 		value="<%=strBoxSeqnData%>">
<input type="hidden" name="OPEN_BOX_DATE" 	value="">
<input type="hidden" name="EXPIRE_DATE" 	value="">
</form>
</body>
</html>
<%  if (!strmsg.equals("")) {  %>
<script language="javaScript">
    <%=strmsg%>
</script>
<%  }   %>