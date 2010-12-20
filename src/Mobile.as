package  
{
	import org.flixel.*;
	import flash.utils.getTimer;
	
	/**
	 * ...
	 * @author Ethan Kennerly
	 */
	public class Mobile extends FlxSprite
	{
		public var loot:FlxSprite = null;
		public var world:PlayState;
		public var maxHealth:int;
		public function Mobile(X:int = 0, Y:int = 0, SimpleGraphic:Class = null):void 
		{
			super(X, Y, SimpleGraphic);
			this.spawn = new FlxPoint(X, Y);
			if (! this.maxHealth) {
				this.maxHealth = 1;
			}
			this.health = this.maxHealth;
		}
		
		public var spawn:FlxPoint;
		public var deadMillisecond:int;
		public var deadMillisecondMin:int
		/* if off screen and dead and spawn point is also offscreen, reset 
		 * limit farming by time dead.  */
		public static function respawn(mobiles:FlxGroup):void {
			for (var m:int = 0; m < mobiles.members.length; m ++ ) {
				var mobile:Mobile = mobiles.members[m];
				if (mobile.deadMillisecond + mobile.deadMillisecondMin < getTimer() ) {
					var spawner:FlxObject = new FlxObject(mobile.spawn.x, mobile.spawn.y);
					if (! mobile.onScreen() && ! spawner.onScreen()) { 
						mobile.reset(mobile.spawn.x, mobile.spawn.y);
						mobile.health = mobile.maxHealth;
					}
				}
			}
		}
		/* center collision as ratio of frame.  */
		public function setCollisionRatio(xRatio:Number, yRatio:Number):void {
			this.width = this.frameWidth * xRatio;
			this.offset.x = (this.frameWidth - this.width) * (1 - xRatio) * 0.5;
			this.height = this.frameHeight * 0.75;
			this.offset.y = (this.frameHeight - this.height) * (1 - yRatio) * 0.5;
		}
		/* reflect */
		public override function hitLeft(Contact:FlxObject, Velocity:Number):void
		{
			this.velocity.x = -this.velocity.x;
			if (0 <= velocity.x) {				
				facing = RIGHT;
			}
			else {
				facing = LEFT;
			}
		}
		public override function hitRight(Contact:FlxObject, Velocity:Number):void
		{
			this.hitLeft(Contact, Velocity);
		}
		/* only move or act if onscreen */
		override public function update():void 
		{
			if (this.onScreen()) {
				super.update();
			}
		}
		override public function hurt(Damage:Number):void {
			if (! this.flickering()) {
				super.hurt(Damage);
				if (!this.dead) {
					this.flicker(1);
				}
			}
		}
		override public function kill():void 
		{
			if (null != this.loot) {
				this.loot.reset(this.x, this.y);
				this.loot.exists = true;
				this.loot.visible = true;
				this.loot.solid = true;
				this.world.pickups.add(this.loot);
				// this.world.add(this.loot);
				this.deadMillisecond = getTimer();
			}
			super.kill();
		}
	}
}
