package controller 
{
import message.Message;
import org.puremvc.as3.interfaces.INotification;
import org.puremvc.as3.patterns.command.SimpleCommand;
import view.mediator.EditUIMediator;
import view.mediator.SufaceComponetsPanelMediator;
/**
 * ...
 * @author Kanon
 */
public class ViewCommand extends SimpleCommand 
{
	public function ViewCommand() 
	{
		super();
	}
	
	override public function execute(notification:INotification):void  
	{
		trace("ViewCommand execute");
		this.facade.registerMediator(new EditUIMediator());
		this.facade.registerMediator(new SufaceComponetsPanelMediator());
		this.sendNotification(Message.START);
	}
}
}