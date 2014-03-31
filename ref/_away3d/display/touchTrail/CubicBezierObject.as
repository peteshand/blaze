package imag.masdar.core.view.away3d.display.touchTrail
{
	import away3d.containers.ObjectContainer3D;
	import away3d.core.base.ISubGeometry;
	import away3d.core.base.SubGeometry;
	import away3d.debug.Debug;
	import away3d.entities.Mesh;
	import away3d.materials.TextureMaterial;
	import away3d.primitives.PlaneGeometry;
	import away3d.textures.Texture2DBase;
	import away3d.tools.commands.Merge;
	import flash.display.BlendMode;
	import flash.geom.Vector3D;
	import imag.masdar.core.view.away3d.display.base.BaseAwayObject;
	import imag.masdar.core.view.away3d.display.touchTrail.animators.TrailAnimationSet;
	import imag.masdar.core.view.away3d.display.touchTrail.animators.TrailAnimator;
	
	/**
	 * ...
	 * @author Pete Shand
	 */
	public class CubicBezierObject extends BaseAwayObject 
	{
		private var steps:int = 200;
		private var dotSize:int = 20;
		private var alphaMul:Number = 1;
		
		private var meshes:Vector.<Mesh> = new Vector.<Mesh>();
		private var receiver:Mesh;
		
		private var material:TextureMaterial;
		private var texture:Texture2DBase;
		private var geo:PlaneGeometry;
		private var mesh:Mesh;
		
		private var trailAnimationSet:TrailAnimationSet;
		private var trailAnimator:TrailAnimator;
		
		public function CubicBezierObject(steps:Number, minSize:int, maxSize:int, _texture:Texture2DBase) 
		{
			this.steps = steps;
			this.dotSize = dotSize;
			
			texture = _texture;
			
			material = new TextureMaterial(texture, true, false, false);
			material.alphaBlending = true;
			
			if (config.whiteTouchTrail){
				material.blendMode = BlendMode.ADD;
			}
			else {
				material.blendMode = BlendMode.NORMAL;
				alphaMul = 0.04;
			}
			
			var geo:PlaneGeometry = new PlaneGeometry(minSize, minSize, 1, 1, false);
			
			for (var k:int = 0; k < steps; ++k) {
				var t:Number = k / steps;
				var size:Number = minSize + ((maxSize - minSize) * t)
				var scale:Number = maxSize / size;
				var mesh:Mesh = new Mesh(geo.clone(), null);
				mesh.z = k;
				mesh.scaleX = mesh.scaleY = mesh.scaleZ = scale;
				meshes.push(mesh);
			}
			
			receiver = new Mesh(geo, material);
			addChild(receiver);
			
			var merge:Merge = new Merge(false, true);
			merge.applyToMeshes(receiver, meshes);
			
			trailAnimationSet = new TrailAnimationSet();
			trailAnimationSet.steps = steps;
			trailAnimator = new TrailAnimator(trailAnimationSet);
			receiver.animator = trailAnimator;
			
			this.alpha = 1;
		}
		
		public function get loc1():Vector3D 
		{
			return trailAnimationSet.loc1;
		}
		
		public function set loc1(value:Vector3D):void 
		{
			trailAnimationSet.loc1 = value;
		}
		
		public function get loc2():Vector3D 
		{
			return trailAnimationSet.loc2;
		}
		
		public function set loc2(value:Vector3D):void 
		{
			trailAnimationSet.loc2 = value;
		}
		
		public function get loc3():Vector3D 
		{
			return trailAnimationSet.loc3;
		}
		
		public function set loc3(value:Vector3D):void 
		{
			trailAnimationSet.loc3 = value;
		}
		
		public function get loc4():Vector3D 
		{
			return trailAnimationSet.loc4;
		}
		
		public function set loc4(value:Vector3D):void 
		{
			trailAnimationSet.loc4 = value;
		}
		
		public function updateVertexData():void
		{
			trailAnimationSet.updateVertexData();
		}
		
		override public function set alpha(value:Number):void
		{
			super.alpha = value;
			material.alpha = value * alphaMul;
		}
		
		override public function dispose():void
		{
			material.dispose();
			material = null;
			geo = null;
			receiver.dispose();
			receiver = null;
			super.dispose();
		}
	}
}