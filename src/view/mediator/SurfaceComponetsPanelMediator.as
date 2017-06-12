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
	public function SurfaceComponetsPanelMediator(mediatorName:String=null, viewComponent:Object=null) 
	{
		super(mediatorName, viewComponent);
	}
	
	override public function listNotificationInterests():Array 
	{
		var arr:Array = [];
		arr.push(Message.INIT);
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
			default:
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
		this.faceComponet.upLeftPoint.addEventListener(MouseEvent.MOUSE_DOWN, upLeftMouseDownHandler);
		this.faceComponet.downLeftPoint.addEventListener(MouseEvent.MOUSE_DOWN, downLeftMouseDownHandler);
		this.faceComponet.upRightPoint.addEventListener(MouseEvent.MOUSE_DOWN, upRightMouseDownHandler);
		this.faceComponet.downRightPoint.addEventListener(MouseEvent.MOUSE_DOWN, downRightMouseDownHandler);
		Layer.STAGE.addEventListener(MouseEvent.MOUSE_UP, stageMouseUpHandler);
	}
		
	private function upLeftMouseDownHandler(event:MouseEvent):void 
	{
		event.stopImmediatePropagation();
		var upLeftPoint:Sprite = event.currentTarget as Sprite;
		Layer.STAGE.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
	}
	
	private function enterFrameHandler(event:Event):void 
	{
		var upLeftPoint:Sprite = event.currentTarget as Sprite;
		var pos:Point = upLeftPoint.parent.globalToLocal(new Point(event.stageX, event.stageY));
		upLeftPoint.x = pos.x;
		upLeftPoint.y = pos.y;
	}

	
	private function downLeftMouseDownHandler(event:MouseEvent):void 
	{
		event.stopImmediatePropagation();
	}
	
	private function downRightMouseDownHandler(event:MouseEvent):void 
	{
		event.stopImmediatePropagation();
	}
	
	private function upRightMouseDownHandler(event:MouseEvent):void 
	{
		event.stopImmediatePropagation();
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
		}
	}

	private function faceMouseDownHandler(event:MouseEvent):void 
	{
		this.faceComponet = event.currentTarget as SurfaceComponet;
		this.faceComponet.startDrag();
		Layer.STAGE.addEventListener(MouseEvent.MOUSE_UP, stageMouseUpHandler);
	}
}
}