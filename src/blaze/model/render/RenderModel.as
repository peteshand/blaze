package blaze.model.render
{
	import away3d.containers.View3D;
	import away3d.core.managers.Stage3DManager;
	import away3d.core.managers.Stage3DProxy;
	import away3d.events.Stage3DEvent;
	import blaze.model.viewPort.ViewPort;
	import blaze.utils.layout.Dimensions;
	import com.greensock.TweenLite;
	import flash.display.Stage;
	import flash.display3D.Context3DProfile;
	import flash.geom.Rectangle;
	import org.osflash.signals.Signal;
	import starling.core.Starling;
	/**
	 * ...
	 * @author Pete Shand
	 */
	public class RenderModel
	{
		public var instanceIndex:int;
		private var _proxySlotsUsed:int;
		
		private var viewPort:ViewPort;
		
		private var stage3DManager		:Stage3DManager;
		public var stage3DProxy			:Stage3DProxy;
		public var context3dReadySignal	:Signal = new Signal();
		
		private var updateHandlers:Vector.<Function> = new Vector.<Function>();
		
		private var _stage3DVisible		:Boolean = true;
		public var VisibilityChange		:Signal = new Signal();
		private var stage:Stage;
		public var active:Boolean = true;
		
		public function RenderModel(instanceIndex:int):void
		{
			this.instanceIndex = instanceIndex;
		}
		
		public function init(stage:Stage):void 
		{
			this.stage = stage;
			
			stage3DManager = Stage3DManager.getInstance(stage);
			//stage3DProxy = stage3DManager.getStage3DProxy(instanceIndex, false, Context3DProfile.BASELINE_EXTENDED);
			//stage3DProxy = stage3DManager.getFreeStage3DProxy(false, Context3DProfile.BASELINE_EXTENDED);
			stage3DProxy = stage3DManager.getFreeStage3DProxy(false, Context3DProfile.BASELINE);
			stage3DProxy.enableDepthAndStencil = true;
			
			stage3DProxy.addEventListener(Stage3DEvent.CONTEXT3D_CREATED, onContextCreated);
			stage3DProxy.antiAlias = 8;
			
			Renderers.addProxy(stage3DProxy.clear, this.update, stage3DProxy.present);
		}
		
		private function onContextCreated(e:Stage3DEvent):void 
		{
			context3dReadySignal.dispatch();
			viewPort = Blaze.instance(instanceIndex).viewPort;
			viewPort.update.add(OnViewPortUpdate);
			viewPort.init(stage, this);
		}
		
		/*private function render():void
		{
			Renderers.update();
		}*/
		
		private function update():void
		{
			if (active){
				for each(var updater:Function in updateHandlers) {
					updater();
				}
			}
		}
		
		// Show and hide stage3D
		public function get stage3DVisible():Boolean 
		{
			return _stage3DVisible;
		}
		
		public function set stage3DVisible(value:Boolean):void 
		{
			if (_stage3DVisible != value){
				_stage3DVisible = value;
				for (var i:int = 0; i < stage3DManager.numProxySlotsUsed; ++i) {
					//var proxy:Stage3DProxy = stage3DManager.getStage3DProxy(i, false, Context3DProfile.BASELINE_EXTENDED);
					var proxy:Stage3DProxy = stage3DManager.getStage3DProxy(i, false);
					if (stage3DVisible) proxy.visible = true;
					else proxy.visible = false;
				}
				VisibilityChange.dispatch();
			}
		}
		
		// Resize code
		
		public function OnViewPortUpdate():void
		{
			stage3DProxy.x = viewPort.rect.x;
			stage3DProxy.y = viewPort.rect.y;
			stage3DProxy.width = viewPort.rect.width;
			stage3DProxy.height = viewPort.rect.height;
		}
		
		public function replaceUpdater(oldUpdater:Function, newUpdater:Function):Boolean
		{
			var index:int = updateHandlers.indexOf(oldUpdater);
			if (index != -1) {
				updateHandlers[index] = newUpdater;
				return true;
			}
			return false;
		}
		
		public function removeUpdater(updater:Function):Boolean
		{
			var index:int = updateHandlers.indexOf(updater);
			if (index != -1) {
				updateHandlers.splice(index, 1);
				return true;
			}
			return false;
		}
		
		private function addUpdater(updater:Function):void
		{
			removeUpdater(updater);
			updateHandlers.push(updater);
		}
		
		private function addUpdaterAt(updater:Function, index:int):void
		{
			if (index == -1) {
				addUpdater(updater);
				return;
			}
			if (index >= updateHandlers.length) index = updateHandlers.length;
			
			var curIndex:int = updateHandlers.indexOf(updater);
			if (curIndex != index) {
				if (curIndex != -1) updateHandlers.splice(curIndex, 1);
				updateHandlers.splice(index, 0, updater);
			}
		}
		
		public function get renderCount():int {
			return updateHandlers.length;
		}
		
		public function get colour():uint 
		{
			return stage3DProxy.color;
		}
		
		public function set colour(value:uint):void 
		{
			stage3DProxy.color = value;
		}
		
		public function get proxySlotsUsed():int 
		{
			return stage3DManager.numProxySlotsUsed;
		}
		
		public function start():void
		{
			Renderers.start();
		}
		
		public function stop():void
		{
			Renderers.stop();
		}
		
		public var awayCollectionData:Array = new Array();
		public function addView3D(View3DClass:Class, id:String, renderIndex:int = -1):View3D
		{
			var view3D:View3D = new View3DClass(instanceIndex);
			stage.addChild(view3D);
			this.addUpdaterAt(view3D.render, renderIndex);
			awayCollectionData.push([view3D, id, instanceIndex]);
			return view3D;
		}
		
		public var starlingCollectionData:Array = new Array();
		public function addStarling(StarlingLayerClass:Class, id:String, renderIndex:int = -1):Starling
		{
			var starling:Starling = new View2DInitializer().init(this, stage, StarlingLayerClass, addUpdaterAt, renderIndex, instanceIndex);
			starlingCollectionData.push([starling, id, instanceIndex]);
			return starling;
		}
		
	}
}

import away3d.core.managers.Stage3DProxy;
import blaze.starling.layers.StarlingLayer;
import flash.display.Stage;
import flash.display3D.Context3DProfile;
import flash.system.Capabilities;
import starling.core.Starling;
import starling.events.Event;
import blaze.model.render.RenderModel;

class View2DInitializer
{
	private var starling:Starling;
	private var renderModel:RenderModel;
	private var renderIndex:int;
	private var instanceIndex:int;
	
	public function View2DInitializer()
	{
	
	}
	
	public function init(renderModel:RenderModel, stage:Stage, StarlingLayerClass:Class, addUpdaterAt:Function, renderIndex:int = -1, instanceIndex:int=0):Starling
	{
		this.renderModel = renderModel;
		this.renderIndex = renderIndex;
		this.instanceIndex = instanceIndex;
		
		try { Starling.handleLostContext = true; } // deactivate on mobile devices (to save memory)
		catch (e:Error) { }
		
		try{
			Starling.multitouchEnabled = true; // useful on mobile devices
		}catch (e:Error) {
			// I hate using try..catch as logic but the Starling API is shit here
		}
		
		starling = new Starling(StarlingLayerClass, stage, renderModel.stage3DProxy.viewPort, renderModel.stage3DProxy.stage3D, 'auto', Context3DProfile.BASELINE_EXTENDED);
		starling.simulateMultitouch = true;
		starling.enableErrorChecking = Capabilities.isDebugger;
		starling.start();
		
		starling.shareContext = true;
		starling.addEventListener(Event.ROOT_CREATED, onStarlingReady);
		
		// Because of delayed initialisation, we should convert auto index to real index now
		if (renderIndex == -1) renderIndex = renderModel.renderCount;
		addUpdaterAt(tempRenderFunc, renderIndex);
		
		return starling;
	}
	
	private var tempRenderFunc:Function = function():void { }
	
	public function onStarlingReady(e:Event):void
	{
		var layer:StarlingLayer = starling.root as StarlingLayer;
		layer.setStarling(starling, instanceIndex);
		renderModel.replaceUpdater(tempRenderFunc, layer.update);
	}
}