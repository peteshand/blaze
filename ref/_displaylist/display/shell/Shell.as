package imag.masdar.core.view.displaylist.display.shell 
{
	import imag.masdar.core.config.VariableObjects.ShellAlignmentVO;
	import imag.masdar.core.view.displaylist.display.base.BaseClassicSprite;
	import imag.masdar.core.view.displaylist.display.shell.home.HomeButton;
	import imag.masdar.core.view.displaylist.display.shell.languageSwitch.LanguageSwitchButton;
	
	/**
	 * ...
	 * @author Pete Shand
	 */
	public class Shell extends BaseClassicSprite 
	{
		public var languageSwitchButton:LanguageSwitchButton;
		public var homeButton:HomeButton;
		
		public function Shell() 
		{
			super();
			
			var shellAlignment:ShellAlignmentVO = config.shellAlignment;
			if (shellAlignment.home) addHomeButton(shellAlignment.home);
			if (shellAlignment.language) addLanguageSwitch(shellAlignment.language);
		}
		
		public function addHomeButton(alignment:String):void
		{
			homeButton = new HomeButton();
			homeButton.anchor = alignment;
			addChildAtAlignment(homeButton, alignment);
		}
		
		public function addLanguageSwitch(alignment:String):void
		{
			languageSwitchButton = new LanguageSwitchButton();
			languageSwitchButton.anchor = alignment;
			addChildAtAlignment(languageSwitchButton, alignment);
		}
	}
}