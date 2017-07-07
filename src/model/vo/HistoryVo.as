package model.vo 
{
	import flash.geom.Point;
/**
 * ...历史数据
 * @author ...
 */
public class HistoryVo 
{
	public static const DELETE:int = 0;//删除
	public static const COPY:int = 1;//复制
	public static const CREATE:int = 2;//创建
	public static const PROP:int = 3;//属性更新
	//操作类型
	public var type:int;
	//操作对象
	public var target:Object;
	//深度
	public var depth:int;
	//坐标
	public var x:Number;
	public var y:Number;
	//名字
	public var name:String;
	//face 的属性
	public var leftBlock:Boolean;
	public var rightBlock:Boolean;
	public var upBlock:Boolean;
	public var downBlock:Boolean;
	public var leftRestrict:Boolean;
	public var rightRestrict:Boolean;
	//左上点坐标
	public var upLeftPoint:Point;
	//右上点坐标
	public var upRightPoint:Point;
	//左下点坐标
	public var downLeftPoint:Point;
	//右下点坐标
	public var downRightPoint:Point;
	public var leftH:Number;
	public var rightH:Number;
	public function HistoryVo() 
	{
		
	}
	
}
}