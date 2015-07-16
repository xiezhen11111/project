package
{
	import flash.filesystem.File;
	
	import data.GlobalData;
	
	import lzm.starling.STLConstant;
	import lzm.starling.STLMainClass;
	import lzm.starling.swf.Swf;
	import lzm.starling.swf.SwfAssetManager;
	
	import myEvent.MyEvent;
	
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.textures.Texture;
	
	import ui.popupUI;
	
	
	public class GameManger extends STLMainClass
	{
		
		[Embed(source='assets/game/zhujiemian.jpg')]
		private static var StartBgImage:Class;
		
		
		public static var GAME_LAYER:Sprite;
		public static var UI_LAYER:Sprite;
		
		public static const LIB_PATH:String = "assets/game/" ;

		private var game:Game;
	
		private  var startSpr:Sprite;
		
		public function GameManger()
		{
			
			
			
			super();
			
			startSpr=new Sprite;
			this.addChild(startSpr);
			
			var textfield:TextField;
			var assets:SwfAssetManager;
			
			GlobalData.stage=Starling.current.root.stage;
			GlobalData.startPosY=GlobalData.stage.stageHeight-GlobalData.elementRow*GlobalData.elementSize;
			
			Swf.init(this);
			
			//背景
			var  bg:Image=new Image(Texture.fromBitmap(new StartBgImage));
			startSpr.addChild(bg);
				
			//进度文本框
			textfield = new TextField(300,100,"loading....");
			textfield.x = (STLConstant.StageWidth - textfield.width)/2;
			textfield.y = (STLConstant.StageHeight - textfield.height)/2+100;
			textfield.color=0xff0000;
			textfield.fontSize=30;
			startSpr.addChild(textfield);
			
			//加载资源
			assets = new SwfAssetManager(STLConstant.scale,STLConstant.useMipMaps);
			assets.verbose = true;
			GlobalData.assets=assets;
			assets.enqueueOtherAssets(File.applicationDirectory.resolvePath(LIB_PATH));
			
			assets.loadQueue(function(ratio:Number):void{
				textfield.text = "loading...." + int(ratio*100)+"%";
				if(ratio == 1){
					textfield.removeFromParent(true);
					
					//创建开始按钮
					var button:Button=new Button(assets.otherAssets.getTexture("zidan"));
					button.x=(STLConstant.StageWidth - button.width)/2;
					button.y=(STLConstant.StageHeight - button.height)/2+100;
					var txt:TextField=new TextField(100,50,"开始游戏");
					txt.fontSize=17;
					txt.color=0xff0000;
					txt.x=(button.width-txt.width)/2;
					txt.y=(button.height-txt.height)/2;
					button.addChild(txt);
					startSpr.addChild(button);
					
					button.addEventListener(Event.TRIGGERED,onTri);		
					
					
				}
				
			});
			
			
			
			
			
		}
		
		private function onTri(e:Event):void
		{
			(e.currentTarget as Button).removeEventListener(Event.TRIGGERED,onTri);		
			startSpr.removeFromParent(true);
			startSpr=null;
			
			init();
		}		
	
		
		private function init():void
		{
			//初始化游戏层
			GAME_LAYER=new Sprite;
			this.addChild(GAME_LAYER);
			
			UI_LAYER=new Sprite;
			this.addChild(UI_LAYER);
			
			game = new Game();
			GAME_LAYER.addChild(game);
			
			game.addEventListener(MyEvent.GAME_PAUSE,onEvent);
			game.addEventListener(MyEvent.GAME_OVER,onEvent);
		}
		
		
		/**
		 * 处理事件 
		 * @param e
		 * 
		 */		
		private function onEvent(e:Event):void
		{
			var type:String=e.type;
			
			
			switch(type)
			{
				case MyEvent.GAME_PAUSE:
					
					popupUI.instance.show(popupUI.GAME_PAUSE);
					popupUI.instance.addEventListener(MyEvent.GAME_CONYINUE,onEvent);
					popupUI.instance.addEventListener(MyEvent.GAME_AGAIN,onEvent);
					break;
				
				case MyEvent.GAME_CONYINUE:
					game.gameContinue();
					
					popupUI.instance.removeEventListener(MyEvent.GAME_CONYINUE,onEvent);
					popupUI.instance.removeEventListener(MyEvent.GAME_AGAIN,onEvent);
					popupUI.instance.hidden();
					break;
				
				case MyEvent.GAME_AGAIN:
					game.gameAgain();
					popupUI.instance.removeEventListener(MyEvent.GAME_CONYINUE,onEvent);
					popupUI.instance.removeEventListener(MyEvent.GAME_AGAIN,onEvent);
					popupUI.instance.hidden();
					break;
				
				case MyEvent.GAME_OVER:
					popupUI.instance.show(popupUI.GAME_OVER);
					popupUI.instance.addEventListener(MyEvent.GAME_AGAIN,onEvent);
					
					break;
			}
			
			
		}		
		
		
		
		
	}
}