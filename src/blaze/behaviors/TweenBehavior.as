package blaze.behaviors 
{
	import com.greensock.TweenLite;
	
	/**
	 * ...
	 * @author P.J.Shand
	 */
	public class TweenBehavior 
	{
		protected var showTweenLite:TweenLite = new TweenLite(this, 0, {});
		protected var hideTweenLite:TweenLite = new TweenLite(this, 0, {});
		public var tweenVO:TweenVO = new TweenVO();
		public var animationShowHide:Boolean = false;
		public var visOnHide:Boolean = false;
		
		private var OnHideComplete:Function;
		private var OnShowComplete:Function;
		private var OnTweenHideStart:Function;
		private var OnTweenShowStart:Function;
		
		public function TweenBehavior(target:Object, OnHideComplete:Function=null, OnShowComplete:Function=null, OnTweenHideStart:Function=null, OnTweenShowStart:Function=null) 
		{
			tweenVO.target = target;
			this.OnHideComplete = OnHideComplete;
			this.OnShowComplete = OnShowComplete;
			this.OnTweenHideStart = OnTweenHideStart;
			this.OnTweenShowStart = OnTweenShowStart;
			
			if (OnHideComplete != null) tweenVO.addHideProperty( { onComplete:OnHideComplete } );
			if (OnShowComplete != null) tweenVO.addShowProperty( { onComplete:OnShowComplete } );
			tweenVO.addHideProperty( { onStart:OnLocalTweenHideStart } );
			tweenVO.addShowProperty( { onStart:OnLocalTweenShowStart } );
		}
		
		private function OnLocalTweenShowStart():void 
		{
			hideTweenLite.kill();
			if (OnTweenShowStart != null) OnTweenShowStart();
		}
		
		private function OnLocalTweenHideStart():void 
		{
			showTweenLite.kill();
			if (OnTweenHideStart != null) OnTweenHideStart();
		}
		
		public function Show():void
		{
			if (animationShowHide) {
				hideTweenLite.kill();
				TweenLite.killTweensOf(tweenVO.target);
				showTweenLite = TweenLite.to(tweenVO.target, tweenVO.showTime, tweenVO.ShowProperties );
			}
			else OnShowComplete();
		}
		
		public function Hide():void
		{
			if (animationShowHide) {
				showTweenLite.kill();
				TweenLite.killTweensOf(tweenVO.target);
				hideTweenLite = TweenLite.to(tweenVO.target, tweenVO.hideTime, tweenVO.HideProperties );
			}
			else OnHideComplete();
		}
		
		public function addShowProperty(propertiesToAdd:Object):void
		{
			tweenVO.addShowProperty(propertiesToAdd);
			checkTweenProperties();
		}
		
		public function removeShowProperty(propertiesToRemove:Object):void
		{
			tweenVO.removeShowProperty(propertiesToRemove);
			checkTweenProperties();
		}
		
		public function addHideProperty(propertiesToAdd:Object):void
		{
			tweenVO.addHideProperty(propertiesToAdd);
			checkTweenProperties();
		}
		
		public function removeHideProperty(propertiesToRemove:Object):void
		{
			tweenVO.removeHideProperty(propertiesToRemove);
			checkTweenProperties();
		}
		
		private function checkTweenProperties():void 
		{
			if (tweenVO.numOfTweenProperties == 0) animationShowHide = false;
			else animationShowHide = true;
		}
		
		public function get target():Object 
		{
			return tweenVO.target;
		}
		
		public function set target(value:Object):void 
		{
			tweenVO.target = value;
		}
		
	}
}

class TweenVO 
{
	public var target:Object;
	public var showTime:Number;
	public var hideTime:Number;
	public var showDelay:Number;
	public var hideDelay:Number;
	
	public var ShowProperties:Object;
	public var HideProperties:Object;
	
	public function TweenVO(showTime:Number=0.5, hideTime:Number=0.5, showDelay:Number=0.5, hideDelay:Number=0)
	{
		this.showTime = showTime;
		this.hideTime = hideTime;
		this.showDelay = showDelay;
		this.hideDelay = hideDelay;
		
		ShowProperties = { delay:showDelay };
		HideProperties = { delay:hideDelay };
	}
	
	public function addShowProperty(propertiesToAdd:Object):void
	{ addProperty(ShowProperties, propertiesToAdd); }
	
	public function removeShowProperty(propertiesToRemove:Object):void
	{ removeProperty(ShowProperties, propertiesToRemove); }
	
	public function addHideProperty(propertiesToAdd:Object):void
	{ addProperty(HideProperties, propertiesToAdd); }
	
	public function removeHideProperty(propertiesToRemove:Object):void
	{ removeProperty(HideProperties, propertiesToRemove); }
	
	private function addProperty(baseProperties:Object, propertiesToAdd:Object):void
	{
		for (var property:String in propertiesToAdd) baseProperties[property] = propertiesToAdd[property];
	}
	
	private function removeProperty(baseProperties:Object, propertiesToRemove:Object):void
	{
		for (var property:String in propertiesToRemove) {
			if (baseProperties.hasOwnProperty(property)) delete(baseProperties[property])
		}
	}
	
	public function copyTimings(base:TweenVO):void
	{
		this.showTime = base.showTime;
		this.hideTime = base.hideTime;
		this.showDelay = base.showDelay;
		this.hideDelay = base.hideDelay;
	}
	
	public function clone():TweenVO
	{
		var cloneTween:TweenVO = new TweenVO(this.showTime, this.hideTime, this.showDelay, this.hideDelay);
		cloneTween.ShowProperties = new Object();
		cloneTween.HideProperties = new Object();
		cloneTween.target = target;
		
		for (var property:String in ShowProperties) {
			cloneTween.ShowProperties[property] = ShowProperties[property];
		}
		for (var property2:String in HideProperties) cloneTween.HideProperties[property2] = HideProperties[property2];
		
		return cloneTween;
	}
	
	private var _numOfTweenProperties:int = 0;
	public function get numOfTweenProperties():Boolean 
	{
		_numOfTweenProperties = 0;
		var isFunction:Boolean;
		for (var property:String in ShowProperties) {
			isFunction = ShowProperties[property] is Function;
			if (property != "delay" && !isFunction) _numOfTweenProperties++;
		}
		
		for (var property2:String in HideProperties) {
			isFunction = HideProperties[property2] is Function;
			if (property2 != "delay" && !isFunction) _numOfTweenProperties++;
		}
		if (_numOfTweenProperties == 0) return false;
		else return true;
	}
}