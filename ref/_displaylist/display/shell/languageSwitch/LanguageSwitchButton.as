package imag.masdar.core.view.displaylist.display.shell.languageSwitch 
{
	import away3d.events.Touch;
	import imag.masdar.core.utils.bitmap.BitmapStateSetUtils;
	import imag.masdar.core.view.displaylist.display.buttons.BaseButton;
	import imag.masdar.core.view.displaylist.display.buttons.bitmapStateSet.BitmapStateSet;
	import imag.masdar.core.view.displaylist.display.buttons.ToggleButton;
	import imag.masdar.core.view.starling.display.buttons.imageStateSet.ImageStateSet;
	
	/**
	 * ...
	 * @author Pete Shand
	 */
	public class LanguageSwitchButton extends ToggleButton 
	{
		private var englishBitmapStateSet:BitmapStateSet;
		private var arabicBitmapStateSet:BitmapStateSet;
		
		public function LanguageSwitchButton(foregroundColour:uint=0x04ADF0, backgroundColour:uint=0xFFFFFF) 
		{
			this.toggleWithoutModel = false;
			
			englishBitmapStateSet = BitmapStateSetUtils.GenerateCircFromBmd(new EnglishLanguageBtnBmd(), foregroundColour, backgroundColour);
			arabicBitmapStateSet = BitmapStateSetUtils.GenerateCircFromBmd(new ArabicLanguageBtnBmd(), foregroundColour, backgroundColour);
			super(arabicBitmapStateSet, englishBitmapStateSet);
			
			model.language.updateSignal.add(OnLanguageChange);
			OnLanguageChange();
		}
		
		override protected function OnTouchOut(touch:Touch):void
		{
			buttonState = BitmapStateSet.NORMAL_STATE;
		}
		
		override protected function OnTouchEnd(touch:Touch):void
		{
			super.OnTouchEnd(touch);
			control.transControl.setProp(model.language, "languageIndex", model.language.languageIndex + 1);
		}
		
		private function OnLanguageChange():void 
		{
			toggleIndex = model.language.languageIndex;
		}
	}
}