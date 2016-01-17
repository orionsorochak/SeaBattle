package application.event_system.messages
{
	import application.event_system.components.UID;

	public class GameBattleMessages
	{
		public static const GAME_STARTED:		int = UID.getUid()	/*String = "gameStarted"*/;
		public static const GAME_UPDATED:		int = UID.getUid()	/*String = "gameUpdated"*/;
	}
}