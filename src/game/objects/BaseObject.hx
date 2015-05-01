package game.objects;
import colliders.Collider;
import colliders.CollisionInformation;
import colliders.HasCollider;
import colliders.Quadtree;
import starling.events.Event;
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

	public function new(world:World, ?x:Float=0.0, ?y:Float=0.0, ?offsetX:Float=0.0, ?offsetY:Float=0.0) 
	{
		super();
		this.x = x+offsetX;
		this.y = y+offsetY;
		this.pivotX += offsetX;
		this.pivotY += offsetY;
		this.world = world;

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
			addHealth( -amt);
			if (health < 0) {
				killed( -health);
				updateHealth(0);
			}
		}
	}
	
	public function getHealth():Float {
		return this.health;
	}
	public function getMaxHealth():Float {
		return this.maxHealth;
	}
	
	public function updateHealth(amt:Float) {
		health = amt;
		dispatchEvent(new Event("healthChanged"));
	}
	public function addHealth(amt:Float) {
		updateHealth(this.health + amt);
	}
	
	private function killed(overflow:Float) { world.removeObject(this); this.dispose(); }
	
	public function isDead():Bool {
		return health == 0;
	}
	
}