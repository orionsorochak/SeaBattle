package application.core.game.p_vs_computer
{
	import application.core.data.game.ShipData;
	import application.core.interfaces.IGame;
	import application.core.interfaces.IGameLoader;
	
	public class GameVSComputerLoader implements IGameLoader
	{
		private var _shipList:		Vector.<ShipData>;
		private var _difficult:		uint;
		
		private const shipsDeckList:	Vector.<uint> = new <uint>[4, 3, 3, 2, 2, 2, 1, 1, 1, 1];
		
		public function GameVSComputerLoader()
		{
			initializeShipList();
		}
		
		
		public function getShipList():Vector.<ShipData>
		{
			return _shipList.concat();
		}
		
		public function setDifficult(level:int):void
		{
			_difficult = level;
		}
		
		public function loadGame():void
		{
			
		}
		
		public function getGame():IGame
		{
			return null;
		}
		
		
		private function initializeShipList():void
		{
			_shipList = new Vector.<ShipData>(shipsDeckList.length, true);
			
			var i:int, ship:ShipData;
			
			for(i = 0; i < _shipList.length; i++)
			{
				ship = new ShipData();
				
				ship.x = -10;
				ship.y = -10;
				
				ship.deck = shipsDeckList[i];
				_shipList[i] =  ship ;
			}
			
			/*
			_shipList = new Vector.<ShipData>(10, true);
			_shipList[0] = new ShipData(4);
			
			_shipList[1] = new ShipData(3);
			_shipList[2] = new ShipData(3);
			
			_shipList[3] = new ShipData(2);
			_shipList[4] = new ShipData(2);
			_shipList[5] = new ShipData(2);
			
			_shipList[6] = new ShipData(1);
			_shipList[7] = new ShipData(1);
			_shipList[8] = new ShipData(1);
			_shipList[9] = new ShipData(1);*/
		}
	}
}