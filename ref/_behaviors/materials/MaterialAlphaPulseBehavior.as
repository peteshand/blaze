package blaze.behaviors.materials 
{
	import away3d.materials.TextureMaterial;
	import imag.masdar.core.BaseObject;
	
	/**
	 * ...
	 * @author Pete Shand
	 */
	public class MaterialAlphaPulseBehavior extends BaseObject 
	{
		private var material:TextureMaterial;
		private var count:Number;
		private var step:Number;
		private var maxAlpha:Number;
		
		public function MaterialAlphaPulseBehavior(material:TextureMaterial, count:Number, step:Number, maxAlpha:Number = 1) 
		{
			this.material = material;
			this.count = count;
			this.step = step;
			this.maxAlpha = maxAlpha;
			
			model.tick.render.add(OnTick);
		}
		
		private function OnTick(timeDelta:int):void 
		{
			count += step;
			material.alpha = ((Math.sin(count) * 0.5) + 0.5) * maxAlpha;
		}
	}
}