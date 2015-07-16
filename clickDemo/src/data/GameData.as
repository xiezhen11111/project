package data
{
	import vo.BulletVo;
	import vo.EnemyVo;
	
	/**
	 * 游戏数据 
	 * @author xiezhen11111
	 * 
	 */	
	public class GameData
	{
		
		private  static var _instance:GameData=new GameData;
		
		public function GameData()
		{
			if(_instance)
				throw new Error("this is a single");
			
			initEnemyData();
			initBulletData();
			
		}
		
		
		
		public static function instance():GameData
		{
			
			return  _instance;
			
		}
		
		private var enemyVoVec:Vector.<EnemyVo>;
		
		/**
		 *初始化游戏数据 
		 * 
		 */		
		private function initEnemyData():void
		{
			enemyVoVec=new Vector.<EnemyVo>;
			
			var enemyVo:EnemyVo=new EnemyVo;
			enemyVo.type=0;
			enemyVo.hp=5;
			enemyVo.speed=0.7;
			enemyVo.score=100;
			enemyVoVec.push(enemyVo);
			
			enemyVo=new EnemyVo;
			enemyVo.type=1;
			enemyVo.hp=10;
			enemyVo.speed=0.5;
			enemyVo.score=200;
			enemyVoVec.push(enemyVo);
			
			enemyVo=new EnemyVo;
			enemyVo.type=2;
			enemyVo.hp=15;
			enemyVo.speed=0.3;
			enemyVo.score=300;
			enemyVoVec.push(enemyVo);
			
			enemyVo=new EnemyVo;
			enemyVo.type=3;
			enemyVo.hp=20;
			enemyVo.speed=.1;
			enemyVo.score=400;
			enemyVoVec.push(enemyVo);
			
			
			
			
			
		}
		
		/**
		 * 获取敌人数据 
		 * @param type
		 * @return 
		 * 
		 */		
		public function getEnemyVo(type:uint):EnemyVo
		{
			return enemyVoVec[type];
		}
		
		private var bulletVoVec:Vector.<BulletVo>;
		
		
		
		/**
		 *更新子弹数据 
		 * 
		 */		
		private function initBulletData():void
		{
			bulletVoVec=new Vector.<BulletVo>;
			
			var bulletVo:BulletVo = new BulletVo();
			bulletVo.type=0;
			bulletVo.speed=8;
			bulletVo.atk=5;
			bulletVoVec.push(bulletVo);
			
			 bulletVo = new BulletVo();
			bulletVo.type=1;
			bulletVo.speed=12;
			bulletVo.atk=7;
			bulletVoVec.push(bulletVo);
			
			 bulletVo = new BulletVo();
			bulletVo.type=2;
			bulletVo.speed=17;
			bulletVo.atk=9;
			bulletVoVec.push(bulletVo);
			
			 bulletVo = new BulletVo();
			bulletVo.type=3;
			bulletVo.speed=22;
			bulletVo.atk=12;
			bulletVoVec.push(bulletVo);
			
			//可以干掉任意一种敌人
			bulletVo = new BulletVo();
			bulletVo.type=4;
			bulletVo.speed=25;
			bulletVo.atk=20;
			bulletVoVec.push(bulletVo);
			
			
		}
		
		/**
		 * 获取子弹数据 
		 * @param type
		 * @return 
		 * 
		 */		
		public function getBulletVo(type:uint):BulletVo
		{
			return bulletVoVec[type];
		}
		
		
	}
}