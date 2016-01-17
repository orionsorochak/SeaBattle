package application.menu.view.settings_page
{
	import application.AppGlobalVariables;
	import application.event_system.EventDispatcher;
	import application.event_system.messages.MenuMessages;
	import application.interfaces.IPage;
	
	import com.greensock.TweenLite;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.system.ApplicationDomain;

	public class SettingsPageView implements IPage
	{
		private var menuStage:			Sprite;			
		private var linkToTable:		MovieClip;		
		private var tween:				TweenLite;		
		private var tween_2:			TweenLite;		
		
		private var linkToPrevPopUp:	MovieClip;
		private var linkToCurrentPopUp:	MovieClip;
		
		public function SettingsPageView(_menuStage:Sprite)
		{
			menuStage = _menuStage;
		}
		
		public function show():void{
			
			var elementClass:Class = ApplicationDomain.currentDomain.getDefinition(SettingsPageVariables.TABLE_CLASS_NAME) as Class;
			linkToTable = new elementClass();			
			linkToTable.alpha = 0;
			
			menuStage.addChild(linkToTable);
			
			tween = TweenLite.to(linkToTable, AppGlobalVariables.PAGE_FADE_ODE_TIME, {alpha:1, onComplete:onShowComplete});
		}
		
		public function onShowComplete():void{
			
			tween.kill();
			tween = null;
			
			EventDispatcher.Instance().sendMessage(MenuMessages.MENU_PAGE_IS_ACTIVE, SettingsPageVariables.NAME);	
			
			setListeners();
		}
		
		private function setListeners():void{
			linkToTable.addEventListener(MouseEvent.MOUSE_DOWN, buttonClickHandler);
		}
		
		private function buttonClickHandler(e:Event):void{
			
			resetAllButtons();
			if(linkToTable.getChildByName(e.target.name) is MovieClip)
				(linkToTable.getChildByName(e.target.name) as MovieClip).gotoAndStop(2);
			
			showSettingsPage(e);
			EventDispatcher.Instance().sendMessage(MenuMessages.SETTINGS_BTN_CLICKED, e.target.name);	
		}
		
		private function resetAllButtons():void
		{
			(linkToTable.getChildByName(SettingsPageVariables.AUDIO_BTN_NAME) as MovieClip).gotoAndStop(1);
			(linkToTable.getChildByName(SettingsPageVariables.LANGUAGE_BTN_NAME) as MovieClip).gotoAndStop(1);
			(linkToTable.getChildByName(SettingsPageVariables.SOCIAL_BTN_NAME) as MovieClip).gotoAndStop(1);
		}
		
		private function showSettingsPage(e:Event):void
		{
			switch(e.target.name)
			{
				case SettingsPageVariables.AUDIO_BTN_NAME:
				{
					showPopUp(SettingsPageVariables.AUDIO_CLASS_NAME);					
					break;
				}
					
				case SettingsPageVariables.LANGUAGE_BTN_NAME:
				{
					showPopUp(SettingsPageVariables.LENG_CLASS_NAME);
					break;
				}
					
				case SettingsPageVariables.SOCIAL_BTN_NAME:
				{
					showPopUp(SettingsPageVariables.SOCIAL_CLASS_NAME);
					break;
				}
			}
		}
		
		private function showPopUp(linkName:String):void
		{		
			if(tween_2){
				tween_2.kill();
				tween_2 = null;
			}
			
			linkToPrevPopUp = linkToCurrentPopUp;
			
			var elementClass:Class = ApplicationDomain.currentDomain.getDefinition(linkName) as Class;
			linkToCurrentPopUp = new elementClass();			
			linkToCurrentPopUp.alpha = 0;
			
			menuStage.addChild(linkToCurrentPopUp);
			
			tween_2 = TweenLite.to(linkToCurrentPopUp, AppGlobalVariables.PAGE_FADE_ODE_TIME, {alpha:1, onComplete:onShowPopUpComplete});
			
		}
		
		private function onShowPopUpComplete():void
		{		
			if(tween_2){
				tween_2.kill();
				tween_2 = null;
			}
			
			if(linkToPrevPopUp)
			{
				menuStage.removeChild(linkToPrevPopUp);
				linkToPrevPopUp = null;
			}			
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