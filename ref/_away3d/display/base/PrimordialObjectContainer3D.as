package imag.masdar.core.view.away3d.display.base 
{
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.Scene3D;
	import away3d.events.Scene3DEvent;
	import com.greensock.TweenLite;
	import flash.display.Stage;
	import imag.masdar.core.config.VariableObjects.transitions.TweenValueVO;
	import imag.masdar.core.Core;
	import imag.masdar.core.view.away3d.display.away2d.StandardAsset;
	import org.osflash.signals.Signal;
	
	/**
	 * ...
	 * @author Pete Shand
	 */
	public class PrimordialObjectContainer3D extends ObjectContainer3D 
	{
		protected var core:Core = Core.getInstance();
		protected var stage:Stage = core.stage;
		
		public var onAddToStage:Signal = new Signal();
		private var addedToScene:Boolean = false;
		public var visibilityChange:Signal = new Signal();
		
		protected var _width:Number = 0;
		protected var _height:Number = 0;
		
		public var showing:Boolean = true;
		public var animationShowHide:Boolean = false;
		
		protected var showTweenLite:TweenLite = new TweenLite(this, 0, {});
		protected var hideTweenLite:TweenLite = new TweenLite(this, 0, {});
		public var tweenValueVO:TweenValueVO;
		
		public var scrollShowOffset:int = 0;
		public var scrollHideOffset:int = 0;
		
		protected var _alpha:Number = 1;
		
		public function PrimordialObjectContainer3D() 
		{
			super();
			tweenValueVO = core.config.tranitions.clone();
			tweenValueVO.target = this;
			tweenValueVO.addShowProperty( { onStart:OnTweenShowStart, onComplete:OnShowComplete  } );
			tweenValueVO.addHideProperty( { onStart:OnTweenHideStart, onComplete:OnHideComplete });
		}
		
		override public function set scene(value : Scene3D) : void
		{
			super.scene = value;
			if (!addedToScene && super.scene) {
				addedToScene = true;
				OnAdd(null);
			}
		}
		
		protected function OnAdd(e:Scene3DEvent):void 
		{
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
			visibilityChange.dispatch();
			
			if (animationShowHide) {
				showTweenLite.kill();
				TweenLite.killTweensOf(tweenValueVO.target);
				hideTweenLite = TweenLite.to(tweenValueVO.target, tweenValueVO.hideTime, tweenValueVO.HideProperties );
			}
			else OnHideComplete();
		}
		
		protected function OnTweenHideStart():void 
		{
			showTweenLite.kill();
		}
		
		protected function OnShowComplete():void 
		{
			
		}
		
		protected function OnHideComplete():void 
		{
			this.visible = false;
		}
		
		public function get width():Number {
			return _width;
		}
		public function get height():Number {
			return _height;
		}
		
		public function set width(value:Number):void {
			_width = value;
		}
		public function set height(value:Number):void {
			_height = value;
		}
		
		public function get alpha():Number 
		{
			return _alpha;
		}
		
		public function set alpha(value:Number):void 
		{
			_alpha = value;
		}
	}

}