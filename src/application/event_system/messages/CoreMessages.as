package application.event_system.messages
{
	import application.event_system.components.UID;

	public class CoreMessages
	{
		public static const APP_MODULE_INIT_COMPLETE:	int = UID.getUid();
		
		public static const AUTHORIZATION_COMPLETE:		int = UID.getUid();
		public static const AUTHORIZATION_ERROR:		int = UID.getUid();
	}
}