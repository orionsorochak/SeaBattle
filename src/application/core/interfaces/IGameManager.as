package application.core.interfaces
{
	public interface IGameManager
	{
		function createNewGame(type:int):IGameLoader;
	}
}