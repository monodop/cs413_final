package game.objects;
import starling.events.EnterFrameEvent;
import flash.geom.Rectangle;
import utility.Point;


class AI extends BaseObject
{
	var direction:Bool = true;
	
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

	/*public function Attack(){
		var dir = new Point(this.x - player.x, this.y - player.y);
		dir = dir.normalize(5);
		if(rayCast(newPoint(this.x, this.y), new Point()))
	
	}*/

	public override function update(event:EnterFrameEvent) {
		this.Patrol(event);
	
	}






}