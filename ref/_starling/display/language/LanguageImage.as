package imag.masdar.core.view.starling.display.language 
{
	import imag.masdar.core.Core;
	import starling.display.Image;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author Pete Shand
	 */
	public class LanguageImage extends Image 
	{
		private var core:Core = Core.getInstance();
		
		public var englishTexture:Texture;
		public var arabicTexture:Texture;
		
		public function LanguageImage(_englishTexture:Texture, _arabicTexture:Texture=null) 
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