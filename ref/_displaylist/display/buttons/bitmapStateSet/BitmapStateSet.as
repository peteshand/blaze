package imag.masdar.core.view.displaylist.display.buttons.bitmapStateSet 
{
	import com.greensock.TweenLite;
	import flash.display.Sprite;
	import imag.masdar.core.view.displaylist.display.buttons.bitmapStateSet.BitmapContainer;
	import org.osflash.signals.Signal;
	
	/**
	 * ...
	 * @author Pete Shand
	 */
	public class BitmapStateSet extends Sprite 
	{
		public static const NORMAL_STATE:int = 0;
		public static const OVER_STATE:int = 1;
		public static const DOWN_STATE:int = 2;
		public static const INACTIVE_STATE:int = 3;
		
		private var normalBitmap:BitmapContainer;
		private var overBitmap:BitmapContainer;
		private var downBitmap:BitmapContainer;
		private var inactiveBitmap:BitmapContainer;
		
		private var bitmaps:Vector.<BitmapContainer> = new Vector.<BitmapContainer>();
		
		private var activeBitmap:BitmapContainer;
		
		private var _buttonState:int = BitmapStateSet.NORMAL_STATE;
		private var fadeTime:Number = 0.3;
		
		private var hideComplete:Signal = new Signal();
		private var transitioning:Boolean = false;
		
		public function BitmapStateSet(_normalBitmap:BitmapContainer, _overBitmap:BitmapContainer=null, _downBitmap:BitmapContainer=null, _inactiveBitmap:BitmapContainer=null) 
		{
			normalBitmap = _normalBitmap;
			overBitmap = _overBitmap;
			downBitmap = _downBitmap;
			inactiveBitmap = _inactiveBitmap;
			
			addChild(normalBitmap);
			
			if (overBitmap) addChild(overBitmap);
			else overBitmap = normalBitmap;
			
			if (downBitmap) addChild(downBitmap);
			else downBitmap = normalBitmap;
			
			if (inactiveBitmap) addChild(inactiveBitmap);
			else inactiveBitmap = normalBitmap;
			
			bitmaps.push(normalBitmap, overBitmap, downBitmap, inactiveBitmap);
			
			buttonState = BitmapStateSet.NORMAL_STATE;
		}		
		
		public function get buttonState():int 
		{
			return _buttonState;
		}
		
		public function set buttonState(value:int):void 
		{
			_buttonState = value;
			switch(buttonState)
			{
				case BitmapStateSet.NORMAL_STATE:
					activeBitmap = normalBitmap;
				break;
				case BitmapStateSet.OVER_STATE:
					activeBitmap = overBitmap;
				break;
				case BitmapStateSet.DOWN_STATE:
					activeBitmap = downBitmap;
				break;
				case BitmapStateSet.INACTIVE_STATE:
					activeBitmap = inactiveBitmap;
				break;
			}
			transitionState();
		}
		
		private function transitionState():void 
		{
			hideComplete.removeAll();
			if (transitioning) {
				waitForTransitionToComplete();
			}
			else {
				transitioning = true;
				for (var i:int = 0; i < bitmaps.length; ++i) {
					if (bitmaps[i] == activeBitmap) {
						bitmaps[i].Show(0.3);
					}
					else {
						bitmaps[i].Hide(0.3);
						
					}
				}
				TweenLite.delayedCall(0.5, OnTransitionComplete);
			}
		}
		
		private function OnTransitionComplete():void 
		{
			transitioning = false;
			hideComplete.dispatch();
		}
		
		private function waitForTransitionToComplete():void 
		{
			hideComplete.addOnce(transitionState);
		}
		
		public function Show():void
		{
			this.visible = true;
			TweenLite.to(this, fadeTime, { alpha:1} );
		}
		
		public function Hide():void
		{
			TweenLite.to(this, fadeTime, { alpha:0, onComplete:OnFadeOutComplete} );
		}
		
		private function OnFadeOutComplete():void 
		{
			this.visible = false;
		}
		
	}

}