package application.menu
{
	import application.ApplicationController;
	import application.event_system.EventDispatcher;
	import application.event_system.messages.ApplicationMessages;
	import application.event_system.messages.CoreMessages;
	import application.event_system.messages.MenuMessages;
	import application.event_system.messages.PreloaderMessages;
	import application.interfaces.IModule;
	import application.menu.view.bg_page.BgPageView;
	import application.menu.view.level_page.LevelPageVariables;
	import application.menu.view.level_page.LevelPageView;
	import application.menu.view.main_page.MainPageVariables;
	import application.menu.view.main_page.MainPageView;
	import application.menu.view.profile.ProfilePageVariables;
	import application.menu.view.profile.ProfilePageView;
	import application.menu.view.settings_page.SettingsPageVariables;
	import application.menu.view.settings_page.SettingsPageView;
	
	import flash.display.Sprite;

	public class MenuController implements IModule{
		
		private var applicationStage:	Sprite;
		private var menuStage:			Sprite;
		private var menuData:			MenuData;
		
		private var menuBgView:			BgPageView;
		
		public function MenuController(_applicationStage:Sprite){
			
			applicationStage = _applicationStage;
			init();
			showMainMenuPage();
		}
		
		public function init():void{		
			
			menuData = new MenuData();
			
			addListeners();
		}
		
		private function showMainMenuPage():void{			
			
			menuStage = new Sprite();
			applicationStage.addChild(menuStage);
			
			menuBgView = new BgPageView(menuStage);
			menuBgView.show();
			
			menuData.currentPage = new MainPageView(menuStage);
			menuData.currentPage.show();			
		}
		
		private function menuPageShowed(pageName:String):void{
			
			switch(pageName)
			{
				case MainPageVariables.NAME:
				{
					EventDispatcher.Instance().sendMessage(ApplicationMessages.REMOVE_PRELOADER, null);
					break;
				}
			}
			
		}
		
		private function removePreviousPage():void{
			
			if(menuData.previousPage){
				menuData.previousPage.destroy();
				menuData.previousPage = null;
			}
		}
		
		private function mainMenuBtnClicked(buttonName:String):void{
			
			switch(buttonName)
			{
				case MainPageVariables.COMPUTER_BTN_NAME:
				{
					menuData.previousPage = menuData.currentPage;
					
					menuData.currentPage = new LevelPageView(menuStage);
					menuData.currentPage.show();
					
					EventDispatcher.Instance().sendMessage(CoreMessages.INIT_GAME_CORE, null);
					
					break;
				}
					
				case MainPageVariables.PROFILER_BTN_NAME:
				{
					menuData.previousPage = menuData.currentPage;
					
					menuData.currentPage = new ProfilePageView(menuStage);
					menuData.currentPage.show();
					
					break;
				}
					
				case MainPageVariables.SETTINGS_BTN_NAME:
				{
					menuData.previousPage = menuData.currentPage;
					
					menuData.currentPage = new SettingsPageView(menuStage);
					menuData.currentPage.show();
					
					break;
				}
			}
		}
		
		private function showMainPage():void
		{
			menuData.previousPage = menuData.currentPage;
			
			menuData.currentPage = new MainPageView(menuStage);
			menuData.currentPage.show();
		}
		
		private function levelBtnClicked(buttonName:String):void{
			
			switch(buttonName){
				
				case LevelPageVariables.LOW_BTN_NAME:{
					
					EventDispatcher.Instance().sendMessage(ApplicationMessages.SHOW_GAME, null);
					break;
				}
				case LevelPageVariables.MIDDLE_BTN_NAME:{
					
					EventDispatcher.Instance().sendMessage(ApplicationMessages.SHOW_GAME, null);
					break;
				}
				case LevelPageVariables.HIGH_BTN_NAME:{
					
					EventDispatcher.Instance().sendMessage(ApplicationMessages.SHOW_GAME, null);
					break;
				}
				case LevelPageVariables.BACK_BTN_NAME:{
					
					showMainPage();					
					break;
				}
			}
		}
		
		private function profileBtnClicked(buttonName:String):void{
			
			switch(buttonName){
				
				case ProfilePageVariables.BACK_BTN_NAME:{
					
					showMainPage();							
					break;
				}
			}
		}
		
		private function settingsBtnClicked(buttonName:String):void{
			
			switch(buttonName){
				
				case SettingsPageVariables.BACK_BTN_NAME:{
					
					showMainPage();							
					break;
				}
			}
		}
		
		private function addListeners():void{
			
			EventDispatcher.Instance().addListener(ApplicationMessages.SHOW_MENU,   	this);									
			EventDispatcher.Instance().addListener(MenuMessages.MENU_PAGE_IS_ACTIVE, 	this);
			EventDispatcher.Instance().addListener(MenuMessages.MAIN_MENU_BTN_CLICKED,  this);
			EventDispatcher.Instance().addListener(MenuMessages.LEVEL_BTN_CLICKED,  	this);
			EventDispatcher.Instance().addListener(MenuMessages.PROFILE_BTN_CLICKED,  	this);
			EventDispatcher.Instance().addListener(MenuMessages.SETTINGS_BTN_CLICKED,  	this);
		}
		
		public function receiveMessage(messageId:int, data:Object):void{
			
			switch(messageId)
			{
				case MenuMessages.MENU_PAGE_IS_ACTIVE:{
					
					removePreviousPage();
					menuPageShowed(data as String);
					
					break;
				}
					
				case MenuMessages.MAIN_MENU_BTN_CLICKED:{
					
					mainMenuBtnClicked(data as String);
					break;
				}
					
				case MenuMessages.LEVEL_BTN_CLICKED:{
					
					levelBtnClicked(data as String);
					break;
				}
					
				case MenuMessages.PROFILE_BTN_CLICKED:{
					
					levelBtnClicked(data as String);
					break;
				}					
					
				case MenuMessages.SETTINGS_BTN_CLICKED:{
					
					settingsBtnClicked(data as String);
					break;
				}
			}
		}
		
		public function destroy():void{
			
		}
	}
}