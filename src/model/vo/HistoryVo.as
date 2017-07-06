package model.vo 
{
/**
 * ...历史数据
 * @author ...
 */
public class HistoryVo 
{
	public static const DELETE:int = 0;
	public static const COPY:int = 1;
	public static const CREATE:int = 2;
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
	public function HistoryVo() 
	{
		
	}
	
}
}