package imag.masdar.core.view.starling.layers 
{
	import imag.masdar.core.assets.CoreAssets;
	import imag.masdar.core.config.CoreConfig;
	import imag.masdar.core.control.CoreControl;
	import imag.masdar.core.model.CoreModel;
	import imag.masdar.core.services.CoreServices;
	import imag.masdar.core.view.CoreView;
	
	/**
	 * ...
	 * @author Pete Shand
	 */
	public class StarlingLayer extends BaseStarlingLayer 
	{
		protected var assets:CoreAssets;
		protected var config:CoreConfig;
		protected var control:CoreControl;
		protected var model:CoreModel;
		protected var services:CoreServices;
		protected var view:CoreView;
		
		public function StarlingLayer() 
		{
			super();
			assets = core.assets;
			config = core.config;
			control = core.control;
			model = core.model;
			services = core.services;
			view = core.view;
			
			this.active = true;
		}
	}
}