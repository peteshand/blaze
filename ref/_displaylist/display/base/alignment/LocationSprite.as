package imag.masdar.core.view.displaylist.display.base.alignment 
{
	import com.greensock.TweenLite;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import imag.masdar.core.Core;
	import imag.masdar.core.view.away3d.display.base.ResizeContainer3D;
	
	/**
	 * ...
	 * @author Pete Shand
	 */
	public class LocationSprite extends Sprite 
	{
		private var core:Core = Core.getInstance();
		private var location:Point;
		public var child:DisplayObject
		public var scaleToScreen:Boolean;
		
		public function LocationSprite(_child:DisplayObject, _location:Point, _scaleToScreen:Boolean=false) 
		{
			child = _child;
			addChild(child);
			location = _location;
			scaleToScreen = _scaleToScreen;
			
			OnStageResize();
			core.stage.addEventListener(Event.RESIZE, OnStageResize);
		}
		
		private function OnStageResize(event:Event=null):void
		{
			this.x = core.model.viewportModel.width * location.x;
			this.y = core.model.viewportModel.height * location.y;
			
			if (scaleToScreen){
				this.scaleX = core.model.viewportModel.stageScale();
				this.scaleY = core.model.viewportModel.stageScale();
			}
		}
	}
}