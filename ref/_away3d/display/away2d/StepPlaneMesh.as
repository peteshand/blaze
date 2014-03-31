package imag.masdar.core.view.away3d.display.away2d 
{
	import away3d.core.base.Geometry;
	import away3d.entities.Mesh;
	import away3d.materials.MaterialBase;
	import away3d.tools.commands.Merge;
	
	/**
	 * ...
	 * @author Pete Shand
	 */
	public class StepPlaneMesh extends Mesh 
	{
		private var meshes:Vector.<Mesh> = new Vector.<Mesh>();
		
		public function StepPlaneMesh(geometry:Geometry, material:MaterialBase = null, steps:int = 10) 
		{
			for (var k:int = 0; k < steps; ++k) {
				var t:Number = k / steps;
				var mesh:Mesh = new Mesh(geometry.clone(), null);
				mesh.z = t;
				meshes.push(mesh);
			}
			
			super(geometry, material);
			
			var merge:Merge = new Merge(false, true);
			merge.applyToMeshes(this, meshes);
		}
		
	}

}