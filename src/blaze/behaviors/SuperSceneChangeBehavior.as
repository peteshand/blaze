package blaze.behaviors 
{
	import blaze.model.scene.SceneModel;
	/**
	 * ...
	 * @author Pete Shand
	 */
	public class SuperSceneChangeBehavior
	{
		// Controls Show/Hide on sceneIndex, subSceneIndex, subScenendices, and languageIndex change
		public var scene:SceneModel;
		
		private var Show:Function
		private var Hide:Function;
		
		private var _sceneIndex:int = -1;
		private var sceneChangeBehavior:SceneChangeBehavior;
		private var _showScene:Boolean = true;
		
		private var _sceneIndices:Array = new Array();
		private var sceneIndicesChangeBehaviors:Vector.<SceneIndicesChangeBehavior> = new Vector.<SceneIndicesChangeBehavior>();
		private var showSceneIndices:Vector.<Boolean> = new Vector.<Boolean>();
		private var sceneIndicesCount:int = 0;
		
		private var _subSceneIndex:int = -1;
		private var subSceneChangeBehavior:SubSceneChangeBehavior;
		private var _showSubScene:Boolean = true;
		
		private var _subSceneIndices:Array = new Array();
		private var subSceneIndicesChangeBehaviors:Vector.<SubSceneIndicesChangeBehavior> = new Vector.<SubSceneIndicesChangeBehavior>();
		private var showSubSceneIndices:Vector.<Boolean> = new Vector.<Boolean>();
		private var subSceneIndicesCount:int = 0;
		
		private var _languageIndex:int = -1;
		private var languageChangeBehavior:LanguageChangeBehavior;
		private var _showLanguage:Boolean = true;
		
		public var active:Boolean = true;
		
		private var checkFunctions:Vector.<Function> = new Vector.<Function>();
		private var instanceIndex:int;
		
		public function SuperSceneChangeBehavior(Show:Function, Hide:Function, instanceIndex:int) 
		{
			super();
			this.instanceIndex = instanceIndex;
			
			scene = Blaze.instance(instanceIndex).scene;
			
			this.Show = Show;
			this.Hide = Hide;
			
			addBooleanCheck(showScene);
			addBooleanCheck(allShowSceneIndices);
			addBooleanCheck(showSubScene);
			addBooleanCheck(allShowSubSceneIndices);
			addBooleanCheck(showLanguage);
		}
		
		public function addBooleanCheck(checkFunction:Function):void
		{
			checkFunctions.push(checkFunction);
		}
		
		public function removeBooleanCheck(checkFunction:Function):void
		{
			for (var i:int = 0; i < checkFunctions.length; i++) 
			{
				if (checkFunctions[i] == checkFunction) {
					checkFunctions.splice(i, 1);
				}
			}
		}
		
		///////////////////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////////////////
		
		public function get sceneIndex():int 
		{
			return _sceneIndex;
		}
		
		public function set sceneIndex(value:int):void 
		{
			if (_sceneIndex == value) return;
			_sceneIndex = value;
			if (sceneIndex == -1) removeSceneListener();
			else {
				sceneIndices = [];
				addSceneListener();
			}
		}
		
		private function removeSceneListener():void 
		{
			if (sceneChangeBehavior) {
				sceneChangeBehavior.dispose();
				sceneChangeBehavior = null;
			}
		}
		
		private function addSceneListener():void 
		{
			removeSceneListener();
			sceneChangeBehavior = new SceneChangeBehavior(sceneIndex, ShowScene, HideScene, instanceIndex);
		}
		
		
		private function ShowScene():void
		{
			_showScene = true;
			checkVis();
		}
		
		private function HideScene():void
		{
			_showScene = false;
			checkVis();
		}
		
		///////////////////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////////////////
		
		public function get sceneIndices():Array 
		{
			return _sceneIndices;
		}
		
		public function set sceneIndices(value:Array):void
		{
			if (_sceneIndices == value) return;
			_sceneIndices = value;
			if (sceneIndices == null || sceneIndices.length == 0) removeSceneIndicesListener();
			else addSceneIndicesListener();
		}
		
		private function removeSceneIndicesListener():void 
		{
			for (var i:int = 0; i < sceneIndices.length; ++i) {
				sceneIndicesChangeBehaviors[i].dispose();
				sceneIndicesChangeBehaviors[i] = null;
			}
		}
		
		private function addSceneIndicesListener():void 
		{
			removeSceneListener();
			sceneIndicesChangeBehaviors = new Vector.<SceneIndicesChangeBehavior>();
			showSceneIndices = new Vector.<Boolean>();
			for (var i:int = 0; i < sceneIndices.length; ++i) {
				showSceneIndices.push(false);
				sceneIndicesChangeBehaviors.push(new SceneIndicesChangeBehavior(sceneIndices[i], i, showSceneIndices, checkVis, instanceIndex));
			}
		}
		
		///////////////////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////////////////
		
		public function get subSceneIndex():int 
		{
			return _subSceneIndex;
		}
		
		public function set subSceneIndex(value:int):void 
		{
			if (_subSceneIndex == value) return;
			_subSceneIndex = value;
			if (subSceneIndex == -1) removeSubSceneListener();
			else {
				subSceneIndices = [];
				addSubSceneListener();
			}
		}
		
		private function removeSubSceneListener():void 
		{
			if (subSceneChangeBehavior) {
				subSceneChangeBehavior.dispose();
				subSceneChangeBehavior = null;
			}
		}
		
		private function addSubSceneListener():void 
		{
			removeSubSceneListener();
			subSceneChangeBehavior = new SubSceneChangeBehavior(subSceneIndex, ShowSubScene, HideSubScene, instanceIndex);
		}
		
		
		private function ShowSubScene():void
		{
			_showSubScene = true;
			checkVis();
		}
		
		private function HideSubScene():void
		{
			_showSubScene = false;
			checkVis();
		}
		
		///////////////////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////////////////
		
		public function get subSceneIndices():Array 
		{
			return _subSceneIndices;
		}
		
		public function set subSceneIndices(value:Array):void
		{
			if (_subSceneIndices == value) return;
			_subSceneIndices = value;
			if (subSceneIndices == null || subSceneIndices.length == 0) removeSubSceneIndicesListener();
			else addSubSceneIndicesListener();
		}
		
		private function removeSubSceneIndicesListener():void 
		{
			for (var i:int = 0; i < subSceneIndices.length; ++i) {
				subSceneIndicesChangeBehaviors[i].dispose();
				subSceneIndicesChangeBehaviors[i] = null;
			}
		}
		
		private function addSubSceneIndicesListener():void 
		{
			removeSubSceneListener();
			subSceneIndicesChangeBehaviors = new Vector.<SubSceneIndicesChangeBehavior>();
			showSubSceneIndices = new Vector.<Boolean>();
			for (var i:int = 0; i < subSceneIndices.length; ++i) {
				showSubSceneIndices.push(false);
				subSceneIndicesChangeBehaviors.push(new SubSceneIndicesChangeBehavior(subSceneIndices[i], i, showSubSceneIndices, checkVis, instanceIndex));
			}
		}
		
		///////////////////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////////////////
		
		public function get languageIndex():int 
		{
			return _languageIndex;
		}
		
		public function set languageIndex(value:int):void 
		{
			if (_languageIndex == value) return;
			_languageIndex = value;
			if (languageIndex == -1) removeLanguageListener();
			else addLanguageListener();
		}
		
		private function removeLanguageListener():void 
		{
			if (languageChangeBehavior) {
				languageChangeBehavior.dispose();
				languageChangeBehavior = null;
			}
		}
		
		private function addLanguageListener():void 
		{
			removeLanguageListener();
			languageChangeBehavior = new LanguageChangeBehavior(languageIndex, ShowLanguage, HideLanguage, instanceIndex);
		}
		
		private function ShowLanguage():void
		{
			_showLanguage = true;
			checkVis();
		}
		
		private function HideLanguage():void
		{
			_showLanguage = false;
			checkVis();
		}
		
		protected function checkVis():void
		{
			if (active) {
				for (var i:int = 0; i < checkFunctions.length; i++) 
				{
					if (checkFunctions[i]() == false) {
						Hide();
						return;
					}
				}
				Show();
			}
		}
		
		public function showScene():Boolean
		{
			return _showScene;
		}
		
		public function allShowSceneIndices():Boolean 
		{
			if (sceneIndicesChangeBehaviors.length == 0) return true;
			else {
				for (var j:int = 0; j < showSceneIndices.length; ++j) {
					
					if (showSceneIndices[j]) return true;
				}
				return false;
			}
		}
		
		public function showSubScene():Boolean
		{
			return _showSubScene;
		}
		
		public function allShowSubSceneIndices():Boolean 
		{
			if (subSceneIndicesChangeBehaviors.length == 0) return true;
			else {
				for (var j:int = 0; j < showSubSceneIndices.length; ++j) {
					
					if (showSubSceneIndices[j]) return true;
				}
				return false;
			}
		}
		
		public function showLanguage():Boolean
		{
			return _showLanguage;
		}
		
	}
}



import blaze.behaviors.SubSceneChangeBehavior;

class SubSceneIndicesChangeBehavior
{
	private var subSceneChangeBehavior:SubSceneChangeBehavior;
	private var index:int;
	private var showSubSceneIndices:Vector.<Boolean>;
	private var callback:Function;
	
	public function SubSceneIndicesChangeBehavior(subSceneIndex:int, index:int, showSubSceneIndices:Vector.<Boolean>, callback:Function, instanceIndex:int)
	{
		this.index = index;
		this.showSubSceneIndices = showSubSceneIndices;
		this.callback = callback;
		subSceneChangeBehavior = new SubSceneChangeBehavior(subSceneIndex, Show, Hide, instanceIndex);
	}
	
	public function Show():void
	{
		showSubSceneIndices[index] = true;
		callback();
	}
	
	public function Hide():void
	{
		showSubSceneIndices[index] = false;
		callback();
	}
	
	public function dispose():void
	{
		subSceneChangeBehavior.dispose();
		subSceneChangeBehavior = null;
	}
}

import blaze.behaviors.SceneChangeBehavior;

class SceneIndicesChangeBehavior
{
	private var sceneChangeBehavior:SceneChangeBehavior;
	private var index:int;
	private var showSceneIndices:Vector.<Boolean>;
	private var callback:Function;
	
	public function SceneIndicesChangeBehavior(sceneIndex:int, index:int, showSceneIndices:Vector.<Boolean>, callback:Function, instanceIndex:int)
	{
		this.index = index;
		this.showSceneIndices = showSceneIndices;
		this.callback = callback;
		sceneChangeBehavior = new SceneChangeBehavior(sceneIndex, Show, Hide, instanceIndex);
	}
	
	public function Show():void
	{
		showSceneIndices[index] = true;
		callback();
	}
	
	public function Hide():void
	{
		showSceneIndices[index] = false;
		callback();
	}
	
	public function dispose():void
	{
		sceneChangeBehavior.dispose();
		sceneChangeBehavior = null;
	}
}