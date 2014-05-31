package blaze.behaviors 
{
	import blaze.model.scene.SceneModel;
	import com.greensock.TweenLite;
	/**
	 * ...
	 * @author Pete Shand
	 */
	public class SceneChangeBehavior
	{
		// checks if the scene changes
		// if the scene index = the object sceneIndex then the showFunction will be called
		// otherwise the hideFunction will be called
		public var scene:SceneModel;
		
		private var sceneIndex:int;
		private var showFunction:Function;
		private var hideFunction:Function;
		
		public function SceneChangeBehavior(sceneIndex:int, showFunction:Function, hideFunction:Function, instanceIndex:int) 
		{
			this.sceneIndex = sceneIndex;
			this.showFunction = showFunction;
			this.hideFunction = hideFunction;
			
			scene = Blaze.instance(instanceIndex).sceneModel;
			
			scene.indexChange.add(OnSceneChange);
			TweenLite.delayedCall(1, OnSceneChange, null, true);
		}
		
		private function OnSceneChange():void 
		{
			if (scene.index == sceneIndex) {
				showFunction();
			}
			else {
				hideFunction();
			}
		}
		
		public function dispose():void
		{
			scene.indexChange.remove(OnSceneChange);
		}
	}
}