package imag.masdar.core.view.starling.display.fade 
{
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.textures.Texture;
	/**
	 * ...
	 * @author Tom Byrne
	 */
	public class FadeBlock 
	{
		public function get display():DisplayObject {
			return _display;
		}
		
		public function set alpha(value:Number):void {
			_alpha = value;
			_display.alpha = 1 - value;
		}
		public function get alpha():Number {
			return _alpha;
		}
		
		private var _alpha:Number = 1;
		private var _display:Image;
		
		public function FadeBlock(colour:uint=0xff000000) 
		{
			_display = new Image(Texture.fromColor(10, 10, colour));
			_display.alpha = 0;
			_display.touchable = false;
		}
		
	}

}