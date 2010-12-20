package

{

	import org.flixel.*;
	import flash.display.DisplayObjectContainer;



	public class PlayState extends FlxState

	{

		public var player:Player;
		public var bullets:FlxGroup;
		public var enemies:FlxGroup;
		public var enemy_bullets:FlxGroup;
		public var pickups:FlxGroup;
		public var rocks:FlxGroup;
		public var hazards:FlxGroup;
		public var cities:FlxGroup;
		public var fish:FlxGroup;
		
		public var level:BaseLevel;
		public var level_0:Level_0;
		override public function create():void

		{

			// add(new FlxText(0,0,100,"INSERT GAME HERE"));
			// FlxG.timeScale = 2; // fail map 4
			// FlxG.timeScale = 4; // fail map 4
			// FlxG.level = 5; // develop
			this.enemies = new FlxGroup();
			this.hazards = new FlxGroup();
			this.pickups = new FlxGroup();
			this.rocks = new FlxGroup();
			this.cities = new FlxGroup();
			this.fish = new FlxGroup();
			// bullet below fog
			this.enemy_bullets = Bullet.createGroup(EnemyBullet);				
			this.add(this.enemy_bullets);
			this.add(this.pickups);
			FlxG.levels = [Level_0];
			level = Level.load(this._onLoadObject);
			Level.setCollideIndex(level, 2);
			level_0 = level as Level_0;
			Level.setTilemap(level_0.layerFog, 2);

			// collision group
			this.mobiles = new FlxGroup();
			this.mobiles.add(player);
			this.mobiles.add(player.bullets);
			this.mobiles.add(enemy_bullets);
			this.mobiles.add(fish);
			this.mobiles.add(enemies);

			// HUD
			// this.add(this.player.createHUD());
			var this_root:DisplayObjectContainer = this.stage.root as DisplayObjectContainer;
			this.player.hud = new Hud(this_root);
			
			
			FlxG.follow(this.player, 2.5);
			FlxG.followBounds(0, 0, 256 * 25, 128 * 25);
			
			// FlxG.followAdjust(0.5);
		}

		/** When objects are added to a level, we tell BaseLevel to call this function back.
		 * BaseLevel will call us back and tell us about the object that we are adding.
		 */
		protected function _onLoadObject(obj:Object, layer:FlxGroup, level:BaseLevel, properties:Array):void
		{
			if (obj is Player)
			{
				this.player = obj as Player;
				this.add(this.player.bullets);
			}
			if (obj is Pickup)
			{
				this.pickups.add(obj as Pickup);
			}
			if (obj is Fish)
			{
				this.fish.add(obj as Fish);
			}
			if (obj is Rock)
			{
				this.rocks.add(obj as Rock);
			}
			if (obj is Crag)
			{
				this.hazards.add(obj as Crag);
			}
			if (obj is GiantShark)
			{
				this.enemies.add(obj as GiantShark);
			}
			if (obj is Pirate)
			{
				this.enemies.add(obj as Pirate);
			}
			if (obj is Gunner)
			{
				this.enemies.add(obj as Gunner);
			}
			if (obj is City)
			{
				this.cities.add(obj as City);
				(obj as City).world = this;
			}
			if (obj is Mobile)
			{
				(obj as Mobile).world = this;
			}
			Level.onLoadObject(obj, layer, level, properties);
		}
		
		/* east-west wrap only */
		public function wrapEastWest(player:Player):void {
			var minX:int = 1 * 25;
			var maxX:int = (this.level_0.layerFog.widthInTiles - 2) * 25;
			var minDestinationX:int = 3 * 25;
			var maxDestinationX:int = (this.level_0.layerFog.widthInTiles - 4) * 25;
			if (player.x < minX) {
				player.x = maxDestinationX;
				player.setMessage("YOU SAILED FROM THE FAR WEST TO THE FAR EAST!");
			}
			else if (maxX < player.x) {
				player.x = minDestinationX;
				player.setMessage("YOU SAILED FROM THE FAR EAST TO THE FAR WEST!");
			}
		}
		/* try to improve frame rate with consolidated collision */
		public var mobiles:FlxGroup;
		override public function update():void 
		{
			// commenting out replaceTile did not increase frame rate from 25 fps.
			this.wrapEastWest(player);
			Level.replaceTile(level_0.layerFog, player, 5, 2, 1);
			Level.replaceTile(level_0.layerFog, player, 4, 1, 0);
			// Frame rate drops from 40 fps to 20 fps!
			// player.hud.mc.map_txt.text = Level.percentTilesUnderIndex(level_0.layerFog, 1).toString();
			// collide
			// 40 fps without starts here
			// var collideProfileId:int = FlxU.startProfile();
			level.hitTilemaps.collide(mobiles);
			// FlxU.endProfile(collideProfileId, "level.collide", false);
			// 30 fps without starts here
/*			FlxU.collide(player, this.rocks);
			FlxU.collide(this.enemies, this.rocks);
			FlxU.collide(this.enemies, this.hazards);
*/			// 20 fps without starts here
			FlxU.overlap(player.bullets, this.enemies, Bullet.shootEnemy);
			//FlxU.overlap(player.bullets, this.rocks);
			//FlxU.overlap(player.bullets, this.hazards);
			//FlxU.overlap(player.bullets, this.fish);
/*			// 18 fps without starts here
			FlxU.overlap(this.enemy_bullets, this.rocks);
			FlxU.overlap(this.enemy_bullets, this.player);
			FlxU.overlap(this.enemy_bullets, this.hazards);
			FlxU.overlap(this.enemy_bullets, this.fish);
*/
			// 20-25 fps with starts here
			// 35-40 fps without starts here
			FlxU.overlap(this.enemy_bullets, this.player);
			FlxU.overlap(player, this.enemies, Player.overlapEnemy);
			FlxU.overlap(player, this.pickups, Player.pickup);
			FlxU.overlap(this.fish, player, Fish.eaten); //reverse syntax?  or better for expanding, ala The Sims?
			FlxU.overlap(this.cities, player, City.save);
/**/			// FlxU.overlap(this.bullets, level.hitTilemaps, Bullet.overlapBlock);
			// 40 fps without ends here
			// Developer control
			if (FlxG.keys.justPressed("B")) {
				FlxG.showBounds = !FlxG.showBounds;				
			}
			if (FlxG.keys.CONTROL && FlxG.keys.justPressed("ONE")) {
				FlxG.log("CTRL-1:  timeScale 1");
				FlxG.timeScale = 1;	
			}
			if (FlxG.keys.CONTROL && FlxG.keys.justPressed("TWO")) {
				FlxG.log("CTRL-2:  timeScale 2");
				FlxG.timeScale = 2;				
			}
			if (FlxG.keys.CONTROL && FlxG.keys.justPressed("THREE")) {
				FlxG.log("CTRL-4:  timeScale 4");
				FlxG.timeScale = 4;				
			}
			if (FlxG.keys.CONTROL && FlxG.keys.justPressed("FOUR")) {
				FlxG.log("CTRL-4:  timeScale 8");
				FlxG.timeScale = 8;	
			}
			if (FlxG.keys.CONTROL && FlxG.keys.justPressed("FIVE")) {
				FlxG.log("CTRL-5:  timeScale 16");
				FlxG.timeScale = 16;	
			}
			super.update();
		}
	}

}

