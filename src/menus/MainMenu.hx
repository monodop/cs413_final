package menus;

import starling.display.Sprite;
import starling.display.Image;
import starling.text.TextField;
import starling.text.BitmapFont;
import starling.core.Starling;
import starling.animation.Transitions;
import starling.animation.Tween;
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
		this.scaleX = 8;
		this.scaleY = 8;
		bg = new Image(Root.assets.getTexture("world/SnowPlatform"));
		gametitle = new TextField(350, 50, "game", "font");
		gametitle.text = "game";
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
		rootSprite.addChild(this);
		}
		
	}
	
	override function deinit() {
		
	}
	
	override function awake() {
		
	}
	override function sleep() {
		
	}
	
	private override function transitionIn(?callback:Void->Void) {
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
		callback();
	}
	private override function transitionOut(?callback:Void->Void) {
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
		callback();
	}
	
}