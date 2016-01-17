package application.core.data.profile
{
	import application.core.interfaces.IAuthUserData;
	import application.core.interfaces.IUserProfile;

	public class UserProfileManager implements IUserProfile
	{
		private var _name:		String;
		private var _email:		String;
		private var _systemId:	String;
		
		public function UserProfileManager()
		{
			
		}
		
		public function setAuthorizationData(data:IAuthUserData):void
		{
			_name = data.name;
			_email = data.email;
			_systemId = data.systemId;
		}
		
		public function get name():String
		{
			return _name;
		}
		
		public function get email():String
		{
			return _email;
		}
		
		public function get systemId():String
		{
			return _systemId;
		}
	}
}