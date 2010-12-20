package  
{
	import org.flixel.*;
	/**
	 * ...
	 * @author Ethan Kennerly
	 */
	public class City extends FlxSprite
	{
		// [Embed(source="../data/city_save.mp3")] private static var SndCitySave:Class;
		public var world:PlayState;
		public function City(X:int = 0, Y:int = 0, SimpleGraphic:Class = null) 
		{
			super(X, Y, SimpleGraphic);
			var sheet:CitySpritesheet = new CitySpritesheet();
			// FlxG.log("City:  width = " + sheet.frameWidth.toString() + " height = " + sheet.frameHeight.toString());
			this.loadGraphic(CitySpritesheet, true, true, sheet.frameWidth, sheet.frameHeight);
			
			this.addAnimation("ruin", [0], 12);
			this.addAnimation("city", [1], 12);
			this.play("ruin");
		}
		/* Save player */
		public static function save(me:FlxObject, you:FlxObject):void {
			if (! (me is City)) {
				FlxG.log("City.save: me is not City? " + me.toString());
			}
			var self:City = me as City;
			if (you is Player) {
				var player:Player = you as Player;
				if (self != player.port) { 
					// slows frame rate
					// FlxG.play(City.SndCitySave);
					var map_str:String = Level.percentTilesUnderIndex(self.world.level_0.layerFog, 1).toString();
					if (self._curAnim.name == "city") {
						if (map_str != player.hud.mc.map_txt.text) {
							player.gold += int(map_str); 
							FlxG.kong.API.stats.submit("Map Percent", int(map_str) );
							FlxG.kong.API.stats.submit("Gold", int(player.gold) );
							if (int(map_str) <= 5) {
								player.setMessage("YOUR MAP INSPIRES THE SAILORS!  +" + int(map_str) + " GOLD");
							}
							else if (int(map_str) <= 10) {
								player.setMessage("YOUR MAP GUIDES THE MERCHANTS!  +" + int(map_str) + " GOLD");
							}
							else if (int(map_str) <= 20) {
								player.setMessage("YOUR MAP EDUCATES THE SCHOLARS!  +" + int(map_str) + " GOLD");
							}
							else if (int(map_str) <= 30) {
								player.setMessage("YOUR MAP SPARKS AN AGE OF DISCOVERY!  +" + int(map_str) + " GOLD");
							}
							else if (int(map_str) <= 50) {
								player.setMessage("YOUR MAP COVERS THE EMPIRE!  +" + int(map_str) + " GOLD");
							}
							else if (int(map_str) <= 70) {
								player.setMessage("YOUR MAP ENLIGHTENS THE PRINCESS!  +" + int(map_str) + " GOLD");
							}
							else if (int(map_str) <= 98) {
								player.setMessage("YOUR MAP IMPRESSES THE QUEEN!  +" + int(map_str) + " GOLD");
							}
							else {
								player.setMessage("YOU MAPPED THE WHOLE WORLD!  YOU WIN!");
								FlxG.kong.API.stats.submit("Game Complete", 1);
							}
						}
						else {
							player.setMessage("AHOY CAPTAIN!  WELCOME BACK");
						}
					}
					else {
						player.setMessage("YOU ADDED A NEW CITY TO YOUR MAP!");
						self.play("city");
					}
					player.hud.mc.map_txt.text = map_str;
					// FlxG.log("City.save: you " + you.toString());
				}
				// else if (player.food < 99 && "YOU RESTOCK FOOD RATIONS!" != player.message.text){
				else if (player.food < 90 && "YOU RESTOCK FOOD!" != player.hud.mc.message_txt.text){
					player.setMessage("YOU RESTOCK FOOD!");	
				}
				player.port = self;
				player.gold += player.cargo;
				player.cargo = 0;
				player.food = player.maxFood;
				// respawn
				// 20 fps with
/*				Mobile.respawn(self.world.enemies);
*/				Mobile.respawn(self.world.fish);
			}
		}
	}		
}


/**
 * Hold the pixels of a sprite sheet in this.bitmapData.
 */
class CitySpritesheet extends FlxMovieClip
{
	// AS3 Embedded MovieClip Gotcha:  Need two frames to declare movieclip.
	// http://www.airtightinteractive.com/2008/05/as3-embedded-movieclip-gotcha/
	[Embed(source="../data/city.swf", symbol="city")] public static var MovieClipClass:Class;
	
	public function CitySpritesheet() 
	{
		super(MovieClipClass);
	}
	
}

