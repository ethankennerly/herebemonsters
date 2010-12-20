package  
{
	import org.flixel.*;
	/**
	 * ...
	 * @author Ethan Kennerly
	 */
	public class Dragon extends GiantShark
	{
		[Embed(source="../data/dragon.png")] private var GraphicClass:Class;
		public function Dragon(X:int, Y:int)
		{
			this.maxHealth = 
								4;
								// 5; // tedious?
			super(X, Y);
			this.loadGraphic(GraphicClass, false, true);
			this.velocity.x = FlxG.width / 8;
			this.normalSpeed = this.velocity.x;
			this.maxVelocity.x = FlxG.width * 0.25;
			this.loot = new Ruby();
			this.setCollisionRatio(0.75, 0.5);
		}
		/* dragon rushes, and turns around. */
		public var normalSpeed:Number;
		public var rushTimerMax:Number = 0.5;
		public var rushTimer:Number = 5;
		public var stopRushTimer:Number = 3;
		public function updateRush():void {
			if (this.onScreen()) {
				this.rushTimer -= FlxG.elapsed;
				this.stopRushTimer -= FlxG.elapsed;
				if (this.rushTimer <= 0) {
					this.startRush();
				}
/*				else if (this.stopRushTimer <= 0) {
					this.acceleration.x = 0;
					stopRush();
					this.velocity.x = this.normalSpeed;
				}
*/			}
		}
		public function startRush():void 
		{
			this.acceleration.x = this.velocity.x 
					// * 2; // too slow
					* 4; // fast?
					// * 10; // too fast?
					// * 100; // zip!
			this.velocity.x = -this.velocity.x 
					* 0.5; 
					// * 10;  // too fast?
					// * 100; // zip!
			this.rushTimer = 10;
			this.stopRushTimer = 2;
		}
		public function stopRush():void {
			this.acceleration.x = 0;
			if (this.velocity.x < -this.normalSpeed) {
				this.velocity.x = -this.normalSpeed;
			}
			else if (this.normalSpeed < this.velocity.x) {
				this.velocity.x = this.normalSpeed;
			}			
		}
		public override function hitLeft(Contact:FlxObject, Velocity:Number):void
		{
			stopRush();
			super.hitLeft(Contact, Velocity);
			this.rushTimer = this.rushTimerMax;
		}
		public override function hitRight(Contact:FlxObject, Velocity:Number):void
		{
			stopRush();
			super.hitRight(Contact, Velocity);
			this.rushTimer = this.rushTimerMax;
		}
		override public function update():void 
		{
			this.updateRush();
			super.update();
		}
	}
}
