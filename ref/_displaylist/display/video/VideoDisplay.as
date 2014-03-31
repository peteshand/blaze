package imag.masdar.core.view.displaylist.display.video 
{
	import away3d.events.Touch;
	import com.greensock.TweenLite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.media.StageVideo;
	import flash.media.Video;
	import imag.masdar.core.model.video.connection.MetaDataVO;
	import imag.masdar.core.model.video.connection.VideoConnection;
	import imag.masdar.core.utils.layout.Dimensions;
	import flash.system.Capabilities;
	import imag.masdar.core.view.displaylist.display.base.BaseClassicSprite;
	/**
	 * ...
	 * @author Pete Shand
	 */
	public class VideoDisplay extends BaseClassicSprite 
	{
		private var background:Sprite;
		protected var forseSoftwareRendering:Boolean;
		protected var showHideOnConnection:Boolean;
		
		protected var stageVideo:StageVideo;
		protected var video:Video;
		
		private var videoWidth:int = 1920;
		private var videoHeight:int = 1080;
		
		public var videoConnection:VideoConnection;
		public var hideOnVideoEnd:Boolean = false;
		
		public function VideoDisplay(forseSoftwareRendering:Boolean = false, showHideOnConnection:Boolean = true) 
		{
			this.forseSoftwareRendering = forseSoftwareRendering;
			this.showHideOnConnection = showHideOnConnection;
			
			background = new Sprite();
			addChild(background);
			
			super();
			
			videoConnection = model.videoConnections.getNextVideoConnection();
			
			
		}
		
		override protected function OnAdd(e:Event):void 
		{
			super.OnAdd(e);
			
			var stageVideos:Vector.<StageVideo> = core.stage.stageVideos; 
			if (stageVideos.length == 0 || forseSoftwareRendering) {
				if (!forseSoftwareRendering) trace("Make sure you are targeting Air 3.8 with FlashDebelop 4.4.3 or higher otherwise Video GPU decoding is not work");
				video = new Video();
				video.smoothing = true;
				addChild(video);
			}
			else {
				stageVideo = stageVideos[0];
			}
			
			videoConnection.OnVideoMetaData.add(OnVideoMetaData);
			if (showHideOnConnection) addSignals();
			
			OnResize()
			addResizeListener();
			
			Hide();
			
			model.scene.sceneChangeSignal.add(OnSceneChange);
			OnSceneChange();
		}
		
		private function OnSceneChange():void 
		{
			if (model.scene.currentScene == 0) {
				TweenLite.delayedCall(1, AddTouchListener);
			}
			else {
				removeTouchListenerTo(this.stage);
			}
		}
		
		private function AddTouchListener():void 
		{
			//attachTouchListenerTo(this.stage);
		}
		
		override protected function OnTouchBegin(touch:Touch):void
		{
			if (model.scene.currentScene == 0) {
				model.scene.currentScene = 1;
			}
		}
		
		protected function addSignals():void 
		{
			videoConnection.OnVideoStart.add(Show);
			videoConnection.OnVideoStop.add(Hide);
		}
		
		protected function removeSignals():void 
		{
			videoConnection.OnVideoStart.remove(Show);
			videoConnection.OnVideoMetaData.remove(OnVideoMetaData);
			videoConnection.OnVideoStop.remove(Hide);
		}
		
		protected function OnVideoMetaData(meta:MetaDataVO):void 
		{
			videoWidth = meta.width;
			videoHeight = meta.height;
			OnResize();
		}
		
		override protected function OnResize():void
		{
			var viewPort:Rectangle = Dimensions.Calculator("zoom", stage.stageWidth, stage.stageHeight, videoWidth, videoHeight);
			if (stageVideo) {
				stageVideo.viewPort = viewPort;
			}
			else {
				video.x = viewPort.x;
				video.y = viewPort.y;
				video.width = viewPort.width;
				video.height = viewPort.height;
			}
		}
		
		override public function Show():void
		{
			super.Show();
			background.visible = true;
			if (stageVideo) model.renderModel.stage3DVisible = false;
			attachNetStream();
		}
		
		protected function attachNetStream():void 
		{
			if (videoConnection.netStream){
				if (stageVideo) {
					stageVideo.attachNetStream(videoConnection.netStream);
				}
				else {
					video.attachNetStream(videoConnection.netStream);
					video.visible = true;
				}
			}
		}
		
		override public function Hide():void
		{
			super.Hide();
			background.visible = false;
			if (video) video.visible = false;
			if (stageVideo) model.renderModel.stage3DVisible = true;
		}
	}
}