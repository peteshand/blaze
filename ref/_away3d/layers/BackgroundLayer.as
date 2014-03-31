package imag.masdar.core.view.away3d.layers
{
	import flash.events.Event;
	import imag.masdar.core.view.away3d.display.background.BGImageContainer;
	
	/**
	 * ...
	 * @author Pete Shand
	 */
	
	public class BackgroundLayer extends AwayLayer
	{
		private var backgroundImage:BGImageContainer;
		
		override protected function OnAdd(e:Event):void 
		{
			this.interactive = false;
			this.mouseChildren = false;
			this.mouseEnabled = false;
			
			super.OnAdd(e);
			
			backgroundImage = new BGImageContainer();
			scene.addChild(backgroundImage);
			backgroundImage.scaleToScreen = true;
			backgroundImage.z = 9500;
			camera.lens.far = 15000;
			
			OnStageResize();
		}
	}
}