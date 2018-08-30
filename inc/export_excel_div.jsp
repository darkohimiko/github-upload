<script type="text/javascript">
<!--

function showExportExcelWindow(){
	divExcel.style.visibility = "visible";
	formExcel.SET_CODE_FLAG.value = "N";
	rdo_desc_flag.checked = true;
}

function closeExportExcelWindow(){
	divExcel.style.visibility = "hidden";
}

function export_click(){
	formExcel.submit();
	divExcel.style.visibility = "hidden";
}

function set_flag(code_flag){
	formExcel.SET_CODE_FLAG.value = code_flag;
}

//-->
</script>
<div id="divExcel" style="width:500px;height:300px;visibility:hidden;background: white;z-index:1;position:absolute;top:60;left:150;border:1px solid #000" >
  <table border="0" width="100%">
    <tr>
	  <td width="99%">&nbsp;</td>
	  <td width="1%"><a href="javascript:void(0);" onclick="closeExportExcelWindow();">X</a></td>
	</tr>
  </table>
  <table width="500" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td width="23"><img src="images/popup_01.gif" width="23" height="271"></td>
    <td width="457" valign="top" background="images/popup_02.gif">
    	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	        <tr> 
	          <td colspan="2"><img src="images/export_excel.gif" height="42"></td>
	        </tr>
	        <tr> 
	          <td height="50" colspan="2">&nbsp;</td>
	        </tr>
	        <tr> 
	          	<td width="120"><div align="right" style="padding-right: 30px"><span class="label_bold3" style="font-size: 12px;"><%=lb_select_export_type %></span>&nbsp;</div></td>
	          	<td width="*">
	          		<input type="radio" name="rdo_flag" value="Y" onclick="set_flag('Y')"><span class="label_bold3" style="font-size: 12px;"> <%=lb_export_in_code %></span>
				</td>
	        </tr>
	        <tr>
	        	<td></td>
	        	<td>
	          		<input type="radio" name="rdo_flag" id="rdo_desc_flag" value="N" onclick="set_flag('N')" checked><span class="label_bold3" style="font-size: 12px;"> <%=lb_export_in_description %></span>
	        	</td>
	        </tr>
	        <tr> 
	          <td height="20" colspan="2">&nbsp;</td>
	        </tr>
	        <tr> 
	          <td height="45" colspan="2"><div align="center"><a href="#" onclick="export_click();" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('export','','images/btt_export2_over.gif',1)"><img src="images/btt_export2.gif" name="export" width="142" height="22" border="0"></a></div></td>
	        </tr>
      	</table>
      </td>
    <td width="20"><img src="images/popup_04.gif" width="22" height="271"></td>
  </tr>
</table>
</div>