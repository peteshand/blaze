package imag.masdar.core.view.away3d.display.away2d 
{
	import away3d.entities.Mesh;
	import away3d.materials.TextureMaterial;
	import away3d.primitives.PlaneGeometry;
	import away3d.textures.BitmapTexture;
	import away3d.textures.Texture2DBase;
	import com.demonsters.debugger.MonsterDebugger;
	import com.greensock.TweenLite;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	import imag.masdar.core.model.texturePacker.PackerObject;
	import imag.masdar.core.utils.away.PlaneGeoUVUpdater;
	import imag.masdar.core.utils.logging.Log;
	import imag.masdar.core.view.away3d.display.base.BaseAwayObject;
	
	/**
	 * ...
	 * @author Pete Shand
	 */
	
	public class StandardAsset extends BaseAwayObject 
	{
		private var packerObject:PackerObject;
		protected var _material:TextureMaterial;
		protected var texture:Texture2DBase;
		protected var geo:PlaneGeometry;
		
		private var textureActive:Boolean = false;
		public var mesh:Mesh;
		
		public function StandardAsset(_packerObject:PackerObject) 
		{
			super();
			packerObject = _packerObject;
			showing = false;
			init();
		}
		
		private function init():void 
		{
			if (config.useSpriteSheetGeneration) {
				texture = packerObject.awayTexture;
			}
			else {
				texture = packerObject.awayTextureSingle;
			}
			
			if (texture){
				initMaterial();
				initGeo();
				initMesh();
				setWidthHeight();
				setTween();
			}
			
			textureActive = true;
		}
		
		private function initMaterial():void 
		{
			material = new TextureMaterial(texture, true, false, false);
			material.alphaBlending = true;
			material.alpha = this.alpha;
			material.bothSides = true;
			
			if (packerObject.name.indexOf("box_") != -1) {
				material.alphaBlending = false;
			}
		}
		
		private function initGeo():void 
		{
			if (config.useSpriteSheetGeneration)
			{	
				var placement:Rectangle = packerObject.placement.clone();
				placement.x /= packerObject.textureScale;
				placement.y /= packerObject.textureScale;
				placement.width /= packerObject.textureScale;
				placement.height /= packerObject.textureScale;
				
				//geo = SharedGeo.planeGeometry();
				
				geoWidth = placement.width;
				geoHeight = placement.height;
				geoUpdateRect = placement;
				textureWidth = texture.width / packerObject.textureScale;
				textureHeight = texture.height / packerObject.textureScale;
				
				
				
				//geo = new PlaneGeometry(placement.width, placement.height, 1, 1, false);
				//PlaneGeoUVUpdater.update(geo, placement, texture.width / packerObject.textureScale, texture.height / packerObject.textureScale);
			}
			else {
				
				//geo = SharedGeo.planeGeometry();
				
				geoWidth = packerObject.displayObject.width / packerObject.textureScale;
				geoHeight = packerObject.displayObject.height / packerObject.textureScale;
				geoUpdateRect = new Rectangle(0, 0, packerObject.displayObject.width, packerObject.displayObject.height);
				textureWidth = texture.width;
				textureHeight = texture.height;
				
				/*geo = new PlaneGeometry(packerObject.displayObject.width / packerObject.textureScale, packerObject.displayObject.height / packerObject.textureScale, 1, 1, false);
				var rect:Rectangle = new Rectangle(0, 0, packerObject.displayObject.width, packerObject.displayObject.height);
				PlaneGeoUVUpdater.update(geo, rect, texture.width, texture.height);*/
			}
			
			geo = new PlaneGeometry(geoWidth, geoHeight, 1, 1, false);
			PlaneGeoUVUpdater.update(geo, geoUpdateRect, textureWidth, textureHeight);
		}
		
		private var geoWidth:Number;
		private var geoHeight:Number;
		private var geoUpdateRect:Rectangle;
		private var textureWidth:int;
		private var textureHeight:int;
		
		override public function Show():void
		{
			setGeo()
			super.Show();
		}
		
		override protected function OnHideComplete():void 
		{
			clearGeo();
			if (!config.useSpriteSheetGeneration) {
				dispose();
			}
			super.OnHideComplete();
		}
		
		private function setGeo():void
		{
			if (!geoUpdateRect) return;
			if (geo) {
				geo.dispose();
				geo = null;
			}
			geo = new PlaneGeometry(geoWidth, geoHeight, 1, 1, false);
			PlaneGeoUVUpdater.update(geo, geoUpdateRect, textureWidth, textureHeight);
			if (mesh) mesh.geometry = geo;
		}
		
		private function clearGeo():void
		{
			if (mesh) mesh.geometry = SharedGeo.planeGeometry();
			if (geo) {
				geo.dispose();
				geo = null;
			}
		}
		
		private function initMesh():void 
		{
			mesh = new Mesh(geo, material);
			addChild(mesh);
			mesh.x = geo.width / 2;
			mesh.y = -geo.height / 2;
			mesh.z = _z;
		}
		
		private function setWidthHeight():void 
		{
			_width = packerObject.placement.width;
			_height = packerObject.placement.height;
		}
		
		private function setTween():void 
		{
			animationShowHide = true;
			tweenValueVO.target = this;
			tweenValueVO.addShowProperty( { alpha:1 } );
			tweenValueVO.addHideProperty( { alpha:0 } );
		}
		
		override public function set z(value:Number):void
		{
			_z = value;
			if (mesh) mesh.z = _z;
		}
		
		override public function get z():Number
		{
			//trace("packerObject.name = " + packerObject.name);
			if (mesh) return mesh.z;
			return 0;
		}
		
		override public function set alpha(value:Number):void 
		{
			super.alpha = value;
			if (material && textureActive) material.alpha = value;
		}
		
		public function get material():TextureMaterial 
		{
			return _material;
		}
		
		public function set material(value:TextureMaterial):void 
		{
			_material = value;
		}
		
		override public function set scaleX(value:Number):void
		{
			_scaleX = value;
		}
		
		override public function get scaleX():Number
		{
			return _scaleX;
		}
		
		override public function set scaleY(value:Number):void
		{
			_scaleY = value;
		}
		
		override public function get scaleY():Number
		{
			return _scaleY;
		}
		
		override public function set scaleZ(value:Number):void
		{
			_scaleZ = value;
		}
		
		override public function get scaleZ():Number
		{
			return _scaleZ;
		}
		
		override public function dispose():void
		{
			if (mesh) {
				
				removeChild(mesh);
				mesh.material.dispose();
				mesh.material = null;
				
				texture.dispose();
				texture = null;
				
				if (geo) {
					geo.dispose();
					geo = null;
				}
				mesh.geometry = null;
				
				mesh.dispose();
				mesh = null;
				
				
				textureActive = false;
			}
		}
	}
}