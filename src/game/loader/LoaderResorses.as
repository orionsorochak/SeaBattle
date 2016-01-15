package game.loader
{
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;	
	
	import game.AppGlobalVariables;
	
	[Event(name="complete", 		type="flash.events.Event")]
	[Event(name="progress ", 		type="flash.events.ProgressEvent")]
	public class LoaderResorses extends EventDispatcher
	{
		public static const FILE_LOADED:	String = "file_loaded";
		
		private var filesQueue:			Vector.<String>;
		private var domain:				ApplicationDomain;
		
		private var filesNumber:		uint;
		private var filesLoaded:		uint;
		private var fileProgressRange:	Number;
		
		private var percent:			Number;
		
		public function LoaderResorses(){
			
			domain = new ApplicationDomain(ApplicationDomain.currentDomain);
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
			
			if(filesQueue.length > 0)
			{
				var url:String = filesQueue.shift();
				
				var loader:Loader = new Loader();
				
				loader.contentLoaderInfo.addEventListener(Event.INIT, 			 	handlerFileLoadComplete);
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, 	handlerErrorLoadFile);
				loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, 	handlerProgressLoadFile);
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, 			handlerCompleteLoadFile);
				
				loader.load(new URLRequest(url), new LoaderContext(false, domain));
			}
			else
			{
				this.dispatchEvent( new Event(Event.COMPLETE) );
			}
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
			this.dispatchEvent( new ProgressEvent(ProgressEvent.PROGRESS, false, true, percent, 1 ) );
			
			trace(percent);
		}
		
		private function handlerCompleteLoadFile(e:Event):void{
			
			if(e.currentTarget.url == "app:/data/preloader.swf")
				this.dispatchEvent( new Event(FILE_LOADED) );
		}
	}
}