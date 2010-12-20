package  
{
	import org.flixel.*
	
	/**
	 * ...
	 * @author Ethan Kennerly
	 */
	public class Bullet extends FlxSprite
	{
		[Embed(source="../data/bullet.png")] public var GraphicClass:Class;
		public function Bullet(X:int = 0, Y:int = 0, SimpleGraphic:Class = null) 
		{
			super(X, Y, SimpleGraphic);
			if (null == SimpleGraphic) {
				this.loadGraphic(GraphicClass, false, false, 9, 9);
			}
			this.setup();
		}

		public function setup():void {
			var speed:Number = 
								// FlxG.width * 0.25; // same as ship
								// FlxG.width * 0.33; // too slow? 
								FlxG.width * 0.5; 
			this.maxVelocity.x = speed;
			this.maxVelocity.y = speed;
			this.exists = false;			
		}
		// Bullet Group
		public static var maxBullets:int = 
									// 4; // 15-25 fps
									8;
									// 16; // 20-25 fps
		public static function createGroup(BulletClass:Class):FlxGroup {
			var bullets:FlxGroup = new FlxGroup();
			for(var b:int = 0; b < Bullet.maxBullets; b++)
				bullets.add(new BulletClass());
			return bullets;
		}

		/* shoot left and right */
		public static function shootGroup(shooter:FlxSprite, bullets:FlxGroup, shootFacing:int = -9):void {
			Bullet._shootGroup(shooter, bullets, FlxSprite.LEFT);
			Bullet._shootGroup(shooter, bullets, FlxSprite.RIGHT);
		}
		
		/* shoot one direction */
		public static function _shootGroup(shooter:FlxSprite, bullets:FlxGroup, shootFacing:int = -9):void {
			// FlxG.log("shoot cannonball forward.");
			for each(var bullet:Bullet in bullets.members)
			{
				if (bullet.exists == false)
				{
					bullet.shoot(shooter, shootFacing);
					break;
				}
			}
		}
		
		/* shoot player facing by default */
		public function shoot(player:FlxSprite, shootFacing:int = -9):void {
			// FlxG.log("Bullet.shoot");
			// FlxG.play(SndBullet);
			if (-9 == shootFacing) {
				this.facing = player.facing;
			}
			else {
				this.facing = shootFacing;
			}
			this.velocity.x = 0;
			this.velocity.y = 0;
			// FlxG.log("Bullet.shoot:  facing = " + this.facing.toString() );
			if (FlxSprite.LEFT == this.facing) {
				this.velocity.x = -this.maxVelocity.x;
			}
			else if (FlxSprite.RIGHT == this.facing) {
				this.velocity.x = this.maxVelocity.x;
			}
			else if (FlxSprite.UP == this.facing) {
				this.velocity.y = -this.maxVelocity.y;
			}
			else if (FlxSprite.DOWN == this.facing) {
				this.velocity.y = this.maxVelocity.y;
			}
			else {
				FlxG.log("Bullet.shoot:  I was expecting facing left or right, not " + this.facing.toString() );
			}
			if (this.velocity.x != 0 || this.velocity.y != 0) {
				this.reset(player.x + 0.5 * player.frameWidth - this.width, player.y + 0.5 * player.frameHeight - this.height);
				this.solid = true;
				this.flicker( -1);
			}
		}
		
		public static function explodeGroup(shooter:FlxSprite, bullets:FlxGroup):void {
			// FlxG.log("explodeGroup:  shoot in four directions.");
			Bullet._shootGroup(shooter, bullets, FlxSprite.UP);
			Bullet._shootGroup(shooter, bullets, FlxSprite.RIGHT);
			Bullet._shootGroup(shooter, bullets, FlxSprite.DOWN);
			Bullet._shootGroup(shooter, bullets, FlxSprite.LEFT);
		}
		
		override public function update():void 
		{
			if (! this.onScreen()) {
				this.kill();
			}
			super.update();
		}
		
		override public function hitLeft(Contact:FlxObject, Velocity:Number):void { 
			this.kill();
		}
		override public function hitRight(Contact:FlxObject, Velocity:Number):void { 
			this.kill();
		}
		override public function hitTop(Contact:FlxObject, Velocity:Number):void { 
			this.kill();
		}
		override public function hitBottom(Contact:FlxObject, Velocity:Number):void { 
			this.kill();
		}
		public static function shootEnemy(me:FlxObject, enemy:FlxObject):void
		{
			if (!(me is Bullet))
			{
				FlxG.log("shootEnemy:  what is me?  " + me);
			}
			me.kill();
			enemy.hurt(1);
		}
		
	}

}


