package view.ui 
{
import com.bit101.components.HBox;
import com.bit101.components.Panel;
import com.bit101.components.PushButton;
import com.bit101.components.Style;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.geom.Point;
/**
 * ...编辑器主场景
 * @author Kanon
 */
public class EditUI extends Sprite
{
	public var navPanel:Panel;
	public var stagePanel:Panel;
	public var componentsPanel:Panel;
	public var attributePanel:Panel;
	public var importBtn:PushButton;
	public var exportBtn:PushButton;
	public var center:Point;
	public function EditUI() 
	{
		this.addEventListener(Event.ADDED_TO_STAGE, addToStageHandler);
	}
	
	private function addToStageHandler(event:Event):void 
	{
		this.removeEventListener(Event.ADDED_TO_STAGE, addToStageHandler);
		this.initSytle();
		this.initUI();
		this.initMask();
	}
	
	/**
	 * 初始化风格
	 */
	private function initSytle():void
	{
		Style.embedFonts = false;
		Style.fontName = "微软雅黑";
		Style.fontSize = 12;
		Style.setStyle(Style.DARK);
	}
	
	/**
	 * 初始化UI
	 */
	private function initUI():void
	{
		var gapH:Number = 1;
		this.navPanel = new Panel(this, 0, 0);
		this.navPanel.setSize(1280, 40);
		
		this.stagePanel = new Panel(this, 0, this.navPanel.y + this.navPanel.height + gapH);
		this.stagePanel.setSize(1100, 600);
		//组件
		this.componentsPanel = new Panel(this, this.stagePanel.width, this.stagePanel.y);
		this.componentsPanel.setSize(180, 600);
		
		this.attributePanel = new Panel(this, 0, this.stagePanel.y + this.componentsPanel.height + gapH);
		this.attributePanel.setSize(1280, 126);
		
		//nav
		var hbox:HBox = new HBox(this.navPanel);
		this.importBtn = new PushButton(hbox, 0, 5, "import");
		this.exportBtn = new PushButton(hbox, 0, 5, "export");
		this.importBtn.setSize(120, 30);
		this.exportBtn.setSize(120, 30);
		
		this.center = new Point(this.stagePanel.x + this.stagePanel.width / 2, 
								this.stagePanel.y + this.stagePanel.height / 2);
	}
	
	/**
	 * 初始化遮罩
	 */
	private function initMask():void
	{
		var sp:Shape = new Shape();
		sp.graphics.beginFill(0xff0000);
		sp.graphics.drawRect(0, 0, 
							this.stagePanel.width,  
							this.stagePanel.height);
		sp.graphics.endFill();
		sp.x = this.stagePanel.x;
		sp.y = this.stagePanel.y;
		Layer.UI_STAGE.mask = sp;
	}
}
}