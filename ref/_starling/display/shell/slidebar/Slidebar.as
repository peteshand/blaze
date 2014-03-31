package imag.masdar.core.view.starling.display.shell.slidebar 
{
	import com.greensock.easing.Strong;
	import com.greensock.TweenLite;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import imag.masdar.core.utils.bitmap.BitmapUtils;
	import imag.masdar.core.utils.starling.TextureUtils;
	import imag.masdar.core.view.starling.display.base.BaseStarlingObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author Pete Shand
	 */
	public class Slidebar extends BaseStarlingObject 
	{
		private var bgImage:Image;
		private var whiteLine:Image;
		private var whiteScrollHandle:Sprite;
		private var scrollHandleBg:Image;
		private var scrollHandleBgOver:Image;
		private var scrollHandleArrowLeft:Image;
		private var scrollHandleArrowRight:Image;
		
		private var touchInteractionTypes:Object = new Object();
		private var dragging:Boolean = false;
		
		private var mouseClickLoc:Point = new Point();
		private var clickPercentage:Point = new Point();
		private var percentageDifference:Point = new Point();
		
		private var startLoc:int = 0;
		private var endLoc:int = 0;
		private var scrollLength:int;
		private var scrollbarLength:int = 60;
		private var whiteLineLength:int;
		
		private var local:Point = new Point();
		
		private static const STATE_OVER:String = "over";
		private static const STATE_NORMAL:String = "normal";
		
		private var overSliders:Boolean = false;
		private var _buttonState:String = "";
		
		public function Slidebar() 
		{
			
		}
		
		override protected function OnAdd(e:Event):void 
		{
			startLoc = 20 + 30;
			
			var texture:Texture = Texture.fromColor(32, 32, 0x00FF0000);
			bgImage = new Image(texture);
			addChild(bgImage);
			
			var whiteTexture:Texture = Texture.fromColor(4, 4, 0xFFFFFFFF);
			whiteLine = new Image(whiteTexture);
			whiteLine.touchable = false;
			addChild(whiteLine);
			
			whiteScrollHandle = new Sprite();
			whiteScrollHandle.touchable = false;
			addChild(whiteScrollHandle);
			
			scrollHandleBg = new Image(whiteTexture);
			whiteScrollHandle.addChild(scrollHandleBg);
			
			var blueTexture:Texture = Texture.fromColor(4, 4, 0xFF00aeef);
			scrollHandleBgOver = new Image(blueTexture);
			scrollHandleBgOver.alpha = 0;
			whiteScrollHandle.addChild(scrollHandleBgOver);
			
			var arrowTexture:Texture = TextureUtils.fromBitmapData(BitmapUtils.TintBmd(new ContentScrollArrowLeftBmd(), 0x00aeef));
			
			scrollHandleArrowLeft = new Image(arrowTexture);
			whiteScrollHandle.addChild(scrollHandleArrowLeft);
			
			scrollHandleArrowRight = new Image(arrowTexture);
			whiteScrollHandle.addChild(scrollHandleArrowRight);
			
			addResizeListener();
			attachTouchListenerTo(bgImage);
			model.contentScrollValue.fractionXLagChanged.add(OnScrollValueChange);
			model.contentScrollValue.fractionYLagChanged.add(OnScrollValueChange);
			
			OnStageResize();
		}
		
		private var averagedPercent:Number;
		private function OnScrollValueChange(scrollLag:Number):void 
		{
			var scroll:Number = (config.horizontalScroll?model.contentScrollValue.fractionX:model.contentScrollValue.fractionY);

			averagedPercent = scrollLag * model.contentScrollValue.delayPercent;
			averagedPercent += scroll * (1 - model.contentScrollValue.delayPercent);
			
			if (config.horizontalScroll) whiteScrollHandle.x = startLoc + ((whiteLineLength - scrollbarLength) * averagedPercent);
			else if (config.verticalScroll) whiteScrollHandle.y = startLoc + ((whiteLineLength - scrollbarLength) * averagedPercent);
			
			checkOver();
		}
		
		private var checkCount:int = 0;
		private function checkOver():void
		{
			checkCount = 0;
			core.model.tick.render.add(CheckOverUpdate);
		}
		
		private function CheckOverUpdate(timeDelta:int):void 
		{
			if (overSliders || dragging) ButtonState = Slidebar.STATE_OVER;
			else ButtonState = Slidebar.STATE_NORMAL;
			checkCount++;
			if (checkCount > 60) core.model.tick.render.remove(CheckOverUpdate);
		}
		
		override protected function OnStageResize(e:Event=null):void 
		{
			super.OnStageResize(e);
			
			if (config.horizontalScroll) {
				bgImage.width = (core.model.viewportModel.width - 120 + 2);
				bgImage.height = scrollbarLength;
				
				whiteLineLength = whiteLine.width = (core.model.viewportModel.width - 120 + 2 - 40);
				whiteLine.height = 1;
				whiteLine.x = 20;
				whiteLine.y = 30;
				
				whiteScrollHandle.x = startLoc;
				whiteScrollHandle.y = 30;
				whiteScrollHandle.pivotX = 30;
				whiteScrollHandle.pivotY = 6.5;
				
				scrollHandleBg.width = scrollbarLength;
				scrollHandleBg.height = 13;
				
				scrollHandleBgOver.width = scrollbarLength;
				scrollHandleBgOver.height = 13;
				
				scrollHandleArrowLeft.x = 3;
				scrollHandleArrowLeft.y = 2;
				
				scrollHandleArrowRight.scaleX = -1;
				scrollHandleArrowRight.x = scrollHandleBg.width - 3;
				scrollHandleArrowRight.y = 2;
				
				endLoc = startLoc + whiteLineLength - scrollbarLength;
				scrollLength = endLoc - startLoc;
			}
			else {
				bgImage.width = scrollbarLength;
				bgImage.height = (stage.stageHeight - 120 + 2);
				
				whiteLine.width = 1;
				whiteLineLength = whiteLine.height = (stage.stageHeight - 120 + 2 - 40);
				whiteLine.x = 30;
				whiteLine.y = 20;
				
				whiteScrollHandle.x = 30;
				whiteScrollHandle.y = startLoc;
				whiteScrollHandle.pivotX = 6.5;
				whiteScrollHandle.pivotY = 30;
				
				scrollHandleBg.width = 13;
				scrollHandleBg.height = scrollbarLength;
				
				scrollHandleBgOver.width = 13;
				scrollHandleBgOver.height = scrollbarLength;
				
				scrollHandleArrowLeft.x = scrollHandleBg.width-2;
				scrollHandleArrowLeft.y = 3;
				scrollHandleArrowLeft.rotation = 90 / 180 * Math.PI;
				
				scrollHandleArrowRight.x = 2;
				scrollHandleArrowRight.y = scrollHandleBg.height - 3;
				scrollHandleArrowRight.rotation = -90 / 180 * Math.PI;
				
				endLoc = startLoc + whiteLineLength - scrollbarLength;
				scrollLength = endLoc - startLoc;
			}
		}
		
		override protected function OnTouchHover(touch:Touch):void
		{
			/*if (touch.globalX - this.x > whiteScrollHandle.x - (whiteScrollHandle.width / 2) && 
			touch.globalX - this.x < whiteScrollHandle.x + (whiteScrollHandle.width / 2)) 
			{
				overSliders = true;
			}
			else {
				overSliders = false;
			}
			checkOver();*/
		}
		
		override protected function OnTouchBegin(touch:Touch):void
		{
			if (!dragging) {
				model.contentScrollValue.delayPercent = 1;
				touchInteractionTypes[touch.id] = 'dragging';
				dragging = true;
				if (config.horizontalScroll) {
					mouseClickLoc.x = touch.globalX;
					clickPercentage.x = model.contentScrollValue.fractionX = (touch.globalX - localToGlobal(new Point(startLoc)).x) / scrollLength;
				}
				else if (config.verticalScroll) {
					mouseClickLoc.y = touch.globalY;
					clickPercentage.y = model.contentScrollValue.fractionY = (touch.globalY - localToGlobal(new Point(0, startLoc)).y) / scrollLength;
				}
				OnTouchMove(touch);
				checkOver();
				model.touchTrailRegister.active = false;
			}
		}
		
		override protected function OnTouchMove(touch:Touch):void
		{
			if (touchInteractionTypes[touch.id] == 'dragging') {
				if (config.horizontalScroll){
					percentageDifference.x = ((touch.globalX - mouseClickLoc.x) / (whiteLineLength - scrollbarLength));
					model.contentScrollValue.fractionX = clickPercentage.x + percentageDifference.x;
				}
				else if (config.verticalScroll){
					percentageDifference.y = ((touch.globalY - mouseClickLoc.y) / (whiteLineLength - scrollbarLength));
					model.contentScrollValue.fractionY = clickPercentage.y + percentageDifference.y;
				}
				checkOver();
			}
		}
		
		override protected function OnTouchEnd(touch:Touch):void
		{
			if (touchInteractionTypes[touch.id] == 'dragging') {
				touchInteractionTypes[touch.id] = null;
				dragging = false;
				checkOver();
				model.touchTrailRegister.active = true;
			}
		}
		
		private function set ButtonState(value:String):void
		{
			if (_buttonState != value) {
				_buttonState = value;
				if (value == Slidebar.STATE_NORMAL) {
					if (config.horizontalScroll){
						TweenLite.to(scrollHandleBg, 0.5, { height:13, y:0, ease:Strong.easeInOut} );
						TweenLite.to(scrollHandleBgOver, 0.5, { height:13, y:0, alpha:0, ease:Strong.easeInOut } );
					}
					else if (config.verticalScroll) {
						TweenLite.to(scrollHandleBg, 0.5, { width:13, x:0, ease:Strong.easeInOut} );
						TweenLite.to(scrollHandleBgOver, 0.5, { width:13, x:0, alpha:0, ease:Strong.easeInOut } );
					}
				}
				else if (value == Slidebar.STATE_OVER) {
					if (config.horizontalScroll){
						TweenLite.to(scrollHandleBg, 0.5, { height:40, y: (40 - 13) / -2, ease:Strong.easeInOut } );
						TweenLite.to(scrollHandleBgOver, 0.5, { height:40, y: (40 - 13) / -2, alpha:1, ease:Strong.easeInOut } );
					}
					else if (config.verticalScroll) {
						TweenLite.to(scrollHandleBg, 0.5, { width:40, x: (40 - 13) / -2, ease:Strong.easeInOut } );
						TweenLite.to(scrollHandleBgOver, 0.5, { width:40, x: (40 - 13) / -2, alpha:1, ease:Strong.easeInOut } );
					}
				}
			}
		}
	}
}