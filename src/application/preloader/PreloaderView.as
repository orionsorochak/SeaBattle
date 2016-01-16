package application.preloader
{
	import application.AppGlobalVariables;
	import application.event_system.EventDispatcher;
	import application.event_system.messages.PreloaderMessages;
	import application.interfaces.IModule;
	
	import com.greensock.TweenLite;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.system.ApplicationDomain;

	public class PreloaderView{		
		
		private var preloaderClasName:	String = "viewLoaderWindow";
		
		private var preloaderStage:		Sprite;		
		private var background:			MovieClip;
		
		private var tween:				TweenLite;
		
		public function PreloaderView(_preloaderStage:Sprite){
			
			preloaderStage 		= _preloaderStage;
		}
		
		public function show():void{
			
			var elementClass:Class = ApplicationDomain.currentDomain.getDefinition(preloaderClasName) as Class;
			background = new elementClass();			
			background.alpha = 0;
			
			preloaderStage.addChild(background);
			
			tween = TweenLite.to(background, AppGlobalVariables.PAGE_FADE_ODE_TIME, {alpha:1, onComplete:onShowComplete});
		}
		
		private function onShowComplete():void{
			
			tween.kill();
			tween = null;
			
			EventDispatcher.Instance().sendMessage(PreloaderMessages.PRELOADER_PAGE_IS_ACTIVE, null);			
		}
		
		public function destroy():void{
			
			if(background && preloaderStage.contains(background)){
				preloaderStage.removeChild(background);
				background = null
			}
			
			if(tween){
				tween.kill();
				tween = null;
			}
		}
	}
}