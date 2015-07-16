package body
{
	import starling.display.Quad;
	import starling.display.Sprite;
	import data.GlobalData;
	
	
	/**
	 * 血条 
	 * @author pc001
	 * 
	 */	
	public class Blood extends Sprite
	{
		
		public  var maxHp:uint;
		
		private  var _currentHp:int;
		
		private var bloodFront:Quad;
		
		public function get currentHp():int
		{
			return _currentHp;
		}
		
		public function set currentHp(value:int):void
		{
			_currentHp =Math.max(0, value);
			
			var bl:Number=_currentHp/maxHp;
			bloodFront.scaleX=bl;
			
		}
		
		
		public function Blood(currentHp:int,maxHp:uint)
		{
			super();
			
			
			init();
			
			this.pivotX=this.width>>1;
			this.maxHp=maxHp;
			this.currentHp=currentHp;
			
			
		}
		
		
		private function init():void
		{
			var bloodBg:Quad=new Quad(GlobalData.elementSize,7,0x000000);
			this.addChild(bloodBg);
			
			bloodFront=new Quad(GlobalData.elementSize,7,0xff0000);
			this.addChild(bloodFront);
			
			
		}
		
		
		
		
	}
}