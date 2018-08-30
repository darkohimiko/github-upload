function offlineUtils(){

	this.EBS_SNAME = "OFFLINE_CONTROL";
	this.EBS_ANAME = "EDAS420";
	this.EBS_MNAME = "registerOffline";
	this.EBS_PROJECT_CODE;
	this.EBS_BATCH_NO;
	this.EBS_DOCUMENT_RUNNING;
	this.EBS_DOCUMENT_TYPE;
	this.EBS_REQ_DATE;
	this.EBS_REQ_USER;
	this.EBS_ADD_DATE;
	this.EBS_ADD_USER;
	this.EBS_UPD_USER;
	
	this.setOfflineCtrl = gm_setOfflineCtrl;
	
	function gm_setOfflineCtrl(lv_projectCode, lv_userId, lv_currentDate, lv_batchNo, lv_documentRunning, lv_documentType ){
		this.EBS_PROJECT_CODE	  = lv_projectCode;
		this.EBS_BATCH_NO 	 	  = lv_batchNo;
		this.EBS_DOCUMENT_RUNNING = lv_documentRunning;
		this.EBS_DOCUMENT_TYPE 	  = lv_documentType;
		this.EBS_REQ_DATE		  = lv_currentDate;
		this.EBS_REQ_USER		  = lv_userId;
		this.EBS_ADD_DATE		  = lv_currentDate;
		this.EBS_ADD_USER 		  = lv_userId;
		this.EBS_UPD_USER 		  = lv_userId;
		
		inetdocview.SetProperty( "EBS_SNAME", this.EBS_SNAME );
		inetdocview.SetProperty( "EBS_ANAME", this.EBS_ANAME );
		inetdocview.SetProperty( "EBS_MNAME", this.EBS_MNAME );
		inetdocview.SetProperty( "EBS_PROJECT_CODE", this.EBS_PROJECT_CODE );
		inetdocview.SetProperty( "EBS_BATCH_NO", this.EBS_BATCH_NO );
		inetdocview.SetProperty( "EBS_DOCUMENT_RUNNING", this.EBS_DOCUMENT_RUNNING );
		inetdocview.SetProperty( "EBS_DOCUMENT_TYPE", this.EBS_DOCUMENT_TYPE );
		inetdocview.SetProperty( "EBS_REQ_DATE", this.EBS_REQ_DATE );
		inetdocview.SetProperty( "EBS_REQ_USER", this.EBS_REQ_USER );
		inetdocview.SetProperty( "EBS_ADD_DATE", this.EBS_ADD_DATE );
		inetdocview.SetProperty( "EBS_ADD_USER", this.EBS_ADD_USER );
		inetdocview.SetProperty( "EBS_UPD_USER", this.EBS_UPD_USER );
	}
}