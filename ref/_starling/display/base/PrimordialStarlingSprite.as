package imag.masdar.core.view.starling.display.base 
{
	import com.greensock.TweenLite;
	import flash.display.Stage;
	import imag.masdar.core.config.VariableObjects.transitions.TweenValueVO;
	import imag.masdar.core.Core;
	import org.osflash.signals.Signal;
	import starling.display.Sprite;
	import starling.events.Event;
	
	/**
	 * ...
	 * @author Pete Shand
	 */
	public class PrimordialStarlingSprite extends Sprite 
	{
		protected var core:Core = Core.getInstance();
		public var showing:Boolean = true;
		
		public var onAddToStage:Signal = new Signal();
		
		public var animationShowHide:Boolean = false;
		protected var showTweenLite:TweenLite = new TweenLite(this, 0, {});
		protected var hideTweenLite:TweenLite = new TweenLite(this, 0, {});
		public var tweenValueVO:TweenValueVO;
		
		public function PrimordialStarlingSprite() 
		{
			super();
			core = Core.getInstance();
			this.addEventListener(Event.ADDED_TO_STAGE, OnAdd);
			tweenValueVO = core.config.tranitions.clone();
			tweenValueVO.target = this;
			tweenValueVO.showTime = 0.4;
			tweenValueVO.showDelay = 0.4;
			tweenValueVO.hideTime = 0.4;
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
			this.visible = true;
			if (animationShowHide) {
				hideTweenLite.kill();
				showTweenLite.kill();
				TweenLite.killTweensOf(tweenValueVO.target);
				showTweenLite = TweenLite.to(tweenValueVO.target, tweenValueVO.showTime, tweenValueVO.ShowProperties );
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
			if (animationShowHide) {
				showTweenLite.kill();
				hideTweenLite.kill();
				TweenLite.killTweensOf(tweenValueVO.target);
				hideTweenLite = TweenLite.to(tweenValueVO.target, tweenValueVO.hideTime, tweenValueVO.HideProperties );
			}
			else this.visible = false;
		}
		
		protected function OnTweenHideStart():void 
		{
			showTweenLite.kill();
		}
		
		protected function OnHideComplete():void 
		{
			//this.visible = false;
		}
	}

}