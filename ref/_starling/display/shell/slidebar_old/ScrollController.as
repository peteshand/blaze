package imag.masdar.core.view.starling.display.shell.slidebar_old 
{
	import com.greensock.easing.Strong;
	import com.imagination.ge.core.model.ScrollingModel;
	import com.imagination.ge.core.view.starling.language.LanguageSprite;
	import flash.geom.Point;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	/**
	 * ...
	 * @author Pete Shand
	 */
	public class ScrollController 
	{
		private var dragItem:DisplayObject;
		private var scrollingModel:ScrollingModel = ScrollingModel.getInstance();
		private var scrollingContent:Boolean;
		
		private var mEnabled:Boolean = true;
		private var mUseHandCursor:Boolean = true;
		
		private var mouseClickLoc:Point = new Point();
		private var objectClickLoc:Point = new Point();
		private var percentageClickLoc:Point = new Point();
		private var targetPoint:Point = new Point();
		private var parallax:Boolean;
		private var parallaxOffset:Number;
		private var xDrag:Boolean = true;
		private var yDrag:Boolean = false;
		public var mutli:Point = new Point(1, 1);
		
		private var touchInteractionTypes:Object = new Object();
		private var dragging:Boolean = false;
		private var _active:Boolean = true;
		private var direction:int;
		
		public function ScrollController(_dragItem:DisplayObject, _scrollingContent:Boolean=true, _parallax:Boolean=false, _parallaxOffset:Number=0, _xDrag:Boolean=true, _yDrag:Boolean=false, _direction:int = 1) 
		{
			scrollingContent = _scrollingContent;
			dragItem = _dragItem;
			parallax = _parallax;
			parallaxOffset = _parallaxOffset;
			xDrag = _xDrag;
			yDrag = _yDrag;
			direction = _direction;
			
			dragItem.addEventListener(TouchEvent.TOUCH, onTouch);
			core.model.tick.render.add(OnTick);
		}	
		
		private var percentageX:Number;
		private var percentageY:Number;
		
		private function OnTick(timeDelta:int):void 
		{
			if (active){
				if (scrollingContent) {
					if (int(dragItem.x) != scrollingModel.x || int(dragItem.y) != scrollingModel.y) {
						if (xDrag) {
							targetPoint.x = ((targetPoint.x * scrollingModel.scrollLag) + scrollingModel.x) / (scrollingModel.scrollLag + 1);
							dragItem.x = int(targetPoint.x);
						}
						if (yDrag) {
							targetPoint.y = ((targetPoint.y * scrollingModel.scrollLag) + scrollingModel.y) / (scrollingModel.scrollLag + 1);
							dragItem.y = int(targetPoint.y);
						}
					}
				}
				else {
					if (xDrag) {
						percentageX = scrollingModel.percentageX;
						if (direction == -1) percentageX = 1 - percentageX;
						targetPoint.x = ((targetPoint.x * scrollingModel.scrollLag) + ((1 - percentageX) * (1920 - dragItem.width))) / (scrollingModel.scrollLag + 1);
						if (String(targetPoint.x) == 'NaN') targetPoint.x = 0;
						dragItem.x = int(targetPoint.x);
					}
					if (yDrag) {
						percentageY = scrollingModel.percentageY;
						if (direction == -1) percentageY = 1 - percentageY;
						targetPoint.y = ((targetPoint.y * scrollingModel.scrollLag) + ((1 - percentageY) * (1080 - dragItem.height))) / (scrollingModel.scrollLag + 1);
						if (String(targetPoint.y) == 'NaN') targetPoint.y = 0;
						dragItem.y = int(targetPoint.y);
					}
					scrollingModel.movingSignal.dispatch();
				}
				
				if (parallax) UpdateChildrenZ();
			}
		}
		
		private function UpdateChildrenZ():void 
		{
			for (var i:int = 0; i < Sprite(dragItem).numChildren; i++) 
			{
				if(Sprite(dragItem).getChildAt(i) is LanguageSprite) {
					var languageSprite:LanguageSprite = LanguageSprite(Sprite(dragItem).getChildAt(i));
					languageSprite.x = languageSprite.startLoc.x + (dragItem.x * (languageSprite.z / 100));
					languageSprite.x -= (languageSprite.offsetValue * parallaxOffset);
				}
			}
		}
		
		private function onTouch(event:TouchEvent):void 
		{
			Mouse.cursor = (mUseHandCursor && mEnabled && event.interactsWith(dragItem)) ? 
                MouseCursor.BUTTON : MouseCursor.AUTO;
			
			var touchBegans:Vector.<Touch> = event.getTouches(dragItem, TouchPhase.BEGAN);
			var touchMoves:Vector.<Touch> = event.getTouches(dragItem, TouchPhase.MOVED);
			var touchEnds:Vector.<Touch> = event.getTouches(dragItem, TouchPhase.ENDED);
			if (!mEnabled) return;
			
			if (touchBegans.length > 0 && !scrollingModel.isDragging) ParseTouchBegins(touchBegans);
			if (touchMoves.length > 0) ParseTouchMoves(touchMoves);
            if (touchEnds.length > 0) ParseTouchEnds(touchEnds);
		}
		
		protected function ParseTouchBegins(touchVector:Vector.<Touch>):void
		{
			for (var i:int = 0; i < touchVector.length; ++i) {
				OnTouchBegin(touchVector[i]);
			}
		}
		
		protected function ParseTouchMoves(touchVector:Vector.<Touch>):void
		{
			for (var i:int = 0; i < touchVector.length; ++i) {
				OnTouchMove(touchVector[i]);
			}
		}
		
		protected function ParseTouchEnds(touchVector:Vector.<Touch>):void
		{
			for (var i:int = 0; i < touchVector.length; ++i) {
				OnTouchEnd(touchVector[i]);
			}
		}
		
		private function OnTouchBegin(touch:Touch):void
		{
			if (!dragging) {
				scrollingModel.killTweens();
				touchInteractionTypes[touch.id] = 'dragging';
				dragging = true;
				mouseClickLoc.x = touch.globalX;
				mouseClickLoc.y = touch.globalY;
				objectClickLoc.x = dragItem.x;
				objectClickLoc.y = dragItem.y;
				percentageClickLoc.x = scrollingModel.percentageX;
				percentageClickLoc.y = scrollingModel.percentageY;
			}
		}
		
		private function OnTouchMove(touch:Touch):void
		{
			if (active){
				if (touchInteractionTypes[touch.id] == 'dragging') {
					scrollingModel.killTweens();
					if (touch.globalY > mouseClickLoc.y + 10 || touch.globalY < mouseClickLoc.y - 10 || touch.globalX > mouseClickLoc.x + 10 || touch.globalX < mouseClickLoc.x - 10) {
						scrollingModel.isDragging = true;
						
						if (scrollingContent){
							//if (xDrag) scrollingModel.updateXY(objectClickLoc.x - ((mouseClickLoc.x - touch.globalX) * mutli.x * 1), Infinity);
							//if (yDrag) scrollingModel.updateXY(Infinity, objectClickLoc.y - ((mouseClickLoc.y - touch.globalY) * mutli.y * 1));
						}
						else {
							if (direction == 1) {
								if (xDrag) scrollingModel.updateXYPercentage((objectClickLoc.x - ((mouseClickLoc.x - touch.globalX) * 1)) / (1920 - dragItem.width), Infinity);
								if (yDrag) scrollingModel.updateXYPercentage(Infinity, (objectClickLoc.y - ((mouseClickLoc.y - touch.globalY) * 1)) / (1080 - dragItem.height));
							}
							else {
								if (xDrag) scrollingModel.updateXYPercentage(1 - ((objectClickLoc.x - ((mouseClickLoc.x - touch.globalX) * 1)) / (1920 - dragItem.width)), Infinity);
								if (yDrag) scrollingModel.updateXYPercentage(Infinity, 1 - ((objectClickLoc.y - ((mouseClickLoc.y - touch.globalY) * 1)) / (1080 - dragItem.height)));
							}
						}
					}
					scrollingModel.scrollingSignal.dispatch();
				}
			}
		}
		
		private function OnTouchEnd(touch:Touch):void
		{
			if (touchInteractionTypes[touch.id] == 'dragging') {
				touchInteractionTypes[touch.id] = null;
				dragging = false;
				scrollingModel.isDragging = false;
				scrollingModel.tweenToWithinBounds(1, Strong.easeOut, xDrag, yDrag);
			}
		}
		
		public function get active():Boolean 
		{
			return _active;
		}
		
		public function set active(value:Boolean):void 
		{
			_active = value;
		}
	}
}