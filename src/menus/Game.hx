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
import starling.display.Quad;
import starling.events.EnterFrameEvent;
import starling.events.Event;
import utility.ControlManager.ControlAction;
import starling.text.TextField;
import starling.text.BitmapFont;

class Game extends MenuState
{
	
	var bg:Image;
	var transitionSpeed = 0.5;
	var winterWorld:WinterWorld;
	var summerWorld:SummerWorld;
	var activeWorld:World;
	var player:Player;
    var healthText:TextField;
    var healthBarBG:Quad;
    var healthBarFG:Quad;
    var healthBarWidth:Int = 100;
    var healthBarHeight:Int = 6;
	
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
        this.player.health = 50;
        this.player.maxHealth = 100;
		this.summerWorld.player = this.player;
		this.winterWorld.player = this.player;
		this.activeWorld.attachPlayer();
        
        this.healthText = new TextField(50, 12, "Health:", BitmapFont.MINI, 12, 0x000000);
        this.healthText.x = 20;
        this.healthText.y = 18;
        this.addChild(this.healthText);
        this.healthBarBG = new Quad(healthBarWidth + 4, healthBarHeight + 4, 0x000000);
        this.healthBarBG.x = 70;
        this.healthBarBG.y = 20;
        this.addChild(this.healthBarBG);
        this.healthBarFG = new Quad(healthBarWidth * this.player.health / this.player.maxHealth, healthBarHeight, 0xff0000);
        this.healthBarFG.x = 70 + 2;
        this.healthBarFG.y = 20 + 2;
        this.addChild(this.healthBarFG);
	}
	
	private function updateHealthBar(event:Event) {
		this.healthBarFG.width = healthBarWidth * this.player.health / this.player.maxHealth;
	}
	
	override function deinit() {
		summerWorld.dispose();
		winterWorld.dispose();
		super.deinit();
	}
	
	override function awake() {
		this.addEventListener(EnterFrameEvent.ENTER_FRAME, enterFrame);
		Root.controls.hook("debugWorldSwitch", "gameSwitchWorldDebug", switchWorld);
		this.player.addEventListener("healthChanged", updateHealthBar);
		activeWorld.awake();
	}
	override function sleep() {
		removeEventListener(EnterFrameEvent.ENTER_FRAME, enterFrame);
		Root.controls.unhook("debugWorldSwitch", "gameSwitchWorldDebug");
		this.player.removeEventListener("healthChanged", updateHealthBar);
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
                this.healthText.color = 0x000000;
                this.healthBarBG.color = 0x000000;
			} else {
				this.activeWorld = summerWorld;
                this.healthText.color = 0xffffff;
                this.healthBarBG.color = 0xffffff;
			}
			player.setWorld(this.activeWorld);
			this.addChild(activeWorld);
			//activeWorld.player.x = playerX;
			//activeWorld.player.y = playerY;
			//activeWorld.camera.x = playerX;
			//activeWorld.camera.y = playerY;
			
			this.activeWorld.awake();
            
            this.setChildIndex(healthText, this.numChildren - 1);
            this.setChildIndex(healthBarBG, this.numChildren - 1);
            this.setChildIndex(healthBarFG, this.numChildren - 1);
			
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