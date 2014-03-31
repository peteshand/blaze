package imag.masdar.core.view.starling.utils.Delete 
{
	import com.greensock.TweenLite;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	import starling.display.DisplayObject;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	
	public class TouchHelper 
	{
		protected var touchObject:DisplayObject;
		protected var touchHovers:Vector.<Touch>;
		protected var touchBegans:Vector.<Touch>;
		protected var touchEnds:Vector.<Touch>;
		protected var touchMoves:Vector.<Touch>;
		
		private var mEnabled:Boolean = true;
        private var mUseHandCursor:Boolean = true;
		
		private var pressCooldownActive:Boolean = false;
		private var releaseCooldownActive:Boolean = false;
		private var cooldownTime:Number = 0.2;
		
		private var OnTouchHover:Function;
		private var OnTouchBegin:Function;
		private var OnTouchMove:Function;
		private var OnTouchEnd:Function;
		
		public function TouchHelper(OnTouchBegin:Function=null, OnTouchMove:Function=null, OnTouchEnd:Function=null, OnTouchHover:Function=null) 
		{
			super();
			
			this.OnTouchHover = OnTouchHover;
			this.OnTouchBegin = OnTouchBegin;
			this.OnTouchMove = OnTouchMove;
			this.OnTouchEnd = OnTouchEnd;
		}
		
		public function attachTouchListenerTo(value:DisplayObject):void 
		{
			touchObject = value;
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
				//core.model.functionRegister.Register(ParseTouchHovers, touchHovers);
			}
			if (touchBegans.length > 0) {
				ParseTouchBegins(touchBegans);
				//core.model.starlingTouchRegister.Register(ParseTouchBegins, touchBegans);
			}
			if (touchMoves.length > 0) {
				ParseTouchMoves(touchMoves);
				//core.model.starlingTouchRegister.Register(ParseTouchMoves, touchMoves);
			}
            if (touchEnds.length > 0) {
				ParseTouchEnds(touchEnds);
				//core.model.starlingTouchRegister.Register(ParseTouchEnds, touchEnds);
			}
		}
		
		private function ParseTouchHovers(touchVector:Vector.<Touch>):void 
		{
			for (var i:int = 0; i < touchVector.length; ++i) {
				if(OnTouchHover!=null)OnTouchHover(touchVector[i]);
			}
		}
		
		protected function ParseTouchBegins(touchVector:Vector.<Touch>):void
		{
			if (!pressCooldownActive) {
				TweenLite.delayedCall(cooldownTime, OnCooldownPressComplete);
				for (var i:int = 0; i < touchVector.length; ++i) {
					if (!pressCooldownActive) {
						if(OnTouchBegin!=null)OnTouchBegin(touchVector[i]);
						pressCooldownActive = true;
					}
				}
			}
		}
		
		protected function ParseTouchMoves(touchVector:Vector.<Touch>):void
		{
			for (var i:int = 0; i < touchVector.length; ++i) {
				if(OnTouchMove!=null)OnTouchMove(touchVector[i]);
			}
		}
		
		protected function ParseTouchEnds(touchVector:Vector.<Touch>):void
		{
			if (!releaseCooldownActive) {
				TweenLite.delayedCall(cooldownTime, OnCooldownReleaseComplete);
				for (var i:int = 0; i < touchVector.length; ++i) {
					if (!releaseCooldownActive) {
						if(OnTouchEnd!=null)OnTouchEnd(touchVector[i]);
						releaseCooldownActive = true;
					}
				}
			}
		}
		
		private function OnCooldownPressComplete():void 
		{
			pressCooldownActive = false;
		}
		private function OnCooldownReleaseComplete():void 
		{
			releaseCooldownActive = false;
		}
	}
}