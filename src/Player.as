package  
{
	import org.flixel.*;
	/**
	 * ...
	 * @author Ethan Kennerly
	 */
	public class Player extends FlxSprite
	{
		// [Embed(source = "../data/jump.mp3")] private var SndJump:Class;

		
		public function Player(X:int = 0, Y:int = 0, SimpleGraphic:Class = null) 
		{
			super(X, Y, SimpleGraphic);
			var sheet:PlayerSpritesheet = new PlayerSpritesheet();
			// FlxG.log("Player:  width = " + sheet.frameWidth.toString() + " height = " + sheet.frameHeight.toString());
			this.loadGraphic(PlayerSpritesheet, true, true, sheet.frameWidth, sheet.frameHeight);
			
			//basic player physics
			this.maxVelocity.x = FlxG.width * 0.25;
			this.maxVelocity.y = this.maxVelocity.x;
			this.drag.x = this.maxVelocity.x * 8;
			this.drag.y = this.maxVelocity.y * 8;

			// hit box
			this.width = 0.5 * this.frameWidth;
			this.offset.x = 0.25 * this.frameWidth;
			this.height = 0.5 * this.frameHeight;
			this.offset.y = 0.25 * this.frameHeight;

			this.bullets = Bullet.createGroup(Bullet);
			// HUD must be done separately.
		}

		// Bullet
		public var bullets:FlxGroup;
		public function shootByKeyboard():void {
			if (true == this.cannon) {
				if (FlxG.keys.justPressed("X") || FlxG.keys.justPressed("SPACE") 
					|| FlxG.keys.justPressed("Z") || FlxG.keys.justPressed("Y") ) {
					Bullet.shootGroup(this, this.bullets);
				}
			}
		}
		
/*		// HUD
		public var HUD:FlxGroup;
		public function createHUD():FlxGroup{
			var messageBar:FlxSprite = new FlxSprite(0, FlxG.height - 22)
			messageBar.createGraphic(FlxG.width,24,0x99000000);
			messageBar.scrollFactor.x = messageBar.scrollFactor.y = 0;
			this.HUD = new FlxGroup();
			this.HUD.add(this.createMessage());
			this.HUD.add(this.createFood());
			this.HUD.add(this.createCargo());
			this.HUD.add(this.createGold());
			return this.HUD;
		}
		public var message:FlxText;
		public var messageTimer:Number = 0;
		public function createMessage():FlxText {
			this.message = new FlxText(0, FlxG.height - 24, FlxG.width, "");
			this.message.scrollFactor.x = 0;
			this.message.scrollFactor.y = 0;
			this.message.alignment = "center";
			return this.message;
		}
*/
		public var messageTimer:Number = 0;
		public function updateMessage():void {
			if (0 < this.messageTimer) {
				this.messageTimer -= FlxG.elapsed;
				if (this.messageTimer <= 0) {
					this.messageTimer = 0;
					// this.message.text = "";
					this.hud.mc.message_txt.text = "";
				}
			}
		}
		public function setMessage(text:String):void {
			FlxG.log(text);
			this.hud.mc.message_txt.text = text;
			// this.message.text = text;
			this.messageTimer = 5;
		}
		
		public var port:City;
		override public function update():void {
			this.moveByKeyboard();
			this.shootByKeyboard();
			this.updateMessage();
			this.eat();
			// this.updateGold();
			this.updateHUD();
			super.update();
		}
		
		/**
		 * Left, Right, Up, Down
		 */
		private function moveByKeyboard():void {
			this.acceleration.x = 0;
			this.acceleration.y = 0;
			if (FlxG.keys.LEFT)
			{
				this.facing = FlxSprite.LEFT;
				this.acceleration.x -= this.drag.x;
			}
			else if (FlxG.keys.RIGHT)
			{
				this.facing = FlxSprite.RIGHT;
				this.acceleration.x += this.drag.x;
			}
			if (FlxG.keys.UP)
			{
				// this.facing = FlxSprite.UP;
				this.acceleration.y -= this.drag.y;				
			}
			else if (FlxG.keys.DOWN)
			{
				// this.facing = FlxSprite.DOWN;
				this.acceleration.y += this.drag.y;				
			}
		}

		public var hud:Hud;
		public var lastFood:Number = 100.0;
		public var food:Number = 100.0;
		public var maxFood:Number = 100.0;
		// public var foodText:FlxText;
/*		public function createFood() {
			this.lastFood = 100.0;
			this.food = 100.0;
			this.maxFood = 100.0;
			this.foodText = new FlxText(0, FlxG.height 
					* 0, // gap 
					// * 0.0625, // gap 
					FlxG.width, "");
			this.foodText.scrollFactor.x = 0;
			this.foodText.scrollFactor.y = 0;
			this.foodText.alignment = "right";			
			return this.foodText;
		}
*/		public function eat():void {
			this.food -= FlxG.elapsed;
			if (this.food <= 0) {
				this.kill();
				this.setMessage("YOUR CREW STARVED!");
			}
			else if (this.food <= 10 && 10 <= this.lastFood) {
				this.setMessage("CAPTAIN!  WE'RE STARVING!");
			}
			else if (this.food <= 20 && 20 <= this.lastFood) {
				this.setMessage("CAPTAIN!  WE'RE HUNGRY!  FIND THE NEAREST CITY.");
			}
			else if (this.food <= 30 && 30 <= this.lastFood) {
				this.setMessage("CAPTAIN!  WE'RE LOW ON FOOD!  FIND THE NEAREST CITY.");
			}
			else if (this.food <= 50 && 50 <= this.lastFood) {
				this.setMessage("CAPTAIN, SHOULD WE VISIT A CITY FOR FOOD?");
			}
			this.lastFood = this.food;
			// this.foodText.text = "FOOD " + int(this.food).toString();
		}
		public function updateHUD():void {
			this.hud.mc.food_txt.text = int(this.food).toString();
			this.hud.mc.cargo_txt.text = int(this.cargo).toString();
			this.hud.mc.gold_txt.text = int(this.gold).toString();
		}
		
		
		public var cargo:int = 0;
		//public var cargoText:FlxText;
		public var gold:int = 0;
		//public var goldText:FlxText;
/*		public function createCargo() {
			this.cargo = 0;
			this.cargoText = new FlxText(0, FlxG.height
					// * 0, // gap 
					* 0.0625, // gap 
					FlxG.width, "CARGO");
			this.cargoText.scrollFactor.x = 0;
			this.cargoText.scrollFactor.y = 0;
			this.cargoText.alignment = "right";			
			return this.cargoText;
		}*/
/*		public function createGold():FlxText {
			this.gold = 0;
			this.goldText = new FlxText(0, FlxG.height
					// * 0, // gap 
					* 2 * 0.0625, // gap 
					FlxG.width, "GOLD");
			this.goldText.scrollFactor.x = 0;
			this.goldText.scrollFactor.y = 0;
			this.goldText.alignment = "right";			
			return this.goldText;
		}*/
/*		public function updateGold():void {
			//this.cargoText.text = "CARGO " + int(this.cargo).toString();
			//this.goldText.text = "GOLD " + int(this.gold).toString();
			this.hud.cargo_txt.text = "CARGO " + int(this.cargo).toString();
			this.hud.gold_txt.text = "GOLD " + int(this.gold).toString();
		}
*/		
		
		public var cannon:Boolean = false;
		public static function pickup(me:FlxObject, item:FlxObject):void {
			if (! (me is Player)) {
				FlxG.log("Player.pickup: me is not Player? " + me.toString());
			}
			var self:Player = me as Player;
			if (item is Cannon) {
				self.cannon = true;
				item.kill();
				self.setMessage("TO FIRE CANNON: PRESS SPACE OR X");
			}
			else if (item is Coin) {				
				var coin:Coin = item as Coin;
				self.cargo += coin.value;
				item.kill();
				self.setMessage("TREASURE!  WE'LL DEPOSIT IT AT PORT.");
			}
			// FlxG.log("Player.pickup: item " + item.toString());
		}
		public static function overlapEnemy(me:FlxObject, you:FlxObject):void {
			if (! (me is Player)) {
				FlxG.log("Player.overlapEnemy: me is not Player? " + me.toString());
			}
			var self:Player = me as Player;
			self.kill();
			if (you is Crag) {
				self.setMessage("YOUR SHIP WRECKED ON THE SHARP ROCKS!");
			}
			FlxG.log("Player.overlapEnemy: you " + you.toString());
		}
		
		override public function kill():void 
		{
			this.cargo = 0;
			if (null != this.port) {
				this.x = this.port.x;
				this.y = this.port.y;
				this.food = this.maxFood;
				if (10 <= this.gold) {
					this.gold *= 0.95;
				}
			}
			else {
				FlxG.log("Player.kill:  why no port?");
				FlxG.state = new PlayState();
				// FlxG.state = new (FlxG.state as FlxState)();
			}
			// super.kill();
		}
	}		
}


/**
 * Hold the pixels of a sprite sheet in this.bitmapData.
 */
class PlayerSpritesheet extends FlxMovieClip
{
	// AS3 Embedded MovieClip Gotcha:  Need two frames to declare movieclip.
	// http://www.airtightinteractive.com/2008/05/as3-embedded-movieclip-gotcha/
	[Embed(source="../data/player.swf", symbol="player")] public static var MovieClipClass:Class;
	
	public function PlayerSpritesheet() 
	{
		super(MovieClipClass);
	}
	
}
