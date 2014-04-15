package blaze.model.viewPort 
{
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Michal Moczynski
	 */
	public class ViewportPoint extends Object 
	{
		public var updateCallback:Function;
		private var point:Point
		
		public function ViewportPoint(x:Number=0, y:Number=0) 
		{
			point = new Point(x, y);
		}
		
		public function get x():Number 
		{
			return point.x;
		}
		
		public function set x(value:Number):void 
		{
			point.x = value;
			updateCallback.call();
		}
		
		public function get y():Number 
		{
			return point.y;
		}
		
		public function set y(value:Number):void 
		{
			point.y = value;
			updateCallback.call();
		}
		
		public function setTo(x:Number, y:Number):void
		{
			point.setTo(x, y);
			updateCallback.call();
		}
		
	}

}