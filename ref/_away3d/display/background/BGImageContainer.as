package imag.masdar.core.view.away3d.display.background 
{
	import away3d.events.Scene3DEvent;
	import away3d.textures.ATFTexture;
	import away3d.textures.BitmapTexture;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	import imag.masdar.core.utils.layout.Dimensions;
	import imag.masdar.core.view.away3d.display.away2d.Image;
	import imag.masdar.core.view.away3d.display.base.BaseAwayObject;
	
	/**
	 * ...
	 * @author Pete Shand
	 */
	public class BGImageContainer extends BaseAwayObject 
	{
		private var bgImage:Image;
		private var rect:Rectangle;
		
		public function BGImageContainer() 
		{
			
		}
		
		override protected function OnAdd(e:Scene3DEvent):void 
		{
			var atf_BackgroundImage:ByteArray = assets.BackgroundImage;
			var png_BackgroundImage:BitmapData = assets.BackgroundImagePng;
			
			if (atf_BackgroundImage) {
				var atf_texture:ATFTexture = new ATFTexture(atf_BackgroundImage);
				bgImage = new Image(atf_texture);
				bgImage.width = 100;
				bgImage.height = 100;
				addChild(bgImage);
				addResizeListener();
			}
			else if (png_BackgroundImage) {
				var texture:BitmapTexture = new BitmapTexture(png_BackgroundImage);
				bgImage = new Image(texture);
				bgImage.width = 100;
				bgImage.height = 100;
				addChild(bgImage);
				addResizeListener();
			}

		}
		
		override protected function OnResize():void
		{
			rect = Dimensions.Calculator(Dimensions.ZOOM, core.model.viewportModel.width, core.model.viewportModel.height, config.width, config.height);
			bgImage.scaleX = rect.width / 100;
			bgImage.scaleY = rect.height / 100;
		}
	}
}