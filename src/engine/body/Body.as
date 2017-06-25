package engine.body 
{
import engine.face.Surface;
import engine.manager.FaceMangager;
import flash.display.DisplayObject;
/**
 * ...物体
 * TODO 
 * [绘制出face的高度]
 * [区分跳跃和链接]
 * [区分下落和链接]
 * [区分跳跃时下落和移动时下落]
 * [跳跃时限制左右移动]
 * [跳跃时不判断face的cage]
 * [跳跃后触底在判断face]
 * [跨高度搜索face]
 * [block边跳跃反弹]
 * [跳跃判断高度]
 * [碰壁后反弹]
 * @author Kanon
 */
public class Body 
{
	//方向常量
	public static const NONE:int = 0;
	public static const LEFT:int = 1;
	public static const RIGHT:int = 2;
	public static const UP:int = 3;
	public static const DOWN:int = 4;
	//是否跳跃状态
	private var isJump:Boolean;
	//body在face上的纵向位置
	private var positionVerticalState:int;
	//---public---
	//速度
	public var vx:Number = 0;
	public var prevVx:Number = 0;
	public var vy:Number = 0;
	public var jumpVx:Number = 0;
	public var jumpVy:Number = 0;
	//下落之前的y坐标
	public var prevFaceY:Number;
	//当前帧的坐标
	public var x:Number = 0;
	public var y:Number = 0;
	//上一帧的坐标
	public var prevX:Number = 0;
	public var prevY:Number = 0;
	public var prevZ:Number = 0;
	//重力
	public var g:Number = .98;
	//当前所在的地面
	public var face:Surface;
	public var prevFace:Surface;
	//显示对象
	public var display:DisplayObject;
	//厚度
	public var thick:Number = 0;
	//方向
	public var direction:int;
	
	public var tempFace:Surface;
	public function Body() 
	{
		
	}
	
	/**
	 * 更新方向
	 */
	protected function updateDirection():void
	{
		if (this.vx > 0)
			this.direction = RIGHT;
		else if (this.vx < 0)
			this.direction = LEFT;
		else
			this.direction = NONE;
	}
	
	/**
	 * 更新位置
	 */
	protected function updatePosition():void
	{
		this.prevX = this.x;
		this.prevY = this.y;
		this.x += this.vx;
		this.x += this.jumpVx;
		this.y += this.jumpVy;
		if (this.face)
		{
			this.y += this.vy;
			this.jumpVy = 0;
		}
		else 
		{
			//fall
			this.jumpVy += this.g;
		}
	}
	
	/**
	 * 更新面
	 */
	protected function updateFace():void
	{
		if (this.face)
		{
			//禁锢
			FaceMangager.cageInFace(this.face, this);
			//face边界限制上下
			FaceMangager.restrictInFace(this.face, this);
			if (!this.face.inFaceRage(this.x, this.y, this.thick))
			{
				this.prevFaceY = this.y;
				this.prevFace = this.face;
				this.prevZ = this.face.z;
				this.face = FaceMangager.seachLinkFace(this.x, this.y, this.thick);
			}
		}
		else
		{
			if (!this.isJump)
			{
				var count:int;
				var posY:Number;
				var faceAry:Array;
				var i:int;
				var face:Surface;
				var nextFace:Surface;
				var height:Number;
				var curPosY:Number;
				if (!this.prevFace || this.jumpVy == 0)
				{
					//非跳跃时的face链接
					this.face = FaceMangager.seachLinkFace(this.x, this.y, this.thick);
				}
				else
				{
					//非跳跃时的下落face搜索
					count = FaceMangager.faceAry.length;
					posY = this.prevFaceY;
					for (i = 0; i < count; ++i)
					{
						face = FaceMangager.faceAry[i];
						nextFace = null;
						if (this.prevFace != face)
						{
							if (this.prevZ == face.z)
							{
								//同一层的face
								height = face.downPosY - this.prevFace.downPosY;
								curPosY = this.prevFaceY + height;
								if (face.inFaceRage(this.x, curPosY, this.thick))
								{
									posY = curPosY;
									nextFace = face;
								}
							}
							else if (this.prevZ - 1 == face.z)
							{
								//下一层 
								if (face.inUpRange(this.x, this.thick) && this.positionVerticalState == DOWN)
								{
									posY = face.upPosY;
									nextFace = face;
								}
							}
						}
						if (nextFace && this.y >= posY && this.prevY < posY)
						{
							trace(nextFace.name, posY);
							this.touchDown(nextFace, posY);
							return;
						}
					}
				}
			}
			else
			{
				if (this.jumpVy >= 0)
				{
					//trace("positionState", this.positionState);
					if (this.positionVerticalState == UP)
					{
						faceAry = FaceMangager.seachTopJumpFaceRange(this.x, this.prevZ, this.thick);
						count = faceAry.length; 
						posY = Infinity;
						for (i = 0; i < count; i++)
						{
							face = faceAry[i];
							if (this.prevZ + 1 == face.z)
							{
								//上一层
								posY = face.downPosY;
							}
							else if (this.prevZ == face.z)
							{
								posY = face.upPosY;
							}
							if (this.y >= posY && this.prevY < posY)
							{
								this.touchDown(face, posY);
								return;
							}
						}
					}
					else if (this.positionVerticalState == NONE)
					{
						if (this.jumpVx == 0)
						{
							//原地跳跃
							if (this.y >= this.prevFaceY && this.prevY < this.prevFaceY)
							{
								this.touchDown(this.prevFace, this.prevFaceY);
								return;
							}
						}
						else
						{
							//左右跳跃
							count = FaceMangager.faceAry.length;
							posY = this.prevFaceY;
							for (i = 0; i < count; ++i)
							{
								face = FaceMangager.faceAry[i];
								nextFace = null;
								if (this.prevZ == face.z)
								{
									//同一层的face
									height = face.downPosY - this.prevFace.downPosY;
									curPosY = this.prevFaceY + height;
									if (face.inFaceRage(this.x, curPosY, this.thick))
									{
										posY = curPosY;
										nextFace = face;
									}
								}
								if (nextFace && this.y >= posY && this.prevY < posY)
								{
									this.touchDown(nextFace, posY);
									return;
								}
							}
						}
					} 
					else if (this.positionVerticalState == DOWN)
					{
						if (this.jumpVx == 0)
						{
							//原地跳跃
							if (this.y >= this.prevFaceY && this.prevY < this.prevFaceY)
							{
								this.touchDown(this.prevFace, this.prevFaceY);
								return;
							}
						}
						else
						{
							//左右跳跃
							faceAry = FaceMangager.seachBottomJumpFaceRange(this.x, this.prevZ, this.thick);
							count = faceAry.length;
							posY = this.prevFaceY;
							for (i = 0; i < count; i++)
							{
								face = faceAry[i];
								nextFace = null;
								if (this.prevZ - 1 == face.z)
								{
									//下层
									posY = face.upPosY;
									nextFace = face;
								}
								else if (this.prevZ == face.z)
								{
									//同层
									posY = face.downPosY;
									nextFace = face;
								}
								if (nextFace && this.y >= posY && this.prevY < posY)
								{
									this.touchDown(nextFace, posY);
									return;
								}
							}
						}
					}
				}
			}
		}
	}
	
	/**
	 * 跳跃时限制高度
	 */
	protected function jumpCage():void
	{
		if (!this.isJump) return;
		var face:Surface = FaceMangager.seachSameDepthCurRangeFace(this);
		tempFace = face;
		if (tempFace) trace("face", tempFace.name);
		if (face)
		{
			var height:Number = face.downPosY - this.prevFace.downPosY;
			var posY:Number = this.prevFaceY + height;
			if (face.inLeft(this.x, posY, this.thick) && this.jumpVx < 0)
			{
				trace("left face ", face.name,  face.leftBlock);
				trace("this.y ", this.y,  this.prevFaceY - face.leftH);
				if (this.y >= this.prevFaceY - face.leftH || face.leftBlock)
					this.blockSpring();
			}
			else if (face.inRight(this.x, posY, this.thick) && this.jumpVx > 0)
			{
				trace("right face ", face.name,  face.leftBlock);
				if (this.y >= this.prevFaceY - face.rightH || face.rightBlock)
					this.blockSpring();
			}
		}
	}
	
	/**
	 * 碰壁反弹
	 */
	protected function blockSpring():void
	{
		this.jumpVx = -this.jumpVx;
	}
	
	/**
	 * 触地
	 * @param	face		所在的face
	 * @param	posY		y坐标位置
	 */
	protected function touchDown(face:Surface, posY:Number):void
	{
		this.isJump = false;
		this.face = face;
		this.y = posY;
		this.jumpVx = 0;
		this.jumpVy = 0;
		this.vx = 0;
		this.vy = 0;
	}
	
	/**
	 * 更新跳跃的横向速度
	 */
	protected function updateJumpVx():void
	{
		if (this.isJump)
		{
			if (this.vx != 0)
			{
				this.jumpVx = this.vx;
				this.prevVx = this.vx;
				this.vx = 0;
			}
		}
	}
	
	/**
	 * 更新显示
	 */
	protected function updateDisplay():void
	{
		if (this.display)
		{
			this.display.x = this.x;
			this.display.y = this.y;
		}
	}
	
	/**
	 * 更新body在face的位置状态
	 * @param	face		当前所在的face
	 */
	protected function updateFacePosState(face:Surface):void
	{
		if (!face) return;
		//在 顶部 跳跃
		if (this.y <= face.upPosY)
			this.positionVerticalState = UP;
		else if (this.y >=face.downPosY)
			this.positionVerticalState = DOWN;
		else 
			this.positionVerticalState = NONE;
			
/*		if (face.inLeft(this.x, this.y, this.thick))
			this.positionHorizontalState = LEFT;
		else if (face.inRight(this.x, this.y, this.thick))
			this.positionHorizontalState = RIGHT;
		else
			this.positionHorizontalState = NONE;
			
		trace("this.positionHorizontalState", this.positionHorizontalState);*/
	}
	
	/**
	 * 跳跃
	 * @param	speed	速度
	 */
	public function jump(speed:Number):void
	{
		if (this.isJump || !this.face) return;
		this.prevFaceY = this.y;
		trace("this.prevFaceY", this.prevFaceY);
		this.jumpVy = -speed;
		this.isJump = true;
		this.prevZ = this.face.z;
		this.prevFace = this.face;
		this.face = null;
	}
	
	/**
	 * 横向移动
	 * @param	vx	速度
	 */
	public function moveH(vx:Number):void
	{
		if (this.isJump || !this.face) return;
		this.vx = vx;
	}
	
	/**
	 * 纵向移动
	 * @param	vy	速度
	 */
	public function moveV(vy:Number):void
	{
		if (this.isJump || !this.face) return;
		this.vy = vy;
	}
	
	/**
	 * 更新
	 */
	public function update():void
	{
		this.updateDirection();
		this.updatePosition();
		this.updateJumpVx();
		this.updateFacePosState(this.face);
		this.updateFace();
		this.jumpCage();
		this.updateDisplay();
	}
}
}