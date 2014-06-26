package blaze.math 
{
	/**
	 * ...
	 * @author P.J.Shand
	 */
	public class Range 
	{
		public var min:Number;
		public var max:Number;
		
		public function Range(min:Number, max:Number) 
		{
			this.min = min;
			this.max = max;
		}
		
		public function get length():Number 
		{
			return max - min;
		}
		
	}

}