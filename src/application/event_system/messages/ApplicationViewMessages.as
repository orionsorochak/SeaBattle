package application.event_system.messages
{
	import application.event_system.components.IdCreator;

	public class ApplicationViewMessages
	{
		public static var PRELOADER_SHOWED:int = IdCreator.getUid();
	}
}