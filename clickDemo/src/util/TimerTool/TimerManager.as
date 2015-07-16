package util.TimerTool
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.getTimer;
	
	public class TimerManager extends EventDispatcher
	{
		private static var _instance:TimerManager;
		
		/**
		 * 用来监听帧事件。实现计时 
		 */		
		public var timerTarget:DisplayObject;
		
		/**
		 * 保存帧事件的回调
		 * 在每一帧的时候，执行里面的每一个回调 
		 */		
		private var _saveFrameCallBack:Array = [];
		
		/**
		 * 保存 间隔一段时间执行逻辑的信息
		 * 保存的是 TimerVo对象 
		 */		
		private var _saveTimerCallBack:Array = [];
		
		/**
		 * 记录着计时器是否在走动 
		 */		
		private var _isInTimer:Boolean = false;
		
		public function TimerManager(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		
		public static function get instance():TimerManager
		{
			if(_instance == null)
			{
				_instance = new TimerManager();
			}
			
			return _instance;
		}
		
		
		/**
		 * 监听帧事件 
		 * @param callBack 每一帧的回调函数
		 * 
		 */		
		public function addFrameEvent(callBack:Function):void
		{
			_saveFrameCallBack.push(callBack);
			
			caulateStar();
		}
		
		/**
		 * 移除 帧事件 
		 * @param callBack
		 * 
		 */		
		public function deleteFrameEvent(callBack:Function):void
		{
			 var index:int = _saveFrameCallBack.indexOf(callBack);
			 if(index>=0)
			 {
				 //表示这个监听存在
				 _saveFrameCallBack.splice(index,1);
			 }
			 
			 caulateStopTime();
		}
		
		
		/**
		 * 间隔incTime时间执行callBack回调 
		 * @param incTime 间隔时间
		 * @param callBack  回调
		 * 
		 */		
		public function addTimerEvent(incTime:int,callBack:Function,parameter:Array=null):void
		{
			var timerVo:TimerVo = new TimerVo();//计时的信息
			timerVo.incTime = incTime;
			timerVo.callBackFunc = callBack;
			timerVo.addTime = getTimer();//记录当前【被添加的】时间
			timerVo.parameter=parameter;
			
			_saveTimerCallBack.push(timerVo);
			
			caulateStar();
		}
		
		/**
		 * 移除间隔时间的计时器 
		 * @param callBack
		 * 
		 */		
		public function deleteTimerEvent(callBack:Function):void
		{
			for(var i:int = 0;i<_saveTimerCallBack.length;i++)
			{
				var vo:TimerVo = _saveTimerCallBack[i];
				if(vo.callBackFunc == callBack)
				{
				  _saveTimerCallBack.splice(i,1);
				  break;
				}
			}
			
			caulateStopTime();
		}
		
		/**
		 * 计算是否 需要停止计时器
		 * 当 两个数组都没有回调了 。就移除计时器 
		 * 
		 */		
		private function caulateStopTime():void
		{
			//表示没有再需要的监听了
			if(_saveFrameCallBack.length == 0&&_saveTimerCallBack.length == 0)
			{
				deleteEventListener();
			}
		}
		
		
		/**
		 * 判断计时器是否启动了
		 * 如果未启动。那就启动计时器 
		 * 
		 */		
		private function caulateStar():void
		{
			if(_isInTimer == false)
			{
				//表示计时器还没启动
				startEventListener();
			}else
			{
				//表示计时器已经开启了 无视。。。
			}
		}
		
		
		/**
		 * 启动计时器 
		 * 内部调用
		 */		
		private function startEventListener():void
		{
			if(timerTarget)
			{
				_isInTimer = true;//标记启动了计时器
				timerTarget.addEventListener(Event.ENTER_FRAME,frameFunc);
			}
		}
		
		
		private function frameFunc(e:Event):void
		{
			var i:int = 0;
			var len:int = _saveFrameCallBack.length;
	        var func:Function;
			
			for(i=0;i<len;i++)
			{
				func = _saveFrameCallBack[i];//取出每一个需要执行的回调
				func();//实现了每一帧执行一次
			}
			
			len = _saveTimerCallBack.length;
			var timeVo:TimerVo;
			
			for(i =0;i<len;i++)
			{
				timeVo = _saveTimerCallBack[i];
				
				if(timeVo)
				{
					var newTime:int = getTimer();//运行到这个函数的当前时间
					var inc:int = newTime - timeVo.addTime;
					
					if(inc>=timeVo.incTime)
					{
						//计时器的时间到了。执行计时器
						//vo.callBackFunc();
						timeVo.callBackFunc.apply(this,timeVo.parameter);
						
						timeVo.addTime = newTime;//执行完一次回调。把时间“归零”
					}
				}
			}
			
		}
		
		/**
		 * 移除计时器
		 * 内部调用 
		 * 
		 */		
		private function deleteEventListener():void
		{
			if(timerTarget)
			{
				_isInTimer = false;//标记计时器没有启动了
				timerTarget.removeEventListener(Event.ENTER_FRAME,frameFunc);
			}
		}
		
		
		
		
	}
}