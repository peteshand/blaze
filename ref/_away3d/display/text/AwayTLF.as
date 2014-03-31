package imag.masdar.core.view.away3d.display.text 
{
	import away3d.core.base.Object3D;
	import com.greensock.TweenLite;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flashx.textLayout.formats.TextLayoutFormat;
	import imag.masdar.core.model.content.ContentObject;
	import imag.masdar.core.model.style.StyleApplier;
	import imag.masdar.core.model.style.StyleObject;
	import imag.masdar.core.utils.away.GeoDepth;
	import imag.masdar.core.view.away3d.display.away2d.Image;
	import imag.masdar.core.view.away3d.display.base.BaseAwayObject;
	import imag.masdar.core.view.tlf.BoundsContainer;
	import org.osflash.signals.Signal;
	
	/**
	 * ...
	 * @author Pete Shand
	 */
	public class AwayTLF extends BaseAwayObject 
	{
		private var language:int;
		public var tlfContainer:TLFContainer;
		private var boundsContainer:BoundsContainer;
		
		private var _contentID:String = "";
		private var _styleID:String;
		
		private var contentObject:ContentObject;
		
		public var autoUpdateContent:Boolean = true;
		public var autoUpdateStyle:Boolean = true;
		
		private var styleApp:StyleApplier;
		private var _manualStyle:StyleObject;
		public var textUpdate:Signal = new Signal();
		
		public function AwayTLF() 
		{
			
		}
		
		public function init(language:int, initText:String="", contentID:String="", containerWidth:int=128, containerHeight:int=NaN):void
		{
			this._contentID = contentID;
			this.language = language;
			generateTF(initText, containerWidth, containerHeight);
		}
		
		private function generateTF(initText:String, containerWidth:int, containerHeight:int):void 
		{
			clearTF();
			
			boundsContainer = new BoundsContainer(containerWidth, containerHeight);
			createTLF(initText, containerWidth, containerHeight);
			tlfContainer.addEventListener(Event.CHANGE, OnTFLChange);
			boundsContainer.init(tlfContainer);
		}
		
		private function OnTFLChange(e:Event):void 
		{
			dispatchEvent(new Event(Event.CHANGE));
			textUpdate.dispatch();
			
			if (this.parent && reAddToSceneOnTextChange) {
				this.parent.addChild(this);
			}
		}
		
		private function clearTF():void 
		{
			if (tlfContainer) {
				removeChild(tlfContainer);
				tlfContainer.dispose();
				tlfContainer = null;
				
				styleApp.dispose();
				styleApp = null;
			}
		}
		
		private function createTLF(initText:String, containerWidth:int, containerHeight:int):void
		{
			tlfContainer = TLFContainer.fromHTML(initText, new TextLayoutFormat(), containerWidth, containerHeight, _contentID, language);
			tlfContainer.paddingTop = this.paddingTop;
			tlfContainer.paddingBottom = this.paddingBottom;
			tlfContainer.paddingLeft = this.paddingLeft;
			tlfContainer.paddingRight = this.paddingRight;
			addChild(tlfContainer);
			
			this.animationShowHide = true;
			this.tweenValueVO.target = tlfContainer;
			this.tweenValueVO.addShowProperty( { alpha:1 } );
			this.tweenValueVO.addHideProperty( { alpha:0 } );
			
			styleApp = new StyleApplier();
			styleApp.addDestinationObj(tlfContainer.format);
		}
		
		public function set text(value:String):void 
		{
			tlfContainer.html = value;
		}
		
		public function get text():String 
		{
			return tlfContainer.html;
		}
		
		public function set contentID(id:String):void
		{
			_contentID = id;
			
			if (autoUpdateContent){
				contentObject = model.contentModel.getContent(id);
				contentObject.update.addOnce(OnContentUpdated);
				
				if (contentObject) {
					if (language == 0 || language == -1) this.text = contentObject.englishCopy;
					else if (language == 1) this.text = contentObject.arabicCopy
				}
			}
			
			if (autoUpdateStyle && !_styleID) {
				styleID = id;
			}
		}
		
		public function setManualStyle(styleObject:StyleObject):void 
		{
			if (_manualStyle && styleApp) styleApp.removeStyle(_manualStyle);
			_manualStyle = styleObject;
			
			tlfContainer.textAlign = _manualStyle.getDecl("textAlign");
			if (_manualStyle && styleApp) styleApp.addStyle(_manualStyle, true);
		}
		
		public function set styleID(id:String):void
		{
			_styleID = id;
			model.styleModel.fillStyleApplier(styleApp, id);
			if (_manualStyle) styleApp.addStyle(_manualStyle, true);
		}
		
		private function OnContentUpdated():void 
		{
			contentID = _contentID;
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
		}
		
		public function get textWidth():Number 
		{
			return tlfContainer.textWidth;
		}
		
		public function get textHeight():Number 
		{
			return tlfContainer.textHeight;
		}
		
		public function get showDelay():Number 
		{
			return _showDelay;
		}
		
		public function set showDelay(value:Number):void 
		{
			_showDelay = value;
			this.tweenValueVO.addShowProperty( { delay:value } );
		}
		
		override public function set alpha(value:Number):void 
		{
			super.alpha = value;
			tlfContainer.alpha = value;
		}
		
		public function get blur():Number 
		{
			return tlfContainer.blur;
		}
		
		public function set blur(value:Number):void 
		{
			tlfContainer.blur = value;
		}
		
		public function get paddingTop():int 
		{
			return _paddingTop;
		}
		
		public function set paddingTop(value:int):void 
		{
			_paddingTop = value;
			if (tlfContainer) tlfContainer.paddingTop = value;
		}
		
		public function get paddingBottom():int 
		{
			return _paddingBottom;
		}
		
		public function set paddingBottom(value:int):void 
		{
			_paddingBottom = value;
			if (tlfContainer) tlfContainer.paddingBottom = value;
		}
		
		public function get paddingLeft():int 
		{
			return _paddingLeft;
		}
		
		public function set paddingLeft(value:int):void 
		{
			_paddingLeft = value;
			if (tlfContainer) tlfContainer.paddingLeft = value;
		}
		
		public function get paddingRight():int 
		{
			return _paddingRight;
		}
		
		public function set paddingRight(value:int):void 
		{
			_paddingRight = value;
			if (tlfContainer) tlfContainer.paddingRight = value;
		}
		
		public var reAddToSceneOnTextChange:Boolean = true;
		private var _paddingTop:int = 0;
		private var _paddingBottom:int = 0;
		private var _paddingLeft:int = 0;
		private var _paddingRight:int = 0;
		private var _showDelay:Number = 0.5;
		
		override public function clone():Object3D
		{
			var newAwayTLF:AwayTLF = new AwayTLF();
			newAwayTLF.paddingTop = this.paddingTop;
			newAwayTLF.paddingBottom = this.paddingBottom;
			newAwayTLF.paddingLeft = this.paddingLeft;
			newAwayTLF.paddingRight = this.paddingRight;
			newAwayTLF.x = this.x;
			newAwayTLF.y = this.y;
			newAwayTLF.name = this.name;
			
			newAwayTLF.scaleX = this.scaleX;
			newAwayTLF.scaleY = this.scaleY;
			
			newAwayTLF.autoUpdateContent = this.autoUpdateContent;
			newAwayTLF.autoUpdateStyle = this.autoUpdateStyle;
		
			newAwayTLF.init(this.languageIndex, this.text, _contentID, this.width, this.height);
			if (_styleID) newAwayTLF.styleID = _styleID;
			if (_manualStyle) newAwayTLF.setManualStyle(_manualStyle);
			newAwayTLF.contentID = _contentID;
			return newAwayTLF;
		}
	}

}