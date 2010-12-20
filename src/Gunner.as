package  
{
	import org.flixel.*;
	/**
	 * ...
	 * @author Ethan Kennerly
	 */
	public class Gunner extends Mobile
	{
		
		[Embed(source="../data/gunner.png")] private var GraphicClass:Class;
		public function Gunner(X:int, Y:int)
		{
			super(X, Y);
			this.loadGraphic(GraphicClass, false, true);
			// this.velocity.x = FlxG.width / 8;
			this.velocity.x = 
								FlxG.width * 0.05;
								// FlxG.width / 12; // faster than bullet
								// FlxG.width / 8; // too fast to shoot
			this.loot = new Coin();
		}
		/* pirate creates enemy bullet to see.  enemy bullet is red
		 * .  enemy bullet is added to enemy_bullets.  enemy bullets are bullets that collide with land.  
		 * enemy_bullets collide with player.  enemy bullet destroys rocks or crags too. */
		public var bulletTimerMax:Number = 3;
		public var bulletTimer:Number = 3;
		public var shootFunction:Function = Bullet.shootGroup;
		public function updateBullet():void {
			this.bulletTimer -= FlxG.elapsed;
			if (this.bulletTimer <= 0) {
				// FlxG.log("Gunner.updateBullet:  bang!");
				this.shootFunction(this, this.world.enemy_bullets);
				this.bulletTimer = this.bulletTimerMax;
			}
		}
		
		override public function update():void 
		{
			if (this.onScreen()) {
				this.updateBullet();
			}
			super.update();
		}
	}
}
