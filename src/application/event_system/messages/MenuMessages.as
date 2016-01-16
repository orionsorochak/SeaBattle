package application.event_system.messages
{
	import application.event_system.components.IdCreator;

	public class MenuMessages
	{
		public static var MENU_PAGE_IS_ACTIVE:		int = IdCreator.getUid();
		
		public static var MAIN_MENU_BTN_CLICKED:	int = IdCreator.getUid();
	}
}