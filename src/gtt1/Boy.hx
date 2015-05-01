import starling.display.MovieClip;
import starling.animation.Juggler;
import starling.core.Starling;
import starling.display.Sprite;
import starling.events.Event;
import starling.textures.Texture;
import starling.textures.TextureAtlas;
import flash.media.SoundChannel;
import flash.media.Sound;


class Boy extends Sprite
{

    public var boyArt:MovieClip;

    public function new()
    {
        super();
        this.addEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedToStage);
    }

    public function onAddedToStage(event:Event)
    {
        this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

    }

    public function scratch()
    {

        boyArt = new MovieClip(Root.assets.getTextures("Boy_"), 6);
        var scratch:Sound = Root.assets.getSound("boy_scratch_sound_1");
        boyArt.smoothing = "none";
        boyArt.loop = true;
        boyArt.addFrameAt(7, Root.assets.getTexture("Boy_01"));    // adds the 1st frame to the end so his hand comes back down
        boyArt.setFrameDuration(0, 35);
        boyArt.setFrameDuration(7, 1);
        boyArt.setFrameSound(3, scratch);
        boyArt.setFrameSound(5, scratch);
        boyArt.setFrameSound(7, scratch);
        starling.core.Starling.juggler.add(boyArt);
        this.addChild(boyArt);

    }
}