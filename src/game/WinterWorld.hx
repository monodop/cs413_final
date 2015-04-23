package game;

import menus.MenuState;
import starling.core.Starling;
import starling.display.Image;
import starling.events.EnterFrameEvent;
import starling.extensions.PDParticleSystem;

class WinterWorld extends World
{
	
	public var snowPS:PDParticleSystem;

	public function new(menustate:MenuState, mapName:String) 
	{
		this.bg = new Image(Root.assets.getTexture("world/SnowBG_01"));
		
		super(menustate, mapName);
		
		snowPS = new PDParticleSystem(Root.assets.getXml("snow_particle_config"), Root.assets.getTexture("particles/snow_particle"));
		snowPS.scaleX = 1 / tileSize / 2;
		snowPS.scaleY = 1 / tileSize / 2;
		//snowPS.startColor = ColorArgb.fromArgbToArgb(0xffff0000);
		//snowPS.endColor = ColorArgb.fromArgbToArgb(0xff0000ff);
		snowPS.lifespan = 32;
		this.addChild(snowPS);
		Starling.juggler.add(snowPS);
		snowPS.start();
		
	}
	
	public override function update(event:EnterFrameEvent) {
		super.update(event);
		
		var camBounds = camera.getCameraBounds(this);
		snowPS.emitterX = camera.x * tileSize * 2;
		snowPS.emitterY = camBounds.top * tileSize;
	}
}