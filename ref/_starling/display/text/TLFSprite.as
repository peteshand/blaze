// =================================================================================================
//
//  based on starling.text.TextField
//  modified to use text layout framework engine for rendering text
//
// =================================================================================================

package imag.masdar.core.view.starling.display.text
{
	import com.greensock.TweenLite;
	import flashx.textLayout.formats.TextAlign;
	import flashx.textLayout.formats.VerticalAlign;
	import imag.masdar.core.model.texturePacker.TextureSheet;
	import imag.masdar.core.utils.starling.ImageUtils;
	import imag.masdar.core.utils.starling.TextureUtils;
	import imag.masdar.core.view.starling.display.base.BaseStarlingObject;
	import imag.masdar.core.view.tlf.BoundsContainer;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flashx.textLayout.formats.Direction;
	import imag.masdar.core.utils.layout.Alignment;
	import imag.masdar.core.view.tlf.IDisplayTLF;
	import imag.masdar.core.view.tlf.TLFWrapper;
	
	import flashx.textLayout.conversion.TextConverter;
	import flashx.textLayout.elements.TextFlow;
	import flashx.textLayout.factory.TextFlowTextLineFactory;
	import flashx.textLayout.factory.TruncationOptions;
	import flashx.textLayout.formats.ITextLayoutFormat;
	import flashx.textLayout.formats.TextLayoutFormat;
	
	import starling.core.RenderSupport;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;
	
	/** A TLFSprite displays text, using standard open type or true type fonts.
	 * 
	 * Rendering is done with a backing of the text layout framework engine as opposed
	 * to the classic flash.text.TextField as the standard starling.text.TextField employs.
	 * 
	 * If relying on embedded font use ensure TextLayoutFormat.fontLookup is set to FontLookup.EMBEDDED_CFF,
	 * this defaults to FontLookup.DEVICE, expecting device fonts.
	 * 
	 * Additionally, note that TLF expects embedded fonts with CFF, embedAsCFF="true" unlike
	 * classic TextField which uses embedded fonts with CFF disabled, embedAsCFF="false"
	 * 
	 * Download and find out more about the latest Text Layout Framework at
	 * <a href="http://sourceforge.net/adobe/tlf/home/Home/">Text Layout Framework</a>
	 */
	public class TLFSprite extends BaseStarlingObject implements IDisplayTLF
	{
		//private var randomID:String;
		private var contentID:String;
		private var language:int;
		
		public var tlfWrapper:TLFWrapper;
		
		private var mBorder:DisplayObjectContainer;
		
		private var mImage:Image;
		private var mSmoothing:String;
		private var _initiated:Boolean = false;
		
		private var _boundsWidth:int = 0;
		private var _boundsHeight:int = 0;
		
		private var _flipValue:Number = 1;
		
		/** Creates a TLFSprite from plain text. 
		 *  Optionally providing default formatting with TextLayoutFormat and composition
		 * width and height to limit active drawing area for rendering text 
		 * */
		public static function fromPlainText(text:String, _format:TextLayoutFormat = null, compositionWidth:Number = 2048, compositionHeight:Number = 2048, contentID:String = "", language:int=0):TLFSprite
		{
			return fromFormat(text, TextConverter.PLAIN_TEXT_FORMAT, _format, compositionWidth, compositionHeight, contentID, language);
		}
		
		/** Creates a TLFSprite from a string of HTML text, limited by the HTML tags the TLF engine supports.
		 *  See the Text Layout Framework documentation for supported tags.
		 * 
		 *  Optionally providing default formatting with TextLayoutFormat and composition
		 * width and height to limit active drawing area for rendering text 
		 * */
		public static function fromHTML(htmlString:String, _format:TextLayoutFormat = null, compositionWidth:Number = 2048, compositionHeight:Number = 2048, contentID:String = "", language:int=0):TLFSprite
		{
			return fromFormat(htmlString, TextConverter.TEXT_FIELD_HTML_FORMAT, _format, compositionWidth, compositionHeight, contentID, language);
		}
		
		/** Creates a TLFSprite from a string of text layout XML text, limited by the XML tags the TLF engine supports.
		 *  See the Text Layout Framework documentation for supported tags.
		 * 
		 *  Optionally providing default formatting with TextLayoutFormat and composition
		 * width and height to limit active drawing area for rendering text 
		 * */
		public static function fromTextLayout(layoutXMLString:String, _format:TextLayoutFormat = null, compositionWidth:Number = 2048, compositionHeight:Number = 2048, contentID:String = "", language:int=0):TLFSprite
		{
			return fromFormat(layoutXMLString, TextConverter.TEXT_LAYOUT_FORMAT, _format, compositionWidth, compositionHeight, contentID, language);
		}
		
		private static function fromFormat(text:String, type:String, _format:TextLayoutFormat = null, compositionWidth:Number = 2048, compositionHeight:Number = 2048, contentID:String = "", language:int=0):TLFSprite
		{
			var tlfSprite:TLFSprite = null;
			var textFlow:TextFlow = TextConverter.importToFlow(text ? text : "", type);
			if (textFlow)
				tlfSprite = new TLFSprite(textFlow, _format, compositionWidth, compositionHeight, contentID, language);
			
			return tlfSprite;
		}
		
		/**
		 * Basic constructor that takes an already constructed TLF TextFlow with optional
		 * default format and composition limits
		 * 
		 * See the static helper methods for quickly instantiating a TLFSprite from
		 * a simple plain text unformatted string, HTML or TLF text layout markup.
		 * */
		public function TLFSprite(textFlow:TextFlow, _format:TextLayoutFormat = null, compositionWidth:Number = 2048, compositionHeight:Number = 2048, contentID:String = "", language:int=0)
		{
			super();
			
			this.contentID = contentID;
			this.language = language;
			
			if (!contentID) contentID = "";
			
			tlfWrapper = new TLFWrapper(textFlow, _format, compositionWidth, compositionHeight);
			
			mSmoothing = TextureSmoothing.BILINEAR;
			
			addEventListener(Event.FLATTEN, onFlatten);
			tlfWrapper.mRequiresRedraw = true;
			
			control.flipControl.addFlipSubject(this, "flipValue");
		}
		
		/** Disposes the underlying texture data. */
		public override function dispose():void
		{
			removeEventListener(Event.FLATTEN, onFlatten);
			if (tlfWrapper) tlfWrapper.dispose();
			if (mImage) mImage.texture.dispose();
			super.dispose();
		}
		
		private function onFlatten(event:Event):void
		{
			if (tlfWrapper.mRequiresRedraw) redrawContents();
		}
		
		public function renderTexture():void 
		{
			if (tlfWrapper.mRequiresRedraw) {
				redrawContents();
			}
		}
		public override function render(support:RenderSupport, parentAlpha:Number):void
		{
			if (tlfWrapper.mRequiresRedraw) redrawContents();
			super.render(support, parentAlpha);
		}
		
		private function redrawContents():void
		{
			if(createRenderedContents()){
				tlfWrapper.mRequiresRedraw = false;
			}
		}
		
		private var standardTexture:Texture
		private function createRenderedContents():Boolean
		{
			var scale:Number = Starling.contentScaleFactor;
			
			var bitmapData:BitmapData = tlfWrapper.createRenderedBitmap(scale);
			if (!bitmapData) return false;
			
			if (contentID == "" || config.autoReloadContent || model.texturePacker.alreadyContains(textureID) || currentTexture || !config.useSpriteSheetGeneration) {
				if (standardTexture) standardTexture.dispose();
				standardTexture = Texture.fromBitmapData(bitmapData, false, false, scale);
				createImage(standardTexture);
			}
			else {
				model.texturePacker.ready.addOnce(OnTexturesReady);
				model.texturePacker.addBitmapData(bitmapData, textureID, 0x00010000);
			}
			return true;
		}
		
		
		public function get flipValue():Number {
			return _flipValue;
		}
		public function set flipValue(value:Number):void {
			value = value>0?1:-1;
			if (_flipValue == value) return;
			
			_flipValue = value;
			if (mImage) {
				mImage.scaleX = _flipValue;
				updateAlignmentH();
			}
		}
		
		private var currentTexture:Texture;
		private function OnTexturesReady():void 
		{
			var textureSheet:TextureSheet = model.texturePacker.getTextureSheet(textureID);
			currentTexture = textureSheet.getTexture(textureID);
			createImage(currentTexture);
		}
		
		private function createImage(texture:Texture):void
		{
			if (mImage == null) 
			{
				mImage = new Image(texture);
				mImage.touchable = false;
				mImage.smoothing = mSmoothing;
				mImage.scaleX = _flipValue;
				addChild(mImage);
				mImage.alpha = 0;
				TweenLite.to(mImage, 0.3, { alpha:1, delay:0 } );
			}
			else 
			{ 
				if (mImage.texture) mImage.texture.dispose();
				mImage.texture = texture; 
				mImage.readjustSize();
			}
			_initiated = true;
			
			updateBorder();
			
			//setImageBoundsWidth(boundsImage.width);
			//setImageBoundsHeight(boundsImage.height);
			
			updateAlignmentH();
			updateAlignmentV();
			
			
			
			dispatchEvent(new Event(Event.CHANGE, true));
		}
		
		public function updateAlignmentH():void
		{
			if (mImage) {
				/*var align:String = tlfWrapper.format.containerAlign;
				if (align == Alignment.TOP_LEFT || align == Alignment.LEFT || align == Alignment.BOTTOM_LEFT) {
					mImage.x = 0;
				}
				else if (align == Alignment.TOP_RIGHT || align == Alignment.RIGHT || align == Alignment.BOTTOM_RIGHT) {
					mImage.x = boundsWidth - textWidth;
				}
				else if (align == Alignment.TOP || align == Alignment.MIDDLE || align == Alignment.BOTTOM) {
					mImage.x = (boundsWidth - textWidth) / 2;
				}*/
				
				var align:String = tlfWrapper.format.textAlign;
				if (align == TextAlign.RIGHT || align == TextAlign.END) {
					mImage.x = boundsWidth - textWidth;
				}else if (align == TextAlign.CENTER || align == TextAlign.JUSTIFY) {
					mImage.x = (boundsWidth - textWidth) / 2;
				}else {
					mImage.x = 0;
				}
				mImage.x += (mImage.width - mImage.width * _flipValue) / 2;
			}
		}
		
		public function updateAlignmentV():void
		{
			if (mImage) {
				/*var align:String = tlfWrapper.format.containerAlign;
				if (align == Alignment.TOP_LEFT || align == Alignment.TOP || align == Alignment.TOP_RIGHT) {
					if (height != 0) mImage.y = 0;
				}
				if (align == Alignment.LEFT || align == Alignment.MIDDLE || align == Alignment.RIGHT) {
					if (height != 0) mImage.y = (boundsHeight - textHeight) / 2;
				}
				else if (align == Alignment.BOTTOM_LEFT || align == Alignment.BOTTOM || align == Alignment.BOTTOM_RIGHT) {
					if (height != 0) mImage.y = boundsHeight - textHeight;
				}*/
				
				var align:String = tlfWrapper.format.verticalAlign;
				if (align == VerticalAlign.BOTTOM) {
					mImage.y = boundsHeight - textHeight;
				}else if (align == VerticalAlign.MIDDLE) {
					mImage.y = (boundsHeight - textHeight) / 2;
				}else {
					mImage.y = 0;
				}
			}
		}
		
		
		private function updateBorder():void
		{
			if (mBorder == null || mImage == null) return;
			
			var width:Number  = mImage.width;
			var height:Number = mImage.height;
			
			var topLine:Quad    = mBorder.getChildAt(0) as Quad;
			var rightLine:Quad  = mBorder.getChildAt(1) as Quad;
			var bottomLine:Quad = mBorder.getChildAt(2) as Quad;
			var leftLine:Quad   = mBorder.getChildAt(3) as Quad;
			
			topLine.width    = width; topLine.height    = 1;
			bottomLine.width = width; bottomLine.height = 1;
			leftLine.width   = 1;     leftLine.height   = height;
			rightLine.width  = 1;     rightLine.height  = height;
			rightLine.x  = width  - 1;
			bottomLine.y = height - 1;
			topLine.color = rightLine.color = bottomLine.color = leftLine.color = tlfWrapper.format.color;
			
			if (tlfWrapper.format.direction == Direction.RTL) {
				mBorder.x = this.width - textWidth;
			}
		}
		
		/** @inheritDoc */
		public override function getBounds(targetSpace:starling.display.DisplayObject, resultRect:Rectangle=null):Rectangle
		{
			if (mImage) return mImage.getBounds(targetSpace, resultRect);
			else return new Rectangle();
		}
		
		
		
		override public function get width():Number {return tlfWrapper.width;}
		override public function set width(value:Number):void
		{
			if (String(value) == 'NaN') return;
			tlfWrapper.width = value;
			//setImageBoundsWidth(value);
		}
		
		override public function get height():Number {return tlfWrapper.height;}
		override public function set height(value:Number):void
		{
			if (String(value) == 'NaN') return;
			tlfWrapper.height = value;
			
			//setImageBoundsHeight(value);
		}
		
		/** Draws a border around the edges of the text field. Useful for visual debugging. 
		 *  @default false */
		public function get border():Boolean { return mBorder != null; }
		public function set border(value:Boolean):void
		{
			if (value && mBorder == null)
			{                
				mBorder = new Sprite();
				addChild(mBorder);
				
				for (var i:int=0; i<4; ++i)
					mBorder.addChild(new Quad(1.0, 1.0));
				
				updateBorder();
			}
			else if (!value && mBorder != null)
			{
				mBorder.removeFromParent(true);
				mBorder = null;
			}
		}
		
		/** The smoothing filter that is used for the image texture. 
		 *   @default bilinear
		 *   @see starling.textures.TextureSmoothing */ 
		public function get smoothing():String { return mSmoothing; }
		public function set smoothing(value:String):void 
		{
			if (TextureSmoothing.isValid(value)) {
				mSmoothing = value;
				if (mImage) mImage.smoothing = mSmoothing;
			}
			else
				throw new ArgumentError("Invalid smoothing mode: " + value);
		}
		
		
		
		public function set text(value:String):void
		{ tlfWrapper.text = value; }
		
		public function get text():String
		{ return tlfWrapper.text; }
		
		public function set html(value:String):void
		{ tlfWrapper.html = value; 	}
		
		public function set textLayout(value:String):void
		{ tlfWrapper.textLayout = value; }
		
		public function get textWidth():Number
		{ return tlfWrapper.textWidth; }
		
		public function get textHeight():Number
		{ return tlfWrapper.textHeight; }
		
		public function get truncationOptions():TruncationOptions {return tlfWrapper.truncationOptions;}
		public function set truncationOptions(value:TruncationOptions):void 
		{ tlfWrapper.truncationOptions = value; }
		
		public function getStyle(styleProp:String):*
		{ return tlfWrapper.getStyle(styleProp); }
		
		public function setStyle(styleProp:String,newValue:*):void
		{ tlfWrapper.setStyle(styleProp, newValue); }
		
		public function get styles():Object
		{ return tlfWrapper.styles;}
		
		public function get format():TextLayoutFormat 
		{ return tlfWrapper.format; }
		
		public function set format(value:TextLayoutFormat):void 
		{ tlfWrapper.format = value; }
		
		public function get autoSizeHeight():Boolean 
		{ return tlfWrapper.autoSizeHeight; }
		
		public function set autoSizeHeight(value:Boolean):void 
		{ tlfWrapper.autoSizeHeight = value; }
		
		public function set debug(value:Boolean):void 
		{
			tlfWrapper.debug = value;
			//if (value) boundsImage.visible = true;
			//else boundsImage.visible = false;
		}
		
		public function apply(incoming:ITextLayoutFormat):void
		{ tlfWrapper.apply(incoming); }
		
		public function concat(incoming:ITextLayoutFormat):void
		{ tlfWrapper.concat(incoming); }
		
		public function concatInheritOnly(incoming:ITextLayoutFormat):void
		{ tlfWrapper.concatInheritOnly(incoming); }
		
		public function copy(incoming:ITextLayoutFormat):void
		{ tlfWrapper.copy(incoming); }
		
		public function removeClashing(incoming:ITextLayoutFormat):void
		{ tlfWrapper.removeClashing(incoming); }
		
		public function removeMatching(incoming:ITextLayoutFormat):void
		{ tlfWrapper.removeMatching(incoming); }
		
		
		
		public function get initiated():Boolean 
		{
			return _initiated;
		}
		
		public function get boundsHeight():int 
		{
			return _boundsHeight;
		}
		
		public function set boundsHeight(value:int):void 
		{
			_boundsHeight = value;
		}
		
		public function get boundsWidth():int 
		{
			return _boundsWidth;
		}
		
		public function set boundsWidth(value:int):void 
		{
			_boundsWidth = value;
		}
		
		override public function Show():void 
		{
			this.visible = true;
			TweenLite.to(this, 0.5, { alpha:1, delay:config.tranitions.showDelay } );
		}
		
		override public function Hide():void 
		{
			TweenLite.to(this, 0.5, { alpha:0, delay:config.tranitions.hideDelay, onComplete:OnFadeOutComplete } );
		}
		
		private function OnFadeOutComplete():void 
		{
			this.visible = false;
		}
		
		private function get textureID():String
		{
			return contentID + "_L" + language;
		}
	}
}