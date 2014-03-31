package imag.masdar.core.view.displaylist.layers 
{
	import imag.masdar.core.assets.CoreAssets;
	import imag.masdar.core.config.CoreConfig;
	import imag.masdar.core.control.CoreControl;
	import imag.masdar.core.Core;
	import imag.masdar.core.model.CoreModel;
	import imag.masdar.core.services.CoreServices;
	import imag.masdar.core.view.CoreView;
	
	/**
	 * ...
	 * @author Pete Shand
	 */
	
	public class ClassicLayer extends BaseClassicLayer 
	{
		protected var assets:CoreAssets;
		protected var config:CoreConfig;
		protected var control:CoreControl;
		protected var model:CoreModel;
		protected var services:CoreServices;
		protected var view:CoreView;
		
		public function ClassicLayer() 
		{
			super();
			assets = CoreAssets(core.assets);
			config = CoreConfig(core.config);
			control = CoreControl(core.control);
			model = CoreModel(core.model);
			services = CoreServices(core.services);
			view = CoreView(core.view);
		}
	}
}