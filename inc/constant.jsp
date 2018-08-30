
<%@ page contentType="text/html; charset=tis-620"%>
<%!
String strContainerName = "EDAS420";

String lc_system_name = "ระบบบริหารจัดการเอกสารอิเล็กทรอนิกส์";

String lc_update_edas_detail1 = "ระบบใช้งานได้กับ Internet Explorer 10.0 ขึ้นไป เวอร์ชัน ";

String lc_update_edas_detail2 = " ปรับปรุงล่าสุด ";

String lc_update_edas_detail3 = "4.2.0";

String lc_update_edas_detail4 = "4/7/2559";

String lc_port_jackrabbit = "8081";

String lc_site_name = " EDAS";

String lc_zoom_table_level1 = "ตารางค่าคงที่ระดับ 1";

String lc_zoom_table_level2 = "ตารางค่าคงที่ระดับ 2";

String lc_fulltext_search = "Y";

String  lc_update = "แก้ไข";

String  lc_administrator_menu = "ดูแลระบบ";

String  lc_admin = "ผู้ดูแลระบบ";

String  lc_Jan = "มกราคม";
//String  lc_Jan = "ม.ค.";

String  lc_Feb = "กุมภาพันธ์";
//String  lc_Feb = "ก.พ.";

String  lc_Mar = "มีนาคม";
//String  lc_Mar = "มี.ค.";

String  lc_Apr = "เมษายน";
//String  lc_Apr = "เม.ย.";

String  lc_May = "พฤษภาคม";
//String  lc_May = "พ.ค.";

String  lc_Jun = "มิถุนายน";
//String  lc_Jun = "มิ.ย.";

String  lc_Jul = "กรกฎาคม";
//String  lc_Jul = "ก.ค.";

String  lc_Aug = "สิงหาคม";
//String  lc_Aug = "ส.ค.";

String  lc_Sep = "กันยายน";
//String  lc_Sep = "ก.ย.";

String  lc_Oct = "ตุลาคม";
//String  lc_Oct = "ต.ค.";

String  lc_Nov = "พฤศจิกายน";
//String  lc_Nov = "พ.ย.";

String  lc_Dec = "ธันวาคม";

String  lc_not_define = "ไม่ระบุ";

String  lc_insert_data = "บันทึกเอกสาร";

String  lc_update_data = "แก้ไขเอกสาร";

String  lc_delete_data = "ลบเอกสาร";

String  lc_search_data = "สืบค้นเอกสาร";

String  lc_import_data = "นำเข้าเอกสาร";

String  lc_export_data = "ส่งออกเอกสาร/ ทำสำเนาเอกสาร";

String  lc_modImg = "เพิ่มภาพ / เอกสารแนบ";

String  lc_prnImg = "พิมพ์ภาพ / ส่งออกเอกสารแนบ";

String  lc_delImg = "ลบภาพ / เอกสารแนบ";

String  lc_censor = "สร้าง Censor Zone";

String  lc_anot = "สร้าง Annotation และ Note";

String  lc_link = "เชื่อมโยงเอกสาร";

//************ Process User ********************//

String  lc_not_found_this_user = "กรุณาตรวจสอบรหัสผู้ใช้/รหัสผ่านใหม่";

String  lc_cannot_login = "กรุณาเข้าใช้ระบบด้วยเครื่องที่มี ip address ที่กำหนดไว้สำหรับท่านเท่านั้น หรือติดต่อผู้ดูแลระบบ";

String  lc_password_expired_in = "รหัสผ่านของท่านจะหมดอายุภายใน ";

String  lc_day = " วัน ";

String  lc_please_change_password = "โปรดเปลี่ยนรหัสผ่านทันที";

String  lc_confirm_message = "รหัสผู้ใช้ของท่านหมดอายุการใช้งาน ";

String  lc_user_cannot_update = "รหัสผู้ใช้นี้ไม่มีสิทธิ์เปลี่ยนรหัสผ่านได้";

String	lc_user_pass_not_correct = "รหัสผู้ใช้/รหัสผ่านไม่ถูกต้อง";

String	lc_success_change_password = "เปลี่ยนรหัสผ่านเรียบร้อยแล้ว";

//************* Admin Menu ************************//

String  lc_administrator = "ดูแลระบบ";

String  lc_import_export = "นำเข้า / ส่งออก";

String  lc_report_export = "รายงานและสถิติ";

String  lc_system 		 = "ตั้งค่าระบบ";

String  lc_basic_table 	 = "ตารางค่าคงที่ระบบ";

String  lc_user_role	 = "จัดการบทบาทการทำงาน";

String  lc_search_level	 = "จัดการระดับเอกสาร";

String  lc_user			 = "จัดการผู้ใช้งาน";

String  lc_user_gruop    = "จัดการกลุ่มผู้ใช้งาน";

String  lc_carbinet		 = "จัดการตู้เก็บเอกสาร";

String  lc_news		     = "จัดการข่าวประชาสัมพันธ์";

String  lc_faq		     = "จัดการ FAQ";

String  lc_recall_expire_doc   = "ดึงคืนเอกสารที่หมดอายุ";

String  lc_total_doc_report = "รายงานสรุปยอดรวมการจัดเก็บเอกสาร";

String  lc_doc_report = "รายงานสรุปการจัดเก็บเอกสาร";

String  lc_used_stat_report = "รายงานสรุปสถิติการใช้งานระบบ";

String  lc_user_status_report = "รายงานสถานะผู้ใช้งาน";

String  lc_admin_activity = "รายงานการดำเนินงานของผู้ดูแลระบบ";

String  lc_admin_right_report = "รายงานผู้ใช้ที่มีสิทธิ์ในการใช้งานตู้เก็บเอกสาร";

//******** System Config ******************//

String  lc_can_not_update_data 		= "ไม่สามารถแก้ไขข้อมูลได้";

String  lc_update_data_successfull 	= "แก้ไขข้อมูลเรียบร้อยแล้ว";

String  lc_can_not_delete_data 		= "ไม่สามารถลบข้อมูลนี้ได้";

String  lc_cannot_delete_table_had_used = "มีการใช้งานตารางนี้ไม่สามารถลบได้";

String  lc_cannot_delete_other_used_table = "มีตารางระดับอื่นใช้งานตารางนี้ไม่สามารถลบได้";

String  lc_delete_data_successfull 	= "ลบข้อมูลเรียบร้อยแล้ว";

String  lc_can_not_add_data 		= "ไม่สามารถเพิ่มข้อมูลได้";

String  lc_add_data_successfull 	= "เพิ่มข้อมูลเรียบร้อยแล้ว";

String  lc_can_not_delete_data_2	= "ไม่สามารถลบข้อมูลได้";

//******** Document Type ******************//

String  lc_data_not_found 					= "ไม่พบข้อมูลที่ต้องการค้นหา";

String  lc_can_not_insert_document_type 	= "ไม่สามารถเพิ่มประเภทเอกสารได้";

String  lc_insert_document_type_successfull = "เพิ่มประเภทเอกสารเรียบร้อยแล้ว";

String  lc_can_not_edit_document_type 		= "ไม่สามารถแก้ไขประเภทเอกสารได้";

String  lc_edit_document_type_successfull 	= "แก้ไขประเภทเอกสารเรียบร้อยแล้ว";

String  lc_delete_data_successful 			= "ลบข้อมูลเรียบร้อยแล้ว";

String	lc_cannot_delete_document_type		= "ไม่สามารถลบประเภทเอกสารนี้ได้";			

String  lc_doc_have_used_files 				= "มีข้อมูลประเภทเอกสารนี้ในระบบ ไม่สามารถลบได้";

//******** Zoom Table Manager ******************//

String lc_system_table_dup                = "ไม่สามารถเพิ่มข้อมูลได้ เนื่องจากมีตารางค่าคงที่แล้วในระบบ";

String lc_can_not_insert_system_table     = "ไม่สามารถเพิ่มข้อมูลตารางได้";

String lc_insert_system_table_successfull = "เพิ่มตารางเรียบร้อยแล้ว";

String lc_edit_system_table_successfull   = "แก้ไขข้อมูลตารางเรียบร้อยแล้ว";

String lc_delete_system_table_successfull   = "ลบตารางเรียบร้อยแล้ว";

String lc_cannot_delete_system_table   = "ไม่สามารถลบตารางได้";

String lc_can_not_delete_detail           = "ไม่สามารถลบข้อมูลได้เนื่องจากมีการใช้งาน";

//********** Import Data *********************//

String  lc_total_size_full  = "เนื้อที่ในการเก็บข้อมูลเต็ม ไม่สามารถบันทึกข้อมูลได้";

//******** User Role ******************//

String lc_can_not_insert_user_role     = "ไม่สามารถเพิ่มบทบาทการทำงานได้";

String lc_insert_user_role_successfull = "เพิ่มบทบาทการทำงานเรียบร้อยแล้ว";

String lc_edit_user_role_successfull   = "แก้ไขบทบาทการทำงานเรียบร้อยแล้ว";

//******** User Level ******************//

String lc_user_level_dup                = "ไม่สามารถเพิ่มระดับเอกสารได้ เนื่องจากมีระดับเอกสารแล้วในระบบ";

String lc_can_not_insert_user_level     = "ไม่สามารถเพิ่มระดับเอกสารได้";

String lc_insert_user_level_successfull = "เพิ่มระดับเอกสารเรียบร้อยแล้ว";

String lc_edit_user_level_successfull   = "แก้ไขระดับเอกสารเรียบร้อยแล้ว";

//******** User Profile ******************//

String lc_user_profile_dup                = "ไม่สามารถเพิ่มผู้ใช้งานได้ เนื่องจากมีผู้ใช้งานแล้วในระบบ";

String lc_can_not_insert_user_profile     = "ไม่สามารถเพิ่มผู้ใช้งานได้";

String lc_insert_user_profile_successfull = "เพิ่มผู้ใช้งานเรียบร้อยแล้ว";

String lc_edit_user_profile_successfull   = "แก้ไขผู้ใช้งานเรียบร้อยแล้ว";

String lc_can_not_delete_user_profile     = "ไม่สามารถลบผู้ใช้งานได้";

String lc_delete_user_profile_successfull = "ลบผู้ใช้งานเรียบร้อยแล้ว";

//******** Project Manager ******************//

String lc_project_manager_cannot_delete_used = "มีเอกสารอยู่ในตู้เก็บเอกสารนี้ ไม่สามารถลบได้";

String lc_project_manager_cannot_delete      = "ไม่สามารถลบตู้เอกสารได้";

String lc_can_not_insert_project_manager     = "ไม่สามารถเพิ่มตู้เอกสารได้";

String lc_can_not_edit_project_manager     = "ไม่สามารถแก้ไขตู้เอกสารได้";

String lc_insert_project_manager_successfull = "เพิ่มตู้เอกสารเรียบร้อยแล้ว";

String lc_edit_project_manager_successfull   = "แก้ไขตู้เอกสารเรียบร้อยแล้ว";

String lc_delete_project_manager_successfull = "ลบตู้เอกสารเรียบร้อยแล้ว";

String lc_attachment = "เอกสารแนบ";

//*********** Edit Document ******************//

String	lc_delete_document = "ไม่สามารถลบประเภทเอกสารได้";

String	lc_cannot_check_in = "ไม่สามารถเช็คอินเอกสารได้";

String	lc_cannot_check_out = "ไม่สามารถเช็คเอ้าท์เอกสารได้";

String	lc_cannot_delete_document = "ไม่สามารถลบเอกสารได้";

String	lc_delete_document_success = "ลบเอกสารเรียบร้อยแล้ว";

//*********** Master Link ******************//

String	lc_data_deleted = "ข้อมูลถูกลบไปแล้ว";

String	lc_cannot_save_data_link = "ไม่สามารถบันทึกเอกสารเชื่อมโยงได้";

String	lc_save_data_link_success = "บันทึกเอกสารเชื่อมโยงเรียบร้อยแล้ว";

String	lc_data_link = "เอกสารเชื่อมโยง";

//*********** Field Manager ******************//

String lc_field_manager_dup                = "ไม่สามารถเพิ่มดัชนีเอกสารได้ เนื่องจากมีดัชนีเอกสารนี้แล้วในระบบ";

String lc_can_not_insert_field_manager     = "ไม่สามารถเพิ่มดัชนีเอกสารได้";

String lc_can_not_delete_field_manager     = "มีการใช้งานดัชนีเอกสาร ไม่สามารถลบได้";

String lc_can_not_update_field_manager     = "ไม่สามารถแก้ไขดัชนีเอกสารได้";

String lc_can_not_update_contact_admin     = "ไม่สามารถแก้ไขดัชนีเอกสารได้ กรุณาติดต่อผู้ดูแลระบบ";

String lc_insert_field_manager_successfull = "เพิ่มดัชนีเอกสารเรียบร้อยแล้ว";

String lc_edit_field_manager_successfull   = "แก้ไขข้อมูลดัชนีเอกสารเรียบร้อยแล้ว";

String lc_can_not_set_field_manager        = "ไม่สามารถเซ็ทดัชนีการสืบค้นได้";

String lc_can_not_set_field_manager_too_long = "ไม่สามารถเซ็ทดัชนีการสืบค้นได้เนื่องจากความยาวเกินขนาด";

String lc_set_field_manager_successfull    = "เซ็ทดัชนีการสืบค้นเรียบร้อยแล้ว";

//*********** Box Manage *********************//

String	lc_can_not_insert_box_manage = "ไม่สามารถเพิ่มกล่องใหม่ได้";

String	lc_insert_box_manage_successful = "เพิ่มกล่องใหม่เรียบร้อยแล้ว";

String	lc_cannot_edit_box_manage = "ไม่สามารถแก้ไขกล่องได้";

String	lc_edit_box_manage_successful = "แก้ไขกล่องเรียบร้อยแล้ว";

String	lc_cannot_add_data_box = "ไม่สามารถเพิ่มรายการในกล่องได้";

String	lc_add_data_box_successful = "เพิ่มรายการในกล่องเรียบร้อยแล้ว";

String  lc_box_have_used_files 	= "มีข้อมูลรายการในกล่อง ไม่สามารถลบข้อมูลได้";

String  lc_delete_box_successful = "ลบกล่องเรียบร้อยแล้ว";

//************** Detail Scan *********************//
String	lc_user_level_access_denied = "ท่านไม่มีสิทธิดูเอกสารนี้";

//*********** Form Builder ******************//
String lc_form_builder_dup                = "ไม่สามารถเพิ่มฟอร์มได้ เนื่องจากมีฟอร์มนี้แล้วในระบบ";

String lc_can_not_insert_form_builder     = "ไม่สามารถเพิ่มฟอร์มได้";

String lc_can_not_update_form_builder     = "ไม่สามารถแก้ไขฟอร์มได้";

String lc_can_not_delete_form_builder     = "ไม่สามารถลบฟอร์มได้";

String lc_insert_form_builder_successfull = "เพิ่มฟอร์มเรียบร้อยแล้ว";

String lc_edit_form_builder_successfull   = "แก้ไขข้อมูลฟอร์มเรียบร้อยแล้ว";

String lc_delete_form_builder_successfull = "ลบข้อมูลฟอร์มเรียบร้อยแล้ว";

//*********** Import Data ******************//
String lc_new_document = "เอกสารใหม่";

String lc_edit_delete_document = "แก้ไขเพิ่มเติม / ลบเอกสาร";

//----------edas ver.4.0.2-----------------//
String	lc_permit_user_successful = "ให้สิทธิผู้ใช้เรียบร้อยแล้ว";

String	lc_cannot_permit_user = "ไม่สามารถให้สิทธิผู้ใช้ได้";

String	lc_cancel_permit_user_successful = "ยกเลิกการให้สิทธิผู้ใช้เรียบร้อยแล้ว";

String	lc_cannot_cancel_permit_user = "ไม่สามารถยกเลิกการให้สิทธิผู้ใช้ได้";

String	lc_search_permit_user = "ค้นหาผู้ใช้";

String	lc_permit_user = "ระบุผู้ใช้";

//*********** News Manager ******************//

String lc_can_not_insert_news     = "ไม่สามารถเพิ่มข่าวประชาสัมพันธ์ได้";

String lc_can_not_update_news     = "ไม่สามารถแก้ไขข่าวประชาสัมพันธ์ได้";

String lc_can_not_delete_news     = "ไม่สามารถลบข่าวประชาสัมพันธ์ได้";

String lc_insert_news_successfull = "เพิ่มข่าวประชาสัมพันธ์เรียบร้อยแล้ว";

String lc_edit_news_successfull   = "แก้ไขข้อมูลข่าวประชาสัมพันธ์เรียบร้อยแล้ว";

String lc_delete_news_successfull = "ลบข้อมูลข่าวประชาสัมพันธ์เรียบร้อยแล้ว";

//*********** Faq Manager ******************//

String lc_can_not_insert_faq     = "ไม่สามารถเพิ่มคำถาม-ตอบได้";

String lc_can_not_update_faq     = "ไม่สามารถแก้ไขคำถาม-ตอบได้";

String lc_can_not_delete_faq     = "ไม่สามารถลบคำถาม-ตอบได้";

String lc_insert_faq_successfull = "เพิ่มคำถาม-ตอบเรียบร้อยแล้ว";

String lc_edit_faq_successfull   = "แก้ไขข้อมูลคำถาม-ตอบเรียบร้อยแล้ว";

String lc_delete_faq_successfull = "ลบข้อมูลคำถาม-ตอบเรียบร้อยแล้ว";

//*********** User Group ******************//

String lc_can_not_delete_group = "ไม่สามารถลบกลุ่มผู้ใช้งาน เนื่องจากยังมีผู้ใช้งานอยู่ในกลุ่ม";

//*********** Policy Agent ******************//

String strAdminUsername = "apluser";

String strAdminPassword = "rtyhgf";

//*********** Export XML Field Manager ******************//

String lc_export_xml_successfull = "ส่งออกข้อมูลโครงสร้างตู้เก็บเอกสารเรียบร้อยแล้ว";

String lc_import_xml_successfull = "นำเข้าข้อมูลโครงสร้างตู้เก็บเอกสารเรียบร้อยแล้ว";

//************ Move Document ****************//

String lc_project_target_title = "เลือกตู้เก็บเอกสารปลายทาง";


//************** Update**********************//

String lc_not_set_search_field = "ไม่มีการกำหนดฟิลด์สืบค้น กรุณาระบุที่เมนู \"จัดการดัชนีเอกสาร\"";

String lc_not_set_report_field = "ไม่มีการกำหนดฟิลด์รายงาน กรุณาระบุที่เมนู \"จัดการดัชนีเอกสาร\"";

String lc_not_set_link_field = "ไม่มีการกำหนดฟิลด์เชื่อมโยง กรุณาระบุที่เมนู \"จัดการดัชนีเอกสาร\"";

String lc_not_set_log_field = "ไม่มีการกำหนดฟิลด์log กรุณาระบุที่เมนู \"จัดการดัชนีเอกสาร\"";

String lc_not_set_index_field = "ไม่มีการกำหนดฟิลด์ กรุณาระบุที่เมนู \"จัดการดัชนีเอกสาร\"";

String lc_new_edit_document = "นำเข้า/แก้ไขเอกสาร";

//----------------------- import excel --------------------------//


String lc_must_choose_file_first = "กรุณาเลือกไฟล์ก่อน";

String lc_must_contain_proper_extension = "ไฟล์ที่แนบต้องมีนามสกุลไฟล์";

String lc_invalid_filename_extension = "รองรับเฉพาะไฟล์ .xls เท่านั้น";

//------------------------------------- new microfilm ----------------------//

String	lc_cannot_recall_document = "ไม่สามารถเรียกคืนเอกสารได้";

String	lc_delete_recall_success = "เรียกคืนเอกสารเรียบร้อยแล้ว";

%>