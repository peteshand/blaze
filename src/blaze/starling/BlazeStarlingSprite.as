package blaze.starling 
{
	import blaze.behaviors.ResizeBehavior;
	import blaze.behaviors.SuperSceneChangeBehavior;
	import blaze.behaviors.TweenBehavior;
	import blaze.utils.layout.Alignment;
	import org.osflash.signals.Signal;
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
		
		//protected var touchObject:DisplayObject;
		//private var starlingTouchBehavior:StarlingTouchBehavior;
		private var locationContainers:Vector.<LocationSprite> = new Vector.<LocationSprite>();
		
		private var _showing:Boolean = true;
		public var onAddToStage:Signal = new Signal();
		public var visibilityChange:Signal = new Signal();
		private var _instanceIndex:int;
		
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
		
		public function get instanceIndex():int 
		{
			return _instanceIndex;
		}
		
		public function set instanceIndex(value:int):void 
		{
			trace("instanceIndex = " + instanceIndex);
			_instanceIndex = value;
			superSceneChangeBehavior = new SuperSceneChangeBehavior(Show, Hide, instanceIndex);
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
			var locationSprite:LocationSprite = new LocationSprite(child, location, scaleToScreen);
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
		
	}
}
import blaze.model.language.LanguageModel;
import blaze.model.render.RenderModel;
import blaze.model.scene.SceneModel;
import blaze.model.tick.Tick;
import blaze.model.viewPort.ViewPort;
import flash.geom.Point;
import starling.display.DisplayObject;
import starling.events.Event;
import blaze.starling.BlazeStarlingSprite;

class LocationSprite extends BlazeStarlingSprite 
{
	private var location:Point;
	public var scaleToScreen:Boolean;
	
	protected var renderModel:RenderModel;
	protected var viewPort:ViewPort;
	protected var sceneModel:SceneModel;
	protected var language:LanguageModel;
	protected var tick:Tick;
	
	public function LocationSprite(child:DisplayObject, _location:Point, _scaleToScreen:Boolean=false) 
	{
		addChild(child);
		location = _location;
		scaleToScreen = _scaleToScreen;
		
		renderModel = Blaze.instance().renderer;
		viewPort = Blaze.instance().viewPort;
		sceneModel = Blaze.instance().sceneModel;
		language = Blaze.instance().language;
		tick = Blaze.instance().tick;
		
		addEventListener(Event.ADDED_TO_STAGE, OnAdd);
	}
	
	override protected function OnAdd(e:Event):void 
	{
		removeEventListener(Event.ADDED_TO_STAGE, OnAdd);
		addResizeListener();
		OnResize();
	}
	
	override protected function OnResize():void
	{
		this.x = Math.round(viewPort.rect.width * location.x);
		this.y = Math.round(viewPort.rect.height * location.y);
		
		if (scaleToScreen) {
			this.scaleX = this.scaleY = viewPort.scaleMin;
		}
	}
}