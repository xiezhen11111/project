package util
{
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	
	public class ObjectPool
	{
		/**
		 * 对象池
		 */
		private static var pool:Dictionary = new Dictionary(true);
		/**
		 * 从对象池中获取指定类型的实例
		 */
		public static function getObject(cls:Class, ...args):*
		{
			var clsName:String = getQualifiedClassName( cls );
			var arr:Array = pool[clsName];
			if( arr && arr.length > 0)
			{
				return arr.pop();
			}
			
			return constructor(cls, args);
			
		}
		/**
		 * 将不用的对象返回对象池
		 */
		public static function returnObject(obj:*):void
		{
			var clsName:String = getQualifiedClassName( obj );
			var arr:Array = pool[clsName];
			if( arr )
			{
				arr.push( obj );
			}else
			{
				pool[clsName] = [obj];
			}
		}
		/**
		 * 
		 */
		private static function constructor(cls:Class, args:Array):*
		{
			switch(args.length)
			{
				case 0: return new cls();
				case 1: return new cls( args[0] );
				case 2: return new cls( args[0], args[1]);
				case 3: return new cls( args[0], args[1], args[2]);
					
			}
			
		}
		
		
		public static function clear():void
		{
			
		}
		
		
	}
}