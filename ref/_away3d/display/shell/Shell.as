package imag.masdar.core.view.away3d.display.shell 
{
	import com.greensock.easing.Quad;
	import com.greensock.TweenMax;
	import flash.events.Event;
	import flash.geom.Point;
	import imag.masdar.core.utils.layout.Alignment;
	import imag.masdar.core.view.away3d.display.base.BaseAwayObject;
	import imag.masdar.core.view.away3d.display.shell.dotScrollbr.DotScrollbar;
	
	/**
	 * ...
	 * @author Pete Shand
	 */
	public class Shell extends BaseAwayObject 
	{
		private var _scrollbar:DotScrollbar;
		
		public function Shell() 
		{
			if (config.horizontalScroll || config.verticalScroll) addScrollbar();
		}
		
		protected function addScrollbar():void 
		{
			var alignment:String;
			if (config.scrollbarPlacement == Alignment.TOP)			alignment = Alignment.TOP_LEFT;
			else if (config.scrollbarPlacement == Alignment.BOTTOM)	alignment = Alignment.BOTTOM_LEFT;
			else if (config.scrollbarPlacement == Alignment.LEFT)	alignment = Alignment.TOP_LEFT;
			else if (config.scrollbarPlacement == Alignment.RIGHT)	alignment = Alignment.TOP_RIGHT;
			if (alignment){
				_scrollbar = new DotScrollbar(config.horizontalScroll);
				addChildAtAlignment(_scrollbar, alignment);
			}
		}
	}
}