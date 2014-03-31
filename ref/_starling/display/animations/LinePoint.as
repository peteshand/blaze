package imag.masdar.core.view.starling.display.animations 
{
	/**
	 * ...
	 * @author Tom Byrne
	 */
	public class LinePoint 
	{
		public var x:Number;
		public var y:Number;
		public var colour:uint;
		
		public function LinePoint(x:Number=NaN, y:Number=NaN, colour:uint=0) 
		{
			this.x = x;
			this.y = y;
			this.colour = colour;
		}
		
		public function toString():String {
		return "[LinePoint x:" + x + " y:" + y + "]";
		}
	}

}