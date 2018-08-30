<%@ page contentType="text/html; charset=tis-620"%>
<%@ include file="constant.jsp" %>
<%@ include file="label.jsp" %>
<%@ include file="utils.jsp" %>
<jsp:useBean id="con" scope="session" class="edms.cllib.EABConnector"/>
<jsp:useBean id="con1" scope="session" class="edms.cllib.EABConnector"/>
<%
	con.setRemoteServer("EAS_SERVER");
	con1.setRemoteServer("EAS_SERVER");

	String strTable      = getField( request.getParameter("TABLE") );
	String strTableLabel = getField( request.getParameter("TABLE_LABEL") );

	String strResultField  = checkNull( request.getParameter("RESULT_FIELD") );
	String strClearField   = checkNull( request.getParameter("CLEAR_FIELD") );
	String strCallFunction = checkNull( request.getParameter("CALL_FUNC") );

	String strSortField  = checkNull( request.getParameter( "SORT_FIELD" ) );
	String strOrderBy 	 = checkNull( request.getParameter( "ORDER_BY" ) );
	String strPageNumber = checkNull(request.getParameter("PAGENUMBER"));
	String strPageSize   = checkNull(request.getParameter("PAGE_SIZE"));
	String strTotalPage  = "1";
	String strTotalSize  = "0";

	String strColumnCode       = "";
	String strColumnValue      = "";
	String strColumnLevel1     = "";
	String strColumnLevel1name = "";

	if(strSortField.equals("")){
		strSortField = "0";		
	}
	
	if(strOrderBy.equals("")){
		strOrderBy = "ASC";		
	}
	
	if(strPageNumber.equals("")){
		strPageNumber = "1";
	}
	
	if(strPageSize.equals("")){
		strPageSize = "10";
	}

    String  strClassName     = "ZOOM_TABLE_MANAGER";
    String  strErrorCode     = null;
    String  strErrorMessage  = null;
	boolean bolnSuccess      = false;
	boolean bolnSuccessName  = false;

	con.addData("SORTFIELD",  "String", strSortField );
	con.addData("SORTBY", 	  "String", strOrderBy );
	con.addData("PAGESIZE",   "String", strPageSize);
    con.addData("PAGENUMBER", "String", strPageNumber);
    
	bolnSuccess = con.executeService( strContainerName, strClassName, "zoomTableLevel2" );
	if(bolnSuccess){
		strTotalPage = con.getHeader( "PAGE_COUNT" );
        strTotalSize = con.getHeader( "TOTAL_RECORD" );
	}

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title><%=lc_zoom_table_level2%></title>
<meta http-equiv="Content-Type" content="text/html; charset=windows-874">
<script language="JavaScript" src="../js/constant.js"></script>
<script language="JavaScript" src="../js/label.js"></script>
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

var strTableLabel                  = "<%=strTableLabel%>";
var intSelectedRow                 = -1;
var strSelectedRowDefaultClassName = "";
var strCallFunc                    = "<%=strCallFunction%>";

function rowClick( objRow ){
	if( intSelectedRow != -1 ){
		table1.rows[ intSelectedRow ].className = strSelectedRowDefaultClassName;
	}
	intSelectedRow = objRow.rowIndex;
	strSelectedRowDefaultClassName = objRow.className;

	objRow.className = "table_data_mover1";
}

function rowDblClick( objRow ){
	var strResultField = form1.RESULT_FIELD.value;
	var arrResultField = strResultField.split(",");

	if( opener != null || !opener.closed ){
		var objColumnCode1 = opener.document.getElementById( arrResultField[ 0 ] );
		var objColumnName1 = opener.document.getElementById( arrResultField[ 1 ] );
		var objColumnCode2 = opener.document.getElementById( arrResultField[ 2 ] );
		var objColumnName2 = opener.document.getElementById( arrResultField[ 3 ] );

		if( objColumnCode1 != null ){
			objColumnCode1.value = objRow.getAttribute("COLUMN_CODE");
		}
		if( objColumnName1 != null ){
			objColumnName1.value = objRow.getAttribute("COLUMN_NAME");
		}
		if( objColumnCode2 != null ){
			objColumnCode2.value = objRow.getAttribute("COLUMN_LEVEL1");
		}
		if( objColumnName2 != null ){
			objColumnName2.value = objRow.getAttribute("COLUMN_LEVEL1_NAME");
		}
		opener.focus();

		if( strCallFunc != "" ){
			eval( "opener." + strCallFunc + "();" );
		}
	}
	window.close();
}

function okClick(){
	if( intSelectedRow == -1 ){
        alert( lc_select_record );
        return;
	}
	rowDblClick( table1.rows[ intSelectedRow ] );
}

function cancelClick(){
	window.close();
}

function window_onload(){
    lb_table_code.innerHTML   = lbl_table_code;
    lb_table_name.innerHTML   = lbl_table_name;
    lb_table_level1.innerHTML = lbl_table_level1;
}

function click_sort( sort_field, order_type) {
	form1.SORT_FIELD.value = sort_field;
	form1.ORDER_BY.value   = order_type;
	
	form1.submit();
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

</script>
</head>
<link href="../css/edas.css" type="text/css" rel="stylesheet">
<body onLoad="MM_preloadImages('../images/btt_ok_over.gif','../images/btt_cancel_over.gif');window_onload();">
<form name="form1">
  <table width="340" align="center" class="label_normal2">
    <tr>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td><table width="330" border="0" cellspacing="0">
        <tr>
<%
		boolean bolSuccessData = bolnSuccess;
		
		String[] sortImg = new String[4];

		if(bolSuccessData){
			if(strSortField.equals("0")){
				sortImg[0] = "";
				sortImg[1] = "<img src=\"../images/updown.gif\" width=20 height=11 border=0 style=\"cursor:pointer;\" onclick=\"click_sort('1','ASC')\">";	
				sortImg[2] = "<img src=\"../images/updown.gif\" width=20 height=11 border=0 style=\"cursor:pointer;\" onclick=\"click_sort('2','ASC')\">";	
				sortImg[3] = "<img src=\"../images/updown.gif\" width=20 height=11 border=0 style=\"cursor:pointer;\" onclick=\"click_sort('3','ASC')\">";
			}else{
				int iSortField = Integer.parseInt(strSortField);
				
				for(int idx=0; idx<4; idx++){
					if(idx==iSortField){
						if(strOrderBy.equals("ASC")){
							sortImg[idx] = "<img src=\"../images/sort_down.gif\" width=16 height=16 border=0 style=\"cursor:pointer;\" onclick=\"click_sort('" + idx + "','DESC')\">";		
						}else{
							sortImg[idx] = "<img src=\"../images/sort_up.gif\" width=16 height=16 border=0 style=\"cursor:pointer;\" onclick=\"click_sort('" + idx + "','ASC')\">";		
						}
					}else{
						sortImg[idx] = "<img src=\"../images/updown.gif\" width=20 height=11 border=0 style=\"cursor:pointer;\" onclick=\"click_sort('" + idx + "','ASC')\">";
					}
				}
			}
		}else{
			sortImg[0] = sortImg[1] = sortImg[2] = sortImg[3] ="";
		}
%>
          <td width="100" height="22" class="hd_table"><span id="lb_table_code"></span>&nbsp;<%=sortImg[1] %></td>
          <td width="130" height="22" class="hd_table"><span id="lb_table_name"></span>&nbsp;<%=sortImg[2] %></td>
          <td width="100" height="22" class="hd_table"><span id="lb_table_level1"></span>&nbsp;<%=sortImg[3] %></td>
        </tr>
      </table></td>
    </tr>
    <tr>
      <td>
	    <table id="table1" width="330" border="0" cellspacing="0">
<%
	if( !bolnSuccess ){
		strErrorCode    = con.getRemoteErrorCode();
		strErrorMessage = con.getRemoteErrorMesage();
%>
	  <tr class="text_normal">
	    <td height="22"><%=strErrorMessage%></td>
	  </tr>
<%			
		for(int i=0; i<9; i++){
%>
	<tr class="table_data1">
	    <td height="22" align="center"></td>
	</tr>
<%
		}
	}else{
		int intRecord = 0;
		String strScript;

		while( con.nextRecordElement() ){
			intRecord++;

			strColumnCode   = con.getColumn( "TABLE_CODE" );
			strColumnValue  = con.getColumn( "TABLE_NAME" );
			strColumnLevel1 = con.getColumn( "TABLE_LEVEL1" );
			
			if( !strColumnLevel1.equals("") && strColumnLevel1 != null) {
				con1.addData( "TABLE_CODE", "String", strColumnLevel1 );
				bolnSuccessName = con1.executeService( strContainerName, strClassName, "getTableLevelName" );
			}
			strColumnLevel1name = con1.getHeader( "TABLE_NAME" );
			
			strScript = " COLUMN_CODE=\"" + strColumnCode + "\"";
			strScript += " COLUMN_NAME=\"" + strColumnValue + "\"";
			strScript += " COLUMN_LEVEL1=\"" + strColumnLevel1 + "\"";
			strScript += " COLUMN_LEVEL1_NAME=\"" + strColumnLevel1name + "\"";
			strScript += " onClick=\"rowClick( this );\"";
			strScript += " onDblClick=\"rowDblClick( this );\"";

			if( intRecord % 2 == 1 ){
%>
		  <tr class="table_data1" <%=strScript%>>
		    <td width="110" height="22"><%=strColumnCode%></td>
		    <td width="120" height="22"><%=strColumnValue%></td>
		    <td width="100" height="22"><%=strColumnLevel1%></td>
		  </tr>
<%
			}else{
%>
		  <tr class="table_data2" <%=strScript%>>
		    <td width="110" height="22"><%=strColumnCode%></td>
		    <td width="120" height="22"><%=strColumnValue%></td>
		    <td width="100" height="22"><%=strColumnLevel1%></td>
		  </tr>
<%
				}
			}
			
			int intRem = Integer.parseInt(strPageSize) - intRecord;
			if(intRem > 0){
				while(intRem > 0){
%>					
				<tr class="table_data<%=intRem%2 + 1 %>" >
				    <td width="110" height="22" style="padding-left: 5px"></td>
				    <td width="120" height="22"></td>
				    <td width="100" height="22"></td>
			 	</tr>			
<%				intRem--;
				}
			}
		}
%>
		</table>
		<table width="330" border="0" cellpadding="0" cellspacing="0" class="footer_table">
           	<tr> 
               	<td width="*"><%=strTotalSize %> <%=lb_records %></td>
            	<td width="*"><div align="right"><%=lb_page_no %> <%=strPageNumber %>/<%=strTotalPage %></div></td>
            	<td width="137" align="center">
             		<img src="../images/first.gif" width="22" height="22" onclick="click_navigator('first')" style="cursor:pointer"> 
               		<img src="../images/prv.gif" 	width="22" height="22" onclick="click_navigator('prev')" style="cursor:pointer"> 
               		<img src="../images/next.gif" 	width="22" height="22" onclick="click_navigator('next')" style="cursor:pointer"> 
               		<img src="../images/last.gif" 	width="22" height="22" onclick="click_navigator('last')" style="cursor:pointer">
             	</td>
           	</tr>
        </table>
	  </td>
    </tr>
    <tr>
      <td align="center">
		<a href="javascript:okClick();" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image1','','../images/btt_ok_over.gif',1)">
			<img src="../images/btt_ok.gif" name="Image1" width="67" height="22" border="0"></a>
		<a href="javascript:cancelClick();" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image2','','../images/btt_cancel_over.gif',1)">
			<img src="../images/btt_cancel.gif" name="Image2" width="67" height="22" border="0"></a>
	  </td>
    </tr>
  </table>
  <input type="hidden" name="TABLE"       value="<%=strTable%>">
  <input type="hidden" name="TABLE_LABEL" value="<%=strTableLabel%>">

  <input type="hidden" name="RESULT_FIELD" value="<%=strResultField%>">
  <input type="hidden" name="CLEAR_FIELD"  value="<%=strClearField%>">
  <input type="hidden" name="CALL_FUNC"    value="<%=strCallFunction%>">
  
  <input type="hidden" name="SORT_FIELD"   value="<%=strSortField%>">
  <input type="hidden" name="ORDER_BY" 	   value="<%=strOrderBy%>">
  <input type="hidden" name="PAGENUMBER"   value="<%=strPageNumber%>">
  <input type="hidden" name="TOTALPAGE"    value="<%=strTotalPage%>">
</form>
</body>
</html>
