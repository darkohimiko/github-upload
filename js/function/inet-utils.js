function set_inet_permission( av_strPermission ){
    var av_strRemoveToolBar = "";

    if( av_strPermission.indexOf( "modImg" ) == -1 ){
        av_strRemoveToolBar += "Open File Ctrl+O,Scan Ctrl+A,";
    }
    if( av_strPermission.indexOf( "delImg" ) == -1 ){
        av_strRemoveToolBar += "deleteImage,";
    }
    if(( av_strPermission.indexOf( "delImg" ) == -1 ) && ( av_strPermission.indexOf( "modImg" ) == -1 )){
        av_strRemoveToolBar += "saveImageToServer,";
    }
    if( av_strPermission.indexOf( "prnImg" ) == -1 ){
        av_strRemoveToolBar += "printImage,selectForPrint,Save Image Change,";
    }
    if( av_strPermission.indexOf( "censor" ) == -1 && av_strPermission.indexOf( "anot" ) == -1 ){
        av_strRemoveToolBar += "Annotation,";
    }else if( av_strPermission.indexOf( "censor" ) == -1 ){
        av_strRemoveToolBar += "Annotation.Sensor Zone,";
    }else  if( av_strPermission.indexOf( "anot" ) == -1 ){
        av_strRemoveToolBar += "Annotation.Notation,";
    }
    
    return av_strRemoveToolBar;
}
