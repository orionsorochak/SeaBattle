package application.core.game
{
	public interface IGameLoader
	{
		function setShipsPosition():void;
		function setDifficult(level:int):void;
		function loadGame():void;
		function getGame():IGame;
	}
}