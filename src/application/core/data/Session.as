package application.core.data
{
	import application.core.interfaces.IGameManager;
	import application.core.interfaces.IUserProfile;

	public class Session
	{
		private static var _instance:		Session;
		
		private var _userProfile:		IUserProfile;
		private var _gameManager:		IGameManager;
		
		public function Session()
		{
			
		}
		
		
		public static function getInstance():Session
		{
			if(_instance == null)
				_instance = new Session();
			
			return _instance;
		}
		
		public function setUserProfile(value:IUserProfile):void
		{
			_userProfile = value;
		}
		
		public function getUserProfile():IUserProfile
		{
			return _userProfile;
		}
		
		
		public function setGameManager(value:IGameManager):void
		{
			_gameManager = value;
		}
		
		public function getGameManager():IGameManager
		{
			return _gameManager;
		}
	}
}