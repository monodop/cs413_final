import starling.display.MovieClip;
import starling.textures.Texture;


// Provides an extended version of Starling's MovieClip which matches the
// Flash MovieClip class better in terms of methods.
class MovieClipPlus extends MovieClip {

    private var mTarget:Map<Int, Int>;

    public function new(textures:flash.Vector<Texture>, fps:Int=12) {
        super(textures, fps);
        mTarget = new Map<Int, Int>();
    }

// Custom advanceTime function.
    public override function advanceTime(passedTime:Float) {
        var lf = currentFrame;
        super.advanceTime(passedTime);
        if (lf != currentFrame && mTarget.exists(lf)) {
            var target = mTarget[lf];
            if (target == -1) {
                currentFrame = lf;
                stop();
            } else {
                currentFrame = target;
                play();
            }
        }
    }

// Starts playing at the specified frame.
    public function gotoAndPlay(frame:Int) {
        currentFrame = frame;
        play();
    }

// Brings the playhead to the specified frame and stops.
    public function gotoAndStop(frame:Int) {
        currentFrame = frame;
        stop();
    }

// Sends the playhead to the next frame and stops it.
    public function nextFrame() {
        if (currentFrame == numFrames-1) {
            currentFrame = 0;
        } else {
            currentFrame += 1;
        }
        stop();
    }

// Sends the playhead to the previous frame and stops it.
    public function prevFrame() {
        if (currentFrame == 0) {
            currentFrame = numFrames-1;
        } else {
            currentFrame -= 1;
        }
        stop();
    }

// Sets the successor (target) frame for rendering after the specified frame.
// Use this method instead of scripting control in the frames as you would
// do with Flash.
    public function setNext(frame:Int, target:Int=0) {
        mTarget[frame] = target;
    }

// Stops the playhead in the movie clip.
    public override function stop() {
        pause();
    }

}

// Usage:
//
// var atlas = Root.assets.getTextureAtlas("assets");
// var hero = new MovieClipPlus(atlas.getTextures("hero"), 7);
// // After frame 3 goto frame 0 creating a loop
// hero.setNext(3, 0);