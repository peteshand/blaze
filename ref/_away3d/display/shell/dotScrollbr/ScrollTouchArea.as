package imag.masdar.core.view.away3d.display.shell.dotScrollbr 
{
	import away3d.entities.Mesh;
	import away3d.events.Scene3DEvent;
	import away3d.events.Touch;
	import away3d.materials.ColorMaterial;
	import away3d.primitives.PlaneGeometry;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	import flash.geom.Point;
	import imag.masdar.core.model.scroll.ScrollObjects;
	import imag.masdar.core.model.time.TickObject;
	import imag.masdar.core.view.away3d.display.base.BaseAwayObject;
	
	/**
	 * ...
	 * @author Pete Shand
	 */
	public class ScrollTouchArea extends BaseAwayObject 
	{
		private var material:ColorMaterial;
		private var mesh:Mesh;
		private var geo:PlaneGeometry;
		private var _w:int;
		private var _h:int;
		
		private var touchInteractionTypes:Object = new Object();
		
		private var mouseClickLoc:Point = new Point();
		private var clickPercentage:Point = new Point();
		private var percentageDifference:Point = new Point();
		
		private var padding:int = 50;
		private var startLoc:int = 0;
		private var endLoc:int = 0;
		private var scrollLength:int;
		private var overScrollArea:Boolean = false;
		private var tickObject:TickObject;
		private var currentID:int;
		private var currentTouch:Touch;
		private var _scroll:ScrollObjects;
		
		private var scrollbarThickness:int;
		private var _isHorizontal:Boolean;
		
		public function ScrollTouchArea(isHorizontal:Boolean, scroll:ScrollObjects=null, scrollbarThickness:int=60) 
		{
			this.scrollbarThickness = scrollbarThickness;
			startLoc = 20 + 30;
			
			material = new ColorMaterial(0x00FF00, 0);
			mesh = new Mesh(null, material);
			attachTouchListenerTo(mesh, null, true);
			
			_scroll = scroll || model.contentScrollValue;
			_isHorizontal = isHorizontal;
		}
		
		override protected function OnAdd(e:Scene3DEvent):void 
		{
			resize();
		}
		
		public function setSize(w:Number, h:Number):void 
		{
			_width = w;
			_height = h;
			resize();
		}
		private function resize():void
		{
			if (_isHorizontal) {
				_w = _width;
				_h = scrollbarThickness;
				scrollLength = _w - (padding * 0.8);
			}
			else {
				_w = scrollbarThickness;
				_h = _height;
				scrollLength = _h - (padding * 0.8);
			}
			if (geo) {
				geo.dispose();
				geo = null;
			}
			geo = new PlaneGeometry(_w, _h, 1, 1, false);
			
			mesh.geometry = geo;
			mesh.x = geo.width / 2;
			mesh.y = -geo.height / 2;
			addChild(mesh);
		}
		
		override protected function OnTouchBegin(touch:Touch):void
		{
			
			super.OnTouchBegin(touch);
			if (!_scroll.isBeingDragged) {
				_scroll.delayPercent = 1;
				currentID = touch.id;
				currentTouch = touch;
				touchInteractionTypes[touch.id] = 'dragging';
				_scroll.isBeingDragged = true;
				if (_isHorizontal) {
					mouseClickLoc.x = touch.globalX + this.x; // TODO, check + this.x doesn't effect any of the GE apps
					var newFractionX:Number = (touch.globalX - (padding * 1.5)) / scrollLength;
					if (model.language.languageIndex == 1) newFractionX = 1 - newFractionX;
					clickPercentage.x = _scroll.fractionX = newFractionX;
				}
				else {
					mouseClickLoc.y = touch.globalY;
					clickPercentage.y = _scroll.fractionY = (touch.globalY - (padding * 1.5)) / scrollLength;
				}
				OnTouchMove(touch);
				model.touchTrailRegister.active = false;
				stage.addEventListener(MouseEvent.MOUSE_UP, OnStageMouseUp);
				stage.addEventListener(TouchEvent.TOUCH_END, OnStageTouchUp);
			}
		}
		
		private function OnStageMouseUp(e:MouseEvent):void 
		{
			OnTouchEnd(currentTouch);
		}
		
		private function OnStageTouchUp(e:TouchEvent):void 
		{
			OnTouchEnd(currentTouch);
		}
		
		
		override protected function OnTouchMove(touch:Touch):void
		{
			super.OnTouchMove(touch);
			if (touchInteractionTypes[touch.id] == 'dragging') {
				if (_isHorizontal){
					percentageDifference.x = ((touch.globalX - mouseClickLoc.x) / scrollLength);
					if (model.language.languageIndex == 1) percentageDifference.x *= -1;
					_scroll.fractionX = clickPercentage.x + percentageDifference.x;
				}
				else{
					percentageDifference.y = ((touch.globalY - mouseClickLoc.y) / scrollLength);
					_scroll.fractionY = clickPercentage.y + percentageDifference.y;
				}
			}
		}
		
		override protected function OnTouchEnd(touch:Touch):void
		{
			super.OnTouchEnd(touch);
			if (touchInteractionTypes[touch.id] == 'dragging') {
				stage.removeEventListener(MouseEvent.MOUSE_UP, OnStageMouseUp);
				stage.removeEventListener(TouchEvent.TOUCH_END, OnStageTouchUp);
				
				touchInteractionTypes[touch.id] = null;
				_scroll.isBeingDragged = false;
				model.touchTrailRegister.active = true;
			}
		}
		
		override protected function OnTouchOver(touch:Touch):void
		{
			//trace("OnTouchOver");
			overScrollArea = true;
		}
		
		override protected function OnTouchOut(touch:Touch):void
		{
			//trace("OnTouchOut");
			overScrollArea = false;
		}
	}
}