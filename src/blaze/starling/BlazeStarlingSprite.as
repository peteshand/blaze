package blaze.starling 
{
	import blaze.behaviors.ResizeBehavior;
	import blaze.behaviors.SuperSceneChangeBehavior;
	import blaze.behaviors.TweenBehavior;
	import blaze.model.language.LanguageModel;
	import blaze.model.render.RenderModel;
	import blaze.model.scene.SceneModel;
	import blaze.model.tick.Tick;
	import blaze.model.viewPort.ViewPort;
	import blaze.utils.layout.Alignment;
	import org.osflash.signals.Signal;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.events.Event;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author P.J.Shand
	 */
	public class BlazeStarlingSprite extends Sprite 
	{
		// Controls Show/Hide on sceneIndex, subSceneIndex, subScenendices, and languageIndex change
		private var superSceneChangeBehavior:SuperSceneChangeBehavior;
		public var tweenBehavior:TweenBehavior;
		private var resizeBehavior:ResizeBehavior = new ResizeBehavior();
		
		protected var renderModel:RenderModel;
		protected var viewPort:ViewPort;
		protected var sceneModel:SceneModel;
		protected var language:LanguageModel;
		protected var tick:Tick;
		
		//protected var touchObject:DisplayObject;
		//private var starlingTouchBehavior:StarlingTouchBehavior;
		private var locationContainers:Vector.<LocationSprite> = new Vector.<LocationSprite>();
		
		private var _showing:Boolean = true;
		public var onAddToStage:Signal = new Signal();
		public var visibilityChange:Signal = new Signal();
		
		public var starling:Starling;
		private var _instanceIndex:int = 0;
		
		public function BlazeStarlingSprite() 
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, OnAdd);
			tweenBehavior = new TweenBehavior(this, OnHideComplete, OnShowComplete, OnTweenHideStart, OnTweenShowStart);
		}
		
		protected function OnAdd(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, OnAdd);	
			onAddToStage.dispatch();
		}
		
		protected function addResizeListener():void
		{
			if (stage) resizeBehavior.addResizeListener(Blaze.stage, OnResize);
			else onAddToStage.addOnce(addResizeListener);
		}
		
		protected function OnResize():void
		{
			
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
		
		public function get showing():Boolean { return _showing; }
		
		private var _sceneIndex:int = -1;
		private var _sceneIndices:Array = new Array();
		private var _subSceneIndex:int = -1;
		private var _subSceneIndices:Array = new Array();
		private var _languageIndex:int = -1;
		private var _ignoreShowHide:Boolean = true;
		
		public function get sceneIndex():int					{ return _sceneIndex; }
		public function set sceneIndex(value:int):void {
			_sceneIndex = value;
			trace("superSceneChangeBehavior = " + superSceneChangeBehavior);
			if (superSceneChangeBehavior) superSceneChangeBehavior.sceneIndex = value;
		}
		
		public function get sceneIndices():Array				{ return _sceneIndices; }
		public function set sceneIndices(value:Array):void {
			_sceneIndices = value; 
			if (superSceneChangeBehavior) superSceneChangeBehavior.sceneIndices = value;
		}
		
		public function get subSceneIndex():int					{ return _subSceneIndex; }
		public function set subSceneIndex(value:int):void {
			_subSceneIndex = value;
			if (superSceneChangeBehavior) superSceneChangeBehavior.subSceneIndex = value;
		}
		
		public function get subSceneIndices():Array				{ return _subSceneIndices; }
		public function set subSceneIndices(value:Array):void {
			_subSceneIndices = value;
			if (superSceneChangeBehavior) superSceneChangeBehavior.subSceneIndices = value;
		}
		
		public function get languageIndex():int 				{ return _languageIndex; }
		public function set languageIndex(value:int):void {
			_languageIndex = value;
			if (superSceneChangeBehavior) superSceneChangeBehavior.languageIndex = value;
		}
		
		public function get ignoreShowHide():Boolean 			{ return _ignoreShowHide; }
		public function set ignoreShowHide(value:Boolean):void {
			_ignoreShowHide = value;
			if (superSceneChangeBehavior) superSceneChangeBehavior.active = value;
		}
		
		public function get instanceIndex():int 
		{
			return _instanceIndex;
		}
		
		public function set instanceIndex(value:int):void 
		{
			_instanceIndex = value;
			
			superSceneChangeBehavior = new SuperSceneChangeBehavior(Show, Hide, instanceIndex);
			superSceneChangeBehavior.sceneIndex = _sceneIndex;
			superSceneChangeBehavior.sceneIndices = _sceneIndices;
			superSceneChangeBehavior.subSceneIndex = _subSceneIndex;
			superSceneChangeBehavior.subSceneIndices = _subSceneIndices;
			superSceneChangeBehavior.languageIndex = _languageIndex;
			superSceneChangeBehavior.active = _ignoreShowHide;
			
			renderModel = Blaze.instance(instanceIndex).renderer;
			viewPort = Blaze.instance(instanceIndex).viewPort;
			sceneModel = Blaze.instance(instanceIndex).sceneModel;
			language = Blaze.instance(instanceIndex).language;
			tick = Blaze.instance(instanceIndex).tick;
		}
		
		
		
		/*public function attachTouchListenerTo(touchObject:DisplayObject):void 
		{
			if (!starlingTouchBehavior) starlingTouchBehavior = new StarlingTouchBehavior(OnTouchBegin, OnTouchMove, OnTouchEnd, OnTouchHover);
			starlingTouchBehavior.addListenerTo(touchObject);
		}
		
		public function removeTouchListenerTo(touchObject:DisplayObject):void 
		{
			if (starlingTouchBehavior) starlingTouchBehavior.removeTouchListenerTo(touchObject);
		}
		
		protected function OnTouchBegin(touch:Touch):void { }
		protected function OnTouchMove(touch:Touch):void { }
		protected function OnTouchEnd(touch:Touch):void { }
		protected function OnTouchHover(touch:Touch):void { }*/
		
		
		public function addChildAtAlignment(child:DisplayObject, alignment:String, scaleToScreen:Boolean=false):DisplayObject
		{
			if (alignment == Alignment.TOP_LEFT)	 return addChildAtPoint(child, new Point(0,0), scaleToScreen);
			if (alignment == Alignment.TOP)			 return addChildAtPoint(child, new Point(0.5,0), scaleToScreen);
			if (alignment == Alignment.TOP_RIGHT)	 return addChildAtPoint(child, new Point(1,0), scaleToScreen);
			if (alignment == Alignment.LEFT)		 return addChildAtPoint(child, new Point(0,0.5), scaleToScreen);
			if (alignment == Alignment.MIDDLE)		 return addChildAtPoint(child, new Point(0.5,0.5), scaleToScreen);
			if (alignment == Alignment.RIGHT)		 return addChildAtPoint(child, new Point(1,0.5), scaleToScreen);
			if (alignment == Alignment.BOTTOM_LEFT)	 return addChildAtPoint(child, new Point(0,1), scaleToScreen);
			if (alignment == Alignment.BOTTOM)		 return addChildAtPoint(child, new Point(0.5,1), scaleToScreen);
			if (alignment == Alignment.BOTTOM_RIGHT) return addChildAtPoint(child, new Point(1,1), scaleToScreen);
			return addChild(child);
		}
		
		public function addChildAtPoint(child:DisplayObject, location:Point, scaleToScreen:Boolean=false):DisplayObject
		{
			var locationSprite:LocationSprite = new LocationSprite(child, location, instanceIndex, scaleToScreen);
			addChild(locationSprite);
			locationContainers.push(locationSprite);
			addResizeListener();
			return locationSprite;
		}
		
		public function removeChildFromAlignment(child:DisplayObject):void
		{
			if (child.parent.parent) {
				child.parent.parent.removeChild(child.parent);
			}
			if (child.parent) child.parent.removeChild(child);
		}
		
		override public function addChild(child:DisplayObject):starling.display.DisplayObject
		{
			addInstanceIndex(child);
			return super.addChild(child);
		}
		
		override public function addChildAt(child:DisplayObject, index:int):starling.display.DisplayObject
		{
			addInstanceIndex(child);
			return super.addChildAt(child, index);
		}
		
		private function addInstanceIndex(child:DisplayObject):void
		{
			if (child is BlazeStarlingSprite) {
				BlazeStarlingSprite(child).instanceIndex = this.instanceIndex;
				BlazeStarlingSprite(child).starling = this.starling;
			}
		}
	}
}
import blaze.behaviors.ResizeBehavior;
import blaze.model.language.LanguageModel;
import blaze.model.render.RenderModel;
import blaze.model.scene.SceneModel;
import blaze.model.tick.Tick;
import blaze.model.viewPort.ViewPort;
import flash.geom.Point;
import starling.display.DisplayObject;
import starling.display.Sprite;
import starling.events.Event;
import blaze.starling.BlazeStarlingSprite;

class LocationSprite extends Sprite 
{
	private var location:Point;
	public var scaleToScreen:Boolean;
	
	private var instanceIndex:int;
	protected var viewPort:ViewPort;
	private var resizeBehavior:ResizeBehavior;
	
	public function LocationSprite(child:DisplayObject, _location:Point, instanceIndex:int, _scaleToScreen:Boolean=false) 
	{
		addChild(child);
		location = _location;
		scaleToScreen = _scaleToScreen;
		
		this.instanceIndex = instanceIndex;
		
		viewPort = Blaze.instance(instanceIndex).viewPort;
		
		resizeBehavior = new ResizeBehavior();
		addEventListener(Event.ADDED_TO_STAGE, OnAdd);
	}
	
	protected function OnAdd(e:Event):void 
	{
		removeEventListener(Event.ADDED_TO_STAGE, OnAdd);
		resizeBehavior.addResizeListener(Blaze.stage, OnResize);
		OnResize();
	}
	
	protected function OnResize():void
	{
		this.unflatten();
		this.x = Math.round(viewPort.rect.width * location.x);
		this.y = Math.round(viewPort.rect.height * location.y);
		
		if (scaleToScreen) {
			this.scaleX = this.scaleY = viewPort.scaleMin;
		}
		this.flatten();
	}
}