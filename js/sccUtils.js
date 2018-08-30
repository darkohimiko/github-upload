function SCUtils(){
	var av_strPermission = "";
	var av_strRemoveToolBar = "";
	var av_printScreenProtect = "false";
	var av_ontop = "false";
	var av_importSingle = "false";
	var av_censor = false;
	
	this.CENSOR = av_censor;

	this.isPIN = gm_bolnIsPIN;
	this.isTIN = gm_bolnIsTIN;

	this.maskTIN = gm_strMaskTin;
	this.maskPIN = gm_strMaskPin;
	this.maskDLN = gm_strMaskDln;

	this.unMask = gm_strUnMask;

	this.trim = gm_strTrim;
	this.makeString = gm_strMakeString;
	this.placeString = gm_strPlaceString;
	this.replaceString = gm_strReplaceString;

	this.isEnter = gm_bolnIsEnter;

	this.showCalendar = gm_voidShowCalendar;
	this.openChildWindow = gm_objOpenChildWindow;
	this.openPopWindow = gm_objOpenPopWindow;


	this.getDate = gm_strGetDate; /// return 25460101 [currentDate or inputDate]
	this.getTodayDate = gm_strGetTodayDate; /// return 25460101 [currentDate]
	this.getTodayDateDisplay =gm_strGetTodayDateDisplay; // return 01/01/2546 [ currentDate]
	this.dateToDb = gm_strDateToDb; /// 01/01/2546 --> 25460101
	this.dateToDisplay = gm_strDateToDisplay; /// 25460101 --> 01/01/2546
	this.formatDate = gm_strFormatDate; /// 01012546 --> 01/01/2546
        this.formatDateEng = gm_strFormatDateEng; /// 01012546 --> 01/01/2003
        this.unFormatDate = gm_strUnFormatDate;
	this.isDateValid = gm_strIsDateValid;


	this.setEasImagePermission = gm_voidSetEasImagePermission;
	this.showEasImage = gm_voidShowEasImage;
    this.showEasImageService = gm_voidShowEasImageService;
    this.showEasImageHilight = gm_voidShowEasImageHilightService;
    this.editEasImage = gm_voidEditEasImage;
    this.editEasImageResize = gm_voidEditEasImageResize;



	function lm_strSetMask( lv_strValue , lv_arrCutNumber , lv_strCharacterMask ){
		if( lv_strValue.length == 0 ){
			return "";
		}
		var lv_strMasked = "" , lv_intSumArrayValue = 0 , lv_intBeginIndex = 0;
		for( var lv_intCountArray = lv_arrCutNumber.length - 1 ; lv_intCountArray >= 0 ; lv_intCountArray-- ){
			lv_intSumArrayValue += lv_arrCutNumber[ lv_intCountArray ];
			lv_intBeginIndex = lv_strValue.length - lv_intSumArrayValue;
			lv_strMasked = lv_strCharacterMask + lv_strValue.substr( lv_intBeginIndex , lv_arrCutNumber[ lv_intCountArray ] ) + lv_strMasked;
		}

		lv_strMasked = lv_strMasked.substr( 1 );

		return lv_strMasked;
	}




	function gm_bolnIsPIN( lv_strPIN , lv_bolnZeroPass ){
		if(lv_strPIN.length != 13){
			alert("เลขประจำตัวประชาชนไม่ถูกต้อง");
			return false;
		}
		if( isNaN( lv_strPIN ) ){
			alert("เลขประจำตัวประชาชน ต้องเป็นตัวเลขเท่านั้น");
			return false;
		}
		if( lv_bolnZeroPass == null ){
			lv_bolnZeroPass = false;
		}
		if( lv_strPIN == gm_strMakeString( "0" , 13 ) ){
			if( !lv_bolnZeroPass ){
				alert("เลขประจำตัวประชาชนต้องไม่เป็นศูนย์ (0)");
			}
			return lv_bolnZeroPass;
		}
		var lv_arrCancelPIN = new Array();
		lv_arrCancelPIN[ 0 ] = gm_strMakeString( "1" , 12 ) + "9";
		lv_arrCancelPIN[ 1 ] = "1" + gm_strMakeString( "0" , 11 ) + "9";

		for( var lv_idx in lv_arrCancelPIN ){
			if( lv_strPIN == lv_arrCancelPIN[ lv_idx ] ){
				alert( "ไม่อนุญาตให้กรอกเลขประจำตัวประชาชนนี้ [" + gm_strMaskPin( lv_arrCancelPIN[ lv_idx ] ) + "]" );
				return false;
			}
		}

		var lv_intCount_j = 0 , lv_intDigit;
		var lv_intCal = new Number();
		for( var lv_intCount_i = 13 ; lv_intCount_i > 1; lv_intCount_i-- , lv_intCount_j++ ){
			lv_intDigit = parseFloat( lv_strPIN.charAt( lv_intCount_j ) ) * lv_intCount_i;
			lv_intCal += lv_intDigit;
		}
		lv_intDigit = 11 - ( lv_intCal % 11 );
		var lv_strDigit = lv_intDigit.toString();
		var lv_chrDigit = lv_strDigit.charAt( lv_strDigit.length - 1 );
		
		if ( lv_strPIN.charAt(12) == lv_chrDigit ){
			return true;
		}else{
			alert("เลขประจำตัวประชาชนไม่ถูกต้อง ตามหลักการตรวจสอบเลข");
			return false;
		}
	}

	
	function gm_bolnIsTIN( lv_strTIN , lv_bolnZeroPass ){
		if(lv_strTIN.length != 10){
			alert("เลขประจำตัวผู้เสียภาษีไม่ถูกต้อง");
			return false;
		}
		if( isNaN( lv_strTIN ) ){
			alert("เลขประจำตัวผู้เสียภาษี ต้องเป็นตัวเลขเท่านั้น");
			return false;
		}
		if( lv_bolnZeroPass == null ){
			lv_bolnZeroPass = false;
		}
		if( lv_strTIN == gm_strMakeString( "0" , 10 ) ){
			if( !lv_bolnZeroPass ){
				alert("เลขประจำตัวผู้เสียภาษีต้องไม่เป็นศูนย์ (0)");
			}
			return lv_bolnZeroPass;
		}
		var lv_intDigit;
		var lv_intCal = new Number();
		for( var lv_intCount_i = 0 ; lv_intCount_i  < 9 ; lv_intCount_i += 2 ){
			lv_intDigit = parseFloat( lv_strTIN.charAt( lv_intCount_i ) ) * 3;
			lv_intCal += lv_intDigit;
			lv_intDigit = parseFloat( lv_strTIN.charAt( lv_intCount_i + 1 ) ) * 1;
			if( lv_intCount_i != 8 ){
				lv_intCal  += lv_intDigit;
			}
		}
		var lv_strCal = lv_intCal.toString();
		lv_intDigit = 10 - parseFloat( lv_strCal.charAt( lv_strCal.length - 1 ) );
		var lv_strDigit = lv_intDigit.toString();
		if( lv_strDigit.charAt( lv_strDigit.length - 1 ) == lv_strTIN.charAt( 9 ) ){
			return true;
		}else{
			alert("เลขประจำตัวผู้เสียภาษีไม่ถูกต้อง ตามหลักการตรวจสอบเลข");
			return false;
		}
	}

	function gm_strMaskTin( lv_strTIN ){
		var lv_arrTin = Array(1,8,1);
		var lv_intValueLength = eval( lv_arrTin.join( "+" ) );
		if( lv_strTIN.length > 5 ){
			lv_strTIN = gm_strPlaceString( lv_strTIN , "X" , lv_intValueLength );
		}else{
			return lv_strTIN;
		}
		return gm_strReplaceString( lm_strSetMask( lv_strTIN , lv_arrTin , "-" ) , "X" , "" );
	}

	function gm_strMaskPin( lv_strPIN ){
		var lv_arrPin = Array( 1 , 4 , 5 , 2 , 1 );
		var lv_intValueLength = eval( lv_arrPin.join( "+" ) );
		if( lv_strPIN.length > 5 ){
			lv_strPIN = gm_strPlaceString( lv_strPIN , "X" , lv_intValueLength );
		}else{
			return lv_strPIN;
		}
		return gm_strReplaceString( lm_strSetMask( lv_strPIN , lv_arrPin , "-" ) , "X" , "" );
	}
        
        function gm_strMaskDln( lv_strDLN ){
		var lv_arrDln = Array( 8 , 8 , 1 , 2 , 8 , 1 , 1 , 4 , 2 );
		var lv_intValueLength = eval( lv_arrDln.join( "+" ) );
		if( lv_strDLN.length > 9 ){
			lv_strDLN = gm_strPlaceString( lv_strDLN , "X" , lv_intValueLength );
		}else{
			return lv_strDLN;
		}
		return gm_strReplaceString( lm_strSetMask( lv_strDLN , lv_arrDln , "-" ) , "X" , "" );
	}


	function gm_strUnMask( lv_strValue ){
		return gm_strReplaceString( lv_strValue , "-" , "" );
	}


    function gm_strTrim( lv_strValue ){
		lv_strValue = lv_strValue.toString();
		var lv_intPrefix , lv_intSuffix;
		for( lv_intPrefix = 0 ; lv_intPrefix < lv_strValue.length && lv_strValue.charAt( lv_intPrefix ) == ' ' ; lv_intPrefix++ ){}
		for( lv_intSuffix = lv_strValue.length - 1 ; lv_intSuffix >= 0 && lv_strValue.charAt( lv_intSuffix )== ' ' ; lv_intSuffix-- ){}
		if( lv_intPrefix > lv_intSuffix ){
			return "";
		}else{
			return lv_strValue.substring( lv_intPrefix , lv_intSuffix + 1 );
		}
	}

	function gm_strMakeString( lv_strCharacter , lv_intLength ){
		var lv_strSameCharacter = "";
		while( lv_strSameCharacter.length < lv_intLength ){
			lv_strSameCharacter += lv_strCharacter;
		}
		return lv_strSameCharacter;
	}

	function gm_strPlaceString( lv_strValue , lv_strPlace , lv_intLength , lv_strAlign ){
		if( lv_strValue.length >= lv_intLength || lv_strPlace == null){
			return lv_strValue;
		}
		var lv_strReturn = "";
		if( lv_strAlign == null ){
			lv_strAlign = "LEFT";
		}
		lv_strReturn = gm_strMakeString( lv_strPlace , lv_intLength - lv_strValue.length );
		switch( lv_strAlign.toUpperCase() ){
			case "LEFT" :
					lv_strReturn += lv_strValue;
					break;
			case "RIGHT" :
					lv_strReturn = lv_strValue + lv_strReturn;
					break;
		}
		return lv_strReturn;
	}

	function gm_strReplaceString( lv_strValue , lv_strFind , lv_strReplace , lv_strAlign ){
		lv_strValue = lv_strValue.toString();
		if( lv_strAlign == null ){
			lv_strAlign = "ALL";
		}
		switch( lv_strAlign.toUpperCase() ){
			case "CENTER" : 
			case "ALL" :
					while( lv_strValue.indexOf( lv_strFind ) != -1 ){
						lv_strValue = lv_strValue.replace( lv_strFind , lv_strReplace );
					}
					break;
			case "LEFT" :
					while( lv_strValue.indexOf( lv_strFind ) == 0 ){
						lv_strValue = lv_strValue.replace( lv_strFind , lv_strReplace );
					}
					break;
			case "RIGHT" :
					lv_strValue = gm_strReverseString( lv_strValue );
					lv_strValue = gm_strReplaceString( lv_strValue , lv_strFind , lv_strReplace , "LEFT" );
					lv_strValue = gm_strReverseString( lv_strValue );
					break;
		}
		return lv_strValue;
	}



	function gm_bolnIsEnter(){
		if( window.event.keyCode ==13 ){
			return true;
		}else{
			return false;
		}
	}



	function gm_voidShowCalendar( lv_objField , lv_strLang ){
		if( lv_strLang == "0" ){
			lv_strLang = "English";
		}else{
			lv_strLang = "Thai";
		}

		window.dateField = lv_objField;
		window.language = lv_strLang;

		var lv_objCalendar = window.open( "inc/calendar.html" , "calendarWin" , "width=220,height=260" );
	}

	function gm_objOpenChildWindow( lv_strWindowName ){
		var lv_intWinWidth = window.screen.width;
		var lv_intWinHeight = window.screen.height;

		var lv_intChildWidth = lv_intWinWidth - 10;
		var lv_intChildHeight = lv_intWinHeight - 60;

		var lv_intWinLeft = lv_intWinTop = 0;

		return window.open( "" , lv_strWindowName , "width=" + lv_intChildWidth + " ,height=" + lv_intChildHeight + " ,resizable=yes,scrollbars=yes,top=" + lv_intWinTop +",left=" + lv_intWinLeft );
	}

	function gm_objOpenPopWindow( lv_strUrl , lv_strWindowName , lv_strWidth , lv_strHeight ){
		var lv_intWinWidth = window.screen.width;
		var lv_intWinHeight = window.screen.height;

		//var lv_intWinLeft = ( lv_intWinWidth - parseInt( lv_strWidth ) ) / 2;
		//var lv_intWinTop = ( lv_intWinHeight - parseInt( lv_strHeight ) ) / 2;
		
		var lv_intWinLeft = 50;
		var lv_intWinTop  = 100;

		return window.open( lv_strUrl , lv_strWindowName , "width=" + lv_strWidth + " ,height=" + lv_strHeight + " ,scrollbars=yes,top=" + lv_intWinTop +",left=" + lv_intWinLeft );
	}


	function gm_strGetDate( lv_strDate){
		var lv_objDate = new Date();
		if( lv_strDate != null ){
			lv_strDate = gm_strReplaceString( lv_strDate , "/" , "" );
			var lv_intYear = parseFloat( lv_strDate.substr( 4 , 4 ) ) - 543;
			var lv_intMonth = parseFloat( lv_strDate.substr( 2 , 2 ) ) - 1;
			var lv_intDay = parseFloat( lv_strDate.substr( 0 , 2 ) );
			lv_objDate = new Date( lv_intYear , lv_intMonth , lv_intDay );
		}
		var lv_strDateReturn = "";
		var lv_strDayReturn = lv_objDate.getDate().toString();
		var lv_strMonthReturn = ( lv_objDate.getMonth() +1 ).toString();
		var lv_strYearReturn = lv_objDate.getFullYear();

		lv_strDayReturn = gm_strPlaceString( lv_strDayReturn , "0" , 2 );
		lv_strMonthReturn = gm_strPlaceString( lv_strMonthReturn , "0" , 2 );
		if(lv_strYearReturn < 2400){
			lv_strYearReturn += 543;
		}

		lv_strDateReturn = lv_strYearReturn + lv_strMonthReturn + lv_strDayReturn;

		return lv_strDateReturn;
	}

	function gm_strGetTodayDate(){
		return gm_strGetDate();
	}
	function gm_strGetTodayDateDisplay(){
		return gm_strDateToDisplay( gm_strGetTodayDate() );
	}

	function gm_strDateToDb( lv_strDate ){
		lv_strDate = gm_strReplaceString( lv_strDate , "/" , "" );
		return lv_strDate.substr( 4 , 4 ) + lv_strDate.substr( 2 , 2 ) + lv_strDate.substr( 0 , 2 );
	}

	function gm_strDateToDisplay( lv_strDate ){
            if(lv_strDate == ""){
                return "";
            }
		lv_strDate = gm_strReplaceString( lv_strDate , "/" , "" );
		return lv_strDate.substr( 6 , 2 ) + "/" + lv_strDate.substr( 4 , 2 ) + "/" + lv_strDate.substr( 0 , 4 );
	}

	function gm_strFormatDate( lv_strDate ){
		lv_strDate = gm_strReplaceString( lv_strDate , "/" , "" );
		return lv_strDate.substr( 0 , 2 ) + "/" + lv_strDate.substr( 2 , 2 ) + "/" + lv_strDate.substr( 4 , 4 );
	}
        
        function gm_strFormatDateEng( lv_strDate ){
		lv_strDate = gm_strReplaceString( lv_strDate , "/" , "" );
                var year = lv_strDate.substr( 4 , 4 );
                if(parseInt(year, 10) > 2500 ){
                    year = parseInt(year, 10) - 543;
                }                
		return lv_strDate.substr( 0 , 2 ) + "/" + lv_strDate.substr( 2 , 2 ) + "/" + year;
	}
        
        function gm_strUnFormatDate( lv_strDate ){
		lv_strDate = gm_strReplaceString( lv_strDate , "/" , "" );
		return lv_strDate;
	}

	function gm_strIsDateValid( lv_strDate , lv_bolnNotAfterToday ){
		var lv_strDateCompare = gm_strGetDate( lv_strDate );
		var lv_strDateInput = gm_strDateToDb( lv_strDate );
		if( lv_strDateInput != lv_strDateCompare ){
			return "INVALID_DATE";
		}
		if( lv_bolnNotAfterToday == null ){
			return "VALID_DATE";
		}
		if( lv_bolnNotAfterToday ){
			var lv_strTodayDateCompare = gm_strGetTodayDate();
			if( lv_strDateInput > lv_strTodayDateCompare ){
				return "AFTER_TODAY";
			}
		}
		return "BEFORE_TODAY";
	}



	function gm_voidSetEasImagePermission( strPermission ){
		av_strPermission = strPermission;
		av_strRemoveToolBar = "";

		if( av_strPermission.indexOf( "modImg" ) == -1 ){
//			av_strRemoveToolBar += "saveImageToServer,";
//			av_strRemoveToolBar += "Open File,Scan,";
			av_strRemoveToolBar += "Open File Ctrl+O,Scan Ctrl+A,";
		}
		if( av_strPermission.indexOf( "delImg" ) == -1 ){
			av_strRemoveToolBar += "deleteImage,";
		}
		if(( av_strPermission.indexOf( "delImg" ) == -1 ) && ( av_strPermission.indexOf( "modImg" ) == -1 )){
			av_strRemoveToolBar += "saveImageToServer,";
		}
		if( av_strPermission.indexOf( "prnImg" ) == -1 ){
			av_strRemoveToolBar += "printImage,selectForPrint,Save Image Change,";
		}
		if( av_strPermission.indexOf( "censor" ) == -1 && av_strPermission.indexOf( "anot" ) == -1 ){
			av_strRemoveToolBar += "Annotation,";
		}else if( av_strPermission.indexOf( "censor" ) == -1 ){
			av_strRemoveToolBar += "Annotation.Sensor Zone,";
		}else  if( av_strPermission.indexOf( "anot" ) == -1 ){
			av_strRemoveToolBar += "Annotation.Notation,";
		}
//		alert( av_strRemoveToolBar );
	}



	function gm_voidShowEasImage( lv_strBlobID , lv_strBlobNumber , lv_strUserLevel , lv_strContainType){
		var lv_strUrl = document.location.protocol + "//" + document.location.host ;
        gm_voidShowEasImageService(lv_strBlobID , lv_strBlobNumber , lv_strUrl, lv_strUserLevel , lv_strContainType);
//		alert( lv_strUrl );

		/*if( lv_strBlobID == null || lv_strBlobID == "" ){
			return;
		}   */

//		alert( lv_strBlobID + "\n" + lv_strBlobNumber );


		
	}

    function gm_voidShowEasImageService( lv_strBlobID , lv_strBlobNumber ,lv_serverUrl, lv_strUserLevel , lv_strContainType  ){
            var lv_strUrl = lv_serverUrl  + "/easinetimage/imageproxy";
    		//alert( lv_strUrl );

            /*if( lv_strBlobID == null || lv_strBlobID == "" ){
                return;
            }   */

    //		alert( lv_strBlobID + "\n" + lv_strBlobNumber );
	


            inetdocview.Resize(310, 0, 1024, 738);	// screen size
			inetdocview.Setproperty("AlwaysOnTop",av_ontop);
			inetdocview.Setproperty("RemoveToolBar",av_strRemoveToolBar);
//			inetdocview.Setproperty("RemoveToolBar","selectForPrint");
			inetdocview.Setproperty("Monitor",  av_printScreenProtect); 
			
			inetdocview.Setproperty("UnRemoveToolBar","Menu.Sign Document");
			inetdocview.Setproperty("UnRemoveToolBar","Menu.View.Facing");
			
            inetdocview.Open();
//            inetdocview.Setproperty("BDVersion","2.00.00");
            inetdocview.Url  = lv_strUrl;


            //inetdocview.containerType = "FCS";
			inetdocview.ContainerType(lv_strContainType);

            inetdocview.InternalAnnotation = 1;
//			inetdocview.UserLevel = lv_strUserLevel;
			inetdocview.UserLevel(lv_strUserLevel);
            //inetdocview.ViewMode = 2031615;
            inetdocview.ViewMode  = 2244735; //View Only
            //inetdocview.ViewMode  = 1122175;
    //       if(!(lv_strBlobID == null || lv_strBlobID == "" )){
                    //inetdocview.Retrieve( lv_strBlobID, parseInt( lv_strBlobNumber ) );
    //		}


        }

    function gm_voidShowEasImageHilightService( lv_strHiOraBlob , lv_strBlobNumber, lv_strUserLevel  ){
/*
		lv_strHiOraBlob = [BlobID]@[OraBlob]@[Enquery]

		OraBlob  =  [ProjectCode].[Batchno].[DocumentRunning].[DocumentType]
		Enquery  =  Base64( [searchword] )
*/
			var lv_strUrl = document.location.protocol + "//" + document.location.host ;
           lv_strUrl = lv_strUrl  + "/easinetimage/imageproxy";


            inetdocview.Resize(310, 0, 1024, 738);	// screen size
			inetdocview.Setproperty("AlwaysOnTop",av_ontop);
			inetdocview.Setproperty("RemoveToolBar",av_strRemoveToolBar);
			inetdocview.Setproperty("Monitor",  av_printScreenProtect);
            inetdocview.Open();
//            inetdocview.Setproperty("BDVersion","2.00.00");
            inetdocview.Url  = lv_strUrl;


			inetdocview.ContainerType("ORAFCS");

            inetdocview.InternalAnnotation = 1;

			inetdocview.UserLevel(lv_strUserLevel);

            inetdocview.ViewMode  = 2244735; //View Only

            inetdocview.Retrieve( lv_strHiOraBlob, parseInt( lv_strBlobNumber ) );
        }


    function gm_voidEditEasImage( lv_strBlobID , lv_strBlobNumber , lv_strContainerType ){
            var lv_strUrl = document.location.protocol + "//" + document.location.host + "/easinetimage/imageproxy";
    //		alert( lv_strUrl );

            /*if( lv_strBlobID == null || lv_strBlobID == "" ){
                return;
            }   */

    //		alert( lv_strBlobID + "\n" + lv_strBlobNumber );

            inetdocview.Resize(310, 0, 1024, 738);	// screen size
			inetdocview.Setproperty("AlwaysOnTop",av_ontop);
			inetdocview.Setproperty("RemoveToolBar",av_strRemoveToolBar);
//			inetdocview.Setproperty("RemoveToolBar","selectForPrint"); 
			inetdocview.Setproperty("Monitor",  av_printScreenProtect);
			
			inetdocview.Setproperty("UnRemoveToolBar","Menu.Sign Document");
			inetdocview.Setproperty("UnRemoveToolBar","Menu.View.Facing");
			
            inetdocview.Open();
//            inetdocview.Setproperty("BDVersion","2.00.00");
            inetdocview.Url  = lv_strUrl;


            //inetdocview.containerType = "FCS";
			inetdocview.ContainerType(lv_strContainerType);

            inetdocview.InternalAnnotation = 1;
			inetdocview.ViewMode  = 2097151;
            //inetdocview.ViewMode = 2031615;
            //inetdocview.ViewMode  = 1580927; //View Only
           if(!(lv_strBlobID == null || lv_strBlobID == "" )){
                    inetdocview.Retrieve( lv_strBlobID, parseInt( lv_strBlobNumber ) );
            }else{
                    inetdocview.Clear();
			}


   }


    function gm_voidEditEasImageResize( lv_strBlobID , lv_strBlobNumber , lv_objSize , lv_strContainerType ){
            var lv_strUrl = document.location.protocol + "//" + document.location.host + "/easinetimage/imageproxy";

            inetdocview.Resize( lv_objSize.x1 , lv_objSize.y1 , lv_objSize.x2 , lv_objSize.y2 );	// screen size
			inetdocview.Setproperty("AlwaysOnTop",av_ontop);
			inetdocview.Setproperty("RemoveToolBar",av_strRemoveToolBar);
//			inetdocview.Setproperty("RemoveToolBar","selectForPrint");

			inetdocview.Url  = lv_strUrl; 
			inetdocview.Setproperty("Monitor",  av_printScreenProtect);
            
            inetdocview.Open();

            inetdocview.Setproperty("ImportSingle",  av_importSingle);
//            inetdocview.Setproperty("BDVersion","2.00.00");
			inetdocview.Setproperty("UnRemoveToolBar","Menu.Sign Document");
			inetdocview.Setproperty("UnRemoveToolBar","Menu.View.Facing");
			inetdocview.Setproperty("UnRemoveToolBar","Save.Send Mail...");
//			inetdocview.Setproperty("UnRemoveToolBar","Menu.OCR");
//            inetdocview.Setproperty("OCRUrl","http://172.17.2.73:88/freninge");   //    for test
            
            inetdocview.Url  = lv_strUrl;


            //inetdocview.containerType = "FCS";
			inetdocview.ContainerType( lv_strContainerType );

            inetdocview.InternalAnnotation = 1;
			inetdocview.ViewMode  = 2097151;
            //inetdocview.ViewMode = 2031615;
            //inetdocview.ViewMode  = 1580927; //View Only
           if(!(lv_strBlobID == null || lv_strBlobID == "" )){
                    inetdocview.Retrieve( lv_strBlobID, parseInt( lv_strBlobNumber ) );
            }else{
                    inetdocview.Clear();
			}


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


}