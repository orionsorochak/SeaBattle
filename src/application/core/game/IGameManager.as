package application.core.game
{
	public interface IGameManager
	{
		function createNewGame(type:int):IGameLoader;
	}
}