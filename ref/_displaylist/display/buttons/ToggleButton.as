package imag.masdar.core.view.displaylist.display.buttons 
{
	import away3d.events.Touch;
	import imag.masdar.core.view.displaylist.display.buttons.bitmapStateSet.BitmapStateSet;
	/**
	 * ...
	 * @author Pete Shand
	 */
	public class ToggleButton extends BaseButton 
	{
		private var _toggleIndex:int = 0;
		public var toggleWithoutModel:Boolean = true;
		
		public function ToggleButton(bitmapSet1:BitmapStateSet, bitmapSet2:BitmapStateSet) 
		{
			super(bitmapSet1);
			
			if (bitmapSet2){
				bitmapStateSets.push(bitmapSet2);
				addChild(bitmapSet2);
			}
		}
		
		public function toggle():void
		{
			if (toggleIndex == 0) toggleIndex = 1;
			else toggleIndex = 0;
		}
		
		public function get toggleIndex():int 
		{
			return _toggleIndex;
		}
		
		public function set toggleIndex(value:int):void 
		{
			_toggleIndex = value;
			this.visiableBitmapSet = toggleIndex;
		}
		
		override protected function OnTouchEnd(touch:Touch):void
		{
			super.OnTouchEnd(touch);
			if (toggleWithoutModel) toggle();
		}
	}

}