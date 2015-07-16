package body
{
	
	import data.GlobalData;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	
	import util.ObjectPool;
	
	import vo.EnemyVo;
	
	public class Enemy extends  Sprite
	{
		public function Enemy()
		{
			super();
			
			this.touchable=false;
			//trace("创建了敌人");
			
		}
		
		private var img:Image;
		
		public var speed:Number;
		public var score:uint;
		
		private var _hp:int;
		
		private var blood:Blood;
		
		public function get hp():int
		{
			return _hp;
		}
		
		public function set hp(value:int):void
		{
			_hp = value;
			
			if(blood)
				blood.currentHp=_hp;
		}
		
		
		public function init(enmeyVo:EnemyVo):void
		{
			if(!enmeyVo) return ;
			
			var texture:Texture=GlobalData.enemyTextureVec[enmeyVo.type];
			
			if(!texture) return;
			
			if(img)
			{
				img.texture=texture;
				
			}else
			{
				img=new Image(texture);
				
				/*this.pivotX=this.width>>1;
				this.pivotY=this.height>>1;*/
				
				this.scaleX=this.scaleY=GlobalData.elementSize/img.width;
				
			}
			this.addChild(img);	
			
			speed=enmeyVo.speed;
			hp=enmeyVo.hp;
			score=enmeyVo.score;
			
			this.y=0;
			this.x=uint(Math.random()*GlobalData.elementCol)*GlobalData.elementSize;
			
			//添加血条
			if(!blood)
			{
				blood = new Blood(hp,hp);
				blood.y=-blood.height;
				blood.x=this.width/2+5;
				
				
			}else
			{
				blood.currentHp=blood.maxHp=hp;
				
			}
			this.addChild(blood);
			
		}
		
		
		private var beHitMc:MovieClip;
		/**
		 *是否被击中 
		 */		
		private var _isBeHit:Boolean;
		
		
		public function get isBeHit():Boolean
		{
			return _isBeHit;
		}
		
		public function set isBeHit(value:Boolean):void
		{
			_isBeHit = value;
			
			if(_isBeHit)
			{
				//被击中
				if(beHitMc)
				{
					beHitMc.play();
					
				}else
				{
					var textureVec:Vector.<Texture>=GlobalData.assets.otherAssets.getTextures("H_pg000");
					beHitMc = new MovieClip(textureVec);
					beHitMc.addEventListener(Event.COMPLETE,function ():void{isBeHit=false});
					beHitMc.x-=5;
					//beHitMc.x=(this.width-beHitMc.width)/2;
				}
				
				Starling.juggler.add(beHitMc);
				this.addChild(beHitMc);
				
			}else
			{
				beHitMc.stop();
				Starling.juggler.remove(beHitMc);
				this.removeChild(beHitMc);
			}
			
			
		}
		
		
		/**
		 *是否死亡 
		 */		
		private var dieMc:MovieClip;
		private var _isDie:Boolean;
		
		public function get isDie():Boolean
		{
			return _isDie;
		}
		
		public function set isDie(value:Boolean):void
		{
			_isDie = value;
			
			if(_isDie)
			{
				//移除显示项
				while(this.numChildren>0)
					this.removeChildAt(0);
				
				//被击中
				if(dieMc)
				{
					dieMc.play();
					
				}else
				{
					var textureVec:Vector.<Texture>=GlobalData.assets.otherAssets.getTextures("ghost");
					dieMc = new MovieClip(textureVec,10);
					dieMc.addEventListener(Event.COMPLETE,distroy);
					
					//dieMc.x=(this.width-dieMc.width)/2;
					dieMc.y-=60;
				}
				
				Starling.juggler.add(dieMc);
				this.addChild(dieMc);
				
			}else
			{
				
			}
			
			
			
		}
		
		
		private function distroy():void
		{
		
			
			if(dieMc)
			{
				dieMc.stop();
				Starling.juggler.remove(dieMc);
				this.removeChild(dieMc);
				
			}
			
			isDie=false;
			this.removeFromParent(true);
			
			ObjectPool.returnObject(this);
			
			
		}
		
		
		
		
		
	}
}