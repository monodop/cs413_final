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
	
	var progress:Int;
	var numFields:Int;
	var errors:Int;
	var strikes:Int;
	var numCorrect:Int;
	
	var paperContainer:Sprite;
	var paper:Image;
	var paperHands:Image;
	var textBubble:Image;
	var gradeLetter:Image;
	
	var paperHeading:TextField;
	var paperTitle:TextField;
	var paperBody:TextField;
	var speakerHead:Image;
	
	var fieldProgress = 0; // Determines what textobject should be popped next
	var fields:Array<TextObject>; // All of the textobject fields
	
	var currentField:TextObject;
	var renderProgress = 0; // How far in rendering the text animation we are (in characters)
	var animating = false;
	var soundCounter = 0;
	var waveRate = 0.125;
	
	var animTimer:Timer;
	
	var textBox:TextField = new TextField(512, 50, "", "5x7");
	var angryFilter:SelectorFilter;
	var normalFilter:SelectorFilter;

	public function new(rootSprite:Sprite, progress:Int, numFields:Int, numCorrect:Int, errors:Int, strikes:Int, progress:Int) {
		this.rootSprite = rootSprite;
		this.progress = progress;
		this.numFields = numFields;
		this.errors = errors;
		this.strikes = strikes;
		this.numCorrect = numCorrect;
		
		super();
	}
	
	public function start() {
		
		var stageHeight = Starling.current.stage.stageHeight;
		
		bg = new Image(Root.assets.getTexture("Classroom"));
		bg.smoothing = "none";
		this.addChild(bg);
		
		paperContainer = new Sprite();
		paperContainer.x = 0;
		paperContainer.y = stageHeight + 20;
		paper = new Image(Root.assets.getTexture("GameOver"));
		paper.smoothing = "none";
		paperContainer.addChild(paper);
		
		var date = Date.now();
		var headingTxt = "L. Timmy\n" +
						DateTools.format(date, "%D") + "\n" +
						"Great Depression 101";
		
		paperHeading = new TextField(200, 50, headingTxt, "5x7", 16, 0x0);
		paperHeading.vAlign = "top";
		paperHeading.hAlign = "right";
		paperHeading.x = 150;
		paperHeading.y = 40;
		paperContainer.addChild(paperHeading);
		
		paperTitle = new TextField(180, 50, "The Depression According To Gramps", "5x7", 16, 0x0);
		paperTitle.vAlign = "top";
		paperTitle.hAlign = "center";
		paperTitle.x = 175;
		paperTitle.y = 100;
		paperContainer.addChild(paperTitle);
		
		var bodyText = "    Think back to the first time you ever heard of the Great Depression. At " +
					   "first glance, the Great Depression may seem unenchanting. However, it's study " +
					   "is a necessity for any one wishing to intellectually advance beyond their childhood. " +
					   "While much has been written on its influence on contemporary living, it is impossible " +
					   "to overestimate its impact on modern thought. \n" +
					   "    Society is a simple word with a very complex definition. When blues legend 'Bare " +
					   "Foot D' remarked 'awooooh eeee only my";
		
		paperBody = new TextField(180, 200, bodyText, "5x7", 16, 0x0);
		paperBody.vAlign = "top";
		paperBody.hAlign = "left";
		paperBody.x = 175;
		paperBody.y = 130;
		paperContainer.addChild(paperBody);
		
		var completeness = (progress / numFields) * 100;
		var score = completeness-10*errors;
		var gradeLookup = [
			{ g: 100, a: "A_Plus",	m: "Perfect! I couldn't have done better myself!" },
			{ g: 95, a: "A_Plus",	m: "Fantastic! This paper is wonderful!" },
			{ g: 90, a: "A",		m: "Good job!" },
			{ g: 85, a: "B_Plus",	m: "You did great, but there's still room for improvement!" },
			{ g: 80, a: "B",		m: "Alright! Next time, try and proofread your work a little better." },
			{ g: 75, a: "C_Plus",	m: "This is not your best work. Apply yourself next time!" },
			{ g: 70, a: "C",		m: "Please try harder next time." },
			{ g: 65, a: "D_Plus",	m: "I am disappointed in you. I know you can do much better than this." },
			{ g: 60, a: "D",		m: "This is horribly incomplete and inaccurate. Please do better research next time." },
			{ g: 55, a: "F",		m: "I don't even know what to say." },
			{ g: 00, a: "F_Minus",	m: "Were you even trying? This is total garbage." },
		];
		var grade = gradeLookup[gradeLookup.length - 1];
		for (i in 0...gradeLookup.length) {
			var g = gradeLookup[i];
			if (score >= g.g) {
				grade = g;
				break;
			}
		}
		
		gradeLetter = new Image(Root.assets.getTexture("Letter_" + grade.a));
		gradeLetter.x = 177;
		gradeLetter.y = 35;
		gradeLetter.smoothing = "none";
		paperContainer.addChild(gradeLetter);
		
		paperHands = new Image(Root.assets.getTexture("GameOverHands"));
		paperHands.smoothing = "none";
		paperContainer.addChild(paperHands);
		this.addChild(paperContainer);
		
		textBubble = new Image(Root.assets.getTexture("TextBubble"));
		textBubble.x = 13;
		textBubble.y = stageHeight - 80;
		textBubble.smoothing = "none";
		this.addChild(textBubble);
		
		speakerHead = new Image(Root.assets.getTexture("TeacherHead"));
		speakerHead.x = 418;
		speakerHead.y = stageHeight - 144;
		speakerHead.smoothing = "none";
		this.addChild(speakerHead);
		
		fields = new Array<TextObject>();
		
		fields.push(new TextObject(grade.m));
		
		if (completeness < 50)
			fields.push(new TextObject("Your essay is not even half-finished. Please get more on paper next time."));
		else if (completeness < 70)
			fields.push(new TextObject("Your essay is lacking in breadth on this subject. Do a little bit more research and you'll ace it for sure."));
		else if (completeness < 90)
			fields.push(new TextObject("Your essay is so close to being a complete work! Just a little bit more effort next time!"));
		else
			fields.push(new TextObject("This essay is of perfect length! Keep up the good work!"));
		
		if (errors > 1)
			fields.push(new TextObject("I counted " + errors + " factual errors in this essay. Make sure to double-check your sources!"));
		else if (errors == 1)
			fields.push(new TextObject("I counted just one factual error in this essay. Not bad! See if you can catch them \nall next time!"));
		
		textBox.x = 20;
		textBox.y = stageHeight - 70;
		textBox.fontSize = 16;
		textBox.color = 0xffffff;
		textBox.hAlign = "left";
		textBox.vAlign = "top";
		
		angryFilter = new SelectorFilter(0.25, 125.0, 10.25, 0.0);
		normalFilter = new SelectorFilter(0.0, 0.0, 10.25, 0.0);
		textBox.filter = normalFilter;
		
		this.addChild(textBox);
		
		currentField = popTextObject();
		
		rootSprite.addChild(this);
		transitionIn(function() {
			startTextAnim();
			Starling.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, handleInput);
		});

	}
	
	private function handleInput(event:KeyboardEvent){
		
		if (event.keyCode == Keyboard.SPACE) {
			
			if(animating)
				skipTextAnim();
			else 
				advanceField();
		}
	}
	
	function cleanup() {
		Starling.current.stage.removeEventListener(KeyboardEvent.KEY_DOWN, handleInput);
	}

	private function transitionOut(?callBack:Void->Void) {

		var t = new Tween(paperContainer, transitionOutSpeed, Transitions.EASE_IN_OUT);
		t.animate("y", Starling.current.stage.stageHeight + 10);
		t.onComplete = callBack;
		Starling.juggler.add(t);
		
		var t = new Tween(this, transitionOutSpeed / 2, Transitions.EASE_IN_OUT);
		t.animate("alpha", 0);
		Starling.juggler.add(t);

	}
	
	private function transitionIn(?callBack:Void->Void) {
		
		var t = new Tween(paperContainer, transitionInSpeed, Transitions.EASE_IN_OUT);
		t.animate("y", 0);
		t.onComplete = callBack;
		Starling.juggler.add(t);
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
		//angryFilter.clk += waveRate * event.passedTime;
		//if (fieldState == FieldState.NO_ERROR_RESPONSE || fieldState == FieldState.ERROR_INCORRECT_RESPONSE)
		//	textBox.filter = angryFilter;
		//else
		//	textBox.filter = normalFilter;
	}
	
	function advanceField() {
		currentField = popTextObject();
		if (currentField == null)
		{
			// Exit
			var menu = new Main(rootSprite);
			menu.start();
			cleanup();
			transitionOut(function() {
				this.removeFromParent();
				this.dispose();
			});
		}
		else
		{
			startTextAnim();
		}
	}
	
	function startTextAnim() {
		renderProgress = 0;
		animating = true;
		if(animTimer != null)
			animTimer.stop();
		animTimer = new Timer(25);
		animTimer.run = animationTick;
	}
	
	function skipTextAnim() {
		textBox.text = getText();
		animating = false;
		animTimer.stop();
	}
	
	function animationTick() {
		var fullText = getText();
		textBox.text = fullText.substr(0, renderProgress);
		
		if(textBox.text.substr(-2, 1) == " ") {
			soundCounter = 0;
		} else if(soundCounter == 0) {
			var st:SoundTransform = new SoundTransform(0.25, 0);
			var sc:SoundChannel = Root.assets.playSound("text_sound_2");
			sc.soundTransform = st;
		}
		soundCounter ++;
		if(soundCounter == 2)
			soundCounter = 0;

		if (renderProgress < fullText.length)
			renderProgress++;
		else {
			animTimer.stop();
			animating = false;
		}
	}
	
	function getText():String {
		return currentField.text;
	}
	
	function popTextObject():TextObject {
		renderProgress = 0;
		if(fieldProgress < this.fields.length)
			return this.fields[fieldProgress++];
		return null;
		
	}
	
}
