package imag.masdar.core.view.away3d.display.away2d 
{
	import flash.geom.Point;
	import imag.masdar.core.utils.math.Math2;
	import imag.masdar.core.view.starling.display.animations.LinePoint;
	
	/**
	 * ...
	 * @author Pete Shand
	 */
	public class AnimatedLineVO 
	{
		public var showArrow:Boolean;
		public var linePoints:Vector.<LinePoint>
		public var totalLength:Number = NaN;
		public var lineLengths:Vector.<Number> = null;
		public var dotWidth:Number = 2;
		public var dotLength:Number = 2;
		public var dotGap:Number = 4;
		public var width:int;
		public var height:int;
		
		private function lineIndexByFraction(fraction:Number):int
		{
			if (!lineLengths) return 0;
			var a:Number = 0;
			for (var i:int = 0; i < lineLengths.length; ++i) {
				a += lineLengths[i];
				if (a/totalLength > fraction) return i;
			}
			return 1;
		}
		
		private var arrowPoint:Point = new Point();
		private var lineIndex:int = 0;
		private var lineFraction:Number = 0;
		private var startFraction:Number = 0;
		private var endFraction:Number = 0;
		private var fractionLength:Number = 0;
		private var arrowRotation:Number = 0;
		private var arrowColour:uint;
		
		public function arrowParams(fraction:Number):Array 
		{
			if (fraction > 1) fraction = 1;
			if (fraction == 1) {
				lineIndex = linePoints.length - 2;
				lineFraction = 1;
			}
			else {
				lineIndex = lineIndexByFraction(fraction);
				startFraction = 0;
				for (var j:int = 0; j < lineLengths.length; ++j) {
					if (j < lineIndex) {
						startFraction += lineLengths[j] / totalLength;
					}
					else {
						endFraction = startFraction + (lineLengths[j] / totalLength);
						fractionLength = endFraction - startFraction;
						lineFraction = (fraction - startFraction) / fractionLength;
						break;
					}
				}
			}
			
			arrowPoint.x = Math2.interpolate(lineFraction, linePoints[lineIndex].x, linePoints[lineIndex + 1].x);
			arrowPoint.y = -Math2.interpolate(lineFraction, linePoints[lineIndex].y, linePoints[lineIndex + 1].y);
			arrowRotation = Math.atan2(linePoints[lineIndex].y - linePoints[lineIndex + 1].y,
										linePoints[lineIndex + 1].x - linePoints[lineIndex].x) * 180 / Math.PI;
			
			arrowColour = Math2.interpolate(lineFraction, linePoints[lineIndex].colour >> 16 & 0xFF, linePoints[lineIndex + 1].colour >> 16 & 0xFF) << 16 | Math2.interpolate(lineFraction, linePoints[lineIndex].colour >> 8 & 0xFF, linePoints[lineIndex + 1].colour >> 8 & 0xFF) << 8 | Math2.interpolate(lineFraction, linePoints[lineIndex].colour & 0xFF, linePoints[lineIndex + 1].colour & 0xFF);
			
			return [arrowPoint, arrowRotation, arrowColour];
		}
	}
}