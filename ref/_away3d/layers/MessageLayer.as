package imag.masdar.core.view.away3d.layers
{
	import flash.events.Event;
	import imag.masdar.core.view.away3d.display.overlay.MessageOverlay;
	
	/**
	 * ...
	 * @author Pete Shand
	 */
	
	public class MessageLayer extends AwayLayer
	{
		private var messageOverlay:MessageOverlay;
		
		override protected function OnAdd(e:Event):void 
		{
			this.interactive = false;
			this.mouseChildren = false;
			this.mouseEnabled = false;
			
			super.OnAdd(e);
			
			messageOverlay = new MessageOverlay();
			messageOverlay.scaleToScreen = true;
			messageOverlay.z = -500;
			scene.addChild(messageOverlay);
			
			OnStageResize();
		}
	}
}