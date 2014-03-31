package imag.masdar.core.view.starling.utils 
{
	import com.greensock.TweenLite;
	import dragonBones.animation.WorldClock;
	import dragonBones.Armature;
	import dragonBones.Bone;
	import dragonBones.Slot;
	import flash.geom.ColorTransform;
	import imag.masdar.core.BaseObject;
	import imag.masdar.core.control.trans.TransitionControl;
	import imag.masdar.core.Core;
	import imag.masdar.core.model.applicationState.ApplicationState;
	import imag.masdar.core.model.dragonBones.DragonBonesModel;
	import imag.masdar.core.model.language.LanguageModel;
	import imag.masdar.core.utils.closure;
	import imag.masdar.core.utils.layout.Alignment;
	import imag.masdar.core.utils.layout.DisplayPositioner;
	import imag.masdar.core.utils.scroll.ScrollTrigger;
	import blaze.behaviors.StarlingTouchBehavior;
	import imag.masdar.core.view.starling.display.shell.home.HomeButton;
	import imag.masdar.core.view.starling.display.shell.languageSwitch.LanguageSwitchButton;
	import imag.masdar.core.view.trans.FadeTrans;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.utils.Color;
	/**
	 * ...
	 * @author Tom Byrne
	 */
	public class StandardControls
	{
		
		public static function addLanguageButton(container:Sprite, displayPositioner:DisplayPositioner = null, scrollTrigger:ScrollTrigger = null, dark:Boolean = true):void {
			var cont:Sprite = new Sprite();
			container.addChild(cont);
			
			var trans:TransitionControl = Core.getInstance().control.transControl;
			var db:DragonBonesModel = Core.getInstance().model.dragonBones;
			var lang:LanguageModel = Core.getInstance().model.language;
			var added:Function = function(armature:Armature, display:DisplayObject):void {
				
				if (displayPositioner) {
					
					if (scrollTrigger) {
						displayPositioner.addDisplay(cont, display.width, display.height, Alignment.BOTTOM, DisplayPositioner.SCALE_NEVER);
						scrollTrigger.callMethod(10, ScrollTrigger.DIR_FORWARDS, displayPositioner.setAlignment, [cont, Alignment.BOTTOM_RIGHT, true]);
						scrollTrigger.callMethod(10, ScrollTrigger.DIR_BACKWARDS, displayPositioner.setAlignment, [cont, Alignment.BOTTOM, true]);
					}else{
						displayPositioner.addDisplay(cont, display.width, display.height, Alignment.BOTTOM_RIGHT, DisplayPositioner.SCALE_NEVER);
					}
					displayPositioner.setDisplayPadding(cont, 11, 11, 11, 11);
				}
				
				var over:Boolean = false;
				var down:Boolean = false;
				
				var updateState:Function = function():void {
					if (lang.languageIndex == 0) {
						if(down)armature.animation.gotoAndPlay("arDown");
						else if (over) armature.animation.gotoAndPlay("arOver");
						else armature.animation.gotoAndPlay("arOut");
					}else {
						if(down)armature.animation.gotoAndPlay("enDown");
						else if (over) armature.animation.gotoAndPlay("enOver");
						else armature.animation.gotoAndPlay("enOut");
					}
				}
				addButtonStates(armature, display, null, null, function(armature:Armature, display:DisplayObject, isDown:Boolean, isOver:Boolean):void {
					down = isDown;
					over = isOver;
					updateState();
				});
				lang.updateSignal.add(updateState);
				
				/*Core.getInstance().control.flipControl.addFlipSubject(function(flip:Number):void {
					display.scaleX = flip;
					display.x = display.width/2 - (flip * display.width)/2;
				});*/
				
				var starlingTouchBehavior:StarlingTouchBehavior = new StarlingTouchBehavior(null, null, function():void {
					trans.setProp(lang, "languageIndex", lang.languageIndex + 1);
				}, null);
				starlingTouchBehavior.addListenerTo(display);
			}
			
			if (dark) {
				db.addDisplay("Graphics/LanguageButtonDark", cont, null, added);
			}else {
				db.addDisplay("Graphics/LanguageButtonLight", cont, null, added);
			}
			
			var core:Core = Core.getInstance();
			core.model.appState.update.add(OnApplicationStateChange);
			
			function OnApplicationStateChange():void 
			{
				if (core.model.language.languageIndex == 1 && core.model.appState.state == ApplicationState.ATTRATOR){
					trans.setProp(lang, "languageIndex", 0);
				}
			}
		}
		
		
		public static function addHomeButton(container:Sprite, homeCall:Function, displayPositioner:DisplayPositioner = null, scrollTrigger:ScrollTrigger = null, dark:Boolean=true, dispProps:Object=null):void {
			var core:Core = Core.getInstance();
			var db:DragonBonesModel = core.model.dragonBones;
			var added:Function = function(armature:Armature, display:DisplayObject):void{
				if (displayPositioner) {
					displayPositioner.addDisplay(display, display.width, display.height, Alignment.BOTTOM_LEFT, DisplayPositioner.SCALE_NEVER);
					displayPositioner.setDisplayPadding(display, 11, 11, 11, 11);
					
					if (scrollTrigger) {
						display.alpha = 0;
						scrollTrigger.callMethod(10, ScrollTrigger.DIR_FORWARDS, FadeTrans.show(0.3, null, 0, display));
						scrollTrigger.callMethod(10, ScrollTrigger.DIR_BACKWARDS, FadeTrans.hide(0.3, null, 0, display));
					}
				}
			}
			
			if (dark) {
				addButton(container, "Graphics/HomeButtonDark", homeCall, dispProps, added);
			}else {
				addButton(container, "Graphics/HomeButtonLight", homeCall, dispProps, added);
			}
		}
		
		public static function addBackButton(container:Sprite, backCall:Function, displayPositioner:DisplayPositioner = null, scrollTrigger:ScrollTrigger = null, dark:Boolean=true, dispProps:Object=null):void {
			var core:Core = Core.getInstance();
			var db:DragonBonesModel = core.model.dragonBones;
			var added:Function = function(armature:Armature, display:DisplayObject):void {
				if (displayPositioner) {
					displayPositioner.addDisplay(display, display.width, display.height, Alignment.BOTTOM_LEFT, DisplayPositioner.SCALE_NEVER);
					displayPositioner.setDisplayPadding(display, 11, 11, 11, 11);
					
					if (scrollTrigger) {
						display.alpha = 0;
						scrollTrigger.callMethod(10, ScrollTrigger.DIR_FORWARDS, FadeTrans.show(0.3, null, 0, display));
						scrollTrigger.callMethod(10, ScrollTrigger.DIR_BACKWARDS, FadeTrans.hide(0.3, null, 0, display));
					}
				}
			}
			
			if (dark) {
				addButton(container, "Graphics/BackButtonDark", backCall, dispProps, added);
			}else {
				addButton(container, "Graphics/BackButtonLight", backCall, dispProps, added);
			}
		}	
		
		public static function addHandButton(container:Sprite, dark:Boolean = false, dispProps:Object = null, addHandler:Function = null ):void {
			var added:Function = function(armature:Armature, display:DisplayObject):void {
				if (dispProps) {
					for (var i:String in dispProps) display[i] = dispProps[i];
				}
				
				TweenLite.delayedCall( 1, function():void { armature.animation.gotoAndPlay("intro") } );
				TweenLite.delayedCall( 5, function():void { armature.animation.gotoAndPlay("loop") } );
				WorldClock.clock.add(armature);
				display.touchable = false;
				display.useHandCursor = false;
				if(addHandler != null) addHandler(armature, display);				
			}
			
			var core:Core = Core.getInstance();
			var db:DragonBonesModel = core.model.dragonBones;
			
			if(dark)
				db.addDisplay("Graphics/HandButtonDark", container, null, added);
			else
				db.addDisplay("Graphics/HandButtonLight", container, null, added);
		}
		
		public static function addPlusButton(container:Sprite, touchHandler:Function, dark:Boolean=true, dispProps:Object=null, addHandler:Function=null, keyMethod:Function=null):void {
			if (dark) {
				addButton(container, "Graphics/PlusButtonDark", touchHandler, dispProps, addHandler, keyMethod);
			}else {
				addButton(container, "Graphics/PlusButtonLight", touchHandler, dispProps, addHandler, keyMethod);
			}
		}
		
		public static function addButton(container:Sprite, animationId:String, touchHandler:Function, dispProps:Object=null, addHandler:Function=null, keyMethod:Function=null):void {
			var core:Core = Core.getInstance();
			var db:DragonBonesModel = core.model.dragonBones;
			var added:Function = function(armature:Armature, display:DisplayObject):void {
				if (dispProps) {
					for (var i:String in dispProps) display[i] = dispProps[i];
				}
				addButtonStates(armature, display);
				
				if(touchHandler!=null){
					var starlingTouchBehavior:StarlingTouchBehavior = new StarlingTouchBehavior(null, null, function():void {
						 core.control.transControl.callMeth(touchHandler, null, keyMethod);
					}, null);
					starlingTouchBehavior.addListenerTo(display);
				}
				
				if (addHandler!=null) addHandler(armature, display);
			}
			db.addDisplay(animationId, container, null, added);
		}
		
		public static function addButtonStates(armature:Armature, display:DisplayObject, overHandler:Function = null, outHandler:Function = null, setState:Function = null):void {
			
			if (setState == null) {
				setState = function(armature:Armature, display:DisplayObject, down:Boolean, over:Boolean):void {
					if(down)armature.animation.gotoAndPlay("down");
					else if (over) armature.animation.gotoAndPlay("over");
					else armature.animation.gotoAndPlay("out");
				}
			}
			
			WorldClock.clock.add(armature);
			display.touchable = true;
			display.useHandCursor = true;
			var over:Boolean = false;
			var down:Boolean = false;
			display.addEventListener(TouchEvent.TOUCH, function(e:TouchEvent):void {
				var touches:Vector.<Touch> = e.getTouches(display);
				var change:Boolean = false;
				if (touches.length) {
					if (!over) {
						if(overHandler!=null)overHandler();
					}
					for each(var touch:Touch in touches) {
						if (touch.tapCount) {
							over = true;
							if (!down) {
								down = true;
								change = true;
							}
							return;
						}
					}
					if (!over) {
						over = true;
						change = true;
					}
				}else if (over) {
					down = false;
					over = false;
					change = true;
					if(outHandler!=null)outHandler();
				}
				if(change)setState(armature, display, down, over);
			});
			setState(armature, display, false, false);
		}
	}

}