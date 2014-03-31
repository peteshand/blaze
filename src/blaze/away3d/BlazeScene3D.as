package blaze.away3d 
{
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.Scene3D;
	import blaze.model.render.RenderModel;
	import blaze.model.viewPort.ViewPort;
	
	/**
	 * ...
	 * @author P.J.Shand
	 */
	public class BlazeScene3D extends Scene3D 
	{
		public var instanceIndex:int;
		
		public function BlazeScene3D(instanceIndex:int) 
		{
			super();
			this.instanceIndex = instanceIndex;
		}
		
		override public function addChild(child:ObjectContainer3D):ObjectContainer3D
		{
			if (child is BlazeContainer3D) {
				BlazeContainer3D(child).instanceIndex = instanceIndex;
			}
			return super.addChild(child);
		}
	}

}