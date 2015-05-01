package game;

import menus.MenuState;
import starling.core.Starling;
import starling.display.Image;
import starling.events.EnterFrameEvent;
import starling.extensions.PDParticleSystem;

class SummerWorld extends World
{
	public var firefliesPS:PDParticleSystem;

	public function new(menustate:MenuState, mapName:String) 
	{
		this.bg = new Image(Root.assets.getTexture("world/GrassBG_01"));

		super(menustate, mapName);
		firefliesPS = new PDParticleSystem(Root.assets.getXml("fireflies_config"), Root.assets.getTexture("particles/fireflies_particle"));
		firefliesPS.scaleX = 1 / tileSize / 2;
		firefliesPS.scaleY = 1 / tileSize / 2;
		firefliesPS.lifespan = 16;

		this.addChild(firefliesPS);


	}
	public override function update(event:EnterFrameEvent) {
		super.update(event);

		var camBounds = camera.getCameraBounds(this);
		firefliesPS.emitterX = camera.x * tileSize * 2;
		firefliesPS.emitterY = camBounds.top * tileSize;
	}

	public override function awake() {
		super.awake();
		Starling.juggler.add(firefliesPS);
		firefliesPS.start();
	}

	public override function sleep() {
		super.sleep();
		firefliesPS.stop();
		Starling.juggler.remove(firefliesPS);
	}
	
}