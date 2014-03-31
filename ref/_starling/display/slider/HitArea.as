package imag.masdar.core.view.starling.display.slider 
{
	import flash.geom.Point;
	import imag.masdar.core.model.scroll.ScrollObject;
	import imag.masdar.core.utils.layout.Alignment;
	import imag.masdar.core.view.starling.display.base.BaseStarlingObject;
	import starling.display.Image;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author Pete Shand
	 */
	public class HitArea extends BaseStarlingObject
	{
		private var image:Image;
		private var touchPressLoc:Point = new Point();
		private var touchScrollLoc:Point = new Point();
		private var scrollH:Boolean;
		private var scrollV:Boolean;
		private var pixelDifference:Point = new Point();
		public var pixelPercentage:Point = new Point(1,1);
		private var scrollObject:ScrollObject;
		private var scrollbarGap:int;
		
		public function HitArea(scrollObject:ScrollObject, scrollH:Boolean, scrollV:Boolean, scrollbarGap:int=80, languageIndex:int=0) 
		{
			this.languageIndex = languageIndex;
			this.scrollObject = scrollObject;
			this.scrollbarGap = scrollbarGap;
			
			this.scrollH = scrollH;
			this.scrollV = scrollV;
			
		}
		
		public function init(scrollWidth:Number, scrollHeight:Number):void
		{
			pixelPercentage.x = 1 / scrollWidth;
			pixelPercentage.y = 1 / scrollHeight;
		}
		
		override protected function OnAdd(e:Event):void 
		{
			super.OnAdd(e);
			
			var texture:Texture;
			if (languageIndex == 0) texture = Texture.fromColor(8, 8, 0x00FF0000);
			else texture = Texture.fromColor(8, 8, 0x0000FF00);
			image = new Image(texture);
			addChild(image);
			
			attachTouchListenerTo(image);
			
			addResizeListener();
			
			scrollObject.activeChange.add(OnActiveChange);
		}
		
		private function OnActiveChange():void 
		{
			if (scrollObject.active) attachTouchListenerTo(image);
			else removeTouchListenerTo(image);
		}
		
		override protected function OnResize():void 
		{
			if (config.horizontalScroll) {
				image.width = core.model.viewportModel.width;
				image.height = stage.stageHeight - scrollbarGap;
				if (config.scrollbarPlacement == Alignment.TOP) image.y = scrollbarGap;
			}
			else if (config.verticalScroll){
				image.width = core.model.viewportModel.width - scrollbarGap;
				image.width = core.model.viewportModel.width - scrollbarGap;
				image.height = stage.stageHeight;
				if (config.scrollbarPlacement == Alignment.LEFT) image.x = scrollbarGap;
			}
		}
		
		override protected function OnTouchBegin(touch:Touch):void
		{
			super.OnTouchBegin(touch);
			
			if (!scrollObject.isBeingDragged) {
				scrollObject.touchDragIndex = touch.id;
				if (scrollH) {
					touchPressLoc.x = touch.globalX;
					touchScrollLoc.x = scrollObject.fractionLagX;
					scrollObject.isBeingDragged = true;
				}
				if (scrollV) {
					touchPressLoc.y = touch.globalY;
					touchScrollLoc.y = scrollObject.fractionLagY;
					scrollObject.isBeingDragged = true;
				}
			}
		}
		
		override protected function OnTouchMove(touch:Touch):void
		{
			super.OnTouchMove(touch);
			if (scrollObject.touchDragIndex == touch.id){
				if (scrollH) {
					pixelDifference.x = ((touchPressLoc.x - touch.globalX) * pixelPercentage.x) * config.scrollMultiplier;
					pixelDifference.x *= 60 / core.stage.frameRate;
					if (languageIndex == 1) pixelDifference.x *= -1;
					scrollObject.fractionX = touchScrollLoc.x + pixelDifference.x;
				}
				if (scrollV) {
					pixelDifference.y = ((touchPressLoc.y - touch.globalY) * pixelPercentage.y) * config.scrollMultiplier;
					pixelDifference.y *= 60 / core.stage.frameRate;
					scrollObject.fractionY = touchScrollLoc.y + pixelDifference.y;
				}
			}
		}
		
		override protected function OnTouchEnd(touch:Touch):void
		{
			super.OnTouchEnd(touch);
			if (scrollObject.touchDragIndex == touch.id){
				scrollObject.isBeingDragged = false;
				scrollObject.touchDragIndex = -1;
			}
		}
	}
}