function set_background(screen_name){
    
    var header_height = 0;
    var abs_height = 0;
    var browser = check_browser();
    
    if (browser == "FIREFOX"){//Firefox
	header_height = 40;
    }else if (browser == "CHROME"){//Chrome
	header_height = 20;
    }else if(browser == "SAFARI"){//Safari
	header_height = 10;
    }else if(browser == "OPERA"){//Opera
	header_height = 10;
    }else if(browser == "IE"){//IE
	header_height = 0;
    }else{
        header_height = 0;
    }
    
    $("#" + screen_name).css({
        'width' : "100%",
        'margin' : "0",
        'border' : "0",
        'overflow' : "auto"
    });
    
    abs_height = document.documentElement.clientHeight - header_height;

    $("#" + screen_name).css('height',abs_height) ;
}

function getDocHeight() {
    var D = document;
//    alert("D.body.scrollHeight : " + D.body.scrollHeight + "\n"
//            + "D.documentElement.scrollHeight : " + D.documentElement.scrollHeight + "\n"
//            + "D.body.offsetHeight : " + D.body.offsetHeight + "\n"
//            + "D.documentElement.offsetHeight : " + D.documentElement.offsetHeight + "\n"
//            + "D.body.clientHeight : " + D.body.clientHeight + "\n"
//            + "D.documentElement.clientHeight : " + D.documentElement.clientHeight            );
    return Math.max(
        D.body.scrollHeight, D.documentElement.scrollHeight,
        D.body.offsetHeight, D.documentElement.offsetHeight,
        D.body.clientHeight, D.documentElement.clientHeight
    );
}

function check_browser(){
    var browser_name = "";
    
    if(!!window.opera || navigator.userAgent.indexOf(' OPR/') >= 0){
        // Opera 8.0+ (UA detection to detect Blink/v8-powered Opera)
        browser_name = "OPERA";
    }else if(typeof InstallTrigger !== 'undefined'){
        // Firefox 1.0+
        browser_name = "FIREFOX";
    }else if(Object.prototype.toString.call(window.HTMLElement).indexOf('Constructor') > 0){
        // At least Safari 3+: "[object HTMLElementConstructor]"
        browser_name = "SAFARI";
    }else if(!!window.chrome && !(!!window.opera || navigator.userAgent.indexOf(' OPR/') >= 0)){
        // Chrome 1+
        browser_name = "CHROME";
    }else if(/*@cc_on!@*/false || !!document.documentMode){
        // At least IE6
        browser_name = "IE";
    }
 
    return browser_name;

}

function set_contents(content_name){
    
    var header_height = 0;
    var abs_height = 0;
    var browser = check_browser();
    
    if (browser == "FIREFOX"){//Firefox
	header_height = 40;
    }else if (browser == "CHROME"){//Chrome
	header_height = 20;
    }else if(browser == "SAFARI"){//Safari
	header_height = 10;
    }else if(browser == "OPERA"){//Opera
	header_height = 10;
    }else if(browser == "IE"){//IE
	header_height = 150;
    }else{
        header_height = 0;
    }
    
    $("#" + content_name).css({
        'width' : "100%",
        'margin' : "0",
        'border' : "0",
        'overflow' : "auto"
    });
    
    abs_height = document.documentElement.clientHeight - header_height;
    
    $("#" + content_name).css('height',abs_height) ;
}