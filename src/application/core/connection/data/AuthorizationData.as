package game.application.connection.data
{
	import game.application.connection.ChannelData;
	import game.application.connection.ChannelDataType;
	import game.application.connection.ServerDataChannelEvent;
	
	public class AuthorizationData extends ChannelData
	{
		public var userInfo:		UserInfo;
		
		public var session:			String;
		
		public var error:			Boolean;
		public var errorCode:		int;
		public var errorMessage:	String;
		
		public function AuthorizationData()
		{
			super();
			this._type = ChannelDataType.AUTHORIZATION;
		}
	}
}