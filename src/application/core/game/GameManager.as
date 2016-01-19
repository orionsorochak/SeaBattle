package application.core.game
{
	import application.core.data.game.GameType;
	import application.core.game.p_vs_computer.GameVSComputerLoader;
	import application.core.interfaces.IGameLoader;
	import application.core.interfaces.IGameManager;
	
	public class GameManager implements IGameManager
	{
		private var _currentGameLoader:		IGameLoader;
		
		public function GameManager()
		{
			
		}
		
		public function createNewGame(type:int):IGameLoader
		{
			var gameLoader:IGameLoader;
			
			switch(type)
			{
				case GameType.PLAYER_VS_COMPUTER:
				{
					gameLoader = new GameVSComputerLoader();
					break;
				}
					
				case GameType.PLAYER_VS_RANDOM_INTERNET:
				{
					
					break;
				}
			}
			
			if(gameLoader)
				_currentGameLoader = gameLoader;
			
			return gameLoader;
		}
	}
}