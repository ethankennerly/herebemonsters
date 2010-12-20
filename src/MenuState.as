package

{

	import org.flixel.*;
	import org.flixel.data.FlxKong;


	public class MenuState extends FlxState

	{

		public var subtitle:FlxText;
		
		override public function create():void

		{

			var t:FlxText;

			t = new FlxText(0,FlxG.height/4,FlxG.width,"HERE BE MONSTERS!\nSAIL THE WORLD\nMAP THE MONSTERS");

			t.size = 16;

			t.alignment = "center";

			add(t);

			subtitle = new FlxText(FlxG.width/2-150,FlxG.height /2,300,"CLICK TO PLAY\n\nETHAN KENNERLY");

			subtitle.size = 12;
			subtitle.alignment = "center";

			add(subtitle);
			

			FlxG.mouse.show();

		}



		override public function update():void

		{
			// After stage is setup, connect to Kongregate.
			// http://flixel.org/forums/index.php?topic=293.0
			if (!FlxG.kong) {
				FlxG.kong = parent.addChild(new FlxKong()) as FlxKong;
				FlxG.kong.init();
			}

			super.update();



			if(FlxG.mouse.justPressed())

			{

				FlxG.mouse.hide();
				subtitle.text = "TO MOVE, PRESS ARROW KEYS\nTO START:  PRESS UP";
			}
			if (FlxG.keys.justPressed("UP")) {
				FlxG.state = new PlayState();
				
			}

		}

	}

}

