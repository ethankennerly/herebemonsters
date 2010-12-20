package 
{
	import org.flixel.*;

	public class Cannon extends Pickup
	{
		[Embed(source="../data/cannon.png")] private var GraphicClass:Class;
		
		public function Cannon(X:int, Y:int)
		{
			super(X, Y);
			this.loadGraphic(GraphicClass, false);
		}
	}
}
