package imag.masdar.core.view.starling.display.buttons 
{
	import imag.masdar.core.utils.layout.Alignment;
	import imag.masdar.core.view.starling.display.base.BaseStarlingObject;
	import imag.masdar.core.view.starling.display.buttons.imageStateSet.ImageStateSet;
	import starling.events.Touch;
	
	/**
	 * ...
	 * @author Pete Shand
	 */
	public class BaseButton extends BaseStarlingObject 
	{
		private var _buttonState:int = ImageStateSet.NORMAL_STATE;
		private var _visiableImageSet:int = -1;
		protected var imageStateSets:Vector.<ImageStateSet> = new Vector.<ImageStateSet>();
		
		public function BaseButton(imageStateSet:ImageStateSet) 
		{
			super();
			if (imageStateSet){
				imageStateSets.push(imageStateSet);
				addChild(imageStateSet);
				attachTouchListenerTo(this);
			}
			
			this.animationShowHide = true;
			tweenValueVO.target = this;
			tweenValueVO.showTime = tweenValueVO.hideTime = 0.3;
			tweenValueVO.showDelay = tweenValueVO.hideDelay = 0;
			tweenValueVO.addShowProperty( { alpha:1 } );
			tweenValueVO.addHideProperty( { alpha:0 } );
		}
		
		override protected function OnHideComplete():void 
		{
			this.visible = false;
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
			for (var i:int = 0; i < imageStateSets.length; ++i) {
				imageStateSets[i].buttonState = buttonState;
			}
		}
		
		public function get visiableImageSet():int 
		{
			return _visiableImageSet;
		}
		
		public function set visiableImageSet(value:int):void 
		{
			_visiableImageSet = value;
			
			if (visiableImageSet == -1) {
				for (var i:int = 0; i < imageStateSets.length; ++i) {
					imageStateSets[i].Show();
				}
			}
			else {
				for (var j:int = 0; j < imageStateSets.length; ++j) {
					if (value == j) imageStateSets[j].Show();
					else imageStateSets[j].Hide();
				}
			}
		}
		
		override protected function OnTouchBegin(touch:Touch):void
		{
			buttonState = ImageStateSet.DOWN_STATE;
		}
		
		override protected function OnTouchMove(touch:Touch):void
		{
			
		}
		
		override protected function OnTouchEnd(touch:Touch):void
		{
			buttonState = ImageStateSet.NORMAL_STATE;
		}
	}
}