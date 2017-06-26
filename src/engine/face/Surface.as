package engine.face 
{
import flash.display.Graphics;
import flash.geom.Point;
import utils.MathUtil;
/**
 * ...地面
 * 包含地面的属性
 * @author Kanon
 */
public class Surface 
{
	//x坐标
	public var x:Number = 0;
	//y坐标
	public var y:Number = 0;
	//z坐标
	public var z:Number = 0;
	//左边是否阻碍
	public var leftBlock:Boolean;
	//右边是否是阻碍
	public var rightBlock:Boolean;
	//上边是否阻碍
	public var upBlock:Boolean;
	//下边是否是阻碍
	public var downBlock:Boolean;
	//左上点坐标
	public var upLeftPoint:Point;
	//右上点坐标
	public var upRightPoint:Point;
	//左下点坐标
	public var downleftPoint:Point;
	//右下点坐标
	public var downRightPoint:Point;
	//左边上下限制(用于左边相邻的face的upBlock为true时判断)
	public var leftRestrict:Boolean;
	//右边上下限制(用于右边相邻的face的upBlock为true时判断)
	public var rightRestrict:Boolean;
	//名字
	public var name:String;
	//左边高
	protected var _leftH:Number = 0;
	//右边高
	protected var _rightH:Number = 0;
	public function Surface(upLeftX:Number = 0, downLeftX:Number = 0, 
							upRightX:Number = 100, downRightX:Number = 100, 
							upY:Number = 0, downY:Number = 100) 
	{
		this.upLeftPoint = new Point(upLeftX, upY);
		this.upRightPoint = new Point(upRightX, upY);
		this.downleftPoint = new Point(downLeftX, downY);
		this.downRightPoint = new Point(downRightX, downY);
		
		if (!this.validate())
			throw Error("surface is not parallelogram");
	}
	
	/**
	 * 左边高
	 */
	public function get leftH():Number{ return _leftH; }
	public function set leftH(value:Number):void 
	{
		_leftH = value;
		if(value > 0) this.leftBlock = false;
	}
	
	/**
	 * 右边高
	 */
	public function get rightH():Number{ return _rightH; }
	public function set rightH(value:Number):void 
	{
		_rightH = value;
		if(value > 0) this.rightBlock = false;
	}

	/**
	 * 获取上边坐标
	 */
	public function get upPosY():Number
	{
		return this.y + this.upLeftPoint.y;
	}
	
	/**
	 * 获取下边坐标
	 */
	public function get downPosY():Number
	{
		return this.y + this.downRightPoint.y;
	}
	
	/**
	 * 获取左边边界坐标
	 * @param	posY	当前在这个face上的y坐标
	 * @return	左边边界的坐标
	 */
	public function getLeftRange(posY:Number):Number
	{
		if (Math.abs(this.leftSkew) == 90 || 
			Math.abs(this.leftSkew) == 0) return this.x + this.upLeftPoint.x;
		var skew:Number = this.leftSkew;
		if (skew > 90) skew = 180 - this.leftSkew;
		var rand:Number = skew * Math.PI / 180;
		var sh:Number = this.y + this.upLeftPoint.y + this.height - posY;
		var dx:Number;
		if (this.leftSkew < 90) dx = this.height / Math.tan(rand) - sh / Math.tan(rand);
		else dx = sh / Math.tan(rand);
		var leftX:Number = this.upLeftPoint.x;
		if (this.leftSkew > 90) leftX = this.downleftPoint.x;
		return this.x + leftX + dx;
	}
	
	/**
	 * 获取右边边界的坐标
	 * @param	posY	当前在这个face上的y坐标
	 * @return	右边边界的坐标
	 */
	public function getRightRange(posY:Number):Number
	{
		if (Math.abs(this.rightSkew) == 90 ||
			Math.abs(this.rightSkew) == 0) return this.x + this.upRightPoint.x;
		var skew:Number = this.rightSkew;
		if (skew > 90) skew = 180 - this.rightSkew;
		var rand:Number = skew * Math.PI / 180;
		var sh:Number = this.y + this.upLeftPoint.y + this.height - posY;
		var dx:Number;
		if (this.rightSkew < 90) dx = this.height / Math.tan(rand) - sh / Math.tan(rand);
		else dx = sh / Math.tan(rand);
		var rightX:Number = this.upRightPoint.x;
		if (this.rightSkew > 90) rightX = this.downRightPoint.x;
		return this.x + rightX + dx;
	}
	
	/**
	 * 高度
	 */
	public function get height():Number
	{
		return this.downleftPoint.y - this.upLeftPoint.y;
	}
		
	/**
	 * 计算左边的倾斜角度
	 * @return
	 */
	public function get leftSkew():Number
	{
		return MathUtil.getRotation(this.upLeftPoint.x, 
									this.upLeftPoint.y, 
									this.downleftPoint.x, 
									this.downleftPoint.y);
	}
	
	/**
	 * 计算右边的倾斜角度
	 * @return
	 */
	public function get rightSkew():Number
	{
		return MathUtil.getRotation(this.upRightPoint.x, 
									this.upRightPoint.y, 
									this.downRightPoint.x, 
									this.downRightPoint.y);
	}
	
	/**
	 * 是否在横向范围内
	 * @param	posY	body的y坐标
	 * @return
	 */
	public function inVerticalRange(posY:Number):Boolean
	{
		return posY >= this.y + this.upLeftPoint.y && 
				posY <= this.y + this.downleftPoint.y
	}
	
	/**
	 * 是否在左上范围内
	 * @param	posX		body的x坐标
	 * @param	thick		body的厚度
	 * @return
	 */
	public function inLeftUpRange(posX:Number, thick:Number = 0):Boolean
	{
		return posX >= this.x + this.upLeftPoint.x - thick
	}
	
	/**
	 * 是否在右上范围内
	 * @param	posX		body的x坐标
	 * @param	thick		body的厚度
	 * @return
	 */
	public function inRightUpRange(posX:Number, thick:Number = 0):Boolean
	{
		return posX <= this.x + this.upRightPoint.x + thick;
	}
	
	/**
	 * 是否在左边界
	 * @param	posX	body的x坐标
	 * @param	posY	body的y坐标
	 * @param	thick	body的厚度
	 * @return
	 */
	public function inLeft(posX:Number, posY:Number, thick:Number = 0):Boolean
	{
		var leftX:Number = this.getLeftRange(posY);
		if (this.leftBlock) return posX <= leftX + thick;
		else return posX <= leftX - thick;
	}
	
	/**
	 * 是否在右边界
	 * @param	posX	body的x坐标
	 * @param	posY	body的y坐标
	 * @param	thick	body的厚度
	 * @return
	 */
	public function inRight(posX:Number, posY:Number, thick:Number = 0):Boolean
	{
		var rightX:Number = this.getRightRange(posY);
		if (this.leftBlock) return posX >= rightX - thick;
		else return posX >= rightX + thick;
	}

	/**
	 * 是否在上边范围内
	 * @param	posX		当前x坐标
	 * @param	thick		body的厚度
	 * @return
	 */
	public function inUpRange(posX:Number, thick:Number = 0):Boolean
	{
		return posX >= this.x + this.upLeftPoint.x - thick && 
				posX <= this.x + this.upRightPoint.x + thick;
	}
	
	/**
	 * 是否在下边范围内
	 * @param	posX		当前x坐标
	 * @param	thick		body的厚度
	 * @return
	 */
	public function inDownRange(posX:Number, thick:Number = 0):Boolean
	{
		var thickL:Number = thick;
		var thickR:Number = thick;
		if (this.leftBlock || this._leftH > 0) thickL *= -1;
		if (this.rightBlock || this._rightH > 0) thickR *= -1;
		return posX >= this.x + this.downleftPoint.x - thickL && 
				posX <= this.x + this.downRightPoint.x + thickR;
	}
	
	/**
	 * 验证面的合法性
	 * @return
	 */
	public function validate():Boolean
	{
		return this.upLeftPoint.y == this.upRightPoint.y && 
			   this.downleftPoint.y == this.downRightPoint.y;
	}
	
	/**
	 * 是否在面的范围内
	 * @param	posX		body的x坐标
	 * @param	posY		body的y坐标
	 * @param	thick		body的厚度
	 * @return
	 */
	public function inFaceRage(posX:Number, posY:Number, thick:Number = 0):Boolean
	{
		//获取左右x的范围
		var leftX:Number = this.getLeftRange(posY);
		var rightX:Number = this.getRightRange(posY);
		return posX >= leftX - thick && posX <= rightX + thick && this.inVerticalRange(posY);
	}
	
	/**
	 * 绘制
	 * @param	g	画布
	 * @param	lineColor	线条颜色
	 * @param	pointColor	锚点颜色
	 */
	public function debugDraw(g:Graphics, lineColor:uint = 0xFF0000, 
											pointColor:uint = 0xFFFF00, 
											heighColor:uint = 0x0000FF):void
	{
		if (!g) return;
		g.lineStyle(1, lineColor);
		g.moveTo(this.x + this.upLeftPoint.x, this.y + this.upLeftPoint.y)
		g.lineTo(this.x + this.upRightPoint.x, this.y + this.upRightPoint.y)
		
		g.lineStyle(1, lineColor);
		g.moveTo(this.x + this.upLeftPoint.x, this.y + this.upLeftPoint.y)
		g.lineTo(this.x + this.downleftPoint.x, this.y + this.downleftPoint.y)

		g.lineStyle(1, lineColor);
		g.moveTo(this.x + this.downleftPoint.x, this.y + this.downleftPoint.y)
		g.lineTo(this.x + this.downRightPoint.x, this.y + this.downRightPoint.y)

		g.lineStyle(1, lineColor);
		g.moveTo(this.x + this.upRightPoint.x, this.y + this.upRightPoint.y)
		g.lineTo(this.x + this.downRightPoint.x, this.y + this.downRightPoint.y)
		
		if (this.leftBlock || this._leftH > 0)
		{	
			
			g.lineStyle(1, heighColor);
			g.moveTo(this.x + this.upLeftPoint.x, this.y + this.upLeftPoint.y)
			g.lineTo(this.x + this.upLeftPoint.x, this.y + this.upLeftPoint.y - this._leftH)

			g.lineStyle(1, heighColor);
			g.moveTo(this.x + this.downleftPoint.x, this.y + this.downleftPoint.y)
			g.lineTo(this.x + this.downleftPoint.x, this.y + this.downleftPoint.y - this._leftH)

			g.lineStyle(1, heighColor);
			g.moveTo(this.x + this.upLeftPoint.x, this.y + this.upLeftPoint.y - this._leftH)
			g.lineTo(this.x + this.downleftPoint.x, this.y + this.downleftPoint.y - this._leftH)
		}
					
		//右边高度
		if (this.rightBlock || this._rightH > 0)
		{
			g.lineStyle(1, heighColor);
			g.moveTo(this.x + this.upRightPoint.x, this.y + this.upRightPoint.y)
			g.lineTo(this.x + this.upRightPoint.x, this.y + this.upRightPoint.y - this._rightH)

			g.lineStyle(1, heighColor);
			g.moveTo(this.x + this.downRightPoint.x, this.y + this.downRightPoint.y)
			g.lineTo(this.x + this.downRightPoint.x, this.y + this.downRightPoint.y - this._rightH)
			
			g.lineStyle(1, heighColor);
			g.moveTo(this.x + this.upRightPoint.x, this.y + this.upRightPoint.y - this._rightH)
			g.lineTo(this.x + this.downRightPoint.x, this.y + this.downRightPoint.y - this._rightH)
		}
		g.beginFill(pointColor);
		g.drawCircle(this.x, this.y, 3);
		g.endFill();
	}
}
}