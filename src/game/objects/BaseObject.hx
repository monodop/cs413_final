package game.objects;
import colliders.Collider;
import colliders.CollisionInformation;
import colliders.HasCollider;
import colliders.Quadtree;
import starling.display.Sprite;

class BaseObject extends Sprite implements HasCollider
{

	public function new() 
	{
		super();
	}
	
	public function getColliders():Array<Collider> {
		return [];
	}
	public function collision(self:Collider, object:Collider, collisionInfo:CollisionInformation):Bool {
		return true;
	}
	public function updateColliders():Void {
		for (collider in getColliders())
			collider.updateQuadtree();
	}
	public function setPos(x:Float, y:Float):Void {
		this.x = x;
		this.y = y;
		updateColliders();
	}
	
}