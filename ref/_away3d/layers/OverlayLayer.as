package imag.masdar.core.view.away3d.layers
{
	import flash.events.Event;
	import flash.system.Capabilities;
	import imag.masdar.core.view.away3d.display.bokeh.BokehContainer;
	import imag.masdar.core.view.away3d.display.overlay.MessageOverlay;
	import imag.masdar.core.view.away3d.display.overlay.OverlayImage;
	import imag.masdar.core.view.away3d.display.splash.LoadingSplash;
	import imag.masdar.core.view.away3d.display.touchTrail.TouchTrails;
	
	/**
	 * ...
	 * @author Pete Shand
	 */
	
	public class OverlayLayer extends AwayLayer
	{
		protected var touchTrails:TouchTrails;
		protected var bokehContainer:BokehContainer;
		protected var messageOverlay:MessageOverlay;
		protected var overlayImage:OverlayImage;
		protected var loadingSplash:LoadingSplash;
		
		override protected function OnAdd(e:Event):void 
		{
			this.interactive = false;
			this.mouseChildren = false;
			this.mouseEnabled = false;
			
			super.OnAdd(e);
			
			if (config.interactive){
				touchTrails = new TouchTrails();
				touchTrails.scaleToScreen = true;
				touchTrails.z = -900;
				scene.addChild(touchTrails);
			}
			
			if (config.showBokehs) {
				
				var h:Number = Capabilities.screenResolutionY;
				var fieldOfView:Number = 90; // camera viewing angle
				var fovy:Number = fieldOfView * Math.PI / 180;
				var pixelPerfectLocZ:Number = -(h / 2) / Math.tan(fovy / 2);
				
				bokehContainer = new BokehContainer();
				bokehContainer.scaleToScreen = true;
				bokehContainer.z = -1000 - pixelPerfectLocZ;
				scene.addChild(bokehContainer);
				
				// DynamicBokehContainer either needs to be moved to the core so all applications can use it
				// or added into a 3d layer within the timeline application.
				// The issue with adding it here currently is that the core can not reference anything in the experience.
				
				//var bokehContainer:DynamicBokehContainer = new DynamicBokehContainer();
				//bokehContainer.scaleToScreen = true;
				//scene.addChild(bokehContainer);
			}
			
			messageOverlay = new MessageOverlay();
			messageOverlay.scaleToScreen = true;
			messageOverlay.z = -500;
			scene.addChild(messageOverlay);
			
			
			
			
			overlayImage = new OverlayImage();
			overlayImage.scaleToScreen = true;
			scene.addChild(overlayImage);
			
			loadingSplash = new LoadingSplash();
			loadingSplash.scaleToScreen = true;
			scene.addChild(loadingSplash);
			
			OnStageResize();
		}
	}
}