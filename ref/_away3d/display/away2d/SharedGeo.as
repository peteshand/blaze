package imag.masdar.core.view.away3d.display.away2d 
{
	import away3d.primitives.PlaneGeometry;
	/**
	 * ...
	 * @author P.J.Shand
	 */
	public class SharedGeo 
	{
		private static var _planeGeometry:PlaneGeometry;
		
		public function SharedGeo() 
		{
			
		}
		
		public static function planeGeometry():PlaneGeometry
		{
			if (!_planeGeometry) {
				trace("create shared geo");
				_planeGeometry = new PlaneGeometry(100, 100, 1, 1, false);
			}
			return _planeGeometry;
		}
	}

}