package 
{
	import org.flixel.*;

	public class Ruby extends Coin
	{
		[Embed(source="../data/ruby.png")] private var RubyGraphicClass:Class;
		public function Ruby(X:int = 0, Y:int = 0)
		{
			super(X, Y);
			loadGraphic(RubyGraphicClass, false);
			this.value = 20;
		}
		
	}
}
