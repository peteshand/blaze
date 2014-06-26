package blaze.services.coms 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import org.osflash.signals.ISlot;
	import org.osflash.signals.Signal;
	/**
	 * ...
	 * @author pjshand
	 */
	internal class CrossContextGroup 
	{
		private var dispatcher:EventDispatcher = new EventDispatcher();
		private var signal:Signal = new Signal();
			
		public function CrossContextGroup()
		{
			
		}
		
		public function add(listener:Function):ISlot
		{
			return signal.add(listener);
		}
		
		public function addOnce(listener:Function):ISlot
		{
			return signal.addOnce(listener);
		}
		
		public function dispatch(...rest):void
		{
			signal.dispatch.apply(null, rest);
		}
		
		public function get numListeners():uint
		{
			return signal.numListeners;
		}
		
		public function remove(listener:Function):ISlot
		{
			return signal.remove(listener);
		}
		
		public function removeAll():void
		{
			signal.removeAll();
		}
		
		public function get valueClasses():Array
		{
			return signal.valueClasses;
		}
		
		public function set valueClasses(value:Array):void
		{
			signal.valueClasses = value;
		}
		
		public function addEventListener (type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false) : void
		{
			dispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		public function dispatchEvent (event:Event) : Boolean
		{
			return dispatcher.dispatchEvent(event);
		}
		
		public function hasEventListener (type:String) : Boolean
		{
			return dispatcher.hasEventListener(type);
		}
		
		public function removeEventListener (type:String, listener:Function, useCapture:Boolean = false) : void
		{
			dispatcher.removeEventListener (type, listener, useCapture);
		}
		
		public function toString () : String
		{
			return dispatcher.toString();
		}
		
		public function willTrigger (type:String) : Boolean
		{
			return dispatcher.willTrigger(type);
		}
	}

}