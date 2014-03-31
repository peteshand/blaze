package imag.masdar.core.view.starling.display.slider 
{
	import flash.geom.Point;
	import imag.masdar.core.model.texturePacker.AtlasImage;
	import imag.masdar.core.view.starling.display.animations.ArrowPathAnimation;
	import imag.masdar.core.view.starling.display.animations.DragonPlaceHolder;
	import imag.masdar.core.view.starling.display.animations.GridAnimation;
	import imag.masdar.core.view.starling.display.text.StarlingTLF;
	import starling.display.DisplayObject;
	/**
	 * ...
	 * @author Pete Shand
	 */
	public class SliderChildContainerVO 
	{
		public static var TYPE_TLF:String = 'TLF';
		public static var TYPE_PRIMORDIAL:String = 'PrimordialStarlingSprite';
		public static var TYPE_BASE_SLIDE_ANIMATION:String = 'BaseSlideAnimation';
		
		private var _child:DisplayObject;
		public var middleLoc:Point = new Point();
		public var type:String;
		
		public function SliderChildContainerVO() 
		{
			
		}
		
		public function get child():DisplayObject 
		{
			return _child;
		}
		
		public function set child(value:DisplayObject):void 
		{
			_child = value;
			if (_child is StarlingTLF) type = SliderChildContainerVO.TYPE_TLF;
			if (_child is AtlasImage) type = SliderChildContainerVO.TYPE_PRIMORDIAL;
			if (_child is DragonPlaceHolder) type = SliderChildContainerVO.TYPE_PRIMORDIAL;
			
			if (_child is GridAnimation) type = SliderChildContainerVO.TYPE_BASE_SLIDE_ANIMATION;
			if (_child is ArrowPathAnimation) type = SliderChildContainerVO.TYPE_BASE_SLIDE_ANIMATION;
			
		}
		
	}

}