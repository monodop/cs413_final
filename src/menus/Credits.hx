package menus;

import flash.events.Event;
import flash.media.Sound;
import flash.media.SoundChannel;
import flash.net.URLRequest;
import flash.ui.Keyboard;
import flash.geom.Vector3D;
import starling.display.Sprite;
import starling.utils.AssetManager;
import starling.core.Starling;
import starling.animation.Transitions;
import starling.animation.Tween;
import starling.display.Image;
import starling.text.TextField;
import starling.text.BitmapFont;
import starling.utils.Color;
import starling.events.KeyboardEvent;
import Std;

class Credits extends Sprite {
	public var rootSprite:Sprite;
	public var highScore:Int;
	public var bg:Image;
	private var transitionSpeed = 0.5;
	public var bgcolor = 255;
	public var credits:TextField = new TextField(350, 60,"Credits", "font", 45, Color.WHITE);
	public var name1:TextField = new TextField(150, 50,"Sean Baquiro", "font", 24, Color.WHITE);
	public var name2:TextField = new TextField(150, 50,"Ryan Buckingham", "font", 24, Color.WHITE);
	public var name3:TextField = new TextField(150, 50,"Jack Burrell", "font", 24, Color.WHITE);
	public var name4:TextField = new TextField(150, 50,"Harrison Lambeth", "font", 24, Color.WHITE);
	public var name5:TextField = new TextField(150, 50,"John Loudon", "font", 24, Color.WHITE);
	public function new(rootSprite:Sprite) {
		this.rootSprite = rootSprite;
		super();
	}

	public function start() {

			var center = new Vector3D(Starling.current.stage.stageWidth / 2, Starling.current.stage.stageHeight / 2);
			this.pivotX = center.x;
			this.pivotY = center.y;
			this.x = center.x;
			this.y = center.y;
			this.scaleX = 1;
			this.scaleY = 1;

			Starling.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, handleInput);
			credits.x = center.x - 175;
			credits.y = center.y + 180;
			this.addChild(credits);
			name1.x = center.x - 75;
			name1.y = center.y + 230;
			this.addChild(name1);
			name2.x = center.x - 75;
			name2.y = center.y + 260;
			this.addChild(name2);
			name3.x = center.x - 75;
			name3.y = center.y + 290;
			this.addChild(name3);
			name4.x = center.x - 75;
			name4.y = center.y + 320;
			this.addChild(name4);
            name5.x = center.x - 75;
			name5.y = center.y + 350;
			this.addChild(name5);
			rootSprite.addChild(this);
			scrollUp();
		}
		
	private function scrollUp(){
		var creditsTween = new Tween(credits, 10, Transitions.LINEAR);
		creditsTween.animate("y", credits.y - 300);
		Starling.juggler.add(creditsTween);
		var name1Tween = new Tween(name1, 10, Transitions.LINEAR);
		name1Tween.animate("y", name1.y - 300);
		Starling.juggler.add(name1Tween);
		var name2Tween = new Tween(name2, 10, Transitions.LINEAR);
		name2Tween.animate("y", name2.y - 300);
		Starling.juggler.add(name2Tween);
		var name3Tween = new Tween(name3, 10, Transitions.LINEAR);
		name3Tween.animate("y", name3.y - 300);
		Starling.juggler.add(name3Tween);
		var name4Tween = new Tween(name4, 10, Transitions.LINEAR);
		name4Tween.animate("y", name4.y - 300);
		Starling.juggler.add(name4Tween);
        var name5Tween = new Tween(name5, 10, Transitions.LINEAR);
		name5Tween.animate("y", name5.y - 300);
		Starling.juggler.add(name5Tween);
	}
	
	private function handleInput(event:KeyboardEvent) {
		
		if (event.keyCode == Keyboard.SPACE || event.keyCode == Keyboard.ENTER) {
		
			// Return
			var menu = new MainMenu(rootSprite);
			menu.bgcolor = this.bgcolor;
			menu.start();
			Starling.current.stage.removeEventListener(KeyboardEvent.KEY_DOWN, handleInput);
			this.removeFromParent();
			this.dispose();

			/*transitionOut(function() {
				this.removeFromParent();
				this.dispose();
			});*/
		}
		
	}
	
	
}
