package game.objects;
import colliders.BoxCollider;
import colliders.Collider;
import flash.Vector;
import haxe.ds.StringMap;
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
		this.maxHealth = 200.0;
		this.strikable = true;

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
}