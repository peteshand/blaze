package  
{
	import away3d.containers.View3D;
	import blaze.model.language.LanguageModel;
	import blaze.model.render.RenderModel;
	import blaze.model.scene.SceneModel;
	import blaze.model.tick.Tick;
	import blaze.model.viewPort.ViewPort;
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import starling.core.Starling;
	/**
	 * ...
	 * @author P.J.Shand
	 * 
	 */
	public class Blaze 
	{
		public static var VERSION:String = "0.2.1";
		/** stage is of type flash.display.Stage, should be set at application initialization*/
		private static var _stage:Stage;
		private static var _instances:Vector.<BlazeInstance> = new Vector.<BlazeInstance>(8);
		
		public function Blaze() 
		{
			
		}
		
		/**
		 * RenderModel contains the Away3D and Starling render layers.
		 * <p>RenderModel can be accessed via Blaze.renderer</p>
		 */
		static public function get renderer():RenderModel 
		{
			return instance().renderer;
		}
		
		/**
		 * Tick handles the application tick loop.
		 * <p>Tick can be accessed via Blaze.tick</p>
		 */
		static public function get tick():Tick 
		{
			return instance().tick;
		}
		
		/**
		 * ViewPort contains the viewport Rectangle of the application.
		 * <p>ViewPort can be accessed via Blaze.viewPort</p>
		 */
		static public function get viewPort():ViewPort 
		{
			return instance().viewPort;
		}
		
		/**
		 * SceneModel contains the current scene and subscene index of the application.
		 * <p>SceneModel can be accessed via Blaze.scene</p>
		 */
		static public function get sceneModel():SceneModel 
		{
			return instance().sceneModel;
		}
		
		/**
		 * LanguageModel contains the current language index of the application.
		 * <p>LanguageModel can be accessed via Blaze.language</p>
		 */
		static public function get language():LanguageModel 
		{
			return instance().language;
		}
		
		static public function get stage():Stage 
		{
			return _stage;
		}
		
		static public function set stage(value:Stage):void 
		{
			_stage = value;
			for (var i:int = 0; i < _instances.length; i++) 
				if (_instances[i]) _instances[i].stage = value;
		}
		
		/**
		 * instance(index) can be used to access a BlazeInstance.
		 * You may want to use instances if your application requires split screens where 
		 * more than one 3d context, scenes and languages can be selected at the same time
		 */
		static public function instance(index:int=0):BlazeInstance
		{
			if (!_instances[index]) _instances[index] = new BlazeInstance(index, _stage);
			return _instances[index];
		}
		
		
		
		
		static public var awayCollectionData:Array = new Array();
		static public function addView3D(View3DClass:Class, id:String, renderIndex:int = -1, instanceIndex:int = 0):View3D
		{
			var view3D:View3D = instance(instanceIndex).renderer.addView3D(View3DClass, id, renderIndex);
			awayCollectionData.push([view3D, id, instanceIndex]);
			return view3D;
		}
		
		/** Initialize away3d linked mediators */
		static public function set contextView(view:DisplayObjectContainer):void 
		{
			for (var i:int = 0; i < awayCollectionData.length; i++) view.addChild(awayCollectionData[i][0]);
		}
		
		static public var starlingCollectionData:Array = new Array();
		static public function addStarling(StarlingLayerClass:Class, id:String, renderIndex:int = -1, instanceIndex:int = 0):Starling
		{
			var starling:Starling = instance(instanceIndex).renderer.addStarling(StarlingLayerClass, id, renderIndex);
			starlingCollectionData.push([starling, id, instanceIndex]);
			return starling;
		}
	}
}