<%@ page contentType="text/html; charset=tis-620"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=TIS-620">
<title>EDAS</title>
<link href="css/edas.css" type="text/css" rel="stylesheet">
<style type="text/css">

.table_manual{
    font-size: 12px;
	color: #cccc;
	font-weight: bold;
	font-family: "tahoma";
	line-height: 170%;
    background-image: url(images/bg_manual.gif); 
    background-repeat: repeat-x; 
	background-color:#FFF;

}

#manul:link , #manul:visited , #manul:active
{
	font-family: "Tahoma";
	font-size:12px;
	color: #504f4f;	
	font-weight:bold;
	text-decoration: none;
	line-height: 160%;
}

#manul:hover
{
	color: #924eae;	
	font-weight:bold;
	text-decoration: none;
	font-family: "Tahoma";
	line-height: 160%;
}


</style>
<script language="JavaScript" src="js/label.js"></script>
<script type="text/javascript">
<!--

function window_onload() {
	lb_manual.innerHTML               = lbl_manual;
    lb_manual_basic.innerHTML         = lbl_manual_basic;
    lb_system_config.innerHTML        = lbl_system_config;
    lb_table_system.innerHTML         = lbl_table_system;
    lb_user_profile.innerHTML         = lbl_user_profile;
    lb_doc_level.innerHTML            = lbl_doc_level;
    lb_user_management.innerHTML      = lbl_user_management;
    lb_user_group_management.innerHTML = lbl_user_group_management;
    lb_cabinet_management.innerHTML   = lbl_cabinet_management;
    lb_manual_information.innerHTML   = lbl_manual_information;
    lb_manual_faq.innerHTML 		  = lbl_manual_faq;
    lb_manual_report_export.innerHTML = lbl_manual_report_export;
    lb_manual_retention_module.innerHTML = lbl_manual_retention_module;
    lb_manual_password.innerHTML      = lbl_manual_password;
    lb_manual_zoom.innerHTML          = lbl_manual_zoom;
    lb_manual_icon.innerHTML          = lbl_manual_icon;
    lb_manual_scan.innerHTML          = lbl_manual_scan;
}

function open_page(av_source){
	var screenWidth  = window.screen.availWidth;
	var screenHeight = window.screen.availHeight;
	
	av_source = "doc/admin/" + av_source;
	var lo_win = window.open(av_source,"_blank","toolbar=no");
	try{
		lo_win.moveTo(0,0);
		lo_win.resizeTo( screenWidth, screenHeight );
	}catch(e){
		
	}
}
//-->
</script>
</head>
<body onload="window_onload()">
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td valign="top">	
			<table width="800" border="0" cellspacing="0" cellpadding="0">
              	<tr>
                	<td height="30">
                		<div align="center"></div>
               		</td>
              	</tr>
              	<tr> 
                	<td><div align="center"> 
                    	<table width="500" border="0" cellpadding="0" cellspacing="0">
                      		<tr class="hd_table"> 
                        		<td width="10"><img src="images/hd_tb_01.gif" width="10" height="28"></td>
                        		<td><span id="lb_manual"></span></td>
                        		<td><img src="images/hd_tb_04.gif" width="10" height="28"></td>
                      		</tr>
                      		<tr class="table_manual"> 
                        		<td>&nbsp;</td>
                        		<td align="left">
									<ol style="list-style-image: url('images/bullet_g.gif');margin-left: 100px">
			                            <li><a href="#" onclick="open_page('Chapter1.pdf')" id="manul"><span id="lb_manual_basic"></span></a></li>
			                            <li><a href="#" onclick="open_page('Chapter2.pdf')" id="manul"><span id="lb_system_config"></span></a></li>
			                            <li><a href="#" onclick="open_page('Chapter3.pdf')" id="manul"><span id="lb_table_system"></span></a></li>
			                            <li><a href="#" onclick="open_page('Chapter4.pdf')" id="manul"><span id="lb_user_profile"></span></a></li>
			                            <li><a href="#" onclick="open_page('Chapter5.pdf')" id="manul"><span id="lb_doc_level"></span></a></li>
			                            <li><a href="#" onclick="open_page('Chapter6.pdf')" id="manul"><span id="lb_user_management"></span></a></li>
			                            <li><a href="#" onclick="open_page('Chapter12.pdf')" id="manul"><span id="lb_user_group_management"></span></a></li>
			                            <li><a href="#" onclick="open_page('Chapter7.pdf')" id="manul"><span id="lb_cabinet_management"></span></a></li>
			                            <li><a href="#" onclick="open_page('Chapter8.pdf')" id="manul"><span id="lb_manual_information"></span></a></li>
			                            <li><a href="#" onclick="open_page('Chapter9.pdf')" id="manul"><span id="lb_manual_faq"></span></a></li>
			                            <li><a href="#" onclick="open_page('Chapter10.pdf')" id="manul"><span id="lb_manual_report_export"></span></a></li>
			                            <li><a href="#" onclick="open_page('Append1.pdf')" id="manul"><span id="lb_manual_password"></span></a></li>
			                            <li><a href="#" onclick="open_page('Append2.pdf')" id="manul"><span id="lb_manual_zoom"></span></a></li>
			                            <li><a href="#" onclick="open_page('Append3.pdf')" id="manul"><span id="lb_manual_icon"></span></a></li>
			                            <li><a href="#" onclick="open_page('Append4.pdf')" id="manul"><span id="lb_manual_scan"></span></a></li>
			                            <li><a href="#" onclick="open_page('Chapter11.pdf')" id="manul"><span id="lb_manual_retention_module"></span></a></li>
								  	</ol>
                       			</td>
                        		<td width="10">&nbsp;</td>
	                      	</tr>
                    	</table>
                    	<table width="500" border="0" cellpadding="0" cellspacing="0" class="footer_table">
                      		<tr> 
                        		<td>&nbsp;</td>
                      		</tr>
                    	</table>
                  		</div>
                 	</td>
              	</tr>
            </table>
		</td>
	</tr>
</table>	                    
</body>
</html>