package view.mediator 
{
import com.bit101.components.InputText;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.FocusEvent;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.ui.Keyboard;
import message.Message;
import model.proxy.HistoryProxy;
import model.vo.HistoryVo;
import org.puremvc.as3.interfaces.INotification;
import org.puremvc.as3.patterns.mediator.Mediator;
import view.ui.EditUI;
import view.ui.SurfaceComponet;
import view.ui.SurfaceComponetsPanel;
/**
 * ...面组件面板中介
 * @author ...Kanon
 */
public class SurfaceComponetsPanelMediator extends Mediator 
{
	public static var NAME:String = "SurfaceComponetsPanelMediator";
	private var editUI:EditUI;
	private var faceComponetsPanel:SurfaceComponetsPanel;
	private var faceComponet:SurfaceComponet;
	private var curPtSpt:Sprite;
	private var isOnCtrlKey:Boolean;
	private var historyProxy:HistoryProxy;
	private var curHistoryVo:HistoryVo;
	public function SurfaceComponetsPanelMediator(mediatorName:String=null, viewComponent:Object=null) 
	{
		super(NAME);
		this.historyProxy = this.facade.retrieveProxy(HistoryProxy.NAME) as HistoryProxy;
	}
	
	override public function listNotificationInterests():Array 
	{
		var arr:Array = [];
		arr.push(Message.INIT);
		arr.push(Message.COPY);
		arr.push(Message.DELETE);
		return arr;
	}
	
	override public function handleNotification(notification:INotification):void 
	{
		switch (notification.getName()) 
		{
			case Message.INIT:
				this.editUI = notification.getBody() as EditUI;
				this.faceComponetsPanel = this.editUI.faceComponetsPanel;
				this.initEvent();
			break;
		case Message.DELETE:
				this.faceComponet = notification.getBody() as SurfaceComponet;
				if (this.faceComponet)
				{
					this.faceComponet.upLeftPoint.removeEventListener(MouseEvent.MOUSE_DOWN, ptMouseDownHandler);
					this.faceComponet.downLeftPoint.removeEventListener(MouseEvent.MOUSE_DOWN, ptMouseDownHandler);
					this.faceComponet.upRightPoint.removeEventListener(MouseEvent.MOUSE_DOWN, ptMouseDownHandler);
					this.faceComponet.downRightPoint.removeEventListener(MouseEvent.MOUSE_DOWN, ptMouseDownHandler);					
					this.faceComponet.removeEventListener(MouseEvent.MOUSE_DOWN, faceMouseDownHandler);
					this.faceComponet = null;
					Layer.STAGE.removeEventListener(MouseEvent.MOUSE_UP, stageMouseUpHandler);
					Layer.STAGE.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
					Layer.STAGE.removeEventListener(MouseEvent.MOUSE_UP, ptMouseUpHandler);
				}
			break;
			case Message.COPY:
				this.faceComponet = notification.getBody() as SurfaceComponet;
				this.faceComponet.addEventListener(MouseEvent.MOUSE_DOWN, faceMouseDownHandler);
				this.faceComponet.upLeftPoint.addEventListener(MouseEvent.MOUSE_DOWN, ptMouseDownHandler);
				this.faceComponet.downLeftPoint.addEventListener(MouseEvent.MOUSE_DOWN, ptMouseDownHandler);
				this.faceComponet.upRightPoint.addEventListener(MouseEvent.MOUSE_DOWN, ptMouseDownHandler);
				this.faceComponet.downRightPoint.addEventListener(MouseEvent.MOUSE_DOWN, ptMouseDownHandler);
				Layer.STAGE.addEventListener(MouseEvent.MOUSE_UP, stageMouseUpHandler);
			break;
		}
	}
	
	private function initEvent():void
	{
		this.editUI.upLeftXTxt.addEventListener(FocusEvent.FOCUS_OUT, txtFocusOutHandler);
		this.editUI.downLeftXTxt.addEventListener(FocusEvent.FOCUS_OUT, txtFocusOutHandler);
		this.editUI.upRightXTxt.addEventListener(FocusEvent.FOCUS_OUT, txtFocusOutHandler);
		this.editUI.downRightXTxt.addEventListener(FocusEvent.FOCUS_OUT, txtFocusOutHandler);
		this.editUI.upYTxt.addEventListener(FocusEvent.FOCUS_OUT, txtFocusOutHandler);
		this.editUI.downYTxt.addEventListener(FocusEvent.FOCUS_OUT, txtFocusOutHandler);
		this.editUI.leftRestrict.addEventListener(MouseEvent.CLICK, checkBoxHandler);
		this.editUI.rightRestrict.addEventListener(MouseEvent.CLICK, checkBoxHandler);
		this.editUI.leftBlock.addEventListener(MouseEvent.CLICK, checkBoxHandler);
		this.editUI.rightBlock.addEventListener(MouseEvent.CLICK, checkBoxHandler);
		this.editUI.upBlock.addEventListener(MouseEvent.CLICK, checkBoxHandler);
		this.editUI.downBlock.addEventListener(MouseEvent.CLICK, checkBoxHandler);
		
		this.editUI.leftHeightTxt.addEventListener(FocusEvent.FOCUS_OUT, txtFocusOutHandler);
		this.editUI.rightHeightTxt.addEventListener(FocusEvent.FOCUS_OUT, txtFocusOutHandler);
		this.editUI.depthTxt.addEventListener(FocusEvent.FOCUS_OUT, txtFocusOutHandler);
		this.editUI.nameTxt.addEventListener(FocusEvent.FOCUS_OUT, txtFocusOutHandler);
		this.editUI.widthTxt.addEventListener(FocusEvent.FOCUS_OUT, txtFocusOutHandler);
		this.editUI.heightTxt.addEventListener(FocusEvent.FOCUS_OUT, txtFocusOutHandler);
		this.editUI.resetBtn.addEventListener(MouseEvent.CLICK, resetBtnClickHandler);
		this.editUI.anchorResetBtn.addEventListener(MouseEvent.CLICK, anchorResetBtnClickHandler);
		this.editUI.flipXBtn.addEventListener(MouseEvent.CLICK, flipXBtnClickHandler);
		this.editUI.flipYBtn.addEventListener(MouseEvent.CLICK, flipYBtnClickHandler);
		
		this.faceComponetsPanel.rect.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownHandler);
		this.faceComponetsPanel.quad1.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownHandler);
		this.faceComponetsPanel.quad2.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownHandler);
		this.faceComponetsPanel.trapezoid1.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownHandler);
		this.faceComponetsPanel.trapezoid2.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownHandler);
		Layer.STAGE.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDownHandler);
		Layer.STAGE.addEventListener(KeyboardEvent.KEY_UP, onKeyUpHandler);
	}
	
	//纵向翻转整个surface属性
	private function flipYBtnClickHandler(event:MouseEvent):void 
	{
		if (this.faceComponet)
			this.faceComponet.flipY();
		this.editUI.selectSpt(this.faceComponet);
	}
	
	//横向翻转整个surface属性
	private function flipXBtnClickHandler(event:MouseEvent):void 
	{
		if (this.faceComponet)
			this.faceComponet.flipX();
		this.editUI.selectSpt(this.faceComponet);
	}
	
	private function anchorResetBtnClickHandler(event:MouseEvent):void 
	{
		var hVo:HistoryVo = this.historyProxy.saveHistory(this.faceComponet, HistoryVo.PROP);
		if (this.faceComponet) this.faceComponet.anchorReset();
		this.editUI.selectSpt(this.faceComponet);
		if (hVo)
			hVo.nextVo = this.historyProxy.saveNextHistory(this.faceComponet);
	}
	
	private function resetBtnClickHandler(event:MouseEvent):void 
	{
		var hVo:HistoryVo = this.historyProxy.saveHistory(this.faceComponet, HistoryVo.PROP);
		if (this.faceComponet) this.faceComponet.reset();
		this.editUI.selectSpt(this.faceComponet);
		if (hVo)
			hVo.nextVo = this.historyProxy.saveNextHistory(this.faceComponet);
	}
	
	private function onKeyUpHandler(event:KeyboardEvent):void 
	{
		if (event.keyCode == Keyboard.CONTROL)
			this.isOnCtrlKey = false;
	}
	
	private function onKeyDownHandler(event:KeyboardEvent):void 
	{
		if (event.keyCode == Keyboard.CONTROL)
			this.isOnCtrlKey = true;
	}
	
	private function checkBoxHandler(event:MouseEvent):void 
	{
		if (this.faceComponet)
		{
			this.faceComponet.leftRestrict = this.editUI.leftRestrict.selected;
			this.faceComponet.rightRestrict = this.editUI.rightRestrict.selected;
			this.faceComponet.leftBlock = this.editUI.leftBlock.selected;
			this.faceComponet.rightBlock = this.editUI.rightBlock.selected;
			if (this.faceComponet.leftBlock) this.faceComponet.leftH = 0;
			if (this.faceComponet.rightBlock) this.faceComponet.rightH = 0;
			
			this.editUI.leftHeightTxt.text = this.faceComponet.leftH.toString();
			this.editUI.rightHeightTxt.text = this.faceComponet.rightH.toString();
			
			this.faceComponet.upBlock = this.editUI.upBlock.selected;
			this.faceComponet.downBlock = this.editUI.downBlock.selected;
			this.faceComponet.draw();
		}
	}
	
	private function txtFocusOutHandler(event:FocusEvent):void 
	{
		if (this.faceComponet)
		{
			var hVo:HistoryVo = this.historyProxy.saveHistory(this.faceComponet, HistoryVo.PROP);
			var txt:InputText = event.currentTarget as InputText;
			var gap:int = 10;
			var upleftX:Number = Number(this.editUI.upLeftXTxt.text);
			var upRightX:Number = Number(this.editUI.upRightXTxt.text);
			var downleftX:Number = Number(this.editUI.downLeftXTxt.text);
			var downRightX:Number = Number(this.editUI.downRightXTxt.text);
			var upY:Number = Number(this.editUI.upYTxt.text);
			var downY:Number = Number(this.editUI.downYTxt.text);
			var width:Number = Number(this.editUI.widthTxt.text);
			var height:Number = Number(this.editUI.heightTxt.text);
			
			if (txt == this.editUI.upLeftXTxt)
			{
				if (upleftX > upRightX - gap)
					upleftX = upRightX - gap
			}
			else if (txt == this.editUI.upRightXTxt)
			{
				if (upRightX < upleftX + gap)
					upRightX = upleftX + gap
			}
			else if (txt == this.editUI.downLeftXTxt)
			{
				if (downleftX > downRightX - gap)
					downleftX = downRightX - gap
			}
			else if (txt == this.editUI.downRightXTxt)
			{
				if (downRightX < downleftX + gap)
					downRightX = downleftX + gap
			}
			else if (txt == this.editUI.upYTxt)
			{
				if (upY > downY - gap)
					upY = downY - gap
			}
			else if (txt == this.editUI.downYTxt)
			{
				if (downY < upY + gap)
					downY = upY + gap
			}
			
			this.editUI.upLeftXTxt.text = upleftX.toString();
			this.editUI.upRightXTxt.text = upRightX.toString();
			this.editUI.downLeftXTxt.text = downleftX.toString();
			this.editUI.downRightXTxt.text = downRightX.toString();
			this.editUI.upYTxt.text = upY.toString();
			this.editUI.downYTxt.text = downY.toString();
			
			this.faceComponet.upLeftPoint.x = Number(this.editUI.upLeftXTxt.text);
			this.faceComponet.upLeftPoint.y = Number(this.editUI.upYTxt.text);
			this.faceComponet.upRightPoint.x = Number(this.editUI.upRightXTxt.text);
			this.faceComponet.upRightPoint.y = Number(this.editUI.upYTxt.text);
			
			this.faceComponet.downLeftPoint.x = Number(this.editUI.downLeftXTxt.text);
			this.faceComponet.downLeftPoint.y = Number(this.editUI.downYTxt.text);
			this.faceComponet.downRightPoint.x = Number(this.editUI.downRightXTxt.text);
			this.faceComponet.downRightPoint.y = Number(this.editUI.downYTxt.text);
			
			this.faceComponet.leftH = Number(this.editUI.leftHeightTxt.text);
			this.faceComponet.rightH = Number(this.editUI.rightHeightTxt.text);
			this.faceComponet.depth = Number(this.editUI.depthTxt.text);
			this.faceComponet.name = this.editUI.nameTxt.text;
			
			var newUpRightX:Number;
			var newDownRightX:Number;
			var dis:Number = this.faceComponet.upRightPoint.x - this.faceComponet.downRightPoint.x;
			var leftX:Number = this.faceComponet.downLeftPoint.x;
			this.faceComponet.downLeftPoint.y = this.faceComponet.upLeftPoint.y + height;
			this.faceComponet.downRightPoint.y = this.faceComponet.downLeftPoint.y;
			if (this.faceComponet.upLeftPoint.x < this.faceComponet.downLeftPoint.x)
				leftX = this.faceComponet.upLeftPoint.x;
				
			if (this.faceComponet.upRightPoint.x > this.faceComponet.downRightPoint.x)
			{
				newUpRightX = leftX + width;
				newDownRightX = newUpRightX - dis;
				if (newDownRightX < this.faceComponet.downLeftPoint.x + 1)
				{
					newDownRightX = this.faceComponet.downLeftPoint.x + 1;
					newUpRightX += newDownRightX - (newUpRightX - dis);
				}
				this.faceComponet.upRightPoint.x = newUpRightX;
				this.faceComponet.downRightPoint.x = newDownRightX;
			}
			else
			{
				newDownRightX = leftX + width;
				newUpRightX = newDownRightX + dis;
				if (newUpRightX < this.faceComponet.upLeftPoint.x + 1)
				{
					newUpRightX = this.faceComponet.upLeftPoint.x + 1;
					newDownRightX += newUpRightX - (newDownRightX + dis);
				}
				
				this.faceComponet.downRightPoint.x = newDownRightX;
				this.faceComponet.upRightPoint.x = newUpRightX;
			}
			
			if (this.faceComponet.leftH > 0)
				this.editUI.leftBlock.selected = false;
			if (this.faceComponet.rightH > 0)
				this.editUI.rightBlock.selected = false;
			this.faceComponet.draw();
			if (hVo)
				hVo.nextVo = this.historyProxy.saveNextHistory(this.faceComponet);
		}
	}
	
	private function onMouseDownHandler(event:MouseEvent):void 
	{
		var componets:Sprite = event.currentTarget as Sprite;
		var face:SurfaceComponet = new SurfaceComponet();
		Layer.TOP_LAYER.addChild(face);
		switch (componets.name) 
		{
			case "rect":
				face.setShape(1);
				break;
			case "quad1":
				face.setShape(2);
				break;
			case "quad2":
				face.setShape(3);
				break;
			case "trapezoid1":
				face.setShape(4);
				break;
			case "trapezoid2":
				face.setShape(5);
				break;
		}
		this.faceComponet = face;
		this.faceComponet.startDrag();
		this.faceComponet.x = Layer.STAGE.mouseX - this.faceComponet.width / 2;
		this.faceComponet.y = Layer.STAGE.mouseY - this.faceComponet.height / 2;
		this.faceComponet.addEventListener(MouseEvent.MOUSE_DOWN, faceMouseDownHandler);
		this.faceComponet.upLeftPoint.addEventListener(MouseEvent.MOUSE_DOWN, ptMouseDownHandler);
		this.faceComponet.downLeftPoint.addEventListener(MouseEvent.MOUSE_DOWN, ptMouseDownHandler);
		this.faceComponet.upRightPoint.addEventListener(MouseEvent.MOUSE_DOWN, ptMouseDownHandler);
		this.faceComponet.downRightPoint.addEventListener(MouseEvent.MOUSE_DOWN, ptMouseDownHandler);
		Layer.STAGE.addEventListener(MouseEvent.MOUSE_UP, stageMouseUpHandler);
		//Layer.STAGE.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
	}
		
	private function ptMouseDownHandler(event:MouseEvent):void 
	{
		event.stopImmediatePropagation();
		this.curPtSpt = event.currentTarget as Sprite;
		this.faceComponet = this.curPtSpt.parent as SurfaceComponet;
		Layer.STAGE.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		Layer.STAGE.addEventListener(MouseEvent.MOUSE_UP, ptMouseUpHandler);
		this.sendNotification(Message.FACE_MOUSE_DOWN, this.faceComponet);
		this.curHistoryVo = this.historyProxy.saveHistory(this.faceComponet, HistoryVo.PROP);
	}
	
	private function ptMouseUpHandler(event:MouseEvent):void 
	{
		if (this.faceComponet && this.isOnCtrlKey) this.autoAbsorbFacePoint(this.faceComponet);
		this.curPtSpt = null;
		Layer.STAGE.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
		Layer.STAGE.removeEventListener(MouseEvent.MOUSE_UP, ptMouseUpHandler);
		if (this.curHistoryVo)
			this.curHistoryVo.nextVo = this.historyProxy.saveNextHistory(this.faceComponet);
	}
	
	private function enterFrameHandler(event:Event):void 
	{
		if (this.curPtSpt)
		{
			var pos:Point = this.curPtSpt.parent.globalToLocal(new Point(Layer.STAGE.mouseX, 
																		 Layer.STAGE.mouseY));
			var sc:SurfaceComponet = this.curPtSpt.parent as SurfaceComponet;
			sc.setChildIndex(this.curPtSpt, 1);
			var gap:int = 1;
			var dis:Number;
			if (this.curPtSpt.name == "upLeft")
			{
				dis = sc.downLeftPoint.x - this.curPtSpt.x;
				this.curPtSpt.x = pos.x;
				this.curPtSpt.y = pos.y;
				if (this.curPtSpt.x > sc.upRightPoint.x - gap)
					this.curPtSpt.x = sc.upRightPoint.x - gap;
				if (this.curPtSpt.y > sc.downRightPoint.y - gap)
					this.curPtSpt.y = sc.downRightPoint.y - gap;
				sc.upRightPoint.y = this.curPtSpt.y;
				if (this.isOnCtrlKey)
				{
					sc.downLeftPoint.x = this.curPtSpt.x + dis;
					if (sc.downLeftPoint.x > sc.downRightPoint.x - gap)
						sc.downLeftPoint.x = sc.downRightPoint.x - gap;
				}
			}
			else if (this.curPtSpt.name == "upRight")
			{
				dis = sc.downRightPoint.x - this.curPtSpt.x;
				this.curPtSpt.x = pos.x;
				this.curPtSpt.y = pos.y;
				if (this.curPtSpt.x < sc.upLeftPoint.x + gap)
					this.curPtSpt.x = sc.upLeftPoint.x + gap;
				if (this.curPtSpt.y > sc.downRightPoint.y - gap)
					this.curPtSpt.y = sc.downRightPoint.y - gap;
				sc.upLeftPoint.y = this.curPtSpt.y;
				if (this.isOnCtrlKey)
				{
					sc.downRightPoint.x = this.curPtSpt.x + dis;
					if (sc.downRightPoint.x < sc.downLeftPoint.x + gap)
						sc.downRightPoint.x = sc.downLeftPoint.x + gap;
				}
			}
			else if (this.curPtSpt.name == "downLeft")
			{
				dis = sc.upLeftPoint.x - this.curPtSpt.x;
				this.curPtSpt.x = pos.x;
				this.curPtSpt.y = pos.y;
				if (this.curPtSpt.x > sc.downRightPoint.x - gap)
					this.curPtSpt.x = sc.downRightPoint.x - gap;
				if (this.curPtSpt.y < sc.upLeftPoint.y + gap)
					this.curPtSpt.y = sc.upLeftPoint.y + gap;
				sc.downRightPoint.y = this.curPtSpt.y;
				if (this.isOnCtrlKey)
				{
					sc.upLeftPoint.x = this.curPtSpt.x + dis;
					if (sc.upLeftPoint.x > sc.upRightPoint.x - gap)
						sc.upLeftPoint.x = sc.upRightPoint.x - gap;
				}
			}
			else if (this.curPtSpt.name == "downRight")
			{
				dis = sc.upRightPoint.x - this.curPtSpt.x;
				this.curPtSpt.x = pos.x;
				this.curPtSpt.y = pos.y;
				if (this.curPtSpt.x < sc.downLeftPoint.x + gap)
					this.curPtSpt.x = sc.downLeftPoint.x + gap;
				if (this.curPtSpt.y < sc.upRightPoint.y + gap)
					this.curPtSpt.y = sc.upRightPoint.y + gap;
				sc.downLeftPoint.y = this.curPtSpt.y;
				if (this.isOnCtrlKey)
				{
					sc.upRightPoint.x = this.curPtSpt.x + dis;
					if (sc.upRightPoint.x < sc.upLeftPoint.x + gap)
						sc.upRightPoint.x = sc.upLeftPoint.x + gap;
				}
			}
			sc.draw();
		}
	}
	
	private function stageMouseUpHandler(event:MouseEvent):void 
	{
		this.faceComponet.stopDrag();
		if (this.faceComponet && this.isOnCtrlKey) this.autoAbsorbFacePoint(this.faceComponet);
		Layer.STAGE.removeEventListener(MouseEvent.MOUSE_UP, stageMouseUpHandler);
		Layer.STAGE.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
		if (!Layer.TERRAIN_LAYER.contains(this.faceComponet))
		{
			var pos:Point = Layer.TERRAIN_LAYER.globalToLocal(new Point(event.stageX, event.stageY));
			this.faceComponet.x = pos.x - this.faceComponet.width / 2;
			this.faceComponet.y = pos.y - this.faceComponet.height / 2;
			Layer.TERRAIN_LAYER.addChild(this.faceComponet);
			this.sendNotification(Message.FACE_MOUSE_DOWN, this.faceComponet);
			this.sendNotification(Message.FACE_MOUSE_UP);
			this.historyProxy.saveHistory(this.faceComponet, HistoryVo.CREATE);
		}
	}

	private function faceMouseDownHandler(event:MouseEvent):void 
	{
		this.faceComponet = event.currentTarget as SurfaceComponet;
		this.historyProxy.saveHistory(this.faceComponet, HistoryVo.PROP);
		this.faceComponet.startDrag();
		Layer.STAGE.addEventListener(MouseEvent.MOUSE_UP, stageMouseUpHandler);
		//Layer.STAGE.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		this.sendNotification(Message.FACE_MOUSE_DOWN, this.faceComponet);
	}
	
	/**
	 * 自动吸附点
	 * @param	face	面
	 */
	private function autoAbsorbFacePoint(face:SurfaceComponet):void
	{
		if (!face) return;
		var count:int = Layer.TERRAIN_LAYER.numChildren;
		var dis:Number = Infinity;
		var pot:Point;
		for (var i:int = 0; i < count; ++i) 
		{
			var curFace:SurfaceComponet = Layer.TERRAIN_LAYER.getChildAt(i) as SurfaceComponet;
			if (curFace == face) continue;
			var curPotArr:Array = [];
			pot = new Point(curFace.upLeftPoint.x + curFace.x, curFace.upLeftPoint.y + curFace.y);
			curPotArr.push(pot);
			pot = new Point(curFace.upRightPoint.x + curFace.x, curFace.upRightPoint.y + curFace.y);
			curPotArr.push(pot);
			pot = new Point(curFace.downLeftPoint.x + curFace.x, curFace.downLeftPoint.y + curFace.y);
			curPotArr.push(pot);
			pot = new Point(curFace.downRightPoint.x + curFace.x, curFace.downRightPoint.y + curFace.y);
			curPotArr.push(pot);
			var length:int = curPotArr.length;
			var tempFacePot:Point;
			var tempCurFacePot:Point;
			for (var j:int = 0; j < length; j++) 
			{
				pot = curPotArr[j];
				var facePot:Point = new Point(face.upLeftPoint.x + face.x, face.upLeftPoint.y + face.y);
				if (Point.distance(facePot, pot) < dis)
				{
					dis = Point.distance(facePot, pot);
					tempFacePot = facePot;
					tempCurFacePot = pot;
				}
					
				facePot =  new Point(face.upRightPoint.x + face.x, face.upRightPoint.y + face.y);
				if (Point.distance(facePot, pot) < dis)
				{
					dis = Point.distance(facePot, pot);
					tempFacePot = facePot;
					tempCurFacePot = pot;
				}
					
				facePot =  new Point(face.downLeftPoint.x + face.x, face.downLeftPoint.y + face.y);
				if (Point.distance(facePot, pot) < dis)
				{
					dis = Point.distance(facePot, pot);
					tempFacePot = facePot;
					tempCurFacePot = pot;
				}
					
				facePot =  new Point(face.downRightPoint.x + face.x, face.downRightPoint.y + face.y);
				if (Point.distance(facePot, pot) < dis)
				{
					dis = Point.distance(facePot, pot);
					tempFacePot = facePot;
					tempCurFacePot = pot;
				}
			}
			
			if (dis <= 20)
			{
				var subPot:Point = tempFacePot.subtract(tempCurFacePot);
				face.x -= subPot.x;
				face.y -= subPot.y;
				break;
			}
		}
	}
}
}