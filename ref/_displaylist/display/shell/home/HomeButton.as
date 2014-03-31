package imag.masdar.core.view.displaylist.display.shell.home 
{
	import away3d.events.Touch;
	import imag.masdar.core.utils.bitmap.BitmapStateSetUtils;
	import imag.masdar.core.view.displaylist.display.buttons.BaseButton;
	import imag.masdar.core.view.displaylist.display.buttons.bitmapStateSet.BitmapStateSet;
	
	/**
	 * ...
	 * @author Pete Shand
	 */
	public class HomeButton extends BaseButton 
	{
		private var bitmapStateSet:BitmapStateSet;
		
		public function HomeButton(foregroundColour:uint=0x04ADF0, backgroundColour:uint=0xFFFFFF) 
		{
			bitmapStateSet = BitmapStateSetUtils.GenerateCircFromBmd(new HomeBtnAlphaBmd(), foregroundColour, backgroundColour);
			super(bitmapStateSet);
		}
		
		override protected function OnTouchBegin(touch:Touch):void
		{
			super.OnTouchBegin(touch);
			model.userInterfaceModel.homeBtnTiggered.dispatch();
			//model.scene.currentScene = 0;
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