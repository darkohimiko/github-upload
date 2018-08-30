<%@ page contentType="text/html; charset=tis-620"%>
<%@ include file="inc/constant.jsp" %>
<%@ include file="inc/label.jsp" %>
<%@ include file="inc/utils.jsp" %>
<%
	String	strFileType = checkNull(request.getParameter("FILE_TYPE"));

	strFileType = strFileType.toUpperCase();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=tis-620">
<title><%=lb_file_type %></title>
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
<script language="JavaScript" src="js/constant.js"></script>
<script type="text/javascript">
<!--

var recv_file_type = "<%=strFileType%>";

function enable_check_all(bol_value){
    var items = document.form1.getElementsByTagName("input");
    var size = items.length;
            
    for (i=0; i<size; i++){           
        if (items[i].type == "checkbox"){
            items[i].checked  = bol_value;
        }
    }
	
	checkbox_click();
}

function checkbox_click(){
    var	strConcatFileType = "";
    var items = document.form1.getElementsByTagName("input");
    var size = items.length;
    
    for (var i=0; i<size; i++){
		
        if (items[i].type == "checkbox"){
            if (items[i].checked) {
                strConcatFileType += items[i].value + ",";
            }
        }
    }

    if( strConcatFileType.length > 0 ){
		strConcatFileType = strConcatFileType.substr( 0 , strConcatFileType.length - 1 );
	}
    
    form1.FILE_TYPE.value   = strConcatFileType;
}

function window_onload(){
	init_file_type();
}

function init_file_type(){
	if(recv_file_type == ""){
		return;
	}
	var arr_file_type = recv_file_type.split(',');
	var obj_chk;
    
    for (i=0; i<arr_file_type.length; i++){
		obj_chk = eval("form1." + arr_file_type[i]);
        if (obj_chk){
			if (obj_chk.type == "checkbox"){
				obj_chk.checked  = true;
	        }
        }
	}
}

function click_save(){
    
	if(form1.FILE_TYPE.value.length == 0){
		alert(lc_check_file_more_one);
		return;
	}

	if(opener.form1.FILE_TYPE){
		opener.form1.FILE_TYPE.value = form1.FILE_TYPE.value;
	}
	click_cancel();
}

function click_cancel(){
	window.close();
}
//-->
</script>
</head>
<body onload="MM_preloadImages('images/btt_save2_over.gif','images/btt_cancel_over.gif','images/btt_selectall_s_over.gif','images/btt_noselect_over.gif');window_onload()">
<form id="form1" name="form1" method="post">
<table cellpadding="0" cellspacing="0" border="0">
	<tr>
		<td height="23" colspan="3">&nbsp;</td>
	</tr>
	<tr>
		<td height="23" width="15"></td>
		<td>
			<a href="#" onclick= "enable_check_all(true)" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('checked','','images/btt_selectall_s_over.gif',1)"><img src="images/btt_selectall_s.gif" id="checked" name="checked" width="100" height="20" border="0"></a>&nbsp;
			<a href="#" onclick= "enable_check_all(false)" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('unChecked','','images/btt_noselect_over.gif',1)"><img src="images/btt_noselect.gif" id="unChecked" name="unChecked" width="100" height="20" border="0"></a>
		</td>
		<td></td>
	</tr>
	<tr>
		<td height="23"></td>
		<td>
			<table cellpadding="0"  cellspacing="0" border="0">
				<tr>
					<td align="left" width="80" class="label_normal2"><input type="checkbox" name="TGA" label="TGA" value="TGA" onclick="checkbox_click()" >TGA</td>
					<td align="left" width="80" class="label_normal2"><input type="checkbox" name="PNG" label="PNG" value="PNG" onclick="checkbox_click()" >PNG</td>
					<td align="left" class="label_normal2"><input type="checkbox" name="MP3" label="MP3" value="MP3" onclick="checkbox_click()" >MP3</td>
				</tr>
				<tr>
					<td align="left" class="label_normal2"><input type="checkbox" name="PCX" label="PCX" value="PCX" onclick="checkbox_click()" >PCX</td>
					<td align="left" class="label_normal2"><input type="checkbox" name="ICO" label="ICO" value="ICO" onclick="checkbox_click()" >ICO</td>
					<td align="left" class="label_normal2"><input type="checkbox" name="MP4" label="MP4" value="MP4" onclick="checkbox_click()" >MP4</td>
				</tr>
				<tr>
					<td align="left" class="label_normal2"><input type="checkbox" name="GIF" label="GIF" value="GIF" onclick="checkbox_click()" >GIF</td>
					<td align="left" class="label_normal2"><input type="checkbox" name="PDF" label="PDF" value="PDF" onclick="checkbox_click()" >PDF</td>
					<td align="left" class="label_normal2"><input type="checkbox" name="WAV" label="WAV" value="WAV" onclick="checkbox_click()" >WAV</td>
				</tr>
				<tr>
					<td align="left" class="label_normal2"><input type="checkbox" name="TIF" label="TIF" value="TIF" onclick="checkbox_click()" >TIF</td>
					<td align="left" class="label_normal2"><input type="checkbox" name="DOC" label="DOC" value="DOC" onclick="checkbox_click()" >DOC</td>
					<td align="left" class="label_normal2"><input type="checkbox" name="DAT" label="DAT" value="DAT" onclick="checkbox_click()" >DAT</td>
				</tr>
				<tr>
					<td align="left" class="label_normal2"><input type="checkbox" name="TIFF" label="TIFF" value="TIFF" onclick="checkbox_click()" >TIFF</td>
					<td align="left" class="label_normal2"><input type="checkbox" name="XLS" label="XLS" value="XLS" onclick="checkbox_click()" >XLS</td>
					<td align="left" class="label_normal2"><input type="checkbox" name="DOCX" label="DOCX" value="DOCX" onclick="checkbox_click()" >DOCX</td>
				</tr>
				<tr>
					<td align="left" class="label_normal2"><input type="checkbox" name="DIB" label="DIB" value="DIB" onclick="checkbox_click()" >DIB</td>
					<td align="left" class="label_normal2"><input type="checkbox" name="PPT" label="PPT" value="PPT" onclick="checkbox_click()" >PPT</td>
					<td align="left" class="label_normal2"><input type="checkbox" name="BMP" label="BMP" value="BMP" onclick="checkbox_click()" >BMP</td>
				</tr>
				<tr>
					<td align="left" class="label_normal2"><input type="checkbox" name="WPG" label="WPG" value="WPG" onclick="checkbox_click()" >WPG</td>
					<td align="left" class="label_normal2"><input type="checkbox" name="TXT" label="TXT" value="TXT" onclick="checkbox_click()" >TXT</td>
					<td align="left" class="label_normal2">&nbsp;</td>
				</tr>
				<tr>
					<td align="left" class="label_normal2"><input type="checkbox" name="WMF" label="WMF" value="WMF" onclick="checkbox_click()" >WMF</td>
					<td align="left" class="label_normal2"><input type="checkbox" name="RTF" label="RTF" value="RTF" onclick="checkbox_click()" >RTF</td>
					<td align="left" class="label_normal2">&nbsp;</td>
				</tr>
				<tr>
					<td align="left" class="label_normal2"><input type="checkbox" name="JPG" label="JPG" value="JPG" onclick="checkbox_click()" >JPG</td>
					<td align="left" class="label_normal2"><input type="checkbox" name="CSV" label="CSV" value="CSV" onclick="checkbox_click()" >CSV</td>
					<td align="left" class="label_normal2">&nbsp;</td>
				</tr>
				<tr>
					<td align="left" class="label_normal2"><input type="checkbox" name="JIF" label="JIF" value="JIF" onclick="checkbox_click()" >JIF</td>
					<td align="left" class="label_normal2"><input type="checkbox" name="MPEG" label="MPEG" value="MPEG" onclick="checkbox_click()" >MPEG</td>
					<td align="left" class="label_normal2">&nbsp;</td>
				</tr>
			</table>
		</td>
		<td></td>
	</tr>
	<tr>
		<td height="23" colspan="3">&nbsp;</td>
	</tr>
	<tr>
		<td height="23" width="15"></td>
		<td align="center">
			<a href="#" onclick="click_save()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('btt_save2','','images/btt_save2_over.gif',1)"><img src="images/btt_save2.gif" name="btt_save2" width="67" height="22" border="0"></a>&nbsp;
          	<a href="#" onclick="click_cancel()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('btt_cancel','','images/btt_cancel_over.gif',1)"><img src="images/btt_cancel.gif" name="btt_cancel" width="67" height="22" border="0"></a>
		</td>
		<td></td>
	</tr>
</table>
    <input type="hidden" name="FILE_TYPE" value="<%=strFileType %>">
</form>
</body>
</html>
