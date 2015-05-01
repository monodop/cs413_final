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

import haxe.io.Bytes;
import haxe.io.BytesInput;
import haxe.io.Eof;

import haxe.Timer;

import flash.ui.Keyboard;

class Game extends Sprite
{
	
	var rootSprite:Sprite;
	var levelFile:String;
	var progress = 0;
	var errorsSkipped = 0;
	var strikes = 0;
	var numCorrect = 0;
	var fieldProgress = 0; // Determines what textobject should be popped next
	var fields:Array<TextObject>; // All of the textobject fields
	var introFields:Array<TextObject>; // All of the intro fields
	var outroFields:Array<TextObject>; // All of the outro fields
	
	var currentSpeaker:Speakers;
	var currentField:TextObject;
	var fieldState = FieldState.INTRO;
	var renderProgress = 0; // How far in rendering the text animation we are (in characters)
	var animating = false;
	var soundCounter = 0;
	var menuSelection = 0;
	var waveRate = 0.125;
	
	var animTimer:Timer;
	
	var textBox:TextField = new TextField(512, 50, "", "5x7");
	var angryFilter:SelectorFilter;
	var normalFilter:SelectorFilter;


	var bg:Image;
	var textBubble:Image;
	var speakerHead:Image;
	var grandpa:MovieClipPlus;
	var teacher:Teacher;
	var boy:Boy;
	var fire: Fire;
	var strikeImages:Array<Image>;
	
	var transitionSpeed = 0.5;
	
	public function new(root:Sprite) {
		super();
		this.rootSprite = root;


		this.levelFile = "chapter1";
		
		introFields = [
			new TextObject("Timmy, I want you to write me a history paper!", Speakers.TEACHER, Backgrounds.SCHOOL),
			new TextObject("OK! What should I write it on? World War 2? I bet that would be awesome!", Speakers.TIMMY, Backgrounds.SCHOOL),
			new TextObject("Psshh. Everyone does that. I want you to do something a little different. \nWasn't your grandpa alive during the Great Depression? \nYou should ask him to give you a lesson and write about that!", Speakers.TEACHER, Backgrounds.SCHOOL),
			new TextObject("Um... but he's...                 \nso                 \nold! ", Speakers.TIMMY, Backgrounds.SCHOOL),
			new TextObject("Don't be rude!!                       \nBut you're right...\nWell you're just going to have to listen closely and press [C] whenever you think he's misremembering something! Now GO!", Speakers.TEACHER, Backgrounds.SCHOOL),
			new TextObject("... C?     \nnevermind...", Speakers.TIMMY, Backgrounds.SCHOOL),
			new TextObject("Hey Grandpa, I'm writing a paper about the Great Depression, can you help me? \nI don't know very much about it.", Speakers.TIMMY),
			new TextObject("Wuzzat? You wanna hear about the Depression? Alright!", Speakers.GRANDPA)
		];
		
		outroFields = [
			new TextObject("Well... On THAT note... I guess we're done here. \nI'm sure that will be enough for your paper!", Speakers.GRANDPA),
			new TextObject("Sure Gramps! Thanks a lot for your help!", Speakers.TIMMY),
			new TextObject("Hey teach. I got my paper finished!", Speakers.TIMMY, Backgrounds.SCHOOL),
			new TextObject("Okay. Let's see how you did. I'm expecting a lot from you this time.", Speakers.TEACHER, Backgrounds.SCHOOL)
		];
		
		load();
	}
	
	public function start() {
		
		var stage = Starling.current.stage;
		var stageWidth:Float = Starling.current.stage.stageWidth;
		var stageHeight:Float = Starling.current.stage.stageHeight;

		errorsSkipped = 0;
		strikes = 0;
		
		Starling.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		addEventListener(Event.ENTER_FRAME, onEnterFrame);

		bg = new Image(Root.assets.getTexture("Background"));

		fire = new Fire();
		teacher = new Teacher();
		textBubble = new Image(Root.assets.getTexture("TextBubble"));

		bg.smoothing = "none";

		teacher.x = 170;
		teacher.y = 190;

		fire.x = 440;
		fire.y = 228;
		textBubble.x = 13;
		textBubble.y = stageHeight - 80;
		textBubble.smoothing = "none";

		grandpa = new MovieClipPlus(Root.assets.getTextures("Grandpa"), 5);
		boy = new Boy();
		grandpa.x = 270;
		grandpa.y = 190;
		boy.x = 190;
		boy.y = 250;

		this.addChild(bg);
		this.addChild(boy);
		this.addChild(teacher);
		this.addChild(fire);
		this.addChild(textBubble);
		boy.scratch();
		
		var scratch:Sound = Root.assets.getSound("scratch_sound_3");
		grandpa.setNext(6,0);
		grandpa.smoothing = "none";
        grandpa.setFrameDuration(0,40);
        grandpa.setFrameSound(2, scratch);
        grandpa.setFrameSound(3, scratch);
        grandpa.setFrameSound(4, scratch);
        grandpa.setFrameSound(5, scratch);
        grandpa.setFrameSound(6, scratch);
        starling.core.Starling.juggler.add(grandpa);
        this.addChild(grandpa);

		strikeImages = new Array<Image>();
		for (i in 0...3) {
			var img = new Image(Root.assets.getTexture("StrikeGray"));
			img.x = 10 + 40 * i;
			img.y = 10;
			img.smoothing = "none";
			strikeImages.push(img);
			this.addChild(img);
		}

		rootSprite.addChild(this);
		
		textBox.x = 20;
		textBox.y = stageHeight - 70;
		textBox.fontSize = 16;
		textBox.color = 0xffffff;
		textBox.hAlign = "left";
		textBox.vAlign = "top";
		
		speakerHead = new Image(Root.assets.getTexture("GrandpaHead"));
		speakerHead.x = 30;
		speakerHead.y = stageHeight - 144;
		speakerHead.smoothing = "none";
		this.addChild(speakerHead);
		
		
		angryFilter = new SelectorFilter(0.25, 125.0, 10.25, 0.0);
		normalFilter = new SelectorFilter(0.0, 0.0, 10.25, 0.0);
		textBox.filter = normalFilter;
		
		addChild(textBox);
		
		currentField = popTextObject();
		currentSpeaker = currentField.speaker;
		
		startTextAnim();

		rootSprite.addChild(this);
		
	}
	
	public function cleanup() {
		Starling.current.stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		animTimer.stop();
		this.removeFromParent;
		this.dispose;
	}
	
	function onKeyDown(event:KeyboardEvent) {
		if (event.keyCode == Keyboard.SPACE) {
			if(animating)
				skipTextAnim();
			else if (fieldState != FieldState.CORRECTIONS) {
				if (fieldState == FieldState.CORRECTION_TRANSITION) {
					if(currentField.correct) {
						fieldState = FieldState.NO_ERROR_RESPONSE;
						currentSpeaker = Speakers.GRANDPA;						
						
						//GRANDPA WILL FART OUT OF EXCITEMENT FOR BEING CORRECT

						//this.removeChild(grandpa);
						//grandpa = new Grandpa();
						//grandpa.x = 270;
						//grandpa.y = 190;
						//grandpa.fart();
						//grandpa.transitionF(this);
						//breaks it grandpa = new MovieClipPlus(Root.assets.getTextures("grandpa"),15);

						grandpa.gotoAndPlay(19);
						grandpa.setNext(29,20);
						grandpa.setNext(29,0);
						//grandpa.pause();
						//grandpa.setFrameDuration
						//grandpa.loop = false;
						//grandpa.setFrameDuration(9, 1);
						starling.core.Starling.juggler.add(grandpa);
						Root.assets.playSound("fart_sound_1");


						
						addStrike();
					}
					else {
						fieldState = FieldState.CORRECTIONS;
						currentSpeaker = Speakers.TIMMY;
						menuSelection = 0;
						normalFilter.selected = true;
						normalFilter.selectedLine = 0;
					}
					startTextAnim();
				}
				else
				{
					if (fieldState == FieldState.TEXT && !currentField.correct) {
						errorsSkipped++;
					}
					
					if(fieldState != FieldState.INTRO && fieldState != FieldState.OUTRO)
						fieldState = FieldState.TEXT;
					advanceField();
				}
			}
			else {
				normalFilter.selected = false;
				if (currentField.checkAnswer(menuSelection + 1))
					fieldState = FieldState.ERROR_CORRECT_RESPONSE;
				else {
					fieldState = FieldState.ERROR_INCORRECT_RESPONSE;
					errorsSkipped++;
					addStrike();
				}
				currentSpeaker = Speakers.GRANDPA;
				startTextAnim();
			}
		}
		else if (event.keyCode == Keyboard.C) {
		
			//GRANDPA STARTS SNORING WHEN YOU TRY TO CORRECT HIM
			//grandpa.snore();
			//grandpa.transitionS(this);
			
			var snore:Sound = Root.assets.getSound("snore_sound_2");
			grandpa.gotoAndPlay(7);
			grandpa.setNext(18,7);
			grandpa.setNext(18,0);
			grandpa.setFrameSound(8, snore);
			grandpa.setFrameSound(9, snore);
			grandpa.setFrameSound(10, snore);
			grandpa.setFrameSound(11, snore);
			grandpa.setFrameSound(12, snore);
			grandpa.setFrameSound(13, snore);
			grandpa.setFrameSound(14, snore);
			grandpa.setFrameSound(15, snore);
			grandpa.setFrameSound(16, snore);
			grandpa.setFrameSound(17, snore);
			grandpa.setFrameSound(18, snore);
			starling.core.Starling.juggler.add(grandpa);

			
			if (fieldState == FieldState.TEXT) {
			
				fieldState = FieldState.CORRECTION_TRANSITION;
				currentSpeaker = Speakers.TIMMY;
				startTextAnim();
				}

		}
		else if (fieldState == FieldState.CORRECTIONS) {
			switch(event.keyCode) {
				case Keyboard.UP:
					menuSelection--;
					if (menuSelection < 0)
						menuSelection = 3;
				case Keyboard.DOWN:
					menuSelection++;
					if (menuSelection > 3)
						menuSelection = 0;
			}
			normalFilter.selectedLine = menuSelection;
		}
	}
	
	function onEnterFrame(event:EnterFrameEvent) {
		angryFilter.clk += waveRate * event.passedTime;
		if (fieldState == FieldState.NO_ERROR_RESPONSE || fieldState == FieldState.ERROR_INCORRECT_RESPONSE)
			textBox.filter = angryFilter;
		else
			textBox.filter = normalFilter;
	}
	
	function addStrike() {
		//Plays wrong sound
		//Root.assets.playSound("fart_sound_1");
		strikeImages[strikes].texture = Root.assets.getTexture("Strike");
		strikes++;
		if (strikes == 4) {
			
			// Exit
			var gameover = new GameOver(rootSprite, fieldProgress, fields.length, numCorrect, errorsSkipped, strikes, progress);
			gameover.start();
			cleanup();
			transitionOut(function() {
				this.removeFromParent();
				this.dispose();
			});
		}
	}
	
	function advanceField() {
		currentField = popTextObject();
		if (currentField == null)
		{
			// Exit
			var gameover = new GameOver(rootSprite, fieldProgress, fields.length, numCorrect, errorsSkipped, strikes, progress);
			gameover.start();
			cleanup();
			transitionOut(function() {
				this.removeFromParent();
				this.dispose();
			});
		}
		else
		{
			currentSpeaker = currentField.speaker;
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
		
		
		switch(currentSpeaker) {
			case Speakers.GRANDPA:
				speakerHead.x = 418;
				speakerHead.texture = Root.assets.getTexture("GrandpaHead");
			case Speakers.TEACHER:
				speakerHead.x = 418;
				speakerHead.texture = Root.assets.getTexture("TeacherHead");
			case Speakers.TIMMY:
				speakerHead.x = 30;
				speakerHead.texture = Root.assets.getTexture("TimmyHead");
		}

		switch(currentField.background) {
			case Backgrounds.HOUSE:
				bg.texture = Root.assets.getTexture("Background");
				grandpa.visible = true;
				fire.visible = true;
				boy.visible = true;
				teacher.visible = false;
			case Backgrounds.SCHOOL:
				bg.texture = Root.assets.getTexture("Classroom");
				grandpa.visible = false;
				fire.visible = false;
				boy.visible = false;
				teacher.visible = true;
		}
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
		var text = "";
		switch(fieldState) {
			case FieldState.TEXT: 						text = currentField.text;
			case FieldState.INTRO: 						text = currentField.text;
			case FieldState.OUTRO: 						text = currentField.text;
			case FieldState.CORRECTION_TRANSITION:		text = "No grandpa... That's not right...";
			case FieldState.CORRECTIONS: 				text = currentField.getOptionText();
			case FieldState.ERROR_CORRECT_RESPONSE:		text = currentField.revised;
			case FieldState.ERROR_INCORRECT_RESPONSE:	text = "DO YOU REALLY THINK THAT'S RIGHT, KIDDO?! REALLY!? THAT!?";
			case FieldState.NO_ERROR_RESPONSE:			text = "SONNY BOY, DON'T QUESTION ME. I WAS THERE, REMEMBER?";
		}
		
		return text;
	}
	
	function load() {

		var byteArray = Root.assets.getByteArray(this.levelFile);
		var bytes = Bytes.ofData(byteArray);
		var bi = new BytesInput(bytes);
		
		var fields = new Array<TextObject>();
		try {
			while (true) {
				var field = new TextObject();
				bi.readLine();
				bi.readLine();
				field.correct = bi.readLine() == "C";
				field.text = bi.readLine() + "\n" + bi.readLine() + "\n" + bi.readLine() + "\n" + bi.readLine();
				if(!field.correct) {
					field.options = new Array<String>();
					field.options.push(bi.readLine().substr(3));
					field.options.push(bi.readLine().substr(3));
					field.options.push(bi.readLine().substr(3));
					field.options.push(bi.readLine().substr(3));
					field.revised = bi.readLine() + "\n" + bi.readLine() + "\n" + bi.readLine() + "\n" + bi.readLine();
					numCorrect += 1;
				
				}
				progress++;
				fields.push(field);
			}
		} catch (e:Eof) { }
		
		bi.close();
		
		this.fields = fields;
		
	}
	
	function popTextObject():TextObject {
		
		var fields = this.fields;
		if (fieldState == FieldState.INTRO)
			fields = introFields;
		else if (fieldState == FieldState.OUTRO)
			fields = outroFields;
		
		renderProgress = 0;
		if(fieldProgress < fields.length)
			return fields[fieldProgress++];
		else {
			
			if (fieldState == FieldState.INTRO) {
				fieldState = FieldState.TEXT;
				fieldProgress = 0;
				return popTextObject();
			}
			else if (fieldState != FieldState.OUTRO) {
				fieldState = FieldState.OUTRO;
				fieldProgress = 0;
				return popTextObject();
			}
			
		}
		return null;
		
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