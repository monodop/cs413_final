package game.objects;
import starling.display.Image;

class Player extends BaseObject
{

	private var sprite:Image;
	
	public function new() 
	{
		
		super();
		
		this.sprite = new Image(Root.assets.getTexture("player/Player"));
		addChild(this.sprite);
		
	}
	
}