package imag.masdar.core.view.away3d.display.away2d 
{
	import away3d.core.base.Geometry;
	import away3d.entities.Mesh;
	import away3d.materials.TextureMaterial;
	import away3d.textures.Texture2DBase;
	import com.demonsters.debugger.MonsterDebugger;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import imag.masdar.core.model.texturePacker.PackerObject;
	import imag.masdar.core.view.away3d.animators.IndexFromZAnimationSet;
	import imag.masdar.core.view.away3d.animators.IndexFromZAnimator;
	import imag.masdar.core.view.away3d.display.base.BaseAwayObject;
	import imag.masdar.core.view.away3d.materials.methods.IndexAlphaFadeMethod;
	import org.osflash.signals.Signal;
	/**
	 * ...
	 * @author Pete Shand
	 */
	public class AwayGridAnimation extends BaseAwayObject
	{
		private var packerObject:PackerObject;
		
		protected var material:TextureMaterial;
		protected var texture:Texture2DBase;
		private var _alphaBlending:Boolean;
		
		protected var gridGeo:Geometry;
		protected var mesh:Mesh;
		
		private var segmentSize:int = 40;
		private var segments:Point = new Point();
		
		private var indexFromZAnimationSet:IndexFromZAnimationSet;
		private var indexFromZAnimator:IndexFromZAnimator;
		private var indexAlphaFadeMethod:IndexAlphaFadeMethod;
		
		private var geoReady:Signal = new Signal();
		
		public function AwayGridAnimation(_packerObject:PackerObject) 
		{
			super();
			packerObject = _packerObject;
			trace("packerObject.name = " + packerObject.name);
			
			texture = packerObject.awayTexture;
			if (!texture) texture = packerObject.awayTextureSingle;
			
			material = new TextureMaterial(texture, true, false, false);
			material.alphaBlending = true;
			
			indexAlphaFadeMethod = new IndexAlphaFadeMethod(0.2);
			indexAlphaFadeMethod.fraction = 0;
			
			segments.x = Math.floor((packerObject.placement.width / packerObject.textureScale) / segmentSize);
			segments.y = Math.floor((packerObject.placement.height / packerObject.textureScale) / segmentSize);
			
			width = packerObject.placement.width / packerObject.textureScale;
			height = packerObject.placement.height / packerObject.textureScale;
			
			var placement:Rectangle = packerObject.placement.clone();
			placement.x /= packerObject.textureScale;
			placement.y /= packerObject.textureScale;
			placement.width /= packerObject.textureScale;
			placement.height /= packerObject.textureScale;
			
			model.gridGeometry.getGridGeo(OnGridGeoReady, placement, segments, texture.width / packerObject.textureScale, texture.height / packerObject.textureScale);
			
			animationShowHide = true;
			tweenValueVO.copyTimings(config.tranitions.grid);
			tweenValueVO.target = indexAlphaFadeMethod;
			tweenValueVO.addShowProperty( {fraction:1} );
			tweenValueVO.addHideProperty( {fraction:0} );
			
			showing = false;
		}
		
		private function OnGridGeoReady(_gridGeo:Geometry):void
		{
			gridGeo = _gridGeo.clone();
			
			mesh = new Mesh(gridGeo, material);
			addChild(mesh);
			
			indexFromZAnimationSet = new IndexFromZAnimationSet();
			indexFromZAnimator = new IndexFromZAnimator(indexFromZAnimationSet);
			mesh.animator = indexFromZAnimator;
			
			material.addMethod(indexAlphaFadeMethod);
			
			geoReady.dispatch();
		}
		
		override public function Show():void
		{
			super.Show();
		}
		
		override public function Hide():void
		{
			super.Hide();
		}
		
		override public function dispose():void
		{
			removeChild(mesh);
			mesh.material.dispose();
			mesh.material = null;
			mesh.dispose();
			mesh = null;
		}
	}
}