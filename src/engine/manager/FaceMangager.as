package engine.manager 
{
import engine.body.Body;
import engine.face.Surface;
import flash.display.Graphics;
/**
 * ...面管理
 * @author Kanon
 */
public class FaceMangager 
{
	public static var faceAry:Array = [];
	
	/**
	 * 添加一个面到管理池中
	 * @param	face	面
	 */
	public static function add(face:Surface):void
	{
		faceAry.push(face);
	}
	
	public static function clear():void
	{
		faceAry = [];
	}
	
	/**
	 * 禁锢一个物体在face上
	 * @param	face		面
	 * @param	body		物体
	 */
	public static function cageInFace(face:Surface, body:Body):void
	{
		if (!face || !body) return;
		if (face.upBlock && body.y < face.upPosY)
			body.y = face.upPosY;
			
		if (face.downBlock && body.y > face.downPosY)
			body.y = face.downPosY;
		
		if (face.leftBlock || face.leftH > 0)
		{
			var leftX:Number = face.getLeftRange(body.y) + body.thick;
			if (body.x < leftX) body.x = leftX;
		}
		
		if (face.rightBlock || face.rightH > 0)
		{
			var rightX:Number = face.getRightRange(body.y) - body.thick;
			if (body.x > rightX) body.x = rightX;
		}
	}
	
	/**
	 * 搜索跳跃腾空时当前脚底下的face
	 * @param	body	物体
	 * @return
	 */
	public static function seachSameDepthCurRangeFace(body:Body):Surface
	{
		if (!body.prevFace) return null;
		var count:int = faceAry.length;
		var dis:Number = Infinity;
		for (var i:int = 0; i < count; i++) 
		{
			var face:Surface = faceAry[i];
			var curFace:Surface;
			if (face.z == body.prevZ)
			{
				//计算 body.prevY  高度
				var height:Number = face.downPosY - body.prevFace.downPosY;
				var posY:Number = body.prevFaceY + height;
				if (face.inFaceRage(body.x, posY, body.thick) && body.y <= posY)
				{
					var curDis:Number = posY - body.y;
					if (curDis < dis)
					{
						dis = curDis;
						curFace = face;
					}
				}
			}
		}
		return curFace;
	}
	
	/**
	 * 在一个面上判断上下是否有限制(用于两边相邻的face的upBlock为true时判断)
	 * @param	face		面
	 * @param	body		物体
	 */
	public static function restrictInFace(face:Surface, body:Body):void
	{
		if (!face || !body) return;
		if (face.leftRestrict)
		{
			if (body.x - body.thick < face.x + face.upLeftPoint.x)
			{
				if (body.y < face.y + face.upLeftPoint.y)
					body.y = face.y + face.upLeftPoint.y;
			}
		}
		if (face.rightRestrict)
		{
			if (body.x + body.thick > face.x + face.upRightPoint.x)
			{
				if (body.y < face.y + face.upRightPoint.y)
					body.y = face.y + face.upRightPoint.y;
			}
		}
	}
	
	/**
	 * 搜索面
	 * @param	x		body的x坐标
	 * @param	y		body的y坐标
	 * @param	thick	body的厚度
	 * @return	搜索到的面
	 */
	public static function seachLinkFace(x:Number, 
										y:Number, 
										thick:Number = 0):Surface
	{
		var count:int = faceAry.length;
		for (var i:int = 0; i < count; i++) 
		{
			var face:Surface = faceAry[i];
			if (face.inFaceRage(x, y, thick))
			{
				return face;
			}
		}
		return null;
	}
	
	/**
	 * 搜索向上跳跃时body在face的范围内
	 * @param	x			body的x坐标	
	 * @param	z			body的z坐标
	 * @param	thick		body的厚度
	 * @return	搜索到面的数组
	 */
	public static function seachTopJumpFaceRange(x:Number, z:Number, thick:Number = 0):Array
	{
		var arr:Array = [];
		var count:int = faceAry.length;
		for (var i:int = 0; i < count; i++) 
		{
			var face:Surface = faceAry[i];
			if (z + 1 == face.z && face.inDownRange(x, thick))
				arr.push(face);
			if (z == face.z && face.inUpRange(x, thick))
				arr.push(face);
		}
		arr.sort(function(a:Surface, b:Surface):Number { return a.z > b.z ? 1 : -1});
		return arr;
	}
	
	/**
	 * 搜索face的底部区域跳跃时body在face的范围内
	 * @param	x			body的x坐标	
	 * @param	z			body的z坐标
	 * @param	thick		body的厚度
	 * @return	搜索到面的数组
	 */
	public static function seachBottomJumpFaceRange(x:Number, z:Number, thick:Number = 0):Array
	{
		var arr:Array = [];
		var count:int = faceAry.length;
		for (var i:int = 0; i < count; i++) 
		{
			var face:Surface = faceAry[i];
			//向下查找
			if (z - 1 == face.z && face.inUpRange(x, thick))
				arr.push(face);
			//同级查找
			if (z == face.z && face.inDownRange(x, thick))
				arr.push(face);
		}
		arr.sort(function(a:Surface, b:Surface):Number { return a.z > b.z ? 1 : -1});
		return arr;
	}
	
	/**
	 * 获取两个face之间的间距
	 * @param	face1		面1
	 * @param	face2		面2
	 * @return	高度
	 */
	public static function getGapBetweenFace(face1:Surface, face2:Surface):Number
	{
		if (!face1 || !face2) return 0;
		return Math.abs(face1.downPosY - face2.downPosY);
	}
	
	/**
	 * * 判断两个face是否在同一y坐标上
	 * @param	face1		面1
	 * @param	face2		面2
	 * @return	是否在同一y坐标上
	 */
	public static function isEqualPosY(face1:Surface, face2:Surface):Boolean
	{
		if (!face1 || !face2) return false;
		return face1.z == face2.z && getGapBetweenFace(face1, face2) == 0;
	}
	
	/**
	 * debug 所有的face
	 * @param	g			绘图容器
	 * @param	lineColor	线条颜色
	 * @param	pointColor	锚点颜色
	 */
	public static function debugFace(g:Graphics, lineColor:uint = 0xFF0000, 
												 pointColor:uint = 0xFFFF00, 
												 heighColor:uint = 0x0000FF):void
	{
		if (!g) return;
		g.clear();
		var count:int = faceAry.length;
		for (var i:int = 0; i < count; i++) 
		{
			var face:Surface = faceAry[i];
			face.debugDraw(g, lineColor, pointColor, heighColor);
		}
	}
	
	/**
	 * 创建面的地图
	 * @param	dataStr		数据字符串 json格式
	 */
	public static function createFaceMap(dataStr:String):void
	{
		FaceMangager.createFaceMapByData(JSON.parse(dataStr));
	}
	
	/**
	 * 创建面的地图
	 * @param	data		数据
	 */
	public static function createFaceMapByData(data:Object):void
	{
		var arr:Array = data as Array;
		var count:int = arr.length;
		for (var i:int = 0; i < count; i++) 
		{
			var data:Object = arr[i];
			var face:Surface = new Surface(data.upLeftX, data.downLeftX,
											data.upRightX, data.downRightX, 
											data.upY, data.downY);
			face.name = data.name;
			face.x = data.x;
			face.y = data.y;
			face.z = data.depth;
			face.leftBlock = data.leftBlock;
			face.rightBlock = data.rightBlock;
			face.upBlock = data.upBlock;
			face.downBlock = data.downBlock;
			face.leftH = data.leftH;
			face.rightH = data.rightH;
			face.leftRestrict = data.leftRestrict;
			face.rightRestrict = data.rightRestrict;
			FaceMangager.add(face);
		}
	}
}
}