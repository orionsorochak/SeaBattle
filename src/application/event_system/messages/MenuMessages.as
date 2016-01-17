package application.event_system.messages
{
	import application.event_system.components.UID;

	public class MenuMessages
	{
		public static var MENU_PAGE_IS_ACTIVE:		int = UID.getUid();
		
		public static var MAIN_MENU_BTN_CLICKED:	int = UID.getUid();
		public static var LEVEL_BTN_CLICKED:		int = UID.getUid();
		public static var PROFILE_BTN_CLICKED:		int = UID.getUid();
		public static var SETTINGS_BTN_CLICKED:		int = UID.getUid();
	}
}