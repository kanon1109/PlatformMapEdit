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
	//操作类型
	public var type:int;
	//操作对象
	public var target:Object;
	public function HistoryVo() 
	{
		
	}
	
}
}