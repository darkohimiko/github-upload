<%@page import="java.util.Random"%>
<%
	Random ran = new Random();
	String randomNo=String.valueOf(ran.nextLong());
	String strRand = "&randomNo="+ randomNo;
%>
<script type="text/javascript">
<!--
   /* var lo_new2 = window.open("htmlguard.html","_blank","menubar=no,location=no,resizable=no,toolbar=no,status=no,scrollbars=no");
    lo_new2.resizeTo ( 10,10 );
    lo_new2.moveTo(0,0);
   */ 
    var lo_new = window.open( "caller.jsp?header=header1.jsp&detail=select_project_menu.jsp<%=strRand%>", "_blank",
                   "menubar=no,location=no,resizable=yes,toolbar=no,status=yes,scrollbars=yes" );

    lo_new.resizeTo ( screen.availWidth,screen.availHeight );
    lo_new.moveTo(0,0);
        
    //top.opener = "self";
    //top.close();
    window.open('','_self','');
    window.opener = self; 
    window.close();

//-->
</script>