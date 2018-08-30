<%@ page contentType="text/html; charset=tis-620"%>
<%@ include file="constant.jsp" %>
<%@ include file="label.jsp" %>
<%@ include file="utils.jsp" %>
<jsp:useBean id="con" scope="session" class="edms.cllib.EABConnector"/>
<%
	con.setRemoteServer("EAS_SERVER");

	String strField1     = getField( request.getParameter( "FIELD1" ) );
	String strTable      = getField( request.getParameter( "TABLE" ) );
	String strTableLabel = getField( request.getParameter( "TABLE_LABEL" ) );
	
	String strTableLv1 	= request.getParameter( "TABLE_LV1" );
	String strTableLv1Label = getField( request.getParameter( "TABLE_LV1_LABEL" ) );
	
	String strTableLv1Code 	= request.getParameter( "TABLE_LV1_CODE" );
	String strTableLv1Name  = getField( request.getParameter( "TABLE_LV1_NAME" ) );

	String strResultField 	= checkNull( request.getParameter( "RESULT_FIELD" ) );
	String strClearField 	= checkNull( request.getParameter( "CLEAR_FIELD" ) );
	String strCallFunction 	= checkNull( request.getParameter( "CALL_FUNC" ) );

	String strSortField = checkNull( request.getParameter( "SORT_FIELD" ) );
	String strOrderBy 	= checkNull( request.getParameter( "ORDER_BY" ) );
	
	String	strPageNumber = checkNull(request.getParameter("PAGENUMBER"));
	String	strPageSize   = checkNull(request.getParameter("PAGE_SIZE"));
	String	strTotalPage  = "1";	
	String	strTotalSize  = "0";
        	
	String strColumnCode = "" , strColumnValue = "";

	if(strSortField.equals("")){
		strSortField = "0";		
	}
        
        if(!strSortField.equals("1") && !strSortField.equals("2")){
		strSortField = "0";		
	}
	
	if(strOrderBy.equals("")){
		strOrderBy = "ASC";		
	}
        
        if(!strOrderBy.equals("ASC") && !strOrderBy.equals("DESC")){
		strOrderBy = "ASC";		
	}
	
	if(strPageNumber.equals("")){
		strPageNumber = "1";
	}
	if(strPageSize.equals("")){
		strPageSize = "10";
	}
	
	if(strField1.equals("")){
		strField1 = "%";		
	}

    String strErrorCode = null , strErrorMessage = null;
	boolean bolnSuccess = false;

	if( strField1.length() != 0 ){

		con.addData( "FIELD1" , 		"String" , strField1 );
		con.addData( "FIELD_CODE" , 	"String" , strTable + "_NAME" );	
		con.addData( "TABLE_CODE" , 	"String" , strTable );
		con.addData( "TABLE_LV1" , 		"String" , strTableLv1 );
		con.addData( "TABLE_LV1_CODE" , "String" , strTableLv1Code );
		con.addData( "SORT_FIELD" , 	"String" , strSortField );
		con.addData( "SORT_BY" , 		"String" , strOrderBy );
		con.addData("PAGESIZE", 		"String",  strPageSize);
	    con.addData("PAGENUMBER", 		"String",  strPageNumber);


		bolnSuccess = con.executeService( strContainerName , "ZOOM_TABLE_MANAGER" , "zoomDataTable2" );
		if(bolnSuccess){
			strTotalPage = con.getHeader( "PAGE_COUNT" );
	        strTotalSize = con.getHeader( "TOTAL_RECORD" );
		}
	}

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title><%=strTableLabel%></title>
<meta http-equiv="Content-Type" content="text/html; charset=windows-874">
<link href="../css/edas.css" rel="stylesheet" type="text/css">
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

var strTableLabel= "<%=strTableLabel%>";
var intSelectedRow = -1;

var strSelectedRowDefaultClassName = "";

var strCallFunc = "<%=strCallFunction%>";

function fieldPress( objField ){
	if( window.event.keyCode == 13 ){
		window.event.keyCode = 0;
		if( validateSearch() ){
			form1.PAGENUMBER.value = "1";
			submitForm();
		}
	}
}


function rowClick( objRow ){
	if( intSelectedRow != -1 ){
		table1.rows[ intSelectedRow ].className = strSelectedRowDefaultClassName;
	}
	intSelectedRow = objRow.rowIndex;
	strSelectedRowDefaultClassName = objRow.className;

	objRow.className = "table_data_mover";
}

function rowDblClick( objRow ){
	var strResultField = form1.RESULT_FIELD.value;
	var arrResultField = strResultField.split(",");
	
	var strClearField = form1.CLEAR_FIELD.value;
	var arrClearField = strClearField.split(",");

	if( opener != null || !opener.closed ){
//		var objColumnCode = opener.document.all( arrResultField[ 0 ] );
//		var objColumnName = opener.document.all( arrResultField[ 1 ] );
                var objColumnCode = opener.document.getElementById( arrResultField[ 0 ] );
		var objColumnName = opener.document.getElementById( arrResultField[ 1 ] );

		if( objColumnCode != null ){
		
			if( objColumnCode.value != objRow.getAttribute("COLUMN_CODE") ){
				for(var idx=0; idx < arrClearField.length; idx++){
//					objTableLevel  = opener.document.all( arrClearField[ idx ] );
                                        objTableLevel  = opener.document.getElementById( arrClearField[ idx ] );
					
					if( objTableLevel != null ){
						objTableLevel.value = "";
					}								
				}	
			}
				
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

function validateSearch(){
    if( form1.FIELD1.value.length == 0 ){
        alert( lc_check_for_search );
        form1.FIELD1.focus();
        return false;
    }
    return true;
}

function searchClick(){
	if( validateSearch() ){
		form1.PAGENUMBER.value = "1";
		submitForm();
	}
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

function submitForm(){
	form1.method = "post";
	form1.action = "zoom_data_table_level2.jsp";
	form1.submit();
}

function window_onload(){
    lb_code.innerHTML = lbl_code;
    
    if( form1.FIELD1.value.length == 0 ){
		form1.FIELD1.value = "%";
	}
	form1.FIELD1.focus();
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

<body onLoad="MM_preloadImages('../images/btt_ok_over.gif','../images/btt_cancel_over.gif');window_onload();">
<form name="form1">
  <table width="340" align="center" class="label_normal2" cellspacing="0">
  	<tr>
  		<td height="12">
  		</td>
  	</tr>
    <tr>
      <td align="center">
      	<input type="text" name="FIELD1" class="input_box" size="54" value="<%=strField1%>" onFocus="this.select();" onKeypress="fieldPress( this );">
		<a href="javascript:searchClick();"><img src="../images/search.gif" width="16" height="16" border="0"></a></td>
    </tr>
    <tr>
	  <td style="padding-left: 15px"><%=strTableLv1Label %> <span class="label_bold2"><%=strTableLv1Name%></span></td>
	</tr>
    <tr>
      <td align="center"><table width="310" border="0" cellspacing="0">
        <tr>
<%
		boolean bolSuccessData = bolnSuccess;
		
		String[] sortImg = new String[3]; 	

		if(bolSuccessData){
			if(strSortField.equals("0")){
				sortImg[0] = "";
				sortImg[1] = "<img src=\"../images/updown.gif\" width=20 height=11 border=0 style=\"cursor:pointer;\" onclick=\"click_sort('1','ASC')\">";		
				sortImg[2] = "<img src=\"../images/updown.gif\" width=20 height=11 border=0 style=\"cursor:pointer;\" onclick=\"click_sort('2','ASC')\">";
			}else{
				int iSortField = Integer.parseInt(strSortField);
				
				for(int idx=0; idx<3; idx++){
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
			sortImg[0] = sortImg[1] = sortImg[2] = "";
		}
%>         
          <td width="100" height="22" class="hd_table"><span id="lb_code"></span>&nbsp;<%=sortImg[1] %></td>
          <td width="210" height="22" class="hd_table"><%=strTableLabel%>&nbsp;<%=sortImg[2] %></td>
        </tr>
      </table></td>
    </tr>
    <tr>
      <td align="center">
	    <table id="table1" width="310" border="0" cellspacing="0">
<%
	if( strField1.length() != 0 ){
		if( !bolnSuccess ){
			strErrorCode 	= con.getRemoteErrorCode();
			strErrorMessage = con.getRemoteErrorMesage();
%>
		  <tr class="table_data1">
		    <td height="22" align="center"><%=strErrorMessage%></td>
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

				strColumnCode = con.getColumn( strTable );
				
				if(strTable.equals("USER_LEVEL")){
					strColumnValue = con.getColumn( "LEVEL_NAME" );
				}else{
					strColumnValue = con.getColumn( strTable + "_NAME" );
				}

				strScript = " COLUMN_CODE=\"" + strColumnCode + "\"";
				strScript += " COLUMN_NAME=\"" + strColumnValue + "\"";
				strScript += " onClick=\"rowClick( this );\"";
				strScript += " onDblClick=\"rowDblClick( this );\"";

				if( intRecord % 2 == 1 ){
%>
		  <tr class="table_data1" <%=strScript%> align="left">
		    <td width="100" height="22" style="padding-left: 5px"><%=strColumnCode%></td>
		    <td width="210" height="22"><%=strColumnValue%></td>
		  </tr>
<%
				}else{
%>
		  <tr class="table_data2" <%=strScript%> align="left">
		    <td width="100" height="22" style="padding-left: 5px"><%=strColumnCode%></td>
		    <td width="210" height="22"><%=strColumnValue%></td>
		  </tr>
<%
				}
			}
			
			int intRem = Integer.parseInt(strPageSize) - intRecord;
			if(intRem > 0){
				while(intRem > 0){
%>					
				<tr class="table_data<%=intRem%2 + 1 %>" >
				    <td width="100" height="22" style="padding-left: 5px"></td>
				    <td width="210" height="22"></td>
			 	</tr>			
<%				intRem--;
				}
			}
		}
	}
%>
		</table>
		<table width="310" border="0" cellpadding="0" cellspacing="0" class="footer_table">
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
    	<td height="5"></td>
    </tr>
    <tr>
      <td align="center">
		<a href="javascript:okClick();" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image1','','../images/btt_ok_over.gif',1)"><img src="../images/btt_ok.gif" name="Image1" width="67" height="22" border="0"></a>
		<a href="javascript:cancelClick();" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image2','','../images/btt_cancel_over.gif',1)"><img src="../images/btt_cancel.gif" name="Image2" width="67" height="22" border="0"></a></td>
    </tr>
  </table>
  <input type="hidden" name="TABLE" 		 value="<%=strTable%>">
  <input type="hidden" name="TABLE_LABEL"	 value="<%=strTableLabel%>">
  <input type="hidden" name="TABLE_LV1"		 value="<%=strTableLv1%>">
  <input type="hidden" name="TABLE_LV1_NAME" value="<%=strTableLv1Name%>">
  <input type="hidden" name="TABLE_LV1_CODE"  value="<%=strTableLv1Code%>">
  <input type="hidden" name="TABLE_LV1_LABEL" value="<%=strTableLv1Label%>">

  <input type="hidden" name="RESULT_FIELD" 	value="<%=strResultField%>">
  <input type="hidden" name="CLEAR_FIELD" 	value="<%=strClearField%>">
  <input type="hidden" name="CALL_FUNC" 	value="<%=strCallFunction%>">
  
  <input type="hidden" name="SORT_FIELD" 	value="<%=strSortField%>">
  <input type="hidden" name="ORDER_BY" 		value="<%=strOrderBy%>">
  
  <input type="hidden" name="PAGENUMBER" value="<%=strPageNumber%>">
  <input type="hidden" name="TOTALPAGE"  value="<%=strTotalPage%>">
</form>
</body>
</html>
