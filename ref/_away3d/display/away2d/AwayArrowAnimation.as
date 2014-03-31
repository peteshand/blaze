package imag.masdar.core.view.away3d.display.away2d 
{
	import away3d.entities.Mesh;
	import away3d.materials.TextureMaterial;
	import away3d.primitives.PlaneGeometry;
	import away3d.textures.ATFTexture;
	import away3d.textures.BitmapTexture;
	import away3d.tools.commands.Merge;
	import com.greensock.TweenLite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import imag.masdar.core.model.texturePacker.PackerObject;
	import imag.masdar.core.utils.math.Math2;
	import imag.masdar.core.utils.parsers.AnimatedLineParser;
	import imag.masdar.core.view.away3d.animators.IndexFromZAnimationSet;
	import imag.masdar.core.view.away3d.animators.IndexFromZAnimator;
	import imag.masdar.core.view.away3d.display.base.BaseAwayObject;
	import imag.masdar.core.view.away3d.materials.methods.ColourMethod;
	import imag.masdar.core.view.away3d.materials.methods.IndexAlphaFadeMethod;
	import imag.masdar.core.view.starling.display.animations.LinePoint;
	/**
	 * ...
	 * @author Pete Shand
	 */
	public class AwayArrowAnimation extends BaseAwayObject
	{
		//private var linearLineBatchObject:LinearLineBatchObject;
		private var indexFromZAnimationSet:IndexFromZAnimationSet;
		private var indexAlphaFadeMethod:IndexAlphaFadeMethod;
		private var animatedLineVO:AnimatedLineVO;
		private var _fraction:Number = 0;
		private var arrowHeadGeo:PlaneGeometry;
		private var arrowHeadMaterial:TextureMaterial;
		private var arrowHead:Mesh;
		private var colourMethod:ColourMethod;
		private var lineFadeFraction:Number = 0.03;
		private var hideArrowOnComplete:Boolean;
		
		public function AwayArrowAnimation(displayObject:DisplayObject, showArrow:Boolean, hideArrowOnComplete:Boolean=false) 
		{
			animatedLineVO = AnimatedLineParser.animatedLineVO(displayObject, showArrow);
			this.width = animatedLineVO.width;
			this.height = animatedLineVO.height;
			this.hideArrowOnComplete = hideArrowOnComplete;
			
			this.scrollShowOffset = 200;
			this.scrollHideOffset = 200;
			
			var horizontalGeo:PlaneGeometry = new PlaneGeometry(animatedLineVO.dotLength, animatedLineVO.dotWidth, 1, 1, false);
			var verticalGeo:PlaneGeometry = new PlaneGeometry(animatedLineVO.dotWidth, animatedLineVO.dotLength, 1, 1, false);
			
			var bmd:BitmapData = new BitmapData(2, 2, false, 0xFF0000);
			//var texture:ATFTexture = new ATFTexture(new assets.BlackDot());
			var texture:BitmapTexture = new BitmapTexture(bmd);
			var material:TextureMaterial = new TextureMaterial(texture, true, false, false);
			material.alphaBlending = true;
			var meshes:Vector.<Mesh> = new Vector.<Mesh>();
			var mesh:Mesh;
			
			var c:int = 0;
			var totalFraction:Number;
			var totalNumberOfDots:int = animatedLineVO.totalLength / (animatedLineVO.dotLength + animatedLineVO.dotGap);
			
			var partFraction:Number;
			
			for (var i:int = 0; i < animatedLineVO.linePoints.length - 1; ++i) {
				var startLinePoint:LinePoint = animatedLineVO.linePoints[i];
				var endLinePoint:LinePoint = animatedLineVO.linePoints[i+1];
				var difference:Point = new Point(startLinePoint.x - endLinePoint.x, startLinePoint.y - endLinePoint.y);
				var dif:int = Math.abs(difference.x) + Math.abs(difference.y);
				var partNumberOfDots:int = dif / (animatedLineVO.dotLength + animatedLineVO.dotGap);
				
				for (var j:int = 0; j < partNumberOfDots; ++j) {
					partFraction = j / partNumberOfDots;
					totalFraction = c / totalNumberOfDots;
					if (difference.y > 0) mesh = new Mesh(verticalGeo, null);
					else mesh = new Mesh(horizontalGeo, null);
					mesh.x = startLinePoint.x - (difference.x * partFraction) + (PlaneGeometry(mesh.geometry).width / 2);
					mesh.y = (difference.y * partFraction) - startLinePoint.y + (PlaneGeometry(mesh.geometry).height / 2);
					mesh.z = 1 - totalFraction;
					meshes.push(mesh);
					c++;
				}
			}
			
			var receiver:Mesh = new Mesh(null, material);
			addChild(receiver);
			
			var merge:Merge = new Merge();
			merge.applyToMeshes(receiver, meshes);
			
			indexFromZAnimationSet = new IndexFromZAnimationSet();
			receiver.animator = new IndexFromZAnimator(indexFromZAnimationSet);
			
			indexAlphaFadeMethod = new IndexAlphaFadeMethod(lineFadeFraction);
			indexAlphaFadeMethod.setColour(animatedLineVO.linePoints[0].colour, animatedLineVO.linePoints[animatedLineVO.linePoints.length-1].colour);
			indexAlphaFadeMethod.fraction = 0;
			material.addMethod(indexAlphaFadeMethod);
			
			animationShowHide = true;
			tweenValueVO.target = this;
			tweenValueVO.showTime = 3;
			tweenValueVO.showDelay = 2;
			tweenValueVO.hideTime = 2;
			tweenValueVO.addShowProperty( { fraction:1 } );
			tweenValueVO.addHideProperty( { fraction:0 } );
			
			
			
			
			var bmd1:BitmapData = Bitmap(new assets.LineArrowHead()).bitmapData;
			var arrowHeadTexture:BitmapTexture = new BitmapTexture(bmd1);
			arrowHeadMaterial = new TextureMaterial(arrowHeadTexture, true, false, false);
			arrowHeadMaterial.alphaBlending = true;
			arrowHeadMaterial.alpha = 0;
			arrowHeadGeo = new PlaneGeometry(bmd1.width, bmd1.height, 1, 1, false);
			arrowHead = new Mesh(arrowHeadGeo, arrowHeadMaterial);
			addChild(arrowHead);
			
			colourMethod = new ColourMethod()
			arrowHeadMaterial.addMethod(colourMethod);
			
			TweenLite.delayedCall(1, Hide, null, true);
		}
		
		override public function Show():void 
		{
			if (showing) return;
			TweenLite.killTweensOf(arrowHeadMaterial);
			TweenLite.to(arrowHeadMaterial, 1, { alpha:1} );
			super.Show();
		}
		
		override public function Hide():void 
		{
			if (!showing) return;
			TweenLite.killTweensOf(arrowHeadMaterial);
			TweenLite.to(arrowHeadMaterial, 1, { alpha:0, delay:3} );
			super.Hide();
		}
		
		private function OnFadeOutComplete():void 
		{
			this.visible = false;
		}
		
		public function get fraction():Number 
		{
			return _fraction;
		}
		
		private var _arrowHeadPosition:Vector3D = new Vector3D();
		private var arrowParams:Array;
		private var fractionPoint:Point;
		private var arrowColour:uint = 0xFF0000;
		private var lastFraction:Number = -1;
		public function set fraction(value:Number):void 
		{
			_fraction = value;
			indexAlphaFadeMethod.fraction = fraction;
			
			if (lastFraction != fraction) {
				arrowParams = animatedLineVO.arrowParams(fraction * (1 + lineFadeFraction));
				fractionPoint = arrowParams[0];
				_arrowHeadPosition.x = fractionPoint.x + (animatedLineVO.dotLength / 2);
				_arrowHeadPosition.y = fractionPoint.y + (animatedLineVO.dotWidth / 2);
				
				arrowHead.position = _arrowHeadPosition;
				arrowHead.rotationZ = arrowParams[1];
				
				colourMethod.colour = arrowParams[2];
				
				if (hideArrowOnComplete){
					if (fraction == 1) {
						arrowHead.visible = false;
					}
					else {
						arrowHead.visible = true;
					}
				}
			}
			
			lastFraction = fraction;
		}
	}
}