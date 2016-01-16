package application.menu
{
	import application.interfaces.IPage;

	public class MenuData
	{
		private var prevPage:	IPage;
		private var curPage:	IPage;
		
		public function MenuData()
		{
			
		}
		
		public function set previousPage(page:IPage):void
		{
			prevPage = page;
		}
		
		public function get previousPage():IPage
		{
			return prevPage;
		}
		
		public function set currentPage(page:IPage):void
		{
			curPage = page;
		}
		
		public function get currentPage():IPage
		{
			return curPage;
		}
	}
}