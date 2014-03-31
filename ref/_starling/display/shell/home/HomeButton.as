package imag.masdar.core.view.starling.display.shell.home 
{
	import imag.masdar.core.utils.starling.ImageStateSetUtils;
	import imag.masdar.core.view.starling.display.buttons.BaseButton;
	import imag.masdar.core.view.starling.display.buttons.imageStateSet.ImageStateSet;
	import starling.events.Touch;
	/**
	 * ...
	 * @author Pete Shand
	 */
	public class HomeButton extends BaseButton 
	{
		private var imageStateSet:ImageStateSet;
		
		public function HomeButton(foregroundColour:uint=0x04ADF0, backgroundColour:uint=0xFFFFFF) 
		{
			imageStateSet = ImageStateSetUtils.GenerateCircFromBmd(new HomeBtnAlphaBmd(), foregroundColour, backgroundColour);
			super(imageStateSet);
			
			model.userInterfaceModel.showHomeBtn.add(Show);
			model.userInterfaceModel.hideHomeBtn.add(Hide);
		}
		
		override protected function OnTouchBegin(touch:Touch):void
		{
			super.OnTouchBegin(touch);
			model.userInterfaceModel.homeBtnTiggered.dispatch();
			model.scene.currentScene = 0;
		}
		
		override protected function OnTouchMove(touch:Touch):void
		{
			super.OnTouchMove(touch);
		}
		
		override protected function OnTouchEnd(touch:Touch):void
		{
			super.OnTouchEnd(touch);
		}
	}
}