package application.event_system.messages
{
	import application.event_system.components.UID;

	public class ApplicationMessages
	{		
		public static var PROGRESS_LOAD				:int = UID.getUid();
		public static var COMPLETE_LOAD_PRELOADER	:int = UID.getUid();
		public static var COMPLETE_LOAD				:int = UID.getUid();
		
		public static var SHOW_MENU					:int = UID.getUid();
		public static var SHOW_GAME					:int = UID.getUid();
		
		public static var REMOVE_PRELOADER			:int = UID.getUid();
		
		public static var MOVE_BACK					:int = UID.getUid();
	}
}