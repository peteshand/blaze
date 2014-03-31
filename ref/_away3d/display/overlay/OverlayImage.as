package imag.masdar.core.view.away3d.display.overlay 
{
	import away3d.events.Scene3DEvent;
	import away3d.textures.BitmapTexture;
	import away3d.utils.Cast;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.geom.Vector3D;
	import imag.masdar.core.utils.layout.Alignment;
	import imag.masdar.core.view.away3d.display.away2d.Image;
	import imag.masdar.experience.view.away3d.display.base.BaseAwayObject;
	
	/**
	 * ...
	 * @author Pete Shand
	 */
	public class OverlayImage extends BaseAwayObject 
	{
		protected var highlightBlend:String = BlendMode.ADD;
		protected var shadowBlend:String = BlendMode.MULTIPLY;
		
		protected var highlightImage:Image;
		protected var shadowImage:Image;
		
		protected var highlightPosition:Vector3D = new Vector3D();
		protected var shadowPosition:Vector3D = new Vector3D();
		
		public function OverlayImage() 
		{
			
		}
		
		override protected function OnAdd(e:Scene3DEvent):void 
		{
			super.OnAdd(e);
			
			shadowImage = createOverlayImage(assets.OverlayShadow, shadowBlend, shadowPosition);
			highlightImage = createOverlayImage(assets.OverlayHighlight, highlightBlend, highlightPosition);
			
			
			trace("shadowImage = " + shadowImage);
		}
		
		protected function createOverlayImage(bmd:BitmapData, blendMode:String, postion:Vector3D):Image
		{
			if (!bmd) return null;
			var image:Image = new Image(Cast.bitmapTexture(bmd));
			image.width = config.width;
			image.height = config.height;
			image.blendMode = blendMode;
			image.position = postion;
			image.alphaBlending = true;
			addChildAtAlignment(image, Alignment.MIDDLE);
			return image;
		}
	}
}