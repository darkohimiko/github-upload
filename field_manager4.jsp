<%@page import="com.scc.edms.conf.ImageConfUtil"%>
<%@ page contentType="text/html; charset=tis-620"%>
<%@ page import="com.scc.security.UserInfo"%>
<%@ include file="inc/checkUser.jsp" %>
<%@ include file="inc/constant.jsp" %>
<%@ include file="inc/label.jsp" %>
<%@ include file="inc/utils.jsp" %>
<jsp:useBean id="con" scope="session" class="edms.cllib.EABConnector"/>
<jsp:useBean id="con1" scope="session" class="edms.cllib.EABConnector"/>
<%	
	con.setRemoteServer("EAS_SERVER");
	con1.setRemoteServer("EAS_SERVER");

    UserInfo userInfo     = (UserInfo)session.getAttribute( "USER_INFO" );
    String strUserId      = userInfo.getUserId();
    String strProjectCode = userInfo.getProjectCode();
    String user_role      = getField(request.getParameter("user_role"));
    String app_name       = getField(request.getParameter("app_name"));
    String app_group      = getField(request.getParameter("app_group"));

    String screenname   = getField(request.getParameter("screenname"));
    String strClassName = "FIELD_MANAGER";
    String strMode      = getField(request.getParameter("MODE"));

    String strProjectCodeData   = getField(request.getParameter( "PROJECT_CODE" ));
    String strIndexNameData     = "MASTER_SCAN_" + strProjectCode + "_IX1";
    String strFieldCode1Choose  = getField(request.getParameter( "FIELD_CODE1_CHOOSE" ));
    String strFieldOrder1Choose = getField(request.getParameter( "FIELD_ORDER1_CHOOSE" ));
    String strFieldCode2Choose  = getField(request.getParameter( "FIELD_CODE2_CHOOSE" ));
    String strFieldOrder2Choose = getField(request.getParameter( "FIELD_ORDER2_CHOOSE" ));
	
    String strFieldSeqnData   = getField(request.getParameter("INDEX_SEQN"));
    String strFieldCodeData   = getField(request.getParameter("hidFieldCode1"));
    String strFieldIndexOrder = "";
    String strFieldLabelData  = "";
    String strFieldTypeData   = "";
    String strFieldLengthData = "";

    String strFieldCodeChooseData  = getField(request.getParameter("hidFieldCode2"));
    String strFieldOrderChooseData = getField(request.getParameter("hidFieldOrder"));

    String strFieldCodeTypeKData       = "";
    String strFieldSeqnTypeKData       = "";
    String strFieldLabelTypeKData      = "";
    String strFieldTypeTypeKData       = "";
    String strFieldLengthTypeKData     = "";
    String strFieldIndexOrderTypeKData = "";
    
    String strLastRowSelect2 = getField(request.getParameter( "last_row_select2" ));
    String strFieldCode      = "";
    String fieldCode         = "fieldCode";
    
    boolean bolnSuccess     = true;
    boolean bolnSuccess1    = true;
    String  strErrorCode    = null;
    String  strmsg          = "";
    int     intSeq          = 0;
    String  strScript       = "";

    String  screenLabel     = lb_field_search;
    String  strCurrentDate	= "";
    String  strVersionLang	= ImageConfUtil.getVersionLang();

    if( strVersionLang.equals("thai") ) {
        strCurrentDate = getTodayDateThai();
    }else{
        strCurrentDate = getTodayDate();
    }
	
    if( strMode == null ){
        strMode = "SEARCH";
    }

    if( strMode.equals("SETKEY") ) {
        con1.addData( "PROJECT_CODE", "String", strProjectCode );
        con1.addData( "INDEX_TYPE",   "String", "S" );
        
        bolnSuccess1 = con1.executeService( strContainerName, strClassName, "findMaxIndexManager" );
        if( bolnSuccess1 ) {
        	strFieldIndexOrder = con1.getHeader("INDEX_ORDER");
        	if( strFieldIndexOrder == null || strFieldIndexOrder.equals("") ) {
        		strFieldIndexOrder = "1";
        	}
        }
        
        con.addData( "PROJECT_CODE", "String", strProjectCode );
        con.addData( "INDEX_CODE",   "String", strFieldCodeData );
        con.addData( "INDEX_SEQN",   "String", strFieldSeqnData );
        con.addData( "INDEX_ORDER",  "String", strFieldIndexOrder );
        con.addData( "INDEX_TYPE",   "String", "S" );
        con.addData( "ADD_USER",     "String", strUserId );
        con.addData( "ADD_DATE",     "String", strCurrentDate );
        con.addData( "UPD_USER",     "String", strUserId );
        
        bolnSuccess = con.executeService( strContainerName, strClassName, "setIndexSearchFieldManager" );
        
        if( !bolnSuccess ) {
            strErrorCode    = con.getRemoteErrorCode();
        }
        strMode = "SEARCH";
    }

    if( strMode.equals("UNSETKEY") ) {
        con.addData( "PROJECT_CODE", "String", strProjectCode );
        con.addData( "INDEX_CODE",   "String", strFieldCodeChooseData );
        con.addData( "INDEX_ORDER",  "String", strFieldOrderChooseData );
        con.addData( "INDEX_TYPE",   "String", "S" );
        con.addData( "EDIT_USER",    "String", strUserId );
        con.addData( "EDIT_DATE",    "String", strCurrentDate );
        con.addData( "UPD_USER",     "String", strUserId );
        
        bolnSuccess = con.executeService( strContainerName, strClassName, "unSetIndexSearchFieldManager" );
        
        if( !bolnSuccess ) {
            strErrorCode    = con.getRemoteErrorCode();
        }
        strMode = "SEARCH";
    }
    
    if( strMode.equals("SETINDEX") ) {    	
        con.addData( "PROJECT_CODE", "String", strProjectCode );
        con.addData( "INDEX_NAME",   "String", strIndexNameData );
        con.addData( "INDEX_TYPE",   "String", "S" );
        con.addData( "EDIT_USER",    "String", strUserId );
        con.addData( "EDIT_DATE",    "String", strCurrentDate );
        con.addData( "UPD_USER",     "String", strUserId );
        
        bolnSuccess = con.executeService( strContainerName, strClassName, "setFieldIndexFieldManager" );
        
        if( !bolnSuccess ) {
            strErrorCode    = con.getRemoteErrorCode();
            
            if( strErrorCode.equals("ERR99999") ) {
            	strmsg  = "showMsg(0,0,\" " + lc_can_not_set_field_manager_too_long  + "\")";
            }else {
            	strmsg  = "showMsg(0,0,\" " + lc_can_not_set_field_manager  + "\")";
            }
        }else {
            strmsg  = "showMsg(0,0,\" " + lc_set_field_manager_successfull  + "\")";
        }
        strMode = "SEARCH";
    }

    if( strMode.equals("ORDER") ) {
        con.addData( "PROJECT_CODE", "String", strProjectCode );
        con.addData( "FIELD_CODE1",  "String", strFieldCode1Choose );
        con.addData( "FIELD_ORDER1", "String", strFieldOrder1Choose );
        con.addData( "FIELD_CODE2",  "String", strFieldCode2Choose );
        con.addData( "FIELD_ORDER2", "String", strFieldOrder2Choose );
        con.addData( "INDEX_TYPE",   "String", "S" );
        
        bolnSuccess = con.executeService( strContainerName, strClassName, "orderIndexFieldManager" );
        
        if( !bolnSuccess ) {
            strErrorCode    = con.getRemoteErrorCode();
        }
        strMode = "SEARCH";
    }
	
    if(strMode.equals("SEARCH")){
        con.addData( "PROJECT_CODE", "String", strProjectCodeData );
        bolnSuccess = con.executeService( strContainerName , strClassName , "findFieldManager" );

        if( !bolnSuccess ) {
            strErrorCode    = con.getRemoteErrorCode();
        }
        
        con1.addData( "PROJECT_CODE", "String", strProjectCodeData );
        con1.addData( "INDEX_TYPE",   "String", "S" );
        bolnSuccess1 = con1.executeService( strContainerName , strClassName , "selectFieldManagerTypeOnLoad" );

        if( !bolnSuccess1 ) {
            strErrorCode    = con1.getRemoteErrorCode();
        }
	}
    
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title><%=lc_site_name%></title>
<meta http-equiv="Content-Type" content="text/html; charset=windows-874">
<script language="JavaScript" type="text/JavaScript">
<!--
function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}

function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_findObj(n, d) { //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
}

function MM_swapImage() { //v3.0
  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
}
//-->
</script>
<script language="JavaScript" src="js/sccUtils.js"></script>
<script language="JavaScript" src="js/util.js"></script>
<script language="JavaScript" src="js/constant.js"></script>
<script language="JavaScript" src="js/label.js"></script>
<script language="JavaScript" type="text/javascript">
<!--

function window_onload() {
    var lastRowSelect2              = "<%=strLastRowSelect2 %>";
	
    lb_all_field.innerHTML          = lbl_field_search1
    lb_field_search.innerHTML       = lbl_field_search2
    lb_field_label.innerHTML        = lbl_field_label;
    lb_field_type_length.innerHTML  = lbl_field_type_length;
    lb_field_label2.innerHTML       = lbl_field_label;
    lb_field_type_length2.innerHTML = lbl_field_type_length;
    lb_change_field.innerHTML       = lbl_field_search6;
    
    if( lastRowSelect2 != "" ) {
    	rowSelected( "typeS", lastRowSelect2 );
    }else {
    	obj_fieldCode1Choose.value = "";
    	obj_fieldCode2Choose.value = "";
    	obj_hidFieldCode2.value    = "";
    	obj_hidFieldOrder.value    = "";
    }
}

function rowSelected( lv_isMain, lv_rowIndex, lv_strValue ) {
	var tbResultTable1 = document.getElementById("resultTable1");
	var tbResultTable2 = document.getElementById("resultTable2");
	
	if( lv_isMain == "main" ) {
            if( lv_strValue != null ) {
                obj_hidRowSelected1.value   = lv_rowIndex;
                obj_hidFieldCode1.value     = lv_strValue.getAttribute("FIELD_CODE");
                obj_indexSeqn.value         = lv_strValue.getAttribute("FIELD_SEQN");
                obj_hidRowSelected2.value   = "";
                obj_hidFieldCode2.value     = "";
                obj_hidFieldOrder.value     = "";
                obj_fieldOrder1Choose.value = "";
                obj_fieldCode1Choose.value  = "";
            }

            if( obj_last_row_select2.value != "" ) {
                    if( obj_last_row_select2.value % 2 != 0 ) {
                            tbResultTable2.rows[ obj_last_row_select2.value ].style.background = "#FFFFFF";
                    }else {
                            tbResultTable2.rows[ obj_last_row_select2.value ].style.background = "#f9eac7";
                    }
            }

            tbResultTable1.rows[ lv_rowIndex ].style.background = "#e2e9c8";
            if( obj_last_row_select1.value != lv_rowIndex ) {
                if( obj_last_row_select1.value != "" ) {
                    if( obj_last_row_select1.value % 2 != 0 ) {
                            tbResultTable1.rows[ obj_last_row_select1.value ].style.background = "#FFFFFF";
                    }else {
                            tbResultTable1.rows[ obj_last_row_select1.value ].style.background = "#f9eac7";
                    }
                }
            }
            obj_last_row_select1.value = lv_rowIndex; 
	}else {
		if( lv_strValue != null ) {
			obj_hidRowSelected2.value   = lv_rowIndex;
			obj_hidFieldCode2.value     = lv_strValue.getAttribute("FIELD_CODE");
			obj_hidFieldOrder.value     = lv_strValue.getAttribute("INDEX_ORDER");
			obj_fieldOrder1Choose.value = lv_rowIndex;
			obj_fieldCode1Choose.value  = lv_strValue.getAttribute("FIELD_CODE");
			obj_hidRowSelected1.value   = "";
			obj_hidFieldCode1.value     = "";
			obj_indexSeqn.value         = "";
		}
		
		if( obj_last_row_select1.value != "" ) {
			if( obj_last_row_select1.value % 2 != 0 ) {
				tbResultTable1.rows[ obj_last_row_select1.value ].style.background = "#FFFFFF";
			}else {
				tbResultTable1.rows[ obj_last_row_select1.value ].style.background = "#f9eac7";
			}
		}
		
		if( tbResultTable2.rows[ lv_rowIndex ] != null ) {
			tbResultTable2.rows[ lv_rowIndex ].style.background = "#e2e9c8";
		}
		
		if( obj_last_row_select2.value != lv_rowIndex ) {
			if( obj_last_row_select2.value != "" ) {
				if( obj_last_row_select2.value % 2 != 0 ) {
					tbResultTable2.rows[ obj_last_row_select2.value ].style.background = "#FFFFFF";
				}else {
					tbResultTable2.rows[ obj_last_row_select2.value ].style.background = "#f9eac7";
				}
			}
		}
		obj_last_row_select2.value = lv_rowIndex; 
	}
}

function setKeyField( lv_strMethod ) {
	switch( lv_strMethod ){
		case "set" :
			if( obj_hidFieldCode1.value == "" ) {
				alert( lc_checked_field_set_select );
				return;
			}
			isFieldSelect();
			break;
        case "unset" :
			if( obj_hidFieldCode2.value == "" ) {
				alert( lc_checked_field_set_select );
				return;
			}
			obj_last_row_select2.value = "";
			obj_mode.value             = "UNSETKEY";
			form1.submit();
			break;
	}
}

function isFieldSelect() {
	frameCheck.INDEX_CODE.value = obj_hidFieldCode1.value;
	frameCheck.INDEX_TYPE.value = "S";
	frameCheck.MODE.value       = "SEARCH";
    frameCheck.target           = "frameCheckedField";
    frameCheck.action           = "frame_is_field_select.jsp";
    frameCheck.submit();	
}

function afterCheckSelect( lv_result ) {
	if( lv_result == "true" ) {
		obj_last_row_select2.value = "";
		obj_mode.value             = "SETKEY";
		form1.submit();
	}else {
		alert( lc_this_field_selected_search_field );
	}
}

function moveField( lv_strMethod ) {
	var intOrder     = obj_fieldOrder1Choose.value;
	var strFieldCode = "";
	
	if( intOrder.length == 0 ) {
		alert( lc_checked_field_select );
		return;
	}
	switch( lv_strMethod ){
		case "up" :
			intOrder     = parseInt(intOrder - 1 );
			strFieldCode = document.getElementById("<%=fieldCode%>"+intOrder);
			if( strFieldCode == null ) {
				alert( lc_can_not_move_up_field_selected );
				return;
			}
			
			obj_fieldOrder2Choose.value = intOrder;
			obj_fieldCode2Choose.value  = strFieldCode.value;
			obj_mode.value              = "ORDER";
			obj_last_row_select2.value  = intOrder;
			form1.submit();
			break;
        case "down" :
			intOrder     = parseInt(intOrder) + parseInt( 1 );
			strFieldCode = document.getElementById("<%=fieldCode%>"+intOrder);
			if( strFieldCode == null ) {
				alert( lc_can_not_move_down_field_selected );
				return;
			}
			
			obj_fieldOrder2Choose.value = intOrder;
			obj_fieldCode2Choose.value  = strFieldCode.value;
			obj_mode.value              = "ORDER";
			obj_last_row_select2.value  = intOrder;
			form1.submit();
			break;
	}
}

function buttonClick( lv_strMethod ){	
    switch( lv_strMethod ){
		case "setIndex" :
			form1.action     = "field_manager4.jsp";
			form1.MODE.value = "SETINDEX";
			form1.submit();
			break;
        case "cancel" :
			form1.action     = "field_manager1.jsp";
			form1.target 	 = "_self";
		    form1.MODE.value = "SEARCH";
		    form1.submit();
			break;
	}
}

//-->
</script>
<link href="css/edas.css" type="text/css" rel="stylesheet">
</head>
<body onLoad="MM_preloadImages('images/btt_save2_over.gif','images/btt_indexsearch_over.gif','images/btt_back_over.gif');window_onload();">
<form name="form1" method="post" action="" >
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0" align="center">
  <tr>
    <td valign="top">
    	<table width="800" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td height="25" class="label_header01" colspan="4">&nbsp;&nbsp;<%=screenname%>&nbsp; >> &nbsp;<%=screenLabel %></td>
              </tr>
              <tr>
                	<td height="25" colspan="4">&nbsp;</td>
              </tr>
              <tr>
            	<td height="25" align="center">
    			<div id="screen_div" style="width:665px;height:350px;overflow-y:scroll;overflow-x:hidden;margin-right:0px;margin-bottom:0px;border:0px #ccc solid;" >
            		<table width="622" border="0" cellspacing="0" cellpadding="0">
		                <tr>
		                	<td height="25" class="label_bold2">&nbsp;</td>
		                	<td height="25" class="label_bold2">
		                		<span id="lb_all_field"></span>
			                </td>
		                	<td height="25" class="label_bold2">&nbsp;</td>
			                <td width="438" height="25" class="label_bold2">
			                	<span id="lb_field_search"></span>
			                </td>
	                	</tr>
	                	<tr>
	                		<td height="25" class="label_bold2"><span id="lb_field_type"></span></td>
			                <td height="25">
			                	<table id="resultTable1" width="300" border="0" cellpadding="0" cellspacing="0">
			                		<tr class="hd_table">
			                			<td width="10"><img src="images/hd_tb_01.gif" width="10" height="28"></td>
				                        <td width="150" align="left"><span id="lb_field_label"></span></td>
				                        <td width="130" align="left"><span id="lb_field_type_length"></span></td>
				                        <td align="right"><img src="images/hd_tb_04.gif" width="10" height="28"></td>
			                		</tr>
<%
    if( (bolnSuccess) ) {
        intSeq = 1;
        while( con.nextRecordElement() ){
            strFieldLabelData  = con.getColumn( "FIELD_LABEL" );
            strFieldTypeData   = con.getColumn( "FIELD_TYPE" );
            strFieldLengthData = con.getColumn( "FIELD_LENGTH" );
            strFieldSeqnData   = con.getColumn( "FIELD_SEQN" );
            strFieldCodeData   = con.getColumn( "FIELD_CODE" );
            
            strScript = "FIELD_SEQN=\"" + strFieldSeqnData + "\" FIELD_CODE=\"" + strFieldCodeData + "\" ";
			strScript += "FIELD_TYPE=\"" + strFieldTypeData + "\" FIELD_LENGTH=\"" + strFieldLengthData + "\" FIELD_LABEL=\"" + strFieldLabelData + "\" ";

            if( intSeq % 2 != 0 ) {
%>
									<tr class="table_data1" onclick="rowSelected('main',this.rowIndex,this)"<%=strScript%> >
				                        <td>&nbsp;</td>
				                        <td><div><%=strFieldLabelData %></div></td>
				                        <td colspan="2"><div><%=strFieldTypeData %>(<%=strFieldLengthData %>)</div></td>
				                    </tr>
<%
            }else{
%>
				                    <tr class="table_data2" onclick="rowSelected('main',this.rowIndex,this)"<%=strScript%> > 
				                        <td>&nbsp;</td>
				                        <td><div><%=strFieldLabelData %></div></td>
				                        <td colspan="2"><div><%=strFieldTypeData %>(<%=strFieldLengthData %>)</div></td>
				                    </tr>
<%
            }
            intSeq++;
        }
     }
%>
			                	</table>
			                </td>
			                <td>
			                	<table align="center">
			                		<tr>
			                			<td align="center">
			                				<div align="center">
				                				<a href="#" onclick= "setKeyField('set')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('right','','images/put_right.gif',1)">
								           			<img src="images/put_right.gif" name="right" width="26" height="19" border="0"></a>
								           	</div>
								           	<div align="center">
								           		<a href="#" onclick= "setKeyField('unset')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('left','','images/put_left.gif',1)">
								           			<img src="images/put_left.gif" name="left" width="26" height="19" border="0"></a>
								           	</div>
			                			</td>
			                		</tr>
			                	</table>
			                </td>			                
			                <td align="center" valign="top">
			                	<table id="resultTable2" width="300" border="0" cellpadding="0" cellspacing="0">
			                		<tr class="hd_table">
			                			<td width="10"><img src="images/hd_tb_01.gif" width="10" height="28"></td>
				                        <td width="150" align="left"><span id="lb_field_label2"></span></td>
				                        <td width="130" align="left"><span id="lb_field_type_length2"></span></td>
				                        <td align="right"><img src="images/hd_tb_04.gif" width="10" height="28"></td>
			                		</tr>
<%
    if( (bolnSuccess1) ) {
        intSeq = 1;
        while( con1.nextRecordElement() ){
            strFieldLabelTypeKData      = con1.getColumn( "FIELD_LABEL" );
            strFieldTypeTypeKData       = con1.getColumn( "FIELD_TYPE" );
            strFieldLengthTypeKData     = con1.getColumn( "FIELD_LENGTH" );
            strFieldSeqnTypeKData       = con1.getColumn( "FIELD_SEQN" );
            strFieldCodeTypeKData       = con1.getColumn( "FIELD_CODE" );
            strFieldIndexOrderTypeKData = con1.getColumn( "INDEX_ORDER" );
            
			strFieldCode = fieldCode + intSeq;
            strScript    = "FIELD_SEQN=\"" + strFieldSeqnTypeKData + "\" FIELD_CODE=\"" + strFieldCodeTypeKData + "\" ";
			strScript    += "FIELD_TYPE=\"" + strFieldTypeTypeKData + "\" FIELD_LENGTH=\"" + strFieldLengthTypeKData + "\" ";
			strScript    += "FIELD_LABEL=\"" + strFieldLabelTypeKData + "\" INDEX_ORDER=\"" + strFieldIndexOrderTypeKData + "\" ";

            if( intSeq % 2 != 0 ) {
%>
									<tr class="table_data1" onclick="rowSelected('typeK',this.rowIndex,this)"<%=strScript%> >
				                        <td>&nbsp;</td>
				                        <td><div><%=strFieldLabelTypeKData %></div></td>
				                        <td colspan="2">
				                        	<div><%=strFieldTypeTypeKData %>(<%=strFieldLengthTypeKData %>)</div>
				                        	<input type="hidden" id="<%=strFieldCode %>" name="<%=strFieldCode %>" value="<%=strFieldCodeTypeKData %>" >
				                        </td>
				                    </tr>
<%
            }else{
%>
				                    <tr class="table_data2" onclick="rowSelected('typeK',this.rowIndex,this)"<%=strScript%> > 
				                        <td>&nbsp;</td>
				                        <td><div><%=strFieldLabelTypeKData %></div></td>
				                        <td colspan="2">
				                        	<div><%=strFieldTypeTypeKData %>(<%=strFieldLengthTypeKData %>)</div>
				                        	<input type="hidden" id="<%=strFieldCode %>" name="<%=strFieldCode %>" value="<%=strFieldCodeTypeKData %>" >
				                        </td>
				                    </tr>
<%
            }
            intSeq++;
        }
     }
%>
			                	</table>
			                </td>
	                	</tr>
						<tr>
						  	<td align="right" colspan="4" class="label_bold2">
			                	<span id="lb_change_field"></span>&nbsp;&nbsp;
						  		<a href="#" onclick= "moveField('up')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('mv_up','','images/btt_up_over.gif',1)">
						  			<img id="mv_up" src="images/btt_up.gif" width="67" height="22" border="0" align="absmiddle"></a>
						  		<a href="#" onclick= "moveField('down')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('mv_down','','images/btt_down_over.gif',1)">
						  			<img id="mv_down" src="images/btt_down.gif" width="67" height="22" align="absmiddle" border="0"></a>
						  	</td>
						</tr>
			            <tr>
			            	<td>
					        <input type="hidden" id="MODE" name="MODE" value="<%=strMode%>">
		              			<input type="hidden" name="screenname"   value="<%=screenname%>">
                                                
		              			<input type="hidden" id="hidRowSelected1"  name="hidRowSelected1"  value="">
		              			<input type="hidden" id="hidFieldCode1"    name="hidFieldCode1"    value="">
		              			<input type="hidden" id="last_row_select1" name="last_row_select1" value="">
		              			
		              			<input type="hidden" id="hidRowSelected2"  name="hidRowSelected2"  value="">
		              			<input type="hidden" id="hidFieldCode2"    name="hidFieldCode2"    value="<%=strFieldCodeChooseData %>">
		              			<input type="hidden" id="hidFieldOrder"    name="hidFieldOrder"    value="<%=strFieldOrderChooseData %>">
		              			<input type="hidden" id="last_row_select2" name="last_row_select2" value="">		              			
		              			<input type="hidden" id="INDEX_SEQN"       name="INDEX_SEQN"       value="">
		              			
								<input type="hidden" id="PROJECT_CODE"        name="PROJECT_CODE"        value="<%=strProjectCode%>">
								<input type="hidden" id="FIELD_ORDER1_CHOOSE" name="FIELD_ORDER1_CHOOSE" value="<%=strLastRowSelect2 %>">
								<input type="hidden" id="FIELD_ORDER2_CHOOSE" name="FIELD_ORDER2_CHOOSE" value="">
								<input type="hidden" id="FIELD_CODE1_CHOOSE"  name="FIELD_CODE1_CHOOSE"  value="<%=strFieldCode1Choose %>">
								<input type="hidden" id="FIELD_CODE2_CHOOSE"  name="FIELD_CODE2_CHOOSE"  value="">
								
								<input type="hidden" name="user_role" value="<%=user_role %>">
								<input type="hidden" name="app_name"  value="<%=app_name %>">
								<input type="hidden" name="app_group" value="<%=app_group %>">
							</td>
						</tr>
              		</table>
              	</div>
            	</td>
            </tr>
         	<tr>
           		<td height="25" colspan="4">&nbsp;</td>
           	</tr>
           	<tr>
           		<td align="center" colspan="4">
           			<a href="#" onclick= "buttonClick('setIndex')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('setIndex','','images/btt_indexsearch_over.gif',1)">
           				<img src="images/btt_indexsearch.gif" name="setIndex"  height="22" border="0"></a>
           			<a href="#" onclick= "buttonClick('cancel')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('back','','images/btt_back_over.gif',1)">
           				<img src="images/btt_back.gif" name="back" width="67" height="22" border="0"></a>
           		</td>
           	</tr>
        </table>
        <p>&nbsp;</p>
      </td>
    </tr>
</table>
<iframe name="frameCheckedField" style="display:none;"></iframe>
</form>
<form id="frameCheck" name="frameCheck" method="post" action="">
<input type="hidden" name="MODE"         value="">
<input type="hidden" name="PROJECT_CODE" value="<%=strProjectCode%>">
<input type="hidden" name="INDEX_CODE"   value="">
<input type="hidden" name="INDEX_TYPE"   value="">
</form>

</body>
</html>
<script language="JavaScript" type="text/javascript">
<!--

var obj_mode             = document.getElementById("MODE");
var obj_hidRowSelected1  = document.getElementById("hidRowSelected1");
var obj_hidFieldCode1    = document.getElementById("hidFieldCode1");
var obj_last_row_select1 = document.getElementById("last_row_select1");

var obj_hidRowSelected2  = document.getElementById("hidRowSelected2");
var obj_hidFieldCode2    = document.getElementById("hidFieldCode2");
var obj_last_row_select2 = document.getElementById("last_row_select2");
var obj_hidFieldOrder    = document.getElementById("hidFieldOrder");

var obj_indexSeqn        = document.getElementById("INDEX_SEQN");

var obj_fieldOrder1Choose = document.getElementById("FIELD_ORDER1_CHOOSE");
var obj_fieldOrder2Choose = document.getElementById("FIELD_ORDER2_CHOOSE");
var obj_fieldCode1Choose  = document.getElementById("FIELD_CODE1_CHOOSE");
var obj_fieldCode2Choose  = document.getElementById("FIELD_CODE2_CHOOSE");

var obj_trFieldDefault      = document.getElementById("trFieldDefault");
var obj_imgZoomTableCode    = document.getElementById("imgZoomTableCode");
var obj_imgZoomDefaultValue = document.getElementById("imgZoomDefaultValue");
var obj_imgDefaultValue     = document.getElementById("imgDefaultValue");

//-->
</script>
<%  if (!strmsg.equals("")) {  %>
<script language="javaScript">
    <%=strmsg%>
</script>
<%  }   %>