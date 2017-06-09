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
	public static var UI_LAYER:Sprite;
	public static var STAGE_LAYER:Sprite;
	public static var STAGE_BG_LAYER:Sprite;
	public static var TERRAIN_LAYER:Sprite;
	public static var STAGE_FG_LAYER:Sprite;
	public static var EDIT_LAYER:Sprite;
	public static var SYSTEM_LAYER:Sprite;
	public static var TOP_LAYER:Sprite;
	
	public static function initLayer(root:DisplayObjectContainer):void
	{
		ROOT = root;
		STAGE = root.stage;
		
		//存放UI
		UI_LAYER = new Sprite();
		root.addChild(UI_LAYER);
		
		STAGE_LAYER = new Sprite();
		root.addChild(STAGE_LAYER);
		
		//背景层
		STAGE_BG_LAYER = new Sprite();
		STAGE_LAYER.addChild(STAGE_BG_LAYER);
		
		//地形层
		TERRAIN_LAYER = new Sprite();
		STAGE_LAYER.addChild(TERRAIN_LAYER);
		
		//前景层
		STAGE_FG_LAYER = new Sprite();
		STAGE_LAYER.addChild(STAGE_FG_LAYER);	
		
		EDIT_LAYER = new Sprite();
		root.addChild(EDIT_LAYER);
		
		SYSTEM_LAYER = new Sprite();
		root.addChild(SYSTEM_LAYER);
		
		//顶层
		TOP_LAYER = new Sprite();
		root.addChild(TOP_LAYER);
	}
}
}