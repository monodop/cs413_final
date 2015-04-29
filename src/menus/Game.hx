package menus;

import flash.display.SimpleButton;
import game.objects.Player;
import game.SummerWorld;
import game.WinterWorld;
import game.World;
import starling.animation.Transitions;
import starling.animation.Tween;
import starling.core.Starling;
import starling.display.Image;
import starling.events.EnterFrameEvent;
import starling.events.Event;
import utility.ControlManager.ControlAction;

class Game extends MenuState
{
	
	var bg:Image;
	var transitionSpeed = 0.5;
	var winterWorld:WinterWorld;
	var summerWorld:SummerWorld;
	var activeWorld:World;
	var player:Player;
	
	override function init() {
		rootSprite.addChild(this);
		
		var stageWidth:Float = Starling.current.stage.stageWidth;
		var stageHeight:Float = Starling.current.stage.stageHeight;
		
		this.winterWorld = new WinterWorld(this, "map");
		this.addChild(winterWorld);
		
		this.summerWorld = new SummerWorld(this, "map2");
		this.activeWorld = this.winterWorld;
		
		this.player = new Player(this.activeWorld);
		this.player.x = 7;
		this.player.y = 14;
		this.summerWorld.player = this.player;
		this.winterWorld.player = this.player;
		this.activeWorld.attachPlayer();
	}
	
	override function deinit() { }
	
	override function awake() {
		this.addEventListener(EnterFrameEvent.ENTER_FRAME, enterFrame);
		Root.controls.hook("debugWorldSwitch", "gameSwitchWorldDebug", switchWorld);
		activeWorld.awake();
	}
	override function sleep() {
		removeEventListener(EnterFrameEvent.ENTER_FRAME, enterFrame);
		Root.controls.unhook("debugWorldSwitch", "gameSwitchWorldDebug");
		activeWorld.sleep();
	}
	
	function switchWorld(action:ControlAction) {
		
		if (action.isActive()) {
			
			//var playerX = activeWorld.player.x;
			//var playerY = activeWorld.player.y;
			
			this.activeWorld.sleep();
			this.removeChild(activeWorld);
			if (this.activeWorld == summerWorld) {
				this.activeWorld = winterWorld;
			} else {
				this.activeWorld = summerWorld;
			}
			player.setWorld(this.activeWorld);
			this.addChild(activeWorld);
			//activeWorld.player.x = playerX;
			//activeWorld.player.y = playerY;
			//activeWorld.camera.x = playerX;
			//activeWorld.camera.y = playerY;
			
			this.activeWorld.awake();
			
		}
		
	}
	
	function enterFrame(event:EnterFrameEvent) {
		activeWorld.update(event);
	}



	private override function transitionOut(?callBack:Void->Void) {

		var t = new Tween(this, transitionSpeed, Transitions.EASE_IN_OUT);
		t.animate("alpha", 0);
		t.onComplete = callBack;
		Starling.juggler.add(t);

	}
}