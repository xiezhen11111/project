package data    
{	
	import lzm.starling.swf.SwfAssetManager;
	
	import starling.display.Stage;
	import starling.textures.Texture;


	
	/** @全局数据类
	 *   集中管理所有全局数据
	 */	
	public class GlobalData
	{
		/**
		 *舞台对象 
		 */		
		public static var stage:Stage;
		
		/**
		 *元素放置的起始y坐标 
		 */		
		public static var startPosY:Number;
		
		/**
		 *元素的行列数 
		 */	
		public static  const elementRow:uint=8;
		public static const elementCol:uint=10;
		
		/**
		 *元素的尺寸 
		 */		
		public static const elementSize:uint=64;
		
		/**
		 *保存元素的纹理 
		 */		
		public static  var elementTextureVec:Vector.<Texture>;
		
		/**
		 *保存敌人的纹理 
		 */		
		public static var enemyTextureVec:Vector.<Texture>;
		
		/**
		 *子弹纹理 
		 */		
		public static var bulletTexture:Texture;
		
		public static var elementNum:uint=4;
		
		public static var enemyNum:uint=4;
		
		
		public static var assets:SwfAssetManager;
		
	}
	
	
	
}