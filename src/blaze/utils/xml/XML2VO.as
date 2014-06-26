package blaze.utils.xml
{
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	/**
	 * ...
	 * @author P.J.Shand
	 */
	public class XML2VO 
	{
		
		public function XML2VO() 
		{
			
		}
		
		public static function map(xml:XML, vo:*):void
		{
			var voXML:XML = describeType(vo);
			var numVars:int = voXML.variable.length();
			
			var property:String;
			var type:String;
			var value:String;
			
			for (var i:int = 0; i < numVars; i++) 
			{
				property = voXML.variable[i].@name;
				type = voXML.variable[i].@type;
				value = setFrom(property, xml);
				
				if (value == '') continue;
				setVars(type, property, value, vo);
			}
			
			var numAccessors:int = voXML.accessor.length();
			for (var j:int = 0; j < numAccessors; j++) 
			{
				if (String(voXML.accessor[j].@access).toLowerCase().indexOf('write') == -1) {
					continue;
				}
				property = voXML.accessor[j].@name;
				type = voXML.accessor[j].@type;
				value = setFrom(property, xml);
				if (value == '') continue;
				setVars(type, property, value, vo);
			}
			
		}
		
		private static function setVars(type:String, property:String, value:String, vo:*):void 
		{
			var vectorType:String;
			if (type.indexOf("__AS3__.vec") != -1) {
				vectorType = type;
				type = 'Vector';
			}
			
			switch(type)
			{
				case 'String':
					vo[property] = String(value);
					break;
				case 'int':
					vo[property] = int(value);
					break;
				case 'Boolean':
					if (value.toUpperCase() == 'TRUE') vo[property] = true;
					else if (value.toUpperCase() == 'FALSE') vo[property] = false;
					break;
				case 'Number':
					vo[property] = Number(value);
					break;
				case 'uint':
					vo[property] = uint(value);
					break;
				case 'XML':
					vo[property] = XML(value);
					break;
				case 'Array':
					vo[property] = String(value).split(", ").join(",").split(",");
					break;
				case 'Vector':
					var VectorClass:Class = Class(getDefinitionByName(vectorType));
					var vecSplit:Array = value.split(",");
					var vec:* = new VectorClass(false);
					for (var j:int = 0; j < vecSplit.length; j++) {vec.push(vecSplit[j]);}
					vo[property] = vec;
					break;
				default:
					trace("unrecognized config type:", type, property, value);
			}
		}
		
		private static function setFrom(property:String, data:*):String 
		{
			if (String(data[property]) != "") {
				return String(data[property]);
			}
			else if (String(data.@[property]) != "") {
				return String(data.@[property]);
			}
			
			var children:XMLList = data.children();
			for (var i:int = 0; i < children.length(); i++) 
			{
				setFrom(property, XMLList(children[i]));
			}
			return '';
		}
	}
}