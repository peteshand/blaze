package blaze.behaviors 
{
	import imag.masdar.core.BaseObject;
	
	/**
	 * ...
	 * @author Pete Shand
	 */
	public class BaseTouchBehavior extends BaseObject 
	{
		public var active:Boolean = true;
		
		protected var useStageForRelease:Boolean = false;
		protected var pressCooldownActive:Boolean = false;
		protected var releaseCooldownActive:Boolean = false;
		protected var cooldownTime:Number = 0.2;
		
		protected var Begin:Function = DefaultTouchFunction;
		protected var Move:Function = DefaultTouchFunction;
		protected var End:Function = DefaultTouchFunction;
		protected var Over:Function = DefaultTouchFunction;
		protected var Out:Function = DefaultTouchFunction;
		protected var Hover:Function = DefaultTouchFunction;
		
		public function BaseTouchBehavior(Begin:Function, Move:Function, End:Function, Over:Function, Out:Function, Hover:Function=null) 
		{
			if (Begin != null) this.Begin = Begin;
			if (Move != null) this.Move = Move;
			if (End != null) this.End = End;
			if (Over != null) this.Over = Over;
			if (Out != null) this.Out = Out;
			if (Hover != null) this.Hover = Hover;
		}
		
		protected function OnCooldownPressComplete():void 
		{
			pressCooldownActive = false;
		}
		protected function OnCooldownReleaseComplete():void 
		{
			releaseCooldownActive = false;
		}
		
		protected function DefaultTouchFunction(touch:*):void
		{
			
		}
	}

}