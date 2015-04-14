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
	
	public override function init() {
		
		var stage = Starling.current.stage;
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
		stage.addChild(world);
	}
	
	public override function deinit() { }
	
	public override function awake() {
		addEventListener(Event.ENTER_FRAME, onEnterFrame);
	}
	public override function sleep() {
		removeEventListener(Event.ENTER_FRAME, onEnterFrame);
	}
	
	public function cleanup() {

	}
	
	function onEnterFrame(event:EnterFrameEvent) {

	}



	private override function transitionOut(?callBack:Void->Void) {

		var t = new Tween(this, transitionSpeed, Transitions.EASE_IN_OUT);
		t.animate("alpha", 0);
		t.onComplete = callBack;
		Starling.juggler.add(t);

	}
}

enum FieldState {
	TEXT;
	CORRECTION_TRANSITION;
	CORRECTIONS;
	NO_ERROR_RESPONSE;
	ERROR_CORRECT_RESPONSE;
	ERROR_INCORRECT_RESPONSE;
	INTRO;
	OUTRO;
}