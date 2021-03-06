import flash.events.KeyboardEvent;
import flash.ui.Keyboard;
import menus.MainMenu;
import starling.core.Starling;
import starling.display.Sprite;
import starling.events.TouchEvent;
import starling.utils.AssetManager;
import utility.ControlManager;

class Root extends Sprite {

	public static var assets:AssetManager;
	public var rootSprite:Sprite;
	public static var controls:ControlManager;

	public static function init() {
		
	}
	
	public function new() {
		rootSprite = this;
		super();
	}

	public function start(startup:Startup) {

		controls = new ControlManager();
		controls.registerAction("left", Keyboard.A);
		controls.bindKey("left", Keyboard.LEFT);
		
		controls.registerAction("right", Keyboard.D);
		controls.bindKey("right", Keyboard.RIGHT);
		
		controls.registerAction("up", Keyboard.W);
		controls.bindKey("up", Keyboard.UP);
		
		controls.registerAction("down", Keyboard.S);
		controls.bindKey("down", Keyboard.DOWN);
		
		controls.registerAction("select", Keyboard.SPACE);
		controls.bindKey("select", Keyboard.ENTER);
		
		controls.registerAction("attack", Keyboard.Z);
		controls.registerAction("teleport", Keyboard.X);
		
		controls.registerAction("debugWorldSwitch", Keyboard.F2);
		controls.registerAction("quadtreevis", Keyboard.F1);
		
		controls.registerAction("pause", Keyboard.ESCAPE);
		
		Starling.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, controls.keyDown);
		Starling.current.stage.addEventListener(KeyboardEvent.KEY_UP, controls.keyUp);
		Starling.current.stage.addEventListener(TouchEvent.TOUCH, controls.touch);
		
		Starling.current.showStats = true;
		
		assets = new AssetManager();
		assets.enqueue("assets/spritesheet.png");
		assets.enqueue("assets/spritesheet.xml");
		assets.enqueue("assets/font/font.png");
		assets.enqueue("assets/font/font.fnt");
		assets.enqueue("assets/intro.png");
		assets.enqueue("assets/particles/snow_particle_config.pex");
		assets.enqueue("assets/particles/snow_walk_particle_config.pex");
		assets.enqueue("assets/particles/fireflies_config.pex");
		assets.enqueue("assets/sounds/Grandpa's Clock.mp3");
		assets.enqueue("assets/sounds/Jump_Sound_1.mp3");
		assets.enqueue("assets/sounds/Jump_Sound_2.mp3");
		assets.enqueue("assets/sounds/Hit_Sound_1.mp3");
		assets.enqueue("assets/sounds/Hit_Sound_2.mp3");
		assets.enqueue("assets/sounds/Hit_Sound_3.mp3");
		assets.enqueue("assets/sounds/Pickup_Sound_1.mp3");
		assets.enqueue("assets/sounds/Change_World__Sound_1.mp3");
		assets.enqueue("assets/sounds/Change_World_Sound_2.mp3");

		assets.loadQueue(function onProgress(ratio:Float) {
			haxe.Log.clear();
			if (ratio == 1) {
				haxe.Log.clear();
				startup.removeChild(startup.loadingBitmap);
				var menu = new MainMenu(rootSprite);
				menu.start();
			}
		});
	}
}
