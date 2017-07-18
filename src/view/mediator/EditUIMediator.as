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
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;
import flash.geom.Point;
import flash.net.FileFilter;
import flash.ui.Keyboard;
import flash.ui.Mouse;
import flash.ui.MouseCursor;
import message.Message;
import model.proxy.HistoryProxy;
import model.vo.HistoryVo;
import org.puremvc.as3.interfaces.INotification;
import org.puremvc.as3.patterns.mediator.Mediator;
import utils.AdvanceColorUtil;
import view.ui.EditUI;
import view.ui.SurfaceComponet;
/**
 * ...编辑器中介
 * 增加 [快捷保存 ctrl + s]
 * 增加 [点击左右按钮移动]
 * 增加 [放大功能]
 * 修改 [点击face 出现4个点]
 * 修改 [最小高度]
 * 增加 [高度和宽度设置]
 * 增加	[重置功能]
 * 增加	[body]
 * 增加	[重置锚点功能]
 * 增加 [保存图片]
 * 增加 更新人物
 * 增加 [自动吸附功能]
 * 增加 左右跳跃 向下depth搜索
 * 增加 保存地图元素
 * bug  [左边连续三个倾斜的face向上移动掉下]
 * bug  [左边边界向左下移动，下落时掉下]
 * bug  [直接按快捷键保存崩溃]
 * bug  [保存图片的绝对路径会有路径问题]
 * @author Kanon
 */
public class EditUIMediator extends Mediator 
{
	public static var NAME:String = "EditUIMediator";
	private var editUI:EditUI;
	private var imageFile:File;
	private var dataFile:File;
	private var saveFile:File;
	private var imageFilter:FileFilter;
	private var dataFilter:FileFilter;
	private var curSelectedSpt:Sprite;
	private var isSpaceKey:Boolean;
	private var saveDataStr:String;
	private var historyProxy:HistoryProxy;
	private var isMouseDown:Boolean;
	private var curHistoryVo:HistoryVo;
	public function EditUIMediator() 
	{
		super(NAME);
		this.historyProxy = this.facade.retrieveProxy(HistoryProxy.NAME) as HistoryProxy;
	}
	
	override public function listNotificationInterests():Array 
	{
		var arr:Array = [];
		arr.push(Message.START);
		arr.push(Message.FACE_MOUSE_DOWN);
		arr.push(Message.FACE_MOUSE_UP);
		return arr;
	}
	
	override public function handleNotification(notification:INotification):void 
	{
		switch (notification.getName()) 
		{
			case Message.START:
				this.initEditUI();
				this.initEvent();
				this.initFile();
				break;
			case Message.FACE_MOUSE_DOWN:
					//拖动face
					this.select(notification.getBody() as Sprite);	
					this.isMouseDown = true;
					Layer.STAGE.addEventListener(MouseEvent.MOUSE_UP, stageMouseUpHandler);
					Layer.STAGE.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
				break;
			case Message.FACE_MOUSE_UP:
					this.isMouseDown = false;
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
		this.editUI.saveBtn.addEventListener(MouseEvent.CLICK, saveBtnClickHandler);
		this.editUI.loadBtn.addEventListener(MouseEvent.CLICK, loadBtnClickHandler);
		this.editUI.clearBtn.addEventListener(MouseEvent.CLICK, clearBtnClickHandler);
		this.editUI.runBtn.addEventListener(MouseEvent.CLICK, runBtnClickHandler);
		this.editUI.allAnchorResetBtn.addEventListener(MouseEvent.CLICK, allAnchorResetBtnClickHandler);
		this.editUI.vSlider.addEventListener(Event.CHANGE, vSliderChangeHandler);
		this.editUI.posXValueTxt.addEventListener(FocusEvent.FOCUS_OUT, txtFocusOutHandler);
		this.editUI.posYValueTxt.addEventListener(FocusEvent.FOCUS_OUT, txtFocusOutHandler);
		this.editUI.stagePanel.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownHandler);
		Layer.STAGE.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDownHandler);
		Layer.STAGE.addEventListener(MouseEvent.MOUSE_DOWN, onStageMouseDownHandler);
		Layer.STAGE.addEventListener(MouseEvent.MOUSE_UP, onStageMouseUpHandler);
		Layer.STAGE.addEventListener(KeyboardEvent.KEY_UP, onKeyUpHandler);
		this.sendNotification(Message.INIT, this.editUI);
	}
	
	/**
	 * 初始化file
	 */
	private function initFile():void 
	{
		trace("File.desktopDirectory", File.desktopDirectory);
		this.saveFile = File.desktopDirectory;
		this.saveFile.addEventListener(Event.SELECT, selectSaveFileHandler);
		this.saveFile.url += ".json"; //确认后缀名
		
		this.imageFilter = new FileFilter("Image", "*.jpg;*.png");
		this.imageFile = new File();
		this.imageFile.addEventListener(Event.SELECT, selectImageFileHandler);
		
		this.dataFilter = new FileFilter("data", "*.json");
		this.dataFile = new File();
		this.dataFile.addEventListener(Event.SELECT, selectDataFileHandler);
	}
	
	/**
	 * 选择图片
	 */
	private function selectImage():void
	{
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
	 * @param	spt	显示对象
	 */
	private function drawSelectedBound(spt:Sprite):void
	{
		this.resetColor(this.curSelectedSpt)
		if (spt) spt.transform.colorTransform = AdvanceColorUtil.setRGBMixTransform(0xFF, 0xCC, 0xFF, 40);
	}
	
	/**
	 * 重置颜色
	 * @param	spt	显示对象
	 */
	private function resetColor(spt:Sprite):void
	{
		if (spt) spt.transform.colorTransform = AdvanceColorUtil.setColorInitialize();
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
	 * 设置最高或最低深度
	 * @param	spt		显示对象
	 * @param	flag	最高或最低深度
	 */
	private function setSptMaxDepth(spt:Sprite, flag:Boolean):void
	{
		if (!spt || !spt.parent) return;
		var index:int = spt.parent.getChildIndex(spt);
		if (flag) index = spt.parent.numChildren - 1;
		else index = 0;
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
			var hVo:HistoryVo = this.historyProxy.saveHistory(this.curSelectedSpt, HistoryVo.PROP);
			var pos:Point = this.editUI.getPosTxtValue();
			this.curSelectedSpt.x = pos.x;
			this.curSelectedSpt.y = pos.y;
			if (hVo)
				hVo.nextVo = this.historyProxy.saveNextHistory(this.curSelectedSpt);
		}
	}
	
	/**
	 * 选中某物
	 * @param	spt	某物
	 */
	private function select(spt:Sprite):void
	{
		if (this.curSelectedSpt && this.curSelectedSpt is SurfaceComponet)
			SurfaceComponet(this.curSelectedSpt).showPoint(false);
		this.drawSelectedBound(spt);
		this.curSelectedSpt = spt;
		if (this.curSelectedSpt && this.curSelectedSpt is SurfaceComponet)
			SurfaceComponet(this.curSelectedSpt).showPoint(true);
		if (this.editUI) 
			this.editUI.selectSpt(spt);
	}
	
	/**
	 * 上一步
	 */
	private function prevHistory():void
	{
		var hVo:HistoryVo = this.historyProxy.prevHistory();
		if (hVo)
		{
			var faceComponet:SurfaceComponet;
			var image:Image;
			var spt:Sprite;
			var count:int;
			var i:int;
			if (hVo.type == HistoryVo.DELETE)
			{
				//上一步删除
				if (hVo.target is SurfaceComponet)
				{
					faceComponet = hVo.target as SurfaceComponet;
					faceComponet.showPoint(false);
					this.resetColor(faceComponet);
					faceComponet.x = hVo.x;
					faceComponet.y = hVo.y;
					faceComponet.name = hVo.name;
					Layer.TERRAIN_LAYER.addChildAt(faceComponet, hVo.childIndex);
					this.sendNotification(Message.COPY, faceComponet);
				}
				else if (hVo.target is Image)
				{
					image = hVo.target as Image;
					image.x = hVo.x;
					image.y = hVo.y;
					image.name = hVo.name;
					this.resetColor(image);
					image.addEventListener(MouseEvent.MOUSE_DOWN, sptOnMouseDownHandler);
					Layer.STAGE_BG_LAYER.addChildAt(image, hVo.childIndex);
				}
			}
			else if (hVo.type == HistoryVo.COPY || 
					 hVo.type == HistoryVo.CREATE)
			{	
				if (hVo.target is SurfaceComponet)
				{
					faceComponet = hVo.target as SurfaceComponet;
					this.sendNotification(Message.DELETE, faceComponet);
					this.removeSpt(faceComponet);
				}
				else if (hVo.target is Image)
				{
					image = hVo.target as Image;
					this.removeSpt(image);
				}
				spt = hVo.target as Sprite;
				if (this.curSelectedSpt == spt)
				{
					this.select(null);
					this.curSelectedSpt = null;
				}
			}
			else if (hVo.type == HistoryVo.PROP)
			{
				this.select(this.setHistoryVo(hVo));
			}
			else if (hVo.type == HistoryVo.CLEAR)
			{
				count =	hVo.displayList[0].length;
				for (i = 0; i < count; i++) 
				{
					spt = hVo.displayList[0][i];
					Layer.STAGE_BG_LAYER.addChild(spt);
				}
		
				count =	hVo.displayList[1].length;
				for (i = 0; i < count; i++) 
				{
					spt = hVo.displayList[1][i];
					Layer.TERRAIN_LAYER.addChild(spt);
				}
				
				count =	hVo.displayList[2].length;
				for (i = 0; i < count; i++) 
				{
					spt = hVo.displayList[2][i];
					Layer.STAGE_FG_LAYER.addChild(spt);
				}
			}
			else if (hVo.type == HistoryVo.ALL_PROP)
			{
				var historyVo:HistoryVo;
				count =	hVo.historyVoList[0].length;
				for (i = 0; i < count; i++) 
				{
					historyVo = hVo.historyVoList[0][i];
					this.setHistoryVo(historyVo);
				}
		
				count =	hVo.historyVoList[1].length;
				for (i = 0; i < count; i++) 
				{
					historyVo = hVo.historyVoList[1][i];
					this.setHistoryVo(historyVo);
				}
				
				count =	hVo.historyVoList[2].length;
				for (i = 0; i < count; i++) 
				{
					historyVo = hVo.historyVoList[2][i];
					this.setHistoryVo(historyVo);
				}
			}
		}
	}
	
	/**
	 * 恢复撤销
	 */
	private function nextHistory():void
	{
		var hVo:HistoryVo = this.historyProxy.nextHistory();
		if (hVo)
		{
			var faceComponet:SurfaceComponet;
			var spt:Sprite;
			var nextVo:HistoryVo;
			if (hVo.type == HistoryVo.DELETE)
			{
				if (hVo.target is SurfaceComponet)
				{
					faceComponet = hVo.target as SurfaceComponet;
					this.sendNotification(Message.DELETE, faceComponet);
					this.removeSpt(faceComponet);
				}
				else if (hVo.target is Image)
				{
					var image:Image = hVo.target as Image;
					this.removeSpt(image);
				}
			}
			else if (hVo.type == HistoryVo.COPY || 
					 hVo.type == HistoryVo.CREATE)
			{
				spt = hVo.target as Sprite;
				this.resetColor(spt);
				if (hVo.target is SurfaceComponet)
				{
					this.sendNotification(Message.COPY, spt);
					Layer.TERRAIN_LAYER.addChild(spt);
				}
				else if (hVo.target is Image)
				{
					spt.addEventListener(MouseEvent.MOUSE_DOWN, sptOnMouseDownHandler);
					Layer.STAGE_BG_LAYER.addChild(spt); 
				}
			}
			else if (hVo.type == HistoryVo.PROP)
			{
				nextVo = hVo.nextVo;
				this.select(this.setHistoryVo(nextVo));
			}
			else if (hVo.type == HistoryVo.CLEAR)
			{
				this.removeAll();
			}
			else  if (hVo.type == HistoryVo.ALL_PROP)
			{
				nextVo = hVo.nextVo;
				var historyVo:HistoryVo;
				var count:int =	nextVo.historyVoList[0].length;
				for (var i:int = 0; i < count; i++) 
				{
					historyVo = nextVo.historyVoList[0][i];
					this.setHistoryVo(historyVo);
				}
		
				count =	nextVo.historyVoList[1].length;
				for (i = 0; i < count; i++) 
				{
					historyVo = nextVo.historyVoList[1][i];
					this.setHistoryVo(historyVo);
				}
				
				count =	nextVo.historyVoList[2].length;
				for (i = 0; i < count; i++) 
				{
					historyVo = nextVo.historyVoList[2][i];
					this.setHistoryVo(historyVo);
				}
			}
		}
	}
	
	
	private function setHistoryVo(hVo:HistoryVo):Sprite
	{
		if (!hVo) return null;
		var spt:Sprite = hVo.target as Sprite;
		spt.parent.setChildIndex(spt, hVo.childIndex);
		spt.x = hVo.x;
		spt.y = hVo.y;
		if (hVo.target is SurfaceComponet)
		{
			var face:SurfaceComponet = hVo.target as SurfaceComponet;
			face.depth = hVo.depth;
			face.upBlock = hVo.upBlock;
			face.downBlock = hVo.downBlock;
			face.leftBlock = hVo.leftBlock;
			face.rightBlock = hVo.rightBlock;
			face.leftH = hVo.leftH;
			face.rightH = hVo.rightH;
			face.upLeftPoint.x = hVo.upLeftPoint.x;
			face.upLeftPoint.y = hVo.upLeftPoint.y;
			
			face.upRightPoint.x = hVo.upRightPoint.x;
			face.upRightPoint.y = hVo.upRightPoint.y;
			
			face.downLeftPoint.x = hVo.downLeftPoint.x;
			face.downLeftPoint.y = hVo.downLeftPoint.y;
			
			face.downRightPoint.x = hVo.downRightPoint.x;
			face.downRightPoint.y = hVo.downRightPoint.y;
			
			face.showPoint(false);
			
			face.draw();
		}
		spt.name = hVo.name;
		return spt;
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
	
	/**
	 * 保存
	 */
	private function save():void
	{
		var arr:Array = [];
		var count:int = Layer.TERRAIN_LAYER.numChildren;
		var node:Object;
		var img:Image;
		node = {};
		node.type = "stage";
		var stageX:Number = Layer.STAGE_LAYER.x;
		var stageY:Number = Layer.STAGE_LAYER.y;
		var stageScale:Number = Layer.STAGE_LAYER.scaleX;
		node.stageX = stageX;
		node.stageY = stageY;
		node.stageScale = stageScale;
		arr.push(node);
		for (var i:int = 0; i < count; ++i) 
		{
			node = { };
			var sc:SurfaceComponet = Layer.TERRAIN_LAYER.getChildAt(i) as SurfaceComponet;
			var pos:Point = new Point(sc.x + this.editUI.stageWidth / 2, sc.y + this.editUI.stageHeight / 2);
			node.name = sc.name;
			node.x = pos.x;
			node.y = pos.y;
			node.depth = sc.depth;
			node.upLeftX = sc.upLeftPoint.x;
			node.downLeftX = sc.downLeftPoint.x;
			node.upRightX = sc.upRightPoint.x;
			node.downRightX = sc.downRightPoint.x;
			node.upY = sc.upLeftPoint.y;
			node.downY = sc.downLeftPoint.y;
			node.leftBlock = sc.leftBlock;
			node.rightBlock = sc.rightBlock;
			node.upBlock = sc.upBlock;
			node.downBlock = sc.downBlock;
			node.leftH = sc.leftH;
			node.rightH = sc.rightH;
			node.leftRestrict = sc.leftRestrict;
			node.rightRestrict = sc.rightRestrict;
			node.type = "face";
			arr.push(node);
		}
		
		count = Layer.STAGE_BG_LAYER.numChildren;
		for (i = 0; i < count; ++i) 
		{
			node = { };
			img = Layer.STAGE_BG_LAYER.getChildAt(i) as Image;
			node.name = img.name;
			node.resName = img.resName;
			node.pathName = img.pathName;
			node.rotation = img.rotation;
			node.type = "bg";
			node.depth = i;
			node.x = img.x;
			node.y = img.y;
			node.scaleX = img.scaleX;
			node.scaleY = img.scaleY;
			arr.push(node);
		}
		
		count = Layer.STAGE_FG_LAYER.numChildren;
		for (i = 0; i < count; ++i) 
		{
			node = { };
			img = Layer.STAGE_FG_LAYER.getChildAt(i) as Image;
			node.name = img.name;
			node.resName = img.resName;
			node.pathName = img.pathName;
			node.rotation = img.rotation;
			node.type = "fg";
			node.depth = i;
			node.x = img.x;
			node.y = img.y;
			node.scaleX = img.scaleX;
			node.scaleY = img.scaleY;
			arr.push(node);
		}
		this.saveDataStr = JSON.stringify(arr);
	}
	
	/**
	 * 解析
	 * @param	dataStr		数据
	 */
	public function parsing(dataStr:String):void
	{
		var arr:Array = JSON.parse(dataStr) as Array;
		var num:int = arr.length;
		//arr.sortOn("depth", Array.NUMERIC);
		for (var i:int = 0; i < num; i++)
		{
			var data:Object = arr[i];
			if (data.type == "stage")
			{
				Layer.STAGE_LAYER.x = data.stageX;
				Layer.STAGE_LAYER.y = data.stageY;
				this.editUI.scaleStage(data.stageScale)
				this.editUI.vSlider.value = data.stageScale * 50;
			}
			else if (data.type == "face")
			{
				var sc:SurfaceComponet = new SurfaceComponet();
				sc.name = data.name;
				sc.x = data.x - this.editUI.stageWidth / 2;
				sc.y = data.y - this.editUI.stageHeight / 2;
				sc.depth = data.depth;
				sc.upLeftPoint.x = data.upLeftX;
				sc.downLeftPoint.x = data.downLeftX;
				sc.upRightPoint.x = data.upRightX;
				sc.downRightPoint.x = data.downRightX;
				sc.upLeftPoint.y = data.upY;
				sc.upRightPoint.y = data.upY;
				sc.downLeftPoint.y = data.downY;
				sc.downRightPoint.y = data.downY;
				sc.leftBlock = data.leftBlock;
				sc.rightBlock = data.rightBlock;
				sc.upBlock = data.upBlock;
				sc.downBlock = data.downBlock;
				sc.leftH = data.leftH;
				sc.rightH = data.rightH;
				sc.leftRestrict = data.leftRestrict;
				sc.rightRestrict = data.rightRestrict;
				sc.draw();
				Layer.TERRAIN_LAYER.addChild(sc);
				this.sendNotification(Message.COPY, sc);
			}
			else if (data.type == "bg" || 
					 data.type == "fg")
			{
				var image:Image = new Image();
				image.addEventListener(ErrorEvent.ERROR, loadImageErrorHandler);
				image.addEventListener(MouseEvent.MOUSE_DOWN, sptOnMouseDownHandler);
				image.name = data.name;
				image.resName = data.resName;
				image.pathName = data.pathName;
				image.x = data.x;
				image.y = data.y;
				image.scaleX = data.scaleX;
				image.scaleY = data.scaleY;
				image.rotation = data.rotation;
				image.load("res/" + data.resName);
				if (data.type == "bg") Layer.STAGE_BG_LAYER.addChildAt(image, data.depth);
				else if (data.type == "fg") Layer.STAGE_FG_LAYER.addChildAt(image, data.depth);
			}
		}
	}
		
	private function selectData():void
	{
		this.dataFile.browse([this.dataFilter]);
	}
	
	//-----------------------------event--------------------------------
	/////////////////////////////////////////////////////////////////////
	/////////////////////////////////////////////////////////////////////
	/////////////////////////////////////////////////////////////////////
	
	private function onKeyDownHandler(event:KeyboardEvent):void 
	{
		trace("this.isMouseDown", this.isMouseDown);
		if (this.isMouseDown) return;
		var hVo:HistoryVo;
		if (event.ctrlKey && event.keyCode == Keyboard.D)
		{
			//copy
			this.copy(this.curSelectedSpt);
			this.historyProxy.saveHistory(this.curSelectedSpt, HistoryVo.COPY);
		}
		else if (event.ctrlKey && !event.shiftKey && event.keyCode == Keyboard.UP)
		{
			hVo = this.historyProxy.saveHistory(this.curSelectedSpt, HistoryVo.PROP);
			this.setSptDepth(this.curSelectedSpt, true);
			if (hVo)
				hVo.nextVo = this.historyProxy.saveNextHistory(this.curSelectedSpt);
		}
		else if (event.ctrlKey && !event.shiftKey && event.keyCode == Keyboard.DOWN)
		{
			hVo = this.historyProxy.saveHistory(this.curSelectedSpt, HistoryVo.PROP);
			this.setSptDepth(this.curSelectedSpt, false);
			if (hVo)
				hVo.nextVo = this.historyProxy.saveNextHistory(this.curSelectedSpt);
		}
		else if (event.ctrlKey && event.shiftKey && event.keyCode == Keyboard.UP)
		{
			hVo = this.historyProxy.saveHistory(this.curSelectedSpt, HistoryVo.PROP);
			this.setSptMaxDepth(this.curSelectedSpt, true);
			if (hVo)
				hVo.nextVo = this.historyProxy.saveNextHistory(this.curSelectedSpt);
		}
		else if (event.ctrlKey && event.shiftKey && event.keyCode == Keyboard.DOWN)
		{
			hVo = this.historyProxy.saveHistory(this.curSelectedSpt, HistoryVo.PROP);
			this.setSptMaxDepth(this.curSelectedSpt, false);
			if (hVo)
				hVo.nextVo = this.historyProxy.saveNextHistory(this.curSelectedSpt);
		}
		else if (event.keyCode == Keyboard.LEFT)
		{
			hVo = this.historyProxy.saveHistory(this.curSelectedSpt, HistoryVo.PROP);
			if (this.curSelectedSpt) 
			{
				if (event.shiftKey)
					this.curSelectedSpt.x -= 10;
				else
					this.curSelectedSpt.x--;
				if (this.editUI)
					this.editUI.selectSpt(this.curSelectedSpt);
			}
			if (hVo)
				hVo.nextVo = this.historyProxy.saveNextHistory(this.curSelectedSpt);
		}
		else if (event.keyCode == Keyboard.RIGHT)
		{
			hVo = this.historyProxy.saveHistory(this.curSelectedSpt, HistoryVo.PROP);
			if (this.curSelectedSpt) 
			{
				if (event.shiftKey)
					this.curSelectedSpt.x += 10;
				else
					this.curSelectedSpt.x++;
				if (this.editUI)
					this.editUI.selectSpt(this.curSelectedSpt);
			}
			if (hVo)
				hVo.nextVo = this.historyProxy.saveNextHistory(this.curSelectedSpt);
		}
		else if (event.keyCode == Keyboard.UP)
		{
			hVo = this.historyProxy.saveHistory(this.curSelectedSpt, HistoryVo.PROP);
			if (this.curSelectedSpt) 
			{
				if (event.shiftKey)
					this.curSelectedSpt.y -= 10;
				else
					this.curSelectedSpt.y--;
				if (this.editUI)
					this.editUI.selectSpt(this.curSelectedSpt);
			}	
			if (hVo)
				hVo.nextVo = this.historyProxy.saveNextHistory(this.curSelectedSpt);
		}
		else if (event.keyCode == Keyboard.DOWN)
		{
			hVo = this.historyProxy.saveHistory(this.curSelectedSpt, HistoryVo.PROP);
			if (this.curSelectedSpt) 
			{
				if (event.shiftKey)
					this.curSelectedSpt.y += 10;
				else
					this.curSelectedSpt.y++;
				if (this.editUI)
					this.editUI.selectSpt(this.curSelectedSpt);
			}
			if (hVo)
				hVo.nextVo = this.historyProxy.saveNextHistory(this.curSelectedSpt);
		}
		else if (event.keyCode == Keyboard.SPACE)
		{
			if (!this.editUI.isRunMode)
			{
				this.isSpaceKey = true;
				Mouse.cursor = MouseCursor.HAND;
			}
		}
		else if (event.ctrlKey && event.keyCode == Keyboard.S)
		{
			this.save();
			var stream:FileStream = new FileStream();
			stream.open(this.saveFile, FileMode.WRITE);
			stream.writeUTFBytes(this.saveDataStr);
			stream.close();
			Alert.show("", "保存成功");
			//this.saveFile.save(this.saveDataStr);
		}
		else if (event.ctrlKey && event.keyCode == Keyboard.Z)
		{
			this.prevHistory();
		}
		else if (event.ctrlKey && event.keyCode == Keyboard.Y)
		{
			this.nextHistory();
		}
	}
	
	private function onKeyUpHandler(event:KeyboardEvent):void 
	{
		if (this.isMouseDown) return;
		if (event.keyCode == Keyboard.DELETE)
		{
			this.historyProxy.saveHistory(this.curSelectedSpt, HistoryVo.DELETE);
			if (this.curSelectedSpt is SurfaceComponet)
				this.sendNotification(Message.DELETE, this.curSelectedSpt);
			if (this.editUI) this.editUI.selectSpt(null);
			this.removeSpt(this.curSelectedSpt);
			this.curSelectedSpt = null;
		}
		else if (event.keyCode == Keyboard.SPACE)
		{
			if (!this.editUI.isRunMode)
			{
				this.isSpaceKey = false;
				Mouse.cursor = MouseCursor.ARROW;
			}
		}
	}
	
	private function importBtnClickHandler(event:MouseEvent):void 
	{
		this.selectImage();
	}
	
	private function clearBtnClickHandler(event:MouseEvent):void 
	{
		this.historyProxy.saveAllDisplayHistory();
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
		
		this.historyProxy.saveHistory(image, HistoryVo.CREATE);
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
		this.curHistoryVo = this.historyProxy.saveHistory(this.curSelectedSpt, HistoryVo.PROP);
		this.curSelectedSpt.startDrag();
		this.isMouseDown = true;
	}
	
	private function onMouseDownHandler(event:MouseEvent):void 
	{
		this.select(null);
	}
		
	private function onStageMouseDownHandler(event:MouseEvent):void 
	{
		if (this.isSpaceKey)
		{
			if(!this.editUI.isRunMode)
				Layer.STAGE_LAYER.startDrag();
		}
	}
		
	private function onStageMouseUpHandler(event:MouseEvent):void 
	{
		if(!this.editUI.isRunMode)
			Layer.STAGE_LAYER.stopDrag();
	}
	
	private function stageMouseUpHandler(event:MouseEvent):void 
	{
		Layer.STAGE.removeEventListener(MouseEvent.MOUSE_UP, stageMouseUpHandler);
		Layer.STAGE.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
		if (this.curSelectedSpt)
			this.curSelectedSpt.stopDrag();
		this.isMouseDown = false;
		if (this.curHistoryVo)
			this.curHistoryVo.nextVo = this.historyProxy.saveNextHistory(this.curSelectedSpt);
	}
	
	private function vSliderChangeHandler(event:Event):void 
	{
		if (this.editUI)
			this.editUI.scaleStage(this.editUI.vSlider.value / 50);
	}
	
	private function txtFocusOutHandler(event:FocusEvent):void 
	{
		this.setCurSptProp();
	}
	
	private function saveBtnClickHandler(event:MouseEvent):void 
	{
		this.save();
		this.saveFile.browseForSave("保存数据");
	}
		
	private function selectDataFileHandler(event:Event):void
	{
		this.dataFile.addEventListener(Event.COMPLETE, dataFileLoadComplete);
		this.dataFile.load();
	}
	
	private function dataFileLoadComplete(event:Event):void
	{
		var fileStream:FileStream = new FileStream();
		fileStream.open(this.dataFile, FileMode.READ);
		var dataStr:String = fileStream.readUTFBytes(fileStream.bytesAvailable);
		this.parsing(dataStr);
		this.saveFile.url = this.dataFile.url;
	}
		
	private function loadBtnClickHandler(event:MouseEvent):void 
	{
		this.selectData();
	}
	
	private function selectSaveFileHandler(event:Event):void
	{
		var file:File = event.currentTarget as File;
		var stream:FileStream = new FileStream();
		stream.open(file, FileMode.WRITE);
		stream.writeUTFBytes(this.saveDataStr);
		stream.close();
		Alert.show("", "保存成功");
	}
	
	private function runBtnClickHandler(event:MouseEvent):void 
	{
		//运行
		if (this.editUI)
		{
			Layer.RUN_LAYER.x = Layer.STAGE_LAYER.x;
			Layer.RUN_LAYER.y = Layer.STAGE_LAYER.y;
			if (!this.editUI.isRunMode)
				this.editUI.setRunMode(true);
			else
				this.editUI.setRunMode(false);
			this.sendNotification(Message.RUN, this.editUI.isRunMode);
		}
	}
	
	private function allAnchorResetBtnClickHandler(e:MouseEvent):void 
	{
		var hVo:HistoryVo = this.historyProxy.saveAllDisplayProp(false);
		var count:int = Layer.TERRAIN_LAYER.numChildren;
		for (var i:int = 0; i < count; ++i) 
		{
			var face:SurfaceComponet = Layer.TERRAIN_LAYER.getChildAt(i) as SurfaceComponet;
			face.anchorReset();
		}
		hVo.nextVo = this.historyProxy.saveAllDisplayProp(true);
	}
	
	private function enterFrameHandler(event:Event):void 
	{
		if (this.editUI)
			this.editUI.selectSpt(this.curSelectedSpt);
	}	
}
}