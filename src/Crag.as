package 
{
	import org.flixel.*;

	public class Crag extends FlxSprite
	{
		[Embed(source="../data/crag.png")] private var GraphicClass:Class;
		public function Crag(X:int, Y:int)
		{
			super(X, Y);
			this.loadGraphic(GraphicClass);
			this.moves = false;
			this.fixed = true;
		}
	}
}
