package blaze.starling.utils 
{
	import flash.display.BitmapData;
	import starling.display.Image;
	import starling.textures.Texture;
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
		
		static public function loadImage(url:String):Image 
		{
			if (!ImageLoader.imageLoaderObjects) {
				ImageLoader.imageLoaderObjects = new Vector.<ImageLoaderObject>();
			}
			
			for (var i:int = 0; i < ImageLoader.imageLoaderObjects.length; i++) 
			{
				if (ImageLoader.imageLoaderObjects[i].url == url) {
					return ImageLoaderObject(ImageLoader.imageLoaderObjects[i]).image;
				}
			}
			
			var image:Image = new Image(Texture.fromBitmapData(new BitmapData(1, 1, true, 0x00000000)));
			
			var imageLoaderObject:ImageLoaderObject = new ImageLoaderObject(image, url);
			imageLoaderObject.loadComplete.add(OnLoadComplete);
			ImageLoader.imageLoaderObjects.push(imageLoaderObject);
			
			return image;
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

import flash.display.Bitmap;
import flash.display.Loader;
import flash.events.Event;
import flash.net.URLRequest;
import org.osflash.signals.Signal;
import starling.display.Image;
import starling.textures.Texture;

class ImageLoaderObject
{
	public var image:Image;
	private var loader:Loader;
	public var loadComplete:Signal = new Signal(ImageLoaderObject);
	public var url:String;
	
	public function ImageLoaderObject(image:Image, url:String):void 
	{
		this.image = image;
		this.url = url;
		
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
		image.texture = Texture.fromBitmap(Bitmap(loader.content));
		image.width = Bitmap(loader.content).width;
		image.height = Bitmap(loader.content).height;
		loader.unload();
		loader = null;
		loadComplete.dispatch(this);
	}
}