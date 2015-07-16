package
{

	
	import flash.desktop.NativeApplication;
	import flash.desktop.SystemIdleMode;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	import lzm.starling.STLStarup;

	
	public class GameStart extends STLStarup
	{
		public static var SPLASH_END:Boolean;
		public function GameStart()
		{
			super();
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.frameRate = 30;
			NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.KEEP_AWAKE;
	
			
			initStarlingWithWH(GameManger,640,1136,1000000,false,false,true);
			
			
		}
		
		
		
		
		
	}
}