package controller 
{
import org.puremvc.as3.patterns.command.MacroCommand;
/**
 * ...开启
 * @author Kanon
 */
public class StartupCommand extends MacroCommand 
{	
	override protected function initializeMacroCommand():void 
	{
		this.addSubCommand(ModelCommand);	
		this.addSubCommand(ViewCommand);	
		super.initializeMacroCommand();
	}
}
}