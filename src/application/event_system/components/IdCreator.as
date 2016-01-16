package application.event_system.components
{
	public class IdCreator
	{
		private static var UID:int;
		
		public static function getUid():int
		{
			return UID++;
		}
	}
}