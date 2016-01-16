package application.preloader
{
	import application.interfaces.IModule;
	
	import com.greensock.TweenLite;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.system.ApplicationDomain;

	public class PreloaderView
	{		
		private var preloaderClasName:	String = "viewLoaderWindow";
		
		private var preloaderController:PreloaderController;
		private var preloaderStage:		Sprite;
		
		private var background:			MovieClip;
		
		private var tween:				TweenLite;
		
		public function PreloaderView(_preloaderController:PreloaderController, _preloaderStage:Sprite)
		{
			preloaderController = _preloaderController;
			preloaderStage 		= _preloaderStage;
		}
		
		public function showBg():void
		{
			var elementClass:Class = ApplicationDomain.currentDomain.getDefinition(preloaderClasName) as Class;
			background = new elementClass();			
			background.alpha = 0;
			
			preloaderStage.addChild(background);
			
			tween = TweenLite.to(background, 0.5, {alpha:1, onComplete:onTweenComplete});
		}
		
		private function onTweenComplete():void
		{
			tween.kill();
			tween = null;
			
			preloaderController.preloaderViewShowComplete();
		}
	}
}