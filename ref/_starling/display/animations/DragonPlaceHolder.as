package imag.masdar.core.view.starling.display.animations 
{
	import dragonBones.Armature;
	import dragonBones.objects.AnimationData;
	import imag.masdar.core.utils.starling.ImageUtils;
	import imag.masdar.core.view.starling.display.base.BaseStarlingObject;
	import starling.display.DisplayObject;
	import starling.display.Image;
	
	/**
	 * ...
	 * @author Pete Shand
	 */
	public class DragonPlaceHolder extends BaseStarlingObject 
	{
		private var dragonBoneName:String;
		private var armature:Armature;
		private var display:DisplayObject;
		
		private var animationDataList:Vector.<AnimationData>;
		private var currentAnimation:String = "";
		private var firstAnimation:String = "";
		private var containsIntroAnimation:Boolean = false;
		private var containsLoopAnimation:Boolean = false;
		
		public static const ANIMATION_INTRO:String = 'intro';
		public static const ANIMATION_LOOP:String = 'loop';
		
		public function DragonPlaceHolder(name:String) 
		{
			super();
			
			this.name = name;
			dragonBoneName = name.split('dragon_')[1];
			
			//addDebugImage();
			addArmature();
			initTweenValueVO();
		}
		
		/*private function addDebugImage():void 
		{
			var imagePlaceHolder:Image = ImageUtils.fromColour(1, 1, 0x6600FF00);
			imagePlaceHolder.width = 150;
			imagePlaceHolder.height = 150;
			addChild(imagePlaceHolder);
		}*/
		
		private function initTweenValueVO():void 
		{
			animationShowHide = true;
			tweenValueVO.target = display;
			tweenValueVO.showTime = 0.5;
			tweenValueVO.showDelay = 0.8;
			tweenValueVO.hideTime = 0.5;
			tweenValueVO.addShowProperty( { alpha:1 } );
			tweenValueVO.addHideProperty( { alpha:0 } );
		}
		
		private function addArmature():void 
		{
			armature = model.dragonBones.buildArmature(dragonBoneName);
			if (!armature) throw new Error('armature named "' + dragonBoneName + '" not found in DragonBones Graphics png');
			
			display = armature.display as DisplayObject;
			display.alpha = 0;			
			display.touchable = false;
			addChild(display);
			
			animationDataList = armature.animation.animationDataList;
			for (var i:int = 0; i < animationDataList.length; ++i) {
				if (i == 0) firstAnimation = animationDataList[i].name;
				if (animationDataList[i].name == DragonPlaceHolder.ANIMATION_INTRO)	containsIntroAnimation = true;
				if (animationDataList[i].name == DragonPlaceHolder.ANIMATION_LOOP)	containsLoopAnimation = true;
			}
			
		}
		
		public function checkIfShowAtStart():void
		{
			if (this.x < config.width && this.height < config.height)
			{
				showing = false;
				Show();
			}
		}
		
		override public function Show():void 
		{
			if (showing) return;
			super.Show();
			
			armature.animation.play();
			currentAnimation = firstAnimation;
			armature.animation.gotoAndPlay(currentAnimation);
			
			model.tick.render.add(OnTick);
		}
		
		override public function Hide():void 
		{
			if (!showing) return;
			super.Hide();
		}
		
		override protected function OnHideComplete():void 
		{
			armature.animation.stop();
			model.tick.render.remove(OnTick);
		}
		
		private function OnTick(timeDelta:Number):void 
		{
			//armature.animation.advanceTime(timeDelta);
			armature.advanceTime(timeDelta);
			
			if (armature.animation.isComplete) {
				if (containsLoopAnimation && currentAnimation != DragonPlaceHolder.ANIMATION_LOOP){
					currentAnimation = DragonPlaceHolder.ANIMATION_LOOP;
					armature.animation.gotoAndPlay(currentAnimation);
				}
			}
		}
		
	}
}