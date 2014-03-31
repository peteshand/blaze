package imag.masdar.core.view.starling.display.animations 
{
	import com.greensock.easing.Linear;
	import com.greensock.plugins.HexColorsPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.greensock.TweenLite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import starling.animation.Tween;
	import starling.animation.Transitions;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author Pete Shand
	 */
	public class ArrowPathAnimation extends BaseSlideAnimation 
	{
		private static const INTRO_SPEED:Number = 400; // pixels per second
		private static const OUTRO_SPEED:Number = 600; // pixels per second
		private static const ARROW_HEADSTART:Number = 0.05;
		private static const STRAIGHTEN_THRESHOLD:Number = 10;
		
		private var _points:Vector.<LinePoint>;
		private var _lineLengths:Vector.<Number>;
		private var _lineAngles:Vector.<Number>;
		private var _displays:Vector.<DisplayInfo> = new Vector.<DisplayInfo>();
		private var _arrow:Sprite;
		private var _arrowImage:Image;
		private var _totalLength:Number;
		private var _dotWidth:Number;
		private var _dotLength:Number;
		private var _dotGap:Number;
		
		public function ArrowPathAnimation(showArrow:Boolean, points:Vector.<LinePoint>, totalLength:Number=NaN, lineLengths:Vector.<Number>=null, dotWidth:Number=2, dotLength:Number=2, dotGap:Number=4) 
		{
			TweenPlugin.activate([HexColorsPlugin]);
			
			this.showing = false;
			
			var i:int;
			var diffX:Number;
			var diffY:Number;
			var lastPoint:LinePoint = points[0];
			var nextPoint:LinePoint;
			
			_points = points;
			_dotWidth = dotWidth;
			_dotLength = dotLength;
			_dotGap = dotGap;
			
			if(!isNaN(totalLength) && lineLengths){
				_totalLength = totalLength;
			}else {
				_totalLength = 0;
				lineLengths = new Vector.<Number>();
				for (i = 0; i < points.length - 1; ++i) {
					nextPoint = points[i + 1];
					diffX = nextPoint.x - lastPoint.x;
					diffY = nextPoint.y - lastPoint.y;
					
					var dist:Number = Math.sqrt((diffX * diffX) + (diffY * diffY));
					lineLengths.push(dist);
					_totalLength += dist;
					lastPoint = nextPoint;
				}
				lastPoint = points[0];
			}
			_lineLengths = lineLengths;
			this.touchable = false;
			
			var textures:Dictionary = new Dictionary();
			
			var lengthSoFar:Number = 0;
			var angle:Number;
			_lineAngles = new Vector.<Number>();
			var colour:uint;
			for (i = 0; i < points.length-1; ++i) 
			{
				nextPoint = points[i + 1];
				diffX = nextPoint.x - lastPoint.x;
				diffY = nextPoint.y - lastPoint.y;
				
				// straighten out any lines which might be a few pixels off
				if (diffX > diffY) {
					if (Math.abs(diffY) < STRAIGHTEN_THRESHOLD) {
						diffY = 0;
						nextPoint.y = lastPoint.y;
					}
				}else if (Math.abs(diffX) < STRAIGHTEN_THRESHOLD) {
					diffX = 0;
					nextPoint.x = lastPoint.x;
				}
				
				angle = Math.atan2(diffY,  diffX);
				_lineAngles[i] = angle;
				
				var lineLength:Number = lineLengths[i];
				var dots:int = Math.round(lineLength / (_dotGap + _dotLength));
				var dotSpace:Number = lineLength / dots;
				
				var startA:uint = (( lastPoint.colour >> 24 ) & 0xFF);
				var startR:uint = (( lastPoint.colour >> 16 ) & 0xFF);
				var startG:uint = (( lastPoint.colour >> 8  ) & 0xFF);
				var startB:uint = (( lastPoint.colour       ) & 0xFF);
				
				var endA:uint = (( nextPoint.colour >> 24 ) & 0xFF);
				var endR:uint = (( nextPoint.colour >> 16 ) & 0xFF);
				var endG:uint = (( nextPoint.colour >>  8 ) & 0xFF);
				var endB:uint = (( nextPoint.colour       ) & 0xFF);
				
				var difA:int = endA - startA;
				var difR:int = endR - startR;
				var difG:int = endG - startG;
				var difB:int = endB - startB;
				
				for (var j:int = 0; j < dots; ++j) {
					var fract:Number = (j / dots);
					colour = ((startA + difA * fract) << 24) | ((startR + difR * fract) << 16) | ((startG + difG * fract) << 8) | (startB + difB * fract);
					var texture:Texture = textures[colour];
					if (!texture) {
						texture = Texture.fromColor(_dotWidth, _dotLength, colour);
						textures[colour] = texture;
					}
					var dotPos:Number = j * dotSpace;
					var x:Number = Math.round(lastPoint.x + Math.cos(angle) * dotPos);
					var y:Number = Math.round(lastPoint.y + Math.sin(angle) * dotPos);
					_displays.push(new DisplayInfo(addDot(texture, x, y, angle), (dotPos + lengthSoFar) / _totalLength));
				}
				
				lengthSoFar += lineLength;
				
				lastPoint = nextPoint;
			}
			
			if (showArrow) {
				var arrowHead:Bitmap = new assets.LineArrowHead();
				var arrowTexture:Texture = Texture.fromBitmapData(arrowHead.bitmapData, false);
				
				_arrow = new Sprite();
				_arrow.alpha = 0;
				addChild(_arrow);
				
				_arrowImage = new Image(arrowTexture);
				_arrowImage.y = -_arrowImage.height / 2;
				_arrowImage.x = -_arrowImage.width / 2;
				_arrow.addChild(_arrowImage);
			}
		}
		
		private function addDot(dotTexture:Texture, x:Number, y:Number, rotation:Number):Sprite {
			var dotContainer:Sprite = new Sprite();
			var dot:Image = new Image(dotTexture);
			dot.x = - dot.width / 2;
			dot.y = - dot.height / 2;
			dotContainer.alpha = 0;
			dotContainer.addChild(dot);
			dotContainer.x = x;
			dotContainer.y = y;
			dotContainer.rotation = rotation;
			addChild(dotContainer);
			dotContainer.flatten();
			return dotContainer;
		}
		override public function Show():void
		{
			this.shown = true;
		}
		
		override public function Hide():void
		{
			StopLoop();
			this.shown = false;
		}
		
		private var _looping:Boolean = false;
		public function BeginLoop():void
		{
			_looping = true;
			showIntro(false);
		}
		public function StopLoop():void
		{
			_looping = false;
			TweenLite.killDelayedCallsTo(showIntro);
		}
		
		public function set shown(value:Boolean):void {
			if (this.showing == value) return;
			
			this.showing = value;
			
			if (value) {
				showIntro(true);
			}else {
				var totalTime:Number = _totalLength / OUTRO_SPEED;
				var delay:Number = 0;
				for each(var display:DisplayInfo in _displays) {
					delay = (display.fract) * totalTime;
					TweenLite.killTweensOf(display.display);
					TweenLite.to(display.display, 0.1, { alpha:0, delay:delay } );
				}
				if (_arrow) {
					TweenLite.to(_arrow, 0, { delay:totalTime, alpha:0  } );
				}
			}
		}
		private function showIntro(hideOnStart:Boolean):void {
			this.showing = true;
			var delay:Number = 0;
			var dotDelay:Number = 0;
			var totalTime:Number = _totalLength / INTRO_SPEED;
			if (_arrow) {
				TweenLite.killTweensOf(_arrow);
				TweenLite.killTweensOf(_arrowImage);
				var lastPoint:LinePoint = _points[0];
				_arrow.alpha = 1;
				_arrow.x = lastPoint.x;
				_arrow.y = lastPoint.y;
				_arrowImage.color = lastPoint.colour;
				var nextPoint:LinePoint;
				for (var i:int = 0; i < _points.length-1; ++i) 
				{
					nextPoint = _points[i + 1];
					
					var angle:Number = _lineAngles[i];
					var lineLength:Number = _lineLengths[i];
					
					var dur:Number = lineLength / _totalLength * totalTime;
					TweenLite.to(_arrow, dur, { delay:delay, x:nextPoint.x, y:nextPoint.y, onStart:function(angle:Number):void { _arrow.rotation = angle }, onStartParams:[angle], ease:Linear.easeNone } );
					
					var rgb:uint = 0xFFFFFF & nextPoint.colour;
					TweenLite.to(_arrowImage, dur, { delay:delay, hexColors:{color:rgb}, ease:Linear.easeNone } );
					
					/*var tween:Tween = new Tween(_arrow, dur);
					tween.onStart = function(angle:Number):void {
						_arrow.rotation = angle;
					};
					tween.onStartArgs = [angle];
					tween.delay = delay;
					tween.moveTo(nextPoint.x, nextPoint.y);
					Starling.juggler.add(tween);*/
					
					delay += dur;
					lastPoint = nextPoint;
				}
				dotDelay = ARROW_HEADSTART;
			}
			for each(var display:DisplayInfo in _displays) {
				delay = display.fract * totalTime + dotDelay;
				
				TweenLite.killTweensOf(display.display);
				if (hideOnStart) display.display.alpha = 0;
				else {
					TweenLite.to(display.display, 0, { alpha:0, delay:delay - ARROW_HEADSTART * 2 } );
				}
				
				TweenLite.to(display.display, 0.1, { alpha:1, delay:delay } );
			}
			if (_looping) {
				TweenLite.delayedCall(totalTime + dotDelay, showIntro, [false]);
			}
		}
	}
}
import starling.display.Sprite;

class DisplayInfo{
	public var display:Sprite;
	public var fract:Number;
	
	public function DisplayInfo(display:Sprite, fract:Number) {
		this.display = display;
		this.fract = fract;
	}
}