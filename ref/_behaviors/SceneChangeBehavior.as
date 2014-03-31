package blaze.behaviors 
{
	import imag.masdar.core.BaseObject;
	
	/**
	 * ...
	 * @author Pete Shand
	 */
	public class SceneChangeBehavior extends BaseObject 
	{
		// checks if the scene changes
		// if the scene index = the object sceneIndex then the showFunction will be called
		// otherwise the hideFunction will be called
		
		private var sceneIndex:int;
		private var showFunction:Function;
		private var hideFunction:Function;
		
		public function SceneChangeBehavior(sceneIndex:int, showFunction:Function, hideFunction:Function) 
		{
			this.sceneIndex = sceneIndex;
			this.showFunction = showFunction;
			this.hideFunction = hideFunction;
			
			model.scene.sceneChangeSignal.add(OnSceneChange);
			OnSceneChange();
		}
		
		private function OnSceneChange():void 
		{
			if (model.scene.currentScene == sceneIndex) {
				showFunction();
			}
			else {
				hideFunction();
			}
		}
		
		public function dispose():void
		{
			model.scene.sceneChangeSignal.remove(OnSceneChange);
		}
	}
}