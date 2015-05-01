package game.objects;
import colliders.BoxCollider;
import colliders.Collider;
import flash.Vector;
import haxe.ds.StringMap;
import starling.filters.ColorFilter;
import starling.textures.Texture;
import utility.Point;


class Golem extends AI
{

    private var sprite:MovieClipPlusPlus;
    private var collider:BoxCollider;

    public var Loot:String;

    public function new(world:World, ?x:Float=0.0, ?y:Float=0.0)
    {
        super(world, x, y, 40/world.tileSize, 0);
        this.scaleX = 1 / world.tileSize;
        this.scaleY = 1 / world.tileSize;
		this.attackRange = 3.5;
		this.attackDamage = 15;
		this.attackSpeed = 7000.0;
		
		this.health = 50.0;
		this.maxHealth = 50.0;
		this.strikable = true;
		
		this.patrolMoveSpeed = 2;
		this.advanceMoveSpeed = 3;
		
        this.healthBar.scaleX = healthBarWidth * this.getHealth() / this.getMaxHealth();
        this.healthBar.scaleY = healthBarHeight;
		this.healthBar.x = -26.5;
        this.healthBar.y = -100;
		this.healthBarWidth = 50;

        var animations = new StringMap<Vector<Texture>>();
        animations.set("Move", Root.assets.getTextures("enemies/Golem_"));

        this.sprite = new MovieClipPlusPlus(animations, 10);
        this.sprite.pivotX = 40;
        this.sprite.pivotY = 96;
        this.sprite.smoothing = 'none';

        this.sprite.changeAnimation("Move");

        addChild(this.sprite);

        this.collider = new BoxCollider(this, ["enemies"], 80, 96, new Point(0, -48));
        addChild(this.collider);
    }

    public override function getColliders():Array<Collider> {
        return [this.collider];
    }
    
	public override function clearColor() {
		this.sprite.filter = null;
	}
    public override function setColor(r:Float, g:Float, b:Float, a:Float = 0.0) {
        //this.sprite.color = color;
		this.sprite.filter = new ColorFilter(r, g, b, a);
    }
	
	private override function killed(overflow:Float) {
		world.spawnItem("{ \"Coin\" : \"3\" }", this.x, this.y);
		world.removeObject(this);
        this.dispose();
	}
}