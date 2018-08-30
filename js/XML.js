function XML(){

	this.clearXML = gm_voidClearXML;
	this.getXMLString = gm_strGetXMLString;
	this.getNode = gm_objGetNode;
	this.getNodeValue = gm_strGetNodeValue;
	this.setNode = gm_voidSetNode;
	this.addChildNode = gm_voidAddChildNode;
	this.loadXML = gm_voidLoadXML;



	var strXMLString = "";
	var objXmlDom  = new ActiveXObject('Microsoft.XMLDOM'); 



	function gm_voidClearXML(){
		strXMLString = "";
		objXmlDom = new ActiveXObject('Microsoft.XMLDOM'); 
	}


	function gm_strGetXMLString(){
		return objXmlDom.xml;
	}


	function gm_voidSetNode( strNodeName , strNodeValue , strNodeParent , strNodeSeq ){
		var objNode;
		var objParentNode;
		var intNodeSeq;

		if( strNodeParent == null || strNodeParent == "" ){
			objParentNode = objXmlDom;
		}else{
			objParentNode = objXmlDom.getElementsByTagName( strNodeParent );
			if( !objParentNode.length ){
				return;
			}
		}

		if( strNodeSeq == null || strNodeSeq == "" ){
			strNodeSeq = "0";
		}

		intNodeSeq = parseInt( strNodeSeq );

		gm_voidAddChildNode( objParentNode , strNodeName , strNodeValue , intNodeSeq );
	}


	function gm_objGetNode( strNodeName , intNodeSeq ){
		var objParentNode;

		if( strNodeName == "" ){  return null; }
		if( intNodeSeq == null ){ intNodeSeq = 0; }

		var objParentNode = objXmlDom.getElementsByTagName( strNodeName );

		return objParentNode;
	}

	function gm_strGetNodeValue( strNodeName , intNodeSeq ){
		var strNodeValue = "";
		var objNode = gm_objGetNode( strNodeName , intNodeSeq );

		if( objNode != null && objNode.item( intNodeSeq ) ){
			strNodeValue = objNode.item( intNodeSeq ).text;
		}

		return strNodeValue;
	}

	function gm_voidAddChildNode( objNode , strNodeName , strNodeValue , intNodeSeq ){
		var objParentNode = objXmlDom.createElement( strNodeName );

		if( strNodeName == "" ){  return false; }
		if( strNodeValue != null ){
			objParentNode.text = strNodeValue;
		}

		if( objNode.length ){
			objNode.item( intNodeSeq ).appendChild( objParentNode );
		}else{
			objNode.appendChild( objParentNode );
		}
	}

	function gm_voidLoadXML( strXML ){
		objXmlDom.loadXML( strXML );
	}

}

function hg_noprint(){return true};