<%@ page contentType="text/html; charset=tis-620"%>
<%!
//-- ------------------------------------
//-- CONSTANT
//-- ------------------------------------
	
String	lb_add = "เพิ่มรายการใหม่";

String	lb_edit = "แก้ไขรายการ";

String	lb_search = "ค้นหา";

String	lb_add_new_table = "สร้างตารางใหม่";

String	lb_edit_table = "แก้ไขตาราง";

String	lb_search_table = "ค้นหาตาราง";

String	lb_add_new_field = "เพิ่มฟิลด์";

String	lb_edit_field = "แก้ไขฟิลด์";

String	lb_level_doc = "ระดับเอกสาร";

String	lb_doc_user = "เจ้าของเอกสาร";

String	lb_version_doc = "เวอร์ชั่นเอกสาร";

String	lb_keep_old_version = "เก็บเวอร์ชั่นเก่า";

String	lb_not_keep_old_version = "ไม่เก็บเวอร์ชั่นเก่า";

String	lb_add_version = "ระบุเวอร์ชั่น";

String	lb_blank_all_ver = "(*ค่าว่างคือเก็บทุกเวอร์ชั่น)";

String	lb_doc_attach = "เอกสาร";

String	lb_attach_count = "จำนวน";

String	lb_province = "จังหวัด";

String	lb_user_id = "รหัสผู้ใช้";

String	lb_user_name = "ชื่อผู้ใช้";

String	lb_project_name = "ชื่อตู้เอกสาร";

String	lb_new_user_level = "สร้างระดับเอกสารใหม่";

String	lb_edit_user_level = "แก้ไขระดับเอกสาร";

String	lb_new_user_role = "สร้างบทบาทใหม่";

String	lb_edit_user_role = "แก้ไขบทบาทการทำงาน";

String	lb_user_role = "บทบาทการทำงาน";

String	lb_search_profile = "ค้นหารายการ";

String	lb_add_project_code = "เพิ่มตู้ใหม่";

String	lb_edit_project_code = "แก้ไขตู้";

String	lb_document_detail = "รายละเอียดเอกสาร";

String  lb_email_management = "E-MAIL Management";

String  lb_fax_management = "Fax Management";

String  lb_report_management = "Report Management";

String	lb_page_no = "หน้าที่ ";

String	lb_records = " รายการ";

String	lb_total_record = "รายการทั้งหมด ";

String	lb_key_field = "คีย์ฟิลด์";

String	lb_field_search = "ฟิลด์สืบค้น";

String	lb_field_report = "ฟิลด์รายงาน";

String	lb_field_link = "ฟิลด์เชื่อมโยง";

String	lb_field_log = "ฟิลด์ Log";

String  lb_field_global_search = "ฟิลด์ Global Search";

String	lb_document_link = "เชื่อมโยงเอกสาร";

String	lb_search_document_link = "ค้นหาข้อมูลเพื่อเชื่อมโยงเอกสาร";

String	lb_select_project_for_link = "เลือกตู้เก็บเอกสารเพื่อการเชื่อมโยง";

String	lb_add_new_box = "เพิ่มกล่องใหม่";

String	lb_edit_box = "แก้ไขกล่อง";

String	lb_add_data = "ป้อนข้อมูล";

String	lb_search_data_box = "ค้นหาข้อมูลเพื่อเพิ่มรายการข้อมูลลงกล่ิอง";

String lb_detail = "รายละเอียด";

String lb_attachment = "แฟ้มแนบ";

String lb_delete = "ลบ";

String lb_order = "ลำดับ";

String lb_sort_order = "การจัดเรียง";

String lb_sort_asc = "น้อยไปหามาก";

String lb_sort_desc = "มากไปหาน้อย";

String lb_count_record = "จำนวนรายการ";

String lb_all_record = "ทั้งหมด";

String lb_get_record = "ระบุรายการ";

String lb_document_number = "เลขเอกสาร";

String lb_document_name = "ชื่อเอกสาร";

String lb_create_date = "วันที่สร้างเอกสาร";

String lb_to_date = "ถึง";

String lb_edit_date = "วันที่แก้ไข";

String lb_document_user = "เจ้าของเอกสาร";

String lb_chk_document_user = "เอกสารของตนเอง";

String lb_create_user = "ผู้สร้างเอกสาร";

String lb_edit_user = "ผู้แก้ไขเอกสาร";

String lb_detail_document = "เนื้อหาเอกสาร";

String lb_searchkey = "คำค้น";

String lb_date = "วันที่";

String lb_version = "เวอร์ชั่น";

String	lb_add_new_form = "สร้างฟอร์ม";

String	lb_edit_form = "แก้ไขฟอร์ม";

String	lb_manage_field = "จัดการฟิลด์";

String	lb_attatch_field = "จัดการเอกสารแนบ";

String	lb_display_records = "แสดงรายการ";

String	lb_page_sizes = "จำนวนรายการ ";

String	lb_rec_per_page = " รายการ/หน้า";

//--------- edas v. 4.0.2 ------------//
String lb_file_type = "ประเภทแฟ้ม";

String lb_department = "แผนก";

String lb_news = "ข่าวประชาสัมพันธ์";

String lb_add_news = "เพิ่มข่าวประชาสัมพันธ์";

String lb_edit_news = "แก้ไขข่าวประชาสัมพันธ์";

String lb_search_news = "ค้นหาข่าวประชาสัมพันธ์";

String lb_add_faq = "เพิ่มคำถาม-ตอบ";

String lb_edit_faq = "แก้ไขคำถาม-ตอบ";

String lb_search_faq = "ค้นหาคำถาม-ตอบ";

String lb_scan_org_combo = "หน่วยงาน";

String lb_close = "ปิด";

String	lb_page_per_size = "จำนวนรายการต่อหน้า";

//--------- edas v. 4.1.1 ------------//

String lb_user_group_new = "สร้างกลุ่มใหม่";

String lb_user_group_edit = "แก้ไขกลุ่มผู้ใช้";

String lb_user_group_list = ">> รายการผู้ใช้";

String lb_user_group_manage = ">> จัดการผู้ใช้งาน";

String lb_user_group_manage_add = ">> เพิ่มผู้ใช้งาน";

String lb_user_group_permit = ">> จัดการสิทธิ์";

String lb_user_group_access = ">> การเข้าถึงเอกสาร";

String lb_tooltip_attach = "แนบเอกสาร";

String lb_tooltip_delete = "ลบ";

String lb_tooltip_cut = "คัดลอก";

String lb_tooltip_paste = "วาง";

String lb_doc_store = "สถานที่เก็บเอกสาร";

// ---------- v. 4.1.2 -------------//

String lb_file_name = "ชื่อไฟล์";

String lb_select_export_type = "เลือกประเภท";

String lb_export_in_code = "ส่งออกข้อมูลรูปแบบรหัส(Code)";

String lb_export_in_description = "ส่งออกข้อมูลรูปแบบรายละเอียด(Description)";

%>
