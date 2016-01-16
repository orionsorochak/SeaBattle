package application.core.events
{
	import application.event_system.components.IdCreator;

	public class CoreEvents
	{
		public static const APP_MODULE_INIT_COMPLETE:	int = IdCreator.getUid();
		
		public static const AUTHORIZATION_COMPLETE:		int = IdCreator.getUid();
		public static const AUTHORIZATION_ERROR:		int = IdCreator.getUid();
	}
}