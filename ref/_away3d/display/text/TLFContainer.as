package imag.masdar.core.view.away3d.display.text 
{
	import away3d.entities.Mesh;
	import away3d.materials.TextureMaterial;
	import away3d.primitives.PlaneGeometry;
	import away3d.textures.BitmapTexture;
	import away3d.textures.Texture2DBase;
	import flash.events.Event;
	import imag.masdar.core.model.texturePacker.PackerObject;
	import imag.masdar.core.utils.away.GeoDepth;
	import imag.masdar.core.utils.away.PlaneGeoUVUpdater;
	import imag.masdar.core.utils.bitmap.BitmapUtils;
	import imag.masdar.core.view.away3d.display.away2d.Image;
	import imag.masdar.core.view.away3d.display.base.BaseAwayObject;
	import com.greensock.TweenLite;
	import flashx.textLayout.formats.TextAlign;
	import flashx.textLayout.formats.VerticalAlign;
	import imag.masdar.core.model.texturePacker.TextureSheet;
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
	
	/**
	 * ...
	 * @author Pete Shand
	 */
	public class TLFContainer extends BaseAwayObject implements IDisplayTLF 
	{
		//private var randomID:String;
		private var contentID:String;
		private var language:int;
		
		public var tlfWrapper:TLFWrapper;
		
		//private var mBorder:DisplayObjectContainer;
		
		private var texture:BitmapTexture;
		public var material:TextureMaterial;
		public var mesh:Mesh;
		private var _initiated:Boolean = false;
		
		private var _boundsWidth:int = 0;
		private var _boundsHeight:int = 0;
		
		private var _flipValue:Number = 1;
		public var textAlign:String = 'start';
		
		private var _paddingTop:int = 0;
		private var _paddingBottom:int = 0;
		private var _paddingLeft:int = 0;
		private var _paddingRight:int = 0;
		
		public function get paddingTop():int 
		{
			return _paddingTop;
		}
		
		public function set paddingTop(value:int):void 
		{
			_paddingTop = value;
			if (tlfWrapper) tlfWrapper.paddingTop = value;
		}
		
		public function get paddingBottom():int 
		{
			return _paddingBottom;
		}
		
		public function set paddingBottom(value:int):void 
		{
			_paddingBottom = value;
			if (tlfWrapper) tlfWrapper.paddingBottom = value;
		}
		
		public function get paddingLeft():int 
		{
			return _paddingLeft;
		}
		
		public function set paddingLeft(value:int):void 
		{
			_paddingLeft = value;
			if (tlfWrapper) tlfWrapper.paddingLeft = value;
		}
		
		public function get paddingRight():int 
		{
			return _paddingRight;
		}
		
		public function set paddingRight(value:int):void 
		{
			_paddingRight = value;
			if (tlfWrapper) tlfWrapper.paddingRight = value;
		}
		
		/** Creates a TLFContainer from plain text. 
		 *  Optionally providing default formatting with TextLayoutFormat and composition
		 * width and height to limit active drawing area for rendering text 
		 * */
		public static function fromPlainText(text:String, _format:TextLayoutFormat = null, compositionWidth:Number = 2048, compositionHeight:Number = 2048, contentID:String="", language:int=0):TLFContainer
		{
			return fromFormat(text, TextConverter.PLAIN_TEXT_FORMAT, _format, compositionWidth, compositionHeight, contentID, language);
		}
		
		/** Creates a TLFContainer from a string of HTML text, limited by the HTML tags the TLF engine supports.
		 *  See the Text Layout Framework documentation for supported tags.
		 * 
		 *  Optionally providing default formatting with TextLayoutFormat and composition
		 * width and height to limit active drawing area for rendering text 
		 * */
		public static function fromHTML(htmlString:String, _format:TextLayoutFormat = null, compositionWidth:Number = 2048, compositionHeight:Number = 2048, contentID:String="", language:int=0):TLFContainer
		{
			return fromFormat(htmlString, TextConverter.TEXT_FIELD_HTML_FORMAT, _format, compositionWidth, compositionHeight, contentID, language);
		}
		
		/** Creates a TLFContainer from a string of text layout XML text, limited by the XML tags the TLF engine supports.
		 *  See the Text Layout Framework documentation for supported tags.
		 * 
		 *  Optionally providing default formatting with TextLayoutFormat and composition
		 * width and height to limit active drawing area for rendering text 
		 * */
		public static function fromTextLayout(layoutXMLString:String, _format:TextLayoutFormat = null, compositionWidth:Number = 2048, compositionHeight:Number = 2048, contentID:String="", language:int=0):TLFContainer
		{
			return fromFormat(layoutXMLString, TextConverter.TEXT_LAYOUT_FORMAT, _format, compositionWidth, compositionHeight, contentID, language);
		}
		
		private static function fromFormat(text:String, type:String, _format:TextLayoutFormat = null, compositionWidth:Number = 2048, compositionHeight:Number = 2048, contentID:String="", language:int=0):TLFContainer
		{
			var tlfContainer:TLFContainer = null;
			var textFlow:TextFlow = TextConverter.importToFlow(text ? text : "", type);
			if (textFlow)
				tlfContainer = new TLFContainer(textFlow, _format, compositionWidth, compositionHeight, contentID, language);
			
			return tlfContainer;
		}
		
		/**
		 * Basic constructor that takes an already constructed TLF TextFlow with optional
		 * default format and composition limits
		 * 
		 * See the static helper methods for quickly instantiating a TLFContainer from
		 * a simple plain text unformatted string, HTML or TLF text layout markup.
		 * */
		public function TLFContainer(textFlow:TextFlow, _format:TextLayoutFormat = null, compositionWidth:Number = 2048, compositionHeight:Number = 2048, contentID:String="", language:int=0)
		{
			super();
			
			this.language = language;
			this.contentID = contentID;
			
			if (this.contentID == "") {
				this.contentID = String(Math.floor(Math.random() * 1000000).toString(16));
			}
			
			tlfWrapper = new TLFWrapper(textFlow, _format, compositionWidth, compositionHeight);
			tlfWrapper.paddingTop = this.paddingTop;
			tlfWrapper.paddingBottom = this.paddingBottom;
			tlfWrapper.paddingLeft = this.paddingLeft;
			tlfWrapper.paddingRight = this.paddingRight;
			
			tlfWrapper.mRequiresRedraw = true;
			
			model.tick.render.add(OnTick);
		}
		
		private function OnTick(timeDelta:int):void 
		{
			if (tlfWrapper.mRequiresRedraw) redrawContents();
		}
		
		/** Disposes the underlying texture data. */
		public override function dispose():void
		{
			if (tlfWrapper) tlfWrapper.dispose();
			//if (mImage) mImage.texture.dispose();
			super.dispose();
		}
		
		public function renderTexture():void 
		{
			if (tlfWrapper.mRequiresRedraw) {
				redrawContents();
			}
		}
		
		/*public override function render(support:RenderSupport, parentAlpha:Number):void
		{
			if (tlfWrapper.mRequiresRedraw) redrawContents();
			super.render(support, parentAlpha);
		}*/
		
		private function redrawContents():void
		{
			if(createRenderedContents()){
				tlfWrapper.mRequiresRedraw = false;
			}
		}
		
		private function createRenderedContents():Boolean
		{
			var bitmapData:BitmapData = tlfWrapper.createRenderedBitmap();
			if (!bitmapData) return false;
			
			if (config.autoReloadContent || model.texturePacker.alreadyContains(textureID)) { // || !config.useSpriteSheetGeneration
				
				if (texture) {
					texture.dispose();
					texture = null;
				}
				var bmd:BitmapData = BitmapUtils.nextPowerOf2(bitmapData);
				
				
				texture = new BitmapTexture(bmd, false);
				bmd = null;
				if (material) {
					material.texture = texture;
				}
				else {
					material = new TextureMaterial(texture, true, false, false);
					material.alphaBlending = true;
					material.alpha = this.alpha;
				}
				if (mesh) {
					mesh.material = material;
					mesh.geometry.dispose();
					mesh.geometry = null;
					mesh.geometry = new PlaneGeometry(bitmapData.width / config.spriteSheetTextureScale, bitmapData.height / config.spriteSheetTextureScale, 1, 1, false);
				}
				else {
					createMesh(new PlaneGeometry(bitmapData.width, bitmapData.height, 1, 1, false));
				}
				
				bitmapData.dispose();
				bitmapData = null;
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
			/*if (mImage) {
				mImage.scaleX = _flipValue;
				updateAlignmentH();
			}*/
		}
		private function OnTexturesReady():void 
		{
			var textureSheet:TextureSheet = model.texturePacker.getTextureSheet(textureID);
			if (textureSheet){
				var packerObject:PackerObject = textureSheet.packerObjectsByID(textureID);
				createImage(packerObject);
			}
		}
		
		private function createImage(packerObject:PackerObject):void
		{
			var texture:Texture2DBase = packerObject.awayTexture;
			material = new TextureMaterial(texture, true, false, false);
			material.alphaBlending = true;
			material.alpha = this.alpha;
			var geo:PlaneGeometry = new PlaneGeometry(packerObject.placement.width / config.spriteSheetTextureScale, packerObject.placement.height / config.spriteSheetTextureScale, 1, 1, false, true);
			
			var placement:Rectangle = packerObject.placement.clone();
			placement.x /= packerObject.textureScale;
			placement.y /= packerObject.textureScale;
			placement.width /= packerObject.textureScale;
			placement.height /= packerObject.textureScale;
			
			PlaneGeoUVUpdater.update(geo, placement, texture.width / packerObject.textureScale, texture.height / packerObject.textureScale);
			
			createMesh(geo);
		}
		
		private function createMesh(geo:PlaneGeometry):void
		{
			if (mesh) {
				if (mesh.parent) mesh.parent.removeChild(mesh);
				mesh.dispose();
				mesh = null;
			}
			mesh = new Mesh(geo, material);
			addChild(mesh);
			
			mesh.x = (geo.width / 2);
			if (textAlign == 'center') mesh.x += (boundsWidth - geo.width) / 2;
			else if (textAlign == 'end') mesh.x += boundsWidth - geo.width;
			
			mesh.y = -geo.height / 2;
			mesh.z = -0.1;
			
			dispatchEvent(new Event(Event.CHANGE, true));
		}
		
		public function updateAlignmentH():void
		{
			
		}
		
		public function updateAlignmentV():void
		{
			
		}
		
		
		private function updateBorder():void
		{
			
		}
		
		override public function get width():Number {return tlfWrapper.width;}
		override public function set width(value:Number):void
		{
			if (String(value) == 'NaN') return;
			tlfWrapper.width = value;
		}
		
		override public function get height():Number {return tlfWrapper.height;}
		override public function set height(value:Number):void
		{
			if (String(value) == 'NaN') return;
			tlfWrapper.height = value;
		}
		
		public function set text(value:String):void
		{ tlfWrapper.text = value; }
		
		public function get text():String
		{ return tlfWrapper.text; }
		
		public function set html(value:String):void
		{ tlfWrapper.html = value; 	}
		
		public function get html():String
		{ return tlfWrapper.html; }
		
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
		
		override public function set alpha(value:Number):void 
		{
			super.alpha = value;
			if (material) material.alpha = this.alpha;
		}
		
		private function get textureID():String
		{
			return contentID + "_L" + language;
		}
		
		public function get blur():Number 
		{
			return tlfWrapper.blur;
		}
		
		public function set blur(value:Number):void 
		{
			tlfWrapper.blur = value;
		}
	}
}