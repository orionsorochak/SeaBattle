package application.menu.view.bg_page
{
	import application.AppGlobalVariables;
	import application.interfaces.IPage;
	
	import com.greensock.TweenLite;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.system.ApplicationDomain;

	public class BgPageView implements IPage
	{
		private var menuStage:			Sprite;			
		private var linkToTable:		MovieClip;		
		private var tween:				TweenLite;		
		
		public function BgPageView(_menuStage:Sprite){
			
			menuStage = _menuStage;
		}
		
		public function show():void{
			
			var elementClass:Class = ApplicationDomain.currentDomain.getDefinition(BgPageVariables.TABLE_CLASS_NAME) as Class;
			linkToTable = new elementClass();			
			linkToTable.alpha = 0;
			
			menuStage.addChild(linkToTable);
			
			tween = TweenLite.to(linkToTable, AppGlobalVariables.PAGE_FADE_ODE_TIME, {alpha:1, onComplete:onShowComplete});
		}
				
		public function onShowComplete():void{
			
			tween.kill();
			tween = null;
			
//			EventDispatcher.Instance().sendMessage(MenuMessages.MENU_PAGE_IS_ACTIVE, LevelPageVariables.NAME);	
			
			setListeners();
		}
		
		public function hide():void
		{
			linkToTable.visible = false;
		}
		
		private function setListeners():void{
//			linkToTable.addEventListener(MouseEvent.MOUSE_DOWN, buttonClickHandler);
		}
		
		public function destroy():void{
			
			if(tween){
				tween.kill();
				tween = null;
			}			
			
			if(linkToTable && menuStage.contains(linkToTable)){
				
				menuStage.removeChild(linkToTable);
				linkToTable = null;
			}
		}
	}
}