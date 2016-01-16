package application.loader
{
	import application.AppGlobalVariables;
	import application.event_system.EventDispatcher;
	import application.event_system.messages.ApplicationMessages;
	
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	
	public class LoaderResorses{
		
		public static const PRELOADER_URL:	String = "app:/data/preloader.swf";
		
		private var filesQueue:			Vector.<String>;
		
		private var filesNumber:		uint;
		private var filesLoaded:		uint;
		private var fileProgressRange:	Number;
		
		private var percent:			Number;
		
		public function LoaderResorses(){
			
			setLoadQeue();				
		}
		
		private function setLoadQeue():void{
			
			filesQueue = new Vector.<String>();
			
			filesQueue.push(AppGlobalVariables.PRELOADER_URL);
			filesQueue.push(AppGlobalVariables.SOURCE_URL);
			filesQueue.push(AppGlobalVariables.ANIMATIONS_URL);
		}
		
		public function load():void{
			
			filesNumber = filesQueue.length;
			filesLoaded = 0;
			fileProgressRange = 1/filesNumber;
			
			loadNextFile();
		}
		
		private function loadNextFile():void{
			
			if(filesQueue.length > 0){
				
				var url:String = filesQueue.shift();
				
				var loader:Loader = new Loader();
				
				loader.contentLoaderInfo.addEventListener(Event.INIT, 			 	handlerFileLoadComplete);
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, 	handlerErrorLoadFile);
				loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, 	handlerProgressLoadFile);
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, 			handlerCompleteLoadFile);
				
				loader.load(new URLRequest(url), new LoaderContext(false, ApplicationDomain(ApplicationDomain.currentDomain)));
			}
			else
				EventDispatcher.Instance().sendMessage(ApplicationMessages.COMPLETE_LOAD, null);
		}
		
		
		
		private function handlerFileLoadComplete(e:Event):void{
			
			var loaderInfo:LoaderInfo = e.currentTarget as LoaderInfo;
			loaderInfo.removeEventListener(Event.INIT, handlerFileLoadComplete);
			loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, handlerErrorLoadFile);
			
			filesLoaded ++;
			
			loadNextFile();
		}
		
		private function handlerErrorLoadFile(e:IOErrorEvent):void{
			
			var loaderInfo:LoaderInfo = e.currentTarget as LoaderInfo;
			loaderInfo.removeEventListener(Event.INIT, handlerFileLoadComplete);
			loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, handlerErrorLoadFile);
			
			loadNextFile();
		}
		
		private function handlerProgressLoadFile(e:ProgressEvent):void{
			
			var value:Number = e.bytesLoaded/e.bytesTotal;
			
			percent = filesLoaded * fileProgressRange + value * fileProgressRange;
			
			EventDispatcher.Instance().sendMessage(ApplicationMessages.PROGRESS_LOAD, percent);
			
			trace(percent);
		}
		
		private function handlerCompleteLoadFile(e:Event):void{
			
			if(e.currentTarget.url == PRELOADER_URL)
				EventDispatcher.Instance().sendMessage(ApplicationMessages.COMPLETE_LOAD_PRELOADER, null);				
		}
	}
}