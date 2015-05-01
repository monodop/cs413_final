package game.objects;
import colliders.BoxCollider;
import colliders.Collider;
import flash.geom.Rectangle;
import colliders.CollisionInformation;
import flash.Vector;
import haxe.ds.StringMap;
import starling.filters.ColorFilter;
import starling.textures.Texture;
import starling.events.EnterFrameEvent;
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
        animations.set("Move", Root.assets.getTextures("enemies/Golem_Walk_"));
        animations.set("Attack", Root.assets.getTextures("enemies/Golem_Attack_"));

		this.sprite = new MovieClipPlusPlus(animations, 10);
		this.sprite.pivotX = 40;
		this.sprite.pivotY = 96;
		this.sprite.smoothing = 'none';
        this.sprite.setLoop("Walk");
        this.sprite.changeAnimation("Move");
        this.sprite.setAnimationDuration("Move", 0.4);
        this.sprite.setAnimationDuration("Attack", 0.3);

		addChild(this.sprite);
        this.collider = new BoxCollider(this, ["enemies"], 80, 96, new Point(0, -48));
        addChild(this.collider);

    }


    public override function update(event:EnterFrameEvent) {

        this.sprite.advanceTime(event.passedTime);

        var left = Root.controls.isDown("left") ? -1 : 0;
        var right = Root.controls.isDown("right") ? 1 : 0;
        var up = Root.controls.isDown("up") ? -1 : 0;
        var down = Root.controls.isDown("down");
        var down2 = Root.controls.isDown("down") ? 1 : 0;
        var hor = left + right;
        var vert = up + down2;

        this.setChildIndex(healthBar, this.numChildren - 1);

        var dir = new Point(world.player.x - this.x, world.player.y - this.y);
        dir = dir.normalize(5);
        var ci = new Array<CollisionInformation>();
        var hitpoint:Point;
        hitpoint = world.rayCast(new Point(this.x, this.y - 0.5), dir, new Rectangle(this.x-5, this.y-5, 10, 10), ["map", "player"], 0.0, ci);
        if(hitpoint == null || !Std.is(ci[0].collider_src.parent, Player))
            this.Patrol(event);
        else if((new Point(this.x, this.y - 0.5)).distance(new Point(world.player.x, world.player.y)) >= attackRange)
            this.Advance(event);
        else{
            if(!canAttack){
                if(!sprite.isPlaying)
                    sprite.changeAnimation("Walk");

                attackTimer -= event.passedTime*1000;
                if(attackTimer<=0){
                    attackTimer = 0;
                    canAttack = true;
                }
            }
            if(canAttack){

                canAttack=false;
                this.Attack(event);
                attackTimer = attackSpeed;
                sprite.changeAnimation("Attack");
            }
        }
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