package  
{
	import blaze.model.language.LanguageModel;
	import blaze.model.render.RenderModel;
	import blaze.model.scene.SceneModel;
	import blaze.model.tick.Tick;
	import blaze.model.viewPort.ViewPort;
	import flash.display.Stage;
	/**
	 * ...
	 * @author P.J.Shand
	 */
	public class BlazeInstance 
	{
		public var index:int;
		public var stage:Stage;
		private var _language:LanguageModel;
		private var _sceneModel:SceneModel;
		
		private var _renderer:RenderModel;
		private var _tick:Tick;
		private var _viewPort:ViewPort;
		
		public function BlazeInstance(index:int, stage:Stage) 
		{
			this.index = index;
			this.stage = stage;
		}
		
		/**
		 * RenderModel contains the Away3D and Starling render layers.
		 * <p>RenderModel can be accessed via Blaze.instance(index).renderer</p>
		 */
		public function get renderer():RenderModel 
		{
			if (!_renderer) {
				if (!stage) throw new Error("Blaze.stage must be set before renderer can be accessed");
				_renderer = new RenderModel(index);
				_renderer.init(stage);
			}
			return _renderer;
		}
		
		/**
		 * Tick handles the application tick loop.
		 * <p>Tick can be accessed via Blaze.instance(index).tick</p>
		 */
		public function get tick():Tick 
		{
			if (!_tick) {
				if (!stage) throw new Error("Blaze.stage must be set before tick can be accessed");
				_tick = new Tick();
				_tick.init(stage);
			}
			return _tick;
		}
		
		/**
		 * ViewPort currents the viewport Rectangle of the application.
		 * <p>ViewPort can be accessed via Blaze.instance(index).viewPort</p>
		 */
		public function get viewPort():ViewPort 
		{
			if (!_viewPort) {
				if (!stage) throw new Error("Blaze.stage must be set before viewPort can be accessed");
				_viewPort = new ViewPort();
				_viewPort.init(stage, renderer);
			}
			return _viewPort;
		}
		
		/**
		 * SceneModel currents the current scene and subscene index of the application.
		 * <p>SceneModel can be accessed via Blaze.instance(index).scene</p>
		 */
		public function get sceneModel():SceneModel 
		{
			if (!_sceneModel) _sceneModel = new SceneModel();
			return _sceneModel;
		}
		
		/**
		 * LanguageModel currents the current language index of the application.
		 * <p>LanguageModel can be accessed via Blaze.instance(index).language</p>
		 */
		public function get language():LanguageModel 
		{
			if (!_language) _language = new LanguageModel();
			return _language;
		}
	}

}