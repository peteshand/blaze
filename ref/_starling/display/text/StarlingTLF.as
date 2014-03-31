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
	import imag.masdar.core.view.tlf.BoundsContainer;
	import org.osflash.signals.Signal;
	import starling.display.Image;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.utils.Color;
	
	/**
	 * ...
	 * @author Pete Shand
	 */
	
	public class StarlingTLF extends BaseStarlingObject
	{
		private var language:int;
		private var tlfSprite:TLFSprite;
		private var boundsContainer:BoundsContainer;
		
		//private var _format:LanguageFormat;
		
		private var _debug:Boolean = false;
		private var _contentID:String = "";
		private var _styleID:String;
		
		private var contentObject:ContentObject;
		private var pivotPercentageX:Number = -1;
		private var pivotPercentageY:Number = -1;
		
		//private var styleObject:StyleObject;
		
		public var autoUpdateContent:Boolean = true;
		public var autoUpdateStyle:Boolean = true;
		
		/*private var _flaTLF:TLFTextField;
		private var _flaTextLayoutFormat:TextLayoutFormat;*/
		
		private var styleApp:StyleApplier;
		private var _manualStyle:StyleObject;
		public var textUpdate:Signal = new Signal();
		public var fadeShowHide:Boolean = false;
		
		public function StarlingTLF()
		{
			this.touchable = false;
		}
		
		public function init(language:int, initText:String="", contentID:String="", containerWidth:int=128, containerHeight:int=NaN):void
		{
			this._contentID = contentID;
			this.language = language;
			this.languageIndex = language;
			
			//if (containerHeight == 0) autoSizeHeight = true;
			generateTF(initText, containerWidth, containerHeight);
		}
		
		private function generateTF(initText:String, containerWidth:int, containerHeight:int):void 
		{
			clearTF();
			
			//createFormat();
			
			boundsContainer = new BoundsContainer(containerWidth, containerHeight);
			
			createTLF(initText, containerWidth, containerHeight);
			
			tlfSprite.addEventListener(Event.CHANGE, OnTFLChange);
			
			boundsContainer.init(tlfSprite);
			
			debug = _debug;
		}
		
		private function OnTFLChange(e:Event):void 
		{
			updatePivotPercentage();
			dispatchEvent(new Event(Event.CHANGE));
			textUpdate.dispatch();
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
			format = new TextLayoutFormat();
		}*/
		
		private function createTLF(initText:String, containerWidth:int, containerHeight:int):void
		{
			tlfSprite = TLFSprite.fromHTML(initText, new TextLayoutFormat(), containerWidth, containerHeight, _contentID, language);
			addChild(tlfSprite);
			
			this.animationShowHide = true;
			this.tweenValueVO.target = tlfSprite;
			this.tweenValueVO.addShowProperty( { alpha:1 } );
			this.tweenValueVO.addHideProperty( { alpha:0 } );
			
			styleApp = new StyleApplier();
			styleApp.addDestinationObj(tlfSprite.format);
		}
		
		private function clearTF():void 
		{
			if (tlfSprite) {
				removeChild(tlfSprite);
				tlfSprite.dispose();
				tlfSprite = null;
				
				styleApp.dispose();
				styleApp = null;
			}
			//if (format) format = null;
		}
		
		public function renderTexture():void 
		{	
			this.unflatten();
			tlfSprite.renderTexture();
			this.flatten();
		}
		
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
			//autoSizeHeight = false;
		}
		
		/*public function get fontSize():int 
		{
			return format.fontSize;
		}
		
		public function set fontSize(value:int):void 
		{
			format.fontSize = value;
		}
		
		public function get colour():uint 
		{
			return format.color;
		}
		
		public function set colour(value:uint):void 
		{
			format.color = value;
		}*/
		
		public function get text():String 
		{
			return tlfSprite.text;
		}
		
		public function set text(value:String):void 
		{
			tlfSprite.html = value;
		}
		
		public function get textHeight():Number 
		{
			return tlfSprite.textHeight;
		}
		
		public function get textWidth():Number 
		{
			return tlfSprite.textWidth;
		}
		
		public function get debug():Boolean 
		{
			return _debug;
		}
		
		public function set debug(value:Boolean):void 
		{
			tlfSprite.debug = boundsContainer.debug = value;
		}
		
		/*public function get format():LanguageFormat 
		{
			return _format;
		}
		
		public function set format(value:LanguageFormat):void 
		{
			_format = value;
		}*/
		
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
					if (language == 0) this.text = contentObject.englishCopy;
					else if (language == 1) this.text = contentObject.arabicCopy
				}
			}
			
			/*if (autoUpdateStyle) {
				if (language == 0) styleObject = model.contentModel.getStyleObject(id, 'english');
				else if (language == 1) styleObject = model.contentModel.getStyleObject(id, 'arabic');
				
				if (styleObject) {
					styleObject.update.addOnce(OnStyleUpdate);
					
					format.fontFamily = styleObject.fontFamily;
					format.color = styleObject.color;
					format.fontSize = styleObject.fontSize;
					format.lineHeight = styleObject.leading + (format.fontSize * 0.75);
					format.containerAlign = styleObject.containerAlign;
					format.textAlign = styleObject.textAlign;
					tlfSprite.width = styleObject.width;
					tlfSprite.height = styleObject.height;
					tlfSprite.debug = styleObject.debug;
					if (model.language.language == 0) {
						boundsContainer.debug = styleObject.debug;
					}
				}
				else if (_flaTextLayoutFormat) setStandardFormat(_flaTLF, _flaTextLayoutFormat);
			}*/
			
			if (autoUpdateStyle && !_styleID) {
				styleID = id;
			}
		}
		public function set styleID(id:String):void
		{
			_styleID = id;
			model.styleModel.fillStyleApplier(styleApp, id);
			if (_manualStyle) styleApp.addStyle(_manualStyle, true);
		}
		
		/*private function OnStyleUpdate():void 
		{
			contentID = _contentID;
		}*/
		
		private function OnContentUpdated():void 
		{
			contentID = _contentID;
		}
		
		public function pivotAlignment(_pivotPercentageX:Number, _pivotPercentageY:Number):void
		{
			pivotPercentageX = _pivotPercentageX;
			pivotPercentageY = _pivotPercentageY;
		}
		
		public function setManualStyle(styleObject:StyleObject):void 
		{
			if (_manualStyle && styleApp) styleApp.removeStyle(_manualStyle);
			_manualStyle = styleObject;
			if (_manualStyle && styleApp) styleApp.addStyle(_manualStyle, true);
		}
		
		/*public function setStandardFormat(flaTLF:TLFTextField, flaTextLayoutFormat:TextLayoutFormat):void
		{
			_flaTLF = flaTLF;
			_flaTextLayoutFormat = flaTextLayoutFormat;
			format.fontFamily = _flaTextLayoutFormat.fontFamily;
			format.color =  _flaTextLayoutFormat.color;
			format.fontSize = _flaTextLayoutFormat.fontSize;
			format.lineHeight = _flaTextLayoutFormat.lineHeight;
			format.textAlign = _flaTextLayoutFormat.textAlign;
			format.trackingLeft = _flaTextLayoutFormat.trackingLeft;
			format.trackingRight = _flaTextLayoutFormat.trackingRight;
			if (language == 1) {
				format.containerAlign = Alignment.TOP_LEFT;
			}
			else if (language == 1) {
				format.containerAlign = Alignment.TOP_RIGHT;
				format.direction = Direction.RTL;
			}
			this.width = _flaTLF.width;
		}*/
		
		public function get initiated():Boolean 
		{
			return tlfSprite.initiated;
		}
		
		public function clone():StarlingTLF
		{
			var newStarlingTLF:StarlingTLF = new StarlingTLF();
			newStarlingTLF.x = this.x;
			newStarlingTLF.y = this.y;
			newStarlingTLF.name = this.name;
			newStarlingTLF.fadeShowHide = this.fadeShowHide;
			
			newStarlingTLF.scaleX = this.scaleX;
			newStarlingTLF.scaleY = this.scaleY;
			newStarlingTLF.rotation = this.rotation;
			
			//newStarlingTLF.alpha = this.alpha;
			//newStarlingTLF.visible = this.visible;
			newStarlingTLF.autoUpdateContent = this.autoUpdateContent;
			newStarlingTLF.autoUpdateStyle = this.autoUpdateStyle;
		
			newStarlingTLF.init(this.language, this.text, _contentID, this.width, this.height);
			if (_styleID) newStarlingTLF.styleID = _styleID;
			if (_manualStyle) newStarlingTLF.setManualStyle(_manualStyle);
			newStarlingTLF.contentID = _contentID;
			return newStarlingTLF;
		}
		
		/*override public function Show():void
		{
			if (showing) return;
			showing = true;
			this.visible = true;
			if (animationShowHide) {
				trace("Show TEXTFIELD");
				
				MonsterDebugger.initialize(tweenValueVO.ShowProperties);
				
				hideTweenLite.kill();
				TweenLite.killTweensOf(tweenValueVO.target);
				showTweenLite = TweenLite.to(tweenValueVO.target, tweenValueVO.showTime, tweenValueVO.ShowProperties );
				//showTweenLite = TweenLite.to(tweenValueVO.target, tweenValueVO.showTime, tweenValueVO.ShowProperties );
			}
		}
		
		override public function Hide():void
		{
			if (!showing) return;
			showing = false;
			if (animationShowHide) {
				trace("Hide TEXTFIELD");
				showTweenLite.kill();
				TweenLite.killTweensOf(tweenValueVO.target);
				hideTweenLite = TweenLite.to(tweenValueVO.target, tweenValueVO.hideTime, tweenValueVO.HideProperties );
				//hideTweenLite = TweenLite.to(tweenValueVO.target, tweenValueVO.hideTime, tweenValueVO.HideProperties );
			}
			else this.visible = false;
		}*/
		
		/*override public function Show():void
		{
			if (showing) return;
			this.visible = true;
			if (fadeShowHide) {
				showing = true;
				TweenLite.killTweensOf(this);
				TweenLite.to(this, config.tranitions.text.showTime, { alpha:1, delay:config.tranitions.text.showDelay } );
			}
			else super.Show();
		}
		
		override public function Hide():void
		{
			if (!showing) return;
			if (fadeShowHide) {
				showing = false;
				TweenLite.killTweensOf(this);
				TweenLite.to(this, config.tranitions.text.hideTime, { alpha:0, delay:config.tranitions.text.hideDelay, onComplete:OnFadeoutComplete } );
			}
			else super.Hide();
		}
		
		private function OnFadeoutComplete():void 
		{
			this.visible = false;
		}*/
	}
}