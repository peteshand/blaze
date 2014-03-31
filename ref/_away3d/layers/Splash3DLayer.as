package imag.masdar.core.view.away3d.layers 
{
	import flash.events.Event;
	import imag.masdar.core.view.away3d.display.shell.Shell;
	import imag.masdar.core.view.away3d.display.splash.LoadingSplash;
	
	/**
	 * ...
	 * @author Pete Shand
	 */
	
	public class Splash3DLayer extends AwayLayer 
	{
		private var loadingSplash:LoadingSplash;
		
		override protected function OnAdd(e:Event):void 
		{
			super.OnAdd(e);
			
			loadingSplash = new LoadingSplash();
			loadingSplash.scaleToScreen = true;
			loadingSplash.z = -950;
			scene.addChild(loadingSplash);
			
			OnStageResize();
		}
	}
}