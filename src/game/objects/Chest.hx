package game.objects;
import colliders.BoxCollider;
import colliders.Collider;
import flash.Vector;
import haxe.ds.StringMap;
import starling.filters.ColorFilter;
import starling.textures.Texture;
import utility.Point;


class Chest extends BaseObject
{

	private var sprite:MovieClipPlusPlus;
	private var collider:BoxCollider;
	
	public var Loot:String;
	
	public function new(world:World) 
	{
		super(world);
		
		this.scaleX = 1 / world.tileSize;
		this.scaleY = 1 / world.tileSize;
		
		this.health = 1.0;
		this.maxHealth = 1.0;
		this.strikable = true;
		
		var animations = new StringMap<Vector<Texture>>();
		animations.set("Closed", Root.assets.getTextures("world/Chest_Closed"));
		animations.set("Open", Root.assets.getTextures("world/Chest_Open"));
		
		this.sprite = new MovieClipPlusPlus(animations, 10);
		this.sprite.pivotX = 0;
		this.sprite.pivotY = 32;
		this.sprite.smoothing = 'none';
		
		this.sprite.changeAnimation("Closed");
		
		addChild(this.sprite);
		
		this.collider = new BoxCollider(this, ["hitOnly"], 32, 32, new Point(16, -16));
		addChild(this.collider);
	}
	
	public override function getColliders():Array<Collider> {
		return [this.collider];
	}
	
	private override function killed(overflow:Float) {
		this.sprite.changeAnimation("Open");
		world.spawnItem(Loot, this.x, this.y);
	}
    
	public override function clearColor() {
		this.sprite.filter = null;
	}
    public override function setColor(r:Float, g:Float, b:Float, a:Float = 0.0) {
		this.sprite.filter = new ColorFilter(r, g, b, a);
    }
}