package application.core.interfaces
{
	import application.core.data.game.ShipData;

	public interface IGameLoader
	{
		function getShipList():Vector.<ShipData>;
		function setDifficult(level:int):void;
		function loadGame():void;
		function getGame():IGame;
	}
}