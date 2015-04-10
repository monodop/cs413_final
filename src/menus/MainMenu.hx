package menus;

import starling.display.Sprite;
import starling.display.Image;
import starling.text.TextField;
import starling.text.BitmapFont;
import starling.core.Starling;
import starling.animation.Transitions;
import starling.animation.Tween;
import starling.events.KeyboardEvent;
import flash.ui.Keyboard;
import starling.utils.Color;
import flash.geom.Vector3D;


class MainMenu extends MenuState
{

	private var selection:Int;
	private var buttons:Array<TextField>;
	private var title:Image;
	private var rotateSpeed = 0.3;
	private var transitionSpeed = 0.5;
	private var tween:Tween;
	public var bgcolor = 255;
	public var bg:Image;
	public var gametitle:TextField;
	public var center = new Vector3D(Starling.current.stage.stageWidth / 2.5, Starling.current.stage.stageHeight / 2.5);

	public function new(rootSprite:Sprite) 
	{
		super(rootSprite);

	}
	
	override function init() {

		this.pivotX = center.x;
		this.pivotY = center.y;
		this.x = center.x;
		this.y = center.y;
		bg = new Image(Root.assets.getTexture("sample"));
		gametitle = new TextField(350, 60, "TWO WOOOORLDS", "font");
		//gametitle.text = "game";
		gametitle.fontSize = 45;
		gametitle.color = Color.WHITE;
		gametitle.x = center.x - 125;
		gametitle.y = 50;

		TextField.getBitmapFont("font").smoothing = "none";
		this.addChild(bg);
		this.addChild(gametitle);
		rootSprite.addChild(this);

		buttons = [new TextField(150, 50, "Start", "font"), new TextField(150, 50, "Credits", "font")];
		for (i in 0...buttons.length) {
			var button = buttons[i];
			button.fontSize = 24;
			button.color = Color.WHITE;
			button.x = center.x - 25;
			button.y = 110 + (i * 50);
			this.addChild(button);
		}
		//Enlarge the first highlighted option by default
		buttons[0].fontSize = 40;
		Starling.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, handleInput);
		selection = 0;
		rootSprite.addChild(this);
		transitionIn();
		
	}
	
	override function deinit() {
		
	}
	
	override function awake() {
		
	}
	override function sleep() {
		
	}
	
	private override function transitionIn(?callBack:Void->Void) {
		//this.scaleX = 0;
		//this.scaleY = 0;
		//this.x = 256;
		//this.y = 256;
		//
		//var tween = new Tween(this, 1.5, "easeInOut");
		//tween.animate("scaleX", 1);
		//tween.animate("scaleY", 1);
		//tween.animate("x", 0);
		//tween.animate("y", 0);
		//tween.onComplete = function() {
			//callback();
		//}
		//Starling.juggler.add(tween);
		var t = new Tween(this, transitionSpeed, Transitions.EASE_IN_OUT);
		t.animate("scaleX", 1);
		t.animate("scaleY", 1);
		t.animate("bgcolor", 0);
		t.onUpdate = function() {
			Starling.current.stage.color = this.bgcolor | this.bgcolor << 8 | this.bgcolor << 16;
		};
		t.onComplete = callBack;
		Starling.juggler.add(t);
		//callback();
	}
	private override function transitionOut(?callBack:Void->Void) {
		//
		//var tween = new Tween(ship, 2.0, "easeInOut");
		//if(selection == 0) {
			//tween.animate("x", 256);
			//tween.animate("y", 192);
		//} else {
			//tween.animate("x", 512 + ship.width);
		//}
		//tween.onComplete = function() {
			//callback();
		//}
		//Starling.juggler.add(tween);
		//
		//tween = new Tween(title, 1.5, "easeInOut");
		//tween.animate("y", -100);
		//Starling.juggler.add(tween);
		//
		//tween = new Tween(options, 1.5, "easeInOut");
		//tween.animate("x", -options.width);
		//Starling.juggler.add(tween);
		var t = new Tween(this, transitionSpeed, Transitions.EASE_IN_OUT);
		t.animate("x", 1000);
		t.onComplete = callBack;
		Starling.juggler.add(t);
		//callback();
	}
	private function handleInput(event:KeyboardEvent){

		if (event.keyCode == Keyboard.SPACE) {

			if (selection == 0) {
			// NewGame
				var game = new Game(rootSprite);
				game.start();
				Starling.current.stage.removeEventListener(KeyboardEvent.KEY_DOWN, handleInput);
				transitionOut(function() {
			//Root.assets.removeSound("GrandpaTallTales");
					this.removeFromParent();
					this.dispose();
				});
			}
			else if (selection == 1) {
			// Credits
				var credits = new Credits(rootSprite);
				credits.start();
				Starling.current.stage.removeEventListener(KeyboardEvent.KEY_DOWN, handleInput);
				transitionOut(function() {
			//Root.assets.removeSound("GrandpaTallTales");
					this.removeFromParent();
					this.dispose();
				});
			}
		}
		else if (tween == null || tween.isComplete)
		{
			// Only allow moving if the current tween does not exist.
			if (event.keyCode == Keyboard.UP) {

				tween = new Tween(this.buttons[selection], rotateSpeed, Transitions.EASE_IN_OUT);
				tween.animate("fontSize", 24);
				Starling.juggler.add(tween);
				selection = arithMod(--selection, buttons.length);
				tween = new Tween(this.buttons[selection], rotateSpeed, Transitions.EASE_IN_OUT);
				tween.animate("fontSize", 40);
				Starling.juggler.add(tween);
			}
			else if (event.keyCode == Keyboard.DOWN) {

				tween = new Tween(this.buttons[selection], rotateSpeed, Transitions.EASE_IN_OUT);
				tween.animate("fontSize", 24);
				Starling.juggler.add(tween);
				selection = arithMod(++selection, buttons.length);
				tween = new Tween(this.buttons[selection], rotateSpeed, Transitions.EASE_IN_OUT);
				tween.animate("fontSize", 40);
				Starling.juggler.add(tween);
			}
		}
	}

	public static function arithMod(n:Int, d:Int) : Int {

		var r = n % d;
		if (r < 0)
			r += d;
		return r;
	}
}