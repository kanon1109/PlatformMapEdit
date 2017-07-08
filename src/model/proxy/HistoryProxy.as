package model.proxy 
{
import flash.display.Sprite;
import flash.geom.Point;
import model.vo.HistoryVo;
import org.puremvc.as3.patterns.proxy.Proxy;
import view.ui.SurfaceComponet;
/**
 * ...历史记录数据管理
 * @author ...	Kanon
 */
public class HistoryProxy extends Proxy 
{
	//保存历史列表
	public static const NAME:String = "HistoryProxy";
	private var historyMaxCount:int = 100;
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
		if (this.curIndex < this.historyAry.length - 1)
			this.historyAry.splice(this.curIndex + 1);
		this.historyAry.push(vo);
		if (this.historyAry.length > this.historyMaxCount)
			this.historyAry.splice(0, 1);
		this.curIndex = this.historyAry.length - 1;
	}
	
	/**
	 * 撤销
	 * @return	记录数据
	 */
	public function prevHistory():HistoryVo
	{
		if (this.historyAry.length == 0) return null;
		if (this.curIndex == -1) return null;
		var index:int = this.curIndex;
		this.curIndex--;
		if (this.curIndex < 0) this.curIndex = -1; 
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
	
	
	/**
	 * 保存记录
	 * @param	spt		显示对象
	 * @param	type	保存类型
	 */
	public function saveHistory(spt:Sprite, type:int):HistoryVo
	{
		if (spt)
		{
			trace("----------------save-------------")
			var hVo:HistoryVo = new HistoryVo();
			hVo.target = spt;
			hVo.type = type;
			hVo.x = spt.x;
			hVo.y = spt.y;
			if (spt is SurfaceComponet)
			{
				var face:SurfaceComponet = spt as SurfaceComponet;
				hVo.leftBlock = face.leftBlock;
				hVo.rightBlock = face.rightBlock;
				hVo.upBlock = face.upBlock;
				hVo.downBlock = face.downBlock;
				hVo.leftH = face.leftH;
				hVo.rightH = face.rightH;
				hVo.leftRestrict = face.leftRestrict;
				hVo.rightRestrict = face.rightRestrict;
				hVo.upLeftPoint = new Point(face.upLeftPoint.x, face.upLeftPoint.y);
				hVo.upRightPoint = new Point(face.upRightPoint.x, face.upRightPoint.y);
				hVo.downLeftPoint = new Point(face.downLeftPoint.x, face.downLeftPoint.y);
				hVo.downRightPoint = new Point(face.downRightPoint.x, face.downRightPoint.y);
				hVo.depth = face.depth;
				trace("save ", face.depth);
			}
			hVo.childIndex = spt.parent.getChildIndex(spt);
			hVo.name = spt.name;
			this.addHistory(hVo);
			return hVo;
		}
		return null;
	}
	
	/**
	 * 保存属性操作的下一步
	 * @param	spt		显示对象
	 * @return
	 */
	public function saveNextHistory(spt:Sprite):HistoryVo
	{
		if (spt)
		{
			var hVo:HistoryVo = new HistoryVo();
			hVo.target = spt;
			hVo.type = HistoryVo.PROP;
			hVo.x = spt.x;
			hVo.y = spt.y;
			if (spt is SurfaceComponet)
			{
				var face:SurfaceComponet = spt as SurfaceComponet;
				hVo.leftBlock = face.leftBlock;
				hVo.rightBlock = face.rightBlock;
				hVo.upBlock = face.upBlock;
				hVo.downBlock = face.downBlock;
				hVo.leftH = face.leftH;
				hVo.rightH = face.rightH;
				hVo.leftRestrict = face.leftRestrict;
				hVo.rightRestrict = face.rightRestrict;
				hVo.upLeftPoint = new Point(face.upLeftPoint.x, face.upLeftPoint.y);
				hVo.upRightPoint = new Point(face.upRightPoint.x, face.upRightPoint.y);
				hVo.downLeftPoint = new Point(face.downLeftPoint.x, face.downLeftPoint.y);
				hVo.downRightPoint = new Point(face.downRightPoint.x, face.downRightPoint.y);
				hVo.depth = face.depth;
			}
			hVo.childIndex = spt.parent.getChildIndex(spt);
			hVo.name = spt.name;
			return hVo;
		}
		return null;
	}
	
	/**
	 * 保存清空舞台历史记录（用于清空舞台）
	 */
	public function saveAllDisplayHistory():void
	{
		var hVo:HistoryVo = new HistoryVo();
		hVo.type = HistoryVo.CLEAR;
		hVo.displayList = [[],[],[]];
		var count:int = Layer.STAGE_BG_LAYER.numChildren;
		for (var i:int = 0; i < count; i++) 
		{
			hVo.displayList[0].push(Layer.STAGE_BG_LAYER.getChildAt(i));
		}
		count = Layer.TERRAIN_LAYER.numChildren;
		for (i = 0; i < count; i++) 
		{
			hVo.displayList[1].push(Layer.TERRAIN_LAYER.getChildAt(i));
		}
		count = Layer.STAGE_FG_LAYER.numChildren;
		for (i = 0; i < count; i++) 
		{
			hVo.displayList[2].push(Layer.STAGE_FG_LAYER.getChildAt(i));
		}
		this.addHistory(hVo);
	}
}
}