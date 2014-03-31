package imag.masdar.core.view.away3d.display.slider 
{
	import away3d.containers.ObjectContainer3D;
	import away3d.core.base.Geometry;
	import away3d.entities.Mesh;
	import away3d.events.Scene3DEvent;
	import away3d.primitives.PlaneGeometry;
	import away3d.textures.BitmapTexture;
	import com.greensock.TweenLite;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import imag.masdar.core.model.assetPool.AssetContainerObject;
	import imag.masdar.core.model.scroll.ScrollObject;
	import imag.masdar.core.utils.layout.Alignment;
	import imag.masdar.core.view.away3d.display.base.BaseAwayObject;
	import org.osflash.signals.Signal;
	
	/**
	 * ...
	 * @author Pete Shand
	 */
	public class SlideContainer extends BaseAwayObject 
	{
		private var containerParent:ObjectContainer3D;
		private var scaleContainer:BaseAwayObject;
		public var container:BaseAwayObject;
		private var scrollLoc:Point = new Point();
		private var numSliderChildren:int = 0;
		private var children:Vector.<BaseAwayObject> = new Vector.<BaseAwayObject>();
		
		private static var DIRECTION_LEFT:int = -1;
		private static var DIRECTION_RIGHT:int = 1;
		
		private var assetContainerObject:AssetContainerObject;
		private var scrollObject:ScrollObject;
		public var assetContainer:ObjectContainer3D;
		private var assetBounds:Rectangle = new Rectangle();
		public var visChange:Signal = new Signal();
		
		public function SlideContainer(sceneIndex:int, languageIndex:int, assetContainerObject:AssetContainerObject, containerParent:ObjectContainer3D) 
		{
			scrollObject = model.contentScrollValue.scrollObject(sceneIndex);
			
			this.containerParent = containerParent;
			this.sceneIndex = sceneIndex;
			this.languageIndex = languageIndex;
			this.assetContainerObject = assetContainerObject;
			
			scaleContainer = new BaseAwayObject();
			addChildAtAlignment(scaleContainer, Alignment.TOP_LEFT);
			
			container = new BaseAwayObject();
			scaleContainer.addChild(container);
			
			assetContainer = new ObjectContainer3D();
		}
		
		override protected function OnAdd(e:Scene3DEvent):void 
		{
			super.OnAdd(e);
			
			for (var i:int = 0; i < assetContainerObject.assetObjects.length; ++i) 
			{	
				assetContainerObject.assetObjects[i].addAwayObjectToContainer(assetContainer, languageIndex);
			}
			assetBounds = assetContainerObject.bounds;
			
			OnResize();
			
			addSlideContent(assetContainer);
			addScrollListers();
		}
		
		private function addScrollListers():void
		{
			if (config.horizontalScroll) {
				scrollObject.fractionLagXChanged.add(OnScrollX);
				OnScrollX(0);
			}
			if (config.verticalScroll){
				scrollObject.fractionLagYChanged.add(OnScrollY);
				OnScrollY(0);
			}
		}
		
		public function addSlideContent(slideContainer:ObjectContainer3D):void
		{
			container.addChild(slideContainer);
			numSliderChildren += slideContainer.numChildren;
			
			for (var i:int = 0; i < numSliderChildren; ++i) {
				var awayObject:BaseAwayObject = BaseAwayObject(slideContainer.getChildAt(i));
				awayObject.languageIndex = this.languageIndex;
				awayObject.sceneIndex = this.sceneIndex;
				children.push(awayObject);
			}
			
			TweenLite.delayedCall(1, function ():void { core.stage.dispatchEvent(new Event(Event.RESIZE));  }, null, true );
			addResizeListener();
		}
		
		override protected function OnResize():void
		{
			var w:int = (model.viewportModel.width / model.viewportModel.stageScale()) - ((assetBounds.x * 2) + assetBounds.width);
			var h:int = (model.viewportModel.height / model.viewportModel.stageScale()) - ((assetBounds.y * 2) + assetBounds.height);
			setPixelDimensions(w, h);
			
			scaleContainer.scaleX = scaleContainer.scaleY = model.viewportModel.stageScale();
		}
		
		private function setPixelDimensions(w:int, h:int):void 
		{
			scrollObject.scrollWidth = w;
			scrollObject.scrollHeight = h;
		}
		
		private function OnScrollX(scrollX:Number):void 
		{
			if (isNaN(scrollX)) return;
			if (languageIndex == -1 || languageIndex == 0) container.x = Math.round(scrollObject.fractionLagX * scrollObject.scrollWidth);
			else container.x = scrollObject.scrollWidth - Math.round(scrollObject.fractionLagX * scrollObject.scrollWidth);
			if (this.sceneIndex == model.scene.currentScene && this.languageIndex == model.language.languageIndex) setChildVisibilityX();
		}
		
		private function OnScrollY(scrollY:Number):void 
		{
			if (isNaN(scrollY)) return;
			container.y = Math.round(scrollObject.fractionLagY * scrollObject.scrollHeight);
			if (this.sceneIndex == model.scene.currentScene && this.languageIndex == model.language.languageIndex) setChildVisibilityY();
		}
		
		private var difference:int;
		private var direction:int;
		
		private function setChildVisibilityX():void 
		{
			scrollLoc.x = (1920 / 2) - container.x;
			for (var i:int = 0; i < numSliderChildren; ++i) {
				var awayObject:BaseAwayObject = children[i];
				
				direction = SlideContainer.DIRECTION_LEFT;
				if (awayObject.x - scrollLoc.x > 0) direction = SlideContainer.DIRECTION_RIGHT;
				
				var awayObjectWidth:Number = awayObject.width// * model.viewportModel.stageScale;
				
				if (direction == SlideContainer.DIRECTION_RIGHT){
					difference = Math.abs(awayObject.x - (awayObjectWidth / 2) - scrollLoc.x);
				}
				else {
					difference = Math.abs(awayObject.x + (awayObjectWidth / 2) - scrollLoc.x);
				}
				
				
				if (Math.abs(difference) > ((core.model.viewportModel.width + awayObjectWidth) / 2) + config.scrollContainerShowHideOffset + awayObject.scrollHideOffset) {
					awayObject.Hide();
				}
				else if (Math.abs(difference) < ((core.model.viewportModel.width + awayObjectWidth) / 2) + config.scrollContainerShowHideOffset + awayObject.scrollShowOffset) {
					awayObject.Show();
				}
			}
		}
		
		private function setChildVisibilityY():void 
		{
			
		}
		
		override public function Show():void
		{
			if (showing) return;
			showing = true;
			this.visible = true;
			TweenLite.killDelayedCallsTo(OnHideComplete);
			if (this.parent == null) {
				containerParent.addChild(this);
				visChange.dispatch();
			}
		}
		
		override public function Hide():void
		{
			if (!showing) return;
			showing = false;
			TweenLite.delayedCall(1, OnHideComplete);
		}
		
		override protected function OnHideComplete():void 
		{
			this.visible = false;
			if (this.parent == containerParent) {
				containerParent.removeChild(this);
				visChange.dispatch();
			}
		}
		
		private function removeScroll():void 
		{
			scrollObject.fractionLagXChanged.remove(OnScrollX);
			scrollObject.fractionLagYChanged.remove(OnScrollY);
		}
	}
}