package blaze.behaviors 
{
	import blaze.model.language.LanguageModel;
	
	/**
	 * ...
	 * @author Pete Shand
	 */
	public class LanguageChangeBehavior
	{
		// checks if the language index changes
		// if the language index = the object languageIndex then the showFunction will be called
		// otherwise the hideFunction will be called
		private var language:LanguageModel;
		
		private var languageIndex:int;
		private var showFunction:Function;
		private var hideFunction:Function;
		
		public function LanguageChangeBehavior(languageIndex:int, showFunction:Function, hideFunction:Function, instanceIndex:int) 
		{
			this.languageIndex = languageIndex;
			this.showFunction = showFunction;
			this.hideFunction = hideFunction;
			
			language = Blaze.instance(instanceIndex).language;
			
			language.updateSignal.add(OnLanguageChange);
			OnLanguageChange();
		}
		
		private function OnLanguageChange():void 
		{
			if (language.index == languageIndex) {
				showFunction();
			}
			else {
				hideFunction();
			}
		}
		
		public function dispose():void
		{
			language.updateSignal.remove(OnLanguageChange);
		}
	}
}