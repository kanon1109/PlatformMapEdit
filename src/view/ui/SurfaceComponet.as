package view.ui 
{
import flash.display.Sprite;

/**
 * ...面组件
 * @author ...
 */
public class SurfaceComponet extends Sprite 
{
	public var upLeftPoint:Sprite;
	public var downLeftPoint:Sprite;
	public var upRightPoint:Sprite;
	public var downRightPoint:Sprite;
	public function SurfaceComponet() 
	{
		this.init();
		this.draw();
		super();
	}
	
	/**
	 * 初始化
	 */
	private function init():void
	{
		this.upLeftPoint = new Sprite();
		this.downLeftPoint = new Sprite();
		this.upRightPoint = new Sprite();
		this.downRightPoint = new Sprite();
		
		this.upLeftPoint.name = "upLeft";
		this.downLeftPoint.name = "downLeft";
		this.upRightPoint.name = "upRight";
		this.downRightPoint.name = "downRight";
		
		this.upLeftPoint.graphics.beginFill(0xff0000, .5);
		this.upLeftPoint.graphics.drawCircle(0, 0, 5);
		this.upLeftPoint.graphics.endFill();
		
		this.downLeftPoint.graphics.beginFill(0xff0000, .5);
		this.downLeftPoint.graphics.drawCircle(0, 0, 5);
		this.downLeftPoint.graphics.endFill();
		
		this.upRightPoint.graphics.beginFill(0xff0000, .5);
		this.upRightPoint.graphics.drawCircle(0, 0, 5);
		this.upRightPoint.graphics.endFill();
		
		this.downRightPoint.graphics.beginFill(0xff0000, .5);
		this.downRightPoint.graphics.drawCircle(0, 0, 5);
		this.downRightPoint.graphics.endFill();
		
		this.addChild(this.upLeftPoint);
		this.addChild(this.downLeftPoint);
		this.addChild(this.upRightPoint);
		this.addChild(this.downRightPoint);
		
		this.setShape(1);
	}
	
	/**
	 * 设置形状
	 * @param	type	形状类型
	 */
	public function setShape(type:int):void
	{
		if (type == 1)
		{
			this.upLeftPoint.x = 0;
			this.upLeftPoint.y = 0;
			
			this.upRightPoint.x = 80;
			this.upRightPoint.y = 0;
			
			this.downRightPoint.x = 80;
			this.downRightPoint.y = 70;
			
			this.downLeftPoint.x = 0;
			this.downLeftPoint.y = 70;
		}
		else if (type == 2)
		{
			this.upLeftPoint.x = 20;
			this.upLeftPoint.y = 0;
			
			this.upRightPoint.x = 80;
			this.upRightPoint.y = 0;
			
			this.downRightPoint.x = 60;
			this.downRightPoint.y = 70;
			
			this.downLeftPoint.x = 0;
			this.downLeftPoint.y = 70;
		}
		else if (type == 3)
		{
			this.upLeftPoint.x = 0;
			this.upLeftPoint.y = 0;
			
			this.upRightPoint.x = 60;
			this.upRightPoint.y = 0;
			
			this.downRightPoint.x = 80;
			this.downRightPoint.y = 70;
			
			this.downLeftPoint.x = 20;
			this.downLeftPoint.y = 70;
		}
		else if (type == 4)
		{
			this.upLeftPoint.x = 0;
			this.upLeftPoint.y = 0;
			
			this.upRightPoint.x = 80;
			this.upRightPoint.y = 0;
			
			this.downRightPoint.x = 60;
			this.downRightPoint.y = 70;
			
			this.downLeftPoint.x = 20;
			this.downLeftPoint.y = 70;
		}
		else if (type == 5)
		{
			this.upLeftPoint.x = 20;
			this.upLeftPoint.y = 0;
			
			this.upRightPoint.x = 60;
			this.upRightPoint.y = 0;
			
			this.downRightPoint.x = 80;
			this.downRightPoint.y = 70;
			
			this.downLeftPoint.x = 0;
			this.downLeftPoint.y = 70;
		}
		this.draw();
	}
	
	/**
	 * 绘制
	 */
	public function draw():void
	{
		this.graphics.clear();
		this.graphics.lineStyle(1, 0x000000);
		this.graphics.beginFill(0x388AE4, .5);
		this.graphics.moveTo(this.upLeftPoint.x, this.upLeftPoint.y);
		this.graphics.lineTo(this.upRightPoint.x, this.upRightPoint.y);
		this.graphics.lineTo(this.downRightPoint.x, this.downRightPoint.y);
		this.graphics.lineTo(this.downLeftPoint.x, this.downLeftPoint.y);
		this.graphics.endFill();
		this.graphics.lineStyle(1, 0);
		this.graphics.moveTo( -5, 0);
		this.graphics.lineTo( 5, 0);
		this.graphics.moveTo( 0, -5);
		this.graphics.lineTo( 0, 5);
	}
	
	/**
	 * 克隆一个face
	 * @return face
	 */
	public function clone():SurfaceComponet
	{
		var faceComponet:SurfaceComponet = new SurfaceComponet();
		faceComponet.upLeftPoint.x = this.upLeftPoint.x;
		faceComponet.upLeftPoint.y = this.upLeftPoint.y;
		faceComponet.upRightPoint.x = this.upRightPoint.x;
		faceComponet.upRightPoint.y = this.upRightPoint.y;
		faceComponet.downLeftPoint.x = this.downLeftPoint.x;
		faceComponet.downLeftPoint.y = this.downLeftPoint.y;
		faceComponet.downRightPoint.x = this.downRightPoint.x;
		faceComponet.downRightPoint.y = this.downRightPoint.y;
		faceComponet.draw();
		return faceComponet;
	}
	
	/**
	 * 输出字符串
	 * @return
	 */
	override public function toString():String
	{
		return this.upLeftPoint.x + 
			   "," + this.downLeftPoint.x + 
			   "," + this.upRightPoint.x + 
			   "," + this.downRightPoint.x + 
			   "," + this.upLeftPoint.y + 
			   "," + this.downLeftPoint.y;
	}
	
	override public function get width():Number 
	{
		var leftX:Number;
		var rightX:Number;
		this.downLeftPoint.x < this.upLeftPoint.x ? leftX = this.downLeftPoint.x : leftX = this.upLeftPoint.x;
		this.downRightPoint.x > this.upRightPoint.x ? rightX = this.downRightPoint.x : rightX = this.upRightPoint.x;
		return rightX - leftX;
	}
	
	override public function get height():Number 
	{
		return this.downLeftPoint.y - this.upLeftPoint.y;
	}
}
}