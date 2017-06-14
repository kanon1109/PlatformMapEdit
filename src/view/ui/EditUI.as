package view.ui 
{
import com.bit101.components.HBox;
import com.bit101.components.InputText;
import com.bit101.components.Label;
import com.bit101.components.Panel;
import com.bit101.components.PushButton;
import com.bit101.components.Style;
import com.bit101.components.VBox;
import com.bit101.components.VUISlider;
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
	public var clearBtn:PushButton;
	public var vSlider:VUISlider;
	public var posXValueTxt:InputText;
	public var posYValueTxt:InputText;
	public var stageWidth:Number = 1100;
	public var stageHeight:Number = 600;
	public var attributeLayout:HBox;
	public var faceAttributeLayout:HBox;
	public var faceComponetsPanel:SurfaceComponetsPanel;
	public var upLeftXTxt:InputText;
	public var downLeftXTxt:InputText;
	public var upRightXTxt:InputText;
	public var downRightXTxt:InputText;
	public var upYTxt:InputText;
	public var downYTxt:InputText;
	
	//---private---
	private var center:Point;
	private var posXTxt:Label;
	private var posYTxt:Label;
	private var upLeftXLabel:Label;
	private var downLeftXLabel:Label;
	private var upRightXLabel:Label;
	private var downRightXLabel:Label;
	private var upYLabel:Label;
	private var downYLabel:Label;
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
		this.drawStage(this.stageWidth, this.stageHeight);
		this.selectSpt(null);
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
		this.stagePanel.setSize(this.stageWidth, this.stageHeight);
		//组件
		this.componentsPanel = new Panel(this, this.stagePanel.width, this.stagePanel.y);
		this.componentsPanel.setSize(180, 600);
		
		this.attributePanel = new Panel(this, 0, this.stagePanel.y + this.componentsPanel.height + gapH);
		this.attributePanel.setSize(1280, 126);
		
		//nav
		var hbox:HBox = new HBox(this.navPanel);
		this.importBtn = new PushButton(hbox, 0, 5, "import");
		this.exportBtn = new PushButton(hbox, 0, 5, "export");
		this.clearBtn = new PushButton(hbox, 0, 5, "clear");
		this.importBtn.setSize(120, 30);
		this.exportBtn.setSize(120, 30);
		this.clearBtn.setSize(120, 30);
		
		this.center = new Point(this.stagePanel.x + this.stagePanel.width / 2, 
								this.stagePanel.y + this.stagePanel.height / 2);
								
		this.vSlider = new VUISlider(Layer.EDIT_LAYER, 0, 0, "舞台缩放比");
		this.vSlider.x = this.stagePanel.x + this.stagePanel.width - 65;
		this.vSlider.y = this.stagePanel.y ;
		this.vSlider.minimum = 0;
		this.vSlider.maximum = 100;
		this.vSlider.value = 100;
		
		this.attributeLayout = new HBox(this.attributePanel);
		this.posXTxt = new Label(this.attributeLayout, 0, 0, "x:");
		this.posXValueTxt = new InputText(this.attributeLayout);
		this.posYTxt = new Label(this.attributeLayout, 0, 0, "y:");
		this.posYValueTxt = new InputText(this.attributeLayout);
		
		this.posXValueTxt.setSize(60, 20);
		this.posYValueTxt.setSize(60, 20);
		
		this.posXValueTxt.restrict = "0-9\\-";
		this.posYValueTxt.restrict = "0-9\\-";
		
		this.faceAttributeLayout = new HBox(this.attributeLayout);
		
		this.upLeftXLabel = new Label(this.faceAttributeLayout, 0, 0, "upleftX");
		this.upLeftXTxt = new InputText(this.faceAttributeLayout);
		this.downLeftXLabel = new Label(this.faceAttributeLayout, 0, 0, "downleftX");
		this.downLeftXTxt = new InputText(this.faceAttributeLayout);
		this.upRightXLabel = new Label(this.faceAttributeLayout, 0, 0, "upRightX");
		this.upRightXTxt = new InputText(this.faceAttributeLayout);
		this.downRightXLabel = new Label(this.faceAttributeLayout, 0, 0, "downRightX");
		this.downRightXTxt = new InputText(this.faceAttributeLayout);
		this.upYLabel = new Label(this.faceAttributeLayout, 0, 0, "upY");
		this.upYTxt = new InputText(this.faceAttributeLayout);
		this.downYLabel = new Label(this.faceAttributeLayout, 0, 0, "downY");
		this.downYTxt = new InputText(this.faceAttributeLayout);
		
		this.upLeftXTxt.setSize(30, 20);
		this.downLeftXTxt.setSize(30, 20);
		this.upRightXTxt.setSize(30, 20);
		this.downRightXTxt.setSize(30, 20);
		this.upYTxt.setSize(30, 20);
		this.downYTxt.setSize(30, 20);
		
		this.upLeftXTxt.restrict = "0-9\\-";
		this.downLeftXTxt.restrict = "0-9\\-";
		this.upRightXTxt.restrict = "0-9\\-";
		this.downRightXTxt.restrict = "0-9\\-";
		this.upYTxt.restrict = "0-9\\-";
		this.downYTxt.restrict = "0-9\\-";
		
		var vBox:VBox = new VBox(this.componentsPanel);
		this.faceComponetsPanel = new SurfaceComponetsPanel(vBox);
	}
	
	/**
	 * 初始化遮罩
	 */
	private function initMask():void
	{
		var sp:Shape = new Shape();
		sp.graphics.beginFill(0xff0000);
		sp.graphics.drawRect(0, 0, this.stageWidth, this.stageHeight);
		sp.graphics.endFill();
		sp.x = this.stagePanel.x;
		sp.y = this.stagePanel.y;
		Layer.STAGE_LAYER.x = this.center.x;
		Layer.STAGE_LAYER.y = this.center.y;
		Layer.STAGE_LAYER.mask = sp;
	}
	
	/**
	 * 绘制舞台
	 */
	private function drawStage(width:Number, height:Number):void
	{
		var sp:Shape = new Shape();
		sp.graphics.lineStyle(1, 0xFFFFFF);
		sp.graphics.drawRect( -width / 2, -height / 2, width, height);
		Layer.STAGE_LAYER.addChild(sp);
	}
	
	/**
	 * 缩放舞台
	 * @param	scale	缩放比
	 */
	public function scaleStage(scale:Number):void
	{
		Layer.STAGE_LAYER.scaleX = scale;
		Layer.STAGE_LAYER.scaleY = scale;
	}
	
	/**
	 * 选中舞台上物品
	 * @param	spt		舞台物品
	 */
	public function selectSpt(spt:Sprite):void
	{
		this.attributeLayout.visible = spt != null;
		if (spt)
		{
			var pos:Point = spt.parent.localToGlobal(new Point(spt.x, spt.y));
			pos = this.stagePanel.globalToLocal(pos);
			this.posXValueTxt.text = pos.x.toString();
			this.posYValueTxt.text = pos.y.toString();
			
			if (spt is SurfaceComponet)
			{
				var face:SurfaceComponet = spt as SurfaceComponet;
				this.attributeLayout.addChild(this.faceAttributeLayout);
				this.upLeftXTxt.text = face.upLeftPoint.x.toString();
				this.downLeftXTxt.text = face.downLeftPoint.x.toString();
				this.upRightXTxt.text = face.upRightPoint.x.toString();
				this.downRightXTxt.text = face.downRightPoint.x.toString();
				this.upYTxt.text = face.upLeftPoint.y.toString();
				this.downYTxt.text = face.downLeftPoint.y.toString();
			}
			else
			{
				if (this.faceAttributeLayout.parent)
					this.faceAttributeLayout.parent.removeChild(this.faceAttributeLayout);
			}
		}
	}
	
	/**
	 * 获取文本的坐标
	 * @return
	 */
	public function getPosTxtValue():Point
	{
		var x:Number = Number(this.posXValueTxt.text) - this.stageWidth / 2;
		var y:Number = Number(this.posYValueTxt.text) - this.stageHeight / 2;
		return new Point(x, y);
	}
	
	
	
}
}