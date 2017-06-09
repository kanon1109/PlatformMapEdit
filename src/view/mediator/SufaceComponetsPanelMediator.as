package view.mediator 
{
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import message.Message;
import org.puremvc.as3.interfaces.INotification;
import org.puremvc.as3.patterns.mediator.Mediator;
import view.ui.EditUI;
import view.ui.SufaceComponetsPanel;
/**
 * ...面组件面板中介
 * @author ...Kanon
 */
public class SufaceComponetsPanelMediator extends Mediator 
{
	private var editUI:EditUI;
	private var faceComponetsPanel:SufaceComponetsPanel;
	private var curSuface:Sprite;
	public function SufaceComponetsPanelMediator(mediatorName:String=null, viewComponent:Object=null) 
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
		switch (componets.name) 
		{
			case "rect":
				this.curSuface = this.faceComponetsPanel.createRectSuface();
				break;
			case "quad1":
				this.curSuface = this.faceComponetsPanel.createQuadSuface(true);
				break;
			case "quad2":
				this.curSuface = this.faceComponetsPanel.createQuadSuface(false);
				break;
			case "trapezoid1":
				this.curSuface = this.faceComponetsPanel.createTrapezoidSuface(true);
				break;
			case "trapezoid2":
				this.curSuface = this.faceComponetsPanel.createTrapezoidSuface(false);
				break;
		}
		if (this.curSuface)
		{
			Layer.TOP_LAYER.addChild(this.curSuface);
			Layer.STAGE.addEventListener(MouseEvent.MOUSE_UP, stageMouseUpHandler);
			Layer.STAGE.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
	}
	
	private function stageMouseUpHandler(event:MouseEvent):void 
	{
		Layer.STAGE.removeEventListener(MouseEvent.MOUSE_UP, stageMouseUpHandler);
		Layer.STAGE.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
		
		
		
		if (this.curSuface && this.curSuface.parent)
		{
			this.curSuface.parent.removeChild(this.curSuface);
			this.curSuface = null;
		}
	}
		
	private function enterFrameHandler(event:Event):void 
	{
		if (this.curSuface)
		{
			this.curSuface.x = Layer.STAGE.mouseX - this.curSuface.width / 2;
			this.curSuface.y = Layer.STAGE.mouseY - this.curSuface.height / 2;
		}
	}
}
}