package imag.masdar.core.view.starling.display.base 
{
	import com.greensock.TweenLite;
	import flash.geom.Point;
	import imag.masdar.core.utils.layout.Alignment;
	import imag.masdar.core.view.starling.display.base.alignment.LocationSprite;
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.events.Event;
	
	/**
	 * ...
	 * @author Pete Shand
	 */
	public class AlignmentSprite extends TouchSprite 
	{
		private var locationContainers:Vector.<LocationSprite> = new Vector.<LocationSprite>();
		
		public function AlignmentSprite()
		{
			super();
		}
		
		public function addChildAtAlignment(child:DisplayObject, alignment:String, scaleToScreen:Boolean=false):DisplayObject
		{
			if (alignment == Alignment.TOP_LEFT)	 return addChildAtPoint(child, new Point(0,0), scaleToScreen);
			if (alignment == Alignment.TOP)			 return addChildAtPoint(child, new Point(0.5,0), scaleToScreen);
			if (alignment == Alignment.TOP_RIGHT)	 return addChildAtPoint(child, new Point(1,0), scaleToScreen);
			if (alignment == Alignment.LEFT)		 return addChildAtPoint(child, new Point(0,0.5), scaleToScreen);
			if (alignment == Alignment.MIDDLE)		 return addChildAtPoint(child, new Point(0.5,0.5), scaleToScreen);
			if (alignment == Alignment.RIGHT)		 return addChildAtPoint(child, new Point(1,0.5), scaleToScreen);
			if (alignment == Alignment.BOTTOM_LEFT)	 return addChildAtPoint(child, new Point(0,1), scaleToScreen);
			if (alignment == Alignment.BOTTOM)		 return addChildAtPoint(child, new Point(0.5,1), scaleToScreen);
			if (alignment == Alignment.BOTTOM_RIGHT) return addChildAtPoint(child, new Point(1,1), scaleToScreen);
			return addChild(child);
		}
		
		public function addChildAtPoint(child:DisplayObject, location:Point, scaleToScreen:Boolean=false):DisplayObject
		{
			var locationSprite:LocationSprite = new LocationSprite(child, location, scaleToScreen);
			addChild(locationSprite);
			locationContainers.push(locationSprite);
			addResizeListener();
			return locationSprite;
		}
		
		public function removeChildFromAlignment(child:DisplayObject):void
		{
			if (child.parent.parent) {
				child.parent.parent.removeChild(child.parent);
			}
			if (child.parent) child.parent.removeChild(child);
		}
	}
}