package application.core.auth
{
	public interface IAuthManager
	{
		function connectToGooglePlayAPI():void;
		function createAnonymousUser():void;
	}
}