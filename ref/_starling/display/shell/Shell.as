package imag.masdar.core.view.starling.display.shell 
{
	import com.greensock.easing.Quad;
	import com.greensock.TweenMax;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import imag.masdar.core.config.VariableObjects.ShellAlignmentVO;
	import imag.masdar.core.utils.layout.Alignment;
	import imag.masdar.core.view.starling.display.base.BaseStarlingObject;
	import imag.masdar.core.view.starling.display.shell.home.HomeButton;
	import imag.masdar.core.view.starling.display.shell.languageSwitch.LanguageSwitchButton;
	import imag.masdar.core.view.starling.display.shell.scrollButtons.ScrollLeft;
	import imag.masdar.core.view.starling.display.shell.scrollButtons.ScrollRight;
	import starling.display.DisplayObject;
	import starling.events.Event;
	
	/**
	 * ...
	 * @author Pete Shand
	 */
	public class Shell extends BaseStarlingObject 
	{
		public var languageSwitchButton:LanguageSwitchButton;
		public var homeButton:HomeButton;
		public var scrollLeft:ScrollLeft;
		public var scrollRight:ScrollRight;
		
		public function Shell()
		{
			super();
			
			var shellAlignment:ShellAlignmentVO = config.shellAlignment;
			if (shellAlignment.home) addHomeButton(shellAlignment.home);
			if (shellAlignment.language) addLanguageSwitch(shellAlignment.language);
			if (shellAlignment.scrollLeft) addScrollLeft(shellAlignment.scrollLeft);
			if (shellAlignment.scrollRight) addScrollRight(shellAlignment.scrollRight);
			
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
		
		public function addScrollLeft(alignment:String):void
		{
			scrollLeft = new ScrollLeft();
			scrollLeft.anchor = alignment;
			addChildAtAlignment(scrollLeft, alignment);
		}
		
		public function addScrollRight(alignment:String):void
		{
			scrollRight = new ScrollRight();
			scrollRight.anchor = alignment;
			addChildAtAlignment(scrollRight, alignment);
		}
	}
}