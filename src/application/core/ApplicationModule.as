package application.core
{
	import application.core.auth.AuthorizationManager;
	import application.core.auth.IAuthManager;
	import application.core.data.IAuthUserData;
	import application.core.data.Session;
	import application.core.data.profile.UserProfileManager;
	import application.core.events.CoreEvents;
	import application.event_system.EventDispatcher;
	import application.interfaces.IModule;

	public class ApplicationModule implements IModule, IApplicationModule
	{
		private static var _instance:		ApplicationModule;
		
		private var _authManager:		IAuthManager;
		
		private var _profileManager:	UserProfileManager;
		
		public function ApplicationModule()
		{
			if(_instance == null)
				_instance = this;
			else
				throw new Error("Multiple creation of ApplicationModule unacceptable");
		}
		
		public static function getInstance():IApplicationModule
		{
			if(_instance == null)
				new ApplicationModule();
			
			return _instance;
		}
		
		
		
		//------------- IModule ---------------
		public function init():void
		{
			_authManager = new AuthorizationManager();
			
			EventDispatcher.Instance().addListener( CoreEvents.AUTHORIZATION_COMPLETE, this);
			EventDispatcher.Instance().addListener( CoreEvents.AUTHORIZATION_ERROR, this);
			
			EventDispatcher.Instance().sendMessage( CoreEvents.APP_MODULE_INIT_COMPLETE, null );
		}
		
		public function receiveMessage(messageId:int, data:Object):void
		{
			switch(messageId)
			{
				case CoreEvents.AUTHORIZATION_COMPLETE:
				{
					initializeApplicationModules(data as IAuthUserData);
					break;
				}
					
				case CoreEvents.AUTHORIZATION_ERROR:
				{
					
					break;
				}
			}
		}
		
		public function destroy():void
		{
			
		}
		
		
		public function getAuthManager():IAuthManager
		{
			return _authManager;
		}
		
		
		
		private function initializeApplicationModules(data:IAuthUserData):void
		{
			if( !_profileManager )
			{
				_profileManager = new UserProfileManager();
				_profileManager.setAuthorizationData( data );
				
				Session.getInstance().setUserProfile( _profileManager );
			}
		}
		
	}
}