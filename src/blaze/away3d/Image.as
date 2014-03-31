package blaze.away3d 
{
	import away3d.entities.Mesh;
	import away3d.materials.ColorMaterial;
	import away3d.materials.MaterialBase;
	import away3d.materials.TextureMaterial;
	import away3d.primitives.PlaneGeometry;
	import away3d.textures.BitmapTexture;
	import away3d.textures.Texture2DBase;
	import blaze.away3d.utils.ImageLoader;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	
	/**
	 * ...
	 * @author Pete Shand
	 */
	
	public class Image extends BlazeContainer3D 
	{
		protected var _material:MaterialBase;
		protected var texture:Texture2DBase;
		private var _alphaBlending:Boolean;
		
		public var geo:PlaneGeometry;
		public var mesh:Mesh;
		private var _mipmap:Boolean;
		private var _bothSides:Boolean;
		
		//private var _alphaBlending:Boolean;
		private var _blendMode:String = BlendMode.NORMAL;
		private var _repeatTexture:Boolean;
		//private var _mipmap:Boolean;
		//private var _bothSides:Boolean;
		
		public function Image(texture:Texture2DBase=null)
		{
			geo = new PlaneGeometry(1, 1, 1, 1, false, true);
			
			if (texture) {
				material = new TextureMaterial(texture, true, false, false);
				width = texture.width;
				height = texture.height;
			}
			
			mesh = new Mesh(geo, material);
			addChild(mesh);
		}
		
		override public function get height():Number 
		{
			return geo.height;
		}
		
		override public function set height(value:Number):void 
		{
			geo.height = value;
		}
		
		override public function get width():Number 
		{
			return geo.width;
		}
		
		override public function set width(value:Number):void 
		{
			geo.width = value;
		}
		
		override public function set alpha(value:Number):void 
		{
			super.alpha = value;
			if (material is TextureMaterial) TextureMaterial(material).alpha = value;
			else if (material is ColorMaterial) ColorMaterial(material).alpha = value;
		}
		
		public function set blendMode(value:String):void
		{
			_blendMode = value;
			material.blendMode = value;
		}
		
		public function get repeatTexture():Boolean 
		{
			return material.repeat;
		}
		
		public function set repeatTexture(value:Boolean):void 
		{
			_repeatTexture = value;
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
			_alphaBlending = value;
			if (material is TextureMaterial) TextureMaterial(material).alphaBlending = value;
			else if (material is ColorMaterial) ColorMaterial(material).alphaBlending = value;
		}
		
		public function get mipmap():Boolean 
		{
			return material.mipmap;
		}
		
		public function set mipmap(value:Boolean):void 
		{
			_mipmap = value;
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
			
			_material.blendMode = _blendMode;
			_material.mipmap = _mipmap;
			_material.repeat = _repeatTexture;
			_material.bothSides = _bothSides;
			_material.blendMode = _blendMode;
			
			if (_material is TextureMaterial) {
				TextureMaterial(_material).alpha = this.alpha;
				TextureMaterial(_material).alphaBlending = _alphaBlending;
			}
		}
		
		public function get bothSides():Boolean 
		{
			return material.bothSides;
		}
		
		public function set bothSides(value:Boolean):void 
		{
			_bothSides = value;
			material.bothSides = value;
			geo.doubleSided = value;
		}
		
		override public function dispose():void
		{
			removeChild(mesh);
			mesh.material.dispose();
			mesh.material = null;
			mesh.dispose();
			mesh = null;
		}
		
		static public function fromColor(colour:uint, alpha:Number=1):Image 
		{
			var image:Image = new Image();
			image.material = new ColorMaterial(colour, alpha);
			return image;
		}
		
		static public function fromURL(url:String):Image 
		{
			var image:Image = Image.fromColor(0x000000, 0.5);
			ImageLoader.loadImage(image, url);
			return image;
		}
	}
}