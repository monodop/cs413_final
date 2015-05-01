import starling.display.Sprite;
import starling.utils.AssetManager;
import starling.display.Image;
import starling.core.Starling;
import starling.animation.Transitions;
import starling.display.Stage;
import starling.events.EnterFrameEvent;
import starling.textures.Texture;
import starling.textures.TextureAtlas;
/**
@:bitmap("assets/Sprites.png")
class GrandpaBitmap extends flash.display.BitmapData{}
@:file("assets/Sprites.xml")
class GrandpaXml extends flash.utils.ByteArray{}
**/
class Root extends Sprite {

    public static var assets:AssetManager;
    public var rootSprite:Sprite;
	public var highScore:Int;
    private var gameTextureAtlas:TextureAtlas;

	public static function init() {
		
	}
	
    public function new() {
        rootSprite = this;
        super();
    }
/**
    public function getAtlas(){
        if (gameTextureAtlas == null){
            var texture:Texture = getTexture("GrandpaBitmap");
            var xml:Xml = Xml(new GrandpaXml());
            var bitmapData = Assets.getBitmapData("Sprites.png");
            gameTextureAtlas = new TextureAtlas(texture, xml);
        }
        return gameTextureAtlas;
    }
**/
    public function start(startup:Startup) {

        assets = new AssetManager();
        assets.enqueue("assets/Sprites.png");
        assets.enqueue("assets/Sprites.xml");
        assets.enqueue("assets/SpritesOld.png");
        assets.enqueue("assets/SpritesOld.xml");
        assets.enqueue("assets/Background.png");
        assets.enqueue("assets/Intro.png");
        assets.enqueue("assets/Classroom.png");
        assets.enqueue("assets/TextBubble.png");
	assets.enqueue("assets/Strike.png");
	assets.enqueue("assets/StrikeGray.png");
	assets.enqueue("assets/GameOver.png");
	assets.enqueue("assets/GameOverHands.png");
	assets.enqueue("assets/font/5x7.png");
	assets.enqueue("assets/font/5x7.fnt");
		
	assets.enqueue("assets/TeacherHead.png");
	assets.enqueue("assets/TimmyHead.png");
	assets.enqueue("assets/GrandpaHead.png");
		
	// Letter Grades
	assets.enqueue("assets/Letter_A_Plus.png");
	assets.enqueue("assets/Letter_A.png");
	assets.enqueue("assets/Letter_B_Plus.png");
	assets.enqueue("assets/Letter_B.png");
	assets.enqueue("assets/Letter_C_Plus.png");
	assets.enqueue("assets/Letter_C.png");
	assets.enqueue("assets/Letter_D_Plus.png");
	assets.enqueue("assets/Letter_D.png");
	assets.enqueue("assets/Letter_F.png");
	assets.enqueue("assets/Letter_F_Minus.png");

        // Sounds
        assets.enqueue("assets/sounds/GrandpaTallTales.mp3");
        assets.enqueue("assets/sounds/text_sound_1.mp3");
        assets.enqueue("assets/sounds/text_sound_2.mp3");
		assets.enqueue("assets/sounds/fart_sound_1.mp3");
		assets.enqueue("assets/sounds/scratch_sound_3.mp3");
		assets.enqueue("assets/sounds/wrong_sound_2.mp3");
		assets.enqueue("assets/sounds/boy_scratch_sound_1.mp3");
		assets.enqueue("assets/sounds/snore_sound_1.mp3");
		assets.enqueue("assets/sounds/snore_sound_2.mp3");
	
	//Music
	assets.enqueue("assets/sounds/testing.mp3");
		
	// Levels
	assets.enqueue("assets/levels/chapter1.txt");
		
        assets.loadQueue(function onProgress(ratio:Float) {
            haxe.Log.clear();
            if (ratio == 1) {
                haxe.Log.clear();
                startup.removeChild(startup.loadingBitmap);
                var menu = new Main(rootSprite);
                menu.start();
            }

        });
		
    }
}
