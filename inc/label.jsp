<%@ page contentType="text/html; charset=tis-620"%>
<%!
//-- ------------------------------------
//-- CONSTANT
//-- ------------------------------------
	
String	lb_add = "������¡������";

String	lb_edit = "�����¡��";

String	lb_search = "����";

String	lb_add_new_table = "���ҧ���ҧ����";

String	lb_edit_table = "��䢵��ҧ";

String	lb_search_table = "���ҵ��ҧ";

String	lb_add_new_field = "������Ŵ�";

String	lb_edit_field = "��䢿�Ŵ�";

String	lb_level_doc = "�дѺ�͡���";

String	lb_doc_user = "��Ңͧ�͡���";

String	lb_version_doc = "��������͡���";

String	lb_keep_old_version = "������������";

String	lb_not_keep_old_version = "���������������";

String	lb_add_version = "�к��������";

String	lb_blank_all_ver = "(*�����ҧ����纷ء�������)";

String	lb_doc_attach = "�͡���";

String	lb_attach_count = "�ӹǹ";

String	lb_province = "�ѧ��Ѵ";

String	lb_user_id = "���ʼ����";

String	lb_user_name = "���ͼ����";

String	lb_project_name = "���͵���͡���";

String	lb_new_user_level = "���ҧ�дѺ�͡�������";

String	lb_edit_user_level = "����дѺ�͡���";

String	lb_new_user_role = "���ҧ���ҷ����";

String	lb_edit_user_role = "��䢺��ҷ��÷ӧҹ";

String	lb_user_role = "���ҷ��÷ӧҹ";

String	lb_search_profile = "������¡��";

String	lb_add_project_code = "�����������";

String	lb_edit_project_code = "��䢵��";

String	lb_document_detail = "��������´�͡���";

String  lb_email_management = "E-MAIL Management";

String  lb_fax_management = "Fax Management";

String  lb_report_management = "Report Management";

String	lb_page_no = "˹�ҷ�� ";

String	lb_records = " ��¡��";

String	lb_total_record = "��¡�÷����� ";

String	lb_key_field = "�����Ŵ�";

String	lb_field_search = "��Ŵ��׺��";

String	lb_field_report = "��Ŵ���§ҹ";

String	lb_field_link = "��Ŵ�������§";

String	lb_field_log = "��Ŵ� Log";

String  lb_field_global_search = "��Ŵ� Global Search";

String	lb_document_link = "������§�͡���";

String	lb_search_document_link = "���Ң���������������§�͡���";

String	lb_select_project_for_link = "���͡������͡������͡��������§";

String	lb_add_new_box = "�������ͧ����";

String	lb_edit_box = "��䢡��ͧ";

String	lb_add_data = "��͹������";

String	lb_search_data_box = "���Ң���������������¡�â�����ŧ����ͧ";

String lb_detail = "��������´";

String lb_attachment = "���Ṻ";

String lb_delete = "ź";

String lb_order = "�ӴѺ";

String lb_sort_order = "��èѴ���§";

String lb_sort_asc = "��������ҡ";

String lb_sort_desc = "�ҡ��ҹ���";

String lb_count_record = "�ӹǹ��¡��";

String lb_all_record = "������";

String lb_get_record = "�к���¡��";

String lb_document_number = "�Ţ�͡���";

String lb_document_name = "�����͡���";

String lb_create_date = "�ѹ������ҧ�͡���";

String lb_to_date = "�֧";

String lb_edit_date = "�ѹ������";

String lb_document_user = "��Ңͧ�͡���";

String lb_chk_document_user = "�͡��âͧ���ͧ";

String lb_create_user = "������ҧ�͡���";

String lb_edit_user = "�������͡���";

String lb_detail_document = "�������͡���";

String lb_searchkey = "�Ӥ�";

String lb_date = "�ѹ���";

String lb_version = "�������";

String	lb_add_new_form = "���ҧ�����";

String	lb_edit_form = "��䢿����";

String	lb_manage_field = "�Ѵ��ÿ�Ŵ�";

String	lb_attatch_field = "�Ѵ����͡���Ṻ";

String	lb_display_records = "�ʴ���¡��";

String	lb_page_sizes = "�ӹǹ��¡�� ";

String	lb_rec_per_page = " ��¡��/˹��";

//--------- edas v. 4.0.2 ------------//
String lb_file_type = "���������";

String lb_department = "Ἱ�";

String lb_news = "���ǻ�Ъ�����ѹ��";

String lb_add_news = "�������ǻ�Ъ�����ѹ��";

String lb_edit_news = "��䢢��ǻ�Ъ�����ѹ��";

String lb_search_news = "���Ң��ǻ�Ъ�����ѹ��";

String lb_add_faq = "�����Ӷ��-�ͺ";

String lb_edit_faq = "��䢤Ӷ��-�ͺ";

String lb_search_faq = "���ҤӶ��-�ͺ";

String lb_scan_org_combo = "˹��§ҹ";

String lb_close = "�Դ";

String	lb_page_per_size = "�ӹǹ��¡�õ��˹��";

//--------- edas v. 4.1.1 ------------//

String lb_user_group_new = "���ҧ���������";

String lb_user_group_edit = "��䢡���������";

String lb_user_group_list = ">> ��¡�ü����";

String lb_user_group_manage = ">> �Ѵ��ü����ҹ";

String lb_user_group_manage_add = ">> ���������ҹ";

String lb_user_group_permit = ">> �Ѵ����Է���";

String lb_user_group_access = ">> �����Ҷ֧�͡���";

String lb_tooltip_attach = "Ṻ�͡���";

String lb_tooltip_delete = "ź";

String lb_tooltip_cut = "�Ѵ�͡";

String lb_tooltip_paste = "�ҧ";

String lb_doc_store = "ʶҹ������͡���";

// ---------- v. 4.1.2 -------------//

String lb_file_name = "�������";

String lb_select_export_type = "���͡������";

String lb_export_in_code = "���͡�������ٻẺ����(Code)";

String lb_export_in_description = "���͡�������ٻẺ��������´(Description)";

%>
