package application.game.view.player_info
{
	import application.game.GameController;
	import application.game.view.components.ShipViewDescription;
	
	import com.greensock.TweenLite;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.system.ApplicationDomain;
	
	public class ShipLiveView
	{
		private const POP_UP_NAME:String = "viewShipsLivePopUp";
		private const SHOW_TIME:Number = 0.3;
		
		public var playerType	:String;
		
		public var isShowedUser		:Boolean;
		public var isShowedOponent	:Boolean;
		
		private var mainContainer		:DisplayObjectContainer;
		private var viewOponentLink		:MovieClip;
		private var viewUserLink		:MovieClip;
		
		private var userPosition		:Array = [436, 94];
		private var oponentPosition		:Array = [842, 94];
		
		private var oponnentTween		:TweenLite;
		private var userTween			:TweenLite;
		
		private var gameViewMediator:	GameController;
		
		public function ShipLiveView(viewComponent:Object, val:GameController)
		{
			mainContainer = viewComponent as DisplayObjectContainer;
			gameViewMediator = val;
		}
		
		public function showUserPopUp(eventType:String):void
		{
			var classInstance:Class = ApplicationDomain.currentDomain.getDefinition(POP_UP_NAME) as Class
			
			viewUserLink = new classInstance();
			mainContainer.addChild( viewUserLink );	
			
			isShowedUser = true;
			
			viewUserLink.x = userPosition[0];
			viewUserLink.y = userPosition[1];
			
			viewUserLink.alpha = 0;
			
			setShipsState(viewUserLink, gameViewMediator.getUserShipsDescription());
			
			userTween = TweenLite.to(viewUserLink, SHOW_TIME, {alpha:1});
		}
		
		public function showOponentPopUp(eventType:String):void
		{
			var classInstance:Class = ApplicationDomain.currentDomain.getDefinition(POP_UP_NAME) as Class
			
			viewOponentLink = new classInstance();
			mainContainer.addChild( viewOponentLink );	
						
			isShowedOponent = true;
			
			viewOponentLink.x = oponentPosition[0];
			viewOponentLink.y = oponentPosition[1];
			
			viewOponentLink.alpha = 0;
			
			setShipsState(viewOponentLink, gameViewMediator.getOponentShipsDescription());
									
			oponnentTween = TweenLite.to(viewOponentLink, SHOW_TIME, {alpha:1});			
		}		
		
		private function setShipsState(shipsContainer:MovieClip, shipsDescription:Vector.<ShipViewDescription>):void
		{
			var oneCounter:int,	twoCounter:int, threeCounter:int;
			
			for (var i:int = 0; i < shipsDescription.length; i++) 
			{
				if(shipsDescription[i].sunk)
				{
					var decks:int = shipsDescription[i].deck;
					
					if(decks == 4)
					{					
						(shipsContainer.getChildByName("s4_1") as MovieClip).gotoAndStop(2);						
					}
					else if(decks == 3)
					{						
						threeCounter++;
						(shipsContainer.getChildByName("s3_" + threeCounter.toString()) as MovieClip).gotoAndStop(2);							
					}					
					else if(decks == 2)
					{
						twoCounter++;
						(shipsContainer.getChildByName("s2_" + twoCounter.toString()) as MovieClip).gotoAndStop(2);							
					}					
					else if(decks == 1)
					{
						oneCounter++;
						(shipsContainer.getChildByName("s1_" + oneCounter.toString()) as MovieClip).gotoAndStop(2);							
					}
				}
			}
		}
		
		public function hideOponentPopUp():void
		{
			isShowedOponent = false;
			
			if(oponnentTween)
				oponnentTween.kill();
			
			oponnentTween = TweenLite.to(viewOponentLink, SHOW_TIME, {alpha:0, onComplete:removeElement, onCompleteParams:[viewOponentLink]});
		}
		
		public function hideUserPopUp():void
		{
			isShowedUser = false;
			
			if(userTween)
				userTween.kill();
			
			userTween = TweenLite.to(viewUserLink, SHOW_TIME, {alpha:0, onComplete:removeElement, onCompleteParams:[viewUserLink]});
					
		}
		
		private function removeElement(element:Object):void
		{
			if(mainContainer.contains(element as MovieClip))
				mainContainer.removeChild(element as MovieClip);
		}
	}
}