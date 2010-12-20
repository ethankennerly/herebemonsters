package 
{
	import org.flixel.*;

	public class Rock extends FlxSprite
	{
		[Embed(source="../data/rock.png")] private var GraphicClass:Class;
		
		public function Rock(X:int, Y:int)
		{
			super(X, Y);
			this.loadGraphic(GraphicClass);
			this.moves = false;
			this.fixed = true;
		}
	}
}
