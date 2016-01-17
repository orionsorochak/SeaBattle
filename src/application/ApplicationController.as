package application
{
	import application.event_system.messages.CoreMessages;
	import application.event_system.EventDispatcher;
	import application.event_system.messages.ApplicationMessages;
	import application.event_system.messages.MenuMessages;
	import application.event_system.messages.PreloaderMessages;
	import application.interfaces.IModule;
	import application.loader.LoaderResorses;
	import application.menu.MenuController;
	import application.preloader.PreloaderController;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public class ApplicationController implements IModule
	{
		private var linkToEnterPoint:		SeaBattle;
		private var applicationStage:		Sprite;
		
		private var loaderResources:		LoaderResorses;
		
		private var preloaderController:	PreloaderController;
		private var menuController:			MenuController;
		
		public function ApplicationController(_linkToEnterPoint:SeaBattle){
			
			linkToEnterPoint = _linkToEnterPoint;
			
			init();
		}
				
		public function init():void
		{
					
			addListeners();
			
			createMainStage();
			
			ApplicationModule.getInstance().init();
			
			/*
			Moved to startupApplication method, that runs after IApplicationModule sends event CoreEvents.APP_MODULE_INIT_COMPLETE
			
			loaderResources = new LoaderResorses();
			loaderResources.load();
			
			preloaderController = new PreloaderController(applicationStage);*/			
		}
		
		private function startupApplication():void
		{
			loaderResources = new LoaderResorses();
			loaderResources.load();
			
			preloaderController = new PreloaderController(applicationStage);
		}
		
		private function createMainStage():void
		{
			applicationStage = new Sprite();
			applicationStage.scaleX = applicationStage.scaleY = linkToEnterPoint.getAppScale();
			linkToEnterPoint.addChild(applicationStage);
		}
		
		private function removeSplashScreen():void
		{
			linkToEnterPoint.destroySplashScreen();	
			EventDispatcher.Instance().removeListener(PreloaderMessages.PRELOADER_PAGE_IS_ACTIVE, this);			
		}
				
		private function addMenu():void
		{			
			menuController	= new MenuController(applicationStage);
		}
		
		private function removePreloader():void{
			
			if(preloaderController)
				preloaderController.destroy();
						
			EventDispatcher.Instance().removeListener(ApplicationMessages.REMOVE_PRELOADER,		this);
		}
		
		private function addListeners():void{
			
			EventDispatcher.Instance().addListener(CoreMessages.APP_MODULE_INIT_COMPLETE,				this);			
			EventDispatcher.Instance().addListener(MenuMessages.MENU_PAGE_IS_ACTIVE,					this);	
			EventDispatcher.Instance().addListener(ApplicationMessages.REMOVE_PRELOADER,				this);			
			EventDispatcher.Instance().addListener(PreloaderMessages.PRELOADER_PAGE_IS_ACTIVE,			this);
			EventDispatcher.Instance().addListener(PreloaderMessages.END_SHOW_PRELOADER_PAGE,			this);
		}
		
		public function receiveMessage(messageId:int, data:Object):void{
		
			switch(messageId)
			{
				case PreloaderMessages.PRELOADER_PAGE_IS_ACTIVE:
				{
					removeSplashScreen();
					break;
				}
					
				case PreloaderMessages.END_SHOW_PRELOADER_PAGE:
				{
					addMenu();
					break;
				}
					
				case ApplicationMessages.REMOVE_PRELOADER:
				{
					removePreloader();
					break;
				}
					
				case CoreMessages.APP_MODULE_INIT_COMPLETE:
				{
					startupApplication();
					break;
				}
			}
		}
		
		public function destroy():void
		{
			
		}
	}
}