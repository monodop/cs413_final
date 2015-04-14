package menus;

import flash.geom.Vector3D;
import starling.animation.Transitions;
import starling.animation.Tween;
import starling.core.Starling;
import starling.display.Image;
import starling.text.TextField;
import starling.utils.Color;
import utility.ControlManager.ControlAction;


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
		selection = 0;
		rootSprite.addChild(this);
		
	}
	
	override function deinit() {
		
	}
	
	override function awake() {
		Root.controls.hook("up", "MainMenuUp", up);
		Root.controls.hook("down", "MainMenuDown", down);
		Root.controls.hook("select", "MainMenuSpace", space);
	}
	override function sleep() {
		Root.controls.unhook("up", "MainMenuUp");
		Root.controls.unhook("down", "MainMenuDown");
		Root.controls.unhook("select", "MainMenuSpace");
	}
	
	private override function transitionIn(?callBack:Void->Void) {
		var t = new Tween(this, transitionSpeed, Transitions.EASE_IN_OUT);
		t.animate("scaleX", 1);
		t.animate("scaleY", 1);
		t.animate("bgcolor", 0);
		t.onUpdate = function() {
			Starling.current.stage.color = this.bgcolor | this.bgcolor << 8 | this.bgcolor << 16;
		};
		t.onComplete = callBack;
		Starling.juggler.add(t);
	}
	private override function transitionOut(?callBack:Void->Void) {
		var t = new Tween(this, transitionSpeed, Transitions.EASE_IN_OUT);
		t.animate("x", 1000);
		t.onComplete = callBack;
		Starling.juggler.add(t);
	}
	
	private function up(action:ControlAction) {
		
		if (tween == null || tween.isComplete) {
			tween = new Tween(this.buttons[selection], rotateSpeed, Transitions.EASE_IN_OUT);
			tween.animate("fontSize", 24);
			Starling.juggler.add(tween);
			selection = arithMod(--selection, buttons.length);
			tween = new Tween(this.buttons[selection], rotateSpeed, Transitions.EASE_IN_OUT);
			tween.animate("fontSize", 40);
			Starling.juggler.add(tween);
		}
	}
	private function down(action:ControlAction) {
		
		if (tween == null || tween.isComplete) {
			tween = new Tween(this.buttons[selection], rotateSpeed, Transitions.EASE_IN_OUT);
			tween.animate("fontSize", 24);
			Starling.juggler.add(tween);
			selection = arithMod(++selection, buttons.length);
			tween = new Tween(this.buttons[selection], rotateSpeed, Transitions.EASE_IN_OUT);
			tween.animate("fontSize", 40);
			Starling.juggler.add(tween);
		}
	}
	private function space(action:ControlAction) {
		if (selection == 0) {
			// NewGame
			var game = new Game(rootSprite);
			game.start();
			this.stop();
		}
		else if (selection == 1) {
			// Credits
			//var credits = new Credits(rootSprite);
			//credits.start();
			this.stop();
		}
	}

	public static function arithMod(n:Int, d:Int) : Int {

		var r = n % d;
		if (r < 0)
			r += d;
		return r;
	}
}