package blaze.model.language 
{
	import flash.events.Event;
	import org.osflash.signals.Signal;
	
	/**
	 * ...
	 * @author Pete Shand
	 */
	public class LanguageModel
	{
		/*protected static var _allowInstantiate:Boolean;
		protected static var _instance:LanguageModel;
		
		public function LanguageModel()
		{
			if (!_allowInstantiate)
			{
				throw new Error("LanguageModel can only be accessed through LanguageModel.getInstance()");
			}
		}
		
		public static function getInstance():LanguageModel
		{
			if (!_instance) {
				_allowInstantiate = true;
				_instance = new LanguageModel();
				_allowInstantiate = false;
			}
			return _instance;
		}*/
		
		private var currentLanguageVO:LanguageVO;
		private var languages:Vector.<LanguageVO> = new Vector.<LanguageVO>();
		public var updateSignal:Signal = new Signal();
		public var lastIndex:int = 0;
		
		public function LanguageModel():void
		{
			
		}
		
		public function createLanguage(languageVO:LanguageVO):void
		{
			if (!currentLanguageVO) currentLanguageVO = languageVO;
			languages.push(languageVO);
		}
		public function get languageID():String 
		{
			if (currentLanguageVO && !currentLanguageVO.id) throw new Error("default languageID not set"); 
			return currentLanguageVO.id;
		}
		
		public function set languageID(value:String):void 
		{
			var temp:LanguageVO = languageAvailable(value);
			if (currentLanguageVO.id != temp.id && temp != null) {
				currentLanguageVO = temp;
				updateSignal.dispatch();
			}
		}
		
		private function languageAvailable(value:String):LanguageVO 
		{
			for (var i:int = 0; i < languages.length; ++i) {
				if (languages[i].id == value) return languages[i];
			}
			return null;
		}
		
		public function get index():int 
		{
			if (!currentLanguageVO) throw new Error("default index not set"); 
			return currentLanguageVO.index;
		}
		
		public function set index(value:int):void 
		{
			if (value >= languages.length) value = 0;
			lastIndex = index;
			var temp:LanguageVO = indexAvailable(value);
			if (currentLanguageVO.id != temp.id && temp != null) {
				currentLanguageVO = temp;
				updateSignal.dispatch();
			}
		}
		
		private function indexAvailable(value:int):LanguageVO 
		{
			for (var i:int = 0; i < languages.length; ++i) {
				if (languages[i].index == value) return languages[i];
			}
			return null;
		}
		
		public function toggle():void
		{
			if (currentLanguageVO && languages.length > 1) {
				var newIndex:int = currentLanguageVO.index + 1;
				index = newIndex;
			}
		}
	}
}

class LanguageVO 
{
	public var index:int;
	public var id:String;
	
	public function LanguageVO(_index:int, _id:String) 
	{
		index = _index;
		id = _id;
	}
}