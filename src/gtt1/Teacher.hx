import starling.display.MovieClip;
import starling.animation.Juggler;
import starling.core.Starling;
import starling.display.Sprite;
import starling.events.Event;
import starling.display.Image;
import starling.textures.Texture;
import starling.textures.TextureAtlas;
import flash.media.SoundChannel;
import flash.media.Sound;



class Teacher extends Sprite
{

    private var teacherArt:Image;

    public function new()
    {
        super();
        this.addEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedToStage);
    }

    private function onAddedToStage(event:Event)
    {
        this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
        start();

    }

    private function start()
    {
        //teacherArt = new MovieClip(Root.assets.getTextures("Boy_"), 6);
        //teacherArt.smoothing = "none";
        //teacherArt.loop = true;
        //teacherArt.addFrameAt(7, Root.assets.getTexture("Boy_1"));    // adds the 1st frame to the end so his hand comes back //down
        //teacherArt.setFrameDuration(0, 10);
        //teacherArt.setFrameDuration(7, 30);
        //starling.core.Starling.juggler.add(teacherArt);
        teacherArt = new Image(Root.assets.getTexture("Teacher01"));
        teacherArt.scaleX = -2.0;
        teacherArt.scaleY = 2.0;
        teacherArt.smoothing = "none";
        this.addChild(teacherArt);
    }
}