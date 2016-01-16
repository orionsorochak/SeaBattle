package application.preloader
{
	import application.event_system.EventDispatcher;
	import application.event_system.messages.ApplicationMessages;
	import application.event_system.messages.ApplicationViewMessages;
	import application.interfaces.IModule;
	
	import flash.display.Sprite;

	public class PreloaderController implements IModule{
		
		private var mainStage:				Sprite;
		private var preloaderView:			PreloaderView;
		private var preloaderStage:			Sprite;
		
		public function PreloaderController(_mainStage:Sprite){
			
			mainStage = _mainStage;
			
			init();
		}
		
		private function init():void{			
				
			preloaderStage = new Sprite();
			mainStage.addChild(preloaderStage);
			
			preloaderView = new PreloaderView(this, preloaderStage);
			
			addListeners();
		}
		
		private function preloaderLoaded():void{
			
		}
		
		private function loadComplete():void{
			
			preloaderView.showBg();
			EventDispatcher.Instance().removeListener(ApplicationMessages.COMPLETE_LOAD, this);
		}
		
		public function preloaderViewShowComplete():void{
			
			EventDispatcher.Instance().sendMessage(ApplicationViewMessages.PRELOADER_SHOWED, null);			
		}
		
		private function addListeners():void{
			
			EventDispatcher.Instance().addListener(ApplicationMessages.PROGRESS_LOAD, 			this);
			EventDispatcher.Instance().addListener(ApplicationMessages.COMPLETE_LOAD_PRELOADER, this);
			EventDispatcher.Instance().addListener(ApplicationMessages.COMPLETE_LOAD, 			this);
		}
		
		public function receiveMessage(messageId:int, data:Object):void{
			
			switch(messageId)
			{
				case ApplicationMessages.PROGRESS_LOAD:{
					
					break;
				}
					
				case ApplicationMessages.COMPLETE_LOAD_PRELOADER:{
					
					//preloaderLoaded();					
					break;
				}
					
				case ApplicationMessages.COMPLETE_LOAD:{
					
					loadComplete();					
					break;
				}
			}
		}
	}
}