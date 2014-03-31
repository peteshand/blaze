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
	
	public class IndexAlphaFadeMethod extends EffectMethodBase 
	{
		private var _fragmentData : Vector.<Number>;
		
		private var _fraction:Number = 0;
		private var fadeLength:Number = 1;
		
		private var updateColour:Boolean = false;
		private var startColour:uint;
		private var _startR:Number = 0;
		private var _startG:Number = 0;
		private var _startB:Number = 0;
		
		private var endColour:uint;
		private var _endR:Number = 0;
		private var _endG:Number = 0;
		private var _endB:Number = 0;
		
		public function IndexAlphaFadeMethod(_fadeLength:Number) 
		{
			super();
			fadeLength = _fadeLength;
			
			_fragmentData = new Vector.<Number>(12);
			updateVertexData();
		}
		
		public function setColour(_startColour:uint, _endColour:uint):void
		{
			updateColour = true;
			startColour = _startColour;
			
			_startR = ((startColour >> 16) & 0xff)/0xff;
			_startG = ((startColour >> 8) & 0xff)/0xff;
			_startB = (startColour & 0xff) / 0xff;
			
			endColour = _endColour;
			_endR = ((endColour >> 16) & 0xff)/0xff;
			_endG = ((endColour >> 8) & 0xff)/0xff;
			_endB = (endColour & 0xff) / 0xff;
		}
		
		public function updateVertexData():void
		{
			
		}
		
		
		arcane override function getFragmentCode (vo:MethodVO, regCache:ShaderRegisterCache, targetReg:ShaderRegisterElement) : String
		{
			//Debug.active = true;
			
			var code:String = "";
			code += "";
			
			//fraction
			//locZ //(0 - 2)
			
			//alpha = locZ + fraction
			
			code += "add ft3.w, v1.z, fc5.x \n"; //alpha = locZ + fraction
			code += "div ft3.w, ft3.w, fc5.y \n"; //alpha = alpha / fadeLength
			code += "mul ft1.x, ft1.x, ft3.w \n";
			
			if (updateColour){
				code += "mul ft0.x, fc6.x, v1.z \n";
				code += "mul ft0.y, fc6.y, v1.z \n";
				code += "mul ft0.z, fc6.z, v1.z \n";
				
				code += "sub ft2.w, fc5.w, v1.z \n";
				code += "mul ft2.x, fc7.x, ft2.w \n";
				code += "mul ft2.y, fc7.y, ft2.w \n";
				code += "mul ft2.z, fc7.z, ft2.w \n";
				
				code += "add ft0.x, ft0.x, ft2.x \n";
				code += "add ft0.y, ft0.y, ft2.y \n";
				code += "add ft0.z, ft0.z, ft2.z \n";
			}
			
			return code;
		}
		
		arcane override function getVertexCode (vo:MethodVO, regCache:ShaderRegisterCache) : String
		{
			return "";
		}
		
		arcane override function activate(vo : MethodVO, stage3DProxy : Stage3DProxy) : void
		{
			var context : Context3D = stage3DProxy._context3D;
			
			_fragmentData[0] = ((fraction - 1) * (1 + (fadeLength * 2))) + fadeLength;
			_fragmentData[1] = fadeLength;
			_fragmentData[2] = 0;
			_fragmentData[3] = 1;
			
			_fragmentData[4] = _startR;
			_fragmentData[5] = _startG;
			_fragmentData[6] = _startB;
			_fragmentData[7] = 0;
			
			_fragmentData[8] = _endR;
			_fragmentData[9] = _endG;
			_fragmentData[10] = _endB;
			_fragmentData[11] = 0;
			
			context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 5, _fragmentData, 3);
			
			//vo.fragmentData[vo.fragmentConstantsIndex] = _alpha;
			//context.setTextureAt(vo.texturesIndex, _cubeTexture.getTextureForStage3D(stage3DProxy));
			//if (_mask)
			//	context.setTextureAt(vo.texturesIndex+1, _mask.getTextureForStage3D(stage3DProxy));
		}
		
		override arcane function setRenderState(vo : MethodVO, renderable : IRenderable, stage3DProxy : Stage3DProxy, camera : Camera3D) : void
		{
			var context : Context3D = stage3DProxy._context3D;
			context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 5, _fragmentData, 3);
		}
		
		public function get fraction():Number 
		{
			return _fraction;
		}
		
		public function set fraction(value:Number):void 
		{
			_fraction = value;
			//_fraction = value;
		}
	}
}