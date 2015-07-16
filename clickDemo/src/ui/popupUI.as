package ui
{

	import starling.display.Button;
	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.textures.Texture;
	import data.GlobalData;
	import myEvent.MyEvent;
	
	/**
	 * 弹出菜单 
	 * @author pc001
	 * 
	 */	
	public class popupUI extends Sprite
	{
		
		public static const GAME_PAUSE:String="GAME_PAUSE";
		public static const GAME_OVER:String="GAME_OVER";
		
		
		private static var _instance:popupUI;
		
		private static var parentSpr:Sprite;
		
		private var wallTexture:Texture;
		
		
		private var gamePauseSpr:Sprite;
		
		private var gameOverSpr:Sprite;
		
		private var lastSpr:Sprite;
		
		public function popupUI()
		{
			super();
			
			if(_instance)
				throw new Error("this is a single");
			else
				_instance=this;
			
			init();
			
		}
		
		public static function get instance():popupUI
		{
			if(!_instance)
			{
				_instance=new popupUI;
			}
			
			return _instance;
			
		}
		
		
		private  function init():void
		{
			var quad:Quad=new Quad(GlobalData.stage.stageWidth,GlobalData.stage.stageHeight,0x000000);
			quad.alpha=.5;
			this.addChild(quad);
			
			wallTexture=GlobalData.assets.otherAssets.getTexture("城墙");
			
			parentSpr=GameManger.UI_LAYER;
			
			
			
		}
		
		/**
		 * 显示 
		 * @param type
		 * 
		 */		
		public function show(type:String):void
		{
			parentSpr.addChild(this);
			
			switch(type)
			{
				case GAME_PAUSE:
					if(!gamePauseSpr)
					{
						gamePauseSpr=new Sprite;
						//继续
						
						var button:Button = createButton("Continue");
						gamePauseSpr.addChild(button);
						
						//重新开始
						button = createButton("Again");
						button.y=100;
						gamePauseSpr.addChild(button);
						
						
						gamePauseSpr.x=(this.width-gamePauseSpr.width)/2;
						gamePauseSpr.y=(this.height-gamePauseSpr.height)/2;
						
					}
					
					if(lastSpr && this.contains(lastSpr))
					{
						this.removeChild(lastSpr);
					}
					
					this.addChild(gamePauseSpr);
					
					lastSpr=gamePauseSpr;
					
					break;
				
				case GAME_OVER:
					
					if(!gameOverSpr)
					{
						gameOverSpr=new Sprite;
						//继续
						
						var txt:TextField=new TextField(300,200,"Game Over");
						txt.fontSize=40;
						txt.color=0xff0000;
						gameOverSpr.addChild(txt);
						
						//重新开始
						button = createButton("Again");
						button.x=txt.width/2-button.width/2;
						button.y=200;
						gameOverSpr.addChild(button);
						
						
						gameOverSpr.x=(this.width-gameOverSpr.width)/2;
						gameOverSpr.y=(this.height-gameOverSpr.height)/2;
						
					}
					
					if(lastSpr && this.contains(lastSpr))
					{
						this.removeChild(lastSpr);
					}
					
					this.addChild(gameOverSpr);
					lastSpr=gameOverSpr;
					
					break;
				
			}
			
			
			
		}
		
		
		private function createButton(str:String):Button
		{
			var button:Button = new Button(wallTexture,str);
			button.textHAlign="center";
			button.textVAlign="center";
			button.name=str;
			button.addEventListener(Event.TRIGGERED,onTri);
			
			return button;
		}
		
		private function onTri(e:Event):void
		{
			var name:String=(e.currentTarget as DisplayObject).name;
			
			switch(name)
			{
				case "Continue":
					this.dispatchEventWith(MyEvent.GAME_CONYINUE);
					break;
				
				case "Again":
					this.dispatchEventWith(MyEvent.GAME_AGAIN);
					break;
				
				
			}
			
			
		}		
		
		
		
		public function hidden():void
		{
			parentSpr.removeChild(this);
			
		}
		
		
	}
}