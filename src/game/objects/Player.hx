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

class Player extends BaseObject
{

	private var sprite:MovieClipPlusPlus;
	private var collider:BoxCollider;
	private var grounded:Bool;
	public var snowWalkPS:PDParticleSystem;
	public var tileSize:Float = 16;
	private var ladders:Ladder;
	
	private var jumpStart:Bool = false;
	private var jumpEnd:Bool = false;
	private var attacking:Bool = false;
	private var doubleJumped:Bool = false;
	
	public function new(world:World) 
	{
		
		super(world);
		
		this.scaleX = 1 / world.tileSize;
		this.scaleY = 1 / world.tileSize;
		
		this.pivotX = 0;
		this.pivotY = -4;
		
		this.health = 100;
		this.maxHealth = 100;
		
		var animations = new StringMap<Vector<Texture>>();
		animations.set("Walk", Root.assets.getTextures("player/Player_Walk_"));
		animations.set("Idle", Root.assets.getTextures("player/Player_Idle_"));
		animations.set("Jump", Root.assets.getTextures("player/Player_Jump_"));
		animations.set("AirFast", Root.assets.getTextures("player/Player_Air_Fast_"));
		animations.set("AirMed", Root.assets.getTextures("player/Player_Air_Med_"));
		animations.set("AirSlow", Root.assets.getTextures("player/Player_Air_Slow_"));
		animations.set("AirPeak", Root.assets.getTextures("player/Player_Air_Peak_"));
		animations.set("Attack1", Root.assets.getTextures("player/Player_Attack_"));
		animations.set("TeleportIn", Root.assets.getTextures("player/Player_Teleport_In_"));
		animations.set("TeleportOut", Root.assets.getTextures("player/Player_Teleport_Out_"));
		
		this.sprite = new MovieClipPlusPlus(animations, 10);
		this.sprite.pivotX = 32;
		this.sprite.pivotY = 64;
		this.sprite.smoothing = 'none';
		
		this.sprite.setAnimationDuration("Jump", 0.05);
		this.sprite.setAnimationDuration("Attack1", 0.15);
		this.sprite.setAnimationFrameDuration("Attack1", 0, 0.05);
		this.sprite.setAnimationFrameDuration("Attack1", 3, 0.05);
		this.sprite.setAnimationDuration("Idle", 0.20);
		this.sprite.setLoop("Walk");
		this.sprite.setLoop("Idle");
		this.sprite.changeAnimation("Walk");
		
		addChild(this.sprite);
		
		this.collider = new BoxCollider(this, ["player"], 32, 64, new Point(0, -32));
		addChild(this.collider);
		
		//snowWalkPS = new PDParticleSystem(Root.assets.getXml("snow_walk_particle_config"), Root.assets.getTexture("particles/snow_walk_particle"));
		//snowWalkPS.emitterX = this.x * tileSize * 2;
		//snowWalkPS.emitterY = this.y * tileSize * 2;
		//snowWalkPS.scaleX = 1 / tileSize / 2;
		//snowWalkPS.scaleY = 1 / tileSize / 2;
		//world.addChild(snowWalkPS);
		//Starling.juggler.add(snowWalkPS);
		
	}
	
	public function setWorld(world:World) {
		this.world.detachPlayer();
		this.world = world;
		this.world.attachPlayer();
	}
	
	public override function awake() {
		Root.controls.hook("up", "playerJump", jump);
		Root.controls.hook("attack", "playerAttack", attack);
		sprite.addChangeFrameHook(frameAdvance);
	}
	public override function sleep() {
		Root.controls.unhook("up", "playerJump");
		Root.controls.unhook("attack", "playerAttack");
		sprite.removeChangeFrameHook(frameAdvance);
	}
	
	public function jump(action:ControlAction) {
		if (action.isActive() && !jumpStart && !attacking && (grounded || !doubleJumped) ) {
			//velY = -20;
			jumpStart = true;
			sprite.changeAnimation("Jump");
			
			if (!grounded) {
				doubleJumped = true;
			}
		}
	}
	
	public function attack(action:ControlAction) {
		if (action.isActive() && !attacking && !jumpStart) {
			attacking = true;
			jumpEnd = false;
			sprite.changeAnimation("Attack1");
		}
	}
	
	public function frameAdvance(clip:MovieClipPlusPlus) {
		//trace(clip.getLastAnimation() + "\t\t" + clip.getAnimationFrame());
		if (clip.getLastAnimation() == "Attack1" && clip.getAnimationFrame() == 2) {
			// Strike
			var ci = new Array<CollisionInformation>();
			var hit = world.rayCast(new Point(x, y - 1.0), new Point((this.scaleX < 0 ? -1 : 1) * 3.0, 0.0), world.camera.getCameraBounds(world), ["map", "enemies"], 0.0, ci);
			if(hit != null) {
				var hitCollider = ci[0].collider_src.parent;
				if (Std.is(hitCollider, BaseObject)) {
					var target:BaseObject = cast hitCollider;
					target.damage(10);
				}
			}
		}
	}
	
	public override function update(event:EnterFrameEvent) {
		
		this.sprite.advanceTime(event.passedTime);
		
		var left = Root.controls.isDown("left") ? -1 : 0;
		var right = Root.controls.isDown("right") ? 1 : 0;
		var up = Root.controls.isDown("up") ? -1 : 0;
		var down = Root.controls.isDown("down");
		var down2 = Root.controls.isDown("down") ? -1 : 0;

		var hor = left + right;
		var vert = up + down2;

		//snowWalkPS.start();
		
		if (hor < 0) {
			this.scaleX = -(Math.abs(this.scaleX));
			//snowWalkPS.emitAngle = utility.Utils.deg2rad(221.64 + 90);
		}
		else if (hor > 0) {
			this.scaleX = Math.abs(this.scaleX);
			//snowWalkPS.emitAngle = utility.Utils.deg2rad(221.64);
		}
		else {
			//snowWalkPS.stop();
		}

		if (world.checkCollision(this.collider, null, ["ladder"])) {
		// Ladder Physics
			var newPosY = this.y + vert * event.passedTime;
			var newPosX = this.x + hor * event.passedTime;
			this.setPos(newPosX, newPosY);
		} else {
			if (grounded && !jumpStart && !jumpEnd && !attacking) {

				if (hor == 0) {
					if (sprite.getLastAnimation() != "Idle")
						sprite.changeAnimation("Idle");
				} else {
					if (sprite.getLastAnimation() != "Walk")
						sprite.changeAnimation("Walk");
				}

			} else if (jumpStart) {

				if (!sprite.isPlaying) {
					velY = -20;
					jumpStart = false;
					grounded = false;
				}

			} else if (jumpEnd) {

				if (!sprite.isPlaying) {
					jumpEnd = false;
				}

			} else if (attacking) {

				if (!sprite.isPlaying) {
					attacking = false;
				}

			} else {

				var absVel = (this.velY);

				if (absVel < 5) {
					sprite.changeAnimation("AirPeak");
				} else if (absVel < 10) {
					sprite.changeAnimation("AirSlow");
				} else if (absVel < 14) {
					sprite.changeAnimation("AirMed");
				} else {
					sprite.changeAnimation("AirFast");
				}

			}

			var oldX = this.x;
			var oldY = this.y;

			var newPosY = this.y + velY * event.passedTime;

			var ci = new Array<CollisionInformation>();
			var dest = world.rayCast(new Point(oldX, oldY - 0.0001), new Point(0, velY * event.passedTime), world.camera.getCameraBounds(world), ["map"], 0.0001, ci);
			if (velY >= 0 && dest != null && !ci[0].collider_src.containsPoint(new Point(dest.x, dest.y - 0.0001), world) && !down) {
				this.setPos(this.x, dest.y);
				this.velY = 0;
				if (!grounded && !attacking) {
					jumpEnd = true;
					sprite.changeAnimation("Jump");
					sprite.nextFrame();
					sprite.play();
				}
				grounded = true;
				doubleJumped = false;
			}
			else {
				this.setPos(this.x, newPosY);
				grounded = false;
			}

			var newPosX = this.x + hor * event.passedTime * 7.5;

			var oldX = this.x;
			var oldY = this.y;

			this.setPos(newPosX, this.y);

			if ( true || grounded) {

				var dest = world.rayCast(new Point(this.x, this.y), new Point(0, Math.abs(hor) * event.passedTime * -7.6), world.camera.getCameraBounds(world), ["map"]);
				if (dest != null) {// && Math.abs(dest.y - this.y) > 0.0001) {

					//this.y = dest.y + 0.0001;
					this.setPos(newPosX, dest.y - 0.0001);

				} else {

					dest = world.rayCast(new Point(this.x, this.y), new Point(0, Math.abs(hor) * event.passedTime * 7.6), world.camera.getCameraBounds(world), ["map"]);
					if (dest != null) {
						//this.y = dest.y + 0.0001;
						this.setPos(newPosX, dest.y - 0.0001);
					}
				}

			}
			else {
				//snowWalkPS.stop();
			}

			velY += event.passedTime * 80.0;

			//snowWalkPS.emitterX = this.x * tileSize * 2;
			//snowWalkPS.emitterY = this.y * tileSize * 2;
		}
	}
	
	
	public override function getColliders():Array<Collider> {
		return [this.collider];
	}
	
	//public override function collision(self:Collider, object:Collider, collisionInfo:CollisionInformation):Bool {
		//
		//var b = object.getBounds(world);
		//if (Root.controls.isDown("down")) { return false; }
		//if (this.y - 0.25 > b.top) {
			//return false;
		//}
		//
		//return true;
		//
	//}
}