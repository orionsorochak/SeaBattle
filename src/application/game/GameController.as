package application.game
{
	import application.core.data.game.ShipData;
	import application.core.game.GameCore;
	import application.core.game.battle.GameBattleAction;
	import application.core.game.battle.GameBattleStatus;
	import application.core.game.battle.IGameBattleProxy;
	import application.core.utils.GamePoint;
	import application.core.utils.ShipPositionSupport;
	import application.event_system.EventDispatcher;
	import application.event_system.messages.ApplicationMessages;
	import application.event_system.messages.CoreMessages;
	import application.event_system.messages.GameBattleMessages;
	import application.event_system.messages.GameMessages;
	import application.game.view.GameView;
	import application.game.view.components.ShipViewDescription;
	import application.game.view.TopBar;
	import application.game.view.exit.ExitView;
	import application.game.view.player_info.ShipLiveView;
	import application.game.view.ships_positions.ShipsPositionsView;
	import application.interfaces.IModule;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public class GameController implements IModule
	{
		private var applicationStage:	Sprite;
		
		private var gameView:			GameView;
		private var positionView:		ShipsPositionsView;
		private var shipLiveView:		ShipLiveView;
		private var exitView:			ExitView;
		
		private var shipsList:			Vector.<ShipData>;
		
		private var timer:				Timer = new Timer(3000, 1);
		private var timer_2:			Timer = new Timer(3000, 1);
		
		private var userShipsDescriptionContainer		:Vector.<ShipViewDescription> = new Vector.<ShipViewDescription>();
		private var oponentShipsDescriptionContainer	:Vector.<ShipViewDescription> = new Vector.<ShipViewDescription>();
		
		private var notyficationBody:	Object;
		
		private var gameStage:			Sprite;
		
		private var _gameBattleProxy		:IGameBattleProxy;
		
		public function GameController(_applicationStage:Sprite)
		{
			applicationStage = _applicationStage;
					
			init();
		}
		
		public function init():void
		{		
			addListeners();
			
			gameStage = new Sprite();
			applicationStage.addChild(gameStage);
			
			gameView = new GameView(this);
			gameStage.addChild( gameView );
			
			positionView = new ShipsPositionsView(gameView);
			gameStage.addChild(positionView);						
			
//			EventDispatcher.Instance().sendMessage(CoreMessages.GET_SHIP_LIST, null);
		}		
		
		private function hideTableForSetPosition():void
		{			
			positionView.removeEventListener(ShipsPositionsView.AUTO_ARRANGEMENT, 	handlerAutoArrangement);
			positionView.removeEventListener(ShipsPositionsView.ROTATE, 			handlerRotate);
			positionView.removeEventListener(ShipsPositionsView.BACK, 				handlerBack);
			positionView.removeEventListener(ShipsPositionsView.NEXT, 				handlerNext);
			
			gameStage.removeChild( positionView );
			
			positionView.close();
			positionView = null;
		}
		
		private function addListenersForGame():void
		{
			gameView.addEventListener(GameView.SELECT_OPPONENT_CEIL, handlerSelectCeil);
			
//			_gameBattleProxy.dispacther.addEventListener(GameBattleMessages.GAME_UPDATED, handlerGameUpdated);
//			_gameBattleProxy.dispacther.addEventListener(GameBattleMessages.GAME_STARTED, handlerGameStarted);
			
			EventDispatcher.Instance().sendMessage(GameBattleMessages.GAME_UPDATED, handlerGameUpdated);
			EventDispatcher.Instance().sendMessage(GameBattleMessages.GAME_STARTED, handlerGameStarted);
		}
		
		private function addListenersForSetPositions():void
		{
			positionView.addEventListener(ShipsPositionsView.AUTO_ARRANGEMENT, handlerAutoArrangement);
			positionView.addEventListener(ShipsPositionsView.ROTATE, 			handlerRotate);
			positionView.addEventListener(ShipsPositionsView.BACK, 			handlerBack);		
			positionView.addEventListener(ShipsPositionsView.SHIP_DRAG, 		handlerChangeShipPosition);			
			
		}
		
		private function goToGameListener():void
		{
			positionView.addEventListener(ShipsPositionsView.NEXT, 			handlerNext);
		}
		
		private function handlerAutoArrangement(e:Event):void
		{
//			shipsList = _proxy.getShipsList();
			positionView.setShipsData( shipsList );
			
			ShipPositionSupport.getInstance().shipsAutoArrangement(shipsList, 10, 10);
			//			_view.updateShipPositions();
			positionView.setShipPositionOnTable();
			
			goToGameListener();
		}
		
		private function handlerRotate(e:Event):void
		{			
			positionView.rotateShip();				
		}
		
		private function handlerBack(e:Event):void
		{
			
		}
		
		private function handlerNext(e:Event):void
		{
			positionView.removeEventListener(ShipsPositionsView.AUTO_ARRANGEMENT, handlerAutoArrangement);
			positionView.removeEventListener(ShipsPositionsView.ROTATE, 	handlerRotate);
			positionView.removeEventListener(ShipsPositionsView.BACK, 		handlerBack);
			positionView.removeEventListener(ShipsPositionsView.NEXT, 		handlerNext);
			
//			this.sendNotification( ApplicationCommands.USER_SHIPS_LOCATED_COMPLETE);
			EventDispatcher.Instance().sendMessage(GameMessages.USER_SHIPS_LOCATED_COMPLETE, null);
			
			hideTableForSetPosition();
			
			setGame();
		}
		
		private function setGame():void
		{
			gameView.addEventListener(GameView.SELECT_OPPONENT_CEIL, handlerSelectCeil);
			
//			_gameBattleProxy = this.facade.retrieveProxy( ProxyList.GAME_BATTLE_PROXY) as IGameBattleProxy;
			
//			_gameBattleProxy.dispacther.addEventListener(GameBattleMessages.GAME_UPDATED, handlerGameUpdated);
//			_gameBattleProxy.dispacther.addEventListener(GameBattleMessages.GAME_STARTED, handlerGameStarted);
			
			EventDispatcher.Instance().sendMessage(GameBattleMessages.GAME_UPDATED, handlerGameUpdated);
			EventDispatcher.Instance().sendMessage(GameBattleMessages.GAME_STARTED, handlerGameStarted);
			
			executeBattleProxyAction();
			setSipLocation();
			setName();
			
			gameView.addEventListener(TopBar.OPONENT_STATE, showPlayerState);			
			gameView.addEventListener(TopBar.USER_STATE, 	 showPlayerState);			
		}
		
		private function showPlayerState(e:Event):void
		{
			if(!shipLiveView)			
				shipLiveView = new ShipLiveView(gameStage, this);						
			
			if(e.type == TopBar.OPONENT_STATE)
			{
				if(shipLiveView.isShowedOponent)
				{
					shipLiveView.hideOponentPopUp();
					gameView.unlockGame();
				}
				else
				{
					if(shipLiveView.isShowedUser)
						shipLiveView.hideUserPopUp();
					
					shipLiveView.showOponentPopUp(e.type);
					gameView.lockGame();
					
					stopTimer();
					startTimer();
				}				
			}
			else if(e.type == TopBar.USER_STATE)
			{
				if(shipLiveView.isShowedUser)
				{
					shipLiveView.hideUserPopUp();
					gameView.unlockGame();
				}
				else
				{
					if(shipLiveView.isShowedOponent)
						shipLiveView.hideOponentPopUp();
					
					shipLiveView.showUserPopUp(e.type);
					gameView.lockGame();
					
					stopTimer();					
					startTimer();
				}
			}
		}
		
		private function startTimer():void
		{
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, hidecurrentOpenHint);
			timer.start();
		}
		
		private function stopTimer():void
		{
			timer.stop();
			timer.removeEventListener(TimerEvent.TIMER_COMPLETE, hidecurrentOpenHint);
		}
		
		private function hidecurrentOpenHint(e:Event):void
		{
			stopTimer();
			
			if(shipLiveView.isShowedOponent)
			{
				shipLiveView.hideOponentPopUp();
				gameView.unlockGame();
			}			
			else if(shipLiveView.isShowedUser)
			{
				shipLiveView.hideUserPopUp();
				gameView.unlockGame();
			}			
		}
		
		private function handlerChangeShipPosition(e:Event):void
		{
			var shipData:ShipData = positionView.activeShip;				// текущий ShipData
			
			var v:Vector.<GamePoint> = ShipPositionSupport.getInstance().testCollision(shipData, shipsList);		// вектор объектов точек где произошло пересечение.
			//			trace(v);
			
			if(v.length > 0)
				positionView.isColision = true;
			else 
				positionView.isColision = false;
		}		
		
		private function handlerSelectCeil(e:Event):void
		{			
			EventDispatcher.Instance().sendMessage(GameMessages.USER_HIT_POINT, {x:gameView.ceilX, y:gameView.ceilY});
//			this.sendNotification(ApplicationCommands.USER_HIT_POINT, {x:gameView.ceilX, y:gameView.ceilY});
		}
		
		private function setSipLocation():void
		{
//			var mainApp:IMainApplicationProxy = this.facade.retrieveProxy(ProxyList.MAIN_APPLICATION_PROXY) as IMainApplicationProxy;		
//			gameView.setShipsLocation( mainApp.getCurrentGame().getShipsList() );
		}
		
		private function setName():void
		{
//			gameView.setUsersData(_gameBattleProxy.getUserPlayerInfo());
		}
		
		private function executeBattleProxyAction():void
		{
			var action:GameBattleAction /*= _gameBattleProxy.getAction()*/;
			
			if(action)
			{
				switch(action.type)
				{
					case GameBattleAction.STATUS_CHANGED:
					{
						changeGameStatus();
						break;
					}
						
					case GameBattleAction.USER_MAKE_HIT:
					{
						userMakeHit(action.getData());
						break;
					}
						
					case GameBattleAction.OPPONENT_MAKE_HIT:
					{
						opponentMakeHit(action.getData());
						break;
					}
						
					case GameBattleAction.USER_SANK_OPPONENTS_SHIP:
					{
						// я потопил корабль противника
						// var data = action.getData();
						// data.ship =  ShipData - инфа по кораблю который был потоплен
						// data.fieldPoint = Vector.<ShipPositionPoint> - точки на поле вокруг горабля.
						
						//						
						//						userMakeHit({result:2, x:action.getData().cell.x, y:action.getData().cell.y});
						gameView.sunkUserShip(action.getData());
						
						executeBattleProxyAction();
						break;
					}
						
					case GameBattleAction.OPPONENT_SANK_USER_SHIP:
					{
						//						opponentMakeHit({result:2, x:action.getData().cell.x, y:action.getData().cell.y});
						gameView.sunkOponentShip(action.getData());
						executeBattleProxyAction();						
						break;
					}
						
					case GameBattleAction.USER_POINTS_UPDATED:
					{
						// action.getData() - points (uint) юзера
						// если нужна вся инфа по юзеру или оппоненту можешь получить их  _gameBattleProxy.getUserPlayerInfo():GamePlayerData и _gameBattleProxy.getOpponentPlayerInfo():GamePlayerData
						gameView.updateProgressLine("user", action.getData());
						executeBattleProxyAction();
						break;
					}
						
					case GameBattleAction.OPPONENT_POINTS_UPDATED:
					{
						// action.getData() - points (uint) оппонента
						// если нужна вся инфа по юзеру или оппоненту можешь получить их  _gameBattleProxy.getUserPlayerInfo():GamePlayerData и _gameBattleProxy.getOpponentPlayerInfo():GamePlayerData
						gameView.updateProgressLine("opponent", action.getData());
						executeBattleProxyAction();
						break;
					}
						
					case GameBattleAction.OPPONENT_EXP_UPDATED:
					{
						// action.getData() - exp (uint) оппонента
						// если нужна вся инфа по юзеру или оппоненту можешь получить их  _gameBattleProxy.getUserPlayerInfo():GamePlayerData и _gameBattleProxy.getOpponentPlayerInfo():GamePlayerData
						executeBattleProxyAction();
						break;
					}
						
					case GameBattleAction.USER_EXP_UPDATED:
					{
						// action.getData() - exp (uint) опюзераонента
						// если нужна вся инфа по юзеру или оппоненту можешь получить их  _gameBattleProxy.getUserPlayerInfo():GamePlayerData и _gameBattleProxy.getOpponentPlayerInfo():GamePlayerData
						executeBattleProxyAction();
						break;
					}
						
					default:
					{
						executeBattleProxyAction();
						break;
					}
				}
			}
			else
			{
				
			}
		}		
		
		private function changeGameStatus():void
		{			
			if(_gameBattleProxy.getStatus() == GameBattleStatus.WAITING_FOR_START)
			{
				gameView.lockGame();
				//				gameView.waiting();
			}
			else if(_gameBattleProxy.getStatus() == GameBattleStatus.STEP_OF_OPPONENT)
			{
				gameView.lockGame();
				//				gameView.opponentStep();
			}
			else if(_gameBattleProxy.getStatus() == GameBattleStatus.STEP_OF_INCOMING_USER)
			{
				gameView.unlockGame();
				
				//				gameView.userStep();
			}
			else if(_gameBattleProxy.getStatus() == GameBattleStatus.WAITINIG_GAME_ANSWER)
			{
				gameView.lockGame();
				//				gameView.waitingGame();
			}
				
			else if(_gameBattleProxy.getStatus() == GameBattleStatus.INCOMING_USER_WON)
			{
				gameView.lockGame();
				
				/*notyficationBody = 
					{
						user:			userShipsDescriptionContainer, 
						opponent:		oponentShipsDescriptionContainer, 
						userName:		DataProvider.getInstance().getUserDataProvider().getUserInfo().name, 
							userPoints:		DataProvider.getInstance().getGameDataProvider().user.points, 
							opponentName:	DataProvider.getInstance().getGameDataProvider().opponent.name, 
							opponentPoints:	DataProvider.getInstance().getGameDataProvider().opponent.points
					};*/
				
				timer_2.addEventListener(TimerEvent.TIMER_COMPLETE, sendShowResult);	
				timer_2.start();
			}
			else if(_gameBattleProxy.getStatus() == GameBattleStatus.OPPONENT_WON)
			{
				gameView.lockGame();
				
				/*notyficationBody = 
					{
						user:			userShipsDescriptionContainer, 
						opponent:		oponentShipsDescriptionContainer, 
						userName:		DataProvider.getInstance().getUserDataProvider().getUserInfo().name, 
							userPoints:		DataProvider.getInstance().getGameDataProvider().user.points, 
							opponentName:	DataProvider.getInstance().getGameDataProvider().opponent.name, 
							opponentPoints:	DataProvider.getInstance().getGameDataProvider().opponent.points
					};*/
				
				timer_2.addEventListener(TimerEvent.TIMER_COMPLETE, sendShowResult);		
				timer_2.start();
			}
			
			executeBattleProxyAction();
		}
		
		private function sendShowResult(e:Event):void
		{
			timer_2.stop();
			timer_2.removeEventListener(TimerEvent.TIMER_COMPLETE, sendShowResult);
			
			EventDispatcher.Instance().sendMessage(GameMessages.SHOW_RESULT_WINDOW, notyficationBody);
			
//			this.sendNotification(ApplicationEvents.SHOW_RESULT_WINDOW, notyficationBody);
		}
		
		
		private function userMakeHit(data:Object):void
		{
			gameView.userMakeHit(data, data.result);
			
			executeBattleProxyAction();
		}
		
		
		private function opponentMakeHit(data:Object):void
		{
			gameView.opponentMakeHit(data, data.result);
			
			executeBattleProxyAction();
		}
		
		
		private function handlerGameUpdated(e:Event):void
		{
			executeBattleProxyAction();
		}
		
		
		private function handlerGameStarted(e:Event):void
		{
			
		}
		
		public function listNotificationInterests():Array
		{
			return [
//				ApplicationCommands.USER_PRESS_BACK
			];
		}
		
		public function handleNotification(notification:Object):void
		{
			var name:String = notification.getName();
			
			switch(name)
			{
				case ApplicationMessages.MOVE_BACK:
				{
					if(!exitView)
					{
						exitView = new ExitView(applicationStage);
						exitView.addEventListener(ExitView.MENU, gotoMenu);
						exitView.shopPopUp();
					}
					else
					{
						if(exitView.isShowed)
							exitView.hidePopUp();
						else
							exitView.shopPopUp();
					}
					
					break;
				}
			}
		}
		
		public function getUserShipsDescription():Vector.<ShipViewDescription>
		{
			return userShipsDescriptionContainer;
		}
		
		public function getOponentShipsDescription():Vector.<ShipViewDescription>
		{
			return oponentShipsDescriptionContainer;
		}
		
		private function gotoMenu(e:Event):void
		{
//			exitView.removeEventListener(ExitView.MENU, gotoMenu);
//			this.sendNotification(ApplicationEvents.START_UP_COMPLETE);
//			this.facade.removeMediator(NAME);
		}
		
		public function onRemove():void
		{
//			this.facade.removeProxy(ProxyList.GAME_BATTLE_PROXY);
			//			this.facade.removeProxy(ProxyList.MAIN_APPLICATION_PROXY);
			gameStage.addChild( gameView );
			gameView.destroy();
			gameView = null;
		}
		
		private function addListeners():void{
			
			EventDispatcher.Instance().addListener(CoreMessages.SET_SHIP_LIST,	this);			
		}
		
		public function receiveMessage(messageId:int, data:Object):void{
			
			switch(messageId)
			{
				case CoreMessages.SET_SHIP_LIST:{
					
					shipsList = data as Vector.<ShipData>;
					positionView.setShipsData( shipsList );
					addListenersForSetPositions();
					
					break;
				}			
			}
		}
		
		public function destroy():void{
			
			
		}
	}
}