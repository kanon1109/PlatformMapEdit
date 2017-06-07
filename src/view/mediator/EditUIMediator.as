package view.mediator 
{
import componets.Alert;
import componets.Image;
import flash.display.Sprite;
import flash.events.ErrorEvent;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.filesystem.File;
import flash.net.FileFilter;
import flash.ui.Keyboard;
import message.Message;
import org.puremvc.as3.interfaces.INotification;
import org.puremvc.as3.patterns.mediator.Mediator;
import utils.AdvanceColorUtil;
import view.ui.EditUI;
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
	public function EditUIMediator() 
	{
		super(NAME);
	}
	
	override public function listNotificationInterests():Array 
	{
		var arr:Array = [];
		arr.push(Message.START);
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
			default:
		}
	}
	
	/**
	 * 初始化编辑器UI
	 */
	private function initEditUI():void
	{
		this.editUI = new EditUI();
		Layer.UI.addChild(this.editUI);
	}
	
	/**
	 * 初始化事件
	 */	
	private function initEvent():void 
	{
		this.editUI.importBtn.addEventListener(MouseEvent.CLICK, importBtnClickHandler);
		this.editUI.exportBtn.addEventListener(MouseEvent.CLICK, exportBtnClickHandler);
		Layer.STAGE.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDownHandler);
		Layer.STAGE.addEventListener(KeyboardEvent.KEY_UP, onKeyUpHandler);
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
			Layer.UI_STAGE.addChild(image);
			this.drawSelectedBound(image);
			this.curSelectedSpt = image;
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
	}
	
	private function onKeyUpHandler(event:KeyboardEvent):void 
	{
		if (event.keyCode == Keyboard.DELETE)
		{
			this.removeSpt(this.curSelectedSpt);
			this.curSelectedSpt = null;
		}
	}
	
	private function exportBtnClickHandler(event:MouseEvent):void 
	{
		
	}
	
	private function importBtnClickHandler(event:MouseEvent):void 
	{
		this.selectImage();
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
		image.x = Layer.STAGE.width / 2;
		image.y = Layer.STAGE.height / 2;
		Layer.UI_STAGE.addChild(image);
	}
	
	private function loadImageErrorHandler(event:ErrorEvent):void
	{
		Alert.show("错误", "图片不存在");
	}
	
	private function sptOnMouseDownHandler(event:MouseEvent):void 
	{
		Layer.STAGE.addEventListener(MouseEvent.MOUSE_UP, stageMouseUpHandler);
		Layer.STAGE.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		this.drawSelectedBound(event.currentTarget as Image);
		this.curSelectedSpt = event.currentTarget as Image;
		this.curSelectedSpt.startDrag();
	}
	
	private function stageMouseUpHandler(event:MouseEvent):void 
	{
		Layer.STAGE.removeEventListener(MouseEvent.MOUSE_UP, stageMouseUpHandler);
		Layer.STAGE.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
		if (this.curSelectedSpt)
			this.curSelectedSpt.stopDrag();
	}
	
	private function enterFrameHandler(event:Event):void 
	{
		//if (this.curSelectedSpt)
		//{
			//this.curSelectedSpt.x = Layer.STAGE.mouseX;
			//this.curSelectedSpt.y = Layer.STAGE.mouseY;
		//}
	}
}
}