package imag.masdar.core.view.starling.display.buttons 
{
	import imag.masdar.core.view.starling.display.buttons.imageStateSet.ImageStateSet;
	import org.osflash.signals.Signal;
	import starling.events.Touch;
	
	/**
	 * ...
	 * @author Pete Shand
	 */
	public class ToggleButton extends BaseButton 
	{
		protected var _toggleIndex:int = 0;
		public var toggleWithoutModel:Boolean = true;
		public var toggleUpdate:Signal = new Signal();
		
		public function ToggleButton(imageSet1:ImageStateSet, imageSet2:ImageStateSet) 
		{
			super(imageSet1);
			
			if (imageSet2){
				imageStateSets.push(imageSet2);
				addChild(imageSet2);
				toggleIndex = 0;
			}
		}
		
		public function toggle():void
		{
			if (toggleIndex == 0) toggleIndex = 1;
			else toggleIndex = 0;
			toggleUpdate.dispatch();
		}
		
		public function get toggleIndex():int 
		{
			return _toggleIndex;
		}
		
		public function set toggleIndex(value:int):void 
		{
			_toggleIndex = value;
			this.visiableImageSet = toggleIndex;
		}
		
		override protected function OnTouchEnd(touch:Touch):void
		{
			super.OnTouchEnd(touch);
			if (toggleWithoutModel) toggle();
		}
	}
}