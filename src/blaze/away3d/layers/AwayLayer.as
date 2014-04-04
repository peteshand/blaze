package blaze.away3d.layers 
{
	import away3d.cameras.Camera3D;
	import away3d.cameras.lenses.OrthographicLens;
	import away3d.cameras.lenses.PerspectiveLens;
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.Scene3D;
	import away3d.containers.View3D;
	import away3d.core.pick.IPicker;
	import away3d.core.render.RendererBase;
	import blaze.away3d.BlazeCamera3D;
	import blaze.away3d.BlazeContainer3D;
	import blaze.away3d.BlazeScene3D;
	import blaze.model.language.LanguageModel;
	import blaze.model.scene.SceneModel;
	import blaze.model.tick.Tick;
	//import blaze.away3d.managers.VirtualCursor3DManager;
	import blaze.model.render.RenderModel;
	import blaze.model.viewPort.ViewPort;
	import flash.display.Sprite;
	import flash.display3D.Context3DProfile;
	import flash.events.Event;
	import flash.geom.Point;
	import org.osflash.signals.Signal;
	
	/**
	 * ...
	 * @author P.J.Shand
	 */
	public class AwayLayer extends View3D implements IAwayLayer
	{
		public var renderModel:RenderModel;
		public var viewPort:ViewPort;
		public var sceneModel:SceneModel;
		public var language:LanguageModel;
		public var tick:Tick;
		
		public var lens:PerspectiveLens;
		public var orthographicLens:OrthographicLens;
		
		public var onAddToStage:Signal = new Signal();
		public var id:String;
		public var instanceIndex:int;
		
		private var _root:BlazeContainer3D;
		//protected var _virtualCursor3DManager:VirtualCursor3DManager;
		
		public function AwayLayer(instanceIndex:int, scene:Scene3D = null, camera1:Camera3D = null, renderer:RendererBase = null, forceSoftware:Boolean = false, profile:String = "baseline") 
		{
			this.instanceIndex = instanceIndex;
			renderModel = Blaze.instance(instanceIndex).renderer;
			viewPort = Blaze.instance(instanceIndex).viewPort;
			sceneModel = Blaze.instance(instanceIndex).sceneModel;
			language = Blaze.instance(instanceIndex).language;
			tick = Blaze.instance(instanceIndex).tick;
			
			super(new BlazeScene3D(instanceIndex), new BlazeCamera3D(viewPort), renderer, forceSoftware, profile);
			
			camera.z = -1000;
			lens = PerspectiveLens(camera.lens);
			lens.fieldOfView = 90;
			
			this.shareContext = true;
			this.stage3DProxy = renderModel.stage3DProxy;
			
			/*_virtualCursor3DManager = new VirtualCursor3DManager();
			_virtualCursor3DManager.view = this;
			_virtualCursor3DManager.enableMouseListeners(this);*/
			
			addEventListener(Event.ADDED_TO_STAGE, OnAdd);
		}
		
		protected function OnAdd(e:Event):void 
		{
			_root = new BlazeContainer3D();
			scene.addChild(_root);
			
			removeEventListener(Event.ADDED_TO_STAGE, OnAdd);
			onAddToStage.dispatch();
			viewPort.update.add(OnViewPortUpdate);
		}
		
		private function OnViewPortUpdate():void 
		{
			this.width = viewPort.rect.width;
			this.height = viewPort.rect.height;
			this.x = viewPort.rect.x;
			this.y = viewPort.rect.y;
			
			for (var i:int = 0; i < scene.numChildren; ++i) {
				ApplyScaleOffset(scene.getChildAt(i));
			}
			
			
			
		}
		
		private function ApplyScaleOffset(objectContainer3D:ObjectContainer3D):void
		{
			if (objectContainer3D is BlazeContainer3D){
				var blazeContainer3D:BlazeContainer3D = BlazeContainer3D(objectContainer3D);
				if (blazeContainer3D.scaleToScreen) {
					blazeContainer3D.screenScale = orthographicOffsetScale(blazeContainer3D.z);
				}				
			}
			for (var i:int = 0; i < objectContainer3D.numChildren; ++i) {
				ApplyScaleOffset(objectContainer3D.getChildAt(i));
			}
		}
		
		private function orthographicOffsetScale(z:Number):Number
		{
			return (Math.abs(camera.z - this.z) + z) / this.height * Math.tan(PerspectiveLens(camera.lens).fieldOfView * Math.PI / 180 / 2) * 2;
		}
		
		public function update():void 
		{
			this.render();
		}
		
		override public function render():void
		{
			super.render();
			
			/*_virtualCursor3DManager.updateCollider();
			
			if (!_shareContext) {
				_virtualCursor3DManager.fireTouchEvents();
			}*/
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			/*_virtualCursor3DManager.disableTouchListeners(this);
			_virtualCursor3DManager.dispose();
			_virtualCursor3DManager = null;*/
		}
		
		/*public function get virtualCursorPicker():IPicker
		{
			return _virtualCursor3DManager.touchPicker;
		}
		
		public function set virtualCursorPicker(value:IPicker):void
		{
			_virtualCursor3DManager.touchPicker = value;
		}*/
		
		public function addChildAtAlignment(child:ObjectContainer3D, alignment:String):ObjectContainer3D
		{
			return _root.addChildAtAlignment(child, alignment);
		}
		
		public function addChildAtPoint(child:ObjectContainer3D, location:Point):ObjectContainer3D
		{
			return _root.addChildAtPoint(child, location);
		}
		
	}

}