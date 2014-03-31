package imag.masdar.core.view.away3d.display.bokeh 
{
	import away3d.containers.ObjectContainer3D;
	import away3d.entities.Mesh;
	import away3d.materials.TextureMaterial;
	import away3d.primitives.PlaneGeometry;
	import away3d.textures.BitmapTexture;
	import away3d.tools.commands.Merge;
	import flash.display.BitmapData;
	import imag.masdar.core.view.away3d.display.base.BaseAwayObject;
	
	/**
	 * ...
	 * @author Pete Shand
	 */
	public class BokehMaterialGroup extends BaseAwayObject 
	{
		private var bokehMaterialModel:BokehMaterialModel;
		private var merge:Merge = new Merge();
		private var receiver:Mesh;
		private var container:ObjectContainer3D = new ObjectContainer3D();
		
		public function BokehMaterialGroup(bokehMaterialModel:BokehMaterialModel) 
		{
			this.bokehMaterialModel = bokehMaterialModel;
			
			for (var i:int = 0; i < bokehMaterialModel.numberOfMeshesPerMaterial; i++) 
			{
				var geo:PlaneGeometry = new PlaneGeometry(128, 128, 1, 1, false, true);
				var mesh:Mesh = new Mesh(geo, bokehMaterialModel.materials);
				mesh.x = bokehMaterialModel.placement[i].x;
				mesh.y = bokehMaterialModel.placement[i].y;
				mesh.z = bokehMaterialModel.placement[i].z;
				container.addChild(mesh);
			}
			
			receiver = new Mesh(null, bokehMaterialModel.materials);
			merge.applyToContainer(receiver, container);
			
			addChild(receiver);
		}
	}
}