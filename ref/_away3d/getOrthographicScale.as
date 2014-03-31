package imag.masdar.core.view.away3d 
{
	import away3d.cameras.Camera3D;
	import away3d.cameras.lenses.PerspectiveLens;
	/**
	 * ...
	 * @author Tom Byrne
	 */
	public function getOrthographicScale (absZ:Number, camera:Camera3D, stageWidth:Number, stageHeight:Number):Number
	{
		return (Math.abs(camera.z) + absZ) / stageHeight * Math.tan(PerspectiveLens(camera.lens).fieldOfView * Math.PI / 180 / 2) * 2;
	}

}