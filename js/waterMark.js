function waterMark(){

	this.setWaterMark = gm_setWaterMark;
	
	function gm_setWaterMark( av_flag, av_username, av_date, av_time ){

		var port = document.location.port;
		if(port == ""){
			port = "80";
		}
		
		var lv_image_file = "http://" + document.location.hostname + ":" + port + "/edas420/watermark/06.bmp";
		var lv_all_text	  = "";
		var lv_wm_flag	  = "";
		
		if(av_flag == ""){
			av_flag = "N";
		}
		
		if(av_username){
			lv_all_text = av_username;
		}
		if(av_date){
			lv_all_text += " " + av_date;
		}
		if(av_time){
			lv_all_text += " " + av_time;
		}
		
		switch( av_flag ){
			case "P" :
					lv_wm_flag = "Print";
					break;
			case "V" :
					lv_wm_flag = "Retrieve";
					break;
			case "A" :
					lv_wm_flag = "All";
					break;
			case "N" :
					lv_wm_flag = "None";
					break;
		}
		
		if(lv_wm_flag != 'None'){
		
                    var	lv_xml 	= "<?xml version=\"1.0\" encoding=\"TIS-620\"?>"
					+	"<INET-OBJECT>"
					+	"<ITEXT name=\"IDEPT02\">"
					+	"<MERGEPCTHI>30</MERGEPCTHI>"
					+	"<MERGEPCTLO>5</MERGEPCTLO>"
					+	"<MERGESTYLE>9</MERGESTYLE>"
					+	"<MERGESIZE>3</MERGESIZE>"
					+	"<IMAGE>"
					+			"<IMAGEFILE>" + lv_image_file + "</IMAGEFILE>"
					+			"<LINES>"
					+				"<LINE x=\"5\" y=\"32\" fname=\"CordiaUPC\" fsize=\"18\" pcolor=\"0\">" + av_username + "</LINE>"
					+				"<LINE x=\"5\" y=\"60\" fname=\"CordiaUPC\" fsize=\"18\" pcolor=\"0\"> " + av_date + "</LINE>"
					+			"</LINES>"
					+	"</IMAGE>"
					+	"<TRANSPARENT>0</TRANSPARENT>"
					+	"<PROCESSMODE>" + lv_wm_flag + "</PROCESSMODE>"
					+	"<IPBITSPIXEL>24</IPBITSPIXEL>"
					+	"<ORGINX>3</ORGINX>"
					+	"<ORGINY>0</ORGINY>"
					+	"<ROTATE>45</ROTATE>"
					+	"<AREAWIDTH>-1</AREAWIDTH>"
					+	"<AREAHIGHT>-1</AREAHIGHT>"
					+	"</ITEXT>"
					+	"</INET-OBJECT>";
				   	
				   	
			inetdocview.SetProperty( "ITEXT_XML" , lv_xml );
		}
		
//		inetdocview.Retrieve( av_blob, av_part );
	}
}
