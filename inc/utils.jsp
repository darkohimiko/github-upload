<%@page import="java.util.regex.Pattern"%>
<%@ page import="java.util.Calendar"%>
<%!
	String strVersionLang = "thai";
	String strAdFlag      = "off";

    public String monthThai(int monthIndex)
    {
                String monthDisplay1 = "";
                switch ( monthIndex ) {
                  case 1:monthDisplay1 = lc_Jan;
                                break;
                  case 2:monthDisplay1 = lc_Feb;
                                break;
                  case 3 : monthDisplay1 = lc_Mar;
                                break;
                  case 4 : monthDisplay1 = lc_Apr;
                                break;
                  case 5 : monthDisplay1 = lc_May;
                                break;
                  case 6 : monthDisplay1 = lc_Jun;
                                break;
                  case 7 : monthDisplay1 = lc_Jul;
                                break;
                  case 8: monthDisplay1 = lc_Aug;
                                break;
                  case 9 : monthDisplay1 = lc_Sep;
                                break;
                  case 10:  monthDisplay1 = lc_Oct;
                                break;
                  case 11:	monthDisplay1 = lc_Nov;
                                break;
                  case 12:	monthDisplay1 = lc_Dec;
                                break;
                  default :	monthDisplay1 = lc_not_define;
                                break;
                }
                return monthDisplay1;
    }
    
    public String functionName(String function_aval){
       String  functionName = "";
       if (function_aval.equals("insert")){
           //functionName = "????????????";
           functionName = lc_insert_data;
       }else if (function_aval.equals("update")){
               //functionName = "???????????";
           functionName = lc_update_data;
       }else if (function_aval.equals("delete")){
               //functionName = "????????";
           functionName = lc_delete_data;
       }else if (function_aval.equals("search")){
               //functionName = "????????????";
           functionName = lc_search_data;
       }else if (function_aval.equals("import")){
                //functionName = "????????????/???";
           functionName = lc_import_data;
       }else if (function_aval.equals("export")){
             //functionName = "????????????/???";
           functionName = lc_export_data;
       }else if (function_aval.equals("modImg")){
                //functionName = "?????/?????/?????";
           functionName = lc_modImg;
       }else if (function_aval.equals("prnImg")){
                //functionName = "????????";
           functionName = lc_prnImg;
       }else if (function_aval.equals("delImg")){
                //functionName = "?????";
           functionName = lc_delImg;
       }else if (function_aval.equals("censor")){
                //functionName = "????? Censor Zone";
           functionName = lc_censor;
       }else if (function_aval.equals("anot")){
                //functionName = "????? Annotation ??? Note";
           functionName = lc_anot;
       }else if (function_aval.equals("link")){
                //functionName = "?????????";
           functionName = lc_link;
       }else{
           functionName = function_aval;
       }
        return  functionName;
   }


    public String getTodayDate(){
        java.util.Calendar calendar = java.util.Calendar.getInstance();
        int intYear = calendar.get( calendar.YEAR );
        int intMonth = calendar.get( calendar.MONTH );
        int intDate = calendar.get( calendar.DATE );

        if(intYear > 2500){
        	intYear -=  543;
        }
        String strYear = String.valueOf( intYear );
        String strMonth = String.valueOf( intMonth + 1);
        String strDate = String.valueOf( intDate );

        if( strMonth.length() == 1 ){
            strMonth = "0" + strMonth;
        }
        if( strDate.length() == 1 ){
            strDate = "0" + strDate;
        }

        return strYear + strMonth + strDate;
    }

    public String getTodayDateThai(){
        java.util.Calendar calendar = java.util.Calendar.getInstance();
        int intYear = calendar.get( calendar.YEAR );
        int intMonth = calendar.get( calendar.MONTH );
        int intDate = calendar.get( calendar.DATE );

        if(intYear < 2500){
        	intYear +=  543;
        }	
        String strYear = String.valueOf( intYear );
        String strMonth = String.valueOf( intMonth + 1);
        String strDate = String.valueOf( intDate );

        if( strMonth.length() == 1 ){
            strMonth = "0" + strMonth;
        }
        if( strDate.length() == 1 ){
            strDate = "0" + strDate;
        }

        return strYear + strMonth + strDate;
    }

    public String dateToDisplay( String strDateValue , String strSeperate ){
        if( strDateValue.equals( "" ) ){
            return "";
        }
        if( strDateValue.length() != 8 ){
            return strDateValue;
        }

        String strYear = strDateValue.substring( 0 , 4 );
        String strMonth = strDateValue.substring( 4 , 6 );
        String strDate = strDateValue.substring( 6 , 8 );

        return strDate + strSeperate + strMonth + strSeperate + strYear;

    }


    public String dateToDisplay( String strDateValue ){
        if( strDateValue.equals( "" ) ){
            return "";
        }
        int intYear = Integer.parseInt( strDateValue.substring( 0 , 4 ) );
        int intMonth = Integer.parseInt( strDateValue.substring( 4 , 6 ) );
        int intDate = Integer.parseInt( strDateValue.substring( 6 , 8 ) );

        if( strVersionLang.equals("thai") ) {
	        if( intYear < 2500 ){
	            intYear += 543;
	        }
        }else if( strVersionLang.equals("eng") ) {
        	if( intYear > 2500 ){
	            intYear -= 543;
	        }
        }

        String strYear = String.valueOf( intYear );
        String strMonth = monthThai( intMonth );
        String strDate = String.valueOf( intDate );

        return strDate + " " + strMonth + " " + strYear;
    }

    public String todayDateDisplay(){
        java.util.Calendar calendar = java.util.Calendar.getInstance();
        int intYear = calendar.get( calendar.YEAR );
        int intMonth = calendar.get( calendar.MONTH );
        int intDate = calendar.get( calendar.DATE );

        String strYear = String.valueOf( intYear );
        String strMonth = String.valueOf( intMonth + 1);
        String strDate = String.valueOf( intDate );

        if( strMonth.length() == 1 ){
            strMonth = "0" + strMonth;
        }
        if( strDate.length() == 1 ){
            strDate = "0" + strDate;
        }

        return dateToDisplay( strYear + strMonth + strDate );
    }

    

    public String getField( String strValue ){
        if( strValue == null ){
            return "";
        }
        try {
            strValue = new String(strValue.getBytes("ISO8859_1"),"TIS620");
        } catch (java.io.UnsupportedEncodingException e) {
            e.printStackTrace();  //To change body of catch statement use Options | File Templates.
        }
        return strValue;
    }

    public String checkNull(Object strValue){
        
        String strRetVal = "";
        
        if (strValue==null)
            strRetVal = "";
        else
           strRetVal = (String)strValue;
        
        strRetVal = strRetVal.replaceAll("'", "");
        strRetVal = strRetVal.replaceAll("\"", "");
        
        return strRetVal;
   }


    public boolean checkExpire_date(String strExpire_Days, String change_date, String current_date)
    {
            int day_expire =  Integer.parseInt(strExpire_Days);
            int doc_day		 = Integer.parseInt(change_date.substring(6,8));
            int doc_month = Integer.parseInt(change_date.substring(4,6));
            doc_month		 = doc_month - 1;
            int doc_year	 = Integer.parseInt(change_date.substring(0,4));

			if( day_expire == 0 ){
				return true;
			}

            java.util.Calendar c = java.util.Calendar.getInstance();
            c.set(java.util.Calendar.DAY_OF_MONTH, doc_day);
            c.set(java.util.Calendar.MONTH, doc_month);
            c.set(java.util.Calendar.YEAR, doc_year);
            c.add(java.util.Calendar.DAY_OF_MONTH, day_expire);

             String day = String.valueOf(c.get(java.util.Calendar.DAY_OF_MONTH));
             if(day.length() != 2)
             {
                day = '0' + day;
             }
             String month = String.valueOf(c.get(java.util.Calendar.MONTH));
             if(month.length() != 2)
             {
                month = '0' + month;
             }

             String year = String.valueOf(c.get(java.util.Calendar.YEAR));
             String expire_date = year+month+day;
             int expire_date_int	= Integer.parseInt(expire_date);
             int current_date_int	= Integer.parseInt(current_date);

             if(expire_date_int < current_date_int)
             {
                return false;
             }
             return true;
    }

    public static String[] split(String str, String separator){
        if (str.equals("")) return new String[]{""};
        java.util.StringTokenizer token=new java.util.StringTokenizer(str, separator);
        String[] group = new String[token.countTokens()];
        int i = 0;
        while (token.hasMoreElements()) {
            group[i] = (String) token.nextElement();
            i++;
        }
        return group;
    }

    public String replace(String s, String one, String another) {
        // In a string replace one substring with another
          if (s==null) return "";
          if (s.equals("")) return "";
          String res = "";
          int i = s.indexOf(one,0);
          int lastpos = 0;
          while (i != -1) {
            res += s.substring(lastpos,i) + another;
            lastpos = i + one.length();
            i = s.indexOf(one,lastpos);
          }
          res += s.substring(lastpos);  // the rest
          return res;
   }

   public String dateToDB(String dateScreen){
        String dateDB;
        dateDB=replace(dateScreen,"/","");
        if (dateDB.length()!=8) return "";

        return dateDB.substring(4,8)+dateDB.substring(2,4)+dateDB.substring(0,2);

    }

   private static String[] getServerDate() {
        Calendar cal = Calendar.getInstance();
        String sDay,sMonth,sYear;
        if (cal.get(cal.DATE) < 10)
            sDay = "0" + String.valueOf(cal.get(cal.DATE));
        else
            sDay = String.valueOf(cal.get(cal.DATE));
        if (cal.get(cal.MONTH) < 9)
            sMonth = "0" + String.valueOf(cal.get(cal.MONTH) + 1);
        else
            sMonth = String.valueOf(cal.get(cal.MONTH) + 1);

        sYear = String.valueOf(Calendar.getInstance().get(Calendar.YEAR));
        String[] sRet = {sDay,sMonth,sYear};
        return sRet;
    }

    public static String getServerDateThai() {
		String[] date = getServerDate();
        int year = Integer.parseInt(date[2]);

		if (year < 2500)
			year += 543;

        return String.valueOf(year) + date[1] + date[0];
	}

    public static String getServerDateEng() {
		String[] date = getServerDate();
        int year = Integer.parseInt(date[2]);

		if (year > 2500)
			year -= 543;

        return String.valueOf(year) + date[1] + date[0];
	}


    public String setComma(String strValue){
    java.text.DecimalFormat doubleFormat = new java.text.DecimalFormat("###,##0.00");
    return doubleFormat.format( Double.parseDouble( strValue ) );
    }

     public String setCommaNoDot(String strValue){
    java.text.DecimalFormat doubleFormat = new java.text.DecimalFormat("###,##0");
    return doubleFormat.format( Double.parseDouble( strValue ) );
    }

    public int calculaNumDate(String startDate, String endDate){
		int     stDay     = Integer.parseInt(startDate.substring(6,8));
		int     stMonth   = Integer.parseInt(startDate.substring(4,6));
		int     stYear    = Integer.parseInt(startDate.substring(0,4));
		int     edDay     = Integer.parseInt(endDate.substring(6,8));
		int     edMonth   = Integer.parseInt(endDate.substring(4,6));
		int     edYear    = Integer.parseInt(endDate.substring(0,4));
		int     totNumDay = 0;
		int     result    = 0;

		if (stYear == edYear){
			if (stMonth != edMonth){
				for (int i = stMonth; i < edMonth; i++){
					totNumDay += getNumDayOfMonth(stYear,i);
				}
				result = (totNumDay + edDay) - stDay;
			}else{
				result = edDay - stDay;
			}
		}else{
			if (edYear - stYear == 1){
				for (int i = stMonth; i < 12; i++){
					totNumDay += getNumDayOfMonth(stYear,i);
				}
				for (int j = 0; j < edMonth; j++){
					totNumDay += getNumDayOfMonth(edYear,j);
				}

				result = ((totNumDay + edDay) - stDay) + 1;
			}else if (edYear - stYear > 1){
			//	System.out.println("Comming soon");
				result = 266;
			}
		}

		return result;
	}

    public int getNumDayOfMonth(int year, int month){
		int  numDay = 0;
		if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12 ){
			numDay = 31;
		}else if (month == 2 ){
			if (year%4 == 3){
				numDay = 29;
			}else{
				numDay = 28;
			}
		}else{
			numDay = 30;
		}

		return numDay;
	}

	public String getAdFlag() {
         return strAdFlag;

	}
        
        public boolean isNumeric(String str){
          Pattern pattern = Pattern.compile(".*[^0-9].*");
          
          return !pattern.matcher(str).matches();
        }

%>