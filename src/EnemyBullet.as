package  
{
	import org.flixel.*
	
	/**
	 * ...
	 * @author Ethan Kennerly
	 */
	public class EnemyBullet extends Bullet
	{
		/* Sloppy inheritance?  Asset class?  Pass graphic in constructor?  */
		[Embed(source="../data/enemy_bullet.png")] private var EnemyGraphicClass:Class;
		public function EnemyBullet(X:int = 0, Y:int = 0) 
		{
			super(X, Y, EnemyGraphicClass);
			var speed:Number = 
									FlxG.width * 0.08; 
									// FlxG.width * 0.18; // too hard
									//FlxG.width * 0.33; // too hard
			this.maxVelocity.x = speed;
			this.maxVelocity.y = speed;
		}
	}

}


