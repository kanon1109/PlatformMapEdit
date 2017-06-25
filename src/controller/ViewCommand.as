package controller 
{
import message.Message;
import org.puremvc.as3.interfaces.INotification;
import org.puremvc.as3.patterns.command.SimpleCommand;
import view.mediator.EditUIMediator;
import view.mediator.RunModeMediator;
import view.mediator.SurfaceComponetsPanelMediator;
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
		this.facade.registerMediator(new SurfaceComponetsPanelMediator());
		this.facade.registerMediator(new RunModeMediator());
		this.sendNotification(Message.START);
	}
}
}