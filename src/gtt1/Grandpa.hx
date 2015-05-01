import starling.display.MovieClip;
import starling.animation.Juggler;
import starling.core.Starling;
import starling.display.Sprite;
import starling.events.Event;
import starling.textures.Texture;
import starling.textures.TextureAtlas;
import flash.media.SoundChannel;
import flash.media.Sound;

class Grandpa extends Sprite
{

    public var grandpaArt:MovieClipPlus;
	
    public function new()
    {
        super();
        this.addEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedToStage);
    }

    public function onAddedToStage(event:Event)
    {
		
        this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		
    }
/*
	public function transitionS(game:Game){
		var x =  Std.random(100);
		if(x <60 ){
			game.removeChild(grandpaArt);
			scratch();
		}
		else{
			game.removeChild(grandpaArt);
			snore();
		}
	}
    /*
	public function transitionF(game:Game){
		game.removeChild(grandpaArt);
		fart();
	}
    */
	public function sit()
    {

        grandpaArt = new MovieClipPlus(Root.assets.getTextures("GrandpaOrig"));
        starling.core.Starling.juggler.add(grandpaArt);
        this.addChild(grandpaArt);

    }
	public function scratch()
    {
        var scratch:Sound = Root.assets.getSound("scratch_sound_3");
        grandpaArt = new MovieClipPlus(Root.assets.getTextures("Grandpa"), 5);
        grandpaArt.setNext(6,0);
		grandpaArt.smoothing = "none";
        grandpaArt.loop = true;
        grandpaArt.setFrameDuration(0,4);
        grandpaArt.setFrameSound(2, scratch);
        grandpaArt.setFrameSound(3, scratch);
        grandpaArt.setFrameSound(4, scratch);
        grandpaArt.setFrameSound(5, scratch);
        grandpaArt.setFrameSound(6, scratch);
        starling.core.Starling.juggler.add(grandpaArt);
        this.addChild(grandpaArt);

    }
	public function snore()
    {

        //grandpaArt = new MovieClipPlus(Root.assets.getTextures("Grandpa"), 5);
		grandpaArt.smoothing = "none";
        grandpaArt.setNext(18,9);
        starling.core.Starling.juggler.add(grandpaArt);
        this.addChild(grandpaArt);
		Root.assets.playSound("snore_sound_2");

    }
    public function fart()
    {
        //grandpaArt = new MovieClipPlus(Root.assets.getTextures("Grandpa"), 15);
        grandpaArt.setNext(29,19);
		grandpaArt.smoothing = "none";
        grandpaArt.setFrameDuration(9, 1);
        grandpaArt.loop = false;
        starling.core.Starling.juggler.add(grandpaArt);
        Root.assets.playSound("fart_sound_1");
        this.addChild(grandpaArt);
    }
}