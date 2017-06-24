package view.ui 
{
import com.bit101.components.CheckBox;
import com.bit101.components.HBox;
import com.bit101.components.InputText;
import com.bit101.components.Label;
import com.bit101.components.Panel;
import com.bit101.components.PushButton;
import com.bit101.components.RadioButton;
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
	public var clearBtn:PushButton;
	public var saveBtn:PushButton;
	public var loadBtn:PushButton;
	public var vSlider:VUISlider;
	public var posXValueTxt:InputText;
	public var posYValueTxt:InputText;
	public var stageWidth:Number = 1100;
	public var stageHeight:Number = 600;
	public var baseAttributeLayout:HBox;
	public var faceAttributeLayout:HBox;
	public var faceChickBoxAttributeLayout:HBox;
	public var faceComponetsPanel:SurfaceComponetsPanel;
	public var upLeftXTxt:InputText;
	public var downLeftXTxt:InputText;
	public var upRightXTxt:InputText;
	public var downRightXTxt:InputText;
	public var upYTxt:InputText;
	public var downYTxt:InputText;
	public var leftRestrict:CheckBox;
	public var rightRestrict:CheckBox;
	public var leftBlock:CheckBox;
	public var rightBlock:CheckBox;
	public var upBlock:CheckBox;
	public var downBlock:CheckBox;
	public var leftHeightTxt:InputText;
	public var rightHeightTxt:InputText;
	public var depthTxt:InputText;
	public var nameTxt:InputText;
	public var runBtn:PushButton;
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
	private var textBox:HBox;
	private var checkBox:HBox;
	private var allBox:VBox;
	private var leftHeightLabel:Label;
	private var rightHeightLabel:Label;
	private var depthLabel:Label;
	private var nameLabel:Label;
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
		this.saveBtn = new PushButton(hbox, 0, 5, "save");
		this.loadBtn = new PushButton(hbox, 0, 5, "load");
		this.clearBtn = new PushButton(hbox, 0, 5, "clear");
		this.runBtn = new PushButton(hbox, 0, 5, "run");
		this.importBtn.setSize(120, 30);
		this.saveBtn.setSize(120, 30);
		this.loadBtn.setSize(120, 30);
		this.clearBtn.setSize(120, 30);
		this.runBtn.setSize(120, 30);
		
		this.center = new Point(this.stagePanel.x + this.stagePanel.width / 2, 
								this.stagePanel.y + this.stagePanel.height / 2);
								
		this.vSlider = new VUISlider(Layer.EDIT_LAYER, 0, 0, "舞台缩放比");
		this.vSlider.x = this.stagePanel.x + this.stagePanel.width - 65;
		this.vSlider.y = this.stagePanel.y ;
		this.vSlider.minimum = 0;
		this.vSlider.maximum = 100;
		this.vSlider.value = 100;
		
		this.allBox = new VBox(this.attributePanel);
		this.textBox = new HBox(this.allBox);
		this.checkBox = new HBox(this.allBox, 10);
		
		this.baseAttributeLayout = new HBox(this.textBox);
		this.posXTxt = new Label(this.baseAttributeLayout, 0, 0, "x:");
		this.posXValueTxt = new InputText(this.baseAttributeLayout);
		this.posYTxt = new Label(this.baseAttributeLayout, 0, 0, "y:");
		this.posYValueTxt = new InputText(this.baseAttributeLayout);
		
		this.posXValueTxt.setSize(40, 20);
		this.posYValueTxt.setSize(40, 20);
		
		this.posXValueTxt.restrict = "0-9\\-";
		this.posYValueTxt.restrict = "0-9\\-";
		
		this.faceAttributeLayout = new HBox(this.textBox);
		this.upLeftXLabel = new Label(this.faceAttributeLayout, 0, 0, "upleftX:");
		this.upLeftXTxt = new InputText(this.faceAttributeLayout);
		this.downLeftXLabel = new Label(this.faceAttributeLayout, 0, 0, "downleftX:");
		this.downLeftXTxt = new InputText(this.faceAttributeLayout);
		this.upRightXLabel = new Label(this.faceAttributeLayout, 0, 0, "upRightX:");
		this.upRightXTxt = new InputText(this.faceAttributeLayout);
		this.downRightXLabel = new Label(this.faceAttributeLayout, 0, 0, "downRightX:");
		this.downRightXTxt = new InputText(this.faceAttributeLayout);
		this.upYLabel = new Label(this.faceAttributeLayout, 0, 0, "upY:");
		this.upYTxt = new InputText(this.faceAttributeLayout);
		this.downYLabel = new Label(this.faceAttributeLayout, 0, 0, "downY:");
		this.downYTxt = new InputText(this.faceAttributeLayout);
		
		this.upLeftXTxt.setSize(40, 20);
		this.downLeftXTxt.setSize(40, 20);
		this.upRightXTxt.setSize(40, 20);
		this.downRightXTxt.setSize(40, 20);
		this.upYTxt.setSize(40, 20);
		this.downYTxt.setSize(40, 20);
		
		this.upLeftXTxt.restrict = "0-9\\-";
		this.downLeftXTxt.restrict = "0-9\\-";
		this.upRightXTxt.restrict = "0-9\\-";
		this.downRightXTxt.restrict = "0-9\\-";
		this.upYTxt.restrict = "0-9\\-";
		this.downYTxt.restrict = "0-9\\-";
		
		this.leftHeightLabel = new Label(this.faceAttributeLayout, 0, 0, "left height:");
		this.leftHeightTxt = new InputText(this.faceAttributeLayout);
		this.rightHeightLabel = new Label(this.faceAttributeLayout, 0, 0, "right height:");
		this.rightHeightTxt = new InputText(this.faceAttributeLayout);
		this.leftHeightTxt.setSize(40, 20);
		this.rightHeightTxt.setSize(40, 20);
		this.leftHeightTxt.restrict = "0-9";
		this.rightHeightTxt.restrict = "0-9";
		
		this.depthLabel = new Label(this.faceAttributeLayout, 0, 0, "depth:");
		this.depthTxt = new InputText(this.faceAttributeLayout);
		this.depthTxt.setSize(30, 20);
		this.depthTxt.restrict = "0-9";
		
		this.nameLabel = new Label(this.faceAttributeLayout, 0, 0, "name:");
		this.nameTxt = new InputText(this.faceAttributeLayout);
		this.nameTxt.setSize(70, 20);
		this.nameTxt.restrict = "0-9\a-z\A-Z";
		
		this.faceChickBoxAttributeLayout = new HBox(this.checkBox);
		this.leftRestrict = new CheckBox(this.faceChickBoxAttributeLayout, 0, 5, "left restrict:");
		this.rightRestrict = new CheckBox(this.faceChickBoxAttributeLayout, 0, 5, "right restrict:");
		
		this.leftBlock = new CheckBox(this.faceChickBoxAttributeLayout, 0, 5, "left block:");
		this.rightBlock = new CheckBox(this.faceChickBoxAttributeLayout, 0, 5, "right block:");
		
		this.upBlock = new CheckBox(this.faceChickBoxAttributeLayout, 0, 5, "up block:");
		this.downBlock = new CheckBox(this.faceChickBoxAttributeLayout, 0, 5, "down block:");
		
		
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
		this.allBox.visible = spt != null;
		if (spt)
		{
			var pos:Point = spt.parent.localToGlobal(new Point(spt.x, spt.y));
			pos = this.stagePanel.globalToLocal(pos);
			this.posXValueTxt.text = pos.x.toString();
			this.posYValueTxt.text = pos.y.toString();
			
			if (spt is SurfaceComponet)
			{
				var face:SurfaceComponet = spt as SurfaceComponet;
				this.textBox.addChild(this.faceAttributeLayout);
				this.checkBox.addChild(this.faceChickBoxAttributeLayout);
				this.upLeftXTxt.text = face.upLeftPoint.x.toString();
				this.downLeftXTxt.text = face.downLeftPoint.x.toString();
				this.upRightXTxt.text = face.upRightPoint.x.toString();
				this.downRightXTxt.text = face.downRightPoint.x.toString();
				this.upYTxt.text = face.upLeftPoint.y.toString();
				this.downYTxt.text = face.downLeftPoint.y.toString();
				this.leftHeightTxt.text = face.leftH.toString();
				this.rightHeightTxt.text = face.rightH.toString();
				this.depthTxt.text = face.depth.toString();
				this.nameTxt.text = face.name;
				
				this.leftRestrict.selected = face.leftRestrict;
				this.rightRestrict.selected = face.rightRestrict;
			
				this.leftBlock.selected = face.leftBlock;
				this.rightBlock.selected = face.rightBlock;
				
				if (face.leftH > 0)
					this.leftBlock.selected = false;

				if (face.rightH <= 0)
					this.rightBlock.selected = false;

				this.upBlock.selected = face.upBlock;
				this.downBlock.selected = face.downBlock;
			}
			else
			{
				if (this.faceAttributeLayout.parent)
					this.faceAttributeLayout.parent.removeChild(this.faceAttributeLayout);
					
				if (this.faceChickBoxAttributeLayout.parent)
					this.faceChickBoxAttributeLayout.parent.removeChild(this.faceChickBoxAttributeLayout);
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