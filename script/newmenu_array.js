timegap=500
followspeed=5
followrate=40
suboffset_top=0;
suboffset_left=10;

effect = "fade(duration=0.3);Shadow(color='#000000', Direction=135, Strength=5)"

prop1=[						// prop1 is an array of properties you can have as many property arrays as you need
"FFFFFF",					// Off Font Color
"C5070A",					// Off Back Color
"000099",					// On Font Color
"F8D660",					// On Back Color
"000000",					// Border Color
14,							// Font Size
"normal",					// Font Style 
"normal",					// Font Weight
"Ms sans serif,Tahoma",	// Font
3,							// Padding
"arrow.gif",				// Sub Menu Image (Leave blank if not needed)
0,							// 3D Border & Separator
"66FFFF",					// 3D High Color
"000099",					// 3D Low Color
"000000",					// Referer item Font Color (leave this blank to disable)
"F8D660",					// Referer item Back Color (leave this blank to disable)
]


menu1=[			// This is the array that contains your menu properties and details
120,				// Top
,				// left
,				// Width
1,				// Border Width
"left",		// Screen Position - here you can use "center;left;right;middle;top;bottom"
prop1,			// Properties Array - this is set higher up, as above
1,				// Always Visible - allows the menu item to be visible at all time
"center",		// Alignment - sets the menu elements alignment, HTML values are valid here for example: left, right or center
,				// Filter - Text variable for setting transitional effects on menu activation
,				// Follow Scrolling - Tells the menu item to follow the user down the screen
1, 				// Horizontal Menu - Tells the menu to be horizontal instead of top to bottom style
,				// Keep Alive - Keeps the menu visible until the user moves over another menu or clicks elsewhere on the page
,				// Position of sub image left:center:right:middle:top:bottom
,				// Show an image on top menu bars indicating a sub menu exists below
,				// Reserved for future use
//"&nbsp;&nbsp;&nbsp;สำนักวิชาการ&nbsp;&nbsp;&nbsp;","../index.jsp",,,1  // "Description Text", "URL", "Alternate URL", "Status", "Separator Bar"
"<SPAN id='sp_menu1' style='width:" + ( gv_menu_w - 5 ) + "'>สำนักวิชาการ</SPAN>","show-menu2",,"",1,
"<SPAN id='sp_menu2' style='width:" + ( gv_menu_w + 20 ) + "'>ห้องสมุดและการพัฒนาสารสนเทศ</SPAN>","show-menu3",,"",1,
"<SPAN id='sp_menu3' style='width:" + ( gv_menu_w - 5 ) + "'>บริการวิชาการ</SPAN>","show-menu4",,"",1,
"<SPAN id='sp_menu4' style='width:" + ( gv_menu_w - 5 ) + "'>พิพิธภัณฑ์และจดหมายเหตุ</SPAN>","show-menu5",,"",1,
"<SPAN id='sp_menu5' style='width:" + ( gv_menu_w - 5 ) + "'>วิจัยและพัฒนา</SPAN>","show-menu6",,"",1
]

menu2=[,,190,1,,prop1,0,"left",effect,0,,,,,,
"วิสัยทัศน์ พันธกิจ ภารกิจ ยุทธศาสตร์","text_pdf/bureau.pdf target=_blank",,,1,
"โครงสร้างการบริหารงาน","struc.htm target=_blank",,,1,
"ผู้บริหารงานและผู้ร่วมงาน","adminlist.html target=_blank",,,1,
//"โบรชัวร์ต่าง ๆ","../#",,,1,
//"Download แบบฟอร์มต่าง ๆ","../#",,,1,
"Link ที่น่าสนใจ","link.htm target=_blank",,,1,
"เสนอแนะความคิดเห็น","mailto:nisa@parliament.go.th",,,1
]

menu3=[,,250,1,"",prop1,,"left",effect,,,,,,,
"คู่มือการใช้งานฐานข้อมูล","database_hand.htm target=_blank",,,1,
"ระบบงานห้องสมุดอิเล็กทรอนิกส์","text_doc/e_lib.doc target=_blank",,,1,
"ระบบงานเอกสารอิเล็กทรอนิกส์","text_doc/e_document.doc target=_blank",,,1,
"ระเบียบการใช้ห้องสมุด","rule.htm target=_blank",,,1,
"รายชื่อวารสารที่ให้บริการในห้องสมุด","text_pdf/journallist.pdf target=_blank",,,1
]

menu4=[,,210,1,"",prop1,,,effect,,,,,,,
"บริการวิชาการ","../#",,,1,
"บริการ E-Knowledge Service ","text_doc/e_knowledge.doc target=_blank",,,1,
"บริการ One Stop Service","../#",,,1
//"รายชื่อผลงานวิชาการของกลุ่มบริการวิชาการ","../#",,,1,
//"บทความทางวิชาการ (ฉบับเต็ม)","../#",,,1,
//"สารบัญวารสาร Social News","../#",,,1
]

menu5=[,,220,1,"",prop1,,,effect,,,,,,,
"บริการของกลุ่มพิพิธภัณฑ์และจดหมายเหตุ","../#",,,1,
"พิพิธภัณฑ์การเมืองการปกครอง","../#",,,1,
"ระเบียบจดหมายเหตุรัฐสภา","text_pdf/museam.pdf target=_blank",,,1
]

menu6=[,,180,1,,prop1,0,"left",effect,0,,,,,,
"งานวิจัยและพัฒนาของสำนักวิชาการ","../#",,,1,
"ระเบียบวิจัยและพัฒนา","text_pdf/research.pdf target=_blank",,,1,
"รายชื่องานวิจัยที่แล้วเสร็จ","text_pdf/researchlist.pdf target=_blank",,,1,
//"รายชื่องานวิจัยที่อยู่ระหว่างดำเนินการ","../#",,,1,
//"สารบัญวารสารวิจัยและพัฒนา","../#",,,1
"...","../#",,,1
]
