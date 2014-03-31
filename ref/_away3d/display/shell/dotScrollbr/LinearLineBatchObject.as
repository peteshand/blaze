package imag.masdar.core.view.away3d.display.shell.dotScrollbr
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
	import imag.masdar.core.view.away3d.display.shell.dotScrollbr.animators.LinearLineBatchAnimationSet;
	import imag.masdar.core.view.away3d.display.shell.dotScrollbr.animators.LinearLineBatchAnimator;
	import imag.masdar.core.view.away3d.display.shell.dotScrollbr.materials.methods.DotColourMethod;
	
	/**
	 * ...
	 * @author Pete Shand
	 */
	public class LinearLineBatchObject extends ObjectContainer3D 
	{
		private var steps:int = 100;
		private var dotSize:int = 20;
		private var alphaOfEachDot:Number = 0.5;
		
		private var meshes:Vector.<Mesh> = new Vector.<Mesh>();
		private var receiver:Mesh;
		
		private var material:TextureMaterial;
		private var texture:Texture2DBase;
		private var geo:PlaneGeometry;
		private var mesh:Mesh;
		
		private var dotColourMethod:DotColourMethod;
		
		private var linearLineBatchAnimationSet:LinearLineBatchAnimationSet;
		private var linearLineBatchAnimator:LinearLineBatchAnimator;
		
		public function LinearLineBatchObject(steps:Number, baseSize:int, _texture:Texture2DBase, tintColour:uint, highlight:uint ) 
		{
			this.steps = steps;
			this.dotSize = dotSize;
			this.alphaOfEachDot = alphaOfEachDot;
			
			texture = _texture;
			
			material = new TextureMaterial(texture, true, false, false);
			material.alphaBlending = true;
			
			dotColourMethod = new DotColourMethod(tintColour, highlight);
			material.addMethod(dotColourMethod);
			
			geo = new PlaneGeometry(baseSize, baseSize, 1, 1, false, true);
			
			for (var k:int = 0; k < steps; ++k) {
				var t:Number = k / steps;
				var mesh:Mesh = new Mesh(geo.clone(), null);
				mesh.z = k;
				meshes.push(mesh);
			}
			
			receiver = new Mesh(geo, material);
			addChild(receiver);
			
			var merge:Merge = new Merge(false, true);
			merge.applyToMeshes(receiver, meshes);
			
			linearLineBatchAnimationSet = new LinearLineBatchAnimationSet();
			linearLineBatchAnimationSet.steps = steps;
			linearLineBatchAnimator = new LinearLineBatchAnimator(linearLineBatchAnimationSet);
			receiver.animator = linearLineBatchAnimator;
		}
		
		public function get loc1():Vector3D 
		{
			return linearLineBatchAnimationSet.loc1;
		}
		
		public function set loc1(value:Vector3D):void 
		{
			linearLineBatchAnimationSet.loc1 = value;
		}
		
		public function get loc2():Vector3D 
		{
			return linearLineBatchAnimationSet.loc2;
		}
		
		public function set loc2(value:Vector3D):void 
		{
			linearLineBatchAnimationSet.loc2 = value;
		}
		
		public function set alpha(value:Number):void
		{
			material.alpha = value;
		}
		
		public function get percentage():Number 
		{
			return linearLineBatchAnimationSet.percentage;
		}
		
		public function set percentage(value:Number):void
		{
			linearLineBatchAnimationSet.percentage = value;
		}
		
		public function get ramp():Number 
		{
			return linearLineBatchAnimationSet.ramp;
		}
		
		public function set ramp(value:Number):void 
		{
			linearLineBatchAnimationSet.ramp = value;
		}
		
		public function get minScale():Number 
		{
			return linearLineBatchAnimationSet.minScale;
		}
		
		public function set minScale(value:Number):void 
		{
			linearLineBatchAnimationSet.minScale = value;
		}
		
		public function get maxScale():Number 
		{
			return linearLineBatchAnimationSet.maxScale;
		}
		
		public function set maxScale(value:Number):void 
		{
			linearLineBatchAnimationSet.maxScale = value;
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