package imag.masdar.core.view.away3d.display.shell.dotScrollbr.materials.methods
{
	import away3d.arcane;
	import away3d.core.managers.Stage3DProxy;
	import away3d.materials.compilation.ShaderRegisterCache;
	import away3d.materials.compilation.ShaderRegisterElement;
	import away3d.materials.methods.EffectMethodBase;
	import away3d.materials.methods.MethodVO;
	import flash.display3D.Context3DProgramType;

	use namespace arcane;

	public class _AlphaBlend extends EffectMethodBase
	{
		private var _fragmentData : Vector.<Number>;
		
		private var _tintColour : uint;
		
		public function _AlphaBlend(tintColour : uint = 0xFF8080)
		{
			super();
			_fragmentData = new Vector.<Number>(4);
			this.tintColour = tintColour;
		}

		override arcane function initVO(vo : MethodVO) : void
		{
			vo.needsProjection = true;
		}

		public function get tintColour() : uint
		{
			return _tintColour;
		}

		public function set tintColour(value : uint) : void
		{
			_tintColour = value;
			_fragmentData[0] = ((value >> 16) & 0xff)/0xff;
			_fragmentData[1] = ((value >> 8) & 0xff)/0xff;
			_fragmentData[2] = (value & 0xff) / 0xff;
			_fragmentData[3] = 2; 
		}

		arcane override function activate(vo : MethodVO, stage3DProxy : Stage3DProxy) : void
		{
			stage3DProxy.context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 24, _fragmentData, 1);
		}

		arcane override function getFragmentCode(vo : MethodVO, regCache : ShaderRegisterCache, targetReg : ShaderRegisterElement) : String
		{
			return "// \n mul ft1.x, ft1.x, v6.w \n" + 
					"mul ft1.x, ft1.x, fc24.w \n" + 
					"mov ft0.rgb, fc24.rgb \n";
		}
	}
}
