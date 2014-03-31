package imag.masdar.core.view.starling.display.buttons.imageStateSet 
{
	import com.greensock.TweenLite;
	import starling.display.Image;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author Pete Shand
	 */
	public class ImageContainer extends Image 
	{
		public function ImageContainer(texture:Texture) 
		{
			super(texture);
		}
		
		public function Show(fadeTime:Number=0.3):void
		{
			this.visible = true;
			TweenLite.to(this, fadeTime, { alpha:1} );
		}
		
		public function Hide(fadeTime:Number=0.3):void
		{
			TweenLite.to(this, fadeTime, { alpha:0, onComplete:OnFadeOutComplete} );
		}
		
		private function OnFadeOutComplete():void 
		{
			this.visible = false;
		}
	}
}