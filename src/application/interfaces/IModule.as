package application.interfaces
{
	public interface IModule
	{
		function init():void
		function receiveMessage(messageId:int, data:Object):void;
		function destroy():void
	}
}