package imag.masdar.core.view.away3d.display.base 
{
	import flash.events.Event;
	import blaze.behaviors.ResizeBehavior;
	/**
	 * ...
	 * @author Pete Shand
	 */
	public class ResizeContainer3D extends SceneContainer3D 
	{
		private var resizeBehavior:ResizeBehavior = new ResizeBehavior();
		
		private var _scaleToScreen:Boolean = false;
		protected var _screenScale:Number = 1;
		protected var scaleXTemp:Number = 1;
		protected var scaleYTemp:Number = 1;
		protected var scaleZTemp:Number = 1;
		
		public function ResizeContainer3D() 
		{
			super();
		}
		
		public function get screenScale():Number 
		{
			return _screenScale;
		}
		
		public function set screenScale(value:Number):void 
		{
			_screenScale = value;
			scaleX = scaleXTemp;
			scaleY = scaleYTemp;
			scaleZ = scaleZTemp;
		}
		
		override public function set scaleX(value:Number):void 
		{
			scaleXTemp = value;
			super.scaleX = scaleXTemp * screenScale;
		}
		
		override public function set scaleY(value:Number):void 
		{
			scaleYTemp = value;
			super.scaleY = scaleYTemp * screenScale;
		}
		
		override public function set scaleZ(value:Number):void 
		{
			scaleZTemp = value;
			super.scaleZ = scaleZTemp * screenScale;
		}
		
		public function get scaleToScreen():Boolean 
		{
			return _scaleToScreen;
		}
		
		public function set scaleToScreen(value:Boolean):void 
		{
			_scaleToScreen = value;
		}
		
		protected function addResizeListener():void
		{
			if (scene) resizeBehavior.addResizeListener(core.stage, OnResize);
			else onAddToStage.addOnce(addResizeListener);
		}
		
		protected function OnResize():void
		{
			
		}
	}
}