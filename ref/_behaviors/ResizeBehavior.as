package blaze.behaviors 
{
	import flash.display.Stage;
	import flash.events.Event;
	import imag.masdar.core.BaseObject;
	
	/**
	 * ...
	 * @author Pete Shand
	 */
	public class ResizeBehavior
	{
		private var stage:Stage;
		private var callback:Function;
		
		private var resizeCount:int = 0;
		private var repeatResizeForXFrames:int = 2;
		
		public function ResizeBehavior() 
		{
			
		}
		
		public function addResizeListener(stage:Stage, callback:Function):void
		{
			this.stage = stage;
			this.callback = callback;
			
			removeResizeListener();
			stage.addEventListener(Event.RESIZE, OnStageResize);
			OnStageResize();
		}
		
		public function removeResizeListener():void
		{
			stage.removeEventListener(Event.RESIZE, OnStageResize);
		}
		
		protected function OnStageResize(e:Event=null):void 
		{
			resizeCount = 0;
			stage.addEventListener(Event.ENTER_FRAME, Update);
			Update(null);
		}
		
		private function Update(e:Event):void 
		{
			resizeCount++;
			if (resizeCount >= repeatResizeForXFrames) stage.removeEventListener(Event.ENTER_FRAME, Update);
			callback();
		}
	}
}