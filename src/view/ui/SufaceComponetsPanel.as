package view.ui 
{
import com.bit101.components.Panel;
import flash.display.DisplayObjectContainer;
import flash.display.Sprite;

/**
 * ...面组件面板
 * @author Kanon
 */
public class SufaceComponetsPanel extends Panel 
{
	public var rect:Sprite;
	public function SufaceComponetsPanel(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0) 
	{
		super(parent, xpos, ypos);
		this.setSize(180, 300);
	}
	
}
}