package
{
import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
import flash.display.Stage;
/**
 * ...层
 * @author Kanon
 */
public class Layer
{
	public static var ROOT:DisplayObjectContainer;
	public static var STAGE:Stage;
	public static var UI:Sprite;
	public static function initLayer(root:DisplayObjectContainer):void
	{
		ROOT = root;
		STAGE = root.stage;
		
		UI = new Sprite();
		root.addChild(UI);
	}
}
}