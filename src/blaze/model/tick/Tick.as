package blaze.model.tick 
{
	import flash.display.Stage;
	import flash.events.Event;
	import org.osflash.signals.Signal;
	/**
	 * ...
	 * @author P.J.Shand
	 */
	public class Tick 
	{
		private var stage:Stage;
		public var update:Signal = new Signal();
		
		public function Tick():void
		{
			
		}
		
		public function init(stage:Stage):void
		{
			this.stage = stage;
			stage.addEventListener(Event.ENTER_FRAME, Update);
		}
		
		private function Update(e:Event):void 
		{
			update.dispatch();
		}
		
	}

}