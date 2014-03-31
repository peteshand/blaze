package imag.masdar.core.view.away3d.display.scrollContainer 
{
	import away3d.containers.ObjectContainer3D;
	import away3d.events.Scene3DEvent;
	import imag.masdar.core.model.assetPool.AssetContainerObject;
	import imag.masdar.core.view.away3d.display.base.BaseAwayObject;
	import imag.masdar.core.view.away3d.display.slider.SlideContainer;
	/**
	 * ...
	 * @author Pete Shand
	 */
	public class BaseScrollContainer extends BaseAwayObject 
	{
		protected var container:ObjectContainer3D;
		protected var slideContainers:Vector.<SlideContainer>;
		
		protected var languageAssetContainerObjects:Vector.<AssetContainerObject>;
		
		public function BaseScrollContainer() 
		{
			super();
			model.startupModel.startupComplete.addOnce(OnStartUpComplete);
		}
		
		protected function OnStartUpComplete():void 
		{
			container = new ObjectContainer3D();
			addChild(container);
			
			var numberOfScrollAssets:int = model.assetPool.numberOfScrollAssets;
			slideContainers = new Vector.<SlideContainer>();
			for (var i:int = numberOfScrollAssets-1; i >= 0; --i) {
				languageAssetContainerObjects = model.assetPool.getAssetContainersByScrollIndex(i);
				for (var j:int = languageAssetContainerObjects.length-1; j >= 0; j--) 
				{
					var slideContainer:SlideContainer = new SlideContainer(i, j, languageAssetContainerObjects[j], container);
					slideContainer.name = "SlideContainer_" + languageAssetContainerObjects[j].scrollIndex;
					if (j == 0) slideContainer.name += "_en";
					else slideContainer.name += "_ar";
					
					slideContainer.z = languageAssetContainerObjects[j].zIndex * 1000;
					slideContainers.push(slideContainer);
					
					if (config.useSpriteSheetGeneration)
					{	
						container.addChild(slideContainer);
					}
				}
			}
			slideContainers.reverse();
			
			model.scene.sceneChangeSignal.add(OnSceneChange);
		}
		
		protected function OnSceneChange():void 
		{
			
		}
	}
}