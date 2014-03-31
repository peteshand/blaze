package imag.masdar.core.view.starling.display.base 
{
	import imag.masdar.core.Core;
	import blaze.behaviors.ResizeBehavior;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.events.ResizeEvent;
	import starling.events.Event;
	
	/**
	 * ...
	 * @author Pete Shand
	 */
	public class ResizeSprite extends SceneSprite 
	{
		private var resizeBehavior:ResizeBehavior = new ResizeBehavior();
		
		public function ResizeSprite() 
		{
			super();
		}
		
		protected function addResizeListener():void
		{
			if (stage) resizeBehavior.addResizeListener(core.stage, OnResize);
			else onAddToStage.addOnce(addResizeListener);
		}
		
		protected function OnResize():void
		{
			
		}
	}
}