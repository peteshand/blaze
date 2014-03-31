package imag.masdar.core.view.starling.display.animations 
{
	import com.greensock.TweenLite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	import imag.masdar.core.model.texturePacker.AtlasImage;
	import imag.masdar.core.utils.bitmap.BitmapUtils;
	import imag.masdar.core.view.starling.display.base.BaseStarlingObject;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.textures.Texture;
	import starling.display.Sprite;
	
	/**
	 * ...
	 * @author Pete Shand
	 */
	public class GridAnimation extends BaseSlideAnimation 
	{
		private var atlasImages:Vector.<AtlasImage> = new Vector.<AtlasImage>();
		
		private var fadeTime:Number = 0.25;
		
		private var tileContainer:Sprite;
		private var standardAtlasImages:AtlasImage;
		
		private var tilesX:int;
		private var tilesY:int;
		private var delayTime:Number;
		
		private var tileSize:int = 32; // higher number will result in better performance
		private var simpleFadeOut:Boolean = true;
		private var randomFade:int = 5;
		private var fadeInterval:Number = 0.12;
		
		public function GridAnimation(displayObject:DisplayObject) 
		{
			this.x = Math.round(displayObject.x);
			this.y = Math.round(displayObject.y);
			this.touchable = false;
			
			tileContainer = new Sprite();
			
			name = displayObject.name;
			
			standardAtlasImages = new AtlasImage(displayObject);
			
			model.texturePacker.ready.addOnce(OnTexturesReady);
			
			tilesX = Math.ceil(displayObject.width / tileSize);
			tilesY = Math.ceil(displayObject.height / tileSize);
			
			for (var i:int = 0; i < tilesX; ++i) {
				for (var j:int = 0; j < tilesY; ++j) {
					var atlasImage:AtlasImage = new AtlasImage(null);
					atlasImage.initTile(displayObject, i * tileSize, j * tileSize, tileSize);
					atlasImages.push(atlasImage);
					atlasImages[atlasImages.length - 1].fadeDelay = (i + j + (Math.random() * randomFade)) * fadeInterval * (tileSize / 64) * fadeTime;
				}
			}
			this.visible = false;
		}
		
		private function OnTexturesReady():void 
		{
			for (var m:int = 0; m < atlasImages.length; ++m) {
				atlasImages[m].init();
				tileContainer.addChild(atlasImages[m]);
			}
			standardAtlasImages.init();
			standardAtlasImages.x = 0;
			standardAtlasImages.y = 0;
			addChild(standardAtlasImages);
		}
		
		override public function Show():void
		{
			showing = true;
			this.visible = true;
			this.alpha = 1;
			
			removeChild(standardAtlasImages);
			addChild(tileContainer);
			
			for (var m:int = 0; m < atlasImages.length; ++m) {
				var i:int = m;
				if (model.contentScrollValue.directionX == 1) i = atlasImages.length - 1 - m;
				atlasImages[i].FadeShow(fadeTime, atlasImages[m].fadeDelay);
				
				/*var tween:Tween = new Tween(atlasImages[i], fadeTime);
				tween.animate("alpha", 1);
				tween.delay = atlasImages[m].fadeDelay;
				Starling.juggler.add(tween);*/
			}
			TweenLite.killDelayedCallsTo(ShowTweenComplete);
			TweenLite.killDelayedCallsTo(HideTweenComplete);
			
			
			delayTime = (tilesX + tilesY + randomFade) * fadeInterval * (tileSize / 64) * fadeTime;
			TweenLite.delayedCall(delayTime, ShowTweenComplete);
		}
		
		private function ShowTweenComplete():void 
		{
			removeChild(tileContainer);
			addChild(standardAtlasImages);
			
			RemoveImages();
		}
		
		override public function Hide():void
		{
			showing = false;
			TweenLite.killDelayedCallsTo(ShowTweenComplete);
			
			if (simpleFadeOut) TweenLite.to(this, fadeTime, { alpha:0, delay:0, onComplete:OnHideComplete1 } );
			else {
				removeChild(standardAtlasImages);
				addChild(tileContainer);
				
				showing = false;
				
				for (var m:int = 0; m < atlasImages.length; ++m) {
					var i:int = m;
					if (model.contentScrollValue.directionX == 1) i = atlasImages.length - 1 - m;
					atlasImages[i].FadeHide(fadeTime, atlasImages[m].fadeDelay);
					
					/*var tween:Tween = new Tween(atlasImages[i], fadeTime);
					tween.animate("alpha", 0);
					tween.delay = atlasImages[m].fadeDelay;
					Starling.juggler.add(tween);*/
				}
				
				TweenLite.killDelayedCallsTo(HideTweenComplete);
				delayTime = (tilesX + tilesY + randomFade) * fadeInterval * (tileSize / 64) * fadeTime;
				TweenLite.delayedCall(delayTime, HideTweenComplete);
			}
		}
		
		private function OnHideComplete1():void 
		{
			this.visible = false;
		}
		
		private function HideTweenComplete():void 
		{
			removeChild(tileContainer);
			RemoveImages();
			
			this.visible = false;
		}
		
		private function RemoveImages():void
		{
			for (var m:int = 0; m < atlasImages.length; ++m) {
				atlasImages[m].RemoveImage();
			}
		}
		
	}
}