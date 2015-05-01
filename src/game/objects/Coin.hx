package game.objects;
import colliders.BoxCollider;
import colliders.Collider;
import colliders.CollisionInformation;
import flash.Vector;
import game.MovieClipPlusPlus;
import game.World;
import haxe.ds.StringMap;
import haxe.macro.Expr.Position;
import starling.core.Starling;
import starling.display.Image;
import starling.display.MovieClip;
import starling.events.EnterFrameEvent;
import starling.textures.Texture;
import utility.ControlManager.ControlAction;
import utility.Point;
import starling.extensions.*;

class Coin extends BaseObject
{
	private var sprite:MovieClipPlusPlus;
	private var collider:BoxCollider;
	private var grounded:Bool = false;
	
	public function new(world:World, xloc:Float, yloc:Float, velX, velY) {
		super(world, xloc, yloc, 0, 0);
		this.velX = velX;
		this.velY = velY;
		
		this.scaleX = 1 / world.tileSize;
		this.scaleY = 1 / world.tileSize;
		
		this.health = 0.0;
		this.maxHealth = 0.0;
		this.strikable = true;
		
		var animations = new StringMap<Vector<Texture>>();
		animations.set("Coin", Root.assets.getTextures("items/Coin"));
	
		this.sprite = new MovieClipPlusPlus(animations, 10);
		this.sprite.pivotX = 0;
		this.sprite.pivotY = 16;
		this.sprite.smoothing = 'none';
		
		this.sprite.changeAnimation("Coin");
		
		addChild(this.sprite);
		
		this.collider = new BoxCollider(this, ["items"], 12, 16, new Point(8, -8));
		addChild(this.collider);
	}
	
	public override function getColliders():Array<Collider> {
		return [this.collider];
	}
	
	public override function update(event:EnterFrameEvent) {
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
		var newPosX = this.x + velX * event.passedTime * 6;

		this.setPos(newPosX, this.y);

		if (!grounded) {

			var dest = world.rayCast(new Point(this.x, this.y), new Point(0, Math.abs(velX) * event.passedTime * -7.6), world.camera.getCameraBounds(world), ["map"]);
			if (dest != null) {// && Math.abs(dest.y - this.y) > 0.0001) {

				//this.y = dest.y + 0.0001;
				this.setPos(newPosX, dest.y - 0.0001);

			} else {

				dest = world.rayCast(new Point(this.x, this.y), new Point(0, Math.abs(velX) * event.passedTime * 7.6), world.camera.getCameraBounds(world), ["map"]);
				if (dest != null) {
					//this.y = dest.y + 0.0001;
					this.setPos(newPosX, dest.y - 0.0001);
				}
			}

		}
		else {
			velX = 0.0;
		}
	
		velY += event.passedTime * 80.0;
	}
	
	public override function collision(self:Collider, object:Collider, collisionInfo:CollisionInformation):Bool {
		var player:Player;
		if (Std.is(object, BaseObject)) {
			player = cast object;
			player.addCoin();
		}
		trace(collisionInfo.);
		return true;
		
	}
	
}