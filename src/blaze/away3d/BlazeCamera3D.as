package blaze.away3d 
{
	import away3d.cameras.Camera3D;
	import away3d.cameras.lenses.LensBase;
	import blaze.model.viewPort.ViewPort;
	
	/**
	 * ...
	 * @author P.J.Shand
	 */
	public class BlazeCamera3D extends Camera3D 
	{
		protected var viewPort:ViewPort;
		
		public function BlazeCamera3D(viewPort:ViewPort, lens:LensBase=null) 
		{
			this.viewPort = viewPort;
			super(lens);
		}
		
		override public function set z(value:Number):void
		{
			super.z = value;
			viewPort.update.dispatch();
		}
	}

}