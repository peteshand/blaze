package imag.masdar.core.view.away3d.materials.methods 
{
	import away3d.arcane;
	import away3d.cameras.Camera3D;
	import away3d.core.base.IRenderable;
	import away3d.core.managers.Stage3DProxy;
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
	
	public class PathMethod extends EffectMethodBase 
	{
		private var _vertexData : Vector.<Number>;
		
		private var _percentage:Number = 0;
		private var _loc1:Vector3D = new Vector3D( -200, -200, 0);
		private var _loc2:Vector3D = new Vector3D( 200, 200, 0);
		private var _loc3:Vector3D = new Vector3D( 200, -400, 0);
		private var _loc4:Vector3D = new Vector3D( 500, 0, 0);
		private var _alpha:Number = 1;
		
		public function PathMethod() 
		{
			super();
			preTransfer = true;
			_vertexData = new Vector.<Number>(8);
			updateVertexData();
		}
		
		public function updateVertexData():void
		{
			_vertexData[0] = percentage;
			_vertexData[1] = 0;
			_vertexData[2] = 0;
			_vertexData[3] = alpha;
			
			_vertexData[4] = loc1.x;
			_vertexData[5] = loc1.y;
			_vertexData[6] = loc1.z;
			_vertexData[7] = 0;
			
			_vertexData[8] = loc2.x;
			_vertexData[9] = loc2.y;
			_vertexData[10] = loc2.z;
			_vertexData[11] = 0;
			
			_vertexData[12] = loc3.x;
			_vertexData[13] = loc3.y;
			_vertexData[14] = loc3.z;
			_vertexData[15] = 0;
			
			_vertexData[16] = loc4.x;
			_vertexData[17] = loc4.y;
			_vertexData[18] = loc4.z;
			_vertexData[19] = 0;
			
			
		}
		
		
		arcane override function getFragmentCode (vo:MethodVO, regCache:ShaderRegisterCache, targetReg:ShaderRegisterElement) : String
		{
			return "mul ft1.x, ft1.x, v1.w \n";
		}
		
		arcane override function getVertexCode (vo:MethodVO, regCache:ShaderRegisterCache) : String
		{
			return  "mov vt1.xy, vc25.xy \n" + // move point 1 in vt1
					"sub vt1.xy, vt1.xy, vc26.xy \n" + // Place difference between point 1 and point 2 in vt1
					"mul vt1.xy, vt1.xy, vc24.xx \n" + // Multiple difference percentage
					"sub vt1.xy, vt1.xy, vc25.xy \n" + 
					"sub vt1.xy, vt0.xy, vt1.xy \n" + 
					
					"mov vt2.xy, vc26.xy \n" + // move point 2 in vt2
					"sub vt2.xy, vt2.xy, vc27.xy \n" + // Place difference between point 2 and point 3 in vt2
					"mul vt2.xy, vt2.xy, vc24.xx \n" + // Multiple difference percentage
					"sub vt2.xy, vt2.xy, vc26.xy \n" + 
					"sub vt2.xy, vt0.xy, vt2.xy \n" + 
					
					"mov vt3.xy, vc27.xy \n" + // move point 3 in vt3
					"sub vt3.xy, vt3.xy, vc28.xy \n" + // Place difference between point 3 and point 4 in vt3
					"mul vt3.xy, vt3.xy, vc24.xx \n" + // Multiple difference percentage
					"sub vt3.xy, vt3.xy, vc27.xy \n" + 
					"sub vt3.xy, vt0.xy, vt3.xy \n" + 
					
					"sub vt4.xy, vt1.xy, vt2.xy \n" + // Place difference between "resulting point 1" and "resulting point 2" in vt4
					"mul vt4.xy, vt4.xy, vc24.xx \n" + // Multiple difference percentage
					"sub vt4.xy, vt4.xy, vt1.xy \n" + 
					"sub vt4.xy, vt0.xy, vt4.xy \n" + 
					
					"sub vt5.xy, vt2.xy, vt3.xy \n" + // Place difference between "resulting point 2" and "resulting point 3" in vt5
					"mul vt5.xy, vt5.xy, vc24.xx \n" + // Multiple difference percentage
					"sub vt5.xy, vt5.xy, vt2.xy \n" + 
					"sub vt5.xy, vt0.xy, vt5.xy \n" + 
					
					"sub vt7.xy, vt4.xy, vt5.xy \n" + // Place difference between calc 1 point and calc 2 point in vt7
					"mul vt7.xy, vt7.xy, vc24.xx \n" + // Multiple difference percentage
					"add vt0.xy, vt0.xy, vt4.xy \n" + // Add point calc 1 point to base vertex
					"sub vt0.xy, vt0.xy, vt7.xy \n" + // Add percentage differnce to base vertex
					"mov v1.xyzw, vc24.xyzw \n";
		}
		
		arcane override function activate(vo : MethodVO, stage3DProxy : Stage3DProxy) : void
		{
			var context : Context3D = stage3DProxy._context3D;
			
			context.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 24, _vertexData, 5);
			
			//vo.fragmentData[vo.fragmentConstantsIndex] = _alpha;
			//context.setTextureAt(vo.texturesIndex, _cubeTexture.getTextureForStage3D(stage3DProxy));
			//if (_mask)
			//	context.setTextureAt(vo.texturesIndex+1, _mask.getTextureForStage3D(stage3DProxy));
		}
		
		public function get percentage():Number 
		{
			return _percentage;
		}
		
		public function set percentage(value:Number):void 
		{
			_percentage = value;
		}
		
		public function get loc1():Vector3D 
		{
			return _loc1;
		}
		
		public function set loc1(value:Vector3D):void 
		{
			_loc1 = value;
			updateVertexData();
		}
		
		public function get loc2():Vector3D 
		{
			return _loc2;
		}
		
		public function set loc2(value:Vector3D):void 
		{
			_loc2 = value;
		}
		
		public function get loc3():Vector3D 
		{
			return _loc3;
		}
		
		public function set loc3(value:Vector3D):void 
		{
			_loc3 = value;
		}
		
		public function get loc4():Vector3D 
		{
			return _loc4;
		}
		
		public function set loc4(value:Vector3D):void 
		{
			_loc4 = value;
		}
		
		public function get alpha():Number 
		{
			return _alpha;
		}
		
		public function set alpha(value:Number):void 
		{
			_alpha = value;
		}
		
		override arcane function setRenderState(vo : MethodVO, renderable : IRenderable, stage3DProxy : Stage3DProxy, camera : Camera3D) : void
		{
			var context : Context3D = stage3DProxy._context3D;
			context.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 24, _vertexData, 5);
		}
		//override arcane function render(renderable : IRenderable, stage3DProxy : Stage3DProxy, camera : Camera3D, viewProjection : Matrix3D) : void
		//{
			//trace("wave render");
			//var context : Context3D = stage3DProxy._context3D;
			//_matrix.copyFrom(renderable.sceneTransform);
			//_matrix.append(viewProjection);
			//renderable.activateVertexBuffer(0, stage3DProxy);
			//context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, _matrix, true);
			//context.drawTriangles(renderable.getIndexBuffer(stage3DProxy), 0, renderable.numTriangles);
		//}
	}

}