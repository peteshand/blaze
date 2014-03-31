package imag.masdar.core.view.away3d.materials.pass 
{
	import away3d.arcane;
	import away3d.cameras.Camera3D;
	import away3d.core.base.IRenderable;
	import away3d.core.managers.Stage3DProxy;
	import away3d.materials.passes.MaterialPassBase;
	import away3d.textures.Texture2DBase;

	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.geom.Matrix3D;

	use namespace arcane;

	/**
	 * TrivialTexturePass is a pass rendering an unshaded texture
	 */
	public class TrivialTexturePass extends MaterialPassBase
	{
		private var _matrix : Matrix3D = new Matrix3D();

		private var _texture : Texture2DBase;
		
		private var _color : uint;
		private var _fragmentData : Vector.<Number>;
		
		private var _amplitude:Number = 1;
		private var _frequency:Number = 10;
		private var _offset:Number = 0;
		
		public function TrivialTexturePass(texture : Texture2DBase)
		{
			super();
			_texture = texture;
			
			_fragmentData = new Vector.<Number>(4);
			updateFragmentData();
		}
		
		public function get texture() : Texture2DBase
		{
			return _texture;
		}

		public function set texture(value : Texture2DBase) : void
		{
			_texture = value;
		}
		
		public function get amplitude():Number 
		{
			return _amplitude;
		}
		
		public function set amplitude(value:Number):void 
		{
			_amplitude = value;
			updateFragmentData();
		}
		
		public function get frequency():Number 
		{
			return _frequency;
		}
		
		public function set frequency(value:Number):void 
		{
			_frequency = value;
			updateFragmentData();
		}
		
		public function get offset():Number 
		{
			return _offset;
		}
		
		public function set offset(value:Number):void 
		{
			_offset = value;
			updateFragmentData();
		}
		
		private function updateFragmentData():void
		{
			_fragmentData[0] = amplitude;
			_fragmentData[1] = frequency;
			_fragmentData[2] = offset;
			_fragmentData[3] = 1;
		}

		/**
		 * Get the vertex shader code for this shader
		 */
		override arcane function getVertexCode() : String
		{
			//
			// transform to view space and pass on uv coords to the fragment shader
			// add t a b - Add a and b, put result in t.
			return  "mov vt3, va0\n" +
					"add vt3.xyzw, vt3.xyzw, vc2.xyzy\n" +
					"m44 op, vt3, vc0\n" +
					"mov v0, va1";
		}

		/**
		 * Get the fragment shader code for this shader
		 * @param fragmentAnimatorCode Any additional fragment animation code imposed by the framework, used by some animators. Ignore this for now, since we're not using them.
		 */
		override arcane function getFragmentCode(fragmentAnimatorCode : String) : String
		{
			// simply set sampled colour as output value
			return "tex oc, v0, fs0 <2d, clamp, linear, miplinear>";
		}

		/**
		 * Sets the render state which is constant for this pass
		 * @param stage3DProxy The stage3DProxy used for the current render pass
		 * @param camera The camera currently used for rendering
		 */
		override arcane function activate(stage3DProxy : Stage3DProxy, camera : Camera3D) : void
		{
			super.activate(stage3DProxy, camera);

			// retrieve the actual texture object, and assign it to slot 0 (fs0)
			// we set this in activate, not in render, because the texture is constant for this pass
			stage3DProxy._context3D.setTextureAt(0, _texture.getTextureForStage3D(stage3DProxy));
			
		}

		/**
		 * Set render state for the current renderable and draw the triangles.
		 * @param renderable The renderable that needs to be drawn.
		 * @param stage3DProxy The stage3DProxy used for the current render pass.
		 * @param camera The camera currently used for rendering.
		 * @param viewProjection The matrix that transforms world space to screen space.
		 */
		override arcane function render(renderable : IRenderable, stage3DProxy : Stage3DProxy, camera : Camera3D, viewProjection : Matrix3D) : void
		{
			var context : Context3D = stage3DProxy._context3D;
			_matrix.copyFrom(renderable.sceneTransform);
			_matrix.append(viewProjection);

			renderable.activateVertexBuffer(0, stage3DProxy);
			renderable.activateUVBuffer(1, stage3DProxy);
			
			context.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 9, _fragmentData, 1);
			
			context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, _matrix, true);
			
			
			
			
			
			context.drawTriangles(renderable.getIndexBuffer(stage3DProxy), 0, renderable.numTriangles);
		}

		/**
		 * Clear render state for the next pass.
		 * @param stage3DProxy The stage3DProxy used for the current render pass.
		 */
		override arcane function deactivate(stage3DProxy : Stage3DProxy) : void
		{
			super.deactivate(stage3DProxy);

			var context : Context3D = stage3DProxy._context3D;

			// clear the texture and stream we set before
			// no need to clear attribute stream at slot 0, since it's always used
			context.setTextureAt(0, null);
			context.setVertexBufferAt(1, null);
		}
	}
}