function imageTemplate(){

	this.EBSSZONE_ANAME 			= "EDAS412";   
	this.EBSSZONE_SNAME				= "IMAGE_TEMPLATE";
	this.EBSSZONE_MFINDNAME			= "loadTemplate";
	this.EBSSZONE_MADDUPDATENAME	= "saveTemplate";
	this.EBS_PROJECT_CODE			= "";
	this.EBS_DOCUMENT_TYPE			= "";
	this.EBS_TEMPLATE_TYPE			= "";
	
	this.setImageTemplate = gm_setImageTemplate;
	
	function gm_setImageTemplate(av_project_code, av_document_type, av_template_type){
		
		inetdocview.SetProperty( "EBSSZONE_ANAME", 			this.EBSSZONE_ANAME );
		inetdocview.SetProperty( "EBSSZONE_SNAME", 			this.EBSSZONE_SNAME );
		inetdocview.SetProperty( "EBSSZONE_MFINDNAME", 		this.EBSSZONE_MFINDNAME );
		inetdocview.SetProperty( "EBSSZONE_MADDUPDATENAME", this.EBSSZONE_MADDUPDATENAME );
		inetdocview.SetProperty( "EBS_PROJECT_CODE", 		av_project_code );
		inetdocview.SetProperty( "EBS_DOCUMENT_TYPE", 		av_document_type );
		inetdocview.SetProperty( "EBS_TEMPLATE_TYPE", 		av_template_type );
	}
}

function hg_noprint(){return true};