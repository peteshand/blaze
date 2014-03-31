package blaze.behaviors 
{
	import away3d.containers.ObjectContainer3D;
	import away3d.entities.Entity;
	import away3d.events.TouchPhase;
	import imag.masdar.core.BaseObject;
	
	/**
	 * ...
	 * @author Pete Shand
	 */
	public class BtnAssignmentBehavior extends BaseObject 
	{
		public static function assign(btnName:String, touchPhase:String, callback:Function, parent:ObjectContainer3D, active:Boolean=true):void
		{
			var child:ObjectContainer3D = parent.getChildByName(btnName);
			if (child){
				if (child is Entity) {
					BtnAssignmentBehavior.applyAwayTouchBehavior(Entity(child), touchPhase, callback, active);
				}
				else {
					for (var j:int = 0; j < child.numChildren; ++j) {
						if (child.getChildAt(j) is Entity) {
							BtnAssignmentBehavior.applyAwayTouchBehavior(Entity(child.getChildAt(j)), touchPhase, callback, active);
							break;
						}
					}
				}
			}
		}
		
		private static function applyAwayTouchBehavior(touchObject:Entity, touchPhase:String, callback:Function, active:Boolean):void
		{
			var awayTouchBehavior:AwayTouchBehavior;
			if (touchPhase == TouchPhase.BEGAN) awayTouchBehavior = new AwayTouchBehavior(callback, null, null, null, null);
			if (touchPhase == TouchPhase.MOVED) awayTouchBehavior = new AwayTouchBehavior(null, callback, null, null, null);
			if (touchPhase == TouchPhase.ENDED) awayTouchBehavior = new AwayTouchBehavior(null, null, callback, null, null);
			awayTouchBehavior.removeTouchListenerTo(touchObject);
			awayTouchBehavior.addListenerTo(touchObject);
			awayTouchBehavior.active = active;
		}
	}
}