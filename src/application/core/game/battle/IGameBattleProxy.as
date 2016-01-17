package application.core.game.battle
{
	import application.core.data.game.GamePlayerData;
	
	public interface IGameBattleProxy
	{
		function getStatus():uint;
		function getAction():GameBattleAction;
		function getUserPlayerInfo():GamePlayerData;
		function getOpponentPlayerInfo():GamePlayerData
		
	}
}