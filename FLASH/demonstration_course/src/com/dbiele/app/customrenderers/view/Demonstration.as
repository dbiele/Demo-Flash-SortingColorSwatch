package com.dbiele.app.customrenderers.view 
{
	import com.dbiele.app.components.Dragger;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author Dean Biele
	 */
	public class Demonstration extends MovieClip {
		private static var TIMER_SPEED:int = 1000;	
		private static var COLOR_ARRAY:Array = [{color:"blue",hex:0x66ccff}, {color:"yellow", hex:0xffcc00}, {color:"green", hex:0x33cc66}];
		
		private var _mTimer:Timer;
		private var imageOffSet:int = 36;
		
		
		public function Demonstration() {
			super();
			
			startScene();
			//hack.  Setting the visibility to 0 so we don't see the sample dragger.
			//remove the sample_dragger from the screen
			sample_dragger.alpha = 0;
		}
		
		public function startScene() {
			startDraggerAnimation();
			initalizeColorTargets();
			
		}
		
		/**
		 * start an interval for the draggers to appear
		 * have the draggers appear at a certain time.
		 */
		
		private function startDraggerAnimation():void 
		{
			//TODO Change the timer to use seconds instead of milliseconds. 
			
			_mTimer = new Timer(TIMER_SPEED);
			_mTimer.addEventListener(TimerEvent.TIMER, addDragger, false, 0, true);
			_mTimer.start();
		}
		
		public function endScene():void {
			//TODO Clean up the variables for better memory management.	
			_mTimer.stop();
		}
		
		private function addDragger(evt:TimerEvent):void 
		{
			//endXPostion: Ideally, the stage would be fixed in the html.  However, this could compensate for larger widths.
			var endXPostion:Number = (stage.stageWidth - stage.width) - this.sample_dragger.width;
			var randomizeColor:Array = getRandomColor();
			
			var theDragger:Dragger = new Dragger(this.sample_dragger, "id1", endXPostion, randomizeColor[1], randomizeColor[0]);
			theDragger.addEventListener(Dragger.DRAGGER_CLICK_EVENT, onDraggerClicked, false, 0, true); 
			theDragger.addEventListener(Dragger.DRAGGER_TARGET_TWEEN_COMPLETE, onDraggerToTarget, false, 0, true);
			theDragger.addEventListener(Dragger.DRAGGER_NO_SELECTION, onDraggerNoSelection, false, 0, true);
		}
		
		/**
		 * returns the color name and hex color.  Use [0] for color name and [1] for hex color.
		 * @return
		 */
		private function getRandomColor():Array {
			//TODO Add ability to not have the same color next to each other.
			// using the COLOR_ARRAY
			var randomNumber:int = int(Math.random() * (COLOR_ARRAY.length));
			var colorObject:Object = COLOR_ARRAY[randomNumber];
			var colorName:String = colorObject.color;
			var colorHex:uint = colorObject.hex;
			return [colorName,colorHex];
		}
		
		private function onDraggerNoSelection(evt:Event):void {
			var theDragger:Dragger = evt.target as Dragger;
			theDragger.destroy();
		}
		
		private function onDraggerClicked(evt:Event):void {
			var theDragger:Dragger = evt.target as Dragger;
			
			//get the target position based on the color.
			//This could be improved greatly. Just wanting to get it out.
			var targetPosition:Array = [];
			switch(theDragger.getColorName()) {
					case "blue":
						targetPosition[0] = droptarget_v1.x;
						targetPosition[1] = droptarget_v1.y;
						break;
					case "yellow":
						targetPosition[0] = droptarget_v2.x;
						targetPosition[1] = droptarget_v2.y;
						break;
					case "green":
						targetPosition[0] = droptarget_v3.x;
						targetPosition[1] = droptarget_v3.y;
						break;
					default:
						//nothing.
			}
			trace("droptarget_v1.x" + droptarget_v1.y);
			
			theDragger.movetoDropPosition(targetPosition[0]+imageOffSet, targetPosition[1]);
		}
		
		private function onDraggerToTarget(evt:Event):void {
			var theDragger:Dragger = evt.target as Dragger;
			theDragger.destroy();
		}
		
		private function initalizeColorTargets():void {
			
		}
		
	}

}