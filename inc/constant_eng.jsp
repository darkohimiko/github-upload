
<%@ page contentType="text/html; charset=tis-620"%>
<%!
String strContainerName = "EDAS420";

String lc_system_name = "Electronic Document Administration System";

String lc_update_edas_detail1 = "System requires Internet Explorer 6.0 or higher";

String lc_update_edas_detail2 = " Last update ";

String lc_update_edas_detail3 = "4.2.0";

String lc_update_edas_detail4 = "01/11/2553";

String lc_site_name = " EDAS";

String lc_zoom_table_level1 = "Reference Tables Level 1";

String lc_zoom_table_level2 = "Reference Tables Level 2";

String lc_fulltext_search = "Y";

String  lc_update = "Modify";

String  lc_administrator_menu = "System Administration";

String  lc_admin = "Administrator";

String  lc_Jan = "January";

String  lc_Feb = "February";

String  lc_Mar = "March";

String  lc_Apr = "April";

String  lc_May = "May";

String  lc_Jun = "June";

String  lc_Jul = "July";

String  lc_Aug = "August";

String  lc_Sep = "September";

String  lc_Oct = "October";

String  lc_Nov = "November";

String  lc_Dec = "December";

String  lc_not_define = "No specify";

String  lc_insert_data = "Save Document";

String  lc_update_data = "Modify Document";

String  lc_delete_data = "Delete Document";

String  lc_search_data = "Search Document";

String  lc_import_data = "Import";

String  lc_export_data = "Export/ Copied";

String  lc_modImg = "Add image / Attached file";

String  lc_prnImg = "Print image / Export attached file";

String  lc_delImg = "Delete image / Attached file";

String  lc_censor = "Create Censor Zone";

String  lc_anot = "Create Annotation and Note";

String  lc_link = "Document-link";

//************ Process User ********************//

String  lc_not_found_this_user = "Please review user name / password";

String  lc_cannot_login = "Cannot Access in this System";

String  lc_password_expired_in = "Your password will be expired within ";

String  lc_day = " Day(s) ";

String  lc_please_change_password = "Please change your password immediately";

String  lc_confirm_message = "Your user name is expired ";

String  lc_user_cannot_update = "This user name cannot change password";

String	lc_user_pass_not_correct = "User name and password are incorrect";

String	lc_success_change_password = "Password has been changed";

//************* Admin Menu ************************//

String  lc_administrator = "Administration";

String  lc_import_export = "Import / Export";

String  lc_report_export = "Report and Statistics";

String  lc_system 		 = "System Configuration";

String  lc_basic_table 	 = "Reference Tables";

String  lc_user_role	 = "User Role Configuration";

String  lc_search_level	 = "Document Level";

String  lc_user			 = "User Configuration";

String  lc_user_gruop    = "User Group Configuration";

String  lc_carbinet		 = "Cabinet Configuration";

String  lc_news		     = "News Configuration";

String  lc_faq		     = "FAQ Configuration";

String  lc_recall_expire_doc   = "Purge Document";

String  lc_total_doc_report = "Total Document Storage Summary Report";

String  lc_doc_report = "Document Storage Summary Report";

String  lc_used_stat_report = "Usage Statistics Summary Report";

String  lc_user_status_report = "User Status Report";

String  lc_admin_activity = "Administration Report";

String  lc_admin_right_report = "User Right Report";

//******** System Config ******************//

String  lc_can_not_update_data 		= "Cannot modify data";

String  lc_update_data_successfull 	= "Data has been modified successful";

String  lc_can_not_delete_data 		= "Table in used cannot delete";

String  lc_delete_data_successfull 	= "Data has been deleted";

String  lc_can_not_add_data 		= "Cannot add data";

String  lc_add_data_successfull 	= "Data has been added";

String  lc_can_not_delete_data_2	= "Cannot delete data";

//******** Document Type ******************//

String  lc_data_not_found 					= "No data found";

String  lc_can_not_insert_document_type 	= "Cannot add new document type";

String  lc_insert_document_type_successfull = "New document type has been added";

String  lc_can_not_edit_document_type 		= "Cannot modify document type";

String  lc_edit_document_type_successfull 	= "Document type has been modified";

String  lc_delete_data_successful 			= "Deletion is complete";

String	lc_cannot_delete_document_type		= "Cannot delete document type";			

String  lc_doc_have_used_files 				= "There are data of this document type, cannot be deleted";

//******** Zoom Table Manager ******************//

String lc_system_table_dup                = "Cannot add new data, the reference table is existed";

String lc_can_not_insert_system_table     = "Cannot add new data to this table";

String lc_insert_system_table_successfull = "New data has been added successful";

String lc_edit_system_table_successfull   = "This table has been modified successful";

String lc_can_not_delete_detail           = "Can not delete data (Inused)";

//********** Import Data *********************//

String  lc_total_size_full  = "Space is full, cannot save data";

//******** User Role ******************//

String lc_can_not_insert_user_role     = "Cannot add new user role";

String lc_insert_user_role_successfull = "New user role has been added successful";

String lc_edit_user_role_successfull   = "User role has been modified successful";

//******** User Level ******************//

String lc_user_level_dup                = "Cannot add new document level, document level is existed";

String lc_can_not_insert_user_level     = "Cannot add new document level";

String lc_insert_user_level_successfull = "New document level  has been added successful";

String lc_edit_user_level_successfull   = "Document level has been modified successful";

//******** User Profile ******************//

String lc_user_profile_dup                = "Cannot add this user, user name is existed";

String lc_can_not_insert_user_profile     = "Cannot add new user";

String lc_insert_user_profile_successfull = "New user has been added successful";

String lc_edit_user_profile_successfull   = "User has been modified successful";

//******** Project Manager ******************//

String lc_project_manager_cannot_delete_used = "Cabinet contains document, cannot be deleted";

String lc_project_manager_cannot_delete      = "Cannot delete data";

String lc_can_not_insert_project_manager     = "Cannot assign new user";

String lc_insert_project_manager_successfull = "New user has been assigned";

String lc_edit_project_manager_successfull   = "User has been modified successful";

String lc_delete_project_manager_successfull = "Deletion is complete";

String lc_attachment = "Attach File";

//*********** Edit Document ******************//

String	lc_delete_document = "Cannot delete this document type";

String	lc_cannot_check_in = "Cannot check-in this document";

String	lc_cannot_check_out = "Cannot check-out this document";

String	lc_cannot_delete_document = "Cannot delete this document";

String	lc_delete_document_success = "Document deletion is complete";

//*********** Master Link ******************//

String	lc_data_deleted = "Data has been deleted";

String	lc_cannot_save_data_link = "Cannot create document-link";

String	lc_save_data_link_success = "Document-link has been created successful";

String	lc_data_link = "Document-link";

//*********** Field Manager ******************//

String lc_field_manager_dup                = "Cannot add document-index, document-index is existed";

String lc_can_not_insert_field_manager     = "Cannot add new document-index";

String lc_can_not_update_field_manager     = "Cannot modify document-index";

String lc_can_not_delete_field_manager     = "Cannot delete document-index(Inused)";

String lc_can_not_update_contact_admin     = "Cannot modify document-index, please contact admin";

String lc_insert_field_manager_successfull = "New document-index has been added successful";

String lc_edit_field_manager_successfull   = "Document-index has been modified successful";

String lc_can_not_set_field_manager        = "Cannot set search-index";

String lc_can_not_set_field_manager_too_long = "Cannot set search-index cause maximum key length exceeded";

String lc_set_field_manager_successfull    = "Search index has been set successful";

//*********** Box Manage *********************//

String	lc_can_not_insert_box_manage = "Cannot create new box";

String	lc_insert_box_manage_successful = "New box has been created successful";

String	lc_cannot_edit_box_manage = "Cannot modify box property";

String	lc_edit_box_manage_successful = "Box property has been modified successful";

String	lc_cannot_add_data_box = "Cannot add new item to this box";

String	lc_add_data_box_successful = "New item has been added to this box successful";

//************** Detail Scan *********************//
String	lc_user_level_access_denied = "Cannot view this document";

//*********** Form Builder ******************//
String lc_form_builder_dup                = "Unable to add form, Form duplicate";

String lc_can_not_insert_form_builder     = "Cannot add new form";

String lc_can_not_update_form_builder     = "Cannot modify form property";

String lc_can_not_delete_form_builder     = "Cannot delete this form";

String lc_insert_form_builder_successfull = "New form has been added successful";

String lc_edit_form_builder_successfull   = "Form has been modified successful";

String lc_delete_form_builder_successfull = "Form deletion is complete";

//*********** Import Data ******************//
String lc_new_document = "New Document";

String lc_edit_delete_document = "Modify/Delete Document";

//----------edas ver.4.0.2-----------------//
String	lc_permit_user_successful = "Permit users to access successful.";

String	lc_cannot_permit_user = "Cannot permit users";

String	lc_cancel_permit_user_successful = "Cancel permit users successful";

String	lc_cannot_cancel_permit_user = "Cannot cancel permit users";

String	lc_search_permit_user = "Find user";

String	lc_permit_user = "Select users";

//*********** News Manager ******************//

String lc_can_not_insert_news     = "Cannot add this news";

String lc_can_not_update_news     = "Cannot modify this news";

String lc_can_not_delete_news     = "Cannot delete this news";

String lc_insert_news_successfull = "This news has been added successful";

String lc_edit_news_successfull   = "This news has been modified successful";

String lc_delete_news_successfull = "This news deletion is complete";

//*********** Faq Manager ******************//

String lc_can_not_insert_faq     = "Cannot add this faq";

String lc_can_not_update_faq     = "Cannot modify this faq";

String lc_can_not_delete_faq     = "Cannot delete this faq";

String lc_insert_faq_successfull = "This faq has been added successful";

String lc_edit_faq_successfull   = "This faq has been modified successful";

String lc_delete_faq_successfull = "This faq deletion is complete";

//*********** User Group ******************//

String lc_can_not_delete_group = "This group contain user, cannot delete";

//*********** Policy Agent ******************//

String strAdminUsername = "apluser";

String strAdminPassword = "rtyhgf";

//*********** Export XML Field Manager ******************//

String lc_export_xml_successfull = "ส่งออกข้อมูลโครงสร้างตู้เก็บเอกสารเรียบร้อยแล้ว";

String lc_import_xml_successfull = "นำเข้าข้อมูลโครงสร้างตู้เก็บเอกสารเรียบร้อยแล้ว";

%>