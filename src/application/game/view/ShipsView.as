package application.game.view
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.system.ApplicationDomain;

	public class ShipsView
	{
		public static const LINK_NAME:		String = "viewShips";
		
		private var gameStage:				Sprite;
		private var shipsTable:				MovieClip;
		
		public function ShipsView(_gameStage:Sprite)
		{
			gameStage = _gameStage;
			init();
		}
		
		private function init():void
		{
			var classInstance:Class = ApplicationDomain.currentDomain.getDefinition(LINK_NAME) as Class;
			shipsTable = new classInstance();
			gameStage.addChild( shipsTable );
		}
		
		public function getShips():MovieClip
		{
			return shipsTable;
		}
		
		public function toTop():void
		{
			gameStage.setChildIndex( shipsTable, gameStage.numChildren -1  );
		}
	}
}