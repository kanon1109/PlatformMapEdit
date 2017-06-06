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
		this.titleTxt = new Label(this, 0, 0, "地形");
		this.titleTxt.x = this.width / 2 - this.titleTxt.width / 2;
		this.titleTxt.y = 2;
		
		this.rect = new Sprite();
		this.rect.graphics.lineStyle(1);
		this.rect.graphics.beginFill(0x8E8E8E);
		this.rect.graphics.drawRect(0, 0, 70, 70);
		this.rect.graphics.endFill();
		this.addChild(this.rect);
		this.rect.x = 10;
		this.rect.y = 30;
		
		this.quad1 = new Sprite();
		this.quad1.graphics.lineStyle(1);
		this.quad1.graphics.beginFill(0x8E8E8E);
		this.quad1.graphics.moveTo(20, 0);
		this.quad1.graphics.lineTo(80, 0);
		this.quad1.graphics.lineTo(60, 70);
		this.quad1.graphics.lineTo(0, 70);
		this.quad1.graphics.endFill();
		this.addChild(this.quad1);
		this.quad1.x = 90;
		this.quad1.y = 30;
		
		this.quad2 = new Sprite();
		this.quad2.graphics.lineStyle(1);
		this.quad2.graphics.beginFill(0x8E8E8E);
		this.quad2.graphics.moveTo(0, 0);
		this.quad2.graphics.lineTo(60, 0);
		this.quad2.graphics.lineTo(80, 70);
		this.quad2.graphics.lineTo(20, 70);
		this.quad2.graphics.endFill();
		this.addChild(this.quad2);
		this.quad2.x = 10;
		this.quad2.y = 120;
	}
	
}
}