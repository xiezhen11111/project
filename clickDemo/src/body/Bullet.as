package body
{
	import starling.display.Image;
	import starling.textures.Texture;
	
	import vo.BulletVo;
	import data.GlobalData;
		
	
	/**
	 * 子弹类 
	 * @author pc001
	 * 
	 */	
	public class Bullet extends Image
	{
		public function Bullet()
		{
			
			super(GlobalData.bulletTexture);
			
			this.pivotX=this.width>>1;
			
			this.scaleX=this.scaleY=0.2;
			this.touchable=false;
			
		}
		
		
		public var atk:uint;
		
		public var speed:uint;
		
		
		public function init(bulletVo:BulletVo):void
		{
			if(!bulletVo) return;
			
			atk=bulletVo.atk;
			speed=bulletVo.speed;
			
		}
		
		
	}
}