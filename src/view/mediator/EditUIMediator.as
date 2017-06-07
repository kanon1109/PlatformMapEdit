package view.mediator 
{
import flash.events.MouseEvent;
import message.Message;
import org.puremvc.as3.interfaces.INotification;
import org.puremvc.as3.patterns.mediator.Mediator;
import view.ui.EditUI;
/**
 * ...
 * @author Kanon
 */
public class EditUIMediator extends Mediator 
{
	private var editUI:EditUI;
	public function EditUIMediator(mediatorName:String=null, viewComponent:Object=null) 
	{
		super(mediatorName, viewComponent);
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
				this.editUI = new EditUI();
				Layer.UI.addChild(this.editUI);
			break;
			default:
		}
	}
	
	/**
	 * 初始化编辑器UI
	 */
	private function initEditUI():void
	{
		this.editUI.importBtn.addEventListener(MouseEvent.CLICK, importBtnClickHandler);
		this.editUI.exportBtn.addEventListener(MouseEvent.CLICK, exportBtnClickHandler);
	}
	
	private function exportBtnClickHandler(event:MouseEvent):void 
	{
		
	}
	
	private function importBtnClickHandler(event:MouseEvent):void 
	{
		
	}
}
}