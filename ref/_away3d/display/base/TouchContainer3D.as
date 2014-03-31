package imag.masdar.core.view.away3d.display.base 
{
	import away3d.core.pick.IPickingCollider;
	import away3d.core.pick.PickingColliderType;
	import away3d.entities.Entity;
	import away3d.events.MouseEvent3D;
	import away3d.events.Touch;
	import away3d.events.TouchEvent3D;
	import away3d.events.TouchPhase;
	import com.greensock.TweenLite;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	import blaze.behaviors.AwayTouchBehavior;
	import blaze.behaviors.DisplayListTouchBehavior;
	/**
	 * ...
	 * @author Pete Shand
	 */
	public class TouchContainer3D extends ResizeContainer3D 
	{
		protected var awayTouchBehavior:AwayTouchBehavior;
		protected var displaylistTouchBehavior:DisplayListTouchBehavior;
		
		public function TouchContainer3D() 
		{
			super();
		}
		
		public function attachTouchListenerTo(touchObject:*, iPickingCollider:IPickingCollider=null, _useStageForRelease:Boolean=false):void 
		{
			if (touchObject is Entity) {
				if (!awayTouchBehavior) awayTouchBehavior = new AwayTouchBehavior(OnTouchBegin, OnTouchMove, OnTouchEnd, null, null);
				awayTouchBehavior.addListenerTo(touchObject, iPickingCollider, _useStageForRelease);
			}
			else if (touchObject is DisplayObject) {
				if (!displaylistTouchBehavior) displaylistTouchBehavior = new DisplayListTouchBehavior(OnTouchBegin, OnTouchMove, OnTouchEnd, null, null);
				displaylistTouchBehavior.addListenerTo(touchObject, _useStageForRelease);
			}
		}
		
		public function removeTouchListenerTo(touchObject:*):void
		{
			if (touchObject is Entity) {
				if (awayTouchBehavior) awayTouchBehavior.removeTouchListenerTo(touchObject);
			}
			else if (touchObject is DisplayObject) {
				if (displaylistTouchBehavior) displaylistTouchBehavior.removeTouchListenerTo(touchObject);
			}
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