package game.objects;
import colliders.BoxCollider;
import colliders.Collider;
import colliders.CollisionInformation;
import flash.Vector;
import game.MovieClipPlusPlus;
import game.World;
import haxe.ds.StringMap;
import haxe.macro.Expr.Position;
import starling.core.Starling;
import starling.display.Image;
import starling.display.MovieClip;
import starling.events.EnterFrameEvent;
import starling.textures.Texture;
import utility.ControlManager.ControlAction;
import utility.Point;
import starling.extensions.*;

/**
 * ...
 * @author Group 5
 */
class Coin extends BaseObject
{
	private var sprite:MovieClipPlusPlus;
	private var collider:BoxCollider;
	
	public function new(world:World, xloc:Float, yloc:Float) {
		super(world);
		
		this.scaleX = 1 / world.tileSize;
		this.scaleY = 1 / world.tileSize;
		
		this.health = 1.0;
		this.maxHealth = 1.0;
		this.strikable = true;
		
		var animations = new StringMap<Vector<Texture>>();
		animations.set("Coin", Root.assets.getTextures("player/Player"));
	
		this.sprite = new MovieClipPlusPlus(animations, 10);
		this.sprite.pivotX = 0;
		this.sprite.pivotY = 32;
		this.sprite.smoothing = 'none';
		
		this.sprite.changeAnimation("Coin");
		
		addChild(this.sprite);
		
		this.collider = new BoxCollider(this, ["map"], 32, 32, new Point(16, -16));
		addChild(this.collider);
	}
	
	public override function getColliders():Array<Collider> {
		return [this.collider];
	}
	
}