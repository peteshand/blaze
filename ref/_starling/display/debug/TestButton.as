package imag.masdar.core.view.starling.display.debug 
{
	import com.greensock.TweenLite;
	import starling.display.BlendMode;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.textures.Texture;
	/**
	 * ...
	 * @author Tom Byrne
	 */
	public class TestButton extends Sprite
	{
		private var _clickHandler:Function;
		private var _touchCount:int = 0;
		
		public function TestButton(text:String, clickHandler:Function=null, x:Number=0, y:Number=0, width:Number = 200, height:Number = 80, colour:uint=0xff558866) 
		{
			var backing:Image = new Image(Texture.fromColor(width, height, colour));
			addChild(backing);
			
			addChild(new TextField(width, height, text, "Verdana", 20));
			
			this.x = x;
			this.y = y;
			
			this.flatten();
			
			this.useHandCursor = true;
			
			_clickHandler = clickHandler;
			addEventListener(TouchEvent.TOUCH, onTouch);
		}
	
		private function onTouch(e:TouchEvent):void 
		{
			var touches:Vector.<Touch> = e.touches;
			for each(var touch:Touch in touches) {
				if (touch.phase == TouchPhase.BEGAN) {
					if (_clickHandler != null)_clickHandler();
					
					_touchCount++;
				}else if (touch.phase == TouchPhase.ENDED) {
					_touchCount--;
				}
			}
		}
	}

}