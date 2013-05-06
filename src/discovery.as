package
{
	import org.flixel.*;
	[SWF(width="550", height="400", backgroundColor="#000000")]
	[Frame(factoryClass="Preloader")]

	public class discovery extends FlxGame
	{
		public function discovery()
		{
            new TestTilemap();
			super(550,400,MenuState,1);
		}
	}
}
