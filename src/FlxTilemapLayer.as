package 
{
    import flash.display.BitmapData;
    import flash.geom.Rectangle;

    import org.flixel.FlxG;
    import org.flixel.FlxGroup;
    import org.flixel.FlxSprite;
    import org.flixel.FlxTilemap;

    public class FlxTilemapLayer extends FlxTilemap
    {
        public var spriteGroups:Array = [];

        /**
         * Internal function that actually renders the tilemap.  Called by render().
         * 
         * 2.5D: If tile overlaps sprite, render tile over sprite.
         * 
         * Copy pixels in row order:
         * 
         * 	ab
         * 	cd
         * 
         * a: tile at row 0, b: sprite at row 0
         * c: tile at row 1, d: sprite at row 1
         * 
         * FlxTilemap.renderTilemapAndSprites
         * 
         * copy sprites to be on same layer.
         * sort sprites by bottom, descending.
         * for each row of tiles:
         *      pop sprite; if bottom of sprite greater than bottom of tile, push sprite.
         *      otherwise: render sprite.
         *      render row of tiles.
         *
         * Example:
         * MasterLayer is FlxLayer. FlxLayer extends FlxGroup.
         * add land.  merge player.  merge sprites.
         * LayerMap3 is FlxTilemapAndSprites.  Override renderTilemap.  Assign sprites and player.  
         */
        override protected function renderTilemap():void
        {
            var sprites:Array = [];
            for each(var group:FlxGroup in spriteGroups) {
                for each(var o:FlxSprite in group.members) {
                    if((o != null) && o.exists && o.visible) {
                        sprites.push(o);
                    }
                }
            }
            sprites.sortOn('y', Array.NUMERIC | Array.DESCENDING);
            //Bounding box display options
            var tileBitmap:BitmapData;
            if(FlxG.showBounds)
                tileBitmap = _bbPixels;
            else
                tileBitmap = _pixels;

            getScreenXY(_point);
            _flashPoint.x = _point.x;
            _flashPoint.y = _point.y;
            var tx:int = Math.floor(-_flashPoint.x/_tileWidth);
            var ty:int = Math.floor(-_flashPoint.y/_tileHeight);
            if(tx < 0) tx = 0;
            if(tx > widthInTiles-_screenCols) tx = widthInTiles-_screenCols;
            if(ty < 0) ty = 0;
            if(ty > heightInTiles-_screenRows) ty = heightInTiles-_screenRows;
            var ri:int = ty*widthInTiles+tx;
            _flashPoint.x += tx*_tileWidth;
            _flashPoint.y += ty*_tileHeight;
            var opx:int = _flashPoint.x;
            var c:uint;
            var cri:uint;
            for(var r:uint = 0; r < _screenRows; r++)
            {
                var spriteY:int = (ty + r + 1) * _tileHeight;
                while (1 <= sprites.length && sprites[sprites.length - 1].y < spriteY) {
                    sprites.pop().render();
                }
                cri = ri;
                for(c = 0; c < _screenCols; c++)
                {
                    _flashRect = _rects[cri++] as Rectangle;
                    if(_flashRect != null)
                        FlxG.buffer.copyPixels(tileBitmap,_flashRect,_flashPoint,null,null,true);
                    _flashPoint.x += _tileWidth;
                }
                ri += widthInTiles;
                _flashPoint.x = opx;
                _flashPoint.y += _tileHeight;
            }
            /*-
            for each(var group:FlxGroup in spriteGroups) {
                group.render();
            }
            -*/
        }
    }
}
