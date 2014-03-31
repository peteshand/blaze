package imag.masdar.core.view.starling.display.shell.dotScrollbr 
{
	import imag.masdar.core.view.starling.display.base.BaseStarlingObject;
	import starling.display.Shape;
	import starling.display.Sprite;
	import starling.events.Event;
	
	/**
	 * ...
	 * @author Pete Shand
	 */
	public class DotScrollbar extends BaseStarlingObject 
	{
		private var numOfDots:int = 500;
		private var shapes:Vector.<Shape> = new Vector.<Shape>();
		
		public function DotScrollbar() 
		{
			
		}
		
		override protected function OnAdd(e:Event):void 
		{
			createDots();
		}
		
		private function createDots():void
		{
			removeDots();
			
			var shape:Shape = new Shape();
			addChild(shape);
			shape.y = 30;
			shape.x = 0;
			shapes.push(shape);
				
			for (var i:int = 0; i < numOfDots; ++i){
				shape.graphics.beginFill(0xFF0000);
				shape.graphics.drawCircle(i * 10, 0, 3);
			}
		}
		
		private function removeDots():void 
		{
			for (var i:int = 0; i < shapes.length; ++i) {
				var shape:Shape = shapes[i];
				removeChild(shape);
				shape.dispose();
				shape = null;
			}
		}
	}

}