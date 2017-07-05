package model.proxy 
{
import model.vo.HistoryVo;
import org.puremvc.as3.patterns.proxy.Proxy;
/**
 * ...历史记录数据管理
 * @author ...	Kanon
 */
public class HistoryProxy extends Proxy 
{
	//保存历史列表
	public static const NAME:String = "HistoryProxy";
	private var historyAry:Array = [];
	//当前记录索引
	private var curIndex:int = -1;
	public function HistoryProxy(proxyName:String=null, data:Object=null) 
	{
		super(NAME, data);
	}
	
	/**
	 * 添加历史记录
	 * @param	vo	记录数据
	 */
	public function addHistory(vo:HistoryVo):void
	{
		trace("this.curIndex", this.curIndex);
		trace("this.historyAry.length", this.historyAry.length);
		if (this.curIndex < this.historyAry.length - 1)
			this.historyAry.splice(this.curIndex + 1);
		this.historyAry.push(vo);
		this.curIndex = this.historyAry.length - 1;
		trace("now this.curIndex", this.curIndex);
	}
	
	/**
	 * 撤销
	 * @return	记录数据
	 */
	public function prevHistory():HistoryVo
	{
		trace("prevHistory this.historyAry.length", this.historyAry.length);
		if (this.historyAry.length == 0) return null;
		if (this.curIndex == -1) return null;
		trace("now this.curIndex", this.curIndex);
		var index:int = this.curIndex;
		this.curIndex--;
		if (this.curIndex < 0) this.curIndex = -1; 
		trace("prevHistory this.curIndex", this.curIndex);
		return this.historyAry[index];
	}
	
	/**
	 * 恢复撤销
	 * @return	记录数据
	 */
	public function nextHistory():HistoryVo
	{
		if (this.curIndex == this.historyAry.length - 1 || 
			this.historyAry.length == 0) return null;
		this.curIndex++;
		return this.historyAry[this.curIndex];
	}
	
	/**
	 * 清理历史记录
	 */
	public function clear():void
	{
		this.historyAry = [];
	}
}
}