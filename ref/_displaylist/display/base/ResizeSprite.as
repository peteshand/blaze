package imag.masdar.core.view.displaylist.display.base 
{
	import flash.events.Event;
	import blaze.behaviors.ResizeBehavior;
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