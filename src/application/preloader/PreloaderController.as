package application.preloader
{
	import application.event_system.EventDispatcher;
	import application.event_system.messages.ApplicationMessages;
	import application.event_system.messages.PreloaderMessages;
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
		
		public function init():void{			
				
			preloaderStage = new Sprite();
			mainStage.addChild(preloaderStage);
			
			preloaderView = new PreloaderView(preloaderStage);			
			
			addListeners();
		}
		
		private function preloaderLoaded():void{
			preloaderView.show();
		}
		
		private function loadComplete():void{
			
			EventDispatcher.Instance().sendMessage(PreloaderMessages.END_SHOW_PRELOADER_PAGE,   null);
			EventDispatcher.Instance().removeListener(ApplicationMessages.COMPLETE_LOAD, 		this);
		}
		
		public function preloaderViewShowComplete():void{
										
			EventDispatcher.Instance().removeListener(PreloaderMessages.PRELOADER_PAGE_IS_ACTIVE, 	this);
		}
		
		private function addListeners():void{
			
			EventDispatcher.Instance().addListener(ApplicationMessages.PROGRESS_LOAD, 			this);
			EventDispatcher.Instance().addListener(ApplicationMessages.COMPLETE_LOAD_PRELOADER, this);
			EventDispatcher.Instance().addListener(ApplicationMessages.COMPLETE_LOAD, 			this);
			
			EventDispatcher.Instance().addListener(PreloaderMessages.PRELOADER_PAGE_IS_ACTIVE, 	this);
		}
		
		public function receiveMessage(messageId:int, data:Object):void{
			
			switch(messageId)
			{
				case ApplicationMessages.PROGRESS_LOAD:{
					
					break;
				}
					
				case ApplicationMessages.COMPLETE_LOAD_PRELOADER:{
					
					preloaderLoaded();					
					break;
				}
					
				case ApplicationMessages.COMPLETE_LOAD:{
					
					loadComplete();					
					break;
				}
					
				case PreloaderMessages.PRELOADER_PAGE_IS_ACTIVE:{
					
					preloaderViewShowComplete();					
					break;
				}	
			}
		}
		
		public function destroy():void{
			
			if(preloaderView){
				
				preloaderView.destroy();
				preloaderView = null;
			}
					
			if(preloaderStage && mainStage.contains(preloaderStage)){
				
				mainStage.removeChild(preloaderStage);
				preloaderStage = null;
			}			
		}
	}
}