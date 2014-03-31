package imag.masdar.core.view.away3d.materials.methods 
{
	import away3d.arcane;
	import away3d.cameras.Camera3D;
	import away3d.core.base.IRenderable;
	import away3d.core.managers.Stage3DProxy;
	import away3d.debug.Debug;
	import away3d.materials.compilation.ShaderRegisterCache;
	import away3d.materials.compilation.ShaderRegisterElement;
	import away3d.materials.methods.EffectMethodBase;
	import away3d.materials.methods.MethodVO;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.geom.Vector3D;
	/**
	 * ...
	 * @author Pete Shand
	 */
	
	use namespace arcane;
	
	public class ColourMethod extends EffectMethodBase 
	{
		private var _vertexData : Vector.<Number>;
		
		private var _colour:uint = 0xFFFFFF;
		
		public function ColourMethod() 
		{
			super();
			
			_vertexData = new Vector.<Number>(4);
		}
		
		arcane override function getFragmentCode (vo:MethodVO, regCache:ShaderRegisterCache, targetReg:ShaderRegisterElement) : String
		{
			//Debug.active = true;
			
			var code:String = "";
			code += "mov ft0.xyz, fc5.xyz \n";
			
			return code;
		}
		
		arcane override function getVertexCode (vo:MethodVO, regCache:ShaderRegisterCache) : String
		{
			return "";
		}
		
		arcane override function activate(vo : MethodVO, stage3DProxy : Stage3DProxy) : void
		{
			var context : Context3D = stage3DProxy._context3D;
			
			_vertexData[0] = (colour >> 16 & 0xFF) / 0xFF;
			_vertexData[1] = (colour >> 8 & 0xFF) / 0xFF;
			_vertexData[2] = (colour & 0xFF) / 0xFF;
			_vertexData[3] = 1;
			
			context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 5, _vertexData, 1);
		}
		
		override arcane function setRenderState(vo : MethodVO, renderable : IRenderable, stage3DProxy : Stage3DProxy, camera : Camera3D) : void
		{
			var context : Context3D = stage3DProxy._context3D;
			context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 5, _vertexData, 1);
		}
		
		
		public function get colour():uint 
		{
			return _colour;
		}
		
		public function set colour(value:uint):void 
		{
			_colour = value;
		}
	}
}