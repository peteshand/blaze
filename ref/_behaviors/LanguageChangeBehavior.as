package blaze.behaviors 
{
	import imag.masdar.core.BaseObject;
	
	/**
	 * ...
	 * @author Pete Shand
	 */
	public class LanguageChangeBehavior extends BaseObject 
	{
		// checks if the language index changes
		// if the language index = the object languageIndex then the showFunction will be called
		// otherwise the hideFunction will be called
		
		private var languageIndex:int;
		private var showFunction:Function;
		private var hideFunction:Function;
		
		public function LanguageChangeBehavior(languageIndex:int, showFunction:Function, hideFunction:Function) 
		{
			this.languageIndex = languageIndex;
			this.showFunction = showFunction;
			this.hideFunction = hideFunction;
			
			model.language.updateSignal.add(OnLanguageChange);
			OnLanguageChange();
		}
		
		private function OnLanguageChange():void 
		{
			if (model.language.languageIndex == languageIndex) {
				showFunction();
			}
			else {
				hideFunction();
			}
		}
		
		public function dispose():void
		{
			model.language.updateSignal.remove(OnLanguageChange);
		}
	}
}