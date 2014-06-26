package blaze.service.coms 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author Pete Shand
	 */
	public class CrossContextMessenger
	{
		private static var crossContextGroups:Dictionary = new Dictionary();
		
		public function CrossContextMessenger() 
		{
			
		}
		
		public static function group(id:String):CrossContextGroup
		{
			if (!crossContextGroups[id]) crossContextGroups[id] = new CrossContextGroup();
			return crossContextGroups[id];
		}
	}
}