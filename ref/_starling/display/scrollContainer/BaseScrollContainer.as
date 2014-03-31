package imag.masdar.core.view.starling.display.scrollContainer 
{
	import imag.masdar.core.model.assetPool.AssetContainerObject;
	import imag.masdar.core.view.starling.display.base.BaseStarlingObject;
	import imag.masdar.core.view.starling.display.slider.SlideContainer;
	
	/**
	 * ...
	 * @author Pete Shand
	 */
	public class BaseScrollContainer extends BaseStarlingObject 
	{
		protected var slideContainers:Vector.<SlideContainer> = new Vector.<SlideContainer>();
		
		public function BaseScrollContainer() 
		{
			super();
			model.startupModel.startupComplete.addOnce(OnStartUpComplete);
		}
		
		protected function OnStartUpComplete():void 
		{
			var numberOfScrollAssets:int = model.assetPool.numberOfScrollAssets;
			for (var i:int = 0; i < numberOfScrollAssets; ++i) {
				var languageAssetContainerObjects:Vector.<AssetContainerObject> = model.assetPool.getAssetContainersByScrollIndex(i);
				for (var j:int = 0; j < languageAssetContainerObjects.length; j++) 
				{
					var slideContainer:SlideContainer = new SlideContainer(i, j, languageAssetContainerObjects[j]);
					addChild(slideContainer);
					slideContainers.push(slideContainer);
				}
			}	
		}
	}
}