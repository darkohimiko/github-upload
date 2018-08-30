
var objZoomWindow;

function open_zoom_table( type, result_fields ) {
    var strPopArgument      = "scrollbars=yes,status=no";
    var strWidth            = ",width=370px";
    var strHeight           = ",height=420px";
    var strUrl              = "";
    var strConcatField      = "";

    strPopArgument += strWidth + strHeight;

    switch( type ){
        case "1" :
            strUrl = "inc/zoom_table_level1.jsp";
            strConcatField = "RESULT_FIELD=" + result_fields;
            break;
        case "2" :
            strUrl = "inc/zoom_table_level2.jsp";
            strConcatField = "RESULT_FIELD=" + result_fields;
            break;
    }

    objZoomWindow = window.open( strUrl + "?" + strConcatField, type, strPopArgument );
    objZoomWindow.focus();
}

function open_zoom_data_lv1( type, label, dsp_field, hid_field, call_func ){
    var strPopArgument 	= "scrollbars=yes,status=no";
    var strWidth 	= ",width=370px";
    var strHeight 	= ",height=400px";
    var strUrl          = "inc/zoom_data_table_level1.jsp";
    var strConcatField  = "TABLE=" + type;
    strConcatField += "&TABLE_LABEL=" + label;
    strConcatField += "&RESULT_FIELD=" + dsp_field + "," + hid_field;
    
    if(call_func){
        strConcatField += "&CALL_FUNC=" + call_func;
    }
    
    strPopArgument += strWidth + strHeight;						

    objZoomWindow = window.open( strUrl + "?" + strConcatField , "zm" + type , strPopArgument );
    objZoomWindow.focus();
}

function open_zoom_data_lv2( type, label, dsp_field, hid_field, call_func ){
    var strPopArgument 	= "scrollbars=yes,status=no";
    var strWidth 	= ",width=370px";
    var strHeight 	= ",height=400px";
    var strUrl          = "inc/zoom_data_table_level2.jsp";
    var strConcatField  = "TABLE=" + type;
    strConcatField += "&TABLE_LABEL=" + label;
    strConcatField += "&TABLE_LV1=" + tableLevel1Key + "&TABLE_LV1_CODE=" + form1.txtTableLevel1.value;
    strConcatField += "&TABLE_LV1_LABEL=" + tableLevel1NameKey + "&TABLE_LV1_NAME=" + form1.txtTableLevel1Name.value;
    strConcatField += "&RESULT_FIELD=" + dsp_field + "," + hid_field;
    
    if(call_func){
        strConcatField += "&CALL_FUNC=" + call_func;
    }
    
    strPopArgument += strWidth + strHeight;						

    objZoomWindow = window.open( strUrl + "?" + strConcatField , "zm" + type , strPopArgument );
    objZoomWindow.focus();
}

function openZoom( strZoomType ) {
	var strPopArgument      = "scrollbars=yes,status=no";
	var strWidth            = ",width=370px";
	var strHeight           = ",height=420px";
	var strUrl              = "";
	var strConcatField      = "";

	strPopArgument += strWidth + strHeight;

	switch( strZoomType ){
		case "level1" :
				strUrl = "inc/zoom_data_table_level1.jsp";
				strConcatField = "TABLE="+ tableLevel1Key + "&TABLE_LABEL=" + tableLevel1NameKey;
				strConcatField += "&RESULT_FIELD=txtTableLevel1,txtTableLevel1Name";
				if( tableLevel == "2" ) {
					strConcatField += "&CALL_FUNC=refreshData";
				}
				break;
		case "level2" :
				if( form1.txtTableLevel1.value.length == 0 ) {
					alert( lc_can_not_choose_data );
					return;
				}
				strUrl = "inc/zoom_data_table_level2.jsp";
				strConcatField = "TABLE=" + tableLevel2Key + "&TABLE_LABEL=" + tableLevel2NameKey;
				strConcatField += "&TABLE_LV1=" + tableLevel1Key + "&TABLE_LV1_CODE=" + form1.txtTableLevel1.value;
				strConcatField += "&TABLE_LV1_LABEL=" + tableLevel1NameKey + "&TABLE_LV1_NAME=" + form1.txtTableLevel1Name.value;
				strConcatField += "&RESULT_FIELD=txtTableLevel2,txtTableLevel2Name";
				strConcatField += "&CALL_FUNC=refreshData";
				break;
	}

	objZoomWindow = window.open( strUrl + "?" + strConcatField, strZoomType, strPopArgument );
	objZoomWindow.focus();
}

function close_zoom_popup(){
    
    if(objZoomWindow != null && objZoomWindow.closed){
        objZoomWindow.close();
    }
}