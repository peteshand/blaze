package imag.masdar.core.view.starling.display.shell.slidebar_old 
{
	import com.greensock.easing.Strong;
	import com.imagination.ge.core.model.ScrollingModel;
	import com.imagination.ge.core.ui.view.baseClasses.StarlingSpriteBase;
	import com.imagination.ge.core.view.starling.language.LanguageSprite;
	import flash.geom.Point;
	import starling.display.Shape;
	
	import flash.display.MovieClip;
	
	import starling.display.Image;
	import starling.display.Sprite;
	
	/**
	 * ...
	 * @author Pete Shand
	 */
	public class ScrollingPanel extends StarlingSpriteBase 
	{
		private var baseMovieClip:MovieClip;
		private var scrollContainer:Sprite;
		private var scrollingModel:ScrollingModel = ScrollingModel.getInstance();
		public var languageSprites:Vector.<LanguageSprite> = new Vector.<LanguageSprite>();
		public var scrollController:ScrollController;
		private var parallax:Boolean;
		private var parallaxOffset:int;
		private var _active:Boolean = true;
		
		public function ScrollingPanel(_baseMovieClip:MovieClip, _parallax:Boolean=false, _parallaxOffset:int=0, xDrag:Boolean=true, yDrag:Boolean=false) 
		{
			baseMovieClip = _baseMovieClip;
			parallax = _parallax;
			parallaxOffset = _parallaxOffset;
			
			scrollContainer = new Sprite();
			addChild(scrollContainer);
			
			for (var i:int = 0; i < baseMovieClip.numChildren; i++) 
			{
				var childMc:MovieClip = MovieClip(baseMovieClip.getChildAt(i));
				var languageSprite:LanguageSprite = new LanguageSprite(childMc);
				if (childMc.alpha == 1) languageSprite.fadeBoth = false;
				
				if (parallax){
					languageSprite.offsetValue = (childMc.y / 100);
					languageSprite.x = languageSprite.startLoc.x = (childMc.x * (1 + languageSprite.offsetValue));
					languageSprite.z = childMc.y;
				}
				else {
					languageSprite.x = languageSprite.startLoc.x = childMc.x;
					languageSprite.y = languageSprite.startLoc.y = childMc.y;
					languageSprite.z = 0;
				}
				//languageSprite.arabicContainer.x = -languageSprite.x * 2;
				//languageSprite.arabicContainer.pivotX = languageSprite.arabicContainer.width;
				
				scrollContainer.addChild(languageSprite);
				languageSprites.push(languageSprite);
			}
			
			var numOfBgPanels:int = Math.ceil(scrollContainer.width / 2048);
			for (i = 0; i < numOfBgPanels; ++i) {
				
				var bgShape:Shape = new Shape();
				scrollContainer.addChildAt(bgShape, 0);
				bgShape.graphics.beginFill(0xFF0000, 0);
				if (i == numOfBgPanels - 1) bgShape.graphics.drawRect(i * 2048, 40, scrollContainer.width - (2048 * (numOfBgPanels-1)), 1024);
				else bgShape.graphics.drawRect(i * 2048, 40, 2048, 1024);
			}

			if (xDrag) quickSortOn(languageSprites, "x", 0, languageSprites.length - 1);
			if (yDrag) quickSortOn(languageSprites, "y", 0, languageSprites.length - 1);
			
			scrollController = new ScrollController(scrollContainer, true, parallax, parallaxOffset, xDrag, yDrag);
			scrollController.mutli.x = 2.5;
			
			updateWidth()
		}
		public function updateWidth():void
		{
			scrollingModel.boundMin.x = 0 - (scrollContainer.width - 1920 + 300);
			scrollingModel.boundMax.x = 0;
			scrollingModel.boundMin.y = 0 - (scrollContainer.height - 1080);
			scrollingModel.boundMax.y = 0;
		}
		
		public function setLanguage(index:int):void
		{
			for (var i:int = 0; i < languageSprites.length; i++) 
			{
				if (index == 0) {
					//this.x = 0;
					//languageSprites[i].pivotX = 0;
					//languageSprites[i].x = 1000;
				}
				else {
					//trace(this.width);
					//this.x = 20000;
					
					//languageSprites[i].x = 500;
					
				}
				languageSprites[i].setLanguage(index);
			}
		}
		public function setPanelIndex(index:int):void
		{
			scrollingModel.tweenToPosition(-languageSprites[index].startLoc.x, 0, 2, Strong.easeInOut);
		}
		public function get sprites():Vector.<LanguageSprite>
		{
			return languageSprites;
		}
		
		public function get active():Boolean 
		{
			return _active;
		}
		
		public function set active(value:Boolean):void 
		{
			_active = value;
			scrollController.active = active;
		}
		
		private function quickSortOn(a:Vector.<LanguageSprite>, prop:String, left:int, right:int):void {
			var i:int = 0, j:int = 0, pivot:LanguageSprite, tmp:LanguageSprite;
			i=left;
			j=right;
			pivot = a[Math.round((left+right)*.5)];
			while (i<=j) {
				while (a[i][prop]<pivot[prop]) i++;
				while (a[j][prop]>pivot[prop]) j--;
				if (i<=j) {
					tmp=a[i];
					a[i]=a[j];
					i++;
					a[j]=tmp;
					j--;
				}
			}
			if (left<j)  quickSortOn(a, prop, left, j);
			if (i<right) quickSortOn(a, prop, i, right);
		}
	}

}
