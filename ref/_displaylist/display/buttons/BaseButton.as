package imag.masdar.core.view.displaylist.display.buttons 
{
	import away3d.events.Touch;
	import imag.masdar.core.utils.layout.Alignment;
	import imag.masdar.core.view.displaylist.display.base.BaseClassicSprite;
	import imag.masdar.core.view.displaylist.display.buttons.bitmapStateSet.BitmapStateSet;
	
	/**
	 * ...
	 * @author Pete Shand
	 */
	public class BaseButton extends BaseClassicSprite 
	{
		private var _buttonState:int = BitmapStateSet.NORMAL_STATE;
		private var _visiableBitmapSet:int = -1;
		protected var bitmapStateSets:Vector.<BitmapStateSet> = new Vector.<BitmapStateSet>();
		
		public function BaseButton(bitmapStateSet:BitmapStateSet) 
		{
			super();
			if (bitmapStateSet){
				bitmapStateSets.push(bitmapStateSet);
				addChild(bitmapStateSet);
				attachTouchListenerTo(this);
			}
		}
		
		public function set anchor(alignment:String):void
		{
			if (alignment == Alignment.TOP_LEFT) {
				this.x = config.shellPadding.left;
				this.y = config.shellPadding.top;
			}
			else if (alignment == Alignment.TOP) {
				this.x = -this.width / 2;
				this.y = config.shellPadding.top;
			}
			else if (alignment == Alignment.TOP_RIGHT) {
				this.x = -this.width - config.shellPadding.right;
				this.y = config.shellPadding.top;
			}
			else if (alignment == Alignment.LEFT) {
				this.x = config.shellPadding.left;
				this.y = -this.height / 2;
			}
			else if (alignment == Alignment.MIDDLE) {
				this.x = -this.width / 2;
				this.y = -this.height / 2;
			}
			else if (alignment == Alignment.RIGHT) {
				this.x = -this.width - config.shellPadding.right;
				this.y = -this.height / 2;
			}
			else if (alignment == Alignment.BOTTOM_LEFT) {
				this.x = config.shellPadding.left;
				this.y = -this.height - config.shellPadding.bottom;
			}
			else if (alignment == Alignment.BOTTOM) {
				this.x = -this.width / 2;
				this.y = -this.height - config.shellPadding.bottom;
			}
			else if (alignment == Alignment.BOTTOM_RIGHT) {
				this.x = -this.width - config.shellPadding.right;
				this.y = -this.height - config.shellPadding.bottom;
			}
		}
		
		public function get buttonState():int 
		{
			return _buttonState;
		}
		
		public function set buttonState(value:int):void 
		{
			_buttonState = value;
			for (var i:int = 0; i < bitmapStateSets.length; ++i) {
				bitmapStateSets[i].buttonState = buttonState;
			}
		}
		
		public function get visiableBitmapSet():int 
		{
			return _visiableBitmapSet;
		}
		
		public function set visiableBitmapSet(value:int):void 
		{
			_visiableBitmapSet = value;
			
			if (visiableBitmapSet == -1) {
				for (var i:int = 0; i < bitmapStateSets.length; ++i) {
					bitmapStateSets[i].Show();
				}
			}
			else {
				for (var j:int = 0; j < bitmapStateSets.length; ++j) {
					if (value == j) bitmapStateSets[j].Show();
					else bitmapStateSets[j].Hide();
				}
			}
		}
		
		override protected function OnTouchBegin(touch:Touch):void
		{
			buttonState = BitmapStateSet.DOWN_STATE;
		}
		
		override protected function OnTouchMove(touch:Touch):void
		{
			
		}
		
		override protected function OnTouchEnd(touch:Touch):void
		{
			buttonState = BitmapStateSet.NORMAL_STATE;
		}
	}
}