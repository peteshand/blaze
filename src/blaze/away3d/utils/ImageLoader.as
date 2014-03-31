package blaze.away3d.utils 
{
	import blaze.away3d.Image;
	/**
	 * ...
	 * @author P.J.Shand
	 */
	public class ImageLoader 
	{
		private static var imageLoaderObjects:Vector.<ImageLoaderObject>;
		
		public function ImageLoader() 
		{
			
		}
		
		static public function loadImage(image:Image, url:String):void 
		{
			if (!ImageLoader.imageLoaderObjects) ImageLoader.imageLoaderObjects = new Vector.<ImageLoaderObject>();
			
			var imageLoaderObject:ImageLoaderObject = new ImageLoaderObject(image, url);
			//imageLoaderObject
			imageLoaderObject.loadComplete.add(OnLoadComplete);
			ImageLoader.imageLoaderObjects.push(imageLoaderObject);
		}
		
		static private function OnLoadComplete(imageLoaderObject:ImageLoaderObject):void 
		{
			for (var i:int = 0; i < ImageLoader.imageLoaderObjects.length; i++) 
			{
				if (ImageLoader.imageLoaderObjects[i] == imageLoaderObject) {
					ImageLoader.imageLoaderObjects[i].dispose();
					ImageLoader.imageLoaderObjects.splice(i, 1);
				}
			}
		}
	}
}

import away3d.materials.TextureMaterial;
import away3d.textures.BitmapTexture;
import blaze.away3d.Image;
import flash.display.Bitmap;
import flash.display.Loader;
import flash.events.Event;
import flash.net.URLRequest;
import org.osflash.signals.Signal;

class ImageLoaderObject
{
	private var image:Image;
	private var loader:Loader;
	public var loadComplete:Signal = new Signal(ImageLoaderObject);
	
	public function ImageLoaderObject(image:Image, url:String):void 
	{
		this.image = image;
		var request:URLRequest = new URLRequest(url);
		loader = new Loader();
		loader.contentLoaderInfo.addEventListener(Event.COMPLETE, OnLoadComplete);
		loader.load(request);
	}
	
	public function dispose():void 
	{
		loader = null;
		loadComplete = null;
	}
	
	private function OnLoadComplete(e:Event):void 
	{
		image.material = new TextureMaterial(new BitmapTexture(Bitmap(loader.content).bitmapData), true, false, false);
		loadComplete.dispatch(this);
	}
}