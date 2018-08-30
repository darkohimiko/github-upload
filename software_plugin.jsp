<%@ page contentType="text/html; charset=tis-620"%>
<%@ include file="inc/utils.jsp" %>
<%@ include file="inc/constant.jsp" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title><%=lc_site_name%></title>
<meta http-equiv="Content-Type" content="text/html; charset=tis-620">
<link rel="shortcut icon" href="images/favicon/EDAS.ico" type="image/x-icon" />
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
<script language="JavaScript" src="js/sccUtils.js"></script>
<script language="JavaScript" src="js/util.js"></script>
<script language="JavaScript" src="js/constant.js"></script>
<script language="JavaScript" src="js/label.js"></script>
<script language="JavaScript" type="text/javascript">
<!--

function window_onload() {
        lb_software_install0.innerHTML   = lbl_software_install;
	lb_software_install.innerHTML   = lbl_software_install;
        lb_software_install32b.innerHTML   = lbl_software_install32b;
        lb_software_install64b.innerHTML   = lbl_software_install64b;
//	lb_software_help.innerHTML      = lbl_software_help;
	lb_software_install_1.innerHTML = lbl_software_install;
//	lb_software_install_2.innerHTML = lbl_software_install;
//	lb_software_help_2.innerHTML    = lbl_software_help;
	lb_software_install_3.innerHTML = lbl_software_install;
//	lb_software_help_3.innerHTML    = lbl_software_help;
	lb_software_install_4.innerHTML = lbl_software_install;
//	lb_software_help_4.innerHTML    = lbl_software_help;
	lb_software_install_5.innerHTML = lbl_software_install;
//	lb_software_help_5.innerHTML    = lbl_software_help;
//	lb_software_dotnet.innerHTML    = lbl_software_dotnet;
}

function buttonClick( lv_strMethod ) {
    switch( lv_strMethod ){
                case "i_inet" :
			window.open( "../jinetdocarchive/archive/resource/inetbase.exe", "_blank" );
			form1.submit();
			break;
		case "i_client" :
			window.open( "software/client/edas_client.zip", "_blank" );
			form1.submit();
			break;
		case "i_cad" :
			//window.open( "software/autocad/DWGTrueView2010.exe", "_blank" );
			window.open( "software_plugin2.jsp", "_blank" );
			form1.submit();
			break;
		case "i_cad_2" :
			window.open( "software/autocad/freedwgviewer.exe", "_blank" );
			//window.open( "software_plugin2.jsp", "_blank" );
			form1.submit();
			break;
		case "i_jre32" :
			window.open( "software/jre/jre7u5x32.exe", "_blank" );
			form1.submit();
			break;
                case "i_jre64" :
			window.open( "software/jre/jre7u5x64.exe", "_blank" );
			form1.submit();
			break;
		case "i_acrobat" :
			window.open( "software/adobe/AdbeRdr110.exe", "_blank" );
			form1.submit();
			break;
		case "i_icon" :
			window.open( "software/EDAS2.ico", "_blank" );
			form1.submit();
			saveImageAs();
			break;
		//=============== HELP ===============
		case "h_viewer" :
			window.open( "software/help/inetimageview.pdf", "_blank" );
			form1.submit();
			break;
		case "h_cad" :
			//window.open( "autocad/setup.exe", "_blank" );
			//form1.submit();
			break;
		case "h_jre" :
			//window.open( "jre/setup.exe", "_blank" );
			//form1.submit();
			break;
		case "h_acrobat" :
			//window.open( "adobe/setup.exe", "_blank" );
			//form1.submit();
			break;
		case "h_icon" :
			//window.open( "adobe/setup.exe", "_blank" );
			//form1.submit();
			break;
	}
}

function saveImageAs() {
//	if(typeof imgOrURL == 'object') {
//		imgOrURL = imgOrURL.src;
//	}
   	window.win = open( "software/EDAS2.ico" );
   	setTimeout( "win.document.execCommand('SaveAs')", 500 );
}


function page_close() {
	//window.open('','_self','');
	//window.opener = self;
	window.close();
}

//-->
</script>
<link href="css/edas.css" type="text/css" rel="stylesheet">
</head>
<body onLoad="MM_preloadImages('images/close_over.gif');window_onload();" class="bg">
<form name="form1" method="post" action="" >
<table width="100%" height="100%" border="1" align="center" cellpadding="0" cellspacing="0">
<tr><td>
<div id="screen_div" style="width:100%;height:100%;overflow-y:scroll;overflow-x:hidden;margin-right:0px;margin-bottom:0px;border:0px #ccc solid;" >
<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
	<tr><td class="bg">
<table width="990" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
	<tr> 
	    <td width="504" height="109" class="header01">
                <img src="images/main_01.jpg" width="576" height="109"></td>
            <td width="486" valign="bottom"  style="padding-left:360px;background: url('images/plugin.jpg') no-repeat right;">
	    	<a href="#" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('close','','images/close_over.gif',1)" onclick="page_close()">
	    		<img src="images/close.gif" name="close" width="25" height="25" border="0">
	    	</a>
	    </td>
	</tr>
  	<tr valign="top">
    	<td colspan="2" background="images/main_bg.jpg">
    		<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
	        	<tr>
	          		<td width="31"><img src="images/frame_01.jpg" width="31" height="23"></td>
	          		<td width="701" background="images/frame_02.jpg">&nbsp;</td>
	          		<td width="18"><img src="images/frame_04.jpg" width="30" height="23"></td>
	        	</tr>
	        	<tr>
	          		<td background="images/frame_08.jpg">&nbsp;</td>
	          		<td>
						<table width="600" border="0" align="center" cellpadding="0" cellspacing="0">
	              			<tr>
                				<td background="images/dot_2.gif">
                					<img src="images/softwareplugin.gif" width="155" height="25">
                				</td>
              				</tr>
            			</table> 
            			<br>
            			<table width="600" border="0" align="center" cellpadding="0" cellspacing="0" class="label_bold3">
              				<tr> 
                				<td width="355"><div align="center"><img src="images/b_inet.gif" width="191" height="50"></div></td>
                				<td width="245">
                					<a href="#" class="install" onclick="buttonClick('i_inet')"><span id="lb_software_install0"></span></a>&nbsp;                					
                				</td>
			              	</tr>
                                        <tr> 
                				<td width="355"><div align="center"><img src="images/b_client.gif" width="191" height="50"></div></td>
                				<td width="245">
                					<a href="#" class="install" onclick="buttonClick('i_client')"><span id="lb_software_install"></span></a>&nbsp;
                				</td>
			              	</tr>
			              	<tr> 
				                <td width="355"><div align="center"><img src="images/b_java.gif" width="191" height="50"></div></td>
				                <td width="245">
				                	<a href="#" class="install" onclick="buttonClick('i_jre32')"><span id="lb_software_install32b"></span></a>&nbsp;
				                	<a href="#" class="install" onclick="buttonClick('i_jre64')"><span id="lb_software_install64b"></span></a>
				                </td>
			              	</tr>
			              	<tr> 
				                <td><div align="center"><img src="images/b_autocad.gif" width="191" height="50"></div></td>
				                <td>&nbsp;
				                </td>
			              	</tr>
              				<tr> 
                				<td><div align="center"><img src="images/b_trueview.gif" width="260" height="44"></div></td>
                				<td>
                					<a href="#" class="install" onclick="buttonClick('i_cad')"><span id="lb_software_install_1"></span></a>&nbsp;
<!--                					[ <img src="images/pdf.gif" width="16" height="16" align="texttop">
                					<a href="#" class="help" onclick="buttonClick('h_cad')"><span id="lb_software_dotnet"></span> ]</a>-->
                				</td>
              				</tr>
              				<tr>
				                <td><div align="center"><img src="images/b_viewer.gif" width="260" height="44"></div></td>
				                <td>
				                	<a href="#" class="install" onclick="buttonClick('i_cad_2')"><span id="lb_software_install_4"></span></a>&nbsp;
<!--				                	<a href="#" class="help" onclick="buttonClick('h_cad_2')"><span id="lb_software_help_4"></span></a>-->
				                </td>
                                        </tr>
			              	<tr> 
			                	<td><div align="center"><img src="images/b_acrobat.gif" width="191" height="50"></div></td>
			                	<td>
				                	<a href="#" class="install" onclick="buttonClick('i_acrobat')"><span id="lb_software_install_3"></span></a>&nbsp;
<!--				                	<a href="#" class="help" onclick="buttonClick('h_acrobat')"><span id="lb_software_help_3"></span></a>-->
			                	</td>
			              	</tr>
			              	<tr> 
			                	<td><div align="center"><img src="images/b_edas.gif" width="191" height="50"></div></td>
			                	<td>
				                	<a href="#" class="install" onclick="buttonClick('i_icon')" visible="false"><span id="lb_software_install_5"></span></a>&nbsp;
<!--				                	<a href="#" class="help" onclick="buttonClick('h_icon')"><span id="lb_software_help_5"></span></a>-->
			                	</td>
			              	</tr>
            			</table>
            			<br>
            			<div align="right"></div>
            		</td>
          			<td background="images/frame_10.jpg">&nbsp;</td>
        		</tr>
        		<tr>
	          		<td><img src="images/frame_11.jpg" width="31" height="24"></td>
	          		<td background="images/frame_12.jpg">&nbsp;</td>
	          		<td><img src="images/frame_14.jpg" width="30" height="24"></td>
        		</tr>
      		</table>
    	</td>
  	</tr>
  	<tr> 
    	<td height="25" colspan="2"><img src="images/main_03.jpg" width="990" height="25"></td>
  	</tr>
</table>
	</td></tr>
</table>
</div>
</td></tr>
</table>
</form>
</body>
</html>