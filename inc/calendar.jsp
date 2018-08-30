<%@ page language="java" contentType="text/html; charset=TIS-620"
	pageEncoding="TIS-620"%>
<!--
PROGRAM:	Calendar  version 3.00
AUTHOR:      Phanuwat Sukviboon.
MODIFY FOR ALL BROWSER: Kawin Supakalin - Oct 2008
COMPANY:   Summit Computer Co., Ltd	
*************************************************************
Example : How to call this calendar from opener
*************************************************************
<script language="JavaScript">
	var calendarPopup = null;
	function calendar_onclick(){
		window.language = "Thai";     // "Thai" or "English" (Case sensitive)
		window.dateField = document.form1.date_input;     // Specify what's the return field
		window.backcolor = "white";     // This line is an optional , default value is "lightgrey"
		calendarPopup = window.open ('calendar.html','cal','WIDTH=230,HEIGHT=320,MAXIMIZE=0,minimize=no');
	}	
</script>
*************************************************************	
-->
<html>
<head>
<meta http-equiv="Pragma" content="no-cache"> 
<meta http-equiv="Content-Type" content="text/html; charset=tis-620">
<title>ปฏิทิน</title>
<style type="text/css">
.navigator{
	height: 25px;
	font-family: "webdings";
	font-size: 14px;
}
.thaifont{
	font-family: "tahoma";
	font-size : "12px";
}
.navigator, .thaifont{
	border-style: none;
	cursor: pointer;
	background : none;
	cursor: pointer;
}
.today{
	height: 25px;
	font-family: tahoma;
	border-style: none;
	cursor: pointer;
	background : none;
}
.calendarCell{
	width: 100%;
	border-style: none;
	border:0px;
	cursor: pointer;
}
</style>
<!-- ### jsp:include page="../blocks/common/domain.jsp"/ -->
<script language="JavaScript">
<!--

var message="Sorry, right click has been disabled.";
function click(e)
{
	if (document.all)
		if (event.button == 2) { alert(message); return false;	}
	if (document.layers)
		if (e.which == 3) {	alert(message);	return false; }
}
	
if (document.layers) { document.captureEvents(Event.MOUSEDOWN); }
	
document.onmousedown=click;

//-->
</script>

<script language="JavaScript">
<!--
var go_today = new Date();
var ga_lang  = new Array( "English", "Thai" );
var gv_lang  = "Thai";
var gv_year_add   = 0;
var gv_focus_day  = 0;
var ga_month_thai = new Array(  "มกราคม",	"กุมภาพันธ์", 	"มีนาคม", 	"เมษายน",	"พฤษภาคม", 	"มิถุนายน", 
								"กรกฎาคม",	"สิงหาคม",  	"กันยายน", 	"ตุลาคม", 	"พฤศจิกายน", 	"ธันวาคม" 	);
var ga_month_eng  = new Array(  "January",	"February",	"March", 	"April", 	"May", 		"June",
								"July",   	"August",  	"September","October", 	"November",	"December" 	);
if( window.opener != null ){  
	gv_lang = opener.language;
	this.dateField   = opener.dateField;
	/*if( opener.backcolor!=null ){
		this.backcolor = opener.backcolor;
	}else{*/
		this.backcolor = "#f4f1dd";
	//}
	if( gv_lang==null ){ 
		gv_lang = ga_lang[0];
	}
}else{
	this.backcolor = "lightgrey";
}

//-->
</script>
<script language="JavaScript">
<!--
function lp_initialize(){
	lp_set_date();
}
//-- ----------
function lp_set_date() {
    this.inDate	=  "";
    var lv_day	= go_today.getDate();
    var lv_month= go_today.getMonth();
    var lv_year	= go_today.getFullYear();
    lp_set_year();
	lv_year += gv_year_add;
    gv_focus_day = lv_day;
    document.calControl.month.selectedIndex = lv_month;
    document.calControl.year.selectedIndex  = 100;
    lp_display_calendar( lv_day, lv_month, lv_year );
}
//-- ----------
function lp_set_year(){
	var lv_year  = go_today.getFullYear();
	var lv_range = lv_year - 100;
	var la_month = null;
	if (gv_lang == ga_lang[0]){
		//-- English
		gv_year_add = 0;
		la_month = ga_month_eng;
		document.calControl.today .value = "Today";	
	}else if( gv_lang == ga_lang[1] ){
		//-- Thai
		gv_year_add = 543;
		lv_range += gv_year_add;	
		la_month = ga_month_thai;
		document.calControl.today .value = "วันนี้";			
	}
	for( var i=0; i<12; i++ ){
		document.calControl.month.options[i] 		= new Option();
		document.calControl.month.options[i].value 	= la_month[i];
		document.calControl.month.options[i].text 	= la_month[i];
	}
	for( var i=0; i<=200; i++){
		document.calControl.year.options[i] 		= new Option();
		document.calControl.year.options[i].value 	= i + lv_range;
		document.calControl.year.options[i].text  	= i + lv_range;
	}	
}
//-- ----------
function lp_set_today() {
    var lv_day   = go_today.getDate();
    var lv_month = go_today.getMonth();
    var lv_year  = go_today.getFullYear();
    var lv_index = 0;
    lv_year += gv_year_add;
    gv_focus_day = lv_day;
    document.calControl.month.selectedIndex = lv_month;
    lv_index = lv_year - parseInt( document.calControl.year.options[0].value );
	document.calControl.year.selectedIndex = lv_index;       
    lp_display_calendar( lv_day, lv_month, lv_year );
}
//-- ----------
function lp_is_four_digit_year( av_year ) {
	var lb_pass = false;
    if( av_year.length != 4 ){
        alert( "Sorry, the year must be four-digits in length." );
        document.calControl.year.select();
        document.calControl.year.focus();
    }else{
        lb_pass = true;
    }
    return lb_pass;
}
//-- ----------
function lp_select_date() {
   var lv_year  = document.calControl.year.options [document.calControl.year.selectedIndex].value;
   var lv_month = document.calControl.month.selectedIndex;
   var lv_day   = 0;
    if ( lp_is_four_digit_year( lv_year ) ) {
        lp_display_calendar( lv_day, lv_month, lv_year );
    }
}
//-- ----------
function lp_set_previous_year() {
	var lv_year  = document.calControl.year.options [document.calControl.year.selectedIndex].value;
	var lv_month = document.calControl.month.selectedIndex;
	var lv_day   = 0;
	var lv_index = 0;
    if( lp_is_four_digit_year( lv_year ) ){
        lv_year--;
        lv_index = lv_year - parseInt( document.calControl.year.options [0].value );
		document.calControl.year.selectedIndex = lv_index;        
        lp_display_calendar( lv_day, lv_month, lv_year );
    }
}
//-- ----------
function lp_set_previous_month() {
	var lv_year  = document.calControl.year.options [document.calControl.year.selectedIndex].value;
	var lv_month = document.calControl.month.selectedIndex;
	var lv_day   = 0;
	var lv_index = 0;
    if (lp_is_four_digit_year( lv_year )) {
        if( lv_month == 0 ){
            lv_month = 11;
            if( lv_year > 1000 ){
                lv_year--;
                lv_index = lv_year - parseInt( document.calControl.year.options [0].value );
				document.calControl.year.selectedIndex = lv_index;    
            }
        }else{
            lv_month--;
        }
        document.calControl.month.selectedIndex = lv_month;
        lp_display_calendar( lv_day, lv_month, lv_year );
    }
}
//-- ----------
function lp_set_next_month() {
   var lv_year  = document.calControl.year.options [document.calControl.year.selectedIndex].value;
   var lv_month = document.calControl.month.selectedIndex;
   var lv_day   = 0;
   var lv_index = 0;    
    if( lp_is_four_digit_year( lv_year ) ){
        if (lv_month == 11) {
            lv_month = 0;
            lv_year++;
            lv_index = year - parseInt(document.calControl.year.options[0].value);
			document.calControl.year.selectedIndex = lv_index;    
        }else{
            lv_month++;
        }
        document.calControl.month.selectedIndex = lv_month;
        lp_display_calendar( lv_day, lv_month, lv_year );
    }
}
//-- ----------
function lp_set_next_year() {
   var lv_year  = document.calControl.year.options [document.calControl.year.selectedIndex].value;
   var lv_month = document.calControl.month.selectedIndex;
   var lv_day   = 0;
   var lv_index = 0;
    if (lp_is_four_digit_year(lv_year)) {
        lv_year++;
        lv_index = lv_year - parseInt( document.calControl.year.options [0].value );
		document.calControl.year.selectedIndex = lv_index;        
        lp_display_calendar( lv_day, lv_month, lv_year );
    }
}
//-- ----------
function lp_display_calendar( av_day, av_month, av_year ) {       
	var lv_day		= parseInt( av_day );
	var lv_month	= parseInt(av_month);
	var lv_year 	= parseInt(av_year) - gv_year_add;
    var lv_last_day = lp_get_day_in_month( lv_month, lv_year );
    var lv_days 	= lp_get_day_in_month( lv_month+1,lv_year);
    var lo_month 	= new Date (lv_year, lv_month, 1);
    var lv_starting_pos = lo_month.getDay();
    var lv_dx		= 1;
    var lv_tmp		= 0;
    lv_days += lv_starting_pos;
	lv_last_day = (lv_last_day==0)?31:lv_last_day;
    for( var i=0; i<lv_starting_pos; i++ ){
		document.calButtons.elements[i].style.backgroundColor= "lightblue"; //this.backcolor;
		document.calButtons.elements[i].style.cursor= "default";
		document.calButtons.elements[i].style.color	= "#677888";
		document.calButtons.elements[i].disabled 	= true;
		document.calButtons.elements[i].value 		= lv_last_day - ( lv_starting_pos-i-1 );
    }
    for( var i=lv_starting_pos; i<lv_days; i++ ){
		lv_tmp = i - lv_starting_pos + 1;
		if ((lv_tmp > 0) && (lv_tmp < 10)){
			lv_tmp = "" + lv_tmp;
		}
        document.calButtons.elements[i].value				  = lv_tmp;
		document.calButtons.elements[i].style.backgroundColor = "#dfefff";
		document.calButtons.elements[i].style.cursor 		  = "pointer";
		document.calButtons.elements[i].style.color			  = "black";
		document.calButtons.elements[i].disabled 			  = false;
		if( (i%7)==0 ){
			document.calButtons.elements[i].style.color = "red";
		}
        //document.calButtons.elements[i].onclick = "returnDate";
    }
    for (var i=lv_days; i<42; i++,lv_dx++)  {
		document.calButtons.elements[i].style.backgroundColor= "lightblue"; //this.backcolor;
		document.calButtons.elements[i].style.cursor 		 = "default";
		document.calButtons.elements[i].style.color			 = "#677888";
		document.calButtons.elements[i].disabled 			 = true;
		document.calButtons.elements[i].value 				 = lv_dx;        
    }
    document.calButtons.elements[ gv_focus_day + lv_starting_pos - 1 ].focus();
	if( document.calButtons.elements[ gv_focus_day + lv_starting_pos - 1 ].value != "" ){
    	document.calButtons.elements[ gv_focus_day + lv_starting_pos - 1 ].style.backgroundColor = "yellow";
    }
}
//-- ----------
function lp_get_day_in_month( av_month, av_year )  {
	var lv_days = 0;
    if( av_month==1 || av_month==3  || av_month==5 || av_month==7 || 
    	av_month==8 || av_month==10 || av_month==12 ){  
		lv_days = 31;
    }else{
		if( av_month==4 || av_month==6 || av_month==9 || av_month==11){ 
			lv_days = 30;
		}else{ 
			if( av_month==2 ){
				if( lp_is_leap_year( av_year ) ){
					lv_days = 29;
				}else{
					lv_days = 28;
				}
			}
		}
	}
    return lv_days;
}
//-- ----------
function lp_is_leap_year( av_year ){
    if( ( (av_year%4)==0 ) && ( (av_year%100)!=0 ) || ( (av_year%400)==0 ) ){
        return true;
    }else{ 
        return false;
	}
}
//-- ----------
function lp_return_date( av_day ){
    var lv_day   = av_day;
    var lv_month = (document.calControl.month.selectedIndex) + 1;
    var lv_year = (document.calControl.year.selectedIndex) + 
    	    parseInt( document.calControl.year.options [0].value );
    if( (""+lv_month).length == 1 ){
        lv_month = "0" + lv_month;
    }
    if( lv_day != "" ){
		if (lv_day.length == 1){
			lv_day = "0" + lv_day;
		}
		if( (dateField.value).lastIndexOf("-") != -1 ){
			dateField.value = dateField.value +  lv_year.toString() + lv_month + lv_day;
		}else{
			dateField.value = lv_day + "/" + lv_month + "/" + lv_year;
		}
		if( opener!=null ){
			if(opener.pageID != null){
				switch (opener.pageID){
				 	case "viewdocument" :
						var str = "\/nia\/p04docfile\/p03_child_list.asp?DOC_DATE=" + 
								  lv_year + lv_month + lv_day;
						opener.iframe1.location =str;
						break;
				}
				
			}
		}
                
                dateField.focus();
		try{
			dateField.select();
			eval("opener.yp_cld_"+dateField.id+"();");
		}catch(e){}
        window.close()
        
    }
}
// --> 
</script>
</head>
<body bgcolor=lightgrey onload="lp_initialize();" onunload="//opener.focus();">
<center>
<form name="calControl" onsubmit="return false;">
<!-- Border #1-->
<table align="center" cellpadding="1" cellspacing="0" border="0"><tr><td>

<!--- Table #1 --->
<table width="100%" align="center" cellpadding="3" cellspacing="0" border="0">

<tr><td nowrap colspan="5" class="thaifont">
<center>
	<select name="month" onchange="lp_select_date();" style="width:60%;">
	</select>
	<select id="year" name="year" onchange="lp_select_date();" style="width:38%;">
	</select>         
</center>
</td>
</tr>
<tr><td nowrap colspan="5">

<!--- Table #2 --->
<script language="JavaScript">
<!--
	//if (navigator.appName != "Netscape"){
		document.write ('<table width="100%" align="center" cellpadding=1 cellspacing=0 border=1><tr>');
	/*}else{
		document.write ('<table align="center" cellpadding=0 cellspacing=0 border=0><tr>');
	}*/
//-->
</script>
<script language="JavaScript">
<!--
	var strToday;
	if (gv_lang == ga_lang[1]){
		strToday = "   วันนี้   "; 
		Title1 = " ปีก่อนหน้า ";
		Title2 = " เดือนก่อนหน้า ";
		Title3 = " วันปัจจุบัน (วันนี้) ";
		Title4 = " เดือนถัดไป ";
		Title5 = " ปีถัดไป ";
	}else{
		strToday = "   Today   ";
		Title1 = " Previous year ";
		Title2 = " Previous month ";
		Title3 = " Current date (today) ";
		Title4 = " Next month ";
		Title5 = " Next year ";
	}	
	if (navigator.appName != "Netscape"){
		document.write ('<td align="center" nowrap onmouseover="this.style.backgroundColor=\'#dedeff\'" onmouseout="this.style.backgroundColor=\'\'"><input type=button name="previousYear" value="7" title="' + Title1 + '" onclick="lp_set_previous_year()" class="navigator"></td>');
		document.write ('<td align="center" nowrap onmouseover="this.style.backgroundColor=\'#dedeff\'" onmouseout="this.style.backgroundColor=\'\'"><input type=button name="previousDay" value="3" title="' + Title2 + '" onclick="lp_set_previous_month()" class="navigator"></td>');
		document.write ('<td align="center" nowrap  onmouseover="this.style.backgroundColor=\'yellow\'" onmouseout="this.style.backgroundColor=\'\'"><input type=button  name="today" value="' + strToday + '" title="' + Title3 + '" onclick="lp_set_today()" class="today"></td>');
		document.write ('<td align="center" nowrap onmouseover="this.style.backgroundColor=\'#dedeff\'" onmouseout="this.style.backgroundColor=\'\'"><input type=button name="nextDay" value="4" title="' + Title4 + '" onclick="lp_set_next_month()" class="navigator"></td>');
		document.write ('<td align="center" nowrap onmouseover="this.style.backgroundColor=\'#dedeff\'" onmouseout="this.style.backgroundColor=\'\'"><input type=button name="nextYear" value="8" title="' + Title5 + '" onclick="lp_set_next_year()" class="navigator"></td>');
	}else{
		document.write ('<td><input type=button name="previousYear" value="<<" onclick="lp_set_previous_year()" class="thaifont"></td>');
		document.write ('<td><input type=button name="previousDay" value=" < "   onclick="lp_set_previous_month()" class="thaifont"></td>');
		document.write ('<td><input type=button name="today" value="' + strToday + '" onclick="lp_set_today()" class="thaifont"></td>');
		document.write ('<td><input type=button name="nextDay" value=" > "   onclick="lp_set_next_month()" class="thaifont"></td>');
		document.write ('<td><input type=button name="nextYear" value=">>" onclick="lp_set_next_year()" class="thaifont"></td>');
	}	
//-->		
</script>
<% out.print("</tr></table>"); %><!--- Table #2 --->
</td>
</tr>
</table> <!--- Table #1 --->

</td></tr>  <!--- Border #1 --->
<tr><td> <!--- Border #1 --->

<% out.print("</form>"); %>
<% out.print("<form name='calButtons'>"); %>

<!-- Border #2-->
<table align="center" cellpadding="1" cellspacing="0" border="2" bordercolor="Black"><tr><td>

<!--- Table #3 --->
<script language="JavaScript">
<!--
	//if (navigator.appName != "Netscape"){
		document.write ('<table width="100%" cellpadding=0 cellspacing=0 border=1>');
	/*}else{
		document.write ('<table width="100%" cellpadding=0 cellspacing=0 border=0>');
	}*/
//-->
</script>			
	
<TBODY>
<tr>
<script language=javascript>
<!--
	var lv_s1 = '<td bgcolor="Navy" width="30"><center><font face="tahoma" color="white" size=2><b>';
	var lv_s2 = '<td bgcolor="Navy" width="30"><center><font SIZE=-1 face="tahoma" COLOR="White"><b>';
	var lv_s3 = '</b></font></center></td>';
	if( gv_lang == ga_lang[0] ){
		document.write ('<td bgcolor="Red" width="30"><center><font face="tahoma" color="white" size=2><b>S'+lv_s3);
		document.write (lv_s1 + 'M'	+lv_s3);
		document.write (lv_s1 + 'TU'+lv_s3);
		document.write (lv_s1 + 'W'	+lv_s3);
		document.write (lv_s1 + 'TH'+lv_s3);
		document.write (lv_s1 + 'F'	+lv_s3);
		document.write (lv_s1 + 'SA'+lv_s3);
    }else if( gv_lang == ga_lang[1] ){
		document.write ('<td bgcolor="Red" width="30"><center><font SIZE=-1 face="tahoma" COLOR="White"><b>อา.'+lv_s3);
		document.write (lv_s2 + 'จ.'	 +lv_s3);
		document.write (lv_s2 + 'อ.' +lv_s3);
		document.write (lv_s2 + 'พ.' +lv_s3);
		document.write (lv_s2 + 'พฤ.'+lv_s3);
		document.write (lv_s2 + 'ศ.' +lv_s3);
		document.write (lv_s2 + 'ส.' +lv_s3);
    }  
//-->
</script>
</tr>
<tr>
	<td><input type="button" name="but0"  value="     " onclick="lp_return_date(this.value)" class="calendarCell"></td>
    <td><input type="button" name="but1"  value="     " onclick="lp_return_date(this.value)" class="calendarCell"></td>
    <td><input type="button" name="but2"  value="     " onclick="lp_return_date(this.value)" class="calendarCell"></td>
    <td><input type="button" name="but3"  value="     " onclick="lp_return_date(this.value)" class="calendarCell"></td>
    <td><input type="button" name="but4"  value="     " onclick="lp_return_date(this.value)" class="calendarCell"></td>
    <td><input type="button" name="but5"  value="     " onclick="lp_return_date(this.value)" class="calendarCell"></td>
    <td><input type="button" name="but6"  value="     " onclick="lp_return_date(this.value)" class="calendarCell"></td>
</tr>

<tr>
	<td onmouseover=""><input type="button" name="but7"  value="     " onclick="lp_return_date(this.value)" class="calendarCell"></td>
    <td><input type="button" name="but8"  value="     " onclick="lp_return_date(this.value)" class="calendarCell"></td>
    <td><input type="button" name="but9"  value="     " onclick="lp_return_date(this.value)" class="calendarCell"></td>
    <td><input type="button" name="but10" value="     " onclick="lp_return_date(this.value)" class="calendarCell"></td>
    <td><input type="button" name="but11" value="     " onclick="lp_return_date(this.value)" class="calendarCell"></td>
    <td><input type="button" name="but12" value="     " onclick="lp_return_date(this.value)" class="calendarCell"></td>
    <td><input type="button" name="but13" value="     " onclick="lp_return_date(this.value)" class="calendarCell"></td>
</tr>

<tr>
	<td><input type="button" name="but14" value="     " onclick="lp_return_date(this.value)" class="calendarCell"></td>
    <td><input type="button" name="but15" value="     " onclick="lp_return_date(this.value)" class="calendarCell"></td>
    <td><input type="button" name="but16" value="     " onclick="lp_return_date(this.value)" class="calendarCell"></td>
    <td><input type="button" name="but17" value="     " onclick="lp_return_date(this.value)" class="calendarCell"></td>
    <td><input type="button" name="but18" value="     " onclick="lp_return_date(this.value)" class="calendarCell"></td>
    <td><input type="button" name="but19" value="     " onclick="lp_return_date(this.value)" class="calendarCell"></td>
    <td><input type="button" name="but20" value="     " onclick="lp_return_date(this.value)" class="calendarCell"></td>
</tr>

<tr>
	<td><input type="button" name="but21" value="     " onclick="lp_return_date(this.value)" class="calendarCell"></td>
    <td><input type="button" name="but22" value="     " onclick="lp_return_date(this.value)" class="calendarCell"></td>
    <td><input type="button" name="but23" value="     " onclick="lp_return_date(this.value)" class="calendarCell"></td>
    <td><input type="button" name="but24" value="     " onclick="lp_return_date(this.value)" class="calendarCell"></td>
    <td><input type="button" name="but25" value="     " onclick="lp_return_date(this.value)" class="calendarCell"></td>
    <td><input type="button" name="but26" value="     " onclick="lp_return_date(this.value)" class="calendarCell"></td>
    <td><input type="button" name="but27" value="     " onclick="lp_return_date(this.value)" class="calendarCell"></td>
</tr>

<tr>
	<td><input type="button" name="but28" value="     " onclick="lp_return_date(this.value)" class="calendarCell"></td>
    <td><input type="button" name="but29" value="     " onclick="lp_return_date(this.value)" class="calendarCell"></td>
    <td><input type="button" name="but30" value="     " onclick="lp_return_date(this.value)" class="calendarCell"></td>
    <td><input type="button" name="but31" value="     " onclick="lp_return_date(this.value)" class="calendarCell"></td>
    <td><input type="button" name="but32" value="     " onclick="lp_return_date(this.value)" class="calendarCell"></td>
    <td><input type="button" name="but33" value="     " onclick="lp_return_date(this.value)" class="calendarCell"></td>
    <td><input type="button" name="but34" value="     " onclick="lp_return_date(this.value)" class="calendarCell"></td>
</tr>

<tr>
	<td><input type="button" name="but35" value="     " onclick="lp_return_date(this.value)" class="calendarCell"></td>
    <td><input type="button" name="but36" value="     " onclick="lp_return_date(this.value)" class="calendarCell"></td>
    <td><input type="button" name="but37" value="     " onclick="lp_return_date(this.value)" class="calendarCell"></td>
    <td><input type="button" name="but38" value="     " onclick="lp_return_date(this.value)" class="calendarCell"></td>
    <td><input type="button" name="but39" value="     " onclick="lp_return_date(this.value)" class="calendarCell"></td>
    <td><input type="button" name="but40" value="     " onclick="lp_return_date(this.value)" class="calendarCell"></td>
    <td><input type="button" name="but41" value="     " onclick="lp_return_date(this.value)" class="calendarCell"></td>
</tr>
</tbody></table> <!--- Table #3 --->
	
<!-- End of Table's border --->
<% out.print("</td></tr></table>"); %><!--- Border #2 --->
<% out.print("</td></tr></table>"); %><!--- Border #1 ---> 

<% out.print("</form></center>"); %>

<script language="JavaScript">
	//if (navigator.appName != "Netscape"){
		document.body.bgColor = this.backcolor;
		if (gv_lang == ga_lang[1])
			document.title = "ปฏิทิน - โดย บริษัท ซัมมิท คอมพิวเตอร์ จำกัด";
		else
		 	document.title = "Calendar - by Summit Computer";
	//}
</script>
</body>
</html>
