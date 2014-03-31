package imag.masdar.core.view.away3d.display.bokeh 
{
	import imag.masdar.core.view.away3d.display.base.BaseAwayObject;
	
	/**
	 * ...
	 * @author Pete Shand
	 */
	public class BokehGroup extends BaseAwayObject 
	{
		private var bokehGroupModel:BokehGroupModel;
		
		public function BokehGroup(bokehGroupModel:BokehGroupModel) 
		{
			this.bokehGroupModel = bokehGroupModel;
			
			for (var i:int = 0; i < bokehGroupModel.numberOfMaterials; ++i) {
				var bokehMaterialGroup:BokehMaterialGroup = new BokehMaterialGroup(bokehGroupModel.bokehMaterialModels[i]);
				addChild(bokehMaterialGroup);
			}
		}		
	}
}