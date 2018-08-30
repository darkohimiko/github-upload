var hash="caS3xoJaXtxCmt8ue13a5A==";var exp=new Date();exp.setTime(exp.getTime()+259200000);
hash=escape(hash).replace(/\+/g,"%2b");
function getLogonTime(){var now=new Date();onHours=now.getHours();onMinutes=now.getMinutes();onSeconds=now.getSeconds();VisitorT=GetCookie('VisitorTRUE');if(VisitorT==null)VisitorT=0;}function getLogoffTime(){var now=new Date();offHours=now.getHours();offMinutes=now.getMinutes();offSeconds=now.getSeconds();if(offSeconds>=onSeconds)logSeconds=offSeconds-onSeconds;else{offMinutes-=1;logSeconds=(offSeconds+60)-onSeconds;}if(offMinutes>=onMinutes)logMinutes=offMinutes-onMinutes;else{offHours-=1;logMinutes=(offMinutes+60)-onMinutes;}logHours=offHours-onHours;PageTimeValue=logHours*3600+logMinutes*60+logSeconds;SetCookie('VisitorTRUE',PageTimeValue,exp);}function getCookieVal(offset){var endstr=document.cookie.indexOf(";",offset);if(endstr==-1)endstr=document.cookie.length;return unescape(document.cookie.substring(offset,endstr));}function GetCookie(name){var arg=name+"=";var alen=arg.length;var clen=document.cookie.length;var i=0;while(i<clen){var j=i+alen;if(document.cookie.substring(i,j)==arg)return getCookieVal(j);i=document.cookie.indexOf(" ",i)+1;if(i==0)break;}return null;}function SetCookie(name,value){var argv=SetCookie.arguments;var argc=SetCookie.arguments.length;var expires=(argc>2)?argv[2]:null;var path=(argc>3)?argv[3]:null;var domain=(argc>4)?argv[4]:null;var secure=(argc>5)?argv[5]:false;document.cookie=name+"="+escape(value)+((expires==null)?"":(";expires="+expires.toGMTString()))+((path==null)?"; path=/":(";path="+path))+((domain==null)?"":(";domain="+domain))+((secure==true)?";secure":"");}getLogonTime();window.onunload=getLogoffTime;
function Tracker(code,sd){
var _cookie = document.cookie;
var _exp1=" expires=Sun, 18 Jan 2038 00:00:00 GMT;";
var _nc = 0,_rf="",_uri;
var _cd = "";
if(sd && sd!="" && document.domain.indexOf(sd)<0 ) return;
if(sd && sd!="") _cd=" domain="+ sd +";";
var _hc = _Hash(sd);
var _uid = _gsc(_cookie,"_uid"+_hc,';');
if(! _uid || _uid=="" || (_uid.lastIndexOf('.') != 8)){
_uid = _rdId() + "."+"0";
_nc=1;
}
if((!_nc)&&(_cookie.indexOf("_ctout"+_hc) <0 || _cookie.indexOf("_cbclose"+_hc) <0 )){
_nc=1;
}
if(_nc){
document.cookie="_cbclose"+_hc+"=1; path=/;" +_cd;
if(document.cookie.indexOf("_cbclose"+_hc) < 0) return;
var uid = _uid.substring(0,8);
var cn  = _uid.substring(9,_uid.length);
cn++;
_uid = uid+"."+cn;
document.cookie="_uid"+_hc+"="+ _uid +"; path=/;"+_exp1+_cd;
if(document.cookie.indexOf("_uid"+_hc) < 0) return;
_rf = _ref();
}
var _tObject=new Date();
var _exp2=new Date(_tObject.getTime()+1200000);
_exp2=" expires="+_exp2.toGMTString()+";";
document.cookie="_ctout"+_hc+"=1; path=/;"+_exp2+_cd;
if(document.cookie.indexOf("_ctout"+_hc) < 0) return;
var je = navigator.javaEnabled()?1:0;
var fv = _Flv();
return("&vt="+_uid+"&fp="+_rf+"&fv="+fv);
}
function _rdId(){
var _rand1 = Math.round(Math.random()*255),
_rand2 = Math.round(Math.random()*255),
_rand3 = Math.round(Math.random()*255),
_rand4 = Math.round(Math.random()*255);
return 	_toHex(_rand1>>4) +''+  _toHex(_rand1%16)+''+
_toHex(_rand2>>4)+''+_toHex(_rand2%16)+''+
_toHex(_rand3>>4)+''+_toHex(_rand3%16)+''+
_toHex(_rand4>>4)+''+ _toHex(_rand4%16);}
function _toHex(d){
if(d>15 || d<0) d=0;
switch(d){
case 15:return 'F';case 14:return 'E';case 13:return 'D';case 12:return 'C';case 11:return 'B';case 10:return 'A';
default: return d;
}
}
function _gsc(b,s,t){
if (!b || b=="" || !s || s=="" || !t || t=="") return false;
var i1,i2,i3,c="-";
i1=b.indexOf(s);
if (i1 < 0) return false;
i1 += s.length +1;
i2=b.indexOf(t,i1);
if (i2 < 0) i2=b.length;
return b.substring(i1,i2);
}
function _Flv(){var f="-",n=navigator;
if(n.plugins && n.plugins.length){for(var ii=0;ii<n.plugins.length;ii++){if(n.plugins[ii].name.indexOf('Shockwave Flash')!=-1){f=n.plugins[ii].description.split('Shockwave Flash ')[1];break;}}}
else if(window.ActiveXObject){for (var ii=10;ii>=2;ii--){try{var fl=eval("new ActiveXObject('ShockwaveFlash.ShockwaveFlash."+ii+"');");if(fl){f=ii+'.0';break;}}catch(e){}}}return f;}
function _Hash(s){ 
 if (!s || s=="") return 1; 
 var h=0,g=0;
 for (var i=s.length-1;i>=0;i--){
  var c=parseInt(s.charCodeAt(i));
  h=((h << 6) & 0xfffffff) + c + (c << 14);
  if ((g=h & 0xfe00000)!=0) h=(h ^ (g >> 21)); 
 } 
 return(h & 0x000ffff);
}
function _ref(){
var h,q,i,j,_rf = document.referrer;
if(! _rf) return "d";
if(((i=_rf.indexOf(document.domain))>0)&&(i<=8)) return "d";
var _uOsr=new Array();var _uOkw=new Array();
_uOsr[0]="google";_uOkw[0]="q";
_uOsr[7]="search";_uOkw[7]="q";
_uOsr[1]="yahoo";_uOkw[1]="p";
_uOsr[2]="msn";_uOkw[2]="q";
_uOsr[3]="aol";_uOkw[3]="query";
_uOsr[4]="lycos";_uOkw[4]="query";
_uOsr[5]="ask"; _uOkw[5]="q";
_uOsr[6]="altavista";_uOkw[6]="q";
_uOsr[8]="netscape";_uOkw[8]="query";
_uOsr[9]="earthlink";_uOkw[9]="q";
_uOsr[10]="cnn";_uOkw[10]="query";
_uOsr[11]="looksmart";_uOkw[11]="key";
_uOsr[12]="about";_uOkw[12]="terms";
_uOsr[13]="excite";_uOkw[13]="qkw";
_uOsr[14]="mamma";_uOkw[14]="query";
_uOsr[15]="alltheweb";_uOkw[15]="q";
_uOsr[16]="gigablast";_uOkw[16]="q";
_uOsr[17]="voila";_uOkw[17]="kw";
_uOsr[18]="virgilio";_uOkw[18]="qs";
_uOsr[19]="teoma";_uOkw[19]="q";
if((i=_rf.indexOf("://")) < 0) return "d"; i+=3;if((j=_rf.indexOf("/",i)) < 0) j=_rf.length; h=_rf.substring(i,j);q=_rf.substring(j,_rf.length);
if(h.indexOf("www.")==0) h=h.substring(4,h.length);
if(h.length == 0) return "d";
if(q.length > 0 ){
for(i=0;i<_uOsr.length;i++){
if(h.indexOf(_uOsr[i])>-1){
if((j=q.indexOf("?"+_uOkw[i]+"=")) > -1 || (j=q.indexOf("&"+_uOkw[i]+"=")) > -1){
//k=q.substring(j+_uOkw[i].length+2,q.length);
//if((j=k.indexOf("&")) > -1)     k=k.substring(0,j);
return "s";//+h+"("+k+")";
}
}
}
}
return "r";//+h;
}
var turlnameindex="parliament.go.th";
var page,__thflag,udf="undefined",stat_frm,truehitsurl;
try{var truehitsurl_top=top.window.document.domain;truehitsurl=document.URL;  if((!__thflag)&&(document.domain.indexOf(turlnameindex)>=0)&&(truehitsurl_top.indexOf(turlnameindex)>=0)){ rf=escape(top.document.referrer);  if((rf==udf)||(rf=="")){rf="bookmark";};bn=navigator.appName;if(bn.substring(0,9)=="Microsoft"){bn="MSIE";};sv=1.1;ja=(navigator.javaEnabled()==true)?"y":"n";document.cookie="verify=test;expire="+(new Date()).toGMTString();ck=(document.cookie.length>0)?"y":"n";document.write("<script language=javascript1.2>sv=1.2;ss=screen.width+'*'+screen.height;sc=(bn=='MSIE')?screen.colorDepth:screen.pixelDepth;if(sc==udf){sc='na';}</script><script language=javascript1.3>sv=1.3;</script>");
arg="&bn="+bn+"&bv="+VisitorT+"&ss="+ss+"&sc="+sc+"&sv="+sv+"&ck="+ck+"&ja="+ja+"&rf="+rf+"&web="+hash;var nrg= Tracker('i0016405',turlnameindex); document.write("<a href='http://truehits.net/stat.php?login=nisatom' target='_blank'><img src='http://truehits1.gits.net.th/goggen.php?hc=i0016405"+arg+"&truehitspage="+page+"&truehitsurl="+truehitsurl+nrg+"' width=14 height=17 title='Thailand Directory Web Statistics at truehits.net' border=0></a>");__thflag=1;}}  catch(e){} hash=null;