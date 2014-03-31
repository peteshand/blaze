package imag.masdar.core.view.away3d.materials 
{
	import away3d.debug.Debug;
	import away3d.textures.Texture2DBase;
	import imag.masdar.core.view.away3d.materials.pass.TrivialTexturePass;

	import away3d.materials.MaterialBase;

	public class TrivialTextureMaterial extends MaterialBase
	{
		public function TrivialTextureMaterial(texture : Texture2DBase)
		{
			// pick either of these, which shows a different approach in cleaning up render state
			addPass(new TrivialTexturePass(texture));
			
			//addPass(new TrivialTexturePass_Alternative(texture));
			
			
		}
		
		private var _amplitude:Number = 10;
		private var _frequency:Number = 10;
		private var _offset:Number = 0;
		
		public function get offset():Number 
		{
			return TrivialTexturePass(_passes[0]).offset;
		}
		
		public function set offset(value:Number):void 
		{
			TrivialTexturePass(_passes[0]).offset = value;
		}
		
		public function get frequency():Number 
		{
			return TrivialTexturePass(_passes[0]).frequency;
		}
		
		public function set frequency(value:Number):void 
		{
			TrivialTexturePass(_passes[0]).frequency = value;
		}
		
		public function get amplitude():Number 
		{
			return TrivialTexturePass(_passes[0]).amplitude;
		}
		
		public function set amplitude(value:Number):void 
		{
			TrivialTexturePass(_passes[0]).amplitude = value;
		}
	}
}