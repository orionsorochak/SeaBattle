package application.event_system
{	
	import application.interfaces.IModule;
	
	import flash.utils.Dictionary;
	
	public class EventDispatcher{
		
		private static var instance:	EventDispatcher;
		
		private var listOfRecipients:	Dictionary = new Dictionary();
		
		public function EventDispatcher()
		{
		}
		
		public static function Instance():EventDispatcher{
			
			if(!instance)
				instance = new EventDispatcher();
			
			return instance;
		}
		
		public function sendMessage(messageId:int, data:Object):void{
			
			if(listOfRecipients[messageId]){
				
				var messageRecipients:Vector.<IModule> = listOfRecipients[messageId].concat();
				
				for (var i:int = 0; i < messageRecipients.length; i++)
					messageRecipients[i].receiveMessage(messageId, data);		
			}
		}
		
		public function addListener(messageId:int, listenerModule:IModule):void{
			
			var messageRecipients:Vector.<IModule> = new Vector.<IModule>();
			
			if(listOfRecipients[messageId]){
				
				messageRecipients = listOfRecipients[messageId];
				listOfRecipients[messageId].push(listenerModule);
			}
				
			else{
								
				messageRecipients.push(listenerModule);				
				listOfRecipients[messageId] = messageRecipients;
			}
		}
		
		public function removeListener(messageId:int, listenerModule:IModule):void{
						
			if(listOfRecipients[messageId]){
				
				if(listOfRecipients[messageId].indexOf(listenerModule) != -1){
					
					listOfRecipients[messageId].splice(listOfRecipients[messageId].indexOf(listenerModule), 1);
				}
			}
		}
	}
}