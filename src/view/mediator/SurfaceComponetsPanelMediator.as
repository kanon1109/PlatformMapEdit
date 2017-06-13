package view.mediator 
{
import flash.display.Sprite;
import flash.events.Event;
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
		this.faceComponetsPanel.rect.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownHandler);
		this.faceComponetsPanel.quad1.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownHandler);
		this.faceComponetsPanel.quad2.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownHandler);
		this.faceComponetsPanel.trapezoid1.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownHandler);
		this.faceComponetsPanel.trapezoid2.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownHandler);
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
		trace(this.faceComponet.toString());
		Layer.STAGE.addEventListener(MouseEvent.MOUSE_UP, stageMouseUpHandler);
		this.sendNotification(Message.FACE_MOUSE_DOWN, this.faceComponet);
	}
}
}