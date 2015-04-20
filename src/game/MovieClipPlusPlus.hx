package game;

import flash.Vector;
import starling.textures.Texture;
import haxe.ds.StringMap;

class MovieClipPlusPlus extends MovieClipPlus
{

	private var mappings:StringMap<Int>;
	private var lastAnimation:String;
	
	public function new(textures:StringMap<flash.Vector<Texture>>, fps:Int=12) 
	{
		var texVector = new Vector<Texture>();
		mappings = new StringMap<Int>();
		
		var i = 0;
		for (key in textures.keys()) {
			
			mappings.set(key, i);
			
			for (texture in textures.get(key)) {
				texVector.push(texture);
				i++;
			}
			
		}
		
		
		super(texVector, fps);
		
		for (key in mappings.keys()) {
			setNext(getAnimationEndFrame(key), -1);
		}
		
	}
	
	public function getAnimationEndFrame(key:String):Int {
		var start = mappings.get(key);
		var next_highest = -1;
		
		for (k in mappings.keys()) {
			
			if ( (next_highest == -1 || mappings.get(k) < next_highest) && mappings.get(k) > start) {
				next_highest = mappings.get(k);
			}
			
		}
		
		if (next_highest == -1)
			next_highest = this.numFrames - 1;
		else
			next_highest--;
		
		return next_highest;
	}
	
	public function setLoop(key:String):Void {
		
		var start = mappings.get(key);
		setNext(getAnimationEndFrame(key), start);
		
	}
	
	public function setAnimationDuration(key:String, duration:Float):Void {
		
		var start = mappings.get(key);
		var end = getAnimationEndFrame(key);
		
		for (i in start...end + 1) {
			setFrameDuration(i, duration);
		}
		
	}
	
	public function changeAnimation(key:String):Void {
		gotoAndPlay(mappings.get(key));
		lastAnimation = key;
	}
	
	public function getLastAnimation():String {
		return this.lastAnimation;
	}
	
}