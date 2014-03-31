package imag.masdar.core.view.away3d.utils 
{
	import away3d.containers.ObjectContainer3D;
	import com.greensock.easing.Back;
	import com.greensock.easing.Quad;
	import imag.masdar.core.model.scroll.ScrollObjects;
	import imag.masdar.core.utils.layout.Alignment;
	import imag.masdar.core.utils.layout.DisplayPositioner;
	import imag.masdar.core.utils.scroll.ScrollTrigger;
	import imag.masdar.core.view.away3d.display.shell.dotScrollbr.DotScrollbar;
	import imag.masdar.core.view.trans.SlideTrans;
	
	/**
	 * ...
	 * @author Tom Byrne
	 */
	public class StandardControls3D 
	{
		private static const SCREEN_W:Number = 1920;
		private static const SCREEN_H:Number = 1080;
		
		
		public static function addHScrollBar(container:*, scroll:ScrollObjects, displayPositioner:DisplayPositioner = null, scrollTrigger:ScrollTrigger = null):DotScrollbar {
			var control:DotScrollbar = new DotScrollbar(true, scroll, false);
			control.setSize(SCREEN_W - 600, SCREEN_H);
			var parent:* = container;
			if (displayPositioner) {
				displayPositioner.addDisplay(control, control.width, 60, Alignment.BOTTOM, DisplayPositioner.SCALE_ALWAYS, DisplayPositioner.FIT_LETTERBOXED, DisplayPositioner.POS_SETTER_3D, DisplayPositioner.SIZE_SETTER);
				displayPositioner.setDisplayPadding(control, 0, 71, 80, 80);
				displayPositioner.setDisplayAnchor(control, 0, 1);
				
				if (scrollTrigger) {
					var slideContainer:ObjectContainer3D = new ObjectContainer3D();
					slideContainer.y = -300;
					
					scrollTrigger.callMethod(10, ScrollTrigger.DIR_FORWARDS, SlideTrans.slide(0, 0, 0.3, Quad.easeOut, 0, slideContainer));
					scrollTrigger.callMethod(10, ScrollTrigger.DIR_BACKWARDS, SlideTrans.slide(0, -300, 0.3, Back.easeIn, 0, slideContainer));
					
					parent = slideContainer;
					container.addChild(slideContainer);
				}
			}
			parent.addChild(control);
			return control;
		}
	}

}