package menus;

import game.World;
import starling.animation.Transitions;
import starling.animation.Tween;
import starling.core.Starling;
import starling.display.Image;
import starling.events.EnterFrameEvent;
import starling.events.Event;

class Game extends MenuState
{
	
	var bg:Image;
	var transitionSpeed = 0.5;
	var world:World;
	
	override function init() {
		rootSprite.addChild(this);
		
		var stageWidth:Float = Starling.current.stage.stageWidth;
		var stageHeight:Float = Starling.current.stage.stageHeight;

		//map = new Tilemap(Root.assets, "map");
		//map.scaleX = .3;
		//map.scaleY = .3;
		//stage.addChild(map);

		//player = new Image(Root.assets.getTexture("Player"));
		//player.smoothing = "none";
		//player.x = 40;
		//player.y = 70;
		//stage.addChild(player);

		//bg = new Image(Root.assets.getTexture("Background"));
		//bg.smoothing = "none";

		//this.addChild(bg);
		
		this.world = new World(this);
		this.addChild(world);
	}
	
	override function deinit() { }
	
	override function awake() {
		this.addEventListener(EnterFrameEvent.ENTER_FRAME, enterFrame);
		world.awake();
	}
	override function sleep() {
		removeEventListener(EnterFrameEvent.ENTER_FRAME, enterFrame);
		world.sleep();
	}
	
	function enterFrame(event:EnterFrameEvent) {
		world.update(event);
	}



	private override function transitionOut(?callBack:Void->Void) {

		var t = new Tween(this, transitionSpeed, Transitions.EASE_IN_OUT);
		t.animate("alpha", 0);
		t.onComplete = callBack;
		Starling.juggler.add(t);

	}
}