package application.event_system.messages
{
	import application.event_system.components.UID;

	public class PreloaderMessages
	{
		public static var PRELOADER_PAGE_IS_ACTIVE:	int = UID.getUid();		
		public static var END_SHOW_PRELOADER_PAGE:	int = UID.getUid();	
	}
}