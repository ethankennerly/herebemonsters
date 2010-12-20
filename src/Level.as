package  
{
	import org.flixel.*;
	/**
	 * Default to load object and display text from DAME exporter flixelComplex.lua.
	 * @author Ethan Kennerly
	 */
	public class Level extends BaseLevel 
	{
		/**
		 * Display text.
		 * @param	obj
		 * @param	layer
		 * @param	level
		 * @param	properties
		 */
		public static function onLoadObject(obj:Object, layer:FlxGroup, level:BaseLevel, properties:Array):void {
			if ( obj is TextData )
			{
				var tData:TextData = obj as TextData;
				if ( tData.fontName != "" && tData.fontName != "system" )
				{
					tData.fontName += "Font";
				}
				level.addTextToLayer(tData, layer, true, properties, Level.onLoadObject );
			}
			// var what:String = "_onLoadObject: obj: " + obj.toString();
			// FlxG.log(what);
		}

		public static function load(onLoadObject:Function = null):BaseLevel
		{
			var levelClass:Class = FlxG.levels[FlxG.level];
			var level:BaseLevel = new levelClass(true, onLoadObject);
			FlxState.bgColor = level.bgColor;
			return level;
		}

		/* first collideIndex in hitTilemaps or 1 */
		public static function getCollideIndex(level:BaseLevel):int {
			var collideIndex:int = 1;
			for (var m:int = 0; m < level.hitTilemaps.members.length; m++ ) {
				var map:FlxTilemap = level.hitTilemaps.members[m];
				collideIndex = map.collideIndex;
				break;
			}
			return collideIndex;
		}
		
		public static function setCollideIndex(level:BaseLevel, collideIndex:int):void {
			for (var m:int = 0; m < level.hitTilemaps.members.length; m++ ) {
				var map:FlxTilemap = level.hitTilemaps.members[m];
				map.collideIndex = collideIndex;
			}
		}
		
		/**
		 * for all:  setTileIndex 2

		update fog
			for all near ship
				set tile index 0
			for all at border near ship
				set tile index 1
		 */
		public static function setTilemap(map:FlxTilemap, fillIndex:int):void {
			for (var t:int = 0; t < map.totalTiles; t ++ ) {
				map.setTileByIndex(t, fillIndex);
			}
		}
		/**
		 * show tiles near center.
		 * @param	map			fog tilemap
		 * @param	center		where fog is cleared from
		 * @param	distance	tiles to clear on all sides
		 * @param	oldIndex	tile to change
		 * @param	newIndex	tile to see
		 * @param	tileWidth	width of a tile
		 * @param	tileHeight	height of a tile
		 */
		public static function replaceTile(map:FlxTilemap, center:FlxSprite, distance:int, oldIndex:int = 0, newIndex:int = 0, tileWidth:int = 25, tileHeight:int = 25):void {
			var centerColumn:int = (center.x + center.frameWidth * 0.5) / tileWidth;
			var centerRow:int = (center.y + center.frameHeight * 0.5) / tileHeight;
			for (var column:int = centerColumn - distance; column < centerColumn + distance; column ++ ) {				
				for (var row:int = centerRow - distance; row < centerRow + distance; row ++ ) {	
					if (oldIndex == map.getTile(column, row)){
						map.setTile(column, row, newIndex);
					}
				}
			}
		}
		/* 0..100 tiles at or below index.  By calling this once per frame, frame rate dropped from 40 fps to 20 fps! */
		public static function percentTilesUnderIndex(map:FlxTilemap, maxIndex:int):int {
			var under:int = 0;
			for (var m:int = 0; m < map.totalTiles; m ++ ) {
				var tile:int = map.getTileByIndex(m);
				if (tile <= maxIndex) {
					under ++;
				}
			}
			var percent:int = 100.5 * under / map.totalTiles;
			return percent;
		}
		public static function next():int {
			if (FlxG.level <= FlxG.levels.length - 2) {
				FlxG.level += 1;
			}
			else {
				FlxG.log("Level.loadLevel:  Complete all " + FlxG.levels.length + " levels, at " + FlxG.level + " resetting to 0.");
				FlxG.level = 0;
			}
			return FlxG.level;
		}
		
	}

}