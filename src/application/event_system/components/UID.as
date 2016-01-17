package application.event_system.components
{
	public class UID
	{
		private static var UID:int;
		
		public static function getUid():int
		{
			return UID++;
		}
	}
}