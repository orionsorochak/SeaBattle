package game
{
	import game.loader.LoaderResorses;

	public class ApplicationController
	{
		private var linkToEnterPoint:	SeaBattle;
		private var loaderResources:	LoaderResorses;
		
		public function ApplicationController(_linkToEnterPoint:SeaBattle){
			
			linkToEnterPoint = _linkToEnterPoint;
			
			init();
		}
		
		private function init():void{
			
			loaderResources = new LoaderResorses();
			loaderResources.load();
		}
	}
}