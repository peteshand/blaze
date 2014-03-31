package imag.masdar.core.view.away3d.display.language 
{
	import away3d.textures.BitmapTexture;
	import flash.display.BitmapData;
	import imag.masdar.core.Core;
	import imag.masdar.core.view.away3d.display.base.Image;
	
	/**
	 * ...
	 * @author Pete Shand
	 */
	public class LanguageImage extends Image 
	{
		private var core:Core = Core.getInstance();
		
		private var englishTexture:BitmapTexture;
		private var arabicTexture:BitmapTexture;
		
		public function LanguageImage(englishTexture:BitmapTexture, arabicTexture:BitmapTexture) 
		{
			englishTexture = _englishTexture;
			arabicTexture = _arabicTexture;
			if (arabicTexture == null) arabicTexture = englishTexture;
			super(englishTexture);
			
			core.model.languageModel.updateSignal.add(OnLanguageChange);
		}
		
		private function OnLanguageChange():void 
		{
			setLanguage(core.model.languageModel.languageIndex);
		}
		
		public function setLanguage(index:int):void
		{
			if (index == 0) {
				this.texture = englishTexture;
			}
			else {
				this.texture = arabicTexture;
			}
		}
	}
}