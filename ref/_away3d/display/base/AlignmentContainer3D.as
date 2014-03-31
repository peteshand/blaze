package imag.masdar.core.view.away3d.display.base 
{
	import away3d.containers.ObjectContainer3D;
	import com.greensock.TweenLite;
	import flash.events.Event;
	import flash.geom.Point;
	import imag.masdar.core.utils.layout.Alignment;
	import imag.masdar.core.view.away3d.display.base.alignment.LocationContainer3D;
	/**
	 * ...
	 * @author Pete Shand
	 */
	public class AlignmentContainer3D extends TouchContainer3D 
	{
		public var locationContainers:Vector.<LocationContainer3D> = new Vector.<LocationContainer3D>();
		
		public function AlignmentContainer3D() 
		{
			super();
		}
		
		protected function addChildAtAlignment(child:ObjectContainer3D, alignment:String):ObjectContainer3D
		{
			if (alignment == Alignment.TOP_LEFT)	 return addChildAtPoint(child, new Point(0,0));
			if (alignment == Alignment.TOP)			 return addChildAtPoint(child, new Point(0.5,0));
			if (alignment == Alignment.TOP_RIGHT)	 return addChildAtPoint(child, new Point(1,0));
			if (alignment == Alignment.LEFT)		 return addChildAtPoint(child, new Point(0,0.5));
			if (alignment == Alignment.MIDDLE)		 return addChildAtPoint(child, new Point(0.5,0.5));
			if (alignment == Alignment.RIGHT)		 return addChildAtPoint(child, new Point(1,0.5));
			if (alignment == Alignment.BOTTOM_LEFT)	 return addChildAtPoint(child, new Point(0,1));
			if (alignment == Alignment.BOTTOM)		 return addChildAtPoint(child, new Point(0.5,1));
			if (alignment == Alignment.BOTTOM_RIGHT) return addChildAtPoint(child, new Point(1,1));
			return addChild(child);
		}
		
		public function addChildAtPoint(child:ObjectContainer3D, location:Point):ObjectContainer3D
		{
			var locationContainer3D:LocationContainer3D = new LocationContainer3D(child, location);
			addChild(locationContainer3D);
			locationContainers.push(locationContainer3D);
			addResizeListener();
			return locationContainer3D.child;
		}
	}
}