package blaze.model.scene 
{
	import org.osflash.signals.Signal;
	
	/**
	 * ...
	 * @author Pete Shand
	 */
	
	public class SceneModel
	{
		/*protected static var _allowInstantiate:Boolean;
		protected static var _instance:SceneModel;
		
		public function SceneModel()
		{
			if (!_allowInstantiate)
			{
				throw new Error("SceneModel can only be accessed through SceneModel.getInstance()");
			}
			else {
				index = 0;
				sceneHistory.push([0,0]);
			}
		}
		
		public static function getInstance():SceneModel
		{
			if (!_instance) {
				_allowInstantiate = true;
				_instance = new SceneModel();
				_allowInstantiate = false;
			}
			return _instance;
		}*/
		
		private var sceneHistory:Vector.<Array> = new Vector.<Array>();
		private var backIndex:int = 0;
		private var recordHistory:Boolean = true;
		
		private var minIndex:int = 0;
		public var maxIndex:int = 1000;
		
		private var _index:int = 0;
		private var _lastScene:int = -1;
		
		public var indexChange:Signal = new Signal();
		public var subIndexChange:Signal = new Signal();
		
		private var sceneObjects:Vector.<SceneObject> = new Vector.<SceneObject>(0, false);
		private var currentSceneObject:SceneObject = new SceneObject(-1);
		private var lastSceneObject:SceneObject = new SceneObject(-1);
		
		public function SceneModel():void
		{
			
		}
		
		public function get subIndex():int 
		{
			if (currentSceneObject) return currentSceneObject.subIndex;
			return -1;
		}
		
		public function set subIndex(value:int):void 
		{
			currentSceneObject.subIndex = value;
		}
		
		public function get index():int
		{
			if (currentSceneObject) return currentSceneObject.index;
			return -1;
		}
		
		public function set index(value:int):void 
		{
			lastSceneObject = currentSceneObject;
			
			if (currentSceneObject) {
				currentSceneObject.subIndex = 0;
			}
			
			currentSceneObject = getSceneObject(value);
			if (lastSceneObject.index == currentSceneObject.index) return;
			
			UpdateHistory();
			
			indexChange.dispatch();
		}
		
		public function getSceneObject(value:int):SceneObject 
		{
			if (value < minIndex) value = minIndex;
			if (value > maxIndex) value = maxIndex;
			if (sceneObjects.length - 1 < value) {
				for (var i:int = sceneObjects.length; i <= value; ++i) {
					sceneObjects.push(new SceneObject(i));
				}
			}
			if (sceneObjects[value] == null) sceneObjects[value] = new SceneObject(value);
			if (currentSceneObject) {
				currentSceneObject.reset();
				currentSceneObject.subSceneChange.remove(OnSubSceneChange);
			}
			currentSceneObject = sceneObjects[value];
			currentSceneObject.subSceneChange.add(OnSubSceneChange);
			return currentSceneObject;
		}
		
		
		private function UpdateHistory():void 
		{
			if (recordHistory) {
				sceneHistory.push([index, subIndex]);
				backIndex = sceneHistory.length-1;
			}
			recordHistory = true;
		}
		
		
		public function get lastScene():int 
		{
			return _lastScene;
		}
		
		public function goBack():void
		{
			backIndex--;
			if (backIndex == -1) {
				backIndex = 0;
				return;
			}
			sceneHistory.splice(backIndex + 1, 1);
			recordHistory = false;
			index = sceneHistory[backIndex][0];
		}
		
		private function OnSubSceneChange():void 
		{
			subIndexChange.dispatch();
		}
	}	
}

import org.osflash.signals.Signal;

class SceneObject 
{
	private var _index:int;
	private var _subIndex:int = 0;
	
	public var subSceneChange:Signal = new Signal();
	
	public function SceneObject(index:int) 
	{
		this._index = index;
	}
	
	public function reset():void 
	{
		subIndex = 0;
	}
	
	public function get index():int 
	{
		return _index;
	}
	
	public function get subIndex():int 
	{
		return _subIndex;
	}
	
	public function set subIndex(value:int):void 
	{
		if (_subIndex == value) return;
		_subIndex = value;
		subSceneChange.dispatch();
	}
}