package game;

import colliders.*;
import flash.geom.Rectangle;
import game.objects.BaseObject;
import game.objects.Player;
import menus.MenuState;
import menus.QuadTreeVis;
import movable.*;
import starling.core.Starling;
import starling.display.Image;
import starling.display.Sprite;
import starling.events.EnterFrameEvent;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import utility.ControlManager.ControlAction;
import utility.Point;
import starling.extensions.*;

class World extends Sprite {
	
	private var menustate:MenuState;
	
	public var tileSize:Float = 16;
	private var tilemap:Tilemap;
	private var player:Player;
	public var camera:Camera;
	
	private var quadvis:QuadTreeVis;
	
	public var quadTree:Quadtree;
	private var collisionMatrix:CollisionMatrix;
    
    public var ps:PDParticleSystem;
	
	public function new (menustate:MenuState) {
		super();
		
		// Rescale the world and initiate the menu state
		this.menustate = menustate;
		this.x = Starling.current.stage.stageWidth / 2.0;
		this.y = Starling.current.stage.stageHeight / 2.0;
		this.scaleX = tileSize;
		this.scaleY = tileSize;
		
		// Setup the camera tracking class
		camera = new Camera(new Rectangle( -0.5, -0.5, 100, 100));
		this.addChild(camera);
		
		// Prepare the quadtree
		quadTree = new Quadtree(this, new Rectangle( 0.0, 0.0, 100, 100));
		
		// Prepare the collision matrix
		collisionMatrix = new CollisionMatrix();
		collisionMatrix.registerLayer("map");
		collisionMatrix.registerLayer("player");
		collisionMatrix.enableCollisions("map", ["player"]);
		
		// Prepare the tilemap
		tilemap = new Tilemap(this, Root.assets, "map");
		tilemap.scaleX = 1.0 / tileSize;
		tilemap.scaleY = 1.0 / tileSize;
		addObject(tilemap);

		player = new Player(this);
		player.x = 7;
		player.y = 10;
		player.scaleX = 1 / tileSize;
		player.scaleY = 1 / tileSize;
		addObject(player);
		
		this.pivotX = player.x;
		this.pivotY = player.y;
		this.camera.x = player.x;
		this.camera.y = player.y;
        
        ps = new PDParticleSystem(Root.assets.getXml("snow_particle_config"), Root.assets.getTexture("snow_particle"));
        ps.scaleX = 1 / tileSize / 2;
        ps.scaleY = 1 / tileSize / 2;
        this.addChild(ps);
        Starling.juggler.add(ps);
        ps.start();
	}

	
	public function addObject(obj:BaseObject) {
		addChild(obj);
		for (collider in obj.getColliders()) {
			this.quadTree.insert(collider);
		}
	}
	public function removeObject(obj:BaseObject) {
		for (collider in obj.getColliders()) {
			collider.quadTree.remove(collider, true);
		}
		removeChild(obj);
	}
	
	public function update(event:EnterFrameEvent) {
		player.update(event);
		//var mouse = Root.controls.getMousePos();

		// Control the ship's break
		//if(Root.controls.isDown("break")){
			//playerShip.stopMovement();
		//}
		
		// Hold the ship's current speed
		//if(Root.controls.isDown("hold")){
			//playerShip.holdSpeed();
		//}
		
		
		// Update the camera object
		camera.moveTowards(player.x, player.y);
		camera.applyCamera(this);
		
		// Update the tilemap
		//tilemap.update(event, camera);
        
        var camBounds = camera.getCameraBounds(this);
        ps.emitterX = camera.x * tileSize * 2;
        ps.emitterY = camBounds.top * tileSize;
	}
	
	public function awake() {
		Root.controls.hook("quadtreevis", "quadTreeVis", quadTreeVis);
		//Starling.current.stage.addEventListener(TouchEvent.TOUCH, touch);
		Starling.current.stage.addEventListener(TouchEvent.TOUCH, screenShake);
		player.awake();
	}
	
	public function sleep() {
		Root.controls.unhook("quadtreevis", "quadTreeVis");
		player.sleep();
	}

	public function screenShake(event:TouchEvent) {
		var p = event.getTouch(Starling.current.stage, TouchPhase.BEGAN, -1);

		if (p != null && p.isTouching != null) {
			camera.shake(0, 0, 0.0);
		}
	}

	public function gameOver() {
		
		//var menu = new GameOverMenu(menustate.rootSprite, this, menustate);
		//menu.start();
		//
		//menustate.pause();
		
	}
	
	function touch(event:TouchEvent) {
		var p = event.getTouch(Starling.current.stage, TouchPhase.BEGAN, -1);
		if (p != null) {
			player.setPos(p.getLocation(this).x, p.getLocation(this).y);
			player.velX = 0;
			player.velY = 0;
		}
	}
	
	// Pass a collider of something you want to test the collision of (the player's ship for example).
	// optionally pass in collisionInfo to retrieve an array of collisions that occured with some (admittedly not super reliable) data about them.
	// This function returns True if there was a collision and False if not.
	public function checkCollision(collider:Collider, ?collisionInfo:Array<CollisionInformation>):Bool {
		
		if (collisionInfo == null)
			collisionInfo = new Array<CollisionInformation>();
		
		var colliders = quadTree.retrieve(collider);
		var ci:CollisionInformation;
		for (c in colliders) {
			ci = new CollisionInformation();
			if (collider != c && collider.getOwner() != c.getOwner()
				&& collisionMatrix.canCollide(collider, c)) {
					if(collider.isClipping(c, ci)) {
						var collide = false;
						
						if(collider.getOwner().collision(collider, c, ci)) {
							collide = true;
							if (!c.getOwner().collision(c, collider, ci.reverse()))
								collide = false;
							ci.reverse();
							
						if(collide)
							collisionInfo.push(ci);
						}
					}
				}
		}
		
		return collisionInfo.length > 0;
	}
	
	// Pass a source vector as a Utils.Point, and a direction vector as the ray you want to check.
	// Pass a flash.geom.Rectangle object as the boundaries you want to check within (the camera's boundaries for example).
	// Pass an array of layers you want to collide with.
	// Optionally provide a threshold which can be used to prevent floating point rounding errors.
	// Finally, optionally provide an empty array of CollisionInformation objects and it will be filled with a list of collisions that occured (probably less reliable than checkCollision).
	// This function returns the closest contact point that occured, or null if none.
	public function rayCast(src:Point, dir:Point, bounds:Rectangle, layers:Array<String>, ?threshold:Float = 0.0, ?collisionInfo:Array<CollisionInformation>):Point {
		
		if (collisionInfo == null)
			collisionInfo = new Array<CollisionInformation>();
			
		var smaller_bounds = bounds.clone();
		if (dir.x > 0)
			smaller_bounds.x = src.x;
		if (dir.x < 0)
			smaller_bounds.right = src.x;
		if (dir.y > 0)
			smaller_bounds.y = src.y;
		if (dir.y < 0)
			smaller_bounds.bottom = src.y;
		
		var colliders = quadTree.retrieveAt(smaller_bounds);
		var closest_intersect = null;
		var closest_diff = Math.POSITIVE_INFINITY;
		var ci:CollisionInformation = null;
		for (c in colliders) {
			
			var canCollide = false;
			for (l in c.getLayers()) {
				for (layer in layers) {
					if (l == layer) {
						canCollide = true;
						break;
					}
				}
				if (canCollide)
					break;
			}
			if (!canCollide)
				continue;
			
			ci = new CollisionInformation();
			var intersect = c.rayCast(src, dir, this, threshold, ci);
			if (intersect != null && bounds.containsPoint(intersect.toGeom())) {
				
				if (closest_intersect == null) {
					closest_intersect = intersect;
					closest_diff = src.distanceSqr(intersect);
					collisionInfo.push(ci);
				} else {
					var diff = src.distanceSqr(intersect);
					if(diff < closest_diff) {
						closest_diff = diff;
						closest_intersect = intersect;
						while (collisionInfo.length > 0)
							collisionInfo.pop();
						collisionInfo.push(ci);
					} else if (diff == closest_diff)
						collisionInfo.push(ci);
				}
				
			}
		}
		
		return closest_intersect;
		
	}
	
	function quadTreeVis(action:ControlAction) {
		if (action.isActive()) {
			if(quadvis == null)
				quadvis = new QuadTreeVis(this, quadTree);
			
			var status = quadvis.getMenuStatus();
			if(status == EMenuStatus.SLEEPING || status == EMenuStatus.STOPPED)
				quadvis.start();
			else
				quadvis.pause();
		}
	}
	
}