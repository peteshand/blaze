package imag.masdar.core.view.starling.display.slider 
{
	import com.greensock.TweenLite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import imag.masdar.core.model.assetPool.AssetContainerObject;
	import imag.masdar.core.model.scroll.ScrollObject;
	import imag.masdar.core.model.texturePacker.AtlasImage;
	import imag.masdar.core.utils.layout.Alignment;
	import blaze.behaviors.SceneChangeBehavior;
	import imag.masdar.core.view.starling.display.animations.ArrowPathAnimation;
	import imag.masdar.core.view.starling.display.animations.BaseSlideAnimation;
	import imag.masdar.core.view.starling.display.animations.GridAnimation;
	import imag.masdar.core.view.starling.display.base.BaseStarlingObject;
	import imag.masdar.core.view.starling.display.base.PrimordialStarlingSprite;
	import imag.masdar.core.view.starling.display.text.StarlingTLF;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	/**
	 * ...
	 * @author Pete Shand
	 */
	public class SlideContainer extends BaseStarlingObject 
	{
		//private var hitArea:HitArea;
		public var container:Sprite;
		private var scrollLoc:Point = new Point();
		
		private var numSliderChildren:int = 0;
		public var children:Vector.<SliderChildContainerVO> = new Vector.<SliderChildContainerVO>();
		
		private static var DIRECTION_LEFT:int = -1;
		private static var DIRECTION_RIGHT:int = 1;
		
		private var assetContainerObject:AssetContainerObject;
		private var linkToScene:Boolean;
		
		public var scrollObject:ScrollObject;
		private var assetBounds:Rectangle = new Rectangle();
		public var assetContainer:BaseStarlingObject = new BaseStarlingObject();
		
		public function SlideContainer(sceneIndex:int, languageIndex:int, assetContainerObject:AssetContainerObject, linkToScene:Boolean=true, scrollbarGap:int=80) 
		{
			if (linkToScene) this.sceneIndex = sceneIndex;
			this.languageIndex = languageIndex;
			this.assetContainerObject = assetContainerObject;
			
			scrollObject = model.contentScrollValue.scrollObject(sceneIndex);
			
			/* Is anyone using this? I'm now using ScrollInteraction.as to control both away3d and starling SlideContainer */
			//hitArea = new HitArea(scrollObject, config.horizontalScroll, config.verticalScroll, scrollbarGap, languageIndex);
			//addChild(hitArea);
			
			container = new Sprite();
			addChildAtAlignment(container, Alignment.TOP_LEFT, true);
			
		}
		
		override protected function OnAdd(e:Event):void 
		{
			super.OnAdd(e);
			
			if (assetContainerObject) {
				
				for (var i:int = 0; i < assetContainerObject.assetObjects.length; ++i) {
					assetContainerObject.assetObjects[i].addStartlingObjectToContainer(assetContainer, languageIndex);
				}
				this.addSlideContent(assetContainer);
				assetBounds = assetContainerObject.bounds;
			}
			
			OnResize();
			
			CheckInitLanguage();
		}
		
		private function CheckInitLanguage():void 
		{
			if (this.languageIndex != model.language.languageIndex) {
				this.Hide();
			}
		}
		
		public function addSlideContent(slideSprite:Sprite):void
		{
			container.addChild(slideSprite);
			
			numSliderChildren += slideSprite.numChildren;
			for (var i:int = 0; i < numSliderChildren; ++i) {
				
				var sliderChildContainerVO:SliderChildContainerVO = new SliderChildContainerVO();
				sliderChildContainerVO.child = slideSprite.getChildAt(i);
				sliderChildContainerVO.middleLoc.x = sliderChildContainerVO.child.x + (sliderChildContainerVO.child.width / 2);
				children.push(sliderChildContainerVO);
				
				//children.push(slideSprite.getChildAt(i));
				//childMidLoc.push(children[children.length - 1].x + (children[children.length - 1].width / 2));
			}
			assetBounds = container.getBounds(container);
			
			
			TweenLite.delayedCall(1, OnResize);
			addResizeListener();
		}
		
		public function setPixelDimensions(_w:int, _h:int):void
		{
			setWidth(_w);
			setHeight(_h);
		}
		
		public function setWidth(value:int):void
		{
			scrollObject.scrollWidth = value;
		}
		
		public function setHeight(value:int):void
		{
			scrollObject.scrollHeight = value;
		}
		
		override protected function OnResize():void 
		{
			var w:int = (model.viewportModel.width / model.viewportModel.stageScale()) - ((assetBounds.x * 2) + assetBounds.width);
			var h:int = (model.viewportModel.height / model.viewportModel.stageScale()) - ((assetBounds.y * 2) + assetBounds.height);
			
			setPixelDimensions(w, h);
			
			//hitArea.init(-w, -h);
			
			model.language.updateSignal.add(OnLanguageChange);
			OnLanguageChange();
		}
		
		private function OnLanguageChange():void 
		{
			if (this.languageIndex == model.language.languageIndex) {
				if (config.horizontalScroll){
					if (assetBounds.width > core.model.viewportModel.width) {
						scrollObject.fractionLagXChanged.add(OnScrollX);
						OnScrollX(0);
					}
					else scrollObject.fractionLagXChanged.remove(OnScrollX);
				}
				if (config.verticalScroll){
					if (assetBounds.height > core.model.viewportModel.height) {
						scrollObject.fractionLagYChanged.add(OnScrollY);
						OnScrollY(0);
					}
					else scrollObject.fractionLagYChanged.remove(OnScrollY);
				}

			}
			else {
				scrollObject.fractionLagXChanged.remove(OnScrollX);
				scrollObject.fractionLagYChanged.remove(OnScrollY);
			}
		}
		
		private function OnScrollX(scrollX:Number):void 
		{
			if (languageIndex == -1 || languageIndex == 0) container.x = Math.round(scrollObject.fractionLagX * scrollObject.scrollWidth);
			else container.x = scrollObject.scrollWidth - Math.round(scrollObject.fractionLagX * scrollObject.scrollWidth);
			setChildVisibilityX();
		}
		
		private function OnScrollY(scrollY:Number):void 
		{
			container.y = Math.round(scrollObject.fractionLagY * scrollObject.scrollHeight);
			setChildVisibilityY();
		}
		
		private var difference:int;
		private var direction:int;
		
		private function setChildVisibilityX():void 
		{
			scrollLoc.x = (model.viewportModel.width / 2) - container.x;
			
			for (var i:int = 0; i < children.length; ++i) {
				//difference = Math.abs(childMidLoc[i] - scrollLoc.x);
				difference = Math.abs(children[i].middleLoc.x - scrollLoc.x);
				direction = SlideContainer.DIRECTION_LEFT;
				if (children[i].middleLoc.x - scrollLoc.x > 0) direction = SlideContainer.DIRECTION_RIGHT;
				
				if (children[i].type == SliderChildContainerVO.TYPE_TLF) {
					if (StarlingTLF(children[i].child).initiated) {
						CheckPosition(children[i].child);
					}
				}
				else if (children[i].type == SliderChildContainerVO.TYPE_PRIMORDIAL) {
					CheckPosition(children[i].child);
				}
				else if (children[i].type == SliderChildContainerVO.TYPE_BASE_SLIDE_ANIMATION) {
					CheckSlideAnimation(children[i].child);
				}
				
			}
			
			function CheckPosition(child:PrimordialStarlingSprite):void
			{
				if (difference > 1150) {
					if (child is PrimordialStarlingSprite) PrimordialStarlingSprite(child).Hide();
					else if (child.alpha == 1) TweenLite.to(child, 0.5, { alpha:0, delay:0 } );
				}
				else {
					if (child is PrimordialStarlingSprite) PrimordialStarlingSprite(child).Show();
					else if (child.alpha == 0) TweenLite.to(child, 0.5, { alpha:1, delay:0 } );
				}
			}
			
			function CheckSlideAnimation(child:BaseSlideAnimation):void 
			{
				if (difference > 1150) {
					if (child.showing) child.Hide();
				}
				else {
					if (!child.showing) {
						child.direction = direction;
						child.Show();
					}
				}
			}
		}
		
		private function setChildVisibilityY():void 
		{
			
		}
		
		override public function Show():void
		{
			super.Show();
			TweenLite.killDelayedCallsTo(super.Hide);
		}
		
		override public function Hide():void 
		{
			TweenLite.delayedCall(1, super.Hide);
			if (scrollObject) {
				if (linkToScene && this.sceneIndex != model.scene.currentScene) {
					TweenLite.killTweensOf(scrollObject);
					TweenLite.to(scrollObject, 1.5, { fractionX:0, fractionX:0, delay:1 } );
				}
			}
		}
	}
}