package imag.masdar.core.view.starling.display.shell.slidebar_old 
{
	import com.imagination.ge.core.ui.view.baseClasses.StarlingSpriteBase;
	import com.imagination.ge.core.view.ui.scrollingPanel.ScrollController;
	import starling.display.Shape;
	
	/**
	 * ...
	 * @author Pete Shand
	 */
	public class ScrollBarExample extends StarlingSpriteBase 
	{
		private var shape:Shape;
		private var scrollController:ScrollController;
		
		public function ScrollBarExample() 
		{
			shape = new Shape();
			addChild(shape);
			shape.graphics.beginFill(0xFF0000);
			shape.graphics.drawRect(0, 0, 200, 30);
			
			scrollController = new ScrollController(this, false);
		}
	}
}