//-- ------------------------------------
//-- CONSTANT
//-- ------------------------------------
var btn_mode_new    = "tdNew";
var btn_mode_save   = "tdSave";
var btn_mode_edit   = "tdEdit";
var btn_mode_search = "tdSearch";
var btn_mode_cancel = "tdCancel";

//-- ------------------------------------
//-- ~
//-- ------------------------------------
//-- FUNCTION
//-- ------------------------------------

function headerMove(idScroll,obj){
    document.all(idScroll).style.top =obj.scrollTop-1;
    document.all(idScroll).style.left =-1;
}


function keyEnter()
{
    if (window.event.keyCode==13) window.event.keyCode=9;
}

function logchkout() {

    top.topFrame.ichkout.location="inc/write_logchkout.jsp"
    top.mainFrame.location= "main2.jsp";
}

function mouseOver( obj ){
	obj.style.cursor = "pointer";
	obj.style.backgroundColor='#CCCCFF';
}       

function mouseOut( obj ){
	obj.style.backgroundColor='';
}

function validate(objForm,warning){
  if (objForm.value==""){
    alert(warning);
    objForm.focus();
    return false;
  }
  return true;
}

function skipAutoTab(){
	if (window.event.keyCode==13) window.event.keyCode="";
}

function formatPid(obj){ obj.value=formatPersonalID(obj.value);}

function formatTin(obj){obj.value=formatTaxID(obj.value);}

function formatPersonalID(value){
	value=value.replace(/-/gi,"");
	if (value=="" || value.length!=13) return value;
    return value.substring(0,1)+"-"+value.substring(1,5)+"-"+value.substring(5,10)+"-"+value.substring(10,12)+"-"+value.substring(12,13);
}


function modePanelChange(argMode){

   var oNode = modePanel.documentElement;
   var root=oNode.childNodes;
   var inputName="";
   try{
       for (i=0;i<root.length;i++){
                var objNode=oNode.childNodes.item(i);
                inputName=objNode.nodeName;
                var objAtt=objNode.attributes;
                if (objAtt(0)!=null){
                    var valueMode=new Array();
                    valueMode=objAtt(0).value.split("|");
                    if (valueMode.length<=1){
                            if (argMode==valueMode)
                                isEnabled(inputName,true);
                            else
                                isEnabled(inputName,false);
                    }else{
                            for(k=0;k<valueMode.length;k++){
                                    if (argMode==valueMode[k]){
                                        isEnabled(inputName,true);
                                        break;
                                    }else{
                                        isEnabled(inputName,false);
                                    }
                            }
                    }
             }
       }
    }catch(e){
            alert("xml error !");
    }
 }


function chkNumber(objText,typeNumber,isNegative)
{
    // typeNumber="decimal" and ="integer"
    if (isNegative==null) isNegative=false;
    var number="0123456789";
    if (typeNumber.toUpperCase()=="DECIMAL")
    {
        number=number+".";
        // *********** check ว่าที่ key เข้ามาเป็น "." หรือเปล่า***************
        if (String.fromCharCode(window.event.keyCode)==".")
        {
            //********* check ให้ ใส่จุดได้แค่ครั้งเดียว ***************
            if (objText.value.indexOf(".",0)!=-1)
            {
                window.event.keyCode="";
                return false;
            }
        }
    }
    if (isNegative==true)
    {
        number=number+"-";
        // *********** check ว่าที่ key เข้ามาเป็น "-" หรือเปล่า***************
         if (String.fromCharCode(window.event.keyCode)=="-")
        {
            //********* check ให้ ใส่"-"ได้แค่ครั้งเดียวและต้องอยู่หน้าสุด ***************
            if (objText.value.substring(0,1)=="-" || objText.value.substring(0,1)!="")
            {
                window.event.keyCode="";
                return false;
            }
        }
    }
    var strValue=String.fromCharCode(window.event.keyCode);
    if (number.indexOf(strValue,0)==-1)
    {
        window.event.keyCode="";
        return false;
    }
    return true;
}

function chkDateThai(objText)
{
   if (!isDateValid(objText.value,"undefined") && objText.value!="")
   {
       //alert("กรุณากรอกวันที่ให้ถูกต้อง");
       alert(lc_fill_date_correct);
        objText.select();
		return true;
   }
   else
   {
        objText.value=dateToScreen(dateToDb(objText.value,"3","undefined"));
		return false;
   }
}

function  isDateValid(strDate,checkCurrent,separator){
	var D1 = new Array()	;
	var D2 = new Array();
	if (checkCurrent == "undefined")checkCurrent = false;
	if (separator == '' || separator == null) separator="/";
	var rg = new RegExp(separator,"gi")
	strDate=strDate.replace(rg,"");
    if(strDate.length != 8) return false;
    D1[2] = strDate.substr(4,8); //year
    D1[1] = strDate.substr(2,2);  //month
    D1[0] = strDate.substr(0,2); //day

	D1[0] = parseFloat(D1[0]);
	D1[1] = parseFloat(D1[1]);
	if (parseFloat(D1[2])>=2400 ){
		D1[2] = parseFloat(D1[2])-543;
	}
    else
    	{
    		D1[2] = parseFloat(D1[2]);
    	}

    //alert(D1[0]+' '+D1[1]+' '+D1[2]);

	if((((D1[2])%4) != 0) && (D1[1] == 2) && (D1[0] == 29)){
		return false
	}

	validDate = new Date(D1[2],D1[1]-1,D1[0]);
	//if(D1[2] >=1900 && D1[2] <=1999)D1[2] =
	D2[0] = validDate.getDate();
	D2[1] = validDate.getMonth()+1;
	D2[2] = validDate.getFullYear();

	//alert(D1[2] +"="+D2[2]);
	strDate = D1.join();
	strDate2 = D2.join();
	if (strDate == strDate2){
		if(checkCurrent){
			var currentDate = new Date();
			var D3 = new Array();
			D3[0] = currentDate.getDate();
			D3[1] = currentDate.getMonth();
			D3[2] = currentDate.getFullYear();
			if(D2[2] > D3[2])return false;
			if(D2[2] >= D3[2] && D2[1] > D3[1])return false;
			return !(D2[2] >= D3[2] && D2[1] >= D3[1] && D2[0] > D3[0]);

		}else return true;
	}else return false;
}

function dateToDb(date,lang,separator){
	if(lang == "undefined")lang=0;
	var D1 = new Array()	;
	if(separator == "undefined")separator = '/';
	if (separator == '' || separator == null)separator = '/';
	var rg = new RegExp(separator,"gi")
	var date=date.replace(rg,"");
	if (date=="") return "";
	//D1 = date.split(separator);
	D1[0] = parseFloat(date.substr(0,2));
	D1[1] = parseFloat(date.substr(2,2));
	D1[2] = parseFloat(date.substr(4,8));
	switch(lang){
		case 0:
			if(D1[2] >2400)D1[2]-=543;break;
		case 1:
			if(D1[2] <=2400)D1[2]+=543;break;
		default:
			D1[2]=D1[2];
			break;
	}

	var day = D1[0].toString();
	var month = D1[1].toString();
	var year = D1[2].toString();

	if(day.length <=1)day = "0" + day;
	if(month.length <= 1)month = "0" + month;
	while(year.length < 4) year = "0" + year;
	if(year.length > 4)year = year.substr(0,4);
	return year + month +day;
}

function dateToScreen(date) //format date  คือ yyyymmdd
{
    var day;
    var month;
    var year;
    if (date=="") return "";
    day=date.substr(6,8);
    month=date.substr(4,2);
    year=date.substr(0,4);
    return day+"/"+month+"/"+year;
}

function isPIN(strPIN){
    strPIN=strPIN.replace(/-/gi,"");
    if(strPIN.length != 13){
//        alert('Invalid PIN Number');
        return false;
    }
    if(strPIN=="0000000000000")return true;

    var count_j = 0 , digit;
    var cal = new Number();
    for (var count_i = 13; count_i > 1; count_i-- , count_j++){
        digit = parseFloat(strPIN.charAt(count_j)) * count_i;
        cal += digit;
    }
    digit = 11 - (cal % 11);

    var strDigit = digit.toString();
    var chrDigit = strDigit.charAt(strDigit.length-1);
    if (strPIN.charAt(12) == chrDigit){
        return true;
    }else{
//        alert('Invalid PIN Number');
        return false;
    }
}

function isTIN(strTIN){
    strTIN=strTIN.replace(/-/gi,"");
    if(strTIN.length != 10){
//        alert('Invalid TIN Number');
        return false;
    }

    if(strTIN=="0000000000")return true;
    var digit;
    var cal = new Number();
    for (var count_i = 0; count_i  < 9; count_i += 2){
        digit = parseFloat(strTIN.charAt(count_i)) * 3;
        cal += digit;
        digit = parseFloat(strTIN.charAt(count_i+1)) * 1;
        if(count_i !=8)cal  += digit;
    }
    var str = cal.toString();
    digit = 10 - parseFloat(str.charAt(str.length-1));
    strDigit = digit.toString();
    if(strDigit.charAt(strDigit.length-1) == strTIN.charAt(9)){
        return true;
    }else{
//        alert('Invalid TIN Number');
        return false;
    }
}


function showCalendar
(
    ao_element	,	// Date element
    av_lang			// 0 is Eng, 1 is Thai
){
    //cmUtil.setMethodMsg( "xp_EdaCom_Calendar" );
    try{
        var lo_element	= ao_element;
        var lv_lang			= av_lang;

        if ( lv_lang == "0" ){
            lv_lang	=	"English";
        }else{
            lv_lang	=	"Thai";
        }

        window.dateField	=	lo_element;
        window.language		=	lv_lang;
        calendar = window.open ('inc/calendar.jsp','cal','WIDTH=300,HEIGHT=260,MAXIMIZE=0,minimize=no');
    }catch(e){
        //return cmUtil.showMsgBoxReturnValue( gv_EdaCom_msg_E01, false );
    }
}

function isChecked(objForm){
    var returnValue=false;
    if (objForm.length==null){
      if (objForm.checked) returnValue=true;
    }else{
        for(i=0;i<objForm.length;i++){
            if(objForm[i].checked){
                returnValue=true;
                break;
            }
        }
    }
    return returnValue
}

function showMsg(icode,iopt,iumsg,ipara){
        if(icode==undefined) icode=0;
        if(iopt==undefined) iopt=0;
        if(iumsg==undefined) iumsg="";
        if(ipara==undefined) ipara="";

    try{
        return window.showModalDialog("showMsg.jsp?p1="+icode+"&p2="+iopt+"&p3="+iumsg+"&p4="+ipara,0,"dialogWidth:500px;dialogHeight:280px;center:yes");
    }catch(e){
        if(iopt == 1){
            return confirm(iumsg);
        }else{
            return alert(iumsg);
        }
    }
}

function cdateToDB(date){
    var rg = new RegExp("/","gi")
	date=date.replace(rg,"");

    return date.substr(4,8)+date.substr(2,4)+date.substr(0,2);
}
function monthThai(monthIndex) {
	var monthDisplay1 = "";
	
	switch ( monthIndex ) {
	  case 1:monthDisplay1 = lc_Jan;
	                break;
	  case 2:monthDisplay1 = lc_Feb;
	                break;
	  case 3 : monthDisplay1 = lc_Mar;
	                break;
	  case 4 : monthDisplay1 = lc_Apr;
	                break;
	  case 5 : monthDisplay1 = lc_May;
	                break;
	  case 6 : monthDisplay1 = lc_Jun;
	                break;
	  case 7 : monthDisplay1 = lc_Jul;
	                break;
	  case 8: monthDisplay1 = lc_Aug;
	                break;
	  case 9 : monthDisplay1 = lc_Sep;
	                break;
	  case 10:  monthDisplay1 = lc_Oct;
	                break;
	  case 11:	monthDisplay1 = lc_Nov;
	                break;
	  case 12:	monthDisplay1 = lc_Dec;
	                break;
	  default :	monthDisplay1 = lc_not_define;
	                break;
	}
    return monthDisplay1;
}
function monthEng(monthIndex) {
	var monthDisplay1 = "";
	
	switch ( monthIndex ) {
	  case 1:monthDisplay1 = "January";
	                break;
	  case 2:monthDisplay1 = "Febuary";
	                break;
	  case 3 : monthDisplay1 = "March";
	                break;
	  case 4 : monthDisplay1 = "April";
	                break;
	  case 5 : monthDisplay1 = "May";
	                break;
	  case 6 : monthDisplay1 = "June";
	                break;
	  case 7 : monthDisplay1 = "July";
	                break;
	  case 8: monthDisplay1 = "August";
	                break;
	  case 9 : monthDisplay1 = "September";
	                break;
	  case 10:  monthDisplay1 = "October";
	                break;
	  case 11:	monthDisplay1 = "November";
	                break;
	  case 12:	monthDisplay1 = "December";
	                break;
	  default :	monthDisplay1 = "Not Define";
	                break;
	}
    return monthDisplay1;
}
function displayFullDateThai( strDateValue ) {
	if( strDateValue == "" ){
        return "";
    }
    var intYear  = parseInt( strDateValue.substring( 0 , 4 ), 10 );
    var intMonth = parseInt( strDateValue.substring( 4 , 6 ), 10 );
    var intDate  = parseInt( strDateValue.substring( 6 , 8 ), 10 );

    if( intYear < 2500 ){
        intYear += 543;
    }

    var strYear  = intYear;
    var strMonth = monthThai( intMonth );
    var strDate  = intDate;

    return strDate + " " + strMonth + " " + strYear;
}

function displayFullDateEng( strDateValue ) {
	if( strDateValue == "" ){
        return "";
    }
    var intYear  = parseInt( strDateValue.substring( 0 , 4 ), 10 );
    var intMonth = parseInt( strDateValue.substring( 4 , 6 ), 10 );
    var intDate  = parseInt( strDateValue.substring( 6 , 8 ), 10 );

    if( intYear > 2500 ){
        intYear -= 543;
    }

    var strYear  = intYear;
    var strMonth = monthThai( intMonth );
    var strDate  = intDate;

    return strDate + " " + strMonth + " " + strYear;
}

function lp_new_window( av_name ) {
    return window.open( "",av_name,"width="+ screen.availWidth +"px,height="+ screen.availHeight +"px,status=yes,top=0,left=0,toolsbar=no");
}

function getCurrentTime(){
    var now     = new Date(); 
    var hour    = now.getHours();
    var minute  = now.getMinutes();
    var second  = now.getSeconds(); 
    
    if(hour.toString().length == 1) {
        var hour = '0'+hour;
    }
    if(minute.toString().length == 1) {
        var minute = '0'+minute;
    }
    if(second.toString().length == 1) {
        var second = '0'+second;
    }   
    var time = hour+':'+minute+':'+second;   
     return time;
}

function hg_noprint(){return true};