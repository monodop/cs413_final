package game.objects;
import starling.events.EnterFrameEvent;
import flash.geom.Rectangle;
import utility.Point;
import colliders.CollisionInformation;


class AI extends BaseObject
{
	var direction:Bool = true;
	var attackRange:Float;
	public function Patrol(event:EnterFrameEvent){
		if (direction)
			setPos(this.x+1*event.passedTime, this.y);
		else
			setPos(this.x-1*event.passedTime, this.y);
		if(world.rayCast(new Point(this.x, this.y), new Point(1, 1), new Rectangle(this.x-1, this.y-1, 2, 2), ["map"]) == null)
			direction = false;	
		else if(world.rayCast(new Point(this.x, this.y), new Point(-1, -1), new Rectangle(this.x-1, this.y-1, 2, 2), ["map"]) == null)
			direction = true;
			
	}

	public function Advance(event:EnterFrameEvent){
		if(this.x<world.player.x)
			setPos(this.x+1*event.passedTime, this.y);
		else if(this.x>world.player.x)
			setPos(this.x-1*event.passedTime, this.y);
		if(world.rayCast(new Point(this.x, this.y), new Point(1, 1), new Rectangle(this.x-1, this.y-1, 2, 2), ["map"]) == null)
			setPos(this.x, this.y+1*event.passedTime);
		if(world.rayCast(new Point(this.x, this.y), new Point(-1, -1), new Rectangle(this.x-1, this.y-1, 2, 2), ["map"]) == null)
			setPos(this.x, this.y+1*event.passedTime);
	
	}

	public override function update(event:EnterFrameEvent) {
		var dir = new Point(world.player.x - this.x, world.player.y - this.y);
		dir = dir.normalize(5);
		var ci = new Array<CollisionInformation>();
		var hitpoint:Point;
		hitpoint = world.rayCast(new Point(this.x, this.y - 0.5), dir, new Rectangle(this.x-5, this.y-5, 10, 10), ["map", "player"], 0.0, ci);
		if(hitpoint == null || !Std.is(ci[0].collider_src.parent, Player))
			this.Patrol(event);
		else if((new Point(this.x, this.y - 0.5)).distance(new Point(world.player.x, world.player.y)) <= 2)
			this.Advance(event);
		else
			this.Advance(event);
		//else
		//	this.Attack();
	
	}






}