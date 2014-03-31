package imag.masdar.core.view.away3d.display.away2d 
{
	import away3d.entities.Mesh;
	import away3d.materials.ColorMaterial;
	import away3d.materials.MaterialBase;
	import away3d.materials.TextureMaterial;
	import away3d.primitives.PlaneGeometry;
	import away3d.entities.Sprite3D;
	import away3d.textures.BitmapTexture;
	import away3d.textures.Texture2DBase;
	import flash.display.BitmapData;
	import imag.masdar.core.view.away3d.display.base.BaseAwayObject;
	
	/**
	 * ...
	 * @author Pete Shand
	 */
	
	public class Image extends BaseAwayObject 
	{
		private var useSprite:Boolean = false; // Using Sprite3D creates scaling issues in some cases
		
		private var sprite3D:Sprite3D;
		protected var _material:MaterialBase;
		protected var texture:Texture2DBase;
		private var _alphaBlending:Boolean;
		
		public var geo:PlaneGeometry;
		public var mesh:Mesh;
		private var _mipmap:Boolean;
		private var _bothSides:Boolean;
		
		public function Image(texture:Texture2DBase=null)
		{
			if (useSprite) {
				if (texture) material = new TextureMaterial(texture, true, false, false);
				sprite3D = new Sprite3D(material, 1, 1);
				addChild(sprite3D);
				width = texture.width;
				height = texture.height;
			}
			else {
				geo = new PlaneGeometry(1, 1, 1, 1, false, true);
				
				if (texture) {
					material = new TextureMaterial(texture, true, false, false);
					width = texture.width;
					height = texture.height;
				}
				
				mesh = new Mesh(geo, material);
				addChild(mesh);
			}
		}
		
		override public function set scaleX(value:Number):void
		{
			super.scaleX = value;
			if (useSprite) sprite3D.scaleX = scaleXTemp * screenScale;
		}
		
		override public function set scaleY(value:Number):void
		{
			super.scaleY = value;
			if (useSprite) sprite3D.scaleY = scaleYTemp * screenScale;
		}
		
		override public function set scaleZ(value:Number):void
		{
			super.scaleZ = value;
			if (useSprite) sprite3D.scaleZ = scaleZTemp * screenScale;
		}
		
		override public function get height():Number 
		{
			if (useSprite) return sprite3D.height * screenScale;
			else return geo.height;
		}
		
		override public function set height(value:Number):void 
		{
			if (useSprite) sprite3D.height = value * screenScale;
			else geo.height = value;
		}
		
		override public function get width():Number 
		{
			if (useSprite) return sprite3D.width * screenScale;
			else return geo.width;
		}
		
		override public function set width(value:Number):void 
		{
			if (useSprite) sprite3D.width = value * screenScale;
			else geo.width = value;
		}
		
		override public function set alpha(value:Number):void 
		{
			super.alpha = value;
			if (material is TextureMaterial) TextureMaterial(material).alpha = value;
			else if (material is ColorMaterial) ColorMaterial(material).alpha = value;
		}
		
		public function set blendMode(value:String):void
		{
			material.blendMode = value;
		}
		
		public function get repeatTexture():Boolean 
		{
			return material.repeat;
		}
		
		public function set repeatTexture(value:Boolean):void 
		{
			material.repeat = value;
		}
		
		public function get alphaBlending():Boolean 
		{
			if (material is TextureMaterial) return TextureMaterial(material).alphaBlending;
			else if (material is ColorMaterial) return ColorMaterial(material).alphaBlending;
			return true;
		}
		
		public function set alphaBlending(value:Boolean):void 
		{
			if (material is TextureMaterial) TextureMaterial(material).alphaBlending = value;
			else if (material is ColorMaterial) ColorMaterial(material).alphaBlending = value;
		}
		
		public function get mipmap():Boolean 
		{
			return material.mipmap;
		}
		
		public function set mipmap(value:Boolean):void 
		{
			material.mipmap = value;
		}
		
		public function get material():MaterialBase 
		{
			return _material;
		}
		
		public function set material(value:MaterialBase):void 
		{
			_material = value;
			if (mesh) mesh.material = _material;
		}
		
		public function get bothSides():Boolean 
		{
			return material.bothSides;
		}
		
		public function set bothSides(value:Boolean):void 
		{
			material.bothSides = value;
		}
		
		override public function dispose():void
		{
			removeChild(mesh);
			if (useSprite) {
				sprite3D.material.dispose();
				sprite3D.material = null;
				sprite3D.dispose();
				sprite3D = null;
			}
			else {
				mesh.material.dispose();
				mesh.material = null;
				mesh.dispose();
				mesh = null;
			}
		}
		
		static public function fromColor(colour:uint, alpha:Number=1):Image 
		{
			var image:Image = new Image();
			image.material = new ColorMaterial(colour, alpha);
			return image;
		}
	}
}