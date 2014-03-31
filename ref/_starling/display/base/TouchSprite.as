package imag.masdar.core.view.starling.display.base 
{
	import com.greensock.TweenLite;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	import blaze.behaviors.StarlingTouchBehavior;
	import starling.display.DisplayObject;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	/**
	 * ...
	 * @author Pete Shand
	 */
	public class TouchSprite extends ResizeSprite 
	{
		protected var touchObject:DisplayObject;
		private var starlingTouchBehavior:StarlingTouchBehavior;
		
		public function TouchSprite() 
		{
			super();
		}
		
		public function attachTouchListenerTo(touchObject:DisplayObject):void 
		{
			if (!starlingTouchBehavior) starlingTouchBehavior = new StarlingTouchBehavior(OnTouchBegin, OnTouchMove, OnTouchEnd, OnTouchHover);
			starlingTouchBehavior.addListenerTo(touchObject);
		}
		
		public function removeTouchListenerTo(touchObject:DisplayObject):void 
		{
			if (starlingTouchBehavior) starlingTouchBehavior.removeTouchListenerTo(touchObject);
		}
		
		// Override functions:
		// Override the below functions in child classes for touch/mouse interaction
		protected function OnTouchBegin(touch:Touch):void
		{
			
		}
		
		protected function OnTouchMove(touch:Touch):void
		{
			
		}
		
		protected function OnTouchEnd(touch:Touch):void
		{
			
		}
		
		protected function OnTouchHover(touch:Touch):void
		{
			
		}
	}
}