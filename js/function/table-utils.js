
var totalPage = 0;
var mode      = "";
var obj_current_page;
var obj_form;
var obj_mode;
var obj_sortfield;
var obj_sortby;

function set_field_table(){
    obj_current_page = $("#form1 #CURRENT_PAGE");
    obj_mode         = $("#form1 #MODE");
    obj_sortfield    = $("#form1 #sortfield");
    obj_sortby       = $("#form1 #sortby");
    obj_form         = $("#form1");
}

function sort_search( lv_sortType, lv_sort ) {
    
    if( mode == "SEARCH" ) {
        obj_mode.val("SEARCH");
    }else {
        obj_mode.val("FIND");
    }

    obj_sortfield.val(lv_sort);
    obj_sortby.val(lv_sortType);
    obj_form.submit();
}

function navigator_click(lv_direct) {
    var lv_intCurrPage  = parseInt( obj_current_page.val() );
    var lv_intTotalPage = totalPage;

    if( lv_intTotalPage == null ) {
        lv_intTotalPage = 0;
    }
    
    switch( lv_direct ){
        case "first" :
            if( lv_intCurrPage == 1 ) {
                return false;
            }
            lv_intCurrPage = 1;
            break;
        case "previous" :
            if( lv_intCurrPage == 1 ) {
                return false;
            }
            lv_intCurrPage--;
            break;
        case "next" :
            if( lv_intCurrPage == lv_intTotalPage ) {
                return false;
            }
            lv_intCurrPage++;
            break;
        case "last" :
            if( lv_intCurrPage == lv_intTotalPage ) {
                return false;
            }
            lv_intCurrPage = lv_intTotalPage;
            break;
    }
    obj_current_page.val(lv_intCurrPage);
    obj_form.submit();
}

function change_result_per_page(){
    obj_current_page.val(1);
    obj_form.submit();	
}