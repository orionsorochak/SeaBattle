package application.interfaces
{
	import application.core.interfaces.IAuthManager;

	public interface IApplicationModule
	{
		function init():void;
		function getAuthManager():IAuthManager;
	}
}