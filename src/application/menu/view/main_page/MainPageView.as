package application.menu.view.main_page
{
	import application.AppGlobalVariables;
	import application.event_system.EventDispatcher;
	import application.event_system.messages.MenuMessages;
	import application.event_system.messages.PreloaderMessages;
	import application.interfaces.IPage;
	
	import com.greensock.TweenLite;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.system.ApplicationDomain;

	public class MainPageView implements IPage{
		
		private var menuStage:			Sprite;			
		private var linkToTable:		MovieClip;		
		private var tween:				TweenLite;
		
		public function MainPageView(_menuStage:Sprite){
			
			menuStage = _menuStage;
		}
		
		public function show():void{
			
			var elementClass:Class = ApplicationDomain.currentDomain.getDefinition(MainPageVariables.TABLE_CLASS_NAME) as Class;
			linkToTable = new elementClass();			
			linkToTable.alpha = 0;
			
			menuStage.addChild(linkToTable);
			
			tween = TweenLite.to(linkToTable, AppGlobalVariables.PAGE_FADE_ODE_TIME, {alpha:1, onComplete:onShowComplete});
		}
		
		public function onShowComplete():void{
			
			tween.kill();
			tween = null;
			
			EventDispatcher.Instance().sendMessage(MenuMessages.MENU_PAGE_IS_ACTIVE, MainPageVariables.NAME);	
			
			setListeners();
		}
		
		private function setListeners():void{
			linkToTable.addEventListener(MouseEvent.MOUSE_DOWN, buttonClickHandler);
		}
		
		private function buttonClickHandler(e:Event):void{
			EventDispatcher.Instance().sendMessage(MenuMessages.MAIN_MENU_BTN_CLICKED, e.target.name);	
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