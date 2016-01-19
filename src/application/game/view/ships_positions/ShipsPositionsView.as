package application.game.view.ships_positions
{
	import application.core.data.game.ShipData;
	import application.core.data.game.ShipDirrection;
	import application.game.view.GameView;
	import application.game.view.ShipsView;
	
	import com.greensock.TweenLite;
	import com.greensock.plugins.TintPlugin;
	import com.greensock.plugins.TweenPlugin;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	public class ShipsPositionsView extends Sprite
	{
		private var cellSize:				Number = 31.5;
		
		private const RED:					uint = 0xFF0000;
		private const WHITE:				uint = 0xFFFFFF;
		private const BLACK:				uint = 0x000000;
		private const GREEN:				uint = 0x66FF66;
		
		public static const LINK_NAME:		String = "viewShipLocation";
		
		private static const SHIP_LINING_NAME:		String = "table_element";
		private static const SHIP_LINING_CONTAINER:	String = "movingTable";
		
		public static const AUTO_ARRANGEMENT:		String = "autoArrangement";
		public static const ROTATE:					String = "rotate";
		public static const BACK:					String = "back";
		public static const NEXT:					String = "next";
		
		public static const SHIP_DRAG:				String = "ship_drag";			// отправляеться когда тягаем корабль по полю ( mouseMove(...) )
		private const eventShipDrag:		Event = new Event(SHIP_DRAG);
		private var shipCache:				Dictionary;								// кеш ссылок на корабли. Ключ - мувик корабля которые таскаем по полю, значение - связанный с этим кораблём ShipData.
		public var activeShip:				ShipData;								// задаёться когда начинаем таскать корабль.
		public var isColision:				Boolean;		
		
		private var skinGameView:			MovieClip;
		private var skin:					MovieClip;
		
		
		private var ships:					Vector.<ShipData>;
		private var shipPlaceholder:		MovieClip;
		private var tableHolder:			MovieClip;
		
		private var dragedShip:				MovieClip;
		private var rotatedShip:			MovieClip;
		private var shipsHolder:			MovieClip;
		
		private var initShipPoint:			Point = new Point();		
		private var initShipsPositions:		Array;
		
		private var shipsLocationProcess:	ShipsLocationProcess = new ShipsLocationProcess();	
		
		private var isCleared:				Boolean;	
		private var canLocate:				Boolean;	
		private var tableIsAdd:				Boolean;	
		
		private var hideTimer:				Timer = new Timer(300, 1);
		
		public  var rotateShipDescription:	Object = {"column":0, "line":0, "orient":0, "deck":0};
		private var shipsArray:Array = [4,3,3,2,2,2,1,1,1,1];
		
		private var gameView:GameView;
		private var shipsView:ShipsView;
				
		public function ShipsPositionsView(_gameView:GameView, _shipsView:ShipsView)
		{
			gameView  = _gameView;
			shipsView = _shipsView;
			
			TweenPlugin.activate([TintPlugin]);
						
			init();	
			shipsUpdate();
		}
			
		private function init():void
		{
			var classInstance:Class = ApplicationDomain.currentDomain.getDefinition(LINK_NAME) as Class, i:int;	
			skin = new classInstance();
			this.addChild( skin );			
			
			shipsHolder = skin.getChildByName("location_table") as MovieClip;
				
			tableHolder = gameView.skin.player_field;
			cellSize 	= tableHolder.width/10;				
			
			skin.addEventListener(MouseEvent.CLICK, handlerMouseClick);
		}
		
		private function shipsUpdate():void
		{
			shipCache 			= new Dictionary();
			initShipsPositions  = new Array();
				
			for (var i:int = 0; i < shipsArray.length; i++) 					
			{			
				var ship:MovieClip = getShip(shipsArray[i], i);
				
				ship.addEventListener(MouseEvent.MOUSE_DOWN, mouseMoveActivate);			
				ship.buttonMode = true;
				
				initShipsPositions.push({"x":ship.x, "y":ship.y});
			}
		}
		
		public function setShipPositionOnTable():void
		{
			shipCache = new Dictionary();
			
			for (var i:int = 0; i < ships.length; i++) 
			{
				var ship:MovieClip = getShip(ships[i].deck, i);
				
				ship.x = ships[i].x*cellSize + tableHolder.x;
				ship.y = ships[i].y*cellSize + tableHolder.y;
				
				ship.gotoAndStop(ships[i].dirrection + 1);
				
				shipCache[ship] = ships[i];				
			}			
		}
		
		private function mouseMoveActivate(e:MouseEvent):void
		{			
			dragedShip  	= e.currentTarget as MovieClip;
		
			initShipPoint.x = dragedShip.x;
			initShipPoint.y = dragedShip.y;		
			
			activeShip 		= shipCache[dragedShip];
			
			if(!activeShip)
				activeShip = new ShipData();
			
			dragedShip.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);	
			dragedShip.addEventListener(MouseEvent.MOUSE_UP,   mouseMoveDeactivate);	
			dragedShip.startDrag();		
		}
		
		private function mouseMove(e:MouseEvent):void
		{
			var xx:uint = Math.round( (e.currentTarget.x - tableHolder.x)/cellSize );			// лпределяем позиции корабля.
			var yy:uint = Math.round( (e.currentTarget.y - tableHolder.y)/cellSize );
			
			activeShip.x = xx;
			activeShip.y = yy;
			
			this.dispatchEvent( eventShipDrag );						// событие слушает ShipPositionMediator.as
			
			var shipLining:MovieClip, layerIndex:int, 			
			hitMc:MovieClip = e.currentTarget as MovieClip;		
			
			var x_coef:int = shipsLocationProcess.correctRange((hitMc.x - tableHolder.x + cellSize/2)/cellSize);
			var y_coef:int = shipsLocationProcess.correctRange((hitMc.y - tableHolder.y + cellSize/2)/cellSize);
			
			defineShip(e.currentTarget as MovieClip);
			
			var deckNArray:Array = hitMc.name.split("s")[1].split("_");
		
//			skin.setChildIndex(hitMc, skin.numChildren - 1);		
			
			if(!tableIsAdd && checkIfIsOnShipsTable(e.currentTarget.x, e.currentTarget.y) )
			{
				tableIsAdd = true;
//				if(skin.getChildIndex(hitMc) - 1 >= 0) 
//					layerIndex = skin.getChildIndex(hitMc) - 1;
				
				addTable(shipLining, activeShip.deck, activeShip.dirrection+1, layerIndex);
			}				
			
			shipLining = tableHolder.getChildByName(SHIP_LINING_NAME) as MovieClip;
			
			if(!isCleared)
			{				
				isCleared = true;
				
				shipsLocationProcess.resetShipLocation(0, 0, int(deckNArray[1]));						
			}
			
			rotateShipDescription.column  = x_coef;
			rotateShipDescription.line	  = y_coef;
			rotateShipDescription.orient  = activeShip.dirrection;
			rotateShipDescription.deck	  = activeShip.deck;	
			
			if(tableIsAdd)
			{
				if(!checkIfIsOnShipsTable(e.currentTarget.x, e.currentTarget.y))
				{
					tableIsAdd = false;
					removeTable();
					
				}else if(shipLining)
				{
					if(!isColision)
					{			
						canLocate = true;					
						setTint(shipLining, GREEN, 0, 1);
						
					}else{
						
						canLocate = false;						
						setTint(shipLining, RED, 0, 1);
					}
					
					if(activeShip.dirrection == 0)
					{
						shipLining.x = shipsLocationProcess.correctRangeForMoving(x_coef, activeShip.deck)*cellSize;
						shipLining.y = y_coef*cellSize;						
						
					}else if(activeShip.dirrection == 1)
					{				
						shipLining.x = x_coef*cellSize;
						shipLining.y = shipsLocationProcess.correctRangeForMoving(y_coef, activeShip.deck)*cellSize;
					}
				}					
			}		
		}
		
		private function setTint(_element:MovieClip, _color:uint, _time:int = 0, _alpha:Number = 1):void
		{
			if(_element)
				TweenLite.to(_element, _time, {tint:_color,  alpha:_alpha});	
		}
		
		/**
		 * Adding and showing lining under ship.
		 * @param lining  - lining under ship.
		 * @param deck	  - ship deck number.
		 * @param orient  - ship orientation.
		 * @param level   - child index.
		 */		
		private function addTable(shipLining:MovieClip, deck:int, orient:int, level:int):void
		{
			var classInstance:Class = ApplicationDomain.currentDomain.getDefinition(SHIP_LINING_CONTAINER) as Class;
			
			if(classInstance)
			{
				shipLining = new classInstance();				
				shipLining.name = SHIP_LINING_NAME;
				tableHolder.addChildAt(shipLining, tableHolder.numChildren);
				shipLining.gotoAndStop(deck);
				shipLining.table.gotoAndStop(orient);				
			}	
		}
		
		private function mouseMoveDeactivate(e:MouseEvent):void
		{
			dragedShip.stopDrag();
			dragedShip.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMove);	
			removeMoveListeners();	
			
			isCleared = tableIsAdd = false;
			dragedShip = rotatedShip = e.currentTarget as MovieClip;					
			
			var shipLining:MovieClip = tableHolder.getChildByName(SHIP_LINING_NAME) as MovieClip;			
			
			if(canLocate && checkIfIsOnShipsTable(e.currentTarget.x, e.currentTarget.y))
			{
				dragedShip.x = shipLining.x + tableHolder.x;
				dragedShip.y = shipLining.y + tableHolder.y; 
				
			}else if(checkIfIsOnShipsHolder(e.currentTarget.x, e.currentTarget.y))
			{			
				dragedShip.x = initShipsPositions[activeShip.idx].x;
				dragedShip.y = initShipsPositions[activeShip.idx].y;
				dragedShip.gotoAndStop(0);				
				
			}else{
				
				dragedShip.x = initShipPoint.x;
				dragedShip.y = initShipPoint.y; 	
				
				if(shipLining)
				{
					shipLining.x = initShipPoint.x;
					shipLining.y = initShipPoint.y; 	
				}
			}	
			
			removeTable();	
			
			if(!isColision)
			{
				for (var i:int = 0; i < ships.length; i++) 
				{
					if(ships[i].id == activeShip.idx)
					{
						ships[i].x = activeShip.x;
						ships[i].y = activeShip.y;
						
						trace("x: ", ships[i].x, "y: ", ships[i].y);
						
						break;
					}					
				}
			}			
		}
		
		/**
		 * Reset rotating ships position.
		 * Update all ships position without ship wich will rotate.
		 * If can rotate, change position. Else show "red table" on unposible position, set timer for hide this red table. 
		 */		
		public function rotateShip():void
		{
			if(rotatedShip)
			{	
				var shipLining:MovieClip, layerIndex:int, directionForRotate:int;					
				
				if(!activeShip)
					activeShip = new ShipData();
				
				defineShip(dragedShip);
				
				activeShip = ships[activeShip.idx];
				
				if(activeShip.dirrection == ShipDirrection.VERTICAL)
				{
					activeShip.dirrection = ShipDirrection.HORIZONTAL;
					directionForRotate = 0;
				}					
				else 
				{
					activeShip.dirrection = ShipDirrection.VERTICAL;
					directionForRotate = 1;
				}
				
				this.dispatchEvent( eventShipDrag );	
				
				if( !isColision ) 
				{					
					if(directionForRotate == 0)	
						rotateShipDescription.orient = directionForRotate; 
					else 
						rotateShipDescription.orient = directionForRotate;
					
					rotatedShip.gotoAndStop(directionForRotate + 1);					
					
				}else
				{						
					addTable(shipLining, rotateShipDescription.deck, directionForRotate+1, layerIndex);
					
					shipLining   = tableHolder.getChildByName(SHIP_LINING_NAME) as MovieClip;
					shipLining.x = rotateShipDescription.column*cellSize;
					shipLining.y = rotateShipDescription.line*cellSize;					
					
					setTint(shipLining, RED, 0, 1);
					
					hideTimer.addEventListener(TimerEvent.TIMER, hideTable);
					hideTimer.start();
				}
			}
		}
		
		private function hideTable(e:TimerEvent):void
		{
			hideTimer.stop();
			hideTimer.removeEventListener(TimerEvent.TIMER, hideTable);			
			removeTable();
		}
		
		private function removeMoveListeners():void
		{				
			for (var j:int = 0; j < skin.numChildren; j++) 
			{
				skin.getChildAt(j).removeEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
			}			
		}
		
		private function defineShip(activeElement:MovieClip):void
		{					
			activeShip.deck 		= int(activeElement.name.split("s")[1].split("_")[0]);		
			activeShip.idx			= int(activeElement.name.split("s")[1].split("_")[1]);
			activeShip.dirrection 	= activeElement.currentFrame - 1;					
		}
		
		/**
		 *  Adding and showing lining under ship.
		 */		
		private function removeTable():void
		{	
			if(tableHolder.getChildByName(SHIP_LINING_NAME) && tableHolder.contains(tableHolder.getChildByName(SHIP_LINING_NAME) as MovieClip))
				tableHolder.removeChild(tableHolder.getChildByName(SHIP_LINING_NAME) as MovieClip);		
		}	
		
		private function checkIfIsOnShipsTable(x:uint, y:uint):Boolean
		{			
			if(x >= tableHolder.x && x <= tableHolder.x + tableHolder.width && y >= tableHolder.y && y <= tableHolder.y + tableHolder.height)
				return true;							
			
			return false;			
		}
		
		private function checkIfIsOnShipsHolder(x:uint, y:uint):Boolean
		{			
			if(x >= shipsHolder.x && x <= shipsHolder.x + shipsHolder.width && y >= shipsHolder.y && y <= shipsHolder.y + shipsHolder.height)
				return true;							
			
			return false;			
		}
		
		private function renmoveListeners():void
		{
			for (var i:int = 0; i < shipsArray.length; i++) 					
			{					
				var ship:MovieClip = getShip(shipsArray[i], i);
				
				ship.removeEventListener(MouseEvent.MOUSE_DOWN, mouseMoveActivate);			
				ship.buttonMode = false;
			}
		}
		
		private function handlerMouseClick(e:MouseEvent):void
		{
			var name:String = e.target.name;
			
			switch(name)
			{
				case "btn_shuffle":
				{
					this.dispatchEvent( new Event(AUTO_ARRANGEMENT) );
					rotatedShip = null;
					break;
				}
					
				case "btn_rotate":
				{
					this.dispatchEvent( new Event(ROTATE) );
					break;
				}
					
				case "btn_menu":
				{
					this.dispatchEvent( new Event(BACK) );
					break;
				}
					
				case "btn_next":
				{
					renmoveListeners();
					this.dispatchEvent( new Event(NEXT) );
					
					break;
				}
			}
		}
		
		private function getShip(deckValue:int, shipId:int):MovieClip
		{
			return (shipsView.getShips().getChildByName("ships_container") as MovieClip).getChildByName("s" + deckValue + "_" + shipId) as MovieClip;
		}
		
		public function setShipsData(_ships:Vector.<ShipData>):void
		{
			ships = _ships;
			shipsLocationProcess.shipsLocationArray = _ships;			
		}
		
		public function updateShipPositions():void
		{
			var i:int;
			shipPlaceholder.graphics.clear();
			
			shipPlaceholder.graphics.beginFill(0xff0000);
			
			for(i = 0; i < ships.length; i++)
			{
				if(ships[i].dirrection == ShipDirrection.HORIZONTAL) 
					shipPlaceholder.graphics.drawRect(ships[i].x * cellSize, ships[i].y*cellSize, ships[i].deck * cellSize, cellSize);
				else 
					shipPlaceholder.graphics.drawRect(ships[i].x * cellSize, ships[i].y*cellSize, cellSize, ships[i].deck * cellSize);
			}
		}
		
		public function close():void
		{
			if(skin) 
				skin.removeEventListener(MouseEvent.CLICK, handlerMouseClick);
			if(this.parent) 
				this.parent.removeChild( this );
			
			skin = null;
		}
	}
}