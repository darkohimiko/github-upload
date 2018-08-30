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
	String strUserId     = userInfo.getUserId();
        String strProjCode   = userInfo.getProjectCode();
        String strProjName   = userInfo.getProjectName();

	String strOrderBy 	= checkNull( request.getParameter( "ORDER_BY" ) );

	String strColumnCode = "" , strColumnValue = "";
	String strErrorMessage = null;
	boolean bolnSuccess = false;
		
	con.addData( "USER_ID" , 	  "String" , strUserId );
	con.addData( "PROJECT_CODE" , "String" , strProjCode );
	con.addData( "SORT_BY" ,      "String" , strOrderBy );

	bolnSuccess = con.executeService( strContainerName , "MASTER_LINK" , "findOtherProjectCode" );

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title><%=lb_select_project_for_link%></title>
<meta http-equiv="Content-Type" content="text/html; charset=tis-620">
<link rel="shortcut icon" href="images/favicon/EDAS.ico" type="image/x-icon" />
<link href="css/edas.css" rel="stylesheet" type="text/css">
<script language="JavaScript" src="js/constant.js"></script>
<script language="JavaScript" src="js/label.js"></script>
<style type="text/css">
<!--
body {
	margin-left: 0px;
	margin-top: 0px;
}
-->
</style>
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
<script langauge="javascript">
<!--

var intSelectedRow = -1;

var strSelectedRowDefaultClassName = "";

var strCallFunc = "open_project_link";

function row_click( objRow ){
	if( intSelectedRow != -1 ){
		table1.rows[ intSelectedRow ].className = strSelectedRowDefaultClassName;
	}
	intSelectedRow = objRow.rowIndex;
	strSelectedRowDefaultClassName = objRow.className;

	objRow.className = "table_data_mover";
}

function return_value( objRow ){
	
	if( opener != null || !opener.closed ){
		var objColumnCode = opener.document.getElementById( "PROJECT_CODE_NEW" );
		var objColumnName = opener.document.getElementById( "PROJECT_NAME_NEW" );

		if( objColumnCode != null ){
			objColumnCode.value = objRow.getAttribute("COLUMN_CODE");
		}
		if( objColumnName != null ){
			objColumnName.value = objRow.getAttribute("COLUMN_NAME");
		}

		opener.focus();

		if( strCallFunc != "" ){
			eval( "opener." + strCallFunc + "();" );
		}
	}

	window.close();
}

function double_click( objRow ){
    return_value( objRow );
}

function ok_click(){

	var select_cabinet = form1.SEL_CABINET.value;
	
	if(select_cabinet == 'Y'){
		if( opener != null || !opener.closed ){
                    var objColumnCode = opener.document.getElementById( "PROJECT_CODE_NEW" );
                    var objColumnName = opener.document.getElementById( "PROJECT_NAME_NEW" );
	
			if( objColumnCode != null ){
				objColumnCode.value = "<%=strProjCode%>";
			}
			if( objColumnName != null ){
				objColumnName.value = "<%=strProjName%>";
			}
	
			opener.focus();
	
			if( strCallFunc != "" ){
				eval( "opener." + strCallFunc + "();" );
			}
		}
	
		window.close();
	}else {
		if( intSelectedRow == -1 ){
		       alert( lc_select_record );
		       return;
		}
		return_value( table1.rows[ intSelectedRow ] );
	}
}

function cancel_click(){
	window.close();
}

function window_onload(){
    lb_doc_cabinet.innerHTML 	  = lbl_doc_cabinet;    
    lb_selected_cabinet.innerHTML = lbl_selected_cabinet;
    lb_other_cabinet.innerHTML 	  = lbl_other_cabinet;
}

function click_sort( order_type) {
	form1.ORDER_BY.value = order_type;
	form1.submit();
}

function select_cabinet( rad_flag ){
	form1.SEL_CABINET.value = rad_flag;
	
	if(rad_flag == 'N'){
		div_other.style.display = 'inline';
	}else{
		div_other.style.display = 'none';
	}
}
//-->
</script>
</head>

<body onLoad="MM_preloadImages('images/btt_ok_over.gif','images/btt_cancel_over.gif');window_onload();">
<form name="form1">
  <table width="340" align="center" class="label_normal2">
    <tr>
      	<td><input type="radio" name="PROJECT1" value="Y" onFocus="this.select();" onclick="select_cabinet('Y')" checked>
      		<span id="lb_selected_cabinet" class="label_bold2"></span>
      		<input type="hidden" name="SEL_CABINET" value="Y" />
		</td>
    </tr>
    <tr>
      	<td><input type="radio" name="PROJECT1" value="N" onclick="select_cabinet('N')"> 
      		<span id="lb_other_cabinet" class="label_bold2"></span>
		</td>
    </tr>
    <tr>
      <td><table width="310" border="0" cellspacing="0">
        <tr>
<%
		boolean bolSuccessData = bolnSuccess;
		
		String sortImg = ""; 	

		if(bolSuccessData){
			if(strOrderBy.equals("ASC")){
				sortImg = "<img src=\"images/sort_down.gif\" width=16 height=16 border=0 style=\"cursor:pointer;\" onclick=\"click_sort('DESC')\">";		
			}else if(strOrderBy.equals("DESC")){
				sortImg = "<img src=\"images/sort_up.gif\" width=16 height=16 border=0 style=\"cursor:pointer;\" onclick=\"click_sort('ASC')\">";		
			}else{
				sortImg = "<img src=\"images/updown.gif\" width=20 height=11 border=0 style=\"cursor:pointer;\" onclick=\"click_sort('ASC')\">";
			}
		}else{
			sortImg = "";
		}
%>        
          <td width="310" height="22" class="hd_table"><span id="lb_doc_cabinet"></span>&nbsp;<%=sortImg %></td>
        </tr>
      </table></td>
    </tr>
    <tr>
      <td> 
      	<div style="width:auto;height:270px;overflow:auto" >
      	<div id="div_other" style="display:none">
	    <table id="table1" width="310" border="0" cellspacing="0">
<%
	
		if( !bolnSuccess ){
			strErrorMessage = con.getRemoteErrorMesage();
%>
		  <tr class="table_data1">
		    <td height="22"><%=strErrorMessage%></td>
		  </tr>
<%
		}else{
			int intRecord = 0;
			String strScript;

			while( con.nextRecordElement() ){
				intRecord++;

				strColumnCode = con.getColumn( "PROJECT_CODE_NEW" );
				strColumnValue = con.getColumn( "PROJECT_NAME" );
				

				strScript = " COLUMN_CODE=\"" + strColumnCode + "\"";
				strScript += " COLUMN_NAME=\"" + strColumnValue + "\"";
				strScript += " onClick=\"row_click( this );\"";

				if( intRecord % 2 == 1 ){
%>
		  <tr class="table_data1" <%=strScript%> style="cursor:pointer;" onDblClick="double_click(this)">
		    <td width="310" height="22"><%=strColumnValue%></td>
		  </tr>
<%
				}else{
%>
		  <tr class="table_data2" <%=strScript%> style="cursor:pointer;" onDblClick="double_click(this)">
		    <td width="310" height="22"><%=strColumnValue%></td>
		  </tr>
<%
				}
			}
		}
%>
		</table>
	  </div></div></td>
    </tr>
    <tr>
      <td align="center">
		<a href="javascript:ok_click();" 	onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image1','','images/btt_ok_over.gif',1)"><img src="images/btt_ok.gif" name="Image1" width="67" height="22" border="0"></a>
		<a href="javascript:cancel_click();" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image2','','images/btt_cancel_over.gif',1)"><img src="images/btt_cancel.gif" name="Image2" width="67" height="22" border="0"></a></td>
    </tr>
  </table>
  <input type="hidden" name="USER_ID" 		value="<%=strUserId%>">
  <input type="hidden" name="PROJECT_CODE" 	value="<%=strProjCode%>">
  
  <input type="hidden" name="ORDER_BY" 		value="<%=strOrderBy%>">
</form>
</body>
</html>
