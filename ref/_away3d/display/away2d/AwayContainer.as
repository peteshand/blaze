package imag.masdar.core.view.away3d.display.away2d 
{
	import com.greensock.TweenLite;
	import flash.display.DisplayObject;
	import imag.masdar.core.model.assetPool.AssetObject;
	import imag.masdar.core.model.assetPool.ContainerCheck;
	import imag.masdar.core.view.away3d.display.base.AlignmentContainer3D;
	import imag.masdar.core.view.away3d.display.base.BaseAwayObject;
	import imag.masdar.core.view.away3d.display.base.PrimordialObjectContainer3D;
	import org.osflash.signals.Signal;
	
	/**
	 * ...
	 * @author P.J.Shand
	 */
	public class AwayContainer extends BaseAwayObject 
	{
		private var assetObjects:Vector.<AssetObject> = new Vector.<AssetObject>();
		private var children:Vector.<AlignmentContainer3D> = new Vector.<AlignmentContainer3D>();
		public var OnInit:Signal = new Signal();
		
		public function AwayContainer(displayObject:DisplayObject, languageIndex:int) 
		{
			super();
			
			this.name = displayObject.name;
			this.languageIndex = languageIndex;
			
			var convertChildren:Vector.<DisplayObject> = ContainerCheck.convertChild(displayObject);
			for (var i:int = 0; i < convertChildren.length; i++) 
			{
				var assetObject:AssetObject = new AssetObject(convertChildren[i]);
				assetObjects.push(assetObject);
				//assetObject.addAwayObjectToContainer(this, languageIndex);
			}
			
			if (model.texturePacker.callRestrictor.remainingCalls == 0) {
				TweenLite.delayedCall(1, OnTexturesReady, null, true);
			}
			else {
				model.texturePacker.ready.addOnce(OnTexturesReady);
			}
			
		}
		
		private function OnTexturesReady():void 
		{
			trace("OnTexturesReady");
			for (var i:int = 0; i < assetObjects.length; i++) 
			{
				assetObjects[i].addAwayObjectToContainer(this, languageIndex);
			}
			for (var j:int = 0; j < this.numChildren; j++) 
			{
				children.push(getChildAt(j));
				if (!showing) children[j].alpha = 0;
			}
			Hide();
			OnInit.dispatch();
		}
		
		override public function Show():void
		{
			super.Show();
			for (var i:int = 0; i < children.length; i++) children[i].Show();
		}
		
		override public function Hide():void
		{
			super.Hide();
			for (var i:int = 0; i < children.length; i++) children[i].Hide();
		}
		
		override public function set sceneIndex(value:int):void
		{
			super.sceneIndex = value;
			for (var i:int = 0; i < children.length; i++) children[i].sceneIndex = value;
		}
		
		override public function set languageIndex(value:int):void
		{
			super.languageIndex = value;
			for (var i:int = 0; i < children.length; i++) children[i].languageIndex = value;
		}
		
		override public function set sceneIndices(value:Array):void
		{
			super.sceneIndices = value;
			for (var i:int = 0; i < children.length; i++) children[i].sceneIndices = value;
		}
	}
}