package view.mediator 
{
import componets.Alert;
import componets.Image;
import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.events.ErrorEvent;
import flash.events.Event;
import flash.events.FocusEvent;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.filesystem.File;
import flash.geom.Point;
import flash.net.FileFilter;
import flash.ui.Keyboard;
import flash.ui.Mouse;
import flash.ui.MouseCursor;
import message.Message;
import org.puremvc.as3.interfaces.INotification;
import org.puremvc.as3.patterns.mediator.Mediator;
import utils.AdvanceColorUtil;
import view.ui.EditUI;
import view.ui.SurfaceComponet;
/**
 * ...编辑器中介
 * @author Kanon
 */
public class EditUIMediator extends Mediator 
{
	public static var NAME:String = "EditUIMediator";
	private var editUI:EditUI;
	private var imageFile:File;
	private var imageFilter:FileFilter;
	private var curSelectedSpt:Sprite;
	private var isSpaceKey:Boolean;
	public function EditUIMediator() 
	{
		super(NAME);
	}
	
	override public function listNotificationInterests():Array 
	{
		var arr:Array = [];
		arr.push(Message.START);
		arr.push(Message.FACE_MOUSE_DOWN);
		return arr;
	}
	
	override public function handleNotification(notification:INotification):void 
	{
		switch (notification.getName()) 
		{
			case Message.START:
				this.initEditUI();
				this.initEvent();
				break;
			case Message.FACE_MOUSE_DOWN:
					this.select(notification.getBody() as Sprite);	
					Layer.STAGE.addEventListener(MouseEvent.MOUSE_UP, stageMouseUpHandler);
					Layer.STAGE.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
				break;
			default:
		}
	}
	
	/**
	 * 初始化编辑器UI
	 */
	private function initEditUI():void
	{
		this.editUI = new EditUI();
		Layer.UI_LAYER.addChild(this.editUI);
	}
	
	/**
	 * 初始化事件
	 */	
	private function initEvent():void 
	{
		this.editUI.importBtn.addEventListener(MouseEvent.CLICK, importBtnClickHandler);
		this.editUI.exportBtn.addEventListener(MouseEvent.CLICK, exportBtnClickHandler);
		this.editUI.clearBtn.addEventListener(MouseEvent.CLICK, clearBtnClickHandler);
		this.editUI.vSlider.addEventListener(Event.CHANGE, vSliderChangeHandler);
		this.editUI.posXValueTxt.addEventListener(FocusEvent.FOCUS_OUT, posXValueTxtfocusOutHandler);
		this.editUI.posYValueTxt.addEventListener(FocusEvent.FOCUS_OUT, posYValueTxtfocusOutHandler);
		this.editUI.stagePanel.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownHandler);
		Layer.STAGE.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDownHandler);
		Layer.STAGE.addEventListener(MouseEvent.MOUSE_DOWN, onStageMouseDownHandler);
		Layer.STAGE.addEventListener(MouseEvent.MOUSE_UP, onStageMouseUpHandler);
		Layer.STAGE.addEventListener(KeyboardEvent.KEY_UP, onKeyUpHandler);
		this.sendNotification(Message.INIT, this.editUI);
	}
	
	/**
	 * 选择图片
	 */
	private function selectImage():void
	{
		if (!this.imageFile)
		{
			this.imageFilter = new FileFilter("Image", "*.jpg;*.png");
			this.imageFile = new File();
			this.imageFile.addEventListener(Event.SELECT, selectImageFileHandler);
		}
		this.imageFile.browse([this.imageFilter]);
	}
	
	/**
	 * 拷贝一个显示对象
	 * @param	o	显示对象
	 */
	private function copy(o:Sprite):void
	{
		if (!o) return;
		if (o is Image)
		{
			var image:Image = Image(o).clone();
			image.x = o.x + 20;
			image.y = o.y + 20;
			image.addEventListener(MouseEvent.MOUSE_DOWN, sptOnMouseDownHandler);
			Layer.STAGE_BG_LAYER.addChild(image);
			this.select(image);	
		}
		else if (o is SurfaceComponet)
		{
			var surfaceComponet:SurfaceComponet = SurfaceComponet(o).clone();
			surfaceComponet.x = o.x + 20;
			surfaceComponet.y = o.y + 20;
			Layer.TERRAIN_LAYER.addChild(surfaceComponet); 
			this.select(surfaceComponet);
			this.sendNotification(Message.COPY, surfaceComponet);
		}
	}
	
	/**
	 * 绘制选中的显示对象
	 * @param	spt
	 */
	private function drawSelectedBound(spt:Sprite):void
	{
		if (this.curSelectedSpt) this.curSelectedSpt.transform.colorTransform = AdvanceColorUtil.setColorInitialize();
		if (spt) spt.transform.colorTransform = AdvanceColorUtil.setRGBMixTransform(0x00, 0xCC, 0xFF, 40);
	}
	
	/**
	 * 设置深度
	 * @param	spt		显示对象
	 * @param	flag	深度增加或减少
	 */
	private function setSptDepth(spt:Sprite, flag:Boolean):void
	{
		if (!spt || !spt.parent) return;
		var index:int = spt.parent.getChildIndex(spt);
		if (flag) index++;
		else index--;
		if (index < 0) index = 0;
		else if (index > spt.parent.numChildren - 1) index = spt.parent.numChildren - 1;
		spt.parent.setChildIndex(spt, index);
	}
	
	/**
	 * 删除某个显示对象
	 * @param	spt	显示对象
	 */
	private function removeSpt(spt:Sprite):void
	{
		if (spt && spt.parent)
			spt.parent.removeChild(spt);
	}
	
	/**
	 * 设置当前选中对象的属性
	 */
	private function setCurSptProp():void
	{
		if (this.editUI && this.curSelectedSpt)
		{
			var pos:Point = this.editUI.getPosTxtValue();
			this.curSelectedSpt.x = pos.x;
			this.curSelectedSpt.y = pos.y;
		}
	}
	
	/**
	 * 选中某物
	 * @param	spt	某物
	 */
	private function select(spt:Sprite):void
	{
		this.drawSelectedBound(spt);
		this.curSelectedSpt = spt;
		if (this.editUI) 
			this.editUI.selectSpt(spt);
	}
	
	/**
	 * 删除所有
	 */
	private function removeAll():void
	{
		var count:int = Layer.STAGE_BG_LAYER.numChildren - 1
		for (var i:int = count; i >= 0; --i) 
		{
			var o:DisplayObject = Layer.STAGE_BG_LAYER.getChildAt(i);
			if (o && o.parent)
				o.parent.removeChild(o);
		}
		
		count = Layer.TERRAIN_LAYER.numChildren - 1;
		for (i = count; i >= 0; --i) 
		{
			o = Layer.TERRAIN_LAYER.getChildAt(i);
			if (o && o.parent)
				o.parent.removeChild(o);
		}
		
		count = Layer.STAGE_FG_LAYER.numChildren - 1;
		for (i = count; i >= 0; --i) 
		{
			o = Layer.STAGE_FG_LAYER.getChildAt(i);
			if (o && o.parent)
				o.parent.removeChild(o);
		}
	}
	
	//-----------------------------event--------------------------------
	/////////////////////////////////////////////////////////////////////
	/////////////////////////////////////////////////////////////////////
	/////////////////////////////////////////////////////////////////////
	
	private function onKeyDownHandler(event:KeyboardEvent):void 
	{
		if (event.ctrlKey && event.keyCode == Keyboard.D)
		{
			//copy
			this.copy(this.curSelectedSpt);
		}
		else if (event.ctrlKey && event.keyCode == Keyboard.UP)
		{
			this.setSptDepth(this.curSelectedSpt, true);
		}
		else if (event.ctrlKey && event.keyCode == Keyboard.DOWN)
		{
			this.setSptDepth(this.curSelectedSpt, false);
		}
		else if (event.keyCode == Keyboard.SPACE)
		{
			this.isSpaceKey = true;
			Mouse.cursor = MouseCursor.HAND;
		}
	}
	
	private function onKeyUpHandler(event:KeyboardEvent):void 
	{
		if (event.keyCode == Keyboard.DELETE)
		{
			if (this.curSelectedSpt is SurfaceComponet)
				this.sendNotification(Message.DELETE);
			if (this.editUI) this.editUI.selectSpt(null);
			this.removeSpt(this.curSelectedSpt);
			this.curSelectedSpt = null;
		}
		else if (event.keyCode == Keyboard.SPACE)
		{
			this.isSpaceKey = false;
			Mouse.cursor = MouseCursor.ARROW;
		}
	}
	
	private function exportBtnClickHandler(event:MouseEvent):void 
	{
		
	}
	
	private function importBtnClickHandler(event:MouseEvent):void 
	{
		this.selectImage();
	}
	
	private function clearBtnClickHandler(event:MouseEvent):void 
	{
		this.removeAll();
		this.sendNotification(Message.DELETE);
		if (this.editUI) this.editUI.selectSpt(null);
		this.curSelectedSpt = null;
	}
	
	private function selectImageFileHandler(event:Event):void
	{
		this.imageFile.addEventListener(Event.COMPLETE, imageFileLoadComplete);
		this.imageFile.load();
	}
	
	private function imageFileLoadComplete(event:Event):void
	{
		this.imageFile.removeEventListener(Event.COMPLETE, imageFileLoadComplete);
		var image:Image = new Image();
		image.addEventListener(ErrorEvent.ERROR, loadImageErrorHandler);
		image.addEventListener(MouseEvent.MOUSE_DOWN, sptOnMouseDownHandler);
		image.loadBytes(this.imageFile.data);
		image.resName = this.imageFile.name;
		image.pathName = this.imageFile.nativePath;
		Layer.STAGE_BG_LAYER.addChild(image);
	}
	
	private function loadImageErrorHandler(event:ErrorEvent):void
	{
		Alert.show("错误", "图片不存在");
	}
	
	private function sptOnMouseDownHandler(event:MouseEvent):void 
	{
		Layer.STAGE.addEventListener(MouseEvent.MOUSE_UP, stageMouseUpHandler);
		Layer.STAGE.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		this.select(event.currentTarget as Image);
		this.curSelectedSpt.startDrag();
	}
	
	private function onMouseDownHandler(event:MouseEvent):void 
	{
		trace("onMouseDownHandler");
		this.select(null);
	}
		
	private function onStageMouseDownHandler(event:MouseEvent):void 
	{
		if (this.isSpaceKey)
			Layer.STAGE_LAYER.startDrag();
	}
		
	private function onStageMouseUpHandler(event:MouseEvent):void 
	{
		Layer.STAGE_LAYER.stopDrag();
	}
	
	private function stageMouseUpHandler(event:MouseEvent):void 
	{
		Layer.STAGE.removeEventListener(MouseEvent.MOUSE_UP, stageMouseUpHandler);
		Layer.STAGE.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
		if (this.curSelectedSpt)
			this.curSelectedSpt.stopDrag();
	}
	
	private function vSliderChangeHandler(event:Event):void 
	{
		if (this.editUI)
			this.editUI.scaleStage(this.editUI.vSlider.value / 100);
	}
	
	private function posYValueTxtfocusOutHandler(event:FocusEvent):void 
	{
		this.setCurSptProp();
	}
	
	private function posXValueTxtfocusOutHandler(event:FocusEvent):void 
	{
		this.setCurSptProp();
	}
	
	private function enterFrameHandler(event:Event):void 
	{
		if (this.editUI)
			this.editUI.selectSpt(this.curSelectedSpt);
	}	
}
}