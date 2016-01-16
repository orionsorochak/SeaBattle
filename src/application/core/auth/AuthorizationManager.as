package application.core.auth
{
	import application.core.events.CoreEvents;
	import application.event_system.EventDispatcher;

	public class AuthorizationManager implements IAuthManager
	{
		private const UNAUTHORIZED:		int = 0;
		private const GOOGLE_PLAY:		int = 1;
		private const ANONYMOUS:		int = 2;
		
		private var _status:			uint;
		
		public function AuthorizationManager()
		{
			_status = UNAUTHORIZED;
		}
		
		
		public function connectToGooglePlayAPI():void
		{
			if(_status == UNAUTHORIZED || _status == ANONYMOUS)
			{
				var user:AuthUserData = new AuthUserData();
				user.setName("Default name");
				user.setEmail("Default email");
				user.setSystemId("Default_id_1");
				
				_status = GOOGLE_PLAY;
				
				EventDispatcher.Instance().sendMessage( CoreEvents.AUTHORIZATION_COMPLETE, user );
			}
		}
		
		public function createAnonymousUser():void
		{
			if(_status == UNAUTHORIZED)
			{
				var user:AuthUserData = new AuthUserData();
				user.setName("Default name");
				user.setEmail("Default email");
				user.setSystemId("Default_id_1");
				
				_status = ANONYMOUS;
				
				EventDispatcher.Instance().sendMessage( CoreEvents.AUTHORIZATION_COMPLETE, user );
			}
		}
	}
}