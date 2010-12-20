package  
{
	import org.flixel.*;
	/**
	 * ...
	 * @author Ethan Kennerly
	 */
	public class Hydra extends Gunner
	{
		[Embed(source="../data/hydra.png")] private var GraphicClass:Class;
		public function Hydra(X:int, Y:int)
		{
			super(X, Y);
			this.loadGraphic(GraphicClass, false, true);
			this.loot = new Ruby();
			this.velocity.x = 0;
			this.shootFunction = Bullet.explodeGroup;
			this.bulletTimerMax = 
									// 2; // hard
									3;
		}
	}
}
