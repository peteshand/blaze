package imag.masdar.core.view.displaylist.display.base 
{
	import away3d.events.Touch;
	import flash.display.DisplayObject;
	import blaze.behaviors.DisplayListTouchBehavior;
	/**
	 * ...
	 * @author Pete Shand
	 */
	public class TouchSprite extends ResizeSprite 
	{
		private var displaylistTouchBehavior:DisplayListTouchBehavior;
		
		public function TouchSprite() 
		{
			
		}
		
		public function attachTouchListenerTo(touchObject:DisplayObject, _useStageForRelease:Boolean=false):void 
		{
			if (!displaylistTouchBehavior) displaylistTouchBehavior = new DisplayListTouchBehavior(OnTouchBegin, OnTouchMove, OnTouchEnd, OnTouchOver, OnTouchOut);
			displaylistTouchBehavior.addListenerTo(touchObject, _useStageForRelease);
		}
		
		public function removeTouchListenerTo(touchObject:DisplayObject):void
		{
			if (displaylistTouchBehavior) displaylistTouchBehavior.removeTouchListenerTo(touchObject);
		}
		
		// Override functions:
		// Override the below functions in child classes for touch/mouse interaction
		
		protected function OnTouchBegin(touch:Touch):void
		{
			//trace("OnTouchBegin");
		}
		
		protected function OnTouchMove(touch:Touch):void
		{
			//trace("OnTouchMove");
		}
		
		protected function OnTouchEnd(touch:Touch):void
		{
			//trace("OnTouchEnd");
		}
		
		protected function OnTouchOver(touch:Touch):void
		{
			// current not working correctly... OnTouchOut/OnTouchOver firing every frame while over object
			//trace("OnTouchOver");
		}
		
		protected function OnTouchOut(touch:Touch):void
		{
			// current not working correctly... OnTouchOut/OnTouchOver firing every frame while over object
			//trace("OnTouchOut");
		}
	}
}