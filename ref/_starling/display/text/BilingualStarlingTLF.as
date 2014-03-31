package imag.masdar.core.view.starling.display.text 
{
	import com.greensock.TweenLite;
	import fl.text.TLFTextField;
	import flash.text.TextFormat;
	import flashx.textLayout.formats.BlockProgression;
	import flashx.textLayout.formats.Direction;
	import flashx.textLayout.formats.ITextLayoutFormat;
	import flashx.textLayout.formats.TextLayoutFormat;
	import imag.masdar.core.model.content.ContentObject;
	import imag.masdar.core.model.style.StyleApplier;
	import imag.masdar.core.model.style.StyleObject;
	import imag.masdar.core.utils.layout.Alignment;
	import imag.masdar.core.view.starling.display.base.BaseStarlingObject;
	import imag.masdar.core.view.tlf.BilingualBoundsContainer;
	import starling.display.Image;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.utils.Color;
	
	/**
	 * ...
	 * @author Pete Shand
	 */
	public class BilingualStarlingTLF extends BaseStarlingObject
	{
		private var englishTLF:TLFSprite;
		private var arabicTLF:TLFSprite;
		private var activeTLF:TLFSprite;
		private var boundsContainer:BilingualBoundsContainer;
		
		//private var _format:MultilingualFormat;
		
		private var _autoSizeHeight:Boolean = false;
		
		private var _fontSize:int = 11;
		private var _colour:uint = 0x00000000;
		
		private var _text:String = "";
		private var _debug:Boolean = false;
		private var _contentID:String = "";
		private var _styleID:String;
		
		private var contentObject:ContentObject;
		private var pivotPercentageX:Number = -1;
		private var pivotPercentageY:Number = -1;
		
		/*private var englishStyleObject:StyleObject;
		private var arabicStyleObject:StyleObject;*/
		
		private var englishStyleApp:StyleApplier;
		private var arabicStyleApp:StyleApplier;
		private var _manualStyle:StyleObject;
		private var _name:String;
		
		public var autoUpdateContent:Boolean = true;
		public var autoUpdateStyle:Boolean = true;
		
		/*private var _flaTLF:TLFTextField;
		private var _flaTextLayoutFormat:TextLayoutFormat;*/
		
		public function BilingualStarlingTLF()
		{
			
		}
		
		public function init(name:String, textEnglish:String = "", textArabic:String = "", containerWidth:int = 128, containerHeight:int = 0):void
		{
			_name = name;
			_contentID = name;
			
			if (containerHeight == 0) autoSizeHeight = true;
			generateTF(textEnglish, textArabic, containerWidth, containerHeight);
			
			model.language.updateSignal.add(OnLanguageChange);
			OnLanguageChange();
		}
		
		private function OnLanguageChange():void 
		{
			if (model.language.languageIndex == 0) {
				activeTLF = englishTLF;
				englishTLF.Show();
				arabicTLF.Hide();
			}
			else {
				activeTLF = arabicTLF;
				englishTLF.Hide();
				arabicTLF.Show();
			}
		}
		
		private function generateTF(textEnglish:String, textArabic:String, containerWidth:int, containerHeight:int):void 
		{
			clearTF();
			
			//createFormat();
			
			boundsContainer = new BilingualBoundsContainer(containerWidth, containerHeight);
			
			createArabicTLF(textArabic, containerWidth, containerHeight);
			createEnglishTLF(textEnglish, containerWidth, containerHeight);
			activeTLF = englishTLF;
			
			englishTLF.addEventListener(Event.CHANGE, OnTFLChange);
			arabicTLF.addEventListener(Event.CHANGE, OnTFLChange);
			
			boundsContainer.init(englishTLF, arabicTLF);
			addChildAt(boundsContainer, 0);
			
			debug = _debug;
		}
		
		private function OnTFLChange(e:Event):void 
		{
			updatePivotPercentage();
			dispatchEvent(new Event(Event.CHANGE, true));
		}
		
		private function updatePivotPercentage():void 
		{
			if (pivotPercentageX != -1 || pivotPercentageY != -1) {
				this.pivotX = boundsContainer.width * pivotPercentageX;
				this.pivotY = boundsContainer.height * pivotPercentageY;
			}
		}
		
		/*private function createFormat():void 
		{
			format = new MultilingualFormat();
		}*/
		
		private function createEnglishTLF(textEnglish:String, containerWidth:int, containerHeight:int):void
		{
			englishTLF = TLFSprite.fromHTML(textEnglish, new TextLayoutFormat(), containerWidth, containerHeight, _contentID, 0);
			englishTLF.name = _name;
			addChild(englishTLF);
			
			englishStyleApp = new StyleApplier();
			englishStyleApp.addDestinationObj(englishTLF.format);
		}
		
		private function createArabicTLF(textArabic:String, containerWidth:int, containerHeight:int):void 
		{
			arabicTLF = TLFSprite.fromHTML(textArabic, new TextLayoutFormat(), containerWidth, containerHeight, _contentID, 1);
			arabicTLF.name = _name;
			addChild(arabicTLF);
			
			arabicStyleApp = new StyleApplier();
			arabicStyleApp.addDestinationObj(arabicTLF.format);
		}
		
		
		
		private function clearTF():void 
		{
			if (englishTLF) {
				removeChild(englishTLF);
				englishTLF.dispose();
				englishTLF = null;
				
				englishStyleApp.dispose();
				englishStyleApp = null;
			}
			if (arabicTLF) {
				removeChild(arabicTLF);
				arabicTLF.dispose();
				arabicTLF = null;
				
				arabicStyleApp.dispose();
				arabicStyleApp = null;
			}
			/*if (format) {
				format.dispose();
				format = null;
			}*/
		}
		
		/*public function get englishFormat():EnglishFormat 
		{
			return format.english;
		}
		
		public function set englishFormat(value:EnglishFormat):void 
		{
			format.english = value;
		}
		
		public function get arabicFormat():ArabicFormat 
		{
			return format.arabic;
		}
		
		public function set arabicFormat(value:ArabicFormat):void 
		{
			format.arabic = value;
		}*/
		
		override public function get width():Number 
		{
			return boundsContainer.width;
		}
		
		override public function set width(value:Number):void 
		{
			boundsContainer.width = value;
		}
		
		override public function get height():Number 
		{
			return boundsContainer.height;
		}
		
		override public function set height(value:Number):void 
		{
			boundsContainer.height = value;
			autoSizeHeight = false;
		}
		
		/*public function get fontSize():int 
		{
			return _fontSize;
		}
		
		public function set fontSize(value:int):void 
		{
			_fontSize = format.fontSize = value;
			updateFormats();
		}
		
		public function get colour():uint 
		{
			return _colour;
		}
		
		public function set colour(value:uint):void 
		{
			_colour = format.colour = value;
			updateFormats();
		}*/
		
		public function get text():String 
		{
			return activeTLF.text;
		}
		
		public function set text(value:String):void 
		{
			_text = englishTLF.text = arabicTLF.text = value;
		}
		
		public function get textHeight():Number 
		{
			return activeTLF.textHeight;
		}
		
		public function get textWidth():Number 
		{
			return activeTLF.textWidth;
		}
		
		public function get debug():Boolean 
		{
			return _debug;
		}
		
		public function set debug(value:Boolean):void 
		{
			_debug = englishTLF.debug = arabicTLF.debug = boundsContainer.debug = value;
		}
		
		/*public function get format():MultilingualFormat 
		{
			return _format;
		}
		
		public function set format(value:MultilingualFormat):void 
		{
			_format = value;
		}
		*/
		public function get autoSizeHeight():Boolean 
		{
			return _autoSizeHeight;
		}
		
		public function set autoSizeHeight(value:Boolean):void 
		{
			_autoSizeHeight = value;
		}
		
		/*public function get textEnglish():String 
		{
			return englishTLF.html;
		}*/
		
		public function set textEnglish(value:String):void 
		{
			englishTLF.html = value;
		}
		
		/*public function get textArabic():String 
		{
			return arabicTLF.html;
		}*/
		
		public function set textArabic(value:String):void 
		{
			arabicTLF.html = value;
		}
		
		/*private function updateFormats():void
		{
			englishTLF.format = format.english;
			trace("style: "+englishTLF.format.containerAlign, englishTLF.tlfWrapper.format.containerAlign);
			arabicTLF.format = format.arabic;
			
		}*/
		public function renderTexture():void {
			englishTLF.renderTexture();
			arabicTLF.renderTexture();
		}
		
		override public function dispose():void
		{
			super.dispose();
		}
		
		public function set contentID(id:String):void
		{
			_contentID = id;
			
			if (autoUpdateContent){
				contentObject = model.contentModel.getContent(id);
				contentObject.update.addOnce(OnContentUpdated);
				
				if (contentObject) {
					this.textEnglish = contentObject.englishCopy;
					this.textArabic = contentObject.arabicCopy;
				}
			}
			
			if (autoUpdateStyle && !_styleID) {
				styleID = id;
			}
		}
		public function set styleID(id:String):void
		{
			_styleID = id;
			
			/*englishStyleObject = model.contentModel.getStyleObject(id, "english");
			arabicStyleObject = model.contentModel.getStyleObject(id, "arabic");*/
			
			model.styleModel.fillStyleApplier(englishStyleApp, id, "english");
			model.styleModel.fillStyleApplier( arabicStyleApp, id, "arabic");
			if (_manualStyle) {
				englishStyleApp.addStyle(_manualStyle, true);
				arabicStyleApp.addStyle(_manualStyle, true);
			}
			
			/*var _w:Number = 0;
			var _h:Number = 0;
			if (englishStyleObject) {
				englishStyleObject.update.addOnce(OnStyleUpdate);
				format.english.fontFamily = englishStyleObject.fontFamily;
				format.english.color = englishStyleObject.color;
				format.english.fontSize = englishStyleObject.fontSize;
				format.english.lineHeight = englishStyleObject.leading + (format.english.fontSize * 0.75);
				format.english.containerAlign = englishStyleObject.containerAlign;
				format.english.textAlign = englishStyleObject.textAlign;
				if (englishStyleObject.width > _w) _w = englishStyleObject.width;
				if (englishStyleObject.height > _h) _h = englishStyleObject.height;
				//englishTLF.width = englishStyleObject.width;
				//englishTLF.height = englishStyleObject.height;
				englishTLF.debug = englishStyleObject.debug;
				if (model.language.languageIndex == 0) {
					boundsContainer.debug = englishStyleObject.debug;
				}
			}
			if (arabicStyleObject) {
				arabicStyleObject.update.addOnce(OnStyleUpdate);
				format.arabic.fontFamily = arabicStyleObject.fontFamily;
				format.arabic.color = arabicStyleObject.color;
				format.arabic.fontSize = arabicStyleObject.fontSize;
				format.arabic.lineHeight = arabicStyleObject.leading + (format.arabic.fontSize * 0.75);
				format.arabic.containerAlign = arabicStyleObject.containerAlign;
				format.arabic.textAlign = arabicStyleObject.textAlign;
				if (arabicStyleObject.width > _w) _w = arabicStyleObject.width;
				if (arabicStyleObject.height > _h) _h = arabicStyleObject.height;
				//arabicTLF.width = arabicStyleObject.width;
				//arabicTLF.height = arabicStyleObject.height;
				arabicTLF.debug = arabicStyleObject.debug;
				if (model.language.languageIndex == 1) {
					boundsContainer.debug = arabicStyleObject.debug;
				}
			}
			
			
			if (_w != 0) this.width = _w;
			if (_h != 0) this.height = _h;*/
			
			/*updateFormats();
			if (_flaTextLayoutFormat) setStandardFormat(_flaTLF, _flaTextLayoutFormat);*/
		}
		
		/*private function OnStyleUpdate():void 
		{
			styleID = _styleID;
		}*/
		
		private function OnContentUpdated():void 
		{
			contentID = _contentID;
		}
		
		public function pivotAlignment(_pivotPercentageX:Number, _pivotPercentageY:Number):void
		{
			pivotPercentageX = _pivotPercentageX;
			pivotPercentageY = _pivotPercentageY;
			updatePivotPercentage();
		}
		
		public function setManualStyle(styleObject:StyleObject):void 
		{
			if (_manualStyle) {
				if(englishStyleApp)englishStyleApp.removeStyle(_manualStyle);
				if(arabicStyleApp)arabicStyleApp.removeStyle(_manualStyle);
			}
			_manualStyle = styleObject;
			if (_manualStyle) {
				if(englishStyleApp)englishStyleApp.addStyle(_manualStyle, true);
				if(arabicStyleApp)arabicStyleApp.addStyle(_manualStyle, true);
			}
		}
		
		/*public function setStandardFormat(flaTLF:TLFTextField, flaTextLayoutFormat:TextLayoutFormat):void
		{
			
			trace("setStandardFormat 1: " + format.english.containerAlign);
			
			_flaTLF = flaTLF;
			_flaTextLayoutFormat = flaTextLayoutFormat;
			format.english.fontFamily = _flaTextLayoutFormat.fontFamily;
			format.arabic.fontFamily = assets.dinNextArabic_Light.fontName;
			format.english.color = format.arabic.color = _flaTextLayoutFormat.color;
			format.english.fontSize = format.arabic.fontSize = _flaTextLayoutFormat.fontSize;
			format.english.lineHeight = format.arabic.lineHeight = _flaTextLayoutFormat.lineHeight;
			format.english.textAlign = format.arabic.textAlign = _flaTextLayoutFormat.textAlign;
			format.english.trackingLeft = format.arabic.trackingLeft = _flaTextLayoutFormat.trackingLeft;
			format.english.trackingRight = format.arabic.trackingRight = _flaTextLayoutFormat.trackingRight;
			format.english.containerAlign = Alignment.TOP_LEFT;
			format.arabic.containerAlign = Alignment.TOP_RIGHT;
			format.arabic.direction = Direction.RTL;
			this.width = _flaTLF.width;
			
			trace("setStandardFormat 2: "+format.english.containerAlign);
		}*/
		
		override public function Show():void 
		{
			this.visible = true;
			TweenLite.to(this, config.tranitions.text.showTime, { alpha:1, delay:config.tranitions.text.showDelay } );
		}
		
		override public function Hide():void 
		{
			TweenLite.to(this, config.tranitions.text.hideTime, { alpha:0, delay:config.tranitions.text.hideDelay, onComplete:OnFadeOutComplete } );
		}
		
		private function OnFadeOutComplete():void 
		{
			this.visible = false;
		}
	}
}