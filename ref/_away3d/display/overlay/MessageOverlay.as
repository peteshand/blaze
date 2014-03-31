package imag.masdar.core.view.away3d.display.overlay 
{
	import away3d.containers.ObjectContainer3D;
	import away3d.events.Scene3DEvent;
	import away3d.textures.BitmapTexture;
	import com.greensock.TweenLite;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import imag.masdar.core.model.applicationState.ApplicationState;
	import imag.masdar.core.model.assetPool.AssetContainerObject;
	import imag.masdar.core.utils.layout.Dimensions;
	import imag.masdar.core.view.away3d.display.away2d.Image;
	import imag.masdar.core.view.away3d.display.away2d.StandardAsset;
	import imag.masdar.core.view.away3d.display.text.AwayTLF;
	import imag.masdar.experience.view.away3d.display.base.BaseAwayObject;
	
	/**
	 * ...
	 * @author Pete Shand
	 */
	public class MessageOverlay extends BaseAwayObject 
	{
		private var background:Image;
		private var rect:Rectangle;
		
		private var mc_warningMsgBg:StandardAsset;
		private var txt_warningTitle:AwayTLF;
		
		public function MessageOverlay() 
		{
			var texture:BitmapTexture = new BitmapTexture(new BitmapData(16, 16, false, 0x000000));
			background = new Image(texture);
			background.width = 100;
			background.height = 100;
			addChild(background);
			addResizeListener();
			
			this.showing = false;
			this.visible = false;
			
			if (model.startupModel.started) OnStarupComplete();
			else model.startupModel.startupComplete.addOnce(OnStarupComplete);
		}
		
		private function OnStarupComplete():void 
		{
			var container:ObjectContainer3D = new ObjectContainer3D();
			addChild(container);
			
			var assetContainerObject:AssetContainerObject = model.assetPool.getAssetContainersByName("McWarningMsg");
			assetContainerObject.addAwayObjectsTo(container, 0, true);
			
			mc_warningMsgBg = StandardAsset(container.getChildByName("mc_warningMsgBg"));
			if (container.getChildByName("txt_warningTitle") is AwayTLF){
				txt_warningTitle = AwayTLF(container.getChildByName("txt_warningTitle"));
				txt_warningTitle.textUpdate.add(OnTextUpdated);
			}
			
			if (mc_warningMsgBg){
				container.x = mc_warningMsgBg.width / -2;
				container.y = mc_warningMsgBg.height / 2;
				this.alpha = 0;
			}
			
			this.animationShowHide = true;
			tweenValueVO.target = this;
			tweenValueVO.addShowProperty( { alpha:0.9 } );
			tweenValueVO.addHideProperty( { alpha:0 } );
			
			model.messageOverlayModel.msgUpdated.add(OnMsgOverlayUpdated);
		}
		
		private function OnTextUpdated():void 
		{
			txt_warningTitle.x = (mc_warningMsgBg.width - txt_warningTitle.textWidth) / 2;
			txt_warningTitle.y = (txt_warningTitle.textHeight - mc_warningMsgBg.height) / 2;
		}
		
		override protected function OnResize():void
		{
			rect = Dimensions.Calculator(Dimensions.ZOOM, core.model.viewportModel.width, core.model.viewportModel.height, config.width, config.height);
			background.scaleX = rect.width / 100;
			background.scaleY = rect.height / 100;
		}
		
		private function OnMsgOverlayUpdated():void 
		{
			if (model.messageOverlayModel.messgage == "") {
				Hide();
			}
			else {
				if (txt_warningTitle) txt_warningTitle.text = model.messageOverlayModel.messgage;
				Show();
			}
		}
		
		override protected function OnHideComplete():void 
		{
			this.visible = false;
		}
		
		override public function set alpha(value:Number):void 
		{
			super.alpha = value;
			background.alpha = value;
			mc_warningMsgBg.alpha = value;
			if (txt_warningTitle) txt_warningTitle.alpha = value;
		}
	}
}