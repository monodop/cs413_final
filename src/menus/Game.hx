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
import starling.extensions.*;
import flash.media.SoundTransform;

class Game extends MenuState
{
	
	var bg:Image;
	var transitionSpeed = 0.5;
	var winterWorld:WinterWorld;
	var summerWorld:SummerWorld;
	var activeWorld:World;
	var player:Player;
	var healthText:TextField;
	var healthBarBG:Image;
	var healthBarFG:Image;
	var healthBarWidth:Int = 100;
	var healthBarHeight:Int = 6;
	//var scoreText:TextField;
	var coinText:TextField;
	
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
		
		this.healthText = new TextField(50, 12, "Health:", BitmapFont.MINI, 12, 0x000000);
		this.healthText.x = 20;
		this.healthText.y = 18;
		this.addChild(this.healthText);
		this.healthBarBG = new Image(Root.assets.getTexture("blackpixel"));
		this.healthBarBG.scaleX = healthBarWidth + 4;
		this.healthBarBG.scaleY = healthBarHeight + 4;
		this.healthBarBG.x = 70;
		this.healthBarBG.y = 20;
		this.addChild(this.healthBarBG);
		this.healthBarFG = new Image(Root.assets.getTexture("redpixel"));
		this.healthBarFG.scaleX = healthBarWidth * this.player.getHealth() / this.player.getMaxHealth();
		this.healthBarFG.scaleY = healthBarHeight;
		this.healthBarFG.x = 70 + 2;
		this.healthBarFG.y = 20 + 2;
		this.addChild(this.healthBarFG);
		
		//this.scoreText = new TextField(75, 12, "Score: 0", BitmapFont.MINI, 12, 0x000000);
		//this.scoreText.x = stageWidth - 90;
		//this.scoreText.y = 18;
		//this.addChild(scoreText);
		this.coinText = new TextField(75, 12, "Coins: 0", BitmapFont.MINI, 12, 0x000000);
		this.coinText.x = stageWidth - 90;
		this.coinText.y = 18;
		this.addChild(coinText);
	}
	
	private function updateHealthBar(event:Event) {
		this.healthBarFG.width = healthBarWidth * this.player.getHealth() / this.player.getMaxHealth();
	}
	
	private function updateCoinDisplay(event:Event) {
		this.coinText.text = "Coins: " + Std.string(player.getCoinCount());
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
		this.player.addEventListener("coinAdded", updateCoinDisplay);
		activeWorld.awake();
	}
	override function sleep() {
		removeEventListener(EnterFrameEvent.ENTER_FRAME, enterFrame);
		Root.controls.unhook("debugWorldSwitch", "gameSwitchWorldDebug");
		this.player.removeEventListener("healthChanged", updateHealthBar);
		this.player.removeEventListener("coinAdded", updateCoinDisplay);
		activeWorld.sleep();
	}
	
	function switchWorld(action:ControlAction) {
		
		if (action.isActive()) {
			
			//var playerX = activeWorld.player.x;
			//var playerY = activeWorld.player.y;
			
			this.activeWorld.sleep();
			this.removeChild(activeWorld);
			if (this.activeWorld == summerWorld) {
				Root.assets.playSound("Change_World_Sound_2", 0, 0, new SoundTransform(0.1, 0.1));
				this.activeWorld = winterWorld;
				this.healthText.color = 0x000000;
				this.healthBarBG.texture = Root.assets.getTexture("blackpixel");
				//this.scoreText.color = 0x000000;
				this.coinText.color = 0x000000;
				this.player.snowWalkPS.startColor = ColorArgb.fromArgbToArgb(0xffffffff);
				this.player.snowWalkPS.endColor = ColorArgb.fromArgbToArgb(0xffffffff);
			} else {
				Root.assets.playSound("Change_World__Sound_1", 0, 0, new SoundTransform(0.1, 0.1));
				this.activeWorld = summerWorld;
				this.healthText.color = 0xffffff;
				this.healthBarBG.texture = Root.assets.getTexture("pixel");
				//this.scoreText.color = 0xffffff;
				this.coinText.color = 0xffffff;
				this.player.snowWalkPS.startColor = ColorArgb.fromArgbToArgb(0xff8b7355);
				this.player.snowWalkPS.endColor = ColorArgb.fromArgbToArgb(0xff8b7355);
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
			//this.setChildIndex(scoreText, this.numChildren - 1);
			this.setChildIndex(coinText, this.numChildren - 1);
			
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