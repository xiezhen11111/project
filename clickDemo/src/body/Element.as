package body
{
	
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.textures.Texture;
	import data.GlobalData;
	
	
	/**
	 * 消除的元素 
	 * @author pc001
	 * 
	 */	
	public class Element extends Sprite
	{
		private var size:uint=64;
		
		private var img:Image;
		
		
		/**
		 *设置行索引 
		 */		
		private var _row:uint;
		
		public function get row():uint
		{
			return _row;
		}
		
		public function set row(value:uint):void
		{
			_row = value;
			targetRow=value;
			this.y=GlobalData.startPosY+_row*size;
			
		}
		
		
		/**
		 *设置列索引 
		 */		
		private var _col:uint;
		
		
		public function get col():uint
		{
			return _col;
		}
		
		public function set col(value:uint):void
		{
			_col = value;
			targteCol=value;
			this.x=_col*size;
		}
		
		
		public function Element()
		{
			super();
			//trace("创建了元素");
			
		}
		
		
		/**
		 *是否处于选中状态
		 */		
		private var _isSelect:Boolean;
		private var background:Quad;
		
		/**
		 *元素的类型 
		 */		
		public  var type:uint;
		
		public function get isSelect():Boolean
		{
			return _isSelect;
		}
		
		public function set isSelect(value:Boolean):void
		{
			if(_isSelect == value) return;
			
			_isSelect = value;
			
			if(_isSelect)
			{
				if(!background)
				{
					background = new Quad(size,size,0xff0000);
					background.alpha = 0.5;
				}else
				{
					background.color=0xff0000;
				}
				
				this.addChildAt(background,0);
				
				
			}else
			{
				if(background && this.contains(background))
					this.removeChild(background);
				
			}
			
			
		}
		
		
		/**
		 *是否是发射的起点 
		 */		
		private var _isTarget:Boolean;
		
		public function get isTarget():Boolean
		{
			return _isTarget;
		}
		
		public function set isTarget(value:Boolean):void
		{
			_isTarget = value;
			
			if(_isTarget)
			{
				this.isSelect=false;
				
				if(!background)
				{
			
					background = new Quad(size,size,0x00ff00);
					background.alpha = 0.5;
					
				}else
				{
					background.color=0x00ff00;
				}
				
				
				
				this.addChildAt(background,0);
				
			}else
			{
				if(background && this.contains(background))
					this.removeChild(background);
				
			}
			
			
		}
		
		
		
		
		public var targetRow:uint;
		
		public var targteCol:uint;
		
		
		public function init(type:uint):void
		{
			
			this.type=type;
			
			var texture:Texture=GlobalData.elementTextureVec[type];
			
			if(!texture) return ;
			
			if(!img)
			{
				img=new Image(texture);
				this.addChild(img);
				
				img.width=img.height=size;
				
			}
			else
				img.texture=texture;
			
			
			this.isSelect=this.isTarget=false;
			
			
		}
		
		
		
		
		
		
	}
}