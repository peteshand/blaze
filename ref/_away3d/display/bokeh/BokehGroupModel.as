package imag.masdar.core.view.away3d.display.bokeh 
{
	import away3d.materials.TextureMaterial;
	import away3d.textures.ATFTexture;
	import flash.geom.Point;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author Pete Shand
	 */
	public class BokehGroupModel 
	{
		public var numberOfMaterials:int = 5;
		public var dimensions:Point = new Point(1920, 1080);
		public var bokehMaterialModels:Vector.<BokehMaterialModel> = new Vector.<BokehMaterialModel>();
		
		public function BokehGroupModel(texture:ATFTexture) 
		{
			for (var i:int = 0; i < numberOfMaterials; ++i) {
				var bokehMaterialModel:BokehMaterialModel = new BokehMaterialModel(texture, dimensions);
				bokehMaterialModels.push(bokehMaterialModel);
			}
		}
	}
}