
<%@ page contentType="text/html; charset=tis-620"%>
<%!
String strContainerName = "EDAS420";

String lc_system_name = "�к������èѴ����͡�������硷�͹ԡ��";

String lc_update_edas_detail1 = "�к���ҹ��Ѻ Internet Explorer 10.0 ���� �����ѹ ";

String lc_update_edas_detail2 = " ��Ѻ��ا����ش ";

String lc_update_edas_detail3 = "4.2.0";

String lc_update_edas_detail4 = "4/7/2559";

String lc_port_jackrabbit = "8081";

String lc_site_name = " EDAS";

String lc_zoom_table_level1 = "���ҧ��Ҥ�����дѺ 1";

String lc_zoom_table_level2 = "���ҧ��Ҥ�����дѺ 2";

String lc_fulltext_search = "Y";

String  lc_update = "���";

String  lc_administrator_menu = "�����к�";

String  lc_admin = "�������к�";

String  lc_Jan = "���Ҥ�";
//String  lc_Jan = "�.�.";

String  lc_Feb = "����Ҿѹ��";
//String  lc_Feb = "�.�.";

String  lc_Mar = "�չҤ�";
//String  lc_Mar = "��.�.";

String  lc_Apr = "����¹";
//String  lc_Apr = "��.�.";

String  lc_May = "����Ҥ�";
//String  lc_May = "�.�.";

String  lc_Jun = "�Զع�¹";
//String  lc_Jun = "��.�.";

String  lc_Jul = "�á�Ҥ�";
//String  lc_Jul = "�.�.";

String  lc_Aug = "�ԧ�Ҥ�";
//String  lc_Aug = "�.�.";

String  lc_Sep = "�ѹ��¹";
//String  lc_Sep = "�.�.";

String  lc_Oct = "���Ҥ�";
//String  lc_Oct = "�.�.";

String  lc_Nov = "��Ȩԡ�¹";
//String  lc_Nov = "�.�.";

String  lc_Dec = "�ѹ�Ҥ�";

String  lc_not_define = "����к�";

String  lc_insert_data = "�ѹ�֡�͡���";

String  lc_update_data = "����͡���";

String  lc_delete_data = "ź�͡���";

String  lc_search_data = "�׺���͡���";

String  lc_import_data = "������͡���";

String  lc_export_data = "���͡�͡���/ �������͡���";

String  lc_modImg = "�����Ҿ / �͡���Ṻ";

String  lc_prnImg = "������Ҿ / ���͡�͡���Ṻ";

String  lc_delImg = "ź�Ҿ / �͡���Ṻ";

String  lc_censor = "���ҧ Censor Zone";

String  lc_anot = "���ҧ Annotation ��� Note";

String  lc_link = "������§�͡���";

//************ Process User ********************//

String  lc_not_found_this_user = "��سҵ�Ǩ�ͺ���ʼ����/���ʼ�ҹ����";

String  lc_cannot_login = "��س�������к���������ͧ����� ip address ����˹��������Ѻ��ҹ��ҹ�� ���͵Դ��ͼ������к�";

String  lc_password_expired_in = "���ʼ�ҹ�ͧ��ҹ������������� ";

String  lc_day = " �ѹ ";

String  lc_please_change_password = "�ô����¹���ʼ�ҹ�ѹ��";

String  lc_confirm_message = "���ʼ����ͧ��ҹ������ء����ҹ ";

String  lc_user_cannot_update = "���ʼ������������Է�������¹���ʼ�ҹ��";

String	lc_user_pass_not_correct = "���ʼ����/���ʼ�ҹ���١��ͧ";

String	lc_success_change_password = "����¹���ʼ�ҹ���º��������";

//************* Admin Menu ************************//

String  lc_administrator = "�����к�";

String  lc_import_export = "����� / ���͡";

String  lc_report_export = "��§ҹ���ʶԵ�";

String  lc_system 		 = "��駤���к�";

String  lc_basic_table 	 = "���ҧ��Ҥ�����к�";

String  lc_user_role	 = "�Ѵ��ú��ҷ��÷ӧҹ";

String  lc_search_level	 = "�Ѵ����дѺ�͡���";

String  lc_user			 = "�Ѵ��ü����ҹ";

String  lc_user_gruop    = "�Ѵ��á���������ҹ";

String  lc_carbinet		 = "�Ѵ��õ�����͡���";

String  lc_news		     = "�Ѵ��â��ǻ�Ъ�����ѹ��";

String  lc_faq		     = "�Ѵ��� FAQ";

String  lc_recall_expire_doc   = "�֧�׹�͡��÷���������";

String  lc_total_doc_report = "��§ҹ��ػ�ʹ�����èѴ���͡���";

String  lc_doc_report = "��§ҹ��ػ��èѴ���͡���";

String  lc_used_stat_report = "��§ҹ��ػʶԵԡ����ҹ�к�";

String  lc_user_status_report = "��§ҹʶҹм����ҹ";

String  lc_admin_activity = "��§ҹ��ô��Թ�ҹ�ͧ�������к�";

String  lc_admin_right_report = "��§ҹ����������Է���㹡����ҹ������͡���";

//******** System Config ******************//

String  lc_can_not_update_data 		= "�������ö��䢢�������";

String  lc_update_data_successfull 	= "��䢢��������º��������";

String  lc_can_not_delete_data 		= "�������öź�����Ź����";

String  lc_cannot_delete_table_had_used = "�ա����ҹ���ҧ����������öź��";

String  lc_cannot_delete_other_used_table = "�յ��ҧ�дѺ�����ҹ���ҧ����������öź��";

String  lc_delete_data_successfull 	= "ź���������º��������";

String  lc_can_not_add_data 		= "�������ö������������";

String  lc_add_data_successfull 	= "�������������º��������";

String  lc_can_not_delete_data_2	= "�������öź��������";

//******** Document Type ******************//

String  lc_data_not_found 					= "��辺�����ŷ���ͧ��ä���";

String  lc_can_not_insert_document_type 	= "�������ö�����������͡�����";

String  lc_insert_document_type_successfull = "�����������͡������º��������";

String  lc_can_not_edit_document_type 		= "�������ö��䢻������͡�����";

String  lc_edit_document_type_successfull 	= "��䢻������͡������º��������";

String  lc_delete_data_successful 			= "ź���������º��������";

String	lc_cannot_delete_document_type		= "�������öź�������͡��ù����";			

String  lc_doc_have_used_files 				= "�բ����Ż������͡��ù����к� �������öź��";

//******** Zoom Table Manager ******************//

String lc_system_table_dup                = "�������ö������������ ���ͧ�ҡ�յ��ҧ��Ҥ����������к�";

String lc_can_not_insert_system_table     = "�������ö���������ŵ��ҧ��";

String lc_insert_system_table_successfull = "�������ҧ���º��������";

String lc_edit_system_table_successfull   = "��䢢����ŵ��ҧ���º��������";

String lc_delete_system_table_successfull   = "ź���ҧ���º��������";

String lc_cannot_delete_system_table   = "�������öź���ҧ��";

String lc_can_not_delete_detail           = "�������öź�����������ͧ�ҡ�ա����ҹ";

//********** Import Data *********************//

String  lc_total_size_full  = "���ͷ��㹡���红�������� �������ö�ѹ�֡��������";

//******** User Role ******************//

String lc_can_not_insert_user_role     = "�������ö�������ҷ��÷ӧҹ��";

String lc_insert_user_role_successfull = "�������ҷ��÷ӧҹ���º��������";

String lc_edit_user_role_successfull   = "��䢺��ҷ��÷ӧҹ���º��������";

//******** User Level ******************//

String lc_user_level_dup                = "�������ö�����дѺ�͡����� ���ͧ�ҡ���дѺ�͡���������к�";

String lc_can_not_insert_user_level     = "�������ö�����дѺ�͡�����";

String lc_insert_user_level_successfull = "�����дѺ�͡������º��������";

String lc_edit_user_level_successfull   = "����дѺ�͡������º��������";

//******** User Profile ******************//

String lc_user_profile_dup                = "�������ö���������ҹ�� ���ͧ�ҡ�ռ����ҹ������к�";

String lc_can_not_insert_user_profile     = "�������ö���������ҹ��";

String lc_insert_user_profile_successfull = "���������ҹ���º��������";

String lc_edit_user_profile_successfull   = "��䢼����ҹ���º��������";

String lc_can_not_delete_user_profile     = "�������öź�����ҹ��";

String lc_delete_user_profile_successfull = "ź�����ҹ���º��������";

//******** Project Manager ******************//

String lc_project_manager_cannot_delete_used = "���͡�������㹵�����͡��ù�� �������öź��";

String lc_project_manager_cannot_delete      = "�������öź����͡�����";

String lc_can_not_insert_project_manager     = "�������ö��������͡�����";

String lc_can_not_edit_project_manager     = "�������ö��䢵���͡�����";

String lc_insert_project_manager_successfull = "��������͡������º��������";

String lc_edit_project_manager_successfull   = "��䢵���͡������º��������";

String lc_delete_project_manager_successfull = "ź����͡������º��������";

String lc_attachment = "�͡���Ṻ";

//*********** Edit Document ******************//

String	lc_delete_document = "�������öź�������͡�����";

String	lc_cannot_check_in = "�������ö���Թ�͡�����";

String	lc_cannot_check_out = "�������ö�����ҷ��͡�����";

String	lc_cannot_delete_document = "�������öź�͡�����";

String	lc_delete_document_success = "ź�͡������º��������";

//*********** Master Link ******************//

String	lc_data_deleted = "�����Ŷ١ź�����";

String	lc_cannot_save_data_link = "�������ö�ѹ�֡�͡���������§��";

String	lc_save_data_link_success = "�ѹ�֡�͡���������§���º��������";

String	lc_data_link = "�͡���������§";

//*********** Field Manager ******************//

String lc_field_manager_dup                = "�������ö�����Ѫ���͡����� ���ͧ�ҡ�մѪ���͡��ù��������к�";

String lc_can_not_insert_field_manager     = "�������ö�����Ѫ���͡�����";

String lc_can_not_delete_field_manager     = "�ա����ҹ�Ѫ���͡��� �������öź��";

String lc_can_not_update_field_manager     = "�������ö��䢴Ѫ���͡�����";

String lc_can_not_update_contact_admin     = "�������ö��䢴Ѫ���͡����� ��سҵԴ��ͼ������к�";

String lc_insert_field_manager_successfull = "�����Ѫ���͡������º��������";

String lc_edit_field_manager_successfull   = "��䢢����ŴѪ���͡������º��������";

String lc_can_not_set_field_manager        = "�������ö�練Ѫ�ա���׺����";

String lc_can_not_set_field_manager_too_long = "�������ö�練Ѫ�ա���׺�������ͧ�ҡ��������Թ��Ҵ";

String lc_set_field_manager_successfull    = "�練Ѫ�ա���׺�����º��������";

//*********** Box Manage *********************//

String	lc_can_not_insert_box_manage = "�������ö�������ͧ������";

String	lc_insert_box_manage_successful = "�������ͧ�������º��������";

String	lc_cannot_edit_box_manage = "�������ö��䢡��ͧ��";

String	lc_edit_box_manage_successful = "��䢡��ͧ���º��������";

String	lc_cannot_add_data_box = "�������ö������¡��㹡��ͧ��";

String	lc_add_data_box_successful = "������¡��㹡��ͧ���º��������";

String  lc_box_have_used_files 	= "�բ�������¡��㹡��ͧ �������öź��������";

String  lc_delete_box_successful = "ź���ͧ���º��������";

//************** Detail Scan *********************//
String	lc_user_level_access_denied = "��ҹ������Է�Դ��͡��ù��";

//*********** Form Builder ******************//
String lc_form_builder_dup                = "�������ö����������� ���ͧ�ҡ�տ�������������к�";

String lc_can_not_insert_form_builder     = "�������ö�����������";

String lc_can_not_update_form_builder     = "�������ö��䢿������";

String lc_can_not_delete_form_builder     = "�������öź�������";

String lc_insert_form_builder_successfull = "������������º��������";

String lc_edit_form_builder_successfull   = "��䢢����ſ�������º��������";

String lc_delete_form_builder_successfull = "ź�����ſ�������º��������";

//*********** Import Data ******************//
String lc_new_document = "�͡�������";

String lc_edit_delete_document = "���������� / ź�͡���";

//----------edas ver.4.0.2-----------------//
String	lc_permit_user_successful = "����Է�Լ�������º��������";

String	lc_cannot_permit_user = "�������ö����Է�Լ������";

String	lc_cancel_permit_user_successful = "¡��ԡ�������Է�Լ�������º��������";

String	lc_cannot_cancel_permit_user = "�������ö¡��ԡ�������Է�Լ������";

String	lc_search_permit_user = "���Ҽ����";

String	lc_permit_user = "�кؼ����";

//*********** News Manager ******************//

String lc_can_not_insert_news     = "�������ö�������ǻ�Ъ�����ѹ����";

String lc_can_not_update_news     = "�������ö��䢢��ǻ�Ъ�����ѹ����";

String lc_can_not_delete_news     = "�������öź���ǻ�Ъ�����ѹ����";

String lc_insert_news_successfull = "�������ǻ�Ъ�����ѹ�����º��������";

String lc_edit_news_successfull   = "��䢢����Ţ��ǻ�Ъ�����ѹ�����º��������";

String lc_delete_news_successfull = "ź�����Ţ��ǻ�Ъ�����ѹ�����º��������";

//*********** Faq Manager ******************//

String lc_can_not_insert_faq     = "�������ö�����Ӷ��-�ͺ��";

String lc_can_not_update_faq     = "�������ö��䢤Ӷ��-�ͺ��";

String lc_can_not_delete_faq     = "�������öź�Ӷ��-�ͺ��";

String lc_insert_faq_successfull = "�����Ӷ��-�ͺ���º��������";

String lc_edit_faq_successfull   = "��䢢����ŤӶ��-�ͺ���º��������";

String lc_delete_faq_successfull = "ź�����ŤӶ��-�ͺ���º��������";

//*********** User Group ******************//

String lc_can_not_delete_group = "�������öź����������ҹ ���ͧ�ҡ�ѧ�ռ����ҹ����㹡����";

//*********** Policy Agent ******************//

String strAdminUsername = "apluser";

String strAdminPassword = "rtyhgf";

//*********** Export XML Field Manager ******************//

String lc_export_xml_successfull = "���͡�������ç���ҧ������͡������º��������";

String lc_import_xml_successfull = "����Ң������ç���ҧ������͡������º��������";

//************ Move Document ****************//

String lc_project_target_title = "���͡������͡��û��·ҧ";


//************** Update**********************//

String lc_not_set_search_field = "����ա�á�˹���Ŵ��׺�� ��س��кط������ \"�Ѵ��ôѪ���͡���\"";

String lc_not_set_report_field = "����ա�á�˹���Ŵ���§ҹ ��س��кط������ \"�Ѵ��ôѪ���͡���\"";

String lc_not_set_link_field = "����ա�á�˹���Ŵ�������§ ��س��кط������ \"�Ѵ��ôѪ���͡���\"";

String lc_not_set_log_field = "����ա�á�˹���Ŵ�log ��س��кط������ \"�Ѵ��ôѪ���͡���\"";

String lc_not_set_index_field = "����ա�á�˹���Ŵ� ��س��кط������ \"�Ѵ��ôѪ���͡���\"";

String lc_new_edit_document = "�����/����͡���";

//----------------------- import excel --------------------------//


String lc_must_choose_file_first = "��س����͡����͹";

String lc_must_contain_proper_extension = "�����Ṻ��ͧ�չ��ʡ�����";

String lc_invalid_filename_extension = "�ͧ�Ѻ੾����� .xls ��ҹ��";

//------------------------------------- new microfilm ----------------------//

String	lc_cannot_recall_document = "�������ö���¡�׹�͡�����";

String	lc_delete_recall_success = "���¡�׹�͡������º��������";

%>