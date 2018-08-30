<%@ page contentType="text/html; charset=tis-620"%>
<%@ page import="com.scc.security.UserInfo"%>
<%@ include file="inc/checkUser.jsp" %>
<%@ include file="inc/constant.jsp" %>
<%@ include file="inc/label.jsp" %>
<%@ include file="inc/utils.jsp" %>
<jsp:useBean id="con" scope="session" class="edms.cllib.EABConnector"/>
<jsp:useBean id="con2" scope="session" class="edms.cllib.EABConnector"/>
<%
	con.setRemoteServer("EAS_SERVER");
	con2.setRemoteServer("EAS_SERVER");

	UserInfo userInfo       = (UserInfo)session.getAttribute( "USER_INFO" );
	String	 strProjectCode = userInfo.getProjectCode();		

	String user_role  = getField(request.getParameter("user_role"));
	String app_name   = getField(request.getParameter("app_name"));
	String app_group  = getField(request.getParameter("app_group"));
	String screenname = getField(request.getParameter("screenname"));

	String strMode         = getField(request.getParameter("MODE"));
	String strClassName    = "BOX_MANAGE";
	String strmsg          = "";
	String strErrorMessage = "";
	String strPermission   = "";

	if(strMode.equals("")){
		strMode = "SEARCH";	
	}
	
	String	strYearTemp    = getField(request.getParameter("YEAR_TEMP"));
	String	strBoxSeqnTemp = getField(request.getParameter("BOX_SEQN_TEMP"));
	
	String	strPageNumber = getField(request.getParameter("PAGENUMBER"));
	String	strPageSize   = getField(request.getParameter("PAGE_SIZE"));
	String	strTotalPage  = "1";	
	String	strTotalSize  = "0";
	
	if(strPageNumber.equals("")){
		strPageNumber = "1";
	}
	if(strPageSize.equals("")){
		strPageSize = "10";
	}
			
	boolean bolnSuccess = false;
	boolean bolSuccess2 = false;

	con2.addData("USER_ROLE", 		  "String", user_role);
	con2.addData("APPLICATION", 	  "String", app_name);
       con2.addData("APPLICATION_GROUP", "String", app_group);
       bolSuccess2 = con2.executeService(strContainerName, "DOCUMENT_TYPE", "findPermission");
       if(bolSuccess2) {
       	while(con2.nextRecordElement()) {
       		strPermission = con2.getColumn("PERMIT_FUNCTION");
       	}
       }
	
	if(strMode.equals("DELETE")) {
		
		con.addData( "PROJECT_CODE" , "String" , strProjectCode );
        con.addData( "YEAR" 	, "String" , strYearTemp );
        con.addData( "BOX_SEQN" , "String" , strBoxSeqnTemp );

        bolnSuccess = con.executeService( strContainerName , strClassName , "deleteBox"  );
        if( !bolnSuccess ){	
        		strmsg="showMsg(0,0,\" " + lc_box_have_used_files + "\")";	         
        }else{	         
            strmsg="showMsg(0,0,\" " + lc_delete_box_successful + "\")";	         
        }			
		strMode = "SEARCH";
	}
	
	if(strMode.equals("SEARCH")) {
	
		con.addData("PAGESIZE", 	 "String", strPageSize);
	    con.addData("PAGENUMBER", 	 "String", strPageNumber);
		con.addData( "PROJECT_CODE", "String" , strProjectCode );
        bolnSuccess = con.executeService( strContainerName , strClassName , "findBox" );

        if( !bolnSuccess){
        	strErrorMessage = con.getRemoteErrorMesage();
        }else{
	    	strTotalPage = con.getHeader( "PAGE_COUNT" );
	        strTotalSize = con.getHeader( "TOTAL_RECORD" );
	    }
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
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

function click_open_box() {
	formadd.MODE.value = "pInsert";
	formadd.submit();
}

function click_edit(lv_strValue){
    formadd.YEAR_KEY.value     = lv_strValue.getAttribute("YEAR");
    formadd.BOX_SEQN_KEY.value = lv_strValue.getAttribute("BOX_SEQN");
    
    formadd.MODE.value = "pEdit";
    formadd.submit();
}

function click_add_data( lv_strValue ){
    formInsert.YEAR.value 	   = lv_strValue.getAttribute("YEAR");
    formInsert.BOX_SEQN.value  = lv_strValue.getAttribute("BOX_SEQN");
    
    formInsert.submit();
}

function click_delete(lv_strValue){
	form1.YEAR_TEMP.value 	  = lv_strValue.getAttribute("YEAR");
	form1.BOX_SEQN_TEMP.value = lv_strValue.getAttribute("BOX_SEQN");
    if( form1.BOX_SEQN_TEMP.value.length == 0 ){
        alert(lc_select_data_for_delete);
        return;
        
    }else {
         if (showMsg(0,1,lc_confirm_delete)){
            form1.MODE.value = "DELETE";
			form1.method 	 = "post";
			form1.action	 = "box_manage1.jsp";
			form1.submit();
         }
    }
}

function click_navigator( strValue ){

    var strPageNumber = form1.PAGENUMBER.value;
	var strTotalPage  = form1.TOTALPAGE.value;

	var intPageNumber = parseInt( strPageNumber );
	var intTotalPage  = parseInt( strTotalPage );

	switch( strValue ){
		case "first" :
				if( intPageNumber == 1 ){return;}
				form1.PAGENUMBER.value = 1;
				break;
		case "prev" :
				if( intPageNumber == 1 ){return;}
				form1.PAGENUMBER.value = intPageNumber - 1;
				break;
		case "next" :
				if( intPageNumber == intTotalPage ){return;}
				form1.PAGENUMBER.value = intPageNumber + 1;
				break;
		case "last" :
				if( intPageNumber == intTotalPage ){return;}
				form1.PAGENUMBER.value = intTotalPage;
				break;
	}

    form1.submit();
}

function window_onload(){
	lb_box_no.innerHTML 		= lbl_box_no;
    lb_box_label.innerHTML  	= lbl_box_label;
    lb_open_box_date.innerHTML  = lbl_open_box_date;
    lb_doc_expired.innerHTML  	= lbl_doc_expired;
    
}
//-->
</script>
</head>
<body onLoad="MM_preloadImages('images/btt_edit2_over.gif','images/btt_delete_over.gif','images/btt_addnew_over.gif','images/btt_inputs_over.gif','images/btt_addbox_over.gif');window_onload()">
<form name="form1" action="" method="post">	
	<table width="800" border="0" >
    	<tr>
           	<td height="25" class="label_header01" >
           	&nbsp;&nbsp;&nbsp;<%=screenname%>
       		</td>
       	</tr>
       	<tr>
       		<td height="25"></td>
       	</tr>
        <tr>
            <td width="99%" align="center" valign="top">
           		<table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
            		<tr class="hd_table">
	                 	<td width="10"><img src="images/hd_tb_01.gif" width="10" height="28"></td>
	                 	<td width="56">&nbsp;<span id="lb_box_no"></span></td>
	                 	<td width="*"><span id="lb_box_label"></span></td>
	                 	<td width="100"><span id="lb_open_box_date"></span></td>
	                 	<td width="150"><span id="lb_doc_expired"></span></td>
	                 	<td width="56">&nbsp;</td>
	                 	<td width="56">&nbsp;</td>
	                 	<td width="56">&nbsp;</td>
	                 	<td align="right"><img src="images/hd_tb_04.gif" width="10"></td>
	              	</tr>
<%
			
			if(strMode.equals("SEARCH") && bolnSuccess){
			
				String	strBoxNoData 		= "";
				String	strBoxLabelData 	= "";
				String	strOpenBoxDateData 	= "";
				String	strExpireDateData 	= "";
				String	strBoxSeqnData 		= "";
				String	strYearData 		= "";
				
				String	strScript			= "";
				int 	idx,count			= 0;
				
				while(con.nextRecordElement()) {
					idx = (count%2) + 1;
					strBoxNoData 		= con.getColumn("BOX_NO");
					strBoxLabelData 	= con.getColumn("BOX_LABEL");
					strOpenBoxDateData 	= con.getColumn("OPEN_BOX_DATE");
					strExpireDateData 	= con.getColumn("EXPIRE_DATE");
					strBoxSeqnData 		= con.getColumn("BOX_SEQN");
					strYearData 		= con.getColumn("YEAR");
								
					strScript = "BOX_SEQN=\"" + strBoxSeqnData + "\" YEAR=\"" + strYearData + "\"";		
%>	              	
	              	<tr class="table_data<%=idx%>">
	                 	<td>&nbsp;</td>
	                 	<td align="left">&nbsp;<%=strBoxNoData %></td>
	                 	<td align="left">&nbsp;<%=strBoxLabelData %></td>
	                 	<td align="center">&nbsp;<%=dateToDisplay(strOpenBoxDateData,"/") %></td>
	                 	<td align="center">&nbsp;<%=dateToDisplay(strExpireDateData,"/") %></td>
	                 	<td><div align="center">
	                 	<% if(strPermission.indexOf("update") != -1){ %>
	                 		<a href="#" onclick="click_edit(this)" <%=strScript %> onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('btt_edit<%=count %>','','images/btt_edit2_over.gif',1)"><img src="images/btt_edit2.gif" name="btt_edit<%=count %>" width="52" height="18" border="0"></a>
	                 	<% } %>
	                 	</div></td>
	                 	<td><div align="center">
	                 	<% if(strPermission.indexOf("delete") != -1){ %>
	                 		<a href="#" onclick="click_delete(this)" <%=strScript %> onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('btt_delete<%=count %>','','images/btt_delete_over.gif',1)"><img src="images/btt_delete.gif" name="btt_delete<%=count %>" width="52" height="18" border="0"></a>
	                 	<% } %>	
                 		</div></td>
                 		<td><div align="center">
	                 	<% if(strPermission.indexOf("insert") != -1){ %>
	                 		<a href="#" onclick="click_add_data(this)" <%=strScript %> onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('btt_inputs<%=count %>','','images/btt_inputs_over.gif',1)"><img src="images/btt_inputs.gif" name="btt_inputs<%=count %>" height="18" border="0"></a>
	                 	<% } %>	
                 		</div></td>
	                 	<td width="10">&nbsp;</td>
	              	</tr>
<%
					count++;
				}
			}else {
%>				
					<tr class="table_data1">
	                 	<td colspan="9"><div align="center"><%=strErrorMessage %></div></td>
	                </tr> 					
<%			}
%>	              	
	         	</table>
	         	<table width="90%" border="0" cellpadding="0" cellspacing="0" class="footer_table">
                	<tr> 
	                  	<td width="156"><%=lb_total_record %> <%=strTotalSize %> <%=lb_records %></td>
		              	<td width="477"><div align="right"><%=lb_page_no %> <%=strPageNumber %>/<%=strTotalPage %></div></td>
		              	<td width="137">
			              	<img src="images/first.gif" width="22" height="22" onclick="click_navigator('first')" style="cursor:pointer"> 
			                <img src="images/prv.gif" 	width="22" height="22" onclick="click_navigator('prev')" style="cursor:pointer"> 
			                <img src="images/next.gif" 	width="22" height="22" onclick="click_navigator('next')" style="cursor:pointer"> 
			                <img src="images/last.gif" 	width="22" height="22" onclick="click_navigator('last')" style="cursor:pointer">
	                	</td>
                	</tr>
              	</table>
      		</td>
  		</tr>
        <tr>
	       <td>&nbsp;</td>
	    </tr>
	    <tr>
	       	<td><div align="center">
	       	<% if(strPermission.indexOf("insert") != -1){ %>
	       		<a href="javascript:click_open_box()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('btt_addbox','','images/btt_addbox_over.gif',1)"><img src="images/btt_addbox.gif" name="btt_addbox" width="102" height="22" border="0"></a>
	       	<% } %>	
	       </div></td>
		</tr>
	</table>
	<input type="hidden" name="screenname" 	value="<%=screenname%>">
	<input type="hidden" name="user_role" 	value="<%=user_role%>">
	<input type="hidden" name="app_group" 	value="<%=app_group%>">
	<input type="hidden" name="app_name" 	value="<%=app_name%>">
	<input type="hidden" name="MODE" 		value="<%=strMode%>">
	<input type="hidden" name="YEAR_TEMP" >
	<input type="hidden" name="BOX_SEQN_TEMP" >
	
	<input type="hidden" name="PAGENUMBER" value="<%=strPageNumber%>">
	<input type="hidden" name="TOTALPAGE"  value="<%=strTotalPage%>">
</form>	
<form name="formadd" method="post" action="box_manage2.jsp" target="_self">
<input type="hidden" name="MODE" 		 value="">
<input type="hidden" name="YEAR_KEY"	 value="">
<input type="hidden" name="BOX_SEQN_KEY" value="">
<input type="hidden" name="screenname"	 value="<%=screenname%>">
<input type="hidden" name="user_role"	 value="<%=user_role%>">
<input type="hidden" name="app_group"	 value="<%=app_group%>">
<input type="hidden" name="app_name"	 value="<%=app_name%>">       
</form>
<form name="formInsert" method="post" action="box_manage3.jsp" target="_self">
<input type="hidden" name="YEAR"		 value="">
<input type="hidden" name="BOX_SEQN" 	 value="">
<input type="hidden" name="screenname"	 value="<%=screenname%>">
<input type="hidden" name="user_role"	 value="<%=user_role%>">
<input type="hidden" name="app_group"	 value="<%=app_group%>">
<input type="hidden" name="app_name"	 value="<%=app_name%>">       
</form>	
</body>
</html>
<%  if (!strmsg.equals("")) {  %>
<script language="javaScript">
    <%=strmsg%>
</script>
<%  }   %>