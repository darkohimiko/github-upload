var global_field;
var check_click = false;


function key_press_fx(objField , call_func){
    check_click = true;
    $("#" + objField.name).keypress(function(e){
        var key_code = e.charCode? e.charCode : e.keyCode;
        if(key_code==13){
        
            if(check_click == true){
                eval(call_func + "();");
                check_click = false;
                return;
            }
        }
    });
}

function key_press(objField){
    var arr_field;
    var focus_field;
    var next_field;
    var field_idx = 0;
    var field_size = 0;
    var key_code;
    
    $("#" + objField.name).keyup(function(e){
        key_code = e.charCode? e.charCode : e.keyCode;
        if(key_code==13){
            if(global_field != null){
                arr_field = global_field.split(",");
                field_size = arr_field.length;
            }else{
                return;
            }

            for(var idx=0;idx<field_size;idx++){
                if(objField.name == arr_field[idx]){
                    field_idx = idx;
                    break;
                }
            }

            if(field_idx == (field_size-1)){
                return;
            }

            focus_field = $("#"+arr_field[field_idx]);
            next_field = $("#"+arr_field[field_idx+1]);
            if(!next_field){
                focus_field.focus();
                return;
            }else{
                next_field.focus();
                return;
            }
        }
    });
}

function keypress_number(event){
    var carCode = event.charCode? event.charCode : event.keyCode;
    if ((carCode < 48) || (carCode > 57)){
        if( event.preventDefault ){
            event.preventDefault();
        }else{
            event.returnValue = false;
        }
        return;
    }
}

function keypress_ip(event){
    var carCode = event.charCode? event.charCode : event.keyCode;
    if ((carCode < 48) || (carCode > 57)){
        if(carCode != 46) {
            if( event.preventDefault ){
                event.preventDefault();
            }else{
                event.returnValue = false;
            }
            return;
        }
    }
}

function checked_keypress(event){
    var lv_key_code = event.charCode? event.charCode : event.keyCode;
    var lb_is_int   = ( lv_key_code >= 48 && lv_key_code <= 57 );
    var lb_is_eng   = ( lv_key_code >= 65 && lv_key_code <= 90  ) || ( lv_key_code >= 97 && lv_key_code <= 122 );
    var lb_is_extra = ( lv_key_code == 45 || lv_key_code == 95 );

    if( !( lb_is_int || lb_is_eng || lb_is_extra ) ){
        if( event.preventDefault ){
            event.preventDefault();
        }else{
            event.returnValue = false;
        }
        return;
    }
}