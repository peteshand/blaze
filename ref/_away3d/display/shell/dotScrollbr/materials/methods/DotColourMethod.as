package imag.masdar.core.view.away3d.display.shell.dotScrollbr.materials.methods
{
	import away3d.arcane;
	import away3d.core.managers.Stage3DProxy;
	import away3d.debug.Debug;
	import away3d.materials.compilation.ShaderRegisterCache;
	import away3d.materials.compilation.ShaderRegisterElement;
	import away3d.materials.methods.EffectMethodBase;
	import away3d.materials.methods.MethodVO;
	import flash.display3D.Context3DProgramType;

	use namespace arcane;

	public class DotColourMethod extends EffectMethodBase
	{
		private var _fragmentData : Vector.<Number>;
		private var _tintColour : uint;
		private var _highlight : uint;
		
		public function DotColourMethod(tintColour : uint = 0xFF8080, highlight:uint=0x00FF00)
		{
			super();
			_fragmentData = new Vector.<Number>(8);
			this.tintColour = tintColour;
			this.highlight = highlight;
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
			_fragmentData[0] = ((value >> 16) & 0xff) / 0xff;
			_fragmentData[1] = ((value >> 8) & 0xff) / 0xff;
			_fragmentData[2] = (value & 0xff) / 0xff;
			_fragmentData[3] = 1; 
		}
		
		public function get highlight():uint 
		{
			return _highlight;
		}
		
		public function set highlight(value:uint):void 
		{
			_highlight = value;
			_fragmentData[4] = ((value >> 16) & 0xff) / 0xff;
			_fragmentData[5] = ((value >> 8) & 0xff) / 0xff;
			_fragmentData[6] = (value & 0xff) / 0xff;
			_fragmentData[7] = -1; 
		}

		arcane override function activate(vo : MethodVO, stage3DProxy : Stage3DProxy) : void
		{
			stage3DProxy.context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 24, _fragmentData, 2);
		}

		arcane override function getFragmentCode(vo : MethodVO, regCache : ShaderRegisterCache, targetReg : ShaderRegisterElement) : String
		{
			var code:String = "// test \n";
			code += "mov ft3.zw, v2.ww \n"
			code += "mul ft3.z, ft3.z, fc25.w \n"
			code += "add ft3.z, ft3.z, fc24.w \n"
			code += "mov ft4.xyz, fc24.xyz \n"
			code += "mul ft4.xyz, ft4.xyz, ft3.www \n"
			code += "mov ft5.xyz, fc25.xyz \n"
			code += "mul ft5.xyz, ft5.xyz, ft3.zzz \n"
			code += "add ft4.xyz, ft4.xyz, ft5.xyz \n"
			code += "mov ft0.xyz, ft4.xyz \n";
			return code;
		}
	}
}
