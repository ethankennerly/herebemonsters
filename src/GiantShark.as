package  
{
	import org.flixel.*;
	/**
	 * ...
	 * @author Ethan Kennerly
	 */
	public class GiantShark extends Mobile
	{
		[Embed(source="../data/giant_shark.png")] private var GraphicClass:Class;
		public function GiantShark(X:int, Y:int)
		{
			super(X, Y);
			this.loadGraphic(GraphicClass, false, true);
			this.velocity.x = FlxG.width / 16;
			this.setCollisionRatio(0.75, 1.0);
		}
	}
}
