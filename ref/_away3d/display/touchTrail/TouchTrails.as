package imag.masdar.core.view.away3d.display.touchTrail 
{
	import imag.masdar.core.view.away3d.display.base.BaseAwayObject;
	
	/**
	 * ...
	 * @author Pete Shand
	 */
	public class TouchTrails extends BaseAwayObject 
	{
		private var touchTrails:Vector.<TouchTrail> = new Vector.<TouchTrail>();
		
		public function TouchTrails() 
		{
			model.touchTrailRegister.newTouchRegisted.add(OnNewTouchRegisted);
			model.touchTrailRegister.removeTouchRegisted.add(OnRemoveTouchRegisted);
		}
		
		private function OnNewTouchRegisted(touchID:int):void 
		{
			var touchTrail:TouchTrail = new TouchTrail(touchID);
			addChild(touchTrail);
			touchTrails.push(touchTrail);
		}
		
		private function OnRemoveTouchRegisted(touchID:int):void 
		{
			for (var i:int = 0; i < touchTrails.length; ++i) {
				if (touchTrails[i].touchID == touchID){
					var touchTrail:TouchTrail = touchTrails[i];
					removeChild(touchTrail);
					if (touchTrail.parent) touchTrail.parent.removeChild(touchTrail.parent);
					touchTrail.dispose();
					touchTrail = null;
					touchTrails.splice(i, 1);
				}
			}
		}
	}
}