package game.objects;
import colliders.BoxCollider;
import colliders.Collider;
import starling.display.Image;
import starling.events.EnterFrameEvent;
import utility.Point;

class Player extends BaseObject
{

	private var sprite:Image;
	private var collider:BoxCollider;
	
	
	public function new() 
	{
		
		super();
		
		this.pivotX = 16;
		this.pivotY = 32;
		
		this.sprite = new Image(Root.assets.getTexture("player/Player"));
		addChild(this.sprite);
		
		this.collider = new BoxCollider(this, ["player"], 32, 64, new Point(16, 32));
		addChild(this.collider);
		
	}
	
	public override function awake() {
		
	}
	public override function sleep() {
		
	}
	
	public override function update(event:EnterFrameEvent) {
		
		var left = Root.controls.isDown("left") ? -1 : 0;
		var right = Root.controls.isDown("right") ? 1 : 0;
		var up = Root.controls.isDown("up") ? -1 : 0;
		var down = Root.controls.isDown("down") ? 1 : 0;
		
		var hor = left + right;
		var vert = up + down;
		
		var newPosX = this.x + hor * event.passedTime * 7.5;
		var newPosY = this.y + velY * event.passedTime;
		
		velY += event.passedTime * 10.0;
		//var newPosY = this.y + vert * event.passedTime * 1;
		
		this.setPos(newPosX, newPosY);
	}
	
	
	public override function getColliders():Array<Collider> {
		return [this.collider];
	}
}