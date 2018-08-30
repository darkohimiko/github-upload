<%@ page contentType="text/html; charset=tis-620"%>
<%@ page import="com.scc.security.UserInfo"%>
<%@ include file="inc/checkUser.jsp" %>
<%@ include file="inc/constant.jsp" %>
<%@ include file="inc/utils.jsp" %>
<jsp:useBean id="con" scope="session" class="edms.cllib.EABConnector"/>
<jsp:useBean id="con2" scope="session" class="edms.cllib.EABConnector"/>
<%
	UserInfo userInfo = (UserInfo)session.getAttribute( "USER_INFO" );
	
	con.setRemoteServer("EAS_SERVER");
	con2.setRemoteServer("EAS_SERVER");

	String user_role   = getField(request.getParameter("user_role"));
	String app_name    = getField(request.getParameter("app_name"));
	String app_group   = getField(request.getParameter("app_group"));
	String screenname  = getField(request.getParameter("screenname"));
	
	String  strClassName     = "DOCUMENT_TYPE";
	String  strMode          = getField(request.getParameter("MODE"));
	String	strmsg			 = "";
	String	strErrorMessage  = "";
	String	strErrorCode	 = "";
	String	strPermission	 = "";
	String	strTotalSize	 = "";
	
	String	strProjectCode 		= userInfo.getProjectCode();
	String	strDocumentTypeTemp = getField(request.getParameter("DOCUMENT_TYPE_TEMP"));
	
	if(strMode.equals("")){
		strMode = "SEARCH";	
	}
	
	boolean bolnSuccess = false;
	boolean bolSuccess2 = false;

	con2.addData("USER_ROLE", 		  "String", user_role);
	con2.addData("APPLICATION", 	  "String", app_name);
       con2.addData("APPLICATION_GROUP", "String", app_group);
       bolSuccess2 = con2.executeService(strContainerName, strClassName, "findPermission");
       if(bolSuccess2) {
       	while(con2.nextRecordElement()) {
       		strPermission = con2.getColumn("PERMIT_FUNCTION");
       	}
       }
	
	if(strMode.equals("DELETE")) {
		
		con.addData( "PROJECT_CODE" , "String" , strProjectCode );
        con.addData( "DOCUMENT_TYPE" , "String" , strDocumentTypeTemp );

        bolnSuccess = con.executeService( strContainerName , strClassName , "deleteDocumentType"  );
        if( !bolnSuccess ){	
        	strErrorCode = con.getRemoteErrorCode();
        	if(strErrorCode.equals("ERR00002")){
        		strmsg="showMsg(0,0,\" " + lc_doc_have_used_files + "\")";	
        	}else{
        		strmsg="showMsg(0,0,\" " + lc_cannot_delete_document_type + "\")";
        	}
            	         
        }else{	         
            strmsg="showMsg(0,0,\" " + lc_delete_data_successful + "\")";	         
        }			
		strMode = "SEARCH";
	}
	
	if(strMode.equals("SEARCH")) {
		
		con.addData( "PROJECT_CODE" , "String" , strProjectCode );
        bolnSuccess = con.executeService( strContainerName , strClassName , "findDocumentType" );

        if( !bolnSuccess){
        	strErrorMessage = con.getRemoteErrorMesage();
        }
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=TIS-620">
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
<script language="javaScript" type="text/javascript">
<!--

function click_new() {
	formadd.MODE.value = "pInsert";
    formadd.submit();
}

function click_edit(lv_strValue){
    formadd.DOCUMENT_TYPE_KEY.value = lv_strValue.getAttribute("DOCUMENT_TYPE");
    formadd.DOCUMENT_TYPE_NAME_KEY.value = lv_strValue.getAttribute("DOCUMENT_TYPE_NAME");
    
    formadd.MODE.value  = "pEdit";
    formadd.action 	= "document_type3.jsp";
    formadd.submit();
}

function click_delete(lv_strValue){
	form1.DOCUMENT_TYPE_TEMP.value = lv_strValue.getAttribute("DOCUMENT_TYPE");
    if( form1.DOCUMENT_TYPE_TEMP.value.length == 0 ){
        alert(lc_select_data_for_delete);
        return;
        
    }else {
         if (showMsg( 0 , 1 , lc_confirm_delete)){
            form1.MODE.value = "DELETE";
			form1.method 	 = "post";
			form1.action	 = "document_type1.jsp";
			form1.submit();
         }
    }
}

function window_onload(){
	lb_doc_type.innerHTML 	= lbl_doc_type;
    lb_doc_type_name.innerHTML  = lbl_doc_type_name;
    lb_total_record.innerHTML 	= lbl_total_record;
    lb_record.innerHTML       	= lbl_record;
}
//-->
</script>
</head>
<body onLoad="MM_preloadImages('images/btt_edit2_over.gif','images/btt_delete_over.gif','images/btt_addnew_over.gif');window_onload()">
<form name="form1" action="" method="post">
<table width="100%" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
<tr><td valign="top">
<div id="screen_div" style="width:100%;height:100%;overflow-y:scroll;overflow-x:hidden;margin-right:0px;margin-bottom:0px;border:0px #ccc solid;" >
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
  <tr>
    <td valign="top">	
	<table width="800" border="0" cellspacing="0" cellpadding="0">
    	<tbody>
    		<col width="10%" />
    		<col width="76%" />
    		<col width="14%" />
    	</tbody>          
       	<tr>
           	<td height="25" class="label_header01" colspan="3">
           	&nbsp;&nbsp;&nbsp;<%=screenname%>
       		</td>
       	</tr>
       	<tr>
       		<td height="25" colspan="3"></td>
       	</tr>
        <tr>
            <td align="center" class="label_bold2">&nbsp;</td>
            <td width="76%" align="center" valign="top">
           		<table width="80%" border="0" align="center" cellpadding="0" cellspacing="0">
            		<tr class="hd_table">
	                 	<td width="10" align="left"><img src="images/hd_tb_01.gif" width="10" height="28"></td>
	                 	<td width="54"><div align="center"><span id="lb_doc_type"></span></div></td>
	                 	<td width="226"><div align="left"><span id="lb_doc_type_name"></span></div></td>
	                 	<td width="56">&nbsp;</td>
	                 	<td width="56">&nbsp;</td>
	                 	<td align="right"><img src="images/hd_tb_04.gif" width="10"></td>
	              	</tr>
	            </table>
	       		<div id="table_div" style="width:80%;height:380px;overflow-y:scroll;overflow-x:hidden;margin-right:0px;margin-bottom:0px;border:0px #ccc solid;" >
	       		<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">  	
<%
			
			if(strMode.equals("SEARCH") && bolnSuccess){
			
				String	strDocumentType 	= "";
				String	strDocumentTypeName = "";
				String	strScript			= "";
				int 	idx,count			= 0;
				
				while(con.nextRecordElement()) {
					idx = (count%2) + 1;
					strDocumentType 	= con.getColumn("DOCUMENT_TYPE");
					strDocumentTypeName = con.getColumn("DOCUMENT_TYPE_NAME");
			
					strScript = "DOCUMENT_TYPE=\"" + strDocumentType + "\" DOCUMENT_TYPE_NAME=\"" + strDocumentTypeName + "\"";		
%>	              	
	              	<tr class="table_data<%=idx%>">
	                 	<td width="10">&nbsp;</td>
	                 	<td width="54"><div align="center"><%=strDocumentType %></div></td>
	                 	<td align="left"><%=strDocumentTypeName %></td>
	                 	<td width="56"><div align="center">
	                 	<% if(strPermission.indexOf("update") != -1){ %>
	                 		<a href="#" onclick="click_edit(this)" <%=strScript %> onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('btt_edit<%=count %>','','images/btt_edit2_over.gif',1)"><img src="images/btt_edit2.gif" name="btt_edit<%=count %>" width="52" height="18" border="0"></a>
	                 	<% } %>
	                 	</div></td>
	                 	<td width="56"><div align="center">
	                 	<% if(strPermission.indexOf("delete") != -1){ %>
	                 		<a href="#" onclick="click_delete(this)" <%=strScript %> onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('btt_delete<%=count %>','','images/btt_delete_over.gif',1)"><img src="images/btt_delete.gif" name="btt_delete<%=count %>" width="52" height="18" border="0"></a>
	                 	<% } %>	
                 		</div></td>
	                 	<td width="10">&nbsp;</td>
	              	</tr>
<%
					count++;
				}
				
				strTotalSize = String.valueOf(count);
			}else {
				strTotalSize = "0";
%>				
					<tr class="table_data1">
	                 	<td colspan="6"><div align="center"><%=strErrorMessage %></div></td>
	                </tr> 					
<%			}
%>	              	
	         	</table>
	         	</div>
	         	<table width="80%" height="28" border="0" align="center" cellpadding="0" cellspacing="0">
                    <tr class="footer_table">
                        <td align="left" >&nbsp;&nbsp;<span id="lb_total_record"></span>&nbsp;&nbsp;<%=strTotalSize%>&nbsp;&nbsp;<span id="lb_record"></span></td>
                    </tr>
                </table>
      		</td>
        	<td>&nbsp;</td>
  		</tr>
        <tr>
	       <td colspan="3">&nbsp;</td>
	    </tr>
	    <tr>
	       	<td colspan="3"><div align="center">
	       	<% if(strPermission.indexOf("insert") != -1){ %>
	       		<a href="javascript:click_new()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('btt_addnew','','images/btt_addnew_over.gif',1)"><img src="images/btt_addnew.gif" name="btt_addnew" width="102" height="22" border="0"></a>
	       	<% } %>
	       			</div>
	       			</td>
				</tr>
			</table>
		</td>
    </tr>
</table>
</div>
</td></tr>
</table>
	<input type="hidden" name="screenname" value="<%=screenname%>">
	<input type="hidden" name="user_role" value="<%=user_role%>">
	<input type="hidden" name="app_group" value="<%=app_group%>">
	<input type="hidden" name="app_name" value="<%=app_name%>">
	<input type="hidden" name="MODE" value="<%=strMode%>">
	<input type="hidden" name="DOCUMENT_TYPE_TEMP" value="<%=strDocumentTypeTemp%>">
</form>	
<form name="formadd" method="post" action="document_type2.jsp" target = "_self">
<input type="hidden" name="MODE" value="">
<input type="hidden" name="DOCUMENT_TYPE_KEY" value="">
<input type="hidden" name="DOCUMENT_TYPE_NAME_KEY" value="">
<input type="hidden" name="screenname" value="<%=screenname%>">
<input type="hidden" name="user_role" value="<%=user_role%>">
<input type="hidden" name="app_group" value="<%=app_group%>">
<input type="hidden" name="app_name" value="<%=app_name%>">       
</form>	
</body>
</html>
<%  if (!strmsg.equals("")) {  %>
<script language="javaScript">
    <%=strmsg%>
</script>
<%  }   %>