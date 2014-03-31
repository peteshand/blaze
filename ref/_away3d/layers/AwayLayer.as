package imag.masdar.core.view.away3d.layers 
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
	public class AwayLayer extends BaseAwayLayer 
	{
		protected var assets:CoreAssets;
		protected var config:CoreConfig;
		protected var control:CoreControl;
		protected var model:CoreModel;
		protected var services:CoreServices;
		protected var view:CoreView;
		
		public function AwayLayer() 
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