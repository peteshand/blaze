package imag.masdar.core.view.displaylist.layers 
{
	import flash.display.Sprite;
	import imag.masdar.core.Core;
	
	
	/**
	 * ...
	 * @author Pete Shand
	 */
	
	public class BaseClassicLayer extends Sprite 
	{
		protected var core:Core = Core.getInstance();
		
		public function BaseClassicLayer() 
		{
			super();
		}
	}
}