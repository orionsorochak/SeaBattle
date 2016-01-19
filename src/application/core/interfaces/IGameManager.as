package application.core.interfaces
{
	public interface IGameManager
	{
		/*
		@param type = application.core.data.game.GameType...
		*/
		function createNewGame(type:int):IGameLoader;
	}
}