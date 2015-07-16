package util.TimerTool
{
	public class TimerVo
	{
		
		/**
		 * 计时器运行一次的间隔时间 
		 */
		public var incTime:int = 0;
		
		/**
		 * 执行的回调函数 
		 */		
		public var callBackFunc:Function;
		
		/**
		 * 计时开始的项目运行时间 
		 */		
		public var addTime:int = 0;
		
		/**
		 *回掉函数的参数 
		 */		
		public var parameter:Array;
		
		
	}
}