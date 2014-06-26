package blaze.math 
{
	/**
	 * ...
	 * @author P.J.Shand
	 */
	public class Math2 
	{
		
		public function Math2() 
		{
			
		}
		
		public static function decimal(value:Number, dec:int):Number
		{
			var mul:int = Math.pow(10, dec);
			return int(value * mul) / mul;
		}
	}

}