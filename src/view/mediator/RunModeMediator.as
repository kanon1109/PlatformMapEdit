package view.mediator 
{
import engine.face.Surface;
import engine.manager.FaceMangager;
import flash.events.Event;
import message.Message;
import org.puremvc.as3.interfaces.INotification;
import org.puremvc.as3.patterns.mediator.Mediator;
import view.ui.SurfaceComponet;
/**
 * ...运行模式
 * @author Kanon
 */
public class RunModeMediator extends Mediator 
{
	public static var NAME:String = "RunModeMediator";
	public function RunModeMediator(mediatorName:String=null, viewComponent:Object=null) 
	{
		super(NAME);
	}
	
	override public function listNotificationInterests():Array 
	{
		var arr:Array = [Message.RUN];
		return arr;
	}
	
	override public function handleNotification(notification:INotification):void 
	{
		switch (notification.getName()) 
		{
			case Message.RUN:
				if(Boolean(notification.getBody()))
					this.createSurfaceMap();
				else
					FaceMangager.clear();
				Layer.STAGE.addEventListener(Event.ENTER_FRAME, loop);
			break;
		}
	}
	
	/**
	 * 创建面地图
	 */
	private function createSurfaceMap():void
	{
		var count:int = Layer.TERRAIN_LAYER.numChildren;
		for (var i:int = 0; i < count; ++i) 
		{
			var sc:SurfaceComponet = Layer.TERRAIN_LAYER.getChildAt(i) as SurfaceComponet;
			var face:Surface = new Surface(sc.upLeftPoint.x, sc.downLeftPoint.x,
										   sc.upRightPoint.x, sc.downRightPoint.x, 
										   sc.upLeftPoint.y, sc.downRightPoint.y);
			face.name = sc.name;
			face.x = sc.x;
			face.y = sc.y;
			face.z = sc.depth;
			face.leftBlock = sc.leftBlock;
			face.rightBlock = sc.rightBlock;
			face.upBlock = sc.upBlock;
			face.downBlock = sc.downBlock;
			face.leftH = sc.leftH;
			face.rightH = sc.rightH;
			face.leftRestrict = sc.leftRestrict;
			face.rightRestrict = sc.rightRestrict;
			FaceMangager.add(face);
		}
	}
	
	private function loop(event:Event):void 
	{
		FaceMangager.debugFace(Layer.RUN_LAYER.graphics);
	}
}
}