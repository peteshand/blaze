package imag.masdar.core.view.starling.display.slider 
{
	import flash.geom.Point;
	import imag.masdar.core.utils.layout.Alignment;
	import blaze.behaviors.StarlingTouchBehavior;
	import imag.masdar.core.view.starling.display.base.BaseStarlingObject;
	import org.osflash.signals.Signal;
	import starling.display.*;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author Pete Shand
	 */
	public class DragScrollArea 
	{
		
		public function get display():DisplayObject {
			return image;
		}
		
		private var image:Image;
		private var touchPressLoc:Point = new Point();
		
		private var scrollXHandler:Function;
		private var scrollYHandler:Function;
		
		public var scrollXSpeed:Number;
		public var scrollYSpeed:Number;
		
		private var isScrollingSetter:Function;
		
		public function DragScrollArea(scrollXHandler:Function=null, scrollYHandler:Function=null, scrollXSpeed:Number = 1, scrollYSpeed:Number = 1, isScrollingSetter:Function=null) 
		{
			this.scrollXHandler = scrollXHandler;
			this.scrollYHandler = scrollYHandler;
			
			this.scrollXSpeed = scrollXSpeed;
			this.scrollYSpeed = scrollYSpeed;
			
			this.isScrollingSetter = isScrollingSetter;
			
			var texture:Texture = Texture.fromColor(8, 8, 0x0000FF00);
			image = new Image(texture);
			
			var starlingTouchBehavior:StarlingTouchBehavior = new StarlingTouchBehavior(OnTouchBegin, OnTouchMove, OnTouchEnd, null);
			starlingTouchBehavior.addListenerTo(image);
		}
		
		public function setSize(width:Number, height:Number):void {
			image.width = width;
			image.height = height;
		}
		
		public function addScrollArea(displayObject:DisplayObject):void {
			var starlingTouchBehavior:StarlingTouchBehavior = new StarlingTouchBehavior(OnTouchBegin, OnTouchMove, OnTouchEnd, null);
			starlingTouchBehavior.addListenerTo(displayObject);
		}
		
		protected function OnTouchBegin(touch:Touch):void
		{
			touchPressLoc.x = touch.globalX;
			touchPressLoc.y = touch.globalY;
			if (isScrollingSetter!=null) isScrollingSetter(true);
		}
		
		protected function OnTouchEnd(touch:Touch):void
		{
			if (isScrollingSetter!=null) isScrollingSetter(false);
		}
		
		protected function OnTouchMove(touch:Touch):void
		{
			if (scrollXHandler!=null) {
				var newX:Number = touch.globalX;
				if (touchPressLoc.x != newX) {
					scrollXHandler((touchPressLoc.x - newX) * scrollXSpeed);
					touchPressLoc.x = newX;
				}
			}
			if (scrollYHandler!=null) {
				var newY:Number = touch.globalY;
				if(touchPressLoc.y != newY){
					scrollYHandler((touchPressLoc.y - newY) * scrollYSpeed);
					touchPressLoc.y = newY;
				}
			}
		}
	}
}