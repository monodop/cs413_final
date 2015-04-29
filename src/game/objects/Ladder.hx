package game.objects;
import colliders.BoxCollider;
import colliders.Collider;
import flash.Vector;
import haxe.ds.StringMap;
import starling.textures.Texture;
import utility.Point;


class Ladder extends BaseObject
{

    private var collider:BoxCollider;

    public var Loot:String;

    public function new(world:World)
    {
        super(world);

        //this.scaleX = 1 / world.tileSize;
        //this.scaleY = 1 / world.tileSize;

        this.collider = new BoxCollider(this, ["ladder"], 1, 1, new Point(0.5, 0.5));
        addChild(this.collider);
    }

    public override function getColliders():Array<Collider> {
        return [this.collider];
    }
}