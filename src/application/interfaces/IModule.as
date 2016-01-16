package application.interfaces
{
	public interface IModule
	{
		function receiveMessage(messageId:int, data:Object):void;
	}
}