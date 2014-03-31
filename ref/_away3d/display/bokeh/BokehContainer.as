package imag.masdar.core.view.away3d.display.bokeh 
{
	import away3d.containers.ObjectContainer3D;
	import away3d.entities.Mesh;
	import away3d.materials.TextureMaterial;
	import away3d.primitives.PlaneGeometry;
	import away3d.textures.ATFTexture;
	import away3d.textures.BitmapTexture
	import flash.display.BitmapData;
	import flash.events.Event;
	import imag.masdar.core.model.scroll.ScrollObjects;
	import imag.masdar.core.utils.layout.Alignment;
	import imag.masdar.core.view.away3d.display.away2d.Image;
	import imag.masdar.core.view.away3d.display.base.BaseAwayObject;
	
	/**
	 * ...
	 * @author Pete Shand
	 */
	public class BokehContainer extends BaseAwayObject 
	{
		private var scrollObjects:ScrollObjects;
		
		private var container:ObjectContainer3D;
		private var _screenW:Number;
		private var _screenH:Number;
		private var multiplier:Number = 0.2;
		private var bokehGroupModel:BokehGroupModel;
		
		public function BokehContainer(scrollObjects:ScrollObjects=null, numOfBokehs:int=50, bokehScale:Number=1, screenW:int=1920, screenH:int=1080) 
		{
			if (!scrollObjects && (config.horizontalScroll || config.verticalScroll)) {
				scrollObjects = model.contentScrollValue;
			}
			
			this.mouseChildren = false;
			this.mouseEnabled = false;
			_screenW = screenW;
			_screenH = screenH;
			
			container = new ObjectContainer3D();
			addChild(container);
			
			var texture:ATFTexture = new ATFTexture(new assets.BlueBokeh());
			bokehGroupModel = new BokehGroupModel(texture);
			
			for (var i:int = 0; i < 2; i++) 
			{
				var bokehGroup:BokehGroup = new BokehGroup(bokehGroupModel);
				bokehGroup.x = i * bokehGroupModel.dimensions.x;
				container.addChild(bokehGroup);
			}
			
			if (scrollObjects) {
				scrollObjects.fractionLagXChanged.add(OnScrollXChange);
				scrollObjects.fractionLagYChanged.add(OnScrollYChange);
			}
			
			this.scrollObjects = scrollObjects;
		}
		
		private function OnScrollXChange(scrollX:Number):void 
		{
			if (model.language.languageIndex == 0) this.x += scrollObjects.deltaX * scrollObjects.scrollWidth * multiplier;
			else this.x -= scrollObjects.deltaX * scrollObjects.scrollWidth * multiplier;
			container.x = Math.floor(-this.x / bokehGroupModel.dimensions.x) * bokehGroupModel.dimensions.x;
		}
		private function OnScrollYChange(scrollY:Number):void 
		{
			this.y += scrollObjects.deltaX * _screenH * screenScale;
		}
	}
}