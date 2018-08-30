<%@ page contentType="text/html; charset=tis-620"%>
<%@ page import="com.scc.security.UserInfo"%>
<%@ include file="inc/checkUser.jsp" %>
<%@ include file="inc/constant.jsp" %>
<%@ include file="inc/label.jsp" %>
<%@ include file="inc/utils.jsp" %>
<jsp:useBean id="con" scope="session" class="edms.cllib.EABConnector"/>
<%@page import="java.util.Random"%>
<%
	Random ran = new Random();
	String randomNo=String.valueOf(ran.nextLong());
	String strRand = "&randomNo="+ randomNo;
%>
<%
	con.setRemoteServer("EAS_SERVER");

	UserInfo userInfo = (UserInfo)session.getAttribute( "USER_INFO" );
	String strUserId        = userInfo.getUserId();
	String strUserName      = userInfo.getUserName();
	String strUserOrgName   = userInfo.getUserOrgName();
	String strUserLevel     = userInfo.getUserLevel();
	String strProjectName   = userInfo.getProjectName();
	String strProjectCode	= userInfo.getProjectCode();
	
	String user_role  = getField(request.getParameter("user_role"));
	String app_name   = getField(request.getParameter("app_name"));
	String app_group  = getField(request.getParameter("app_group"));
	String screenname = getField(request.getParameter("screenname"));

	String strMethod        = request.getParameter( "METHOD" );
	String strBttFunction   = "";
	
	String strSearchDesc = getField( request.getParameter("SEARCH_DESC") );
	
	String strClassName     = "DOCUMENT_TYPE";
	String strPermission    = "";
	
	boolean bolSuccess;
		
	con.addData("USER_ROLE", 	 "String", user_role);
	con.addData("APPLICATION", 	 "String", app_name);
        con.addData("APPLICATION_GROUP", "String", app_group);
    
    bolSuccess = con.executeService(strContainerName, strClassName, "findPermission");
    if(bolSuccess) {
    	while(con.nextRecordElement()) {
    		strPermission = con.getColumn("PERMIT_FUNCTION");
    	}
    }
    
    strBttFunction += "<a href=\"javascript:click_search_all()\" onMouseOut=\"MM_swapImgRestore()\" onMouseOver=\"MM_swapImage('i_search','','images/i_search_over.jpg',1)\"><img src=\"images/i_search.jpg\" name=\"i_search\" width=\"56\" height=\"62\" border=0></a>";
    
    if(strPermission.indexOf("export") != -1){
 	//	strBttFunction += "<a href=\"#\" onMouseOut=\"MM_swapImgRestore()\" onMouseOver=\"MM_swapImage('i_export_excel','','images/i_export-excel_over.jpg',1)\"><img src=\"images/i_export-excel.jpg\" name=\"i_export_excel\" width=\"56\" height=\"62\" border=0></a>";
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

function click_search_total(){
	if(form1.txtSEARCH_DESC.value == ""){
		form1.txtSEARCH_DESC.focus();
		return;
	}
	
	if(form1.txtSEARCH_DESC.value.indexOf("%") != -1){
		alert(lc_wrong_search_keyword);
		form1.SEARCH_DESC.value = "";
		form1.txtSEARCH_DESC.value = "";
		form1.txtSEARCH_DESC.focus();
		return;
	}
	form1.SEARCH_DESC.value = form1.txtSEARCH_DESC.value;
	
	form1.SEARCH_DESC.value = form1.SEARCH_DESC.value.replace(/'/g , "");
	form1.SEARCH_DESC.value = form1.SEARCH_DESC.value.replace(/"/gi , "" );
	form1.SEARCH_DESC.value = form1.SEARCH_DESC.value.replace(/ /gi , "+" );
	
	form1.METHOD.value = "SEARCH_TOTAL";
	submit_form();
}

function click_search_all(){
	if(!showMsg( 0 , 1 , lc_alert_for_search_all )){
		return;
	}
	form1.METHOD.value = "SEARCH_ALL";
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

function clear_search_total(){
	form1.SEARCH_DESC.value = "";
	form1.txtSEARCH_DESC.value = "";
	form1.txtSEARCH_DESC.focus();
}

function field_press(){
    if( sccUtils.isEnter() ){
        window.event.keyCode = 0;
        form1.SEARCH_DESC.value = form1.txtSEARCH_DESC.value;
        click_search_total();
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

function change_tab_search( div_name, img_name ) {

	var div_obj = document.getElementById(div_name);
	var img_obj = document.getElementById(img_name);
	
	switch(div_name){
		case 'div_search_all':
			div_obj.style.display = 'inline';
			document.getElementById('div_search_index').style.display = 'none';
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
		document.getElementById('txt_search').src = "images/txt_search.gif";
		document.getElementById('txt_condition').src = "images/txt_condition.gif";
	}else{	
		if(document.getElementById('div_search_index').style.display == 'inline'){
			document.getElementById('txt_search').src = "images/txt_search_over.gif";			
		}else {
			document.getElementById('txt_search').src = "images/txt_search.gif";	
			document.getElementById('txt_searchresult').src = "images/txt_searchresult.gif";
		}
		if(document.getElementById('div_search_all').style.display == 'inline'){
			document.getElementById('txt_condition').src = "images/txt_condition_over.gif";	
		}else {
			document.getElementById('txt_condition').src = "images/txt_condition.gif";
			document.getElementById('txt_searchresult').src = "images/txt_searchresult.gif";	
		}
	}
	
}

function window_onload() {
	form1.txtSEARCH_DESC.focus();
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
<body onLoad="MM_preloadImages('images/txt_search_over.gif','images/txt_condition_over.gif','images/txt_searchresult_over.gif','images/btt_new_over.gif','images/btt_search_over.gif','images/i_new_over.jpg','images/i_search_over.jpg','images/i_export_over.jpg','images/i_doc_over.jpg','images/i_out_over.jpg');window_onload()" >
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
			                	<td valign="bottom">
			                		<%=strBttFunction %><a href="#" onclick="click_cancel()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('i_out','','images/i_out_over.jpg',1)"><img src="images/i_out.jpg" name="i_out" width="56" height="62" border="0"></a></td>
			                	<td width="*" align="right"><div class="label_bold1">
			                    	<div align="right" style="padding-right: 30px"><span class="label_header02" title="<%=strProjectCode %>" ><%=strProjectName %></span><br>
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
				strButtSearch += "<img id=\"txt_search\" src=\"images/txt_search.gif\" name=\"search_detail\" width=117 height=25 border=0 style=\"display:none\">";
				strButtSearch += "<a href=\"javascript:change_tab_search('div_search_all','txt_condition')\" onMouseOut=\"change_tab_img()\" onMouseOver=\"MM_swapImage('searchtotal','','images/txt_condition_over.gif',1)\"><img id=\"txt_condition\" src=\"images/txt_condition_over.gif\" name=\"txt_condition\" height=25 border=0></a>";
				strButtSearch += "<a href=\"javascript:change_tab_search('div_search_result','txt_searchresult')\" onMouseOut=\"change_tab_img()\" onMouseOver=\"MM_swapImage('searchresult','','images/txt_searchresult_over.gif',1)\"><img id=\"txt_searchresult\" src=\"images/txt_searchresult.gif\" name=\"searchresult\" width=117 height=25 border=0></a>";
%>		          
		          <td width="419" height="29" background="images/inner_img_07.jpg"><%=strButtSearch%></td>
		          <td width="*" class="navbar_01" align="right" style="padding-right: 30px">(<%=strUserOrgName%>) <%=lb_user_name %> : <%=strUserName %> 
		            (<%=strUserId%> / <%=strUserLevel%>)&nbsp;&nbsp;&nbsp;</td>
		        </tr>
	      	</table>
      	</td>
  	</tr>
  	<tr> 
            <td valign="top" align="center">
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
		                        				<input name="COUNT_RECORD" type="text" class="input_box" size="5" value="50" onkeypress="keypress_number()" style="text-align:right"> <%=lb_records %> 
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
	  	<div id="div_search_index" style="display:none"></div>
      	<div id="div_search_all" style="display:inline">
      		<table width="790" border="0" cellspacing="0" cellpadding="0">
		        <tr> 
		          	<td>
						<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
			              	<tr> 
				                <td width="18"><img src="images/data_blank_01.gif" width="18" height="20"></td>
				                <td width="760"><img src="images/data_blank_03.gif" width="100%" height="20"></td>
				                <td width="18"><img src="images/data_blank_04.gif" width="18" height="20"></td>
				            </tr>
				            <tr> 
				                <td background="images/data_06.gif"><img src="images/data_06.gif" width="18" height="6"></td>
				                <td bgcolor="#f7f6f2">
					                <table width="700" border="0" align="center" cellpadding="0" cellspacing="0" class="label_bold2">
			                    		<tr> 
						                	<td width="80"><%=lb_searchkey %></td>
						                    <td colspan="3">
						                    	<input name="txtSEARCH_DESC" type="text" value="<%=strSearchDesc %>" class="input_box" size="100" onkeypress="field_press()">
						                    	<input name="SEARCH_DESC" type="hidden" >
						                    </td>
						                </tr>
						                <tr valign="bottom"> 
					                      	<td height="30" colspan="4">
					                      		<div align="center">
					                      			<a href="javascript:click_search_total()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('search3','','images/btt_search_over.gif',1)"><img src="images/btt_search.gif" name="search3" width="67" height="22" border="0" ></a>
					                      			<a href="javascript:clear_search_total()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('btt_new3','','images/btt_new_over.gif',1)"><img src="images/btt_new.gif" name="btt_new3" width="67" height="22" border="0" ></a> 
					                        	</div>
				                        	</td>
					                    </tr>
				                  	</table>
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
      	</div>	
      <!-- ########################### END ################################################## -->	
   		</td>
  	</tr>
</table>
<input type="hidden" name="screenname" value="<%=screenname%>">
<input type="hidden" name="user_role"  value="<%=user_role%>">
<input type="hidden" name="app_group"  value="<%=app_group%>">
<input type="hidden" name="app_name"   value="<%=app_name%>">
<input type="hidden" name="METHOD" 	   value="<%=strMethod%>">
<input type="hidden" name="FROM_PAGE"  value="SEARCH_TOTAL"	>
<input type="hidden" name="CHECK_CLICK" >

</form>
</body>
</html>
