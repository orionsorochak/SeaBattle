package application.interfaces
{
	public interface IPage
	{
		function show():void;
		function onShowComplete():void;
		function destroy():void;
	}
}