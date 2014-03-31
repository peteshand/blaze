package blaze.behaviors 
{
	import blaze.model.scene.SceneModel;
	/**
	 * ...
	 * @author Pete Shand
	 */
	public class SubSceneChangeBehavior
	{
		// checks if the sub-scene changes
		// if the sub-scene index = the object subIndex then the showFunction will be called
		// otherwise the hideFunction will be called
		public var scene:SceneModel;
		
		private var subIndex:int;
		private var showFunction:Function;
		private var hideFunction:Function;
		
		public function SubSceneChangeBehavior(subIndex:int, showFunction:Function, hideFunction:Function, instanceIndex:int) 
		{
			this.subIndex = subIndex;
			this.showFunction = showFunction;
			this.hideFunction = hideFunction;
			
			scene = Blaze.instance(instanceIndex).scene;
			
			scene.subIndexChange.add(OnSubSceneChange);
			OnSubSceneChange();
		}
		
		private function OnSubSceneChange():void 
		{
			if (scene.subIndex == subIndex) {
				showFunction();
			}
			else {
				hideFunction();
			}
		}
		
		public function dispose():void
		{
			scene.subIndexChange.remove(OnSubSceneChange);
		}
	}
}