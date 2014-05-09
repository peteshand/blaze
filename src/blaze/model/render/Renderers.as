package blaze.model.render 
{
	import away3d.core.managers.Stage3DProxy;
	import com.greensock.TweenLite;
	import flash.display.Sprite;
	import flash.events.Event;
	/**
	 * ...
	 * @author P.J.Shand
	 */
	public class Renderers
	{
		static private var clearFunctions:Vector.<Function> = new Vector.<Function>();
		static private var updateFunctions:Vector.<Function> = new Vector.<Function>();
		static private var presentFunctions:Vector.<Function> = new Vector.<Function>();
		static private var active:Vector.<Boolean> = new Vector.<Boolean>();
		static private var _totalActive:int = 0;
		
		static private var presentCount:int = -1;
		static private var sprite:Sprite = new Sprite();
		
		static public function addProxy(clearFunction:Function, updateFunction:Function, presentFunction:Function):int 
		{
			clearFunctions.push(clearFunction);
			updateFunctions.push(updateFunction);
			presentFunctions.push(presentFunction);
			active.push(true);
			return presentFunctions.length - 1;
		}
		
		static public function start():void
		{
			sprite.addEventListener(Event.ENTER_FRAME, update);
		}
		
		static public function stop():void
		{
			sprite.removeEventListener(Event.ENTER_FRAME, update);
		}
		
		static public function setActive(renderIndex:int, value:Boolean):void 
		{
			active[renderIndex] = value;
		}
		
		static private function update(e:Event=null):void 
		{
			if (totalActive == 0) return;
			var i:int;
			//if (presentCount == -1) {
				//presentCount = 0;
				for (i = 0; i < clearFunctions.length; i++) 
				{
					clearFunctions[i]();
				}
				for (i = 0; i < updateFunctions.length; i++) 
				{
					updateFunctions[i]();
				}
			//}
			
			//presentCount++;
			//if (presentCount >= presentFunctions.length) {
				for (i = 0; i < presentFunctions.length; i++) 
				{
					presentFunctions[i]();
				}
				//presentCount = -1;
			//}
		}
		
		private static function get totalActive():int 
		{
			_totalActive = 0;
			for (var i:int = 0; i < active.length; i++) 
			{
				if (active[i]) _totalActive++;
			}
			return _totalActive;
		}
	}
}