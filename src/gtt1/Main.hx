import flash.events.Event;
import flash.media.Sound;
import flash.media.SoundChannel;
import flash.media.SoundTransform;
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

class Main extends Sprite {
	
	public var rootSprite:Sprite;
	private var selection:Int;
	private var buttons:Array<TextField>;
	private var title:Image;
	//private var snakeLogo:Image;
	private var rotateSpeed = 0.3;
	private var transitionSpeed = 0.5;
	private var tween:Tween;
	public var bgcolor = 255;
	public var bg:Image;
	public var gametitle:TextField;
	public var center = new Vector3D(Starling.current.stage.stageWidth / 2.5, Starling.current.stage.stageHeight / 2.5);

	public function new(rootSprite:Sprite) {
		this.rootSprite = rootSprite;
		super();
	}
	
	public function start() {
		
		this.pivotX = center.x;
		this.pivotY = center.y;
		this.x = center.x;
		this.y = center.y;
		this.scaleX = 8;
		this.scaleY = 8;
		bg = new Image(Root.assets.getTexture("Intro"));
		Root.assets.playSound("GrandpaTallTales", 0, 9999);
		gametitle = new TextField(350, 50, "Grandpa's Tall Tales", "5x7");
		gametitle.text = "Grandpa's Tall Tales";
		gametitle.fontSize = 45;
		gametitle.color = Color.WHITE;
		gametitle.x = center.x - 125;
		gametitle.y = 50;
		TextField.getBitmapFont("5x7").smoothing = "none";
		this.addChild(bg);
		this.addChild(gametitle);
		rootSprite.addChild(this);

		buttons = [new TextField(150, 50, "Begin Game", "5x7"), new TextField(150, 50, "Credits", "5x7")];
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
		//startAnim();
		transitionIn();

	}
	
	private function handleInput(event:KeyboardEvent){
		
		if (event.keyCode == Keyboard.SPACE) {
			
			if (selection == 0) {
				// NewGame
				var game = new Game(rootSprite);
				game.start();
				Starling.current.stage.removeEventListener(KeyboardEvent.KEY_DOWN, handleInput);
				transitionOut(function() {
					Root.assets.removeSound("GrandpaTallTales");
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
					Root.assets.removeSound("GrandpaTallTales");
					this.removeFromParent();
					this.dispose();
			});

			}
		}
		else if (tween == null || tween.isComplete)
		{	
			// Only allow moving if the current tween does not exist.
			if (event.keyCode == Keyboard.UP) {
				/*
				Root.assets.playSound("SelectOption");
				*/
				
				tween = new Tween(this.buttons[selection], rotateSpeed, Transitions.EASE_IN_OUT);
				tween.animate("fontSize", 24);
				Starling.juggler.add(tween);

				selection = arithMod(--selection, buttons.length);

				tween = new Tween(this.buttons[selection], rotateSpeed, Transitions.EASE_IN_OUT);
				tween.animate("fontSize", 40);
				Starling.juggler.add(tween);
			}
			else if (event.keyCode == Keyboard.DOWN) {
				/*
				Root.assets.playSound("SelectOption");
				*/
				
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
	private function startAnim(){
		toLeft();

	}

	private function toLeft(){
		var t = new Tween(title, 0.619, Transitions.EASE_IN_OUT);
		t.animate("x", title.x - 80);
		t.onComplete = toRight;
		Starling.juggler.add(t);
	}

	private function toRight(){
		var t = new Tween(title, 0.619, Transitions.EASE_IN_OUT);
		t.animate("x", title.x + 80);
		t.onComplete = toLeft;
		Starling.juggler.add(t);
	}
	private function helpTrans(?callBack:Void->Void) {

		var t = new Tween(this, transitionSpeed, Transitions.EASE_IN_OUT);
		t.animate("x", 1200);
		//t.animate("scaleY", 10);
		t.onComplete = callBack;
		Starling.juggler.add(t);
	}


	private function transitionOut(?callBack:Void->Void) {

		var t = new Tween(this, transitionSpeed, Transitions.EASE_IN_OUT);
		t.animate("x", 1000);
		t.onComplete = callBack;
		Starling.juggler.add(t);

	}
	
	private function transitionIn(?callBack:Void->Void) {
		
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
	
	private function creditTrans(?callBack:Void->Void) {
		
		var t = new Tween(this, 0.3, Transitions.LINEAR);
		t.animate("y", -300);
		t.onComplete = callBack;
		Starling.juggler.add(t);
	}

    public static function deg2rad(deg:Int)
    {
        return deg / 180.0 * Math.PI;
    }
	
	public static function arithMod(n:Int, d:Int) : Int {
		
		var r = n % d;
		if (r < 0)
			r += d;
		return r;
		
	}
	
}
