package application
{
	import application.core.auth.AuthorizationManager;
	import application.core.data.Session;
	import application.core.data.profile.UserProfileManager;
	import application.core.game.GameCore;
	import application.core.game.GameManager;
	import application.core.interfaces.IAuthManager;
	import application.core.interfaces.IAuthUserData;
	import application.core.interfaces.IGameManager;
	import application.event_system.EventDispatcher;
	import application.event_system.messages.ApplicationMessages;
	import application.event_system.messages.CoreMessages;
	import application.event_system.messages.MenuMessages;
	import application.interfaces.IApplicationModule;
	import application.interfaces.IModule;

	public class ApplicationModule implements IModule, IApplicationModule
	{
		private static var _instance:		ApplicationModule;
		
		private var _authManager:		IAuthManager;
		
		private var _profileManager:	UserProfileManager;
		private var _gameManager:		GameManager;
		
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
			
			EventDispatcher.Instance().addListener( CoreMessages.AUTHORIZATION_COMPLETE, this);
			EventDispatcher.Instance().addListener( CoreMessages.AUTHORIZATION_ERROR, this);
			
			EventDispatcher.Instance().sendMessage( CoreMessages.APP_MODULE_INIT_COMPLETE, null );
			EventDispatcher.Instance().addListener( CoreMessages.INIT_GAME_CORE,	this);
		}
		
		public function receiveMessage(messageId:int, data:Object):void
		{
			switch(messageId)
			{
				case CoreMessages.AUTHORIZATION_COMPLETE:
				{
					initializeApplicationModules(data as IAuthUserData);
					break;
				}
					
				case CoreMessages.AUTHORIZATION_ERROR:
				{
					
					break;
				}
					
				case CoreMessages.INIT_GAME_CORE:
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
		
		public function getGameManager():IGameManager
		{
			return _gameManager;
		}
		
		
		
		private function initializeApplicationModules(data:IAuthUserData):void
		{
			if( !_profileManager )
			{
				_profileManager = new UserProfileManager();
				_profileManager.setAuthorizationData( data );
				
				Session.getInstance().setUserProfile( _profileManager );
			}
			
			if( !_gameManager )
			{
				_gameManager = new GameManager();
				Session.getInstance().setGameManager( _gameManager );
			}
		}
	}
}