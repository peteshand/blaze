package blaze.behaviors 
{
	import imag.masdar.core.BaseObject;
	
	/**
	 * ...
	 * @author Pete Shand
	 */
	public class SubSceneChangeBehavior extends BaseObject 
	{
		// checks if the sub-scene changes
		// if the sub-scene index = the object subSceneIndex then the showFunction will be called
		// otherwise the hideFunction will be called
		
		private var subSceneIndex:int;
		private var showFunction:Function;
		private var hideFunction:Function;
		
		public function SubSceneChangeBehavior(subSceneIndex:int, showFunction:Function, hideFunction:Function) 
		{
			this.subSceneIndex = subSceneIndex;
			this.showFunction = showFunction;
			this.hideFunction = hideFunction;
			
			model.scene.subSceneChangeSignal.add(OnSubSceneChange);
			OnSubSceneChange();
		}
		
		private function OnSubSceneChange():void 
		{
			if (model.scene.currentSubScene == subSceneIndex) {
				showFunction();
			}
			else {
				hideFunction();
			}
		}
		
		public function dispose():void
		{
			model.scene.subSceneChangeSignal.remove(OnSubSceneChange);
		}
	}
}