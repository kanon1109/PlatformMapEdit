package view.ui 
{
import com.bit101.components.Label;
import com.bit101.components.Panel;
import flash.display.DisplayObjectContainer;
import flash.display.Sprite;

/**
 * ...面组件面板
 * @author Kanon
 */
public class SufaceComponetsPanel extends Panel 
{
	public var rect:Sprite;
	public var quad1:Sprite;
	public var quad2:Sprite;
	public var trapezoid1:Sprite;
	public var trapezoid2:Sprite;
	public var titleTxt:Label;
	public function SufaceComponetsPanel(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0) 
	{
		super(parent, xpos, ypos);
		this.setSize(180, 300);
		this.initUI();
	}
	
	/**
	 * 初始化UI
	 */
	private function initUI():void
	{
		this.titleTxt = new Label(this, 0, 0, "地形块");
		this.titleTxt.x = this.width / 2 - this.titleTxt.width / 2;
		this.titleTxt.y = 2;
		
		this.rect = this.createRectSuface();
		this.rect.name = "rect";
		this.addChild(this.rect);
		this.rect.x = 10;
		this.rect.y = 30;
		
		this.quad1 = this.createQuadSuface(true);
		this.quad1.name = "quad1";
		this.addChild(this.quad1);
		this.quad1.x = 90;
		this.quad1.y = 30;
		
		this.quad2 = this.createQuadSuface(false);
		this.quad2.name = "quad2";
		this.addChild(this.quad2);
		this.quad2.x = 10;
		this.quad2.y = 120;
		
		this.trapezoid1 = this.createTrapezoidSuface(true);
		this.trapezoid1.name = "trapezoid1";
		this.addChild(this.trapezoid1);
		this.trapezoid1.x = 90;
		this.trapezoid1.y = 120;
		
		this.trapezoid2 = this.createTrapezoidSuface(false);
		this.trapezoid2.name = "trapezoid2";
		this.addChild(this.trapezoid2);
		this.trapezoid2.x = 10;
		this.trapezoid2.y = 210;
	}
	
	/**
	 * 创建矩形
	 * @return	矩形
	 */
	public function createRectSuface():Sprite
	{
		var rect:Sprite = new Sprite();
		rect.graphics.lineStyle(1);
		rect.graphics.beginFill(0x388AE4, .5);
		rect.graphics.drawRect(0, 0, 70, 70);
		rect.graphics.endFill();
		return rect;
	}
	
	
	/**
	 * 创建四边形
	 * @param	flag	正面
	 * @return	四边形
	 */
	public function createQuadSuface(flag:Boolean):Sprite
	{
		var quad:Sprite = new Sprite();
		quad.graphics.lineStyle(1);
		quad.graphics.beginFill(0x388AE4, .5);
		if (flag)
		{
			quad.graphics.moveTo(20, 0);
			quad.graphics.lineTo(80, 0);
			quad.graphics.lineTo(60, 70);
			quad.graphics.lineTo(0, 70);
		}
		else
		{
			quad.graphics.moveTo(0, 0);
			quad.graphics.lineTo(60, 0);
			quad.graphics.lineTo(80, 70);
			quad.graphics.lineTo(20, 70);
		}
		quad.graphics.endFill();
		return quad;
	}
	
	/**
	 * 创建梯形
	 * @param	flag	正面
	 * @return	梯形
	 */
	public function createTrapezoidSuface(flag:Boolean):Sprite
	{
		var trapezoid:Sprite = new Sprite();
		trapezoid.graphics.lineStyle(1);
		trapezoid.graphics.beginFill(0x388AE4, .5);
		if (flag)
		{
			trapezoid.graphics.moveTo(0, 0);
			trapezoid.graphics.lineTo(80, 0);
			trapezoid.graphics.lineTo(60, 70);
			trapezoid.graphics.lineTo(20, 70);
		}
		else
		{
			trapezoid.graphics.moveTo(20, 0);
			trapezoid.graphics.lineTo(60, 0);
			trapezoid.graphics.lineTo(80, 70);
			trapezoid.graphics.lineTo(0, 70);
		}
		trapezoid.graphics.endFill();
		return trapezoid;
	}
}
}