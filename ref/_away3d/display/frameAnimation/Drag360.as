package imag.masdar.core.view.away3d.display.frameAnimation 
{
	import away3d.events.Touch;
	import com.greensock.TweenLite;
	import flash.geom.Point;
	import imag.masdar.core.view.away3d.display.base.BaseAwayObject;
	
	/**
	 * ...
	 * @author P.J.Shand
	 */
	public class Drag360 extends BaseAwayObject 
	{
		private var frameAnimation:FrameAnimation;
		private var touchFrame:int;
		private var touchLoc:Point = new Point();
		private var targetFrame:int = 0;
		private var currentFrame:int = 0;
		
		public function Drag360(dataID:String) 
		{
			super();
			frameAnimation = new FrameAnimation(dataID, false);
			addChild(frameAnimation);
			
			attachTouchListenerTo(frameAnimation.mesh, null, true);
		}
		
		override protected function OnTouchBegin(touch:Touch):void
		{
			TweenLite.killDelayedCallsTo(DelayStopUpdate);
			touchFrame = currentFrame;
			touchLoc.x = touch.globalX;
			
			model.tick.render.add(OnTick);
		}
		
		override protected function OnTouchMove(touch:Touch):void
		{
			targetFrame = int(touchFrame + ((touchLoc.x - touch.globalX) / 5));
		}
		
		override protected function OnTouchEnd(touch:Touch):void
		{
			TweenLite.delayedCall(2, DelayStopUpdate );
		}
		
		private function DelayStopUpdate():void 
		{
			model.tick.render.remove(OnTick);
		}
		
		private function OnTick(timeDelta:Number):void 
		{
			currentFrame = ((currentFrame * 9) + targetFrame) / 10;
			frameAnimation.currentFrame = currentFrame;
		}
		
		override public function Show():void
		{
			super.Show();
			frameAnimation.Show();
		}
		
		override public function Hide():void
		{
			super.Hide();
			frameAnimation.Hide();
		}
	}
}