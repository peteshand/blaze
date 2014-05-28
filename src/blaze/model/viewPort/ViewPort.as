package blaze.model.viewPort 
{
	import blaze.behaviors.ResizeBehavior;
	import blaze.model.render.RenderModel;
	import blaze.utils.layout.Alignment;
	import blaze.utils.layout.Dimensions;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import org.osflash.signals.Signal;
	/**
	 * ...
	 * @author P.J.Shand
	 */
	public class ViewPort 
	{
		private var stage:Stage;
		private var renderer:RenderModel;
		
		private var _zoomType:int = Dimensions.STRETCH;
		private var resizeBehavior:ResizeBehavior;
		
		private var viewWidth:int = -1;
		private var viewHeight:int = -1;
		
		private var displayRatio:Number;
		private var screenRatio:Number;
		
		public var rect:Rectangle;
		public var update:Signal = new Signal();
		
		public var _optimalScreenDimensions:Point = new Point();
		public var optimalScreenFraction:ViewportPoint = new ViewportPoint( -1, -1);
		public var offsetFraction:Point = new Point(-1,-1);
		public var alignment:String = Alignment.MIDDLE;
		
		public function ViewPort():void
		{
			optimalScreenFraction.updateCallback = OnResize;
		}
		
		public function init(stage:Stage, renderer:RenderModel):void 
		{
			this.stage = stage;
			this.renderer = renderer;
			
			if (viewWidth == -1) viewWidth = stage.stageWidth;
			if (viewHeight == -1) viewHeight = stage.stageHeight;
			if (_optimalScreenDimensions.x == -1) _optimalScreenDimensions.x = stage.stageWidth
			if (_optimalScreenDimensions.y == -1) _optimalScreenDimensions.y = stage.stageHeight;
			
			rect = new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);
			
			resizeBehavior = new ResizeBehavior()
			resizeBehavior.addResizeListener(stage, OnResize);
		}
		
		public function optimalScreenDimensions(width:int, height:int):void
		{
			optimalScreenFraction.setTo( -1, -1);
			_optimalScreenDimensions.setTo(width, height);
			viewWidth = width;
			viewHeight = height;
		}
		
		private function OnResize():void 
		{
			if (optimalScreenFraction.x != -1) viewWidth = Math.ceil(stage.stageWidth * optimalScreenFraction.x);
			if (optimalScreenFraction.y != -1) viewHeight = Math.ceil(stage.stageHeight * optimalScreenFraction.y);
			
			rect.width = Math.round(viewWidth)
			rect.height = viewHeight;
			//= Dimensions.calculate(/*stage.stageWidth / renderer.proxySlotsUsed*/viewWidth, stage.stageHeight, viewWidth, viewHeight, zoomType).clone();
			//rect.width = 300
			screenRatio = Dimensions.objectRatio;
			displayRatio = Dimensions.displayRatio;
			
			if (alignment == Alignment.LEFT || alignment == Alignment.TOP_LEFT || alignment == Alignment.BOTTOM_LEFT) {
				rect.x = 0;
			}
			else if (alignment == Alignment.RIGHT || alignment == Alignment.TOP_RIGHT || alignment == Alignment.BOTTOM_RIGHT) {
				rect.x = stage.stageWidth - rect.width;
			}			
			else if (alignment == Alignment.MIDDLE) {
				rect.x = Math.round((stage.stageWidth - rect.width)/2);
			}
	
			
			if (alignment == Alignment.TOP || alignment == Alignment.TOP_LEFT || alignment == Alignment.TOP_RIGHT) {
				rect.y = 0;
			}
			else if (alignment == Alignment.BOTTOM || alignment == Alignment.BOTTOM_LEFT || alignment == Alignment.BOTTOM_RIGHT) {
				rect.y = stage.stageHeight - rect.height;
			}
			
			if (offsetFraction.x != -1) rect.x += Math.floor(offsetFraction.x * stage.stageWidth);
			if (offsetFraction.y != -1) rect.y += Math.floor(offsetFraction.y * stage.stageHeight);
			
			update.dispatch();
		}
		
		public function get zoomType():int 
		{
			return _zoomType;
		}
		
		public function set zoomType(value:int):void 
		{
			_zoomType = value;
		}
		
		public function get scaleHorizontal():Number 
		{
			return viewWidth / _optimalScreenDimensions.x;
		}
		
		public function get scaleVertical():Number 
		{
			return viewHeight / _optimalScreenDimensions.y;
		}
		
		public function get scaleMin():Number 
		{
			if (displayRatio < _optimalScreenDimensions.x / _optimalScreenDimensions.y) {
				return scaleHorizontal;
			}
			else {
				return scaleVertical;
			}
		}
		
		public function get scaleMax():Number 
		{
			if (displayRatio < _optimalScreenDimensions.x / _optimalScreenDimensions.y) {
				return scaleVertical;
			}
			else {
				return scaleHorizontal;
			}
		}
		
	}
}