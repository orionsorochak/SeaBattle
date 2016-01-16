package application.event_system.messages
{
	import application.event_system.components.IdCreator;

	public class PreloaderMessages
	{
		public static var PRELOADER_PAGE_IS_ACTIVE:	int = IdCreator.getUid();		
		public static var END_SHOW_PRELOADER_PAGE:	int = IdCreator.getUid();	
	}
}