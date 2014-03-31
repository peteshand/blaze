package imag.masdar.core.view.starling.display.shell.languageSwitch 
{
	import imag.masdar.core.utils.starling.ImageStateSetUtils;
	import imag.masdar.core.view.starling.display.buttons.imageStateSet.ImageStateSet;
	import imag.masdar.core.view.starling.display.buttons.ToggleButton;
	import starling.events.Touch;
	
	/**
	 * ...
	 * @author Pete Shand
	 */
	public class LanguageSwitchButton extends ToggleButton 
	{
		private var englishImageStateSet:ImageStateSet;
		private var arabicImageStateSet:ImageStateSet;
		
		public function LanguageSwitchButton(foregroundColour:uint=0x04ADF0, backgroundColour:uint=0xFFFFFF) 
		{
			this.toggleWithoutModel = false;
			
			englishImageStateSet = ImageStateSetUtils.GenerateCircFromBmd(new EnglishLanguageBtnBmd(), foregroundColour, backgroundColour);
			arabicImageStateSet = ImageStateSetUtils.GenerateCircFromBmd(new ArabicLanguageBtnBmd(), foregroundColour, backgroundColour);
			super(arabicImageStateSet, englishImageStateSet);
			
			model.language.updateSignal.add(OnLanguageChange);
			OnLanguageChange();
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