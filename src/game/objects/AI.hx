package game.objects;
import starling.events.EnterFrameEvent;
import flash.geom.Rectangle;
import utility.Point;
import colliders.CollisionInformation;
import haxe.Timer;

class AI extends BaseObject
{
	var direction:Bool = true;
	var attackRange:Float = 0.0;
	var attackSpeed:Float = 0.0;
	var attackTimer:Float;
	var canAttack:Bool = false;
	var attackDamage:Float = 0.0;
	
	public function new(world:World, ?x:Float=0.0, ?y:Float=0.0, ?offsetX=0.0, ?offsetY=0.0) {
		super(world, x, y, offsetX, offsetY);
		attackTimer = attackSpeed;
	}
	
	
	public function Patrol(event:EnterFrameEvent) {
		if (direction)
			setPos(this.x+1*event.passedTime, this.y);
		else
			setPos(this.x-1*event.passedTime, this.y);
		if(world.rayCast(new Point(this.x, this.y), new Point(1, 1), new Rectangle(this.x-1, this.y-1, 2, 2), ["map"]) == null)
			direction = false;	
		else if(world.rayCast(new Point(this.x, this.y), new Point(-1, -1), new Rectangle(this.x-1, this.y-1, 2, 2), ["map"]) == null)
			direction = true;
			
	}
	
	public function Advance(event:EnterFrameEvent) {
		if(this.x<world.player.x) {
			setPos(this.x+1*event.passedTime, this.y);
			direction = true;
		}
		else if(this.x>world.player.x) {
			setPos(this.x-1*event.passedTime, this.y);
			direction = false;
		}
		if(world.rayCast(new Point(this.x, this.y), new Point(1, 1), new Rectangle(this.x-1, this.y-1, 2, 2), ["map"]) == null)
			setPos(this.x, this.y+1*event.passedTime);
		if(world.rayCast(new Point(this.x, this.y), new Point(-1, -1), new Rectangle(this.x-1, this.y-1, 2, 2), ["map"]) == null)
			setPos(this.x, this.y+1*event.passedTime);
	
	}
	
	public function Attack(event:EnterFrameEvent) {
		// attack
		var ci = new Array<CollisionInformation>();
		var hit = world.rayCast(new Point(x, y - 1.0), new Point((direction ? 1 : -1)* attackRange, 0.0), world.camera.getCameraBounds(world), ["player", "map"], 0.0, ci);
		if(hit != null) {
			var hitCollider = ci[0].collider_src.parent;
			if (Std.is(hitCollider, BaseObject)) {
				trace("ATTACK");
				var target:BaseObject = cast hitCollider;
				target.damage(attackDamage);
			}
		}
	
	}

	public override function update(event:EnterFrameEvent) {
		var dir = new Point(world.player.x - this.x, world.player.y - this.y);
		dir = dir.normalize(5);
		var ci = new Array<CollisionInformation>();
		var hitpoint:Point;
		hitpoint = world.rayCast(new Point(this.x, this.y - 0.5), dir, new Rectangle(this.x-5, this.y-5, 10, 10), ["map", "player"], 0.0, ci);
		if(hitpoint == null || !Std.is(ci[0].collider_src.parent, Player))
			this.Patrol(event);
		else if((new Point(this.x, this.y - 0.5)).distance(new Point(world.player.x, world.player.y)) >= attackRange)
			this.Advance(event);
		else{
			if(!canAttack){
				attackTimer -= event.passedTime*1000;
				if(attackTimer<=0){
					attackTimer = 0;
					canAttack = true;
				}
			}
			if(canAttack){
				canAttack=false;
				this.Attack(event);
				attackTimer = attackSpeed;
			}
		}
	
	}






}