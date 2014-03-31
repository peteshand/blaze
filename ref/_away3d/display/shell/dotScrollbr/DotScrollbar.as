package imag.masdar.core.view.away3d.display.shell.dotScrollbr 
{
	import away3d.containers.ObjectContainer3D;
	import away3d.events.Scene3DEvent;
	import away3d.textures.ATFTexture;
	import com.greensock.easing.Quad;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import imag.masdar.core.model.scroll.ScrollObjects;
	import imag.masdar.core.utils.layout.Alignment;
	import imag.masdar.core.utils.scroll.ScrollTrigger;
	import imag.masdar.core.view.away3d.display.base.BaseAwayObject;
	
	/**
	 * ...
	 * @author Pete Shand
	 */
	public class DotScrollbar extends BaseAwayObject 
	{
		private var _scrollTrigger:ScrollTrigger;
		private var _scrollbarShown:Boolean;
		
		private var touchArea:ScrollTouchArea;
		private var container:ObjectContainer3D;
		private var linearLineBatchObject:LinearLineBatchObject;
		private var texture:ATFTexture;
		private var _loc1:Vector3D = new Vector3D( 60, -10, 0);
		private var _loc2:Vector3D = new Vector3D( 800, -10, 0);
		private var endPadding:int = 20;
		private var numOfDots:int;
		
		private var spacing:int = 20;
		private var ramp:Number = 0.1;
		private var minScale:Number = -2;
		private var maxScale:Number = 1;
		private var baseSize:int = 3;
		private var hidePoint:Point = new Point();
		
		///////////////////////////////////////
		private var _autoSize:Boolean;
		private var _scroll:ScrollObjects;
		private var _isHorizontal:Boolean;
		
		public function DotScrollbar(isHorizontal:Boolean, scroll:ScrollObjects = null, autoSize:Boolean = true ) 
		{
			_scroll = scroll || model.contentScrollValue;
			_autoSize = autoSize;
			_isHorizontal = isHorizontal;
			
			container = new ObjectContainer3D();
			if(_autoSize){
				if (config.scrollbarPlacement == Alignment.TOP) {
					this.x = 60;
					this.y = -config.shellPadding.top;
					hidePoint.setTo(0, 60);
				}
				else if (config.scrollbarPlacement == Alignment.BOTTOM) {
					this.x = 60;
					this.y = 60 + config.shellPadding.bottom;
					hidePoint.setTo(0, -60);
				}
				else if (config.scrollbarPlacement == Alignment.LEFT) {
					this.x = 0 + config.shellPadding.left;
					this.y = -60;
					hidePoint.setTo(-60, 0);
				}
				else if (config.scrollbarPlacement == Alignment.RIGHT) {
					this.x = -60 - config.shellPadding.right;
					this.y = -60;
					hidePoint.setTo(60, 0);
				}
				container.x = hidePoint.x;
				container.y = hidePoint.y;
			}
			
			addChild(container);
			
			animationShowHide = true;
			if(_autoSize){
				tweenValueVO.target = container;
				tweenValueVO.showTime = tweenValueVO.hideTime = 0.3;
				tweenValueVO.showDelay = tweenValueVO.hideDelay = 0;
				tweenValueVO.addShowProperty( { x:0, y:0, ease:Quad.easeOut } );
				tweenValueVO.addHideProperty( { x:hidePoint.x, y:hidePoint.y, ease:Quad.easeIn } );
			}
		}
		
		override public function Show():void 
		{
			super.Show();
			touchArea.visible = true;
		}
		
		override public function Hide():void 
		{
			super.Hide();
			touchArea.visible = false;
		}
		
		override protected function OnHideComplete():void 
		{
			this.visible = false;
		}
		
		override protected function OnAdd(e:Scene3DEvent):void 
		{
			touchArea = new ScrollTouchArea(_isHorizontal, _scroll);
			touchArea.x = endPadding;
			container.addChild(touchArea);
			
			texture = new ATFTexture(new assets.BlackDot());
			createLinearLineBatchObject();
			
			_scroll.fractionLagXChanged.add(OnScrollValueChange);
			_scroll.fractionLagYChanged.add(OnScrollValueChange);
			
			addResizeListener();
			
			if (!isNaN(_width)) setSize(_width, _height);
			
			if (_isHorizontal && _autoSize) {
				_scrollTrigger = new ScrollTrigger(_scroll.fractionX);
				_scroll.fractionXChanged.add(_scrollTrigger.setScroll);
				_scrollTrigger.callMethod(0.02, ScrollTrigger.DIR_FORWARDS, this.setScrollbarShown, [true]); 
				_scrollTrigger.callMethod(0.02, ScrollTrigger.DIR_BACKWARDS, this.setScrollbarShown, [false]); 
			}
			else {
				// add _scrollTrigger with vertical scroll listener
			}
			
			_scroll.dragStateChange.add(OnDragStateChange);
			
			model.language.updateSignal.add(OnLnguageChange);
			model.scene.sceneChangeSignal.add(OnSceneChange);
			if(_autoSize)Hide();
		}
		
		private function OnSceneChange():void 
		{
			Hide();
		}
		
		private function OnLnguageChange():void 
		{
			createLinearLineBatchObject();
		}
		
		private function OnDragStateChange(dragging:Boolean):void 
		{
			if (!dragging) {
				if (_isHorizontal && model.contentScrollValue.fractionX == 0 && _autoSize) {
					setScrollbarShown(false, true);
				}
			}
		}
		
		public function setScrollbarShown(show:Boolean, tween:Boolean=true):void 
		{
			//if (showing && model.contentScrollValue.isBeingDragged) return; 
			if (showing == show) return;
			if (show) Show();
			else Hide();
		}
		
		
		private function createLinearLineBatchObject():void 
		{
			removeLinearLineBatchObject();
			setPlacementVectors();
			
			if (_isHorizontal)	numOfDots = _width / spacing;
			else numOfDots = _height / spacing;
			
			linearLineBatchObject = new LinearLineBatchObject(numOfDots, baseSize, texture, 0xFFFFFF, 0x00adee);
			
			setParams();
			container.addChild(linearLineBatchObject);
		}
		
		private function removeLinearLineBatchObject():void 
		{
			if (linearLineBatchObject) {
				if (linearLineBatchObject.parent) linearLineBatchObject.parent.removeChild(linearLineBatchObject);
				linearLineBatchObject.dispose();
			}
			linearLineBatchObject = null;
		}
		
		private function setPlacementVectors():void
		{
			if (_isHorizontal) {
				_loc1.x = endPadding + endPadding;
				_loc1.y = -30;
				_loc2.x = _width - (endPadding * 2) + endPadding;
				_loc2.y = -30;
				
				if (model.language.languageIndex == 1) {
					var temp:Vector3D = new Vector3D( _loc1.x, _loc1.y, 0);
					_loc1.x = _loc2.x - endPadding;
					_loc1.y = _loc2.y;
					_loc2.x = temp.x - endPadding;
					_loc2.y = temp.y;
					
					
				}
			}else {
				_loc1.x = 30;
				_loc1.y = -endPadding;
				_loc2.x = 30;
				_loc2.y = (endPadding * 1) - _height;
			}
		}
		
		private function setParams():void
		{
			trace("_loc1 = " + _loc1);
			trace("_loc2 = " + _loc2);
			
			linearLineBatchObject.loc1 = _loc1;
			linearLineBatchObject.loc2 = _loc2;
			if (_isHorizontal) {
				if (model.language.languageIndex == 1 && !_autoSize) {
					linearLineBatchObject.percentage = 1 - _scroll.fractionLagX;
				}
				else {
					linearLineBatchObject.percentage = _scroll.fractionLagX;
				}
				linearLineBatchObject.x = 4;
				linearLineBatchObject.y = 0;
			}else  {
				linearLineBatchObject.percentage = _scroll.fractionLagY;
				linearLineBatchObject.x = 0;
				linearLineBatchObject.y = 4;
			}
			linearLineBatchObject.ramp = ramp;
			linearLineBatchObject.minScale = minScale;
			linearLineBatchObject.maxScale = maxScale;
		}
		
		override protected function OnResize():void 
		{
			if (_autoSize) {
				setSize(core.model.viewportModel.width - 120, core.model.viewportModel.height - 120);
			}
		}
		
		public function setSize(w:Number, h:Number):void 
		{
			_width = w;
			_height = h;
			if(touchArea){
				touchArea.setSize(w - (endPadding * 2), h);
				createLinearLineBatchObject();
			}
		}
		
		private var averagedPercent:Number;
		private function OnScrollValueChange(scrollLag:Number):void 
		{
			var scroll:Number = (_isHorizontal?_scroll.fractionX:_scroll.fractionY);
			averagedPercent = scrollLag * _scroll.delayPercent;
			averagedPercent += scroll * (1 - _scroll.delayPercent);
			if (model.language.languageIndex == 1 && !_autoSize) {
				averagedPercent = 1 - averagedPercent;
			}
			linearLineBatchObject.percentage = averagedPercent;
		}
		
		
		public function get scrollValue():ScrollObjects {
			return _scroll;
		}
		override public function get width():Number {
			return _width;
		}
		override public function get height():Number {
			return _height;
		}
		
		
		
	}
}