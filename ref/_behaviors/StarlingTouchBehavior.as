package blaze.behaviors 
{
	import com.greensock.TweenLite;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	import starling.display.DisplayObject;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	/**
	 * ...
	 * @author Pete Shand
	 */
	public class StarlingTouchBehavior extends BaseTouchBehavior 
	{
		protected var touchObject:DisplayObject;
		protected var touchHovers:Vector.<Touch>;
		protected var touchBegans:Vector.<Touch>;
		protected var touchEnds:Vector.<Touch>;
		protected var touchMoves:Vector.<Touch>;
		
		private var refID:String;
		
		private var mEnabled:Boolean = true;
        private var mUseHandCursor:Boolean = true;
		
		public function StarlingTouchBehavior(Begin:Function, Move:Function, End:Function, Hover:Function) 
		{
			super(Begin, Move, End, null, null, Hover);
		}
		
		public function addListenerTo(touchObject:DisplayObject):void
		{
			this.touchObject = touchObject;
				
			if (!refID) refID = core.model.touchObjectReference.addStarling(touchObject, Begin, Move, End);
			
			if (touchObject) {
				touchObject.touchable = true;
				touchObject.addEventListener(TouchEvent.TOUCH, OnTouch);
			}
		}
		
		public function removeTouchListenerTo(value:DisplayObject):void 
		{
			if (touchObject == value) touchObject = null;
			value.addEventListener(TouchEvent.TOUCH, OnTouch);
		}
		
		
		protected function OnTouch(e:TouchEvent):void 
		{
			Mouse.cursor = (mUseHandCursor && mEnabled && e.interactsWith(touchObject)) ? MouseCursor.BUTTON : MouseCursor.AUTO;
			
			touchHovers = e.getTouches(touchObject, TouchPhase.HOVER);
			touchBegans = e.getTouches(touchObject, TouchPhase.BEGAN);
			touchMoves = e.getTouches(touchObject, TouchPhase.MOVED);
			touchEnds = e.getTouches(touchObject, TouchPhase.ENDED);
			
			if (touchHovers.length > 0) {
				ParseTouchHovers(touchHovers);
				//core.model.functionRegister.Register(ParseTouchHovers, touchHovers, refID);
			}
			if (touchBegans.length > 0) {
				ParseTouchBegins(touchBegans);
				core.model.starlingTouchRegister.Register(ParseTouchBegins, touchBegans, refID);
			}
			if (touchMoves.length > 0) {
				ParseTouchMoves(touchMoves);
				core.model.starlingTouchRegister.Register(ParseTouchMoves, touchMoves, refID);
			}
            if (touchEnds.length > 0) {
				ParseTouchEnds(touchEnds);
				core.model.starlingTouchRegister.Register(ParseTouchEnds, touchEnds, refID);
			}
		}
		
		private function ParseTouchHovers(touchVector:Vector.<Touch>):void 
		{
			if (active){
				for (var i:int = 0; i < touchVector.length; ++i) {
					Hover(touchVector[i]);
				}
			}
		}
		
		protected function ParseTouchBegins(touchVector:Vector.<Touch>):void
		{
			if (active){
				if (!pressCooldownActive) {
					TweenLite.delayedCall(cooldownTime, OnCooldownPressComplete);
					for (var i:int = 0; i < touchVector.length; ++i) {
						if (!pressCooldownActive) {
							Begin(touchVector[i]);
							pressCooldownActive = true;
						}
					}
				}
			}
		}
		
		protected function ParseTouchMoves(touchVector:Vector.<Touch>):void
		{
			if (active){
				for (var i:int = 0; i < touchVector.length; ++i) {
					Move(touchVector[i]);
				}
			}
		}
		
		protected function ParseTouchEnds(touchVector:Vector.<Touch>):void
		{
			if (active){
				if (!releaseCooldownActive) {
					TweenLite.delayedCall(cooldownTime, OnCooldownReleaseComplete);
					for (var i:int = 0; i < touchVector.length; ++i) {
						if (!releaseCooldownActive) {
							End(touchVector[i]);
							releaseCooldownActive = true;
						}
					}
				}
			}
		}
	}
}