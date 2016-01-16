package application.core
{
	import application.core.auth.IAuthManager;

	public interface IApplicationModule
	{
		function init():void;
		function getAuthManager():IAuthManager;
	}
}