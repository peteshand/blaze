package imag.masdar.core.view.displaylist.display.base 
{
	import com.greensock.TweenLite;
	import flash.display.Sprite;
	import flash.events.Event;
	import imag.masdar.core.config.VariableObjects.transitions.TweenValueVO;
	import imag.masdar.core.Core;
	import org.osflash.signals.Signal;
	
	/**
	 * ...
	 * @author Pete Shand
	 */
	public class PrimordialDisplaylistSprite extends Sprite 
	{
		protected var core:Core = Core.getInstance();
		public var onAddToStage:Signal = new Signal();
		public var visibilityChange:Signal = new Signal();
		
		public var showing:Boolean = true;
		public var animationShowHide:Boolean = false;
		protected var showTweenLite:TweenLite = new TweenLite(this, 0, {});
		protected var hideTweenLite:TweenLite = new TweenLite(this, 0, {});
		public var tweenValueVO:TweenValueVO;
		
		public function PrimordialDisplaylistSprite() 
		{
			core = Core.getInstance();
			this.addEventListener(Event.ADDED_TO_STAGE, OnAdd);
			super();
			tweenValueVO = core.config.tranitions.clone();
			tweenValueVO.target = this;
			tweenValueVO.addShowProperty( { onStart:OnTweenShowStart } );
			tweenValueVO.addHideProperty( { onStart:OnTweenHideStart, onComplete:OnHideComplete });
		}
		
		protected function OnAdd(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, OnAdd);	
			onAddToStage.dispatch();
		}
		
		public function Show():void
		{
			if (showing) return;
			showing = true;
			visibilityChange.dispatch();
			
			this.visible = true;
			if (animationShowHide) {
				hideTweenLite.kill();
				if (tweenValueVO.target){
					TweenLite.killTweensOf(tweenValueVO.target);
					showTweenLite = TweenLite.to(tweenValueVO.target, tweenValueVO.showTime, tweenValueVO.ShowProperties );
				}
			}
		}
		
		protected function OnTweenShowStart():void 
		{
			hideTweenLite.kill();
		}
		
		public function Hide():void
		{
			if (!showing) return;
			showing = false;
			visibilityChange.dispatch();
			
			if (tweenValueVO) {
				showTweenLite.kill();
				if (tweenValueVO.target){
					TweenLite.killTweensOf(tweenValueVO.target);
					hideTweenLite = TweenLite.to(tweenValueVO.target, tweenValueVO.hideTime, tweenValueVO.HideProperties );
				}
			}
			else this.visible = false;
		}
		
		protected function OnTweenHideStart():void 
		{
			showTweenLite.kill();
		}
		
		protected function OnHideComplete():void 
		{
			this.visible = false;
		}
	}
}