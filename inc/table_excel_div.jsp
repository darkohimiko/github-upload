<%@ page import="com.scc.security.UserInfo"%>
<%
	UserInfo userInfo = (UserInfo)session.getAttribute( "USER_INFO" );
	String  strUserId = userInfo.getUserId();
%>
<script type="text/javascript">
<!--

function showImportExcelWindow( lv_table_level ){
    
       var table_lv1 = form1.TABLE_LEVEL1_KEY.value;
	var table_lv2 = form1.TABLE_LEVEL2_KEY.value;
	var field_code_lv1 = form1.txtTableLevel1.value;
	var field_code_lv2 = form1.txtTableLevel2.value;
        
        if(lv_table_level == '2'){
            if(field_code_lv1 == ""){
                alert(lc_check_table_level1);
                return;                
            }
        }else if (lv_table_level == '3'){
            if(field_code_lv1 == ""){
                alert(lc_check_table_level1 + "22");
                return;                
            }else if(field_code_lv2 == ""){
                alert(lc_check_table_level2);
                return;                
            }
        }
	
	iframeExcel.location =  "system_table_excel.jsp?TABLE_CODE_KEY=<%=strTableCodeKey%>&USER_ID=<%=strUserId%>&TABLE_LEVEL1_KEY=" + table_lv1 + "&TABLE_LEVEL2_KEY=" + table_lv2 + "&FIELD_LEVEL1_CODE=" + field_code_lv1 +"&FIELD_LEVEL2_CODE=" + field_code_lv2;
	divExcel.style.visibility = "visible";
}

function closeImportExcelWindow( bolnSuccess , strJobId ){

	if( bolnSuccess != null && bolnSuccess ){
		displaySuccessImport();
	}
	divExcel.style.visibility = "hidden";

}

function displaySuccessImport(){
	//alert(lc_import_data_success);
        alert("Success.");
	form1.submit();
	//divXML.style.visibility = "hidden";
}

//-->
</script>
<div id="divExcel" style="width:500px;height:300px;visibility:hidden;background: white;z-index:1;position:absolute;top:50px;left:150px;border:1px solid #000;margin: 0;padding: 0;background-color: #eeece4;" >
  <table border="0" width="100%">
    <tr>
	  <td width="99%">&nbsp;</td>
	  <td width="1%"><a href="javascript:void(0);" onclick="closeImportExcelWindow();">X</a></td>
	</tr>
  </table>
    <iframe name="iframeExcel" frameborder="0" width="500" height="270" style="overflow: hidden;" scrolling="no" ></iframe>
</div>