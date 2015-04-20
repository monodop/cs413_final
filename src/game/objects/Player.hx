package game.objects;
import colliders.BoxCollider;
import colliders.Collider;
import colliders.CollisionInformation;
import haxe.macro.Expr.Position;
import starling.core.Starling;
import starling.display.Image;
import starling.display.MovieClip;
import starling.events.EnterFrameEvent;
import utility.ControlManager.ControlAction;
import utility.Point;
import starling.extensions.*;

class Player extends BaseObject
{

	private var sprite:MovieClip;
	private var collider:BoxCollider;
	private var grounded:Bool;
	public var snowWalkPS:PDParticleSystem;
	public var tileSize:Float = 16;
	
	public function new(world:World) 
	{
		
		super(world);
		
		this.pivotX = 0;
		this.pivotY = -4;
		
		this.sprite = new MovieClip(Root.assets.getTextures("player/Player_Walk"), 10);
		this.sprite.pivotX = 32;
		this.sprite.pivotY = 64;
		this.sprite.smoothing = 'none';
		addChild(this.sprite);
		
		this.collider = new BoxCollider(this, ["player"], 32, 64, new Point(0, -32));
		addChild(this.collider);
		
		snowWalkPS = new PDParticleSystem(Root.assets.getXml("snow_walk_particle_config"), Root.assets.getTexture("particles/snow_walk_particle"));
		snowWalkPS.emitterX = this.x * tileSize * 2;
		snowWalkPS.emitterY = this.y * tileSize * 2;
		snowWalkPS.scaleX = 1 / tileSize / 2;
		snowWalkPS.scaleY = 1 / tileSize / 2;
		world.addChild(snowWalkPS);
		Starling.juggler.add(snowWalkPS);
		
	}
	
	public override function awake() {
		Root.controls.hook("up", "playerJump", jump);
	}
	public override function sleep() {
		Root.controls.unhook("up", "playerJump");
	}
	
	public function jump(action:ControlAction) {
		if(action.isActive())
			velY = -20;
	}
	
	public override function update(event:EnterFrameEvent) {
		
		this.sprite.advanceTime(event.passedTime);
		
		var left = Root.controls.isDown("left") ? -1 : 0;
		var right = Root.controls.isDown("right") ? 1 : 0;
		var up = Root.controls.isDown("up") ? -1 : 0;
		var down = Root.controls.isDown("down");
		
		var hor = left + right;
		
		snowWalkPS.start();
		
		if (hor < 0) {
			this.scaleX = -(Math.abs(this.scaleX));
			snowWalkPS.emitAngle = utility.Utils.deg2rad(221.64 + 90);
		}
		else if (hor > 0) {
			this.scaleX = Math.abs(this.scaleX);
			snowWalkPS.emitAngle = utility.Utils.deg2rad(221.64);
		}
		else {
			snowWalkPS.stop();
		}
		
		var oldX = this.x;
		var oldY = this.y;
		
		var newPosY = this.y + velY * event.passedTime;
		
		var ci = new Array<CollisionInformation>();
		var dest = world.rayCast(new Point(oldX, oldY - 0.0001), new Point(0, velY * event.passedTime), world.camera.getCameraBounds(world), ["map"], 0.0001, ci);
		if (velY >= 0 && dest != null && !ci[0].collider_src.containsPoint(new Point(dest.x, dest.y - 0.0001), world)) {
			this.setPos(this.x, dest.y);
			this.velY = 0;
			grounded = true;
		}
		else {
			this.setPos(this.x, newPosY);
			grounded = false;
		}
		
		var newPosX = this.x + hor * event.passedTime * 7.5;
		
		var oldX = this.x;
		var oldY = this.y;
		
		this.setPos(newPosX, this.y);
		
		if (grounded) {
			
			var ci = new Array<CollisionInformation>();
			var dest = world.rayCast(new Point(this.x, this.y), new Point(0, -0.15), world.camera.getCameraBounds(world), ["map"], 0.0, ci);
			if (dest != null && Math.abs(dest.y - this.y) > 0.0001) {
				
				this.y = dest.y + 0.0001;
				
			}
			
		}
		else {
			snowWalkPS.stop();
		}
		
		velY += event.passedTime * 80.0;
		
		snowWalkPS.emitterX = this.x * tileSize * 2;
		snowWalkPS.emitterY = this.y * tileSize * 2;
	}
	
	
	public override function getColliders():Array<Collider> {
		return [this.collider];
	}
	
	//public override function collision(self:Collider, object:Collider, collisionInfo:CollisionInformation):Bool {
		//
		//var b = object.getBounds(world);
		//if (Root.controls.isDown("down")) { return false; }
		//if (this.y - 0.25 > b.top) {
			//return false;
		//}
		//
		//return true;
		//
	//}
}