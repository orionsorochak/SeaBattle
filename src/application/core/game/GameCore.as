package application.core.game
{
	import application.core.data.game.ShipData;
	import application.event_system.EventDispatcher;
	import application.event_system.messages.ApplicationMessages;
	import application.event_system.messages.CoreMessages;
	import application.interfaces.IModule;
		
	public class GameCore implements IModule 
	{
		protected var shipsList:			Vector.<ShipData>;
		
		public function GameCore()
		{
			init();
		}
		
		public function init():void
		{
			addListeners();
		}
		
		private function showGame():void
		{
			generateShipList();
		}		
		
		private function generateShipList(decksList:Vector.<uint> = null):void
		{
			shipsList = new Vector.<ShipData>(decksList.length, true);
			
			var i:int, ship:ShipData;
			
			for(i = 0; i < decksList.length; i++)
			{
				ship = new ShipData();
				
				ship.x = -10;
				ship.y = -10;
				
				ship.deck = decksList[i];
				shipsList[i] =  ship ;
			}
		}
		
		
		public function getShipsList():void
		{
			EventDispatcher.Instance().sendMessage(CoreMessages.SET_SHIP_LIST , shipsList);
		}
		
		
		private function addListeners():void{
			
			EventDispatcher.Instance().addListener(ApplicationMessages.SHOW_GAME,	this);
			EventDispatcher.Instance().addListener(CoreMessages.GET_SHIP_LIST,		this);
		}
		
		
		public function receiveMessage(messageId:int, data:Object):void{
			
			switch(messageId)
			{					
				case ApplicationMessages.SHOW_GAME:{
					
					showGame();
					break;
				}
					
				case CoreMessages.GET_SHIP_LIST:{
					
					getShipsList();
					break;
				}
			}
		}
		
		public function destroy():void
		{
			
		}
	}
}