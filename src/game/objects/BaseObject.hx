package game.objects;
import colliders.Collider;
import colliders.CollisionInformation;
import colliders.HasCollider;
import colliders.Quadtree;
import flash.geom.Rectangle;
import starling.events.Event;
import game.World;
import starling.display.Sprite;
import starling.events.EnterFrameEvent;
import haxe.Timer;
import starling.filters.ColorFilter;
import starling.filters.PixelateFilter;
import starling.filters.SelectorFilter;
import utility.Point;
import flash.media.SoundTransform;

class BaseObject extends Sprite implements HasCollider
{
	
	public var velX:Float = 0.0;
	public var velY:Float = 0.0;
	private var world:World;
	
	private var strikable:Bool = false;
	private var health:Float = 0.0;
	private var maxHealth:Float = 0.0;
	
	private var grounded:Bool = false;

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
		var noise:Int = Std.random(3) + 1;
		Root.assets.playSound("Hit_Sound_" + Std.string(noise), 0, 0, new SoundTransform(0.1, 0.1));
		if (!isDead()) {
			addHealth( -amt);
            this.setColor(0.9, 0.9, 0.25, 1.0);
            Timer.delay(function() {
				this.clearColor();
            }, 50);
			if (health <= 0) {
				killed( -health);
				updateHealth(0);
			}
		}
	}
	
	public function walk(event:EnterFrameEvent, moveSpeed:Float, hor:Float, ?layers:Array<String>) {
		
		if (layers == null)
			layers = ["map"];
		
		var newPosX = this.x + hor * event.passedTime * moveSpeed;

		var oldX = this.x;
		var oldY = this.y;

		this.setPos(newPosX, this.y);

		var rect = new Rectangle(this.x - 5, this.y - 5, 10, 10);
		var dest = world.rayCast(new Point(this.x, this.y), new Point(0, Math.abs(hor) * event.passedTime * -moveSpeed * 1.05), rect, layers);
		if (dest != null) {
			this.setPos(newPosX, dest.y - 0.0001);
		} else {
			dest = world.rayCast(new Point(this.x, this.y), new Point(0, Math.abs(hor) * event.passedTime * moveSpeed * 1.05), rect, layers );
			if (dest != null) {
				this.setPos(newPosX, dest.y - 0.0001);
			}
		}

	}
	
	public function fall(event:EnterFrameEvent, ?layers:Array<String>, ?clipFloor:Bool = false, ?gravity:Float = 80.0) {
		if (layers == null)
			layers = ["map"];
			
		var oldX = this.x;
		var oldY = this.y;

		var newPosY = this.y + velY * event.passedTime;

		var ci = new Array<CollisionInformation>();
		var rect = new Rectangle(this.x - 5, newPosY - 5, 10, 10);
		var dest = world.rayCast(new Point(oldX, oldY - 0.0001), new Point(0, velY * event.passedTime), rect, layers, 0.0001, ci);
		if (velY >= 0 && dest != null && !ci[0].collider_src.containsPoint(new Point(dest.x, dest.y - 0.0001), world) && !clipFloor) {
			this.setPos(this.x, dest.y);
			this.velY = 0;
			grounded = true;
			landed();
		}
		else {
			this.setPos(this.x, newPosY);
			grounded = false;
		}
		
		velY += event.passedTime * gravity;

	}
	
	public function landed() {
		
	}
	
	public function getHealth():Float {
		return this.health;
	}
    
	public function getMaxHealth():Float {
		return this.maxHealth;
		return this.maxHealth;
	}
	
	public function updateHealth(amt:Float) {
		health = amt;
		dispatchEvent(new Event("healthChanged"));
	}
    
	public function addHealth(amt:Float) {
		updateHealth(this.health + amt);
	}
	
	private function killed(overflow:Float) {
        world.removeObject(this);
        this.dispose();
    }
	
	public function isDead():Bool {
		return health == 0;
	}
    
	//public function setColor(color:Int) { }
	public function clearColor() {
		//this.sprite.filter = null;
	}
    public function setColor(r:Float, g:Float, b:Float, a:Float = 0.0) {
        //this.sprite.color = color;
		//this.sprite.filter = new ColorFilter(r, g, b, a);
    }
}