package imag.masdar.core.view.starling.display.slider 
{
	import com.greensock.easing.Quad;
	import com.greensock.TweenLite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import imag.masdar.core.model.texturePacker.AtlasImage;
	import imag.masdar.core.utils.layout.Alignment;
	import imag.masdar.core.view.starling.display.animations.ArrowPathAnimation;
	import imag.masdar.core.view.starling.display.animations.BaseSlideAnimation;
	import imag.masdar.core.view.starling.display.animations.GridAnimation;
	import imag.masdar.core.view.starling.display.base.BaseStarlingObject;
	import imag.masdar.core.view.starling.display.text.StarlingTLF;
	import starling.core.RenderSupport;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	/**
	 * ...
	 * @author Pete Shand
	 */
	public class ScrollPanner
	{
		public static function fadeIn(display:DisplayObject):void {
			if (!display.visible) {
				display.alpha = 0;
				display.visible = true;
			}
			TweenLite.to(display, 0.3, { alpha:1, ease:Quad.easeOut } );
		}
		public static function fadeOut(display:DisplayObject):void {
			TweenLite.to(display, 0.25, { alpha:0, ease:Quad.easeIn } );
		}
		
		
		public function get display():DisplayObject {
			return _container;
		}
		
		// we could do this with a scrollRect type implementation, need to test which performs better (and depends whether masking is needed)
		private var _outerContainer:Sprite;
		private var _container:Sprite;
		
		private var _width:Number;
		private var _height:Number;
		
		private var _hasExplicitDimensions:Boolean;
		private var _scrollW:Number;
		private var _scrollH:Number;
		
		private var _scrollX:Number;
		private var _scrollY:Number;
		
		private var _contentMinX:Number;
		private var _contentMinY:Number;
		private var _contentMaxX:Number;
		private var _contentMaxY:Number;
		
		private var _bottomPadding:Number;
		private var _topPadding:Number;
		private var _leftPadding:Number;
		private var _rightPadding:Number;
		
		private var _defaultIntro:Function;
		private var _defaultOutro:Function;
		
		private var _childToBundle:Dictionary;
		private var _allBundles:Vector.<ChildBundle>;
		
		public function ScrollPanner(topPadding:Number=0, bottomPadding:Number=0, leftPadding:Number=0, rightPadding:Number=0, defaultIntro:Function=null, defaultOutro:Function=null) 
		{
			_container = new Sprite();
			
			_topPadding = topPadding;
			_bottomPadding = bottomPadding;
			_leftPadding = leftPadding;
			_rightPadding = rightPadding;
			
			_defaultIntro = defaultIntro || fadeIn;
			_defaultOutro = defaultOutro || fadeOut;
			
			_allBundles = new Vector.<ChildBundle>();
			_childToBundle = new Dictionary();
		}
		
		public function setSize(width:Number, height:Number):void 
		{
			_width = width;
			_height = height;
			//checkToListen();
			applyScrollX();
			applyScrollY();
		}
		
		public function setScrollDimensions(width:int, height:Number):void {
			_hasExplicitDimensions = true;
			_scrollW = width;
			_scrollH = height;
			applyScrollX();
			applyScrollY();
		}
		
		public function addChild(child:DisplayObject, introHandler:Function=null, outroHandler:Function=null, passDisplay:Boolean=false, addToCont:Boolean=true, animated:Boolean=false):void {
			if(addToCont)_container.addChild(child);
			
			if (isNaN(_contentMinX) || (_contentMinX > child.x)) {
				_contentMinX = child.x;
			}
			if (isNaN(_contentMaxX) || (_contentMaxX < child.x + child.width)) {
				_contentMaxX = child.x + child.width;
			}
			if (isNaN(_contentMinY) || (_contentMinY > child.y)) {
				_contentMinY = child.y;
			}
			if (isNaN(_contentMaxY) || (_contentMaxY < child.y + child.height)) {
				_contentMaxY = child.y + child.height;
			}
			
			var bundle:ChildBundle = new ChildBundle(child, introHandler, outroHandler, passDisplay, animated);
			_childToBundle[child] = bundle;
			_allBundles.push(bundle);
			
			checkShown(bundle, null);
		}
		
		public function setScrollX(scrollX:Number):void 
		{
			_scrollX = scrollX;
			applyScrollX();
		}
		
		private function applyScrollX():void 
		{
			if (isNaN(_scrollX)) return;
			
			if(_hasExplicitDimensions){
				_container.x = -Math.round(_scrollX * (_scrollW - _width));
			}else {
				_container.x = -_contentMinX + Math.round(_scrollX * ((_contentMaxX - _contentMinX) - _width));
			}
			
			for each(var bundle:ChildBundle in _allBundles) {
				checkShown(bundle, bundle.shown);
			}
		}
		
		public function setScrollY(scrollY:Number):void 
		{
			_scrollY = scrollY;
			applyScrollY();
		}
		
		public function setDisplay(sprite:Sprite):void 
		{
			_container = sprite;
		}
		
		private function applyScrollY():void 
		{
			if (isNaN(_scrollY)) return;
			
			if(_hasExplicitDimensions){
				_container.y = -Math.round(_scrollY * (_scrollH - _height));
			}else {
				_container.y = -_contentMinY + Math.round(_scrollY * ((_contentMaxY - _contentMinY) - _height));
			}
			
			for each(var bundle:ChildBundle in _allBundles) {
				checkShown(bundle, bundle.shown);
			}
		}
		
		
		private function checkShown(bundle:ChildBundle, isShown:*):void 
		{
			var shown:Boolean = shouldBeShown(bundle, bundle.shown);
			if (shown == isShown) return;
			
			bundle.shown = shown;
			if (shown) {
				if (bundle.introHandler != null) {
					if (bundle.passDisplay) bundle.introHandler(bundle.child);
					else bundle.introHandler();
				}else if (_defaultIntro != null) {
					_defaultIntro(bundle.child);
				}
			}else {
				if (bundle.outroHandler != null) {
					if (bundle.passDisplay) bundle.outroHandler(bundle.child);
					else bundle.outroHandler();
				}else if (_defaultOutro != null) {
					_defaultOutro(bundle.child);
				}
			}
		}
		
		private function shouldBeShown(bundle:ChildBundle, isShown:Boolean):Boolean 
		{
			var bounds:Rectangle;
			if (bundle.animated || !bundle.bounds) {
				bounds = bundle.child.bounds;
				bundle.bounds = bounds;
			}else {
				bounds = bundle.bounds;
			}
			// show elements when left comes into view
			return (bounds.left < -_container.x + _width - _rightPadding && 
					bounds.left > -_container.x + _leftPadding &&
					bounds.bottom < -_container.y + _height - _bottomPadding && 
					bounds.top > -_container.y + _topPadding);
		}
		
			
		private function CheckPosition(child:DisplayObject, difference:Number):void
		{
			if (difference > 800) {
				if (child.alpha == 1) TweenLite.to(child, 0.5, { alpha:0, delay:0 } );
			}
			else {
				if (child.alpha == 0) TweenLite.to(child, 0.5, { alpha:1, delay:0 } );
			}
		}
	}
}
import flash.geom.Rectangle;
import starling.display.DisplayObject;

class ChildBundle {
	
	public var child:DisplayObject;
	public var shown:Boolean = true;
	public var animated:Boolean = false;
	public var bounds:Rectangle;
	public var passDisplay:Boolean;
	public var introHandler:Function;
	public var outroHandler:Function;
	
	public function ChildBundle(child:DisplayObject, introHandler:Function, outroHandler:Function, passDisplay:Boolean, animated:Boolean) {
		this.child = child;
		this.introHandler = introHandler;
		this.outroHandler = outroHandler;
		this.passDisplay = passDisplay;
	}
}