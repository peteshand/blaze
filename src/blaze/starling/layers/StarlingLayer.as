package blaze.starling.layers 
{
	import blaze.model.render.RenderModel;
	import blaze.model.viewPort.ViewPort;
	import blaze.starling.BlazeStarlingSprite;
	import blaze.utils.layout.Alignment;
	import flash.geom.Point;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.events.Event;
	/**
	 * ...
	 * @author P.J.Shand
	 */
	public class StarlingLayer extends Sprite implements IStarlingLayer 
	{
		protected var renderModel:RenderModel;
		protected var viewPort:ViewPort;
		
		protected var _starling:Starling;
		//protected var active:Boolean = false;
		public var instanceIndex:int;
		
		private var _root:BlazeStarlingSprite;
		
		public function StarlingLayer() 
		{
			_root = new BlazeStarlingSprite();
			super.addChild(_root);
			
			addEventListener(Event.ADDED_TO_STAGE, OnAdd);
			
		}
		
		/*override public function addChild(child:DisplayObject):DisplayObject
		{
			return _root.addChild(child);
		}
		
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject
		{
			return _root.addChildAt(child, index);
		}*/
		
		public function addChildAtAlignment(child:DisplayObject, alignment:String = Alignment.TOP_LEFT, scaleToScreen:Boolean=false):DisplayObject
		{
			return _root.addChildAtAlignment(child, alignment, scaleToScreen);
		}
		
		public function addChildAtPoint(child:DisplayObject, location:Point, scaleToScreen:Boolean=false):DisplayObject
		{
			return _root.addChildAtPoint(child, location, scaleToScreen);
		}
		
		protected function OnAdd(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, OnAdd);
		}
		
		public function update():void 
		{
			if (_starling) _starling.nextFrame();	
		}
		
		public function setStarling(starling:Starling, instanceIndex:int):void
		{
			this.instanceIndex = instanceIndex;
			renderModel = Blaze.instance(instanceIndex).renderer;
			viewPort = Blaze.instance(instanceIndex).viewPort;
			viewPort.update.add(OnViewPortUpdate);
			this.starling = starling;
		}
		
		public function set starling(value:Starling):void 
		{
			_starling = value;
		}
		
		public function get starling():Starling 
		{
			return _starling;
		}
		
		private function OnViewPortUpdate():void 
		{
			_starling.stage.stageWidth = viewPort.rect.width;
			_starling.stage.stageHeight = viewPort.rect.height;
		}
		
	}

}