package imag.masdar.core.view.starling.layers 
{
	import imag.masdar.core.Core;
	import imag.masdar.core.model.rendering.RenderModel;
	import starling.display.DisplayObject;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.events.Event;
	
	/**
	 * ...
	 * @author Pete Shand
	 */
	public class BaseStarlingLayer extends Sprite 
	{
		protected var core:Core = Core.getInstance();
		protected var renderModel:RenderModel;
		protected var _starling:Starling;
		protected var active:Boolean = false;
		
		public function BaseStarlingLayer() 
		{
			addEventListener(Event.ADDED_TO_STAGE, OnAdd);
			renderModel = core.model.renderModel;
		}
		protected function OnAdd(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, OnAdd);
		}
		public function setStarling(starling:Starling):void {
			this.starling = starling;
		}
		
		public function update():void 
		{
			if (_starling && active) _starling.nextFrame();	
		}
		
		public function set starling(value:Starling):void 
		{
			_starling = value;
			stage.addEventListener(Event.RESIZE, OnStageResize);
			OnStageResize();
		}
		
		protected function OnStageResize(e:Event=null):void 
		{
			_starling.stage.stageWidth = core.model.viewportModel.width;
			_starling.stage.stageHeight = core.model.viewportModel.height;
		}
	}
}