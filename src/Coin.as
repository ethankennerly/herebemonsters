package 
{
	import org.flixel.*;

	public class Coin extends Pickup
	{
		[Embed(source="../data/coin.png")] private var GraphicClass:Class;
		public var value:int = 1;
		public function Coin(X:int = 0, Y:int = 0)
		{
			super(X, Y);
			loadGraphic(GraphicClass, false);
			this.value = 1;
		}
		
	}
}
