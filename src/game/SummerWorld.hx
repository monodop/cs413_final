package game;

import menus.MenuState;
import starling.display.Image;

class SummerWorld extends World
{

	public function new(menustate:MenuState, mapName:String) 
	{
		this.bg = new Image(Root.assets.getTexture("world/GrassBG_01"));
		
		super(menustate, mapName);
		
	}
	
}