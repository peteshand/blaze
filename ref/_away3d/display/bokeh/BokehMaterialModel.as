package imag.masdar.core.view.away3d.display.bokeh 
{
	import away3d.materials.TextureMaterial;
	import away3d.textures.ATFTexture;
	import flash.display.BlendMode;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import blaze.behaviors.materials.MaterialAlphaPulseBehavior;
	/**
	 * ...
	 * @author Pete Shand
	 */
	public class BokehMaterialModel 
	{
		private var texture:ATFTexture;
		public var materials:TextureMaterial;
		public var numberOfMeshesPerMaterial:int = 5;
		public var placement:Vector.<Vector3D> = new Vector.<Vector3D>();
		public var dimensions:Point;
		
		public function BokehMaterialModel(texture:ATFTexture, dimensions:Point) 
		{
			this.texture = texture;
			this.dimensions = dimensions;
			
			materials = new TextureMaterial(texture, true, false, false);
			materials.alphaBlending = true;
			materials.blendMode = BlendMode.ADD;
			
			for (var i:int = 0; i < numberOfMeshesPerMaterial; ++i) {
				placement.push(new Vector3D(Between(-dimensions.x/2,dimensions.x/2), Between(dimensions.y/2,-dimensions.y/2), Between(-300,-100)));
			}
			
			var count:Number = Math.random() * 360 / 180 * Math.PI;
			var step:Number = (0.5 + Math.random()) / 180 * Math.PI;
			
			new MaterialAlphaPulseBehavior(materials, count, step, 0.5);
		}
		
		private function Between(min:Number, max:Number):Number
		{
			return min + (Math.random() * (max - min));
		}
	}
}