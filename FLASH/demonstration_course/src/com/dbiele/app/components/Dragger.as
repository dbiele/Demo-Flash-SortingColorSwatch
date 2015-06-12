package com.dbiele.app.components 
{
	import com.greensock.easing.Elastic;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import com.greensock.TweenLite;
	import com.greensock.easing.Linear;
	import flash.geom.ColorTransform;
	/**
	 * ...
	 * @author Dean Biele
	 */
	public class Dragger extends EventDispatcher {
		
		public static var DRAGGER_CLICK_EVENT:String = "onDraggerClicked";
		public static var DRAGGER_TARGET_TWEEN_COMPLETE:String = "onDraggerTweenComplete";
		public static var DRAGGER_NO_SELECTION:String = "onTopAnimationComplete";
		static var TOP_TIME_TWEEN:Number = 5;
		static var TARGET_TIME_TWEEN:Number = 1;
		
		private var draggerMC:MovieClip;
		private var _mcLibrary:MovieClip;
		private var _id:String;
		private var _parentContent:MovieClip;
		private var _draggerMC:MovieClip;
		private var draggerTween:TweenLite;
		private var _color:uint;
		private var _endXPosition:Number;
		private var _colorName:String;

		
		/**
		 * 
		 * @param	stageMC = color swatch movieclip name that's on the stage.
		 * @param	id = use a unique ID to identify the color swatch.
		 * @param	endXPosition = where should the swatch end up?
		 * @param	colorHex use a color like 0xFFFFFF;
		 */
		public function Dragger(stageMC:MovieClip, id:String, endXPosition:Number, colorHex:uint, colorName:String):void {
			_mcLibrary = stageMC;
			_id = id;
			_parentContent = _mcLibrary.parent as MovieClip;
			_color = colorHex;
			_endXPosition = endXPosition;
			_colorName = colorName;
			addMovieClipToStage();
			startTopAnimation();
			addMouseEventHandlers();
		}
		
		private function addMovieClipToStage():void {
			//add the dragger movie to the stage.
			//TODO change the name so it uses string to pull value from library.
			_draggerMC = new dragger_style_1();
			_draggerMC.x = _mcLibrary.x;
			_draggerMC.y = _mcLibrary.y;
			setMovieClipColor();
			_parentContent.addChild(_draggerMC);
			
			
		}
		
		private function setMovieClipColor():void {
			var myColorTransform:ColorTransform = new ColorTransform();
			myColorTransform.color = _color;
			_draggerMC.content_mc.colorfill_mc.transform.colorTransform = myColorTransform;
		}
		
		
		/**
		 * returns the id value so we can determine what was clicked.
		 * @return
		 */
		public function getID():String { return _id; }
		
		
		/**
		 * returns the movieclip instance.
		 * @return
		 */
		public function getMC():MovieClip { return _draggerMC; }
		
		
		/**
		 * adds a mouse down event.
		 */
		public function addMouseEventHandlers():void {
			_draggerMC.hit_area_mc.buttonMode = true;
			_draggerMC.hit_area_mc.useHandCursor = true;
			_draggerMC.hit_area_mc.addEventListener(MouseEvent.MOUSE_DOWN, onDraggerPress, false, 0, true);
		}
		
		public function deleteMouseEventHandlers():void {
			_draggerMC.hit_area_mc.buttonMode = false;
			_draggerMC.hit_area_mc.useHandCursor = false;
			_draggerMC.hit_area_mc.removeEventListener(MouseEvent.MOUSE_DOWN, onDraggerPress);
		}
		
		private function onDraggerPress(evt:Event):void {
			deleteMouseEventHandlers();
			dispatchEvent(new Event(DRAGGER_CLICK_EVENT));
		}
		
		/**
		 * Moves the dragger across the top of the screen.
		 */
		private function startTopAnimation():void {
			draggerTween = TweenLite.to(_draggerMC, TOP_TIME_TWEEN, { ease:Linear.easeNone, x:_endXPosition, onComplete:topAnimationComplete } );
		}
		
		private function stopTopAnimation():void {
			trace("stopTopAnimation");
			draggerTween.kill();
		}
		
		/**
		 * starts to move the dragger to the drop position. Calls DRAGGER_DONE when transition complete.
		 * @param	x
		 * @param	y
		 */
		public function movetoDropPosition(xLoc:Number,yLoc:Number):void {
			deleteMouseEventHandlers();
			stopTopAnimation();
			TweenLite.to(_draggerMC, TARGET_TIME_TWEEN, { ease:Linear.easeNone, x:xLoc, y:yLoc, onComplete:tweenComplete } );
		}
		
		public function destroy():void {
			//TODO Add better memory management when movieclip is destroyed
			//remove the movie clip
			trace("dragger destory");
			_parentContent.removeChild(_draggerMC);
			_draggerMC = null;
		}
		
		/**
		 * Let the parent handle how this will be disposed of.
		 */
		private function tweenComplete():void {
			dispatchEvent(new Event(DRAGGER_TARGET_TWEEN_COMPLETE));
		}
		
		/**
		 * user has not clicked the color.  Let the parent dispose of it.
		 */
		private function topAnimationComplete():void {
			trace("animation complete");
			dispatchEvent(new Event(DRAGGER_NO_SELECTION));
		}
		
		public function getColorName():String {
		return _colorName;
		}
	}

}