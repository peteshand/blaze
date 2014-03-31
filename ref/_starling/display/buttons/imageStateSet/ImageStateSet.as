package imag.masdar.core.view.starling.display.buttons.imageStateSet 
{
	import com.greensock.TweenLite;
	import org.osflash.signals.Signal;
	import starling.display.Image;
	import starling.display.Sprite;
	
	/**
	 * ...
	 * @author Pete Shand
	 */
	public class ImageStateSet extends Sprite 
	{
		public static const NORMAL_STATE:int = 0;
		public static const OVER_STATE:int = 1;
		public static const DOWN_STATE:int = 2;
		public static const INACTIVE_STATE:int = 3;
		
		private var normalImage:ImageContainer;
		private var overImage:ImageContainer;
		private var downImage:ImageContainer;
		private var inactiveImage:ImageContainer;
		
		private var images:Vector.<ImageContainer> = new Vector.<ImageContainer>();
		
		private var activeImage:ImageContainer;
		
		private var _buttonState:int = ImageStateSet.NORMAL_STATE;
		private var fadeTime:Number = 0.3;
		
		private var hideComplete:Signal = new Signal();
		private var transitioning:Boolean = false;
		
		public function ImageStateSet(_normalImage:ImageContainer, _overImage:ImageContainer=null, _downImage:ImageContainer=null, _inactiveImage:ImageContainer=null) 
		{
			normalImage = _normalImage;
			overImage = _overImage;
			downImage = _downImage;
			inactiveImage = _inactiveImage;
			
			addChild(normalImage);
			
			if (overImage) addChild(overImage);
			else overImage = normalImage;
			
			if (downImage) addChild(downImage);
			else downImage = normalImage;
			
			if (inactiveImage) addChild(inactiveImage);
			else inactiveImage = normalImage;
			
			images.push(normalImage, overImage, downImage, inactiveImage);
			
			buttonState = ImageStateSet.NORMAL_STATE;
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
				case ImageStateSet.NORMAL_STATE:
					activeImage = normalImage;
				break;
				case ImageStateSet.OVER_STATE:
					activeImage = overImage;
				break;
				case ImageStateSet.DOWN_STATE:
					activeImage = downImage;
				break;
				case ImageStateSet.INACTIVE_STATE:
					activeImage = inactiveImage;
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
				for (var i:int = 0; i < images.length; ++i) {
					if (images[i] == activeImage) {
						images[i].alpha = 0;
						this.addChild(images[i]);
						images[i].Show(0.3);
					}
					else {
						//images[i].Hide(0.3);
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