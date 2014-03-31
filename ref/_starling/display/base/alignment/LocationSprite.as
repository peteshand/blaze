package imag.masdar.core.view.starling.display.base.alignment 
{
	import flash.geom.Point;
	import imag.masdar.core.view.starling.display.base.BaseStarlingObject;
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.events.Event;
	
	/**
	 * ...
	 * @author Pete Shand
	 */
	public class LocationSprite extends BaseStarlingObject 
	{
		private var location:Point;
		public var scaleToScreen:Boolean;
		
		public function LocationSprite(child:DisplayObject, _location:Point, _scaleToScreen:Boolean=false) 
		{
			addChild(child);
			location = _location;
			scaleToScreen = _scaleToScreen;
			addEventListener(Event.ADDED_TO_STAGE, OnAdd);
		}
		
		override protected function OnAdd(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, OnAdd);
			addResizeListener();
			OnResize();
		}
		
		override protected function OnResize():void
		{
			this.x = Math.round(core.model.viewportModel.width * location.x);
			this.y = Math.round(core.model.viewportModel.height * location.y);
			
			if (scaleToScreen){
				this.scaleX = core.model.viewportModel.stageScale();
				this.scaleY = core.model.viewportModel.stageScale();
			}
		}
	}
}