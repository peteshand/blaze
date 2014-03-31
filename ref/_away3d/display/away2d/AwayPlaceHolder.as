package imag.masdar.core.view.away3d.display.away2d 
{
	import away3d.containers.ObjectContainer3D;
	import imag.masdar.core.view.away3d.display.base.BaseAwayObject;
	import imag.masdar.core.view.away3d.display.base.PrimordialObjectContainer3D;
	
	/**
	 * ...
	 * @author Pete Shand
	 */
	public class AwayPlaceHolder extends BaseAwayObject 
	{
		private var awayObjects:Vector.<PrimordialObjectContainer3D> = new Vector.<PrimordialObjectContainer3D>();
		
		public function AwayPlaceHolder() 
		{
			
		}
		
		override public function Show():void 
		{
			if (showing) return;
			showing = true;
			for (var i:int = 0; i < awayObjects.length; i++) {
				awayObjects[i].Show();
			}
		}
		
		override public function Hide():void 
		{
			if (!showing) return;
			showing = false;
			for (var i:int = 0; i < awayObjects.length; i++) {
				awayObjects[i].Hide();
			}
		}
		
		override public function addChild(child:ObjectContainer3D):ObjectContainer3D
		{
			if (child is PrimordialObjectContainer3D) {
				awayObjects.push(PrimordialObjectContainer3D(child));
			}
			return super.addChild(child);
		}
		
		override public function removeChild(child:ObjectContainer3D):void
		{
			for (var i:int = 0; i < awayObjects.length; i++) {
				if (awayObjects[i] == child) awayObjects.splice(i, 1);
			}
			super.removeChild(child);
		}
	}
}