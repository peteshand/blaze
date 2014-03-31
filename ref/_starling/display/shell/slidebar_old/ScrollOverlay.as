package imag.masdar.core.view.starling.display.shell.slidebar_old 
{
	import com.greensock.easing.Strong;
	import com.imagination.ge.core.model.ScrollingModel;
	import com.imagination.ge.core.ui.view.baseClasses.StarlingSpriteBase;
	import flash.events.Event;
	import flash.geom.Point;
	import org.osflash.signals.Signal;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	/**
	 * ...
	 * @author Pete Shand
	 */
	public class ScrollOverlay extends StarlingSpriteBase
	{
		private var scrollingModel:ScrollingModel = ScrollingModel.getInstance();
		
		private var dragging:Boolean = false;
		private var touchInteractionTypes:Object = new Object();
		private var dragMulti:Number = 1;
		
		//private var touchPanelLoc:Point = new Point();
		//private var touchPressLoc:Point = new Point();
		//private var targetLoc:Point = new Point();
		
		private var mouseClickLoc:Point = new Point();
		private var objectClickLoc:Point = new Point();
		private var percentageClickLoc:Point = new Point();
		private var targetPoint:Point = new Point();
		
		private var dragItem:Sprite;
		private var scrollingContent:Boolean = false;
		private var xDrag:Boolean = true;
		private var yDrag:Boolean = false;
		private var mutli:Point = new Point(2, 2);
		public var direction:int = 1;
		public var release:Signal = new Signal();
		
		public function ScrollOverlay(dragArea:Image, _dragItem:Sprite) 
		{
			dragItem = _dragItem;
			attachTouchListenerTo(dragArea);
		}
		
		override protected function OnTouchBegin(touch:Touch):void
		{
			if (!dragging) {
				touchInteractionTypes[touch.id] = 'dragging';
				dragging = true;
				mouseClickLoc.x = touch.globalX;
				mouseClickLoc.y = touch.globalY;
				objectClickLoc.x = dragItem.x;
				objectClickLoc.y = dragItem.y;
				percentageClickLoc.x = scrollingModel.fractionLagX;
				percentageClickLoc.y = scrollingModel.fractionLagY;
			}
		}
		
		override protected function OnTouchMove(touch:Touch):void
		{
			if (touchInteractionTypes[touch.id] == 'dragging') {
				
				if (touch.globalY > mouseClickLoc.y + 10 || touch.globalY < mouseClickLoc.y - 10 || touch.globalX > mouseClickLoc.x + 10 || touch.globalX < mouseClickLoc.x - 10) {
					scrollingModel.isDragging = true;
					//if (scrollingContent){
						if (xDrag) scrollingModel.updateXY(objectClickLoc.x - ((mouseClickLoc.x - touch.globalX) * mutli.x * direction), Infinity);
						//if (yDrag) scrollingModel.updateXY(Infinity, objectClickLoc.y - ((mouseClickLoc.y - touch.globalY) * mutli.y * direction));
					//}
					//else {
						//if (xDrag) scrollingModel.updateXYPercentage((objectClickLoc.x - ((mouseClickLoc.x - touch.globalX) * direction * mutli.x)) / (1920 - dragItem.width), Infinity);
						//if (yDrag) scrollingModel.updateXYPercentage(Infinity, (objectClickLoc.y - ((mouseClickLoc.y - touch.globalY) * direction)) / (1080 - dragItem.height));
					//}
				}
				scrollingModel.scrollingSignal.dispatch();
			}
		}
		
		private function FixBounds(x:Number):Number 
		{
			return 0;
			/*if (x < boundMin.x)	x = boundMin.x - Math.pow((boundMin.x - x), 0.7);
			else if (x > boundMax.x) x = boundMax.x + Math.pow((x - boundMax.x), 0.9);
			return x;*/
		}
		
		private function tweenToWithinBounds(time:Number, ease:Function):void
		{
			//if (!isDragging){
				
				/*if (englishSprite.x < boundMin.x) {
					TweenLite.to(englishSprite, time, { x:boundMin.x, ease:ease } );
					TweenLite.to(targetLoc, time, { x:boundMin.x, ease:ease } );
				}
				else if (englishSprite.x > boundMax.x) {
					TweenLite.to(englishSprite, time, { x:boundMax.x, ease:ease } );
					TweenLite.to(targetLoc, time, { x:boundMax.x, ease:ease } );
				}*/
			//}
		}
		
		override protected function OnTouchEnd(touch:Touch):void
		{
			/*if (touchInteractionTypes[touch.id] == 'dragging') {
				dragging = false;
				touchInteractionTypes[touch.id] = null;
				
				tweenToWithinBounds(1, Strong.easeOut);
			}*/
			if (touchInteractionTypes[touch.id] == 'dragging') {
				touchInteractionTypes[touch.id] = null;
				dragging = false;
				scrollingModel.isDragging = false;
				scrollingModel.tweenToWithinBounds(1, Strong.easeOut, true, false);
				release.dispatch(scrollingModel.x);
			}
		}
		
		private function UpdateDrag(e:Event):void 
		{
			/*englishSprite.x = FixBounds(targetLoc.x);
			englishSprite.x = ((englishSprite.x * scrollingModel.scrollLag) + targetLoc.x) / (scrollingModel.scrollLag + 1);
			
			arabicSprite.x = -arabicSprite.width + 1920 - 300 + -englishSprite.x;
			
			scrollingModel.updateXY(targetLoc.x,0);*/
		}
	}

}