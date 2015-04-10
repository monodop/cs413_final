package menus;

import starling.display.Sprite;

class MainMenu extends MenuState
{
	
	public function new(rootSprite:Sprite) 
	{
		super(rootSprite);
		
	}
	
	override function init() {
		rootSprite.addChild(this);
		
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