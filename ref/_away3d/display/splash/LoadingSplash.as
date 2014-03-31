package imag.masdar.core.view.away3d.display.splash 
{
	import away3d.events.Scene3DEvent;
	import away3d.textures.BitmapTexture;
	import com.greensock.TweenLite;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import imag.masdar.core.utils.away.GeoDepth;
	import imag.masdar.core.utils.layout.Dimensions;
	import imag.masdar.core.view.away3d.display.away2d.Image;
	import imag.masdar.core.view.away3d.display.base.BaseAwayObject;
	
	/**
	 * ...
	 * @author Pete Shand
	 */
	public class LoadingSplash extends BaseAwayObject 
	{
		private var splashImage:Image;
		private var rect:Rectangle;
		
		public function LoadingSplash() 
		{
			super();
			
			var bmd:BitmapData = assets.SplashImage;
			
			if (bmd) {
				var texture:BitmapTexture = new BitmapTexture(bmd);
				splashImage = new Image(texture);
				splashImage.width = 100;
				splashImage.height = 100;
				addChild(splashImage);
				addResizeListener();
				OnResize();
				
				this.animationShowHide = true;
				tweenValueVO.target = splashImage;
				tweenValueVO.addHideProperty( { alpha:0 } );
				if (model.startupModel.started) OnStartupComplete();
				else model.startupModel.startupComplete.addOnce(OnStartupComplete);
			}
		}
		
		private function OnStartupComplete():void 
		{
			if (this.parent) this.parent.addChild(this);
			TweenLite.delayedCall(config.splashHideDelay * 60, Hide, null, true);
		}
		
		override public function Hide():void
		{
			super.Hide();
		}
		
		override protected function OnResize():void
		{
			rect = Dimensions.Calculator(Dimensions.ZOOM, core.model.viewportModel.width, core.model.viewportModel.height, config.width, config.height);
			splashImage.scaleX = rect.width / 100;
			splashImage.scaleY = rect.height / 100;
		}
	}

}