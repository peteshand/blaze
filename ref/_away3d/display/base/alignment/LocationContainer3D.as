package imag.masdar.core.view.away3d.display.base.alignment 
{
	import away3d.containers.ObjectContainer3D;
	import com.greensock.TweenLite;
	import flash.events.Event;
	import flash.geom.Point;
	import imag.masdar.core.Core;
	import imag.masdar.core.view.away3d.display.base.ResizeContainer3D;
	
	/**
	 * ...
	 * @author Pete Shand
	 */
	public class LocationContainer3D extends ObjectContainer3D 
	{
		private var core:Core = Core.getInstance();
		private var location:Point;
		public var child:ObjectContainer3D
		
		public function LocationContainer3D(_child:ObjectContainer3D, _location:Point) 
		{
			child = _child;
			addChild(child);
			location = _location;
			
			OnStageResize();
			core.stage.addEventListener(Event.RESIZE, OnStageResize);
		}
		
		private function OnStageResize(event:Event=null):void
		{
			this.x = core.model.viewportModel.width * (location.x - 0.5);
			this.y = core.model.viewportModel.height * -(location.y - 0.5);
		}
	}
}