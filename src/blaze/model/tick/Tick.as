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
		/*protected static var _allowInstantiate:Boolean;
		protected static var _instance:Tick;
		
		public function Tick()
		{
			if (!_allowInstantiate)
			{
				throw new Error("Tick can only be accessed through Tick.getInstance()");
			}
		}
		
		public static function getInstance():Tick
		{
			if (!_instance) {
				_allowInstantiate = true;
				_instance = new Tick();
				_allowInstantiate = false;
			}
			return _instance;
		}*/
		
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