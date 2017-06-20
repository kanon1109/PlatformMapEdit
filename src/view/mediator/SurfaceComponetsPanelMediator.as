package view.mediator 
{
import com.bit101.components.InputText;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.FocusEvent;
import flash.events.MouseEvent;
import flash.geom.Point;
import message.Message;
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
	private var editUI:EditUI;
	private var faceComponetsPanel:SurfaceComponetsPanel;
	private var faceComponet:SurfaceComponet;
	private var curPtSpt:Sprite;
	public function SurfaceComponetsPanelMediator(mediatorName:String=null, viewComponent:Object=null) 
	{
		super(mediatorName, viewComponent);
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
		this.editUI.upLeftXTxt.addEventListener(FocusEvent.FOCUS_OUT, txtfocusOutHandler);
		this.editUI.downLeftXTxt.addEventListener(FocusEvent.FOCUS_OUT, txtfocusOutHandler);
		this.editUI.upRightXTxt.addEventListener(FocusEvent.FOCUS_OUT, txtfocusOutHandler);
		this.editUI.downRightXTxt.addEventListener(FocusEvent.FOCUS_OUT, txtfocusOutHandler);
		this.editUI.upYTxt.addEventListener(FocusEvent.FOCUS_OUT, txtfocusOutHandler);
		this.editUI.downYTxt.addEventListener(FocusEvent.FOCUS_OUT, txtfocusOutHandler);
		this.editUI.leftRestrict.addEventListener(MouseEvent.CLICK, checkBoxHandler);
		this.editUI.rightRestrict.addEventListener(MouseEvent.CLICK, checkBoxHandler);
		this.editUI.leftBlock.addEventListener(MouseEvent.CLICK, checkBoxHandler);
		this.editUI.rightBlock.addEventListener(MouseEvent.CLICK, checkBoxHandler);
		this.editUI.upBlock.addEventListener(MouseEvent.CLICK, checkBoxHandler);
		this.editUI.downBlock.addEventListener(MouseEvent.CLICK, checkBoxHandler);
		
		this.editUI.leftHeightTxt.addEventListener(FocusEvent.FOCUS_OUT, txtfocusOutHandler);
		this.editUI.rightHeightTxt.addEventListener(FocusEvent.FOCUS_OUT, txtfocusOutHandler);
		this.editUI.depthTxt.addEventListener(FocusEvent.FOCUS_OUT, txtfocusOutHandler);
		
		this.faceComponetsPanel.rect.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownHandler);
		this.faceComponetsPanel.quad1.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownHandler);
		this.faceComponetsPanel.quad2.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownHandler);
		this.faceComponetsPanel.trapezoid1.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownHandler);
		this.faceComponetsPanel.trapezoid2.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownHandler);
	}
	
	private function checkBoxHandler(event:MouseEvent):void 
	{
		if (this.faceComponet)
		{
			this.faceComponet.leftRestrict = this.editUI.leftRestrict.selected;
			this.faceComponet.rightRestrict = this.editUI.rightRestrict.selected;
			if (this.faceComponet.leftH <= 0)
				this.faceComponet.leftBlock = this.editUI.leftBlock.selected;
			else
				this.editUI.leftBlock.selected = false;
			if (this.faceComponet.rightH <= 0)
				this.faceComponet.rightBlock = this.editUI.rightBlock.selected;
			else
				this.editUI.rightBlock.selected = false;
			this.faceComponet.upBlock = this.editUI.upBlock.selected;
			this.faceComponet.downBlock = this.editUI.downBlock.selected;
			this.faceComponet.draw();
		}
	}
	
	private function txtfocusOutHandler(event:FocusEvent):void 
	{
		if (this.faceComponet)
		{
			var txt:InputText = event.currentTarget as InputText;
			var gap:int = 10;
			var upleftX:Number = Number(this.editUI.upLeftXTxt.text);
			var upRightX:Number = Number(this.editUI.upRightXTxt.text);
			var downleftX:Number = Number(this.editUI.downLeftXTxt.text);
			var downRightX:Number = Number(this.editUI.downRightXTxt.text);
			var upY:Number = Number(this.editUI.upYTxt.text);
			var downY:Number = Number(this.editUI.downYTxt.text);
			
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
			
			if (this.faceComponet.leftH > 0)
				this.editUI.leftBlock.selected = false;
			if (this.faceComponet.rightH > 0)
				this.editUI.rightBlock.selected = false;
			this.faceComponet.draw();
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
	}
		
	private function ptMouseDownHandler(event:MouseEvent):void 
	{
		event.stopImmediatePropagation();
		this.curPtSpt = event.currentTarget as Sprite;
		this.faceComponet = this.curPtSpt.parent as SurfaceComponet;
		Layer.STAGE.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		Layer.STAGE.addEventListener(MouseEvent.MOUSE_UP, ptMouseUpHandler);
		this.sendNotification(Message.FACE_MOUSE_DOWN, this.faceComponet);
	}
	
	private function ptMouseUpHandler(event:MouseEvent):void 
	{
		Layer.STAGE.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
		Layer.STAGE.removeEventListener(MouseEvent.MOUSE_UP, ptMouseUpHandler);
	}
	
	private function enterFrameHandler(event:Event):void 
	{
		if (this.curPtSpt)
		{
			var pos:Point = this.curPtSpt.parent.globalToLocal(new Point(Layer.STAGE.mouseX, 
																		 Layer.STAGE.mouseY));
			var sc:SurfaceComponet = this.curPtSpt.parent as SurfaceComponet;
			this.curPtSpt.x = pos.x;
			this.curPtSpt.y = pos.y;
			sc.setChildIndex(this.curPtSpt, 1);
			var gap:int = 10;
			if (this.curPtSpt.name == "upLeft")
			{
				if (this.curPtSpt.x > sc.upRightPoint.x - gap)
					this.curPtSpt.x = sc.upRightPoint.x - gap;
				if (this.curPtSpt.y > sc.downRightPoint.y - gap)
					this.curPtSpt.y = sc.downRightPoint.y - gap;
				sc.upRightPoint.y = this.curPtSpt.y;
			}
			else if (this.curPtSpt.name == "upRight")
			{
				if (this.curPtSpt.x < sc.upLeftPoint.x + gap)
					this.curPtSpt.x = sc.upLeftPoint.x + gap;
				if (this.curPtSpt.y > sc.downRightPoint.y - gap)
					this.curPtSpt.y = sc.downRightPoint.y - gap;
				sc.upLeftPoint.y = this.curPtSpt.y;
			}
			else if (this.curPtSpt.name == "downLeft")
			{
				if (this.curPtSpt.x > sc.downRightPoint.x - gap)
					this.curPtSpt.x = sc.downRightPoint.x - gap;
				if (this.curPtSpt.y < sc.upLeftPoint.y + gap)
					this.curPtSpt.y = sc.upLeftPoint.y + gap;
				sc.downRightPoint.y = this.curPtSpt.y;
			}
			else if (this.curPtSpt.name == "downRight")
			{
				if (this.curPtSpt.x < sc.downLeftPoint.x + gap)
					this.curPtSpt.x = sc.downLeftPoint.x + gap;
				if (this.curPtSpt.y < sc.upRightPoint.y + gap)
					this.curPtSpt.y = sc.upRightPoint.y + gap;
				sc.downLeftPoint.y = this.curPtSpt.y;
			}
			sc.draw();
		}
	}
	
	private function stageMouseUpHandler(event:MouseEvent):void 
	{
		this.faceComponet.stopDrag();
		Layer.STAGE.removeEventListener(MouseEvent.MOUSE_UP, stageMouseUpHandler);
		if (!Layer.TERRAIN_LAYER.contains(this.faceComponet))
		{
			var pos:Point = Layer.TERRAIN_LAYER.globalToLocal(new Point(event.stageX, event.stageY));
			this.faceComponet.x = pos.x - this.faceComponet.width / 2;
			this.faceComponet.y = pos.y - this.faceComponet.height / 2;
			Layer.TERRAIN_LAYER.addChild(this.faceComponet);
			this.sendNotification(Message.FACE_MOUSE_DOWN, this.faceComponet);
		}
	}

	private function faceMouseDownHandler(event:MouseEvent):void 
	{
		this.faceComponet = event.currentTarget as SurfaceComponet;
		this.faceComponet.startDrag();
		Layer.STAGE.addEventListener(MouseEvent.MOUSE_UP, stageMouseUpHandler);
		this.sendNotification(Message.FACE_MOUSE_DOWN, this.faceComponet);
	}
}
}