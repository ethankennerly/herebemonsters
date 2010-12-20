package  
{
	import org.flixel.*;
	/**
	 * ...
	 * @author Ethan Kennerly
	 */
	public class Pirate extends Mobile
	{
		[Embed(source="../data/pirate.png")] private var GraphicClass:Class;
		public function Pirate(X:int, Y:int)
		{
			super(X, Y);
			this.loadGraphic(GraphicClass, false, true);
			this.velocity.x = 
								// FlxG.width / 12;
								FlxG.width / 8; // too fast to shoot
			this.loot = new Coin();
		}
	}
}
