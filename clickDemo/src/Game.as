package
{

	import com.greensock.TweenLite;
	
	import flash.geom.Point;
	
	import body.Bullet;
	import body.Element;
	import body.Enemy;
	
	import data.GameData;
	import data.GlobalData;
	
	import myEvent.MyEvent;
	
	import starling.display.BlendMode;
	import starling.display.Button;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.textures.Texture;
	
	import util.ObjectPool;
	
	import vo.BulletVo;
	import vo.EnemyVo;
	
	public class Game extends Sprite
	{
		
		
		
		/**
		 *游戏是否继续 
		 */		
		private var isPlaying:Boolean;
		
		/**
		 *保存创建的元素 
		 */		
		private var elementArr:Array;
		
		/**
		 * 选中的元素
		 */		
		private var selectElementArr:Array;
		
		/**
		 *目标的元素（首次点击选中的） 
		 */		
		private var tagetElement:Element;
		
		/**
		 *城墙层 
		 */		
		private var wallSpr:Sprite;
		
		
		/**
		 * 元素层
		 */		
		private var elementSpr:Sprite;
		
		/**
		 *检测碰撞的层 
		 */		
		private var collisionSpr:Sprite;
		
		/**
		 *ui层 
		 */		
		private var uiSpr:Sprite;
		
		/**
		 *保存敌人 
		 */		
		private var enemyVec:Vector.<Enemy>;
		
		/**
		 *保存子弹 
		 */		
		private var bulletVec:Vector.<Bullet>;
		
		/**
		 *最后一个元素，定位子弹的发射点 
		 */		
		private var lastElement:Element;
		
		private var isAddEnemy:Boolean;
		
		private var isWait:Boolean;
		
		private var waitTime:uint;
		
		private var waveEnemyNum:uint=6;
		
		/**
		 *生命线，当敌人越过该线时游戏结束 
		 */		
		private var lifeLine:Number;
		
		private var score:uint;
		
		public function Game()
		{
			
			init();
		}
		
		
		/**
		 *游戏初始化 
		 * 
		 */		
		private function init():void
		{
			

			
			isPlaying=true;
			selectElementArr=[];
			
			
			//显示背景
			var bgImage:Image = new Image(GlobalData.assets.otherAssets.getTexture("地图"));
			this.addChild(bgImage);
			//完全不透明的矩形纹理，GPU禁用纹理混合
			bgImage.blendMode = BlendMode.NONE;
			//无需响应事件
			bgImage.touchable=false;
			
			
			
			//创建城墙
			wallSpr=new Sprite;
			wallSpr.touchable=false;
			wallSpr.flatten();
			wallSpr.y=GlobalData.startPosY-40;
			this.addChild(wallSpr);
			var num:uint=Math.ceil(GlobalData.stage.stageWidth/64);
			var wallTexture:Texture=GlobalData.assets.otherAssets.getTexture("城墙");
			for(var i:uint=0;i<num;i++)
			{
				var img:Image=new Image(wallTexture);	
				wallSpr.addChild(img);
				img.scaleX=img.scaleY=64/img.width;
				img.x=i*64;
				
			}
			
			lifeLine=wallSpr.y-60;
			
			
			//子弹纹理
			GlobalData.bulletTexture=GlobalData.assets.otherAssets.getTexture("zidan");
		
			//初始化各层
			elementSpr=new Sprite;
			this.addChild(elementSpr);
			
			collisionSpr=new Sprite;
			this.addChild(collisionSpr);
			
			uiSpr=new Sprite;
			this.addChild(uiSpr);
			
			
			//创建暂停按钮
			var button:Button = new Button(wallTexture,"Pause");
			button.textHAlign="center";
			button.textVAlign="center";
			button.name="pause"
			uiSpr.addChild(button);
			trace(GlobalData.stage.stageHeight);
			button.x=GlobalData.stage.stageWidth-button.width-20;
			button.y=20;
			button.addEventListener(Event.TRIGGERED,onTri);
			
			//创建得分文本框
			scoreTxt=new TextField(200,50,"得分："+score);
			scoreTxt.y=20;
			scoreTxt.x=20;
			scoreTxt.fontSize=20;
			scoreTxt.color=0xff0000;
			scoreTxt.hAlign="left";
			scoreTxt.touchable=false;
			uiSpr.addChild(scoreTxt);
			
			//创建元素
			createElement();
			
			
			//创建敌人
			createEnemy();
			
			bulletVec=new Vector.<Bullet>;
			
			//侦听事件
			addEventListener(TouchEvent.TOUCH,onTouch);
			addEventListener(Event.ENTER_FRAME,onUpdate);
			
		}
		
		/**
		 * 暂停按钮 
		 * @param e
		 * 
		 */		
		private function onTri(e:Event):void
		{
			this.dispatchEventWith(MyEvent.GAME_PAUSE);
			
			//游戏暂停
			gamePause();
			
		}		
		
		
		
		/**
		 *创建敌人 
		 * 
		 */		
		private function createEnemy():void
		{
			enemyVec=new Vector.<Enemy>;
			GlobalData.enemyTextureVec=new Vector.<Texture>;
			
			//获取纹理
			for(var i:uint=1;i<=GlobalData.enemyNum;i++)
			{
				GlobalData.enemyTextureVec.push(GlobalData.assets.otherAssets.getTexture("怪物"+i));
			}
			
			isAddEnemy=true;
			isWait=false;
			
			
		}	
		
		/**
		 *添加敌人 
		 * 
		 */		
		private function addEnemy():void
		{
			var index:uint=Math.random()*GlobalData.enemyNum;
			var enemyVo:EnemyVo=GameData.instance().getEnemyVo(index);
			
			var enemy:Enemy = ObjectPool.getObject(Enemy);//new Enemy();
			enemy.init(enemyVo);
			
			collisionSpr.addChild(enemy);
			this.enemyVec.push(enemy);
			
		}
		
		private var enemyAddCount:uint;
		
		/**
		 *游戏主循环 
		 * 
		 */		
		private function onUpdate(e:Event):void
		{
			count++;
			
			if(count % 30==0)
			{
				//补充元素
				addElement();
				
			}
			
			if(isAddEnemy &&　count%50==0  && !isWait)
			{
				
				//添加敌人
				if(enemyAddCount<waveEnemyNum)
				{
					addEnemy();
					enemyAddCount++;
				}
				
			}
			
			//判断下一波的添加时机
			if(enemyAddCount ==6 && (this.enemyVec.length==0 ||  enemyVec[enemyVec.length-1].y>10))
			{
				isWait=true;
				waitTime=0;
				enemyAddCount=0;
			}
			
			//等待计时
			if(isWait)
			{
				waitTime++;
				if(waitTime>600)
				{
					isWait=false;
					count=0;
				}
				
			}
			
			
			
			updateEnemy();
			
			updateBullet();

			
			sort();
			
			
		}		
		
		
		/**
		 *更新子弹 
		 * 
		 */		
		private function updateBullet():void
		{
			var bullet:Bullet;
			
			
			for(var i:int=bulletVec.length-1;i>=0;i--)
			{
				bullet=bulletVec[i];
				bullet.y-=bullet.speed;
				
				var enemy:Enemy;
				
				//移除屏幕外
				if(bullet.y<-bullet.height)
				{
					bullet.removeFromParent(true);
					bulletVec.splice(i,1);
					ObjectPool.returnObject(bullet);
					continue;
				}
				
				//检测与敌人的碰撞
				for(var j:int=enemyVec.length-1;j>=0;j--)
				{
					enemy=enemyVec[j];
					
					if(bullet.bounds.intersects(enemy.bounds))
					{
						bullet.removeFromParent(true);
						bulletVec.splice(i,1);
						ObjectPool.returnObject(bullet);
						
						enemy.hp-=bullet.atk;
						
						if(enemy.hp<=0)
						{
							//挂了
							
							enemyVec.splice(j,1);
							
							score+=enemy.score;
							this.scoreTxt.text="得分："+score;
							
							enemy.isDie=true;
							
							/*enemy.removeFromParent(true);
							
							ObjectPool.returnObject(enemy);*/
							
							
						}else
						{
							//受击
							enemy.isBeHit=true;
							
						}
						
						break;
						
					}
					
					
					
				}
				
				
				
			}
			
		}		
		
			
		
		/**
		 *更新敌人 
		 * 
		 */		
		private function updateEnemy():void
		{
			var enemy:Enemy;
	
			for(var i:int=enemyVec.length-1;i>=0;i--)
			{
				enemy=enemyVec[i];
				enemy.y+=enemy.speed;
				
				//检测游戏是否结束
				if(enemy.y>=lifeLine)
				{
				
					gamePause();

					this.dispatchEventWith(MyEvent.GAME_OVER);
					
					break;
				}
				
			}
			
		}
		
		private var count:uint=0;

		private var scoreTxt:TextField;
		/**
		 *补充元素 
		 * 
		 */		
		private function addElement():void
		{
			
			//获取哪一列需要补充元素
			var isSame:Boolean=false;
			var posArr:Array=[];
			for(var col:uint=0;col<GlobalData.elementCol;col++)
			{
				for( var row:uint=0;row<GlobalData.elementRow;row++)
				{
					
					
					if(!elementArr[row][col])
					{
						//缺少元素
						//防止重复添加
						if(posArr.length==0)
						{
							posArr.push([row,col]);
							
						}else
						{
							isSame=false;
							for(var i:uint=0;i<posArr.length;i++)
							{
								
								if(posArr[i][1]==col)
								{
									//相同，推出循环
									isSame=true;
									break;
								}
								
							}
							
							if(!isSame)
								posArr.push([row,col]);
							
						}
						
						
					}
					
					
				}
				
				
				
			}
			
			
			if(posArr.length==0) return ;
			
			//			trace(posArr);
			//随机一个添加
			var arr:Array=posArr[uint(Math.random()*posArr.length)];
			var element:Element = ObjectPool.getObject(Element);//new Element();
			element.init(uint(Math.random()*GlobalData.elementNum));
			element.row=GlobalData.elementRow;
			element.col=arr[1];
			element.targetRow=arr[0];
			elementArr[arr[0]][arr[1]]=element;
			elementSpr.addChild(element);
			TweenLite.to(element, .3, {y:GlobalData.startPosY+element.targetRow*GlobalData.elementSize,onComplete:moveOver,onCompleteParams:[element]});
			
			
			
			
		}
		
		/**
		 *创建消除元素 
		 * 
		 */		
		private function createElement():void
		{
			
			
			GlobalData.elementTextureVec=new Vector.<Texture>;
			//获取消除元素的纹理集
			for(var i:uint=1;i<=GlobalData.elementNum;i++)
			{
				GlobalData.elementTextureVec.push(GlobalData.assets.otherAssets.getTexture("元素"+i));
			}
			
			elementArr=[];
			//创建元素
			for( var row:uint=0;row<GlobalData.elementRow;row++)
			{
				elementArr[row]=[];
				
				for(var col:uint=0;col<GlobalData.elementCol;col++)
				{
					var type:uint=Math.random()*GlobalData.elementNum;
					
					var element:Element =ObjectPool.getObject(Element);// new Element();
					element.init(type);
					element.row=row;
					element.col=col;
					
					elementSpr.addChild(element);
					
					elementArr[row][col]=element;
					
				}
				
				
			}
			
			
			
			
			
		}	
		
		
		
		/**
		 * 处理鼠标事件
		 * @param e
		 * 
		 */		
		private function onTouch(e:TouchEvent):void
		{
			if(!isPlaying) return;
			
			var touch:Touch = e.getTouch(this);
			
			var element:Element=(e.target as DisplayObject).parent as Element;
			
			
			if( touch &&　element )
			{
				if(touch.phase==TouchPhase.BEGAN)
				{
					
					//鼠标按下
					if( !element.isSelect)
					{
						element.isTarget=true;
						
						tagetElement=element;
						lastElement=element;
						
						selectElementArr.push(element);
					}
					
				}else if(touch.phase==TouchPhase.MOVED)
				{
					if(!tagetElement) return;
					
					//
					var obj:DisplayObject=this.hitTest(this.globalToLocal(new Point(touch.globalX,touch.globalY))) as DisplayObject ;
					if(!obj) return ;
					element=obj.parent as Element;
					
					//不是上一个且符合条件
					if(lastElement!=element && checkElementIsOk(element))
					{
						if( !element.isSelect)
						{
							selectElementArr.push(element);
							
						}
						
						//只要移动到了元素上就是目标的
						element.isTarget=true;
						//恢复上一个
						lastElement.isSelect=true;
						//保存
						lastElement=element;
						
					}
					
					
					
					
				}else if(touch.phase==TouchPhase.ENDED)
				{
					//鼠标抬起
					var num:uint=selectElementArr.length
					
					if(num==1)
					{
						tagetElement.isTarget=false;
						selectElementArr.length=0;
						return ;
						
					}
					tagetElement=null;
					
					//更新元素
					updateElement();
					
					//添加子弹
					addBullet(num);
					
					selectElementArr.length=0;
					
				}
				
				
				
				
			}
			
			
			
			
			
		}	
		
		
		/**
		 *添加子弹 
		 * 
		 */		
		private function addBullet(num:uint):void
		{
			if(num<=2) return;
			
			//生成的子弹类型
			var type:uint=num/2;
			type=type>3?4:type;
			var getBulletVo:BulletVo = GameData.instance().getBulletVo(type);
			var bullet:Bullet = ObjectPool.getObject(Bullet);//new Bullet();
			bullet.init(getBulletVo);
			bullet.x=this.lastElement.x+GlobalData.elementSize/2;
			bullet.y=lastElement.y;
			collisionSpr.addChild(bullet);
			
			this.bulletVec.push(bullet);
			
			lastElement=null;
			
		}
		
		/**
		 * 检查是否符合选中条件 
		 * @param ele   待检测的元素
		 * @return 
		 * 
		 */		
		private function checkElementIsOk(ele:Element):Boolean
		{
			if(!ele) return  false;
			else if(ele.type!=this.tagetElement.type) return false;
			else 
			{
				for( var i:uint=0;i<selectElementArr.length;i++)
				{
					
					var tempElement:Element=selectElementArr[i];
					
					if(!tempElement) continue;
					
					var rowDis:uint=Math.abs(ele.row-tempElement.row);
					var colDis:uint=Math.abs(ele.col-tempElement.col);
					
					//检测水平垂直与斜角
					if(((rowDis + colDis==1) || (colDis==1 && rowDis==1)))
					{
						//trace(tempElement.row,"    ",tempElement.col,ele.row,ele.col);
						
						return true;
					}
					
					
				}
				
				
				return false;
				
			}
			
			return true;
			
			
		}
		
		/**
		 *执行消除操作 
		 * 
		 */		
		private function updateElement():void
		{
			
			
			for(var i:int=selectElementArr.length-1;i>=0;i--)
			{
				var element:Element=selectElementArr[i];
				var targetRow:uint=element.targetRow;
				var targetCol:uint=element.targteCol;
				
				elementArr[targetRow][targetCol]=null;
				
				for(var j:uint=targetRow+1;j<GlobalData.elementRow;j++)
				{
					var targetElemnet:Element=elementArr[j][targetCol];
					
					if(!targetElemnet) break;
					
					//更新数组中的位置
					elementArr[j][targetCol]=null;
					elementArr[j-1][targetCol]=targetElemnet;
					
					
					//更新行索引
					targetElemnet.targetRow--;
					//targetElemnet.row--;
					
					
				}
				
				//移除
				element.removeFromParent(true);
				ObjectPool.returnObject(element);
				
				
			}
			//traceArr();
			
			//return;
			
			//缓懂得移动对象
			for( var row:uint=0;row<GlobalData.elementRow;row++)
			{
				
				
				for(var col:uint=0;col<GlobalData.elementCol;col++)
				{
					targetElemnet=elementArr[row][col];
					
					if(targetElemnet &&  targetElemnet.targetRow!=targetElemnet.row)
					{
						//缓动移动
						TweenLite.to(targetElemnet, .5, {y:GlobalData.startPosY+targetElemnet.targetRow*GlobalData.elementSize,onComplete:moveOver,onCompleteParams:[targetElemnet]});
						
						
					}
					
				}
				
			}
			
			
			
			
			
		}
		
		
		
		
		
		/**
		 * 移动结束 
		 * @param targteElemnet
		 * 
		 */		
		private function moveOver(targteElemnet:Element):void
		{
			targteElemnet.row=targteElemnet.targetRow;
			//targteElemnet.col=targteElemnet.targteCol;
			
		}
		
		/**
		 *对元素排序 
		 * 
		 */		
		private function sort():void
		{
			if(this.enemyVec.length==0) return;
			var arr:Array = [];
			for(var i:int=0;i<enemyVec.length;i++)
			{
				arr.push(enemyVec[i]);
			}
			
			arr.sortOn("y", Array.NUMERIC);
			
			for(i=arr.length-1;i>=0;i--)
			{
				var displayObj:DisplayObject = arr[i];
				collisionSpr.setChildIndex(displayObj,i);
			}
			
		}
		
		
		/**
		 *游戏暂停 
		 * 
		 */		
		private function gamePause():void
		{
			this.isPlaying=false;
			removeEventListener(TouchEvent.TOUCH,onTouch);
			removeEventListener(Event.ENTER_FRAME,onUpdate);
			
		}
		
		/**
		 *游戏继续 
		 * 
		 */		
		public function gameContinue():void
		{
			this.isPlaying=true;
			addEventListener(TouchEvent.TOUCH,onTouch);
			addEventListener(Event.ENTER_FRAME,onUpdate);
		}
		
		/**
		 *重玩 
		 * 
		 */		
		public function gameAgain():void
		{
			//清空数据
			
			//清除元素
			for( var row:uint=0;row<GlobalData.elementRow;row++)
			{
				
				for(var col:uint=0;col<GlobalData.elementCol;col++)
				{
					
					var element:Element=elementArr[row][col];
					
					if(element)
					{
						element.removeFromParent(true);
						ObjectPool.returnObject(element);
						
						elementArr[row][col]=null;
					}
					
				}
				
			}
			tagetElement=null;
			selectElementArr.length=0;
			
			//清除子弹
			for(var i:int=bulletVec.length-1;i>=0;i--)
			{
				var bullet:Bullet=bulletVec[i];
				
				bullet.removeFromParent(true);
				ObjectPool.returnObject(bullet);
				
			}
			
			bulletVec.length=0;
			
			//清除敌人
			for(var j:int=enemyVec.length-1;j>=0;j--)
			{
				var  enemy:Enemy=enemyVec[j];
				
				enemy.removeFromParent(true);
				ObjectPool.returnObject(enemy);
				
			}
			
			enemyVec.length=0;
			
			
			
			//清除数据
			lastElement=null;
			isAddEnemy=true;
			isWait=false;
			waitTime=0;
			count=0;
			score=0;
			enemyAddCount=0;
			this.scoreTxt.text="得分："+score;
			
			isPlaying=true;
			addEventListener(TouchEvent.TOUCH,onTouch);
			addEventListener(Event.ENTER_FRAME,onUpdate);
			
			//创建元素
			createElement();
			
			
			
		}
		
		
		private function traceArr():void
		{
			var str:String="";
			
			for( var row:uint=0;row<GlobalData.elementRow;row++)
			{
				
				for(var col:uint=0;col<GlobalData.elementCol;col++)
				{
					if(elementArr[row][col])
					{
						str+="1";
					}else
					{
						str+="0";
					}
					
					
				}
				
				str+="\n"
				
			}
			
			trace(str);
		}
		
		
		
		
		
		
		
	}
}