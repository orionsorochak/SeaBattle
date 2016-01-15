package
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	
	import game.ApplicationController;
	
	[SWF(frameRate="30")]
	public class SeaBattle extends Sprite{
		
		[Embed(source="../logo/roar_games_logo.png")]
		private var splashScreenImage:Class;
		private var splashScreen:Bitmap;
		
		private var appScale:		Number = 1; 
		private var timer:			Timer = new Timer(1000, 1);
		
		private var applicationController:ApplicationController;
		
		public function SeaBattle(){
			super();
			
			// support autoOrients
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			this.addEventListener(Event.ADDED_TO_STAGE, handlerAddedToStage);
			
			applicationController = new ApplicationController(this);
			
			defineScale();
			showSplashScreen();			
		}
		
		private function defineScale():void{
			
			var guiSize			:Rectangle = new Rectangle(0, 0, 1280, 720); 
			var deviceSize		:Rectangle = new Rectangle(0, 0, Math.max(stage.fullScreenWidth, stage.fullScreenHeight), Math.min(stage.fullScreenWidth, stage.fullScreenHeight)); 
			
			var appSize			:Rectangle = guiSize.clone(); 
			var appLeftOffset	:Number = 0; 
			
			// if device is wider than GUI's aspect ratio, height determines scale 
			if ((deviceSize.width/deviceSize.height) > (guiSize.width/guiSize.height)) 
			{ 
				appScale = deviceSize.height / guiSize.height; 
				appSize.width = deviceSize.width / appScale; 
				appLeftOffset = Math.round((appSize.width - guiSize.width) / 2); } 
				
				// if device is taller than GUI's aspect ratio, width determines scale 
			else 
			{ 
				appScale = deviceSize.width / guiSize.width; 
				appSize.height = deviceSize.height / appScale; 
				appLeftOffset = 0; 
			} 
		}
		
		private function showSplashScreen():void{
			
			//			stage.addEventListener(Event.DEACTIVATE, deactivate);
			splashScreen = new splashScreenImage() as Bitmap;
			addChild( splashScreen );
			
			splashScreen.scaleX = splashScreen.scaleY = appScale;
			splashScreen.smoothing = true;
			
			splashScreen.x = stage.fullScreenWidth/2 - splashScreen.width/2;
			splashScreen.y = stage.fullScreenHeight/2 - splashScreen.height/2;
		}
		
		
		private function handlerAddedToStage(e:Event):void{
			
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, startUpApplication);
			timer.start();
		}
		
		private function startUpApplication(e:Event):void{
			
			timer.stop();
			timer.removeEventListener(TimerEvent.TIMER_COMPLETE, startUpApplication);
			
			timer = null;
			
			this.removeEventListener(Event.ADDED_TO_STAGE, handlerAddedToStage);
			
			removeChild( splashScreen );
		}
		
		private function removeSplashScreen():void{
			
		}
	}
}