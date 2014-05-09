package blaze.utils 
{
	/**
	 * ...
	 * @author P.J.Shand
	 */
	public class StringUtils 
	{
		
		public function StringUtils() 
		{
			
		}
		
		public static function getFileType(value:String):String
		{
			var split:Array = value.split('.');
			return String(split[split.length-1]).substr(0, 3).toLowerCase();
		}
	}

}