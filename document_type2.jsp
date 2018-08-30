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

	String user_role  = getField(request.getParameter("user_role"));
	String app_group  = getField(request.getParameter("app_group"));
	String app_name   = getField(request.getParameter("app_name"));
	String screenname = getField(request.getParameter("screenname"));

	String 	strClassName 	 = "DOCUMENT_TYPE";
	String 	strmsg           = "";
	String	screenLabel      = "";
	String	strCurrentDate	 = "";
        String  strVersionLang   = ImageConfUtil.getVersionLang();
	
	if(strVersionLang.equals("thai")){
		strCurrentDate = getTodayDateThai();
	}else{
		strCurrentDate = getTodayDate();
	}
	
	UserInfo userInfo = (UserInfo)session.getAttribute( "USER_INFO" );
	String strUserId 	  = userInfo.getUserId();
	String strProjectCode = userInfo.getProjectCode();
	
	String strMode              = getField(request.getParameter("MODE"));
	String strDocumentTypeKey   = getField(request.getParameter("DOCUMENT_TYPE_KEY"));
        String strDocumentTypeNameKey  = getField(request.getParameter("DOCUMENT_TYPE_NAME_KEY"));

        String strDocumentTypeData     = getField(request.getParameter("txtDocumentType"));
        String strDocumentTypeNameData = getField(request.getParameter("txtDocumentTypeName"));
	
	boolean bolnSuccess;
	
	if( strMode.equals( "pInsert" ) ) {
		screenLabel = lb_add;		
            con.addData( "PROJECT_CODE" , "String" , strProjectCode);
            bolnSuccess = con.executeService( strContainerName , strClassName , "findSeqnDocType" );

        if( !bolnSuccess){
            strmsg="showMsg(0,0,\" " +  lc_data_not_found + "\")";
            strMode = "MAIN";
        	
        }else{
            strDocumentTypeData = con.getHeader( "MAX_DOC" );
            while(strDocumentTypeData.length() < 3 ){
                strDocumentTypeData = "0" + strDocumentTypeData;
            }
            
            if(strDocumentTypeData.equals("000")){
            	strDocumentTypeData = "001";
            }
        }
    }else if( strMode.equals( "pEdit" ) ) {
    	screenLabel = lb_edit;
        strDocumentTypeData 	= strDocumentTypeKey;
        strDocumentTypeNameData = strDocumentTypeNameKey;
    }
	
	if(strMode.equals("ADD")){
		strDocumentTypeNameData = strDocumentTypeNameData.replaceAll( "'", "&acute;" );
        con.addData( "PROJECT_CODE" 	  , "String" , strProjectCode);
        con.addData( "DOCUMENT_TYPE" 	  , "String" , strDocumentTypeData);
        con.addData( "DOCUMENT_TYPE_NAME" , "String" , strDocumentTypeNameData);
        con.addData( "USER_LEVEL"         , "String" , "0");
        con.addData( "USER_ID" 			  , "String" , strUserId);
        con.addData( "CURRENT_DATE" 	  , "String" , strCurrentDate);

        bolnSuccess = con.executeService( strContainerName , strClassName , "createDocumentType"  );

        if( !bolnSuccess ){
            strmsg  ="showMsg(0,0,\" " + lc_can_not_insert_document_type + "\")";
            strMode = "pInsert";

        }else{
            strmsg="showMsg(0,0,\" " +  lc_insert_document_type_successfull + "\")";
            strMode = "MAIN";
        }
     }else if(strMode.equals("EDIT")){
    	 strDocumentTypeNameData = strDocumentTypeNameData.replaceAll( "'", "&acute;" );
         con.addData( "PROJECT_CODE" 		, "String" , strProjectCode);
         con.addData( "DOCUMENT_TYPE" 		, "String" , strDocumentTypeData);
         con.addData( "DOCUMENT_TYPE_NAME" 	, "String" , strDocumentTypeNameData);
         con.addData( "USER_ID" 		, "String" , strUserId);
         con.addData( "CURRENT_DATE" 		, "String" , strCurrentDate);

         bolnSuccess = con.executeService( strContainerName , strClassName , "updateDocumentType"  );

         if( !bolnSuccess ){
             
             strmsg="showMsg(0,0,\" " + lc_can_not_edit_document_type + "\")";
             strMode = "pEdit";
         }else{
             strmsg="showMsg(0,0,\" " + lc_edit_document_type_successfull  + "\")";
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
<script language="JavaScript" src="js/util.js"></script>
<script language="JavaScript" src="js/constant.js"></script>
<script language="JavaScript" src="js/label.js"></script>
<script language="javascript" type="text/javascript">
<!--

function click_save( ){
    if(verify_form()){
        if(form1.MODE.value == "pInsert"){
            form1.MODE.value = "ADD" ;
        }else{
            form1.MODE.value = "EDIT" ;
        }

        form1.submit();
    }
}

function click_cancel(  ){
    form1.action 	 = "document_type1.jsp";
    form1.target 	 = "_self";
    form1.MODE.value = "SEARCH";
    form1.submit();

}

function verify_form(){
    
    if (form1.txtDocumentTypeName.value.length == 0){
        alert(lc_check_name_document_type);
        form1.txtDocumentTypeName.focus();
        return false;
    }

    return true;
}

function window_onload(){

	lb_doc_type.innerHTML 		= lbl_doc_type;
    lb_doc_type_name.innerHTML  = lbl_doc_type_name;
    
	form1.txtDocumentTypeName.focus();
	
	if(form1.MODE.value == "MAIN"){
        form1.action =   "document_type1.jsp";
        form1.target = "_self";
        form1.MODE.value = "SEARCH";
        form1.submit();
    }
}

//-->
</script>
</head>
<body onload="MM_preloadImages('images/btt_save2_over.gif','images/btt_cancel_over.gif');window_onload()">
<form name="form1" action="" method="post">
	<table width="800" border="0" cellspacing="0" cellpadding="0">
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
          	<td width="115" align="center" valign="top">&nbsp;</td>
          	<td  align="center" valign="top">&nbsp;</td>
          	<td width="92" align="center" valign="top">&nbsp;</td>
        </tr>
        <tr>
          	<td align="right">&nbsp;</td>
          	<td height="25"><span class="label_bold2" id="lb_doc_type"></span>&nbsp;<img src="images/mark.gif" width="12" height="11"></td>
          	<td height="25" ><input name="txtDocumentType" type="text" class="input_box_disable" size="5" maxlength="5" value="<%=strDocumentTypeData%>" readonly></td>
          	<td align="center" valign="top">&nbsp;</td>
        </tr>
        <tr>
          	<td align="right">&nbsp;</td>
          	<td height="25"><span class="label_bold2" id="lb_doc_type_name"></span>&nbsp;<img src="images/mark.gif" width="12" height="11"></td>
          	<td height="25" ><input name="txtDocumentTypeName" type="text" class="input_box" size="50" maxlength="100" value="<%=strDocumentTypeNameData %>"></td>
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
<input type="hidden" name="MODE" 		value="<%=strMode%>">
<input type="hidden" name="screenname"  value="<%=screenname%>">
<input type="hidden" name="user_role" 	value="<%=user_role%>">
<input type="hidden" name="app_group" 	value="<%=app_group%>">            
<input type="hidden" name="app_name" 	value="<%=app_name%>">
</form>
</body>
</html>
<%  if (!strmsg.equals("")) {  %>
<script language="javaScript">
    <%=strmsg%>
</script>
<%  }   %>