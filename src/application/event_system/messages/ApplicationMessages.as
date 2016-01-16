package application.event_system.messages
{
	import application.event_system.components.IdCreator;

	public class ApplicationMessages
	{
				
		
		public static var PROGRESS_LOAD				:int = IdCreator.getUid();
		public static var COMPLETE_LOAD_PRELOADER	:int = IdCreator.getUid();
		public static var COMPLETE_LOAD				:int = IdCreator.getUid();
	}
}