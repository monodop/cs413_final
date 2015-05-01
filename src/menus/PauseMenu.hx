package menus;

import game.World;
import flash.geom.Vector3D;
import starling.animation.Transitions;
import starling.animation.Tween;
import starling.core.Starling;
import starling.display.Image;
import starling.display.Sprite;
import starling.text.TextField;
import starling.utils.Color;
import utility.ControlManager.ControlAction;

class PauseMenu extends MenuState
{
	private var world:World;
	private var selection:Int;
	private var buttons:Array<TextField>;
	private var title:Image;
	private var rotateSpeed = 0.3;
	private var transitionSpeed = 0.5;
	private var tween:Tween;
	public var bgcolor = 255;
	public var bg:Image;
	public var menuTitle:TextField;
	public var center = new Vector3D(Starling.current.stage.stageWidth / 2.5, Starling.current.stage.stageHeight / 2.5);

	public function new(rootSprite:Sprite, world:World) 
	{
		super(rootSprite);
		this.world = world;
	}
	
	public override function init() { 
		this.pivotX = center.x;
		this.pivotY = center.y;
		this.x = center.x;
		this.y = center.y;
		bg = new Image(Root.assets.getTexture("intro"));
		menuTitle = new TextField(350, 100, "Paused", "font");
		bg.smoothing = "none";
		menuTitle.fontSize = 45;
		menuTitle.color = Color.WHITE;
		menuTitle.x = center.x - 125;
		menuTitle.y = 50;

		TextField.getBitmapFont("font").smoothing = "none";
		this.addChild(bg);
		this.addChild(menuTitle);
		rootSprite.addChild(this);
		
		buttons = [new TextField(150, 50, "Resume", "font"), new TextField(150, 50, "Quit", "font")];
		for (i in 0...buttons.length) {
			var button = buttons[i];
			button.fontSize = 24;
			button.color = Color.WHITE;
			button.x = center.x - 25;
			button.y = 150 + (i * 50);
			this.addChild(button);
		}
		//Enlarge the first highlighted option by default
		buttons[0].fontSize = 40;
		selection = 0;
		rootSprite.addChild(this);
	}
	
	public override function deinit() { 
		super.deinit();
	}
	
	public override function awake() {
		Root.controls.hook("up", "PauseMenuUp", up);
		Root.controls.hook("down", "PauseMenuDown", down);
		Root.controls.hook("select", "PauseMenuSpace", space);
	}
	
	public override function sleep() {
		Root.controls.unhook("up", "PauseMenuUp");
		Root.controls.unhook("down", "PauseMenuDown");
		Root.controls.unhook("select", "PauseMenuSpace");
	}
	
	private override function transitionIn(?callBack:Void->Void) {
		var t = new Tween(this, transitionSpeed, Transitions.EASE_IN_OUT);
		t.animate("scaleX", 1);
		t.animate("scaleY", 1);
		t.animate("bgcolor", 0);
		t.onUpdate = function() {
			//Starling.current.stage.color = this.bgcolor | this.bgcolor << 8 | this.bgcolor << 16;
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
			// Resume game
			world.awake();
			this.stop();
		}
		else if (selection == 1) {
			// quit game
			world.quit();
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