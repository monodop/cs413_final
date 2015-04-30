package game.objects;
import colliders.Collider;
import colliders.CollisionInformation;
import colliders.HasCollider;
import colliders.Quadtree;
import game.World;
import starling.display.Sprite;
import starling.events.EnterFrameEvent;

class BaseObject extends Sprite implements HasCollider
{
	
	public var velX:Float = 0.0;
	public var velY:Float = 0.0;
	private var world:World;
	
	private var strikable:Bool = false;
	private var health:Float = 0.0;
	private var maxHealth:Float = 0.0;

	public function new(world:World) 
	{
		this.world = world;
		super();
	}
	
	public function awake() {
		
	}
	
	public function sleep() {
		
	}
	
	public function update(event:EnterFrameEvent) {
		
	}
	
	override public function dispose():Void 
	{
		//this.sleep();
		this.removeChildren(0, -1, true);
		super.dispose();
	}
	
	
	// HasCollider required methods
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
	
	public function isStrikable():Bool {
		return this.strikable;
	}
	
	public function damage(amt:Float) {
		if (!isDead()) {
			health -= amt;
			if (health < 0) {
				killed( -health);
				health = 0.0;
			}
		}
	}
	
	private function killed(overflow:Float) { world.removeObject(this); this.dispose(); }
	
	public function isDead():Bool {
		return health == 0;
	}
	
}