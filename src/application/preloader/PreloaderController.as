package application.preloader
{
	import application.AppGlobalVariables;
	import application.event_system.EventDispatcher;
	import application.event_system.messages.ApplicationMessages;
	import application.event_system.messages.PreloaderMessages;
	import application.interfaces.IModule;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public class PreloaderController implements IModule{
		
		private var mainStage:				Sprite;
		private var preloaderView:			PreloaderView;
		private var preloaderStage:			Sprite;
		
		private var timeShowing:			Timer = new Timer(AppGlobalVariables.SHOWING_TIME_PRELOADER, 1);
		
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
			
			setTimeForShowingPreloader();
			EventDispatcher.Instance().removeListener(ApplicationMessages.COMPLETE_LOAD, 		this);
		}
		
		private function setTimeForShowingPreloader():void
		{
			timeShowing.addEventListener(TimerEvent.TIMER_COMPLETE, endTime);
			timeShowing.start();
		}
		
		private function endTime(e:Event):void
		{
			timeShowing.stop();
			timeShowing.removeEventListener(TimerEvent.TIMER_COMPLETE, endTime);
			
			EventDispatcher.Instance().sendMessage(PreloaderMessages.END_SHOW_PRELOADER_PAGE, null);
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