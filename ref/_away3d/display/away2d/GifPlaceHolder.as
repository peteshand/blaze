package imag.masdar.core.view.away3d.display.away2d 
{
	import away3d.entities.Mesh;
	import away3d.materials.GifMaterial;
	import away3d.primitives.PlaneGeometry;
	import away3d.textures.GifTexture;
	import com.worlize.gif.events.GIFPlayerEvent;
	import com.worlize.gif.GIFPlayer;
	import flash.utils.ByteArray;
	import imag.masdar.core.view.away3d.display.base.BaseAwayObject;
	
	/**
	 * ...
	 * @author Pete Shand
	 */
	public class GifPlaceHolder extends BaseAwayObject 
	{
		private var gifName:String;
		private var gifPlayer:GIFPlayer;
		private var gifMaterial:GifMaterial;
		private var mesh:Mesh;
		
		public function GifPlaceHolder(name:String) 
		{
			super();
			
			this.name = name;
			gifName = name.split('gif_')[1];
			
			var data:ByteArray = assets.getGif(gifName);
			if (data == null) throw new Error("No gif found when searching for:" + gifName);
			else {
				gifPlayer = new GIFPlayer(true);
				gifPlayer.addEventListener(GIFPlayerEvent.COMPLETE, OnDecodeComplete);
				gifPlayer.loadBytes(data);
			}
		}
		
		private function OnDecodeComplete(e:GIFPlayerEvent):void 
		{
			var gifTexture:GifTexture = new GifTexture(gifPlayer, true);
			gifMaterial = new GifMaterial(gifTexture);
			var geo:PlaneGeometry = new PlaneGeometry(gifPlayer.width, gifPlayer.height, 1, 1, false);
			mesh = new Mesh(geo, gifMaterial);
			mesh.x = gifPlayer.width / 2;
			mesh.y = -gifPlayer.height / 2;
			addChild(mesh);
			
			setWidthHeight();
			setTween();
		}
		
		private function setWidthHeight():void 
		{
			_width = gifPlayer.width;
			_height = gifPlayer.height;
		}
		
		private function setTween():void 
		{
			animationShowHide = true;
			tweenValueVO.target = this;
			tweenValueVO.addShowProperty( { alpha:1 } );
			tweenValueVO.addHideProperty( { alpha:0 } );
		}
		
		override public function Show():void 
		{
			if (showing) return;
			super.Show();
			if (gifMaterial) gifPlayer.play();
		}
		
		override public function Hide():void 
		{
			if (!showing) return;
			super.Hide();
			if (gifMaterial) gifPlayer.stop();
		}
		
		override protected function OnHideComplete():void 
		{
			super.OnHideComplete();
			
		}
		
		override public function set alpha(value:Number):void 
		{
			super.alpha = value;
			if (gifMaterial) gifMaterial.alpha = alpha;
		}
	}
}