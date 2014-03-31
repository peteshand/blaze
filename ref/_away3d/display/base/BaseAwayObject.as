package imag.masdar.core.view.away3d.display.base 
{
	import imag.masdar.core.assets.CoreAssets;
	import imag.masdar.core.config.CoreConfig;
	import imag.masdar.core.control.CoreControl;
	import imag.masdar.core.model.CoreModel;
	import imag.masdar.core.services.CoreServices;
	import imag.masdar.core.view.away3d.display.base.AlignmentContainer3D;
	import imag.masdar.core.view.CoreView;
	
	/**
	 * ...
	 * @author Pete Shand
	 */
	public class BaseAwayObject extends AlignmentContainer3D 
	{
		protected var assets:CoreAssets;
		protected var config:CoreConfig;
		protected var control:CoreControl;
		protected var model:CoreModel;
		protected var services:CoreServices;
		protected var view:CoreView;
		
		public function BaseAwayObject() 
		{
			super();
			assets = core.assets;
			config = core.config;
			control = core.control;
			model = core.model;
			services = core.services;
			view = core.view;
		}
	}
}