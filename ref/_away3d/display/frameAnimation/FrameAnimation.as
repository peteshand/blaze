package imag.masdar.core.view.away3d.display.frameAnimation 
{
	import away3d.entities.Mesh;
	import away3d.materials.ColorMaterial;
	import away3d.materials.FrameAnimationMaterial;
	import away3d.primitives.PlaneGeometry;
	import away3d.textures.FrameAnimationTexture;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.registerClassAlias;
	import flash.utils.ByteArray;
	import imag.masdar.core.control.ATFVideoObject;
	import imag.masdar.core.control.Placement;
	import imag.masdar.core.view.away3d.display.base.BaseAwayObject;
	
	/**
	 * ...
	 * @author P.J.Shand
	 */
	public class FrameAnimation extends BaseAwayObject 
	{
		private var byteArray:ByteArray;
		private var atfVideoObject:ATFVideoObject;
		
		private var texture:FrameAnimationTexture;
		private var material:FrameAnimationMaterial;
		private var geo:PlaneGeometry;
		public var mesh:Mesh;
		public var playOnShow:Boolean = true;
		public var uncompressCount:Vector.<Boolean>;
		
		public function FrameAnimation(dataID:String, playOnShow:Boolean=true) 
		{
			super();
			
			this.playOnShow = playOnShow;
			
			byteArray = ByteArray(assets.runtimeAssets.getAsset(dataID));
			
			registerClassAlias("imag.masdar.core.control.ATFVideoObject", ATFVideoObject);
			registerClassAlias("imag.masdar.core.control.Placement", Placement);
			registerClassAlias("flash.utils.ByteArray", ByteArray);
			registerClassAlias("flash.geom.Point", Point);
			registerClassAlias("flash.geom.Rectangle", Rectangle);
			
			byteArray.position = 0;
			atfVideoObject = ATFVideoObject(byteArray.readObject());
			byteArray = null;
			
			animationShowHide = true;
			tweenValueVO.target = this;
			tweenValueVO.addShowProperty( { alpha:1 } );
			tweenValueVO.addHideProperty( { alpha:0 } );
		}
		
		public function get currentFrame():int 
		{
			if (material) return material.currentFrame;
			return 0;
		}
		
		public function set currentFrame(value:int):void 
		{
			if (material){
				value = value % material.totalFrames;
				if (value < 0) value += material.totalFrames;
				material.currentFrame = value;
			}
		}
		
		override public function set alpha(value:Number):void 
		{
			super.alpha = value;
			if (material) material.alpha = value;
		}
		
		override public function Show():void 
		{
			super.Show();
			create();
			if (material && playOnShow) material.play();
		}
		
		override public function Hide():void 
		{
			super.Hide();
			if (material) material.stop();
		}
		
		override protected function OnHideComplete():void 
		{
			this.visible = false;
			disposeChildren();
		}
		
		private function create():void
		{
			trace("create FrameAnimationTexture");
			texture = FrameAnimationTexture.fromPackagedByteArray(atfVideoObject);
			if (uncompressCount) texture.uncompressCount = uncompressCount;
			material = new FrameAnimationMaterial(texture, true, false, false);
			material.alphaBlending = true;
			
			material.playbackFrameRate = 30;
			material.stageFrameRate = core.stage.frameRate;
			
			geo = new PlaneGeometry(texture.animationWidth, texture.animationHeight, 1, 1, false);
			mesh = new Mesh(geo, material);
			addChild(mesh);
		}
		
		private function disposeChildren():void
		{
			if (mesh) {
				uncompressCount = texture.uncompressCount;
				mesh.dispose();
				mesh = null;
				geo.dispose();
				geo = null;
				material.dispose();
				material = null;
				texture.dispose();
				texture = null;
			}
		}
	}

}