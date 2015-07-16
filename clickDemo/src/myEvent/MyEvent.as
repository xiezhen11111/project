package myEvent
{
	import starling.events.Event;
	
	public class MyEvent extends Event
	{
		
		public static const GAME_PAUSE:String="GAME_PAUSE";
		public static const GAME_AGAIN:String="GAME_AGAIN";
		public static const GAME_CONYINUE:String="GAME_CONYINUE";
		public static const GAME_OVER:String="GAME_OVER";
		
		
		public function MyEvent(type:String, bubbles:Boolean=false, data:Object=null)
		{
			super(type, bubbles, data);
		}
		
		
	}
}