package game.objects;
import colliders.BoxCollider;
import colliders.Collider;
import flash.Vector;
import haxe.ds.StringMap;
import starling.filters.ColorFilter;
import starling.textures.Texture;
import utility.Point;


class Snowmon extends AI
{

	private var sprite:MovieClipPlusPlus;
	private var collider:BoxCollider;

	public var Loot:String;

	public function new(world:World, ?x:Float=0.0, ?y:Float=0.0)
	{
		super(world, x, y, 24/world.tileSize, 0);
		this.scaleX = 1 / world.tileSize;
		this.scaleY = 1 / world.tileSize;
		this.attackRange = 2.0;
		this.attackDamage = 3.0;
		this.attackSpeed = 2000.0;
		this.maxHealth = 20.0;
		this.health = 20.0;
		this.strikable = true;
		this.healthBar.scaleX = healthBarWidth * this.getHealth() / this.getMaxHealth();
		this.healthBar.scaleY = healthBarHeight;
		this.healthBar.x = -10;
		this.healthBar.y = -50;
		this.healthBarWidth = 20;
		var animations = new StringMap<Vector<Texture>>();
		animations.set("Move", Root.assets.getTextures("enemies/SnowMon_"));

		this.sprite = new MovieClipPlusPlus(animations, 10);
		this.sprite.pivotX = 24;
		this.sprite.pivotY = 64;
		this.sprite.smoothing = 'none';
		
		this.patrolMoveSpeed = 3;
		this.advanceMoveSpeed = 4.5;

		this.sprite.changeAnimation("Move");

		addChild(this.sprite);

		this.collider = new BoxCollider(this, ["enemies"], 48, 64, new Point(0, -32));
		addChild(this.collider);
	}

	public override function getColliders():Array<Collider> {
		return [this.collider];
	}
	
	public override function clearColor() {
		this.sprite.filter = null;
	}
	public override function setColor(r:Float, g:Float, b:Float, a:Float = 0.0) {
		this.sprite.filter = new ColorFilter(r, g, b, a);
	}
	
	private override function killed(overflow:Float) {
		world.spawnItem("{ \"Coin\" : \"1\" }", this.x, this.y);
		world.removeObject(this);
		this.dispose();
	}
}