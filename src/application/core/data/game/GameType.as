package application.core.data.game
{
	import application.event_system.components.UID;

	public class GameType
	{
		public static const PLAYER_VS_COMPUTER:				uint = UID.getUid();
		public static const PLAYER_VS_RANDOM_INTERNET:		uint = UID.getUid();
	}
}