package imag.masdar.core.view.away3d.display.slider 
{
	import away3d.core.pick.PickingColliderType;
	import away3d.entities.Mesh;
	import away3d.events.MouseEvent3D;
	import away3d.materials.ColorMaterial;
	import away3d.primitives.PlaneGeometry;
	import imag.masdar.core.view.away3d.display.base.BaseAwayObject;
	
	/**
	 * ...
	 * @author Pete Shand
	 */
	public class HitArea extends BaseAwayObject 
	{
		private var touchMesh:Mesh;
		
		public function HitArea() 
		{
			var geo:PlaneGeometry = new PlaneGeometry(100, 100, 1, 1, false);
			var testMaterial:ColorMaterial = new ColorMaterial(0xFF0000);
			touchMesh = new Mesh(geo, testMaterial);
			addChild(touchMesh);
			attachTouchListenerTo(touchMesh, PickingColliderType.BOUNDS_ONLY);
		}
		
		override protected function OnTouchBegin(event:MouseEvent3D):void
		{
			//trace("OnTouchBegin");
		}
		
		override protected function OnTouchMove(event:MouseEvent3D):void
		{
			//trace("OnTouchMove");
		}
		
		override protected function OnTouchEnd(event:MouseEvent3D):void
		{
			//trace("OnTouchEnd");
		}
		
	}

}