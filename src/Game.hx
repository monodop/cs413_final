import starling.display.Sprite;
import starling.display.Image;
import starling.core.Starling;
import starling.text.TextField;
import starling.events.KeyboardEvent;
import starling.events.EnterFrameEvent;
import starling.events.Event;
import starling.filters.BlurFilter;
import starling.filters.SelectorFilter;
import starling.animation.Transitions;
import starling.animation.Tween;
import starling.display.MovieClip;
import starling.animation.Juggler;
import starling.textures.Texture;
import starling.textures.TextureAtlas;
import flash.media.SoundTransform;
import flash.media.SoundChannel;
import flash.media.Sound;
import flash.ui.Keyboard;

import haxe.io.Bytes;
import haxe.io.BytesInput;
import haxe.io.Eof;
import haxe.Timer;
import game.World;

class Game extends Sprite
{
	
	var rootSprite:Sprite;
	var bg:Image;
	var transitionSpeed = 0.5;
	var world:World;

	public function new(root:Sprite) {
		super();
		this.rootSprite = root;
	}
	
	public function start() {
		
		var stage = Starling.current.stage;
		var stageWidth:Float = Starling.current.stage.stageWidth;
		var stageHeight:Float = Starling.current.stage.stageHeight;

		addEventListener(Event.ENTER_FRAME, onEnterFrame);

		//map = new Tilemap(Root.assets, "map");
		//map.scaleX = .3;
		//map.scaleY = .3;
		//stage.addChild(map);

		//player = new Image(Root.assets.getTexture("Player"));
		//player.smoothing = "none";
		//player.x = 40;
		//player.y = 70;
		//stage.addChild(player);

		//bg = new Image(Root.assets.getTexture("Background"));
		//bg.smoothing = "none";

		//this.addChild(bg);
		stage.addChild(world);
	}
	
	public function cleanup() {

	}
	
	function onEnterFrame(event:EnterFrameEvent) {

	}



	private function transitionOut(?callBack:Void->Void) {

		var t = new Tween(this, transitionSpeed, Transitions.EASE_IN_OUT);
		t.animate("alpha", 0);
		t.onComplete = callBack;
		Starling.juggler.add(t);

	}
}

enum FieldState {
	TEXT;
	CORRECTION_TRANSITION;
	CORRECTIONS;
	NO_ERROR_RESPONSE;
	ERROR_CORRECT_RESPONSE;
	ERROR_INCORRECT_RESPONSE;
	INTRO;
	OUTRO;
}