package imag.masdar.core.view.displaylist.display.buttons.bitmapStateSet 
{
	import com.greensock.TweenLite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	/**
	 * ...
	 * @author Pete Shand
	 */
	public class BitmapContainer extends Bitmap 
	{
		public function BitmapContainer(bitmapData:BitmapData=null, pixelSnapping:String="auto", smoothing:Boolean=false) 
		{
			super(bitmapData, pixelSnapping, smoothing);
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