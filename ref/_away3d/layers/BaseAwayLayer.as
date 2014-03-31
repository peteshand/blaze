package imag.masdar.core.view.away3d.layers 
{
	import away3d.cameras.Camera3D;
	import away3d.cameras.lenses.OrthographicLens;
	import away3d.cameras.lenses.PerspectiveLens;
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.Scene3D;
	import away3d.containers.View3D;
	import away3d.core.math.Matrix3DUtils;
	import flash.display.Sprite;
	import flash.display3D.Context3DProfile;
	import flash.events.Event;
	import flash.geom.Vector3D;
	import imag.masdar.core.Core;
	import imag.masdar.core.model.rendering.RenderModel;
	import imag.masdar.core.utils.classTools.ClassTools;
	import imag.masdar.core.view.away3d.display.base.ResizeContainer3D;
	import org.osflash.signals.Signal;
	
	/**
	 * ...
	 * @author Pete Shand
	 */
	public class BaseAwayLayer extends Sprite 
	{
		protected var core:Core = Core.getInstance();
		protected var interactive:Boolean = true;
		
		protected var view3D:View3D;
		protected var scene:Scene3D;
		protected var camera:Camera3D;
		protected var lens:PerspectiveLens;
		protected var orthographicLens:OrthographicLens;
		protected var renderModel:RenderModel;
		public var onAddToStage:Signal = new Signal();
		
		public function BaseAwayLayer() 
		{
			addEventListener(Event.ADDED_TO_STAGE, OnAdd);
		}
		
		protected function OnAdd(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, OnAdd);
			
			renderModel = core.model.renderModel;
			
			view3D = new View3D(null, null, null, false, Context3DProfile.BASELINE_EXTENDED, interactive);
			view3D.interactiveObject = stage;
			scene = view3D.scene;
			camera = view3D.camera;
			camera.z = -1000;
			lens = PerspectiveLens(camera.lens);
			
			view3D.shareContext = true;
			view3D.stage3DProxy = renderModel.stage3DProxy;
			
			addChild(view3D);
			
			lens.fieldOfView = 90;
			
			//renderModel.Add3DLayer(this);
			
			onAddToStage.dispatch();
			
			stage.addEventListener(Event.RESIZE, OnStageResize);
			OnStageResize();
		}
		
		protected function OnStageResize(e:Event=null):void 
		{
			view3D.width = core.model.viewportModel.width;
			view3D.height = core.model.viewportModel.height;
			view3D.x = core.model.viewportModel.viewport.x;
			view3D.y = core.model.viewportModel.viewport.y;
			
			if (orthographicLens) orthographicLens.projectionHeight = core.model.viewportModel.height;
			else updatePixelPerfection();
		}
		
		protected function updatePixelPerfection():void 
		{
			for (var i:int = 0; i < scene.numChildren; ++i) {
				ApplyScaleOffset(scene.getChildAt(i));
			}
		}
		
		protected function ApplyScaleOffset(objectContainer3D:ObjectContainer3D):void
		{
			//if (ClassTools.classExtends(objectContainer3D, "ResizeContainer3D")){
			if (objectContainer3D is ResizeContainer3D){
				var resizeContainer3D:ResizeContainer3D = ResizeContainer3D(objectContainer3D);
				if (resizeContainer3D.scaleToScreen) {
					resizeContainer3D.screenScale = orthographicOffsetScale(resizeContainer3D.z);
				}
				for (var i:int = 0; i < objectContainer3D.numChildren; ++i) {
					ApplyScaleOffset(objectContainer3D.getChildAt(i));
				}
			}
		}
		
		protected function orthographicOffsetScale(z:Number):Number
		{
			return (Math.abs(camera.z - this.z) + z) / view3D.height * Math.tan(PerspectiveLens(camera.lens).fieldOfView * Math.PI / 180 / 2) * 2;
		}
		
		public function pixelPerfectCameraValue(camera:Camera3D, h:Number):Number {
			var h:Number = h;
			var fieldOfView:Number = PerspectiveLens(camera.lens).fieldOfView;
			var fovy:Number = fieldOfView * Math.PI / 180;
			return -(h/2) / Math.tan(fovy/2);
		}
		
		public function update():void 
		{
			view3D.render();
		}
	}
}