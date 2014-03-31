package imag.masdar.core.view.starling.display.shell.scrollButtons 
{
	import com.greensock.TweenLite;
	import imag.masdar.core.Core;
	import imag.masdar.core.utils.starling.ImageStateSetUtils;
	import imag.masdar.core.view.starling.display.buttons.BaseButton;
	import imag.masdar.core.view.starling.display.buttons.imageStateSet.ImageStateSet;
	import starling.events.Touch;
	
	/**
	 * ...
	 * @author Pete Shand
	 */
	public class ScrollLeft extends BaseButton 
	{
		private var imageStateSet:ImageStateSet;
		
		public function ScrollLeft(foregroundColour:uint=0x99FFFFFF, backgroundColour:uint=0x33222222) 
		{
			core = Core.getInstance();
			imageStateSet = ImageStateSetUtils.GenerateCircFromBmd(core.assets.scrollArrows, foregroundColour, backgroundColour);
			super(imageStateSet);
			
			model.userInterfaceModel.showScrollLeft.add(Show);
			model.userInterfaceModel.hideScrollLeft.add(Hide);
			imageStateSet.scaleX = -1;
			imageStateSet.x += 60;
			
			Hide();
			this.visible = false;
			
			addResizeListener();
			model.language.updateSignal.add(OnLanguageChange);
		}
		
		private function OnLanguageChange():void 
		{
			OnResize();
		}
		
		override protected function OnResize():void
		{
			if (model.language.languageIndex == 0) {
				this.x = config.shellPadding.left;
				this.scaleX = 1;
			}
			else {
				this.x = stage.stageWidth - config.shellPadding.right;
				this.scaleX = -1;
			}
		}
		
		override protected function OnTouchBegin(touch:Touch):void
		{
			super.OnTouchBegin(touch);
			model.userInterfaceModel.scrollLeftTiggered.dispatch();
		}
		
		override public function Show():void 
		{
			if (showing) return;
			showing = true;
			this.visible = true;
			TweenLite.to(this, 0.5, { alpha:1, delay:0.5 } );
		}
		
		override public function Hide():void 
		{
			if (!showing) return;
			showing = false;
			TweenLite.to(this, 0.5, { alpha:0, delay:0, onComplete:OnFadeOutComplete } );
		}
		
		private function OnFadeOutComplete():void 
		{
			this.visible = false;
		}
	}

}