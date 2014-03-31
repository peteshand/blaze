package imag.masdar.core.view.starling.display.base 
{
	import blaze.behaviors.SuperSceneChangeBehavior;
	
	/**
	 * ...
	 * @author Pete Shand
	 */
	public class SceneSprite extends PrimordialStarlingSprite 
	{
		// Controls Show/Hide on sceneIndex, subSceneIndex, subScenendices, and languageIndex change
		private var superSceneChangeBehavior:SuperSceneChangeBehavior;
		
		public function SceneSprite() 
		{
			superSceneChangeBehavior = new SuperSceneChangeBehavior(Show, Hide);
		}
		
		public function get sceneIndex():int					{ return superSceneChangeBehavior.sceneIndex; }
		public function set sceneIndex(value:int):void			{ superSceneChangeBehavior.sceneIndex = value; }
		
		public function get sceneIndices():Array				{ return superSceneChangeBehavior.sceneIndices; }
		public function set sceneIndices(value:Array):void		{ superSceneChangeBehavior.sceneIndices = value; }
		
		public function get subSceneIndex():int					{ return superSceneChangeBehavior.subSceneIndex; }
		public function set subSceneIndex(value:int):void		{ superSceneChangeBehavior.subSceneIndex = value; }
		
		public function get subSceneIndices():Array				{ return superSceneChangeBehavior.subSceneIndices; }
		public function set subSceneIndices(value:Array):void	{ superSceneChangeBehavior.subSceneIndices = value; }
		
		public function get languageIndex():int 				{ return superSceneChangeBehavior.languageIndex; }
		public function set languageIndex(value:int):void 		{ superSceneChangeBehavior.languageIndex = value; }
		
		public function get ignoreShowHide():Boolean 			{ return superSceneChangeBehavior.active; }
		public function set ignoreShowHide(value:Boolean):void 	{ superSceneChangeBehavior.active = value; }
	}
}