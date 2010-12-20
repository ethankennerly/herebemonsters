package  
{
	import org.flixel.*;
	/**
	 * ...
	 * @author Ethan Kennerly
	 */
	public class Fish extends Mobile
	{
		[Embed(source="../data/fish.png")] private var GraphicClass:Class;
		public function Fish(X:int, Y:int)
		{
			super(X, Y);
			this.loadGraphic(GraphicClass, false, true);
			this.velocity.x = FlxG.width / 16;
		}
		public static function eaten(me:FlxObject, you:FlxObject):void {
			if (! (me is Fish)) {
				FlxG.log("Fish.save: me is not Fish? " + me.toString());
			}
			var self:Fish = me as Fish;
			if (you is Player) {
				var player:Player = you as Player;
				if (player.food <= 90) { 
					self.kill();
					player.setMessage("MMM.  WILD HERRING.");
					player.food += 20;
					if (player.maxFood < player.food) {
						player.food = player.maxFood;
					}
				}
			}
			else {
				self.kill();				
			}
		}
	}
}
