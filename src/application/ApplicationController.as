package application
{
	import application.event_system.EventDispatcher;
	import application.event_system.messages.ApplicationMessages;
	import application.event_system.messages.ApplicationViewMessages;
	import application.interfaces.IModule;
	import application.loader.LoaderResorses;
	import application.preloader.PreloaderController;
	
	import flash.display.Sprite;

	public class ApplicationController implements IModule
	{
		private var linkToEnterPoint:		SeaBattle;
		private var mainStage:				Sprite;
		
		private var loaderResources:		LoaderResorses;
		
		private var preloaderController:	PreloaderController;
		
		public function ApplicationController(_linkToEnterPoint:SeaBattle){
			
			linkToEnterPoint = _linkToEnterPoint;
			
			init();
		}
		
		private function init():void{
			
			createMainStage();
			
			loaderResources = new LoaderResorses();
			loaderResources.load();
			
			preloaderController = new PreloaderController(mainStage);
			
			addListeners();
		}
		
		private function createMainStage():void
		{
			mainStage = new Sprite();
			linkToEnterPoint.addChild(mainStage);
		}
		
		private function removeSplashScreen():void
		{
			linkToEnterPoint.destroySplashScreen();	
		}
		
		private function addListeners():void{
			
			EventDispatcher.Instance().addListener(ApplicationViewMessages.PRELOADER_SHOWED, this);			
		}
		
		public function receiveMessage(messageId:int, data:Object):void{
		
			switch(messageId)
			{
				case ApplicationViewMessages.PRELOADER_SHOWED:
				{
					removeSplashScreen();
					break;
				}
					
				default:
				{
					break;
				}
			}
		}
	}
}