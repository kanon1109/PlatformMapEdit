package view.mediator 
{
import engine.body.Body;
import engine.face.Surface;
import engine.manager.FaceMangager;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.ui.Keyboard;
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
	//物体
	private var body:Body;
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
				if (Boolean(notification.getBody()))
				{
					this.createBody();
					this.createSurfaceMap();
					Layer.STAGE.addEventListener(Event.ENTER_FRAME, loop);
					Layer.STAGE.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDownHandler);
					Layer.STAGE.addEventListener(KeyboardEvent.KEY_UP, onKeyUpHandler);
				}
				else
				{
					if (this.body && this.body.display && this.body.display.parent)
						this.body.display.parent.removeChild(this.body.display);
					Layer.RUN_LAYER.graphics.clear();
					FaceMangager.clear();
					Layer.STAGE.removeEventListener(Event.ENTER_FRAME, loop);
					Layer.STAGE.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDownHandler);
					Layer.STAGE.removeEventListener(KeyboardEvent.KEY_UP, onKeyUpHandler);
				}
			break;
		}
	}

	/**
	 * 创建面地图
	 */
	private function createSurfaceMap():void
	{
		var face:Surface;
		var count:int = Layer.TERRAIN_LAYER.numChildren;
		for (var i:int = 0; i < count; ++i) 
		{
			var sc:SurfaceComponet = Layer.TERRAIN_LAYER.getChildAt(i) as SurfaceComponet;
			face = new Surface(sc.upLeftPoint.x, sc.downLeftPoint.x,
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
		
					
		face = FaceMangager.getFaceByName("instance204");
		this.body.face = face
		this.body.x = face.x + face.width / 2;
		this.body.y = face.y + face.height / 2;
	}
	
	/**
	 * 创建物体
	 */
	private function createBody():void
	{
		var width:Number = 18;
		var height:Number = 30;
		this.body = new Body();
		this.body.thick = width / 2;
		this.body.g = 0.7;
		var rect:Sprite = new Sprite();
		rect.graphics.beginFill(0xFF0080, .5);
		rect.graphics.drawRect(-width / 2, -height, width, height);
		rect.graphics.endFill();
		Layer.RUN_LAYER.addChild(rect);
		this.body.display = rect;
	}
	
	private function loop(event:Event):void 
	{
		this.body.update();
		if (this.body.face)
			this.body.face.debugDraw(Layer.RUN_LAYER.graphics, 0x00FF80);
		FaceMangager.debugFace(Layer.RUN_LAYER.graphics);
	}
	
	//-----------------------event handler----------------------------
	////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////
	private function onKeyUpHandler(event:KeyboardEvent):void 
	{
		if (event.keyCode == Keyboard.A || event.keyCode == Keyboard.D) this.body.moveH(0);
		if (event.keyCode == Keyboard.W || event.keyCode == Keyboard.S) this.body.moveV(0);
	}
	
	private function onKeyDownHandler(event:KeyboardEvent):void 
	{
		if (event.keyCode == Keyboard.D)
			this.body.moveH(2);
		else if (event.keyCode == Keyboard.A)
			this.body.moveH(-2);
		
		if (event.keyCode == Keyboard.W)
			this.body.moveV(-2);
		else if (event.keyCode == Keyboard.S)
			this.body.moveV(2);
		
		if (event.keyCode == Keyboard.SPACE)
			this.body.jump(10);
	}
}
}