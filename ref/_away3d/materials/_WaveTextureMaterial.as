package imag.masdar.core.view.away3d.materials 
{
	import away3d.materials.TextureMaterial;
	import away3d.textures.Texture2DBase;
	import imag.masdar.core.view.away3d.materials.pass.TrivialColorPass;
	import imag.masdar.core.view.away3d.materials.pass.WaveColorPass;
	
	/**
	 * ...
	 * @author Pete Shand
	 */
	public class WaveTextureMaterial extends TextureMaterial 
	{
		
		public function WaveTextureMaterial(texture : Texture2DBase = null, smooth : Boolean = true, repeat : Boolean = false, mipmap : Boolean = true) 
		{
			
			super(texture, smooth, repeat, mipmap);
			this.texture = texture;
			this.smooth = smooth;
			this.repeat = repeat;
			this.mipmap = mipmap;
			addPass(new WaveColorPass());
		}
		
		public function get offsetX():Number 
		{
			return TrivialColorPass(_passes[1]).offsetX;
		}
		
		public function set offsetX(value:Number):void 
		{
			TrivialColorPass(_passes[1]).offsetX = value;
		}
		
		public function get frequencyX():Number 
		{
			return TrivialColorPass(_passes[1]).frequencyX;
		}
		
		public function set frequencyX(value:Number):void 
		{
			TrivialColorPass(_passes[1]).frequencyX = value;
		}
		
		public function get amplitudeX():Number 
		{
			return TrivialColorPass(_passes[1]).amplitudeX;
		}
		
		public function set amplitudeX(value:Number):void 
		{
			TrivialColorPass(_passes[1]).amplitudeX = value;
		}
		
		
		
		
		
		
		
		
		public function get offsetY():Number 
		{
			return TrivialColorPass(_passes[1]).offsetY;
		}
		
		public function set offsetY(value:Number):void 
		{
			TrivialColorPass(_passes[1]).offsetY = value;
		}
		
		public function get frequencyY():Number 
		{
			return TrivialColorPass(_passes[1]).frequencyY;
		}
		
		public function set frequencyY(value:Number):void 
		{
			TrivialColorPass(_passes[1]).frequencyY = value;
		}
		
		public function get amplitudeY():Number 
		{
			return TrivialColorPass(_passes[1]).amplitudeY;
		}
		
		public function set amplitudeY(value:Number):void 
		{
			TrivialColorPass(_passes[1]).amplitudeY = value;
		}
	}

}