import flash.events.Event;
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
import starling.events.EnterFrameEvent;
import starling.filters.SelectorFilter;
import flash.media.SoundTransform;
import flash.media.SoundChannel;
import flash.media.Sound;
import haxe.Timer;
import Std;

class GameOver extends Sprite {
	
	public var rootSprite:Sprite;
	private var selection:Int;
	private var buttons:Array<TextField>;
	private var title:Image;
	private var bg:Image;
	private var transitionInSpeed = 2.0;
	private var transitionOutSpeed = 1.0;
	private var tween:Tween;
	public var bgcolor = 255;
	public var center = new Vector3D(Starling.current.stage.stageWidth / 2.5, Starling.current.stage.stageHeight / 2.5);

	public function new() {
		super();
	}
	
	public function start() {
		
		var stageHeight = Starling.current.stage.stageHeight;
		
		//bg = new Image(Root.assets.getTexture("Classroom"));
		//bg.smoothing = "none";
		//this.addChild(bg);

	}
	
	private function handleInput(event:KeyboardEvent){

	}
	
	function cleanup() {
		Starling.current.stage.removeEventListener(KeyboardEvent.KEY_DOWN, handleInput);
	}

	private function transitionOut(?callBack:Void->Void) {

	}
	
	private function transitionIn(?callBack:Void->Void) {

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

	function onEnterFrame(event:EnterFrameEvent) {

	}

}
