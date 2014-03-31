package imag.masdar.core.view.away3d.display.touchTrail 
{
	
	import away3d.containers.ObjectContainer3D;
	import away3d.events.Touch;
	import away3d.textures.ATFTexture;
	import com.greensock.plugins.BezierPlugin;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.system.Capabilities;
	import flash.ui.Mouse;
	import imag.masdar.core.utils.bezier.CurveThrough;
	import imag.masdar.core.utils.layout.Alignment;
	import imag.masdar.core.view.away3d.display.base.BaseAwayObject;
	
	/**
	 * ...
	 * @author Pete Shand
	 */
	public class TouchTrail extends BaseAwayObject 
	{
		public var touchID:int;
		private var touch:Touch;
		
		private var container:ObjectContainer3D;
		
		private var lastLocation:Point = new Point();
		private var difference:Point = new Point();
		private var delta:Number = 0;
		private var deltaZeroCount:int = 20;
		
		private var trailAlpha:Number = 0;
		//private var alphaDelay:int = 10;
		private var delayeTrailAlpha:Number = 0;
		
		private var tempAnchors:Vector.<Vector3D> = new Vector.<Vector3D>();
		private var anchors:Vector.<Vector3D> = new Vector.<Vector3D>();
		private var _loc1:Vector3D = new Vector3D();
		private var _loc2:Vector3D = new Vector3D();
		private var _loc3:Vector3D = new Vector3D();
		private var _loc4:Vector3D = new Vector3D();
		private var interpolationLocs:Vector.<Vector3D>;
		
		private var cubicBezierObject:CubicBezierObject;
		
		private var active:Boolean = true;
		
		private var texture:ATFTexture;
		private var numOfSteps:int = 60;
		
		private var dpiScale:Number;
		private var minSize:Number;
		private var maxSize:Number;
		
		private var curveThrough:CurveThrough = new CurveThrough();
		
		public function TouchTrail(touchID:int) 
		{
			this.touchID = touchID;
			touch = model.touchTrailRegister.getTouch(touchID);
			
			dpiScale = ((0.5 * (Capabilities.screenDPI - 72)) + 72) / 72;
			minSize = 5 * dpiScale;
			maxSize = 15 * dpiScale;
			
			tempAnchors.push(_loc1, _loc2, _loc3, _loc4);
			for (var i:int = 0; i < tempAnchors.length; ++i) {
				anchors.push(tempAnchors[i]);
				anchors.push(new Vector3D());
				anchors.push(new Vector3D());
			}
			
			container = new ObjectContainer3D();
			addChildAtAlignment(container, Alignment.TOP_LEFT);
			
			if (config.whiteTouchTrail){
				texture = new ATFTexture(new assets.WhiteDot());
				
			}
			else {
				texture = new ATFTexture(new assets.BlackDot());
			}
			
			trace("texture.width = " + texture.width);
			trace("texture.height = " + texture.height);
			
			createBezierObjects();
			
			core.model.tick.render.add(Update);
			model.touchTrailRegister.change.add(OnTrailActiveChange);
		}
		
		private function ResetTrail():void 
		{
			for (var j:int = 0; j < anchors.length; ++j) {
				anchors[j].setTo(touch.globalX - model.viewportModel.viewport.x, -touch.globalY + model.viewportModel.viewport.y, 0);	
			}
			lastLocation.x = touch.globalX - model.viewportModel.viewport.x;
			lastLocation.y = touch.globalY + model.viewportModel.viewport.y;
			delta = differenceBetweenPoints(lastLocation, new Point(touch.globalX - model.viewportModel.viewport.x, touch.globalY + model.viewportModel.viewport.y));
			deltaZeroCount = 0;
		}
		
		private function createBezierObjects():void 
		{
			removeBezierObjects();
			
			cubicBezierObject = new CubicBezierObject(numOfSteps, minSize, maxSize, texture);
			cubicBezierObject.loc1 = _loc1;
			cubicBezierObject.loc2 = _loc2;
			cubicBezierObject.loc3 = _loc3;
			cubicBezierObject.loc4 = _loc4;
			container.addChild(cubicBezierObject);
			cubicBezierObject.alpha = 0;
		}
		
		private function removeBezierObjects():void 
		{
			if (cubicBezierObject){
				cubicBezierObject.dispose();
				cubicBezierObject = null;
			}
		}
		
		private function OnTrailActiveChange(_active:Boolean):void 
		{
			active = _active
		}
		
		private function Update(timeDelta:int):void 
		{
			if (!cubicBezierObject) return;
			
			delta = differenceBetweenPoints(lastLocation, new Point(touch.globalX - model.viewportModel.viewport.x, touch.globalY + model.viewportModel.viewport.y));
			if (delta != 0 && deltaZeroCount > 10) {
				ResetTrail();
				return;
			}
			if (delta == 0) deltaZeroCount++;
			else deltaZeroCount = 0;
			
			lastLocation.x = touch.globalX - model.viewportModel.viewport.x;
			lastLocation.y = touch.globalY + model.viewportModel.viewport.y;
			
			updatePointChain();
			updateBezierPoints();
			setAlpha();
		}
		
		private function updatePointChain():void 
		{
			for (var j:int = anchors.length-1; j > 0; --j) {
				anchors[j].setTo(anchors[j - 1].x, anchors[j - 1].y, anchors[j - 1].z);
			}
			anchors[0].x = touch.globalX - model.viewportModel.viewport.x;
			anchors[0].y = -touch.globalY + model.viewportModel.viewport.y;
		}
		
		private function updateBezierPoints():void 
		{
			
			
			interpolationLocs = curveThrough.parse(_loc1, _loc2, _loc3, _loc4);
			if (shouldInterpolate() && deltaZeroCount < 10){
				cubicBezierObject.loc1 = interpolationLocs[0];
				cubicBezierObject.loc2 = interpolationLocs[1];
				cubicBezierObject.loc3 = interpolationLocs[2];
				cubicBezierObject.loc4 = interpolationLocs[3];
			}
			else {
				cubicBezierObject.loc1 = _loc1;
				cubicBezierObject.loc2 = _loc2;
				cubicBezierObject.loc3 = _loc3;
				cubicBezierObject.loc4 = _loc4;
			}
			cubicBezierObject.updateVertexData();
		}
		
		private function setAlpha():void 
		{
			if (active) {
				if (dif > 10) {
					delayeTrailAlpha += 0.2;
					if (delayeTrailAlpha > 1) delayeTrailAlpha = 1;
				}
				else {
					delayeTrailAlpha -= 0.1;
					if (delayeTrailAlpha < 0) delayeTrailAlpha = 0;
				}
			}
			else {
				delayeTrailAlpha -= 0.1;
				if (delayeTrailAlpha < 0) delayeTrailAlpha = 0;
			}
			
			if (delayeTrailAlpha == 0) {
				if (cubicBezierObject.visible) cubicBezierObject.visible = false;
			}
			else {
				if (!cubicBezierObject.visible) cubicBezierObject.visible = true;
			}
			cubicBezierObject.alpha = delayeTrailAlpha / 2;
		}
		
		private var dif:Number = 0;
		private var dif1:Vector.<Number> = new Vector.<Number>(3);
		private var dif2:Vector.<Number> = new Vector.<Number>(3);
		private var percent:Number;
		private var pointDifference:Point;
		
		private function shouldInterpolate():Boolean 
		{
			if (delta != 0 && delta < 4) return false;
			
			dif1[0] = differenceBetweenVectors(_loc1, _loc2);
			dif1[1] = differenceBetweenVectors(_loc2, _loc3);
			dif1[2] = differenceBetweenVectors(_loc3, _loc4);
			dif = dif1[0] + dif1[1] + dif1[2];
			if (dif1[0] == 0) return false;
			if (dif1[1] == 0) return false;
			if (dif1[2] == 0) return false;
			
			return true;
		}
		
		private function differenceBetweenPoints(point1:Point, point2:Point):Number 
		{
			difference = new Point(point1.x - point2.x, point1.y - point2.y);
			return Math.sqrt(Math.pow(difference.x, 2) + Math.pow(difference.y, 2));
		}
		
		private function differenceBetweenVectors(vector3D1:Vector3D, vector3D2:Vector3D):Number 
		{
			pointDifference = new Point(vector3D1.x - vector3D2.x, vector3D1.y - vector3D2.y);
			return Math.sqrt(Math.pow(pointDifference.x, 2) + Math.pow(pointDifference.y, 2));
		}
		
		override public function dispose():void
		{
			core.model.tick.render.remove(Update);
			removeBezierObjects();
			texture.dispose();
			texture = null;
		}
	}
}