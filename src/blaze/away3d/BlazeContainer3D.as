package blaze.away3d 
{
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.Scene3D;
	import away3d.events.Scene3DEvent;
	import blaze.behaviors.ResizeBehavior;
	import blaze.behaviors.SuperSceneChangeBehavior;
	import blaze.behaviors.TweenBehavior;
	import blaze.model.render.RenderModel;
	import blaze.model.viewPort.ViewPort;
	import blaze.utils.layout.Alignment;
	import flash.display.Stage;
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	
	import org.osflash.signals.Signal;
	
	import com.greensock.TweenLite;
	/**
	 * ...
	 * @author Pete Shand
	 */
	public class BlazeContainer3D extends ObjectContainer3D 
	{
		// Controls Show/Hide on sceneIndex, subSceneIndex, subScenendices, and languageIndex change
		private var superSceneChangeBehavior:SuperSceneChangeBehavior
		private var resizeBehavior:ResizeBehavior
		//protected var awayTouchBehavior:AwayTouchBehavior;
		//protected var displaylistTouchBehavior:DisplayListTouchBehavior;
		public var tweenBehavior:TweenBehavior;
		protected var renderModel:RenderModel;
		protected var viewPort:ViewPort;
		
		public var locationContainers:Vector.<LocationContainer3D> = new Vector.<LocationContainer3D>();
		
		public var onAddToStage:Signal = new Signal();
		private var addedToScene:Boolean = false;
		public var visibilityChange:Signal = new Signal();
		
		protected var _width:Number = 0;
		protected var _height:Number = 0;
		
		private var _showing:Boolean = true;
		
		public var scaleToScreen:Boolean = false;
		
		private var _instanceIndex:int = 0;
		protected var scaleContainer:ObjectContainer3D;
		
		protected var _alpha:Number = 1;
		
		public function BlazeContainer3D() 
		{
			super();
			
			scaleContainer = new ObjectContainer3D();
			super.addChild(scaleContainer);
			
			tweenBehavior = new TweenBehavior(this, OnHideComplete, OnShowComplete, OnTweenHideStart, OnTweenShowStart);
			resizeBehavior = new ResizeBehavior();
		}
		
		override public function set scene(value:Scene3D):void
		{
			super.scene = value;
			if (!addedToScene && super.scene) {
				addedToScene = true;
				OnAdd(null);
			}
		}
		
		protected function OnAdd(e:Scene3DEvent):void 
		{
			onAddToStage.dispatch();
		}
		
		public function Show():void
		{
			if (showing) return;
			_showing = true;
			visibilityChange.dispatch();
			
			this.visible = true;
			if (tweenBehavior.animationShowHide) tweenBehavior.Show();
			else OnShowComplete();
		}
		
		public function Hide():void
		{
			if (!showing) return;
			_showing = false;
			visibilityChange.dispatch();
			
			if (tweenBehavior.animationShowHide) tweenBehavior.Hide();
			else OnHideComplete();
		}
		
		protected function OnTweenShowStart():void { }
		protected function OnTweenHideStart():void { }
		protected function OnShowComplete():void { }
		protected function OnHideComplete():void { this.visible = false; }
		
		public function get width():Number { return _width };
		public function get height():Number { return _height };
		public function set width(value:Number):void { _width = value; }
		public function set height(value:Number):void { _height = value; }
		public function get alpha():Number { return _alpha; }
		public function set alpha(value:Number):void { _alpha = value; }
		
		public function get sceneIndex():int					{ return superSceneChangeBehavior.sceneIndex; }
		public function set sceneIndex(value:int):void			{ superSceneChangeBehavior.sceneIndex = value; }
		public function get sceneIndices():Array				{ return superSceneChangeBehavior.sceneIndices; }
		public function set sceneIndices(value:Array):void		{ superSceneChangeBehavior.sceneIndices = value; }
		public function get subSceneIndex():int					{ return superSceneChangeBehavior.subSceneIndex; }
		public function set subSceneIndex(value:int):void		{ superSceneChangeBehavior.subSceneIndex = value; }
		public function get subSceneIndices():Array				{ return superSceneChangeBehavior.subSceneIndices; }
		public function set subSceneIndices(value:Array):void	{ superSceneChangeBehavior.subSceneIndices = value; }
		public function get languageIndex():int 				{ return superSceneChangeBehavior.languageIndex; }
		public function set languageIndex(value:int):void 		{ superSceneChangeBehavior.languageIndex = value; }
		public function get ignoreShowHide():Boolean 			{ return superSceneChangeBehavior.active; }
		public function set ignoreShowHide(value:Boolean):void 	{ superSceneChangeBehavior.active = value; }
		
		public function get screenScale():Number { return scaleContainer.scaleX; }
		public function set screenScale(value:Number):void { scaleContainer.scaleX = scaleContainer.scaleY = scaleContainer.scaleZ = value; }
		
		public function get showing():Boolean { return _showing; }
		
		public function get instanceIndex():int 
		{
			return _instanceIndex;
		}
		
		public function set instanceIndex(value:int):void 
		{
			_instanceIndex = value;
			renderModel = Blaze.instance(instanceIndex).renderer;
			viewPort = Blaze.instance(instanceIndex).viewPort;	
			superSceneChangeBehavior = new SuperSceneChangeBehavior(Show, Hide, instanceIndex);
		}
		
		protected function addResizeListener():void
		{
			if (scene) resizeBehavior.addResizeListener(Blaze.stage, OnResize);
			else onAddToStage.addOnce(addResizeListener);
		}
		
		protected function OnResize():void
		{
			
		}
		
		
		
		
		/*
		
		public function attachTouchListenerTo(touchObject:*, iPickingCollider:IPickingCollider=null, _useStageForRelease:Boolean=false):void 
		{
			if (touchObject is Entity) {
				if (!awayTouchBehavior) awayTouchBehavior = new AwayTouchBehavior(OnTouchBegin, OnTouchMove, OnTouchEnd, null, null);
				awayTouchBehavior.addListenerTo(touchObject, iPickingCollider, _useStageForRelease);
			}
			else if (touchObject is DisplayObject) {
				if (!displaylistTouchBehavior) displaylistTouchBehavior = new DisplayListTouchBehavior(OnTouchBegin, OnTouchMove, OnTouchEnd, null, null);
				displaylistTouchBehavior.addListenerTo(touchObject, _useStageForRelease);
			}
		}
		
		public function removeTouchListenerTo(touchObject:*):void
		{
			if (touchObject is Entity) {
				if (awayTouchBehavior) awayTouchBehavior.removeTouchListenerTo(touchObject);
			}
			else if (touchObject is DisplayObject) {
				if (displaylistTouchBehavior) displaylistTouchBehavior.removeTouchListenerTo(touchObject);
			}
		}
		
		// Override functions:
		// Override the below functions in child classes for touch/mouse interaction
		
		protected function OnTouchBegin(touch:Touch):void
		{
			//trace("OnTouchBegin");
		}
		
		protected function OnTouchMove(touch:Touch):void
		{
			//trace("OnTouchMove");
		}
		
		protected function OnTouchEnd(touch:Touch):void
		{
			//trace("OnTouchEnd");
		}
		
		protected function OnTouchOver(touch:Touch):void
		{
			// current not working correctly... OnTouchOut/OnTouchOver firing every frame while over object
			//trace("OnTouchOver");
		}
		
		protected function OnTouchOut(touch:Touch):void
		{
			// current not working correctly... OnTouchOut/OnTouchOver firing every frame while over object
			//trace("OnTouchOut");
		}
		
		*/
		
		override public function addChild(child:ObjectContainer3D):ObjectContainer3D
		{
			
			return scaleContainer.addChild(child);
		}
		
		public function addChildAtAlignment(child:ObjectContainer3D, alignment:String):ObjectContainer3D
		{
			if (alignment == Alignment.TOP_LEFT)	 return addChildAtPoint(child, new Point(0,0));
			if (alignment == Alignment.TOP)			 return addChildAtPoint(child, new Point(0.5,0));
			if (alignment == Alignment.TOP_RIGHT)	 return addChildAtPoint(child, new Point(1,0));
			if (alignment == Alignment.LEFT)		 return addChildAtPoint(child, new Point(0,0.5));
			if (alignment == Alignment.MIDDLE)		 return addChildAtPoint(child, new Point(0.5,0.5));
			if (alignment == Alignment.RIGHT)		 return addChildAtPoint(child, new Point(1,0.5));
			if (alignment == Alignment.BOTTOM_LEFT)	 return addChildAtPoint(child, new Point(0,1));
			if (alignment == Alignment.BOTTOM)		 return addChildAtPoint(child, new Point(0.5,1));
			if (alignment == Alignment.BOTTOM_RIGHT) return addChildAtPoint(child, new Point(1,1));
			return addChild(child);
		}
		
		public function addChildAtPoint(child:ObjectContainer3D, location:Point):ObjectContainer3D
		{
			var locationContainer3D:LocationContainer3D = new LocationContainer3D(child, location, instanceIndex);
			addChild(locationContainer3D);
			locationContainers.push(locationContainer3D);
			addResizeListener();
			return locationContainer3D.child;
		}
	}
}


import away3d.containers.ObjectContainer3D;
import blaze.model.viewPort.ViewPort;
import flash.events.Event;
import flash.geom.Point;

class LocationContainer3D extends ObjectContainer3D 
{
	private var location:Point;
	public var child:ObjectContainer3D
	private var viewPort:ViewPort;
	private var instanceIndex:int;
	
	public function LocationContainer3D(_child:ObjectContainer3D, _location:Point, instanceIndex:int) 
	{
		this.instanceIndex = instanceIndex;
		
		child = _child;
		addChild(child);
		location = _location;
		
		//OnStageResize();
		viewPort = Blaze.instance(instanceIndex).viewPort;
		viewPort.update.add(OnViewPortUpdate);
		
		OnViewPortUpdate();
		//Blaze.stage.addEventListener(Event.RESIZE, OnStageResize);
	}
	
	private function OnViewPortUpdate():void 
	{
		this.x = viewPort.rect.width * (location.x - 0.5);
		this.y = viewPort.rect.height * -(location.y - 0.5);
	}
	
	/*private function OnStageResize(event:Event=null):void
	{
		this.x = Blaze.instance(instanceIndex).stage.stageWidth * (location.x - 0.5);
		this.y = Blaze.instance(instanceIndex).stage.stageHeight * -(location.y - 0.5);
	}*/
}