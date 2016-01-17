package application.core.auth
{
	import application.core.interfaces.IAuthUserData;
	
	public class AuthUserData implements IAuthUserData
	{
		private var _name:		String;
		private var _email:		String;
		private var _systemId:	String;
		
		public function AuthUserData()
		{
			
		}
		
		public function setName(value:String):void
		{
			_name = value;
		}
		
		public function get name():String
		{
			return _name;
		}
		
		
		public function setEmail(value:String):void
		{
			_email = value;
		}
		
		public function get email():String
		{
			return _email;
		}
		
		public function setSystemId(value:String):void
		{
			_systemId = value;
		}
		
		public function get systemId():String
		{
			return _systemId;
		}
	}
}