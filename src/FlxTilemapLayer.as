package 
{
    import flash.display.BitmapData;
    import flash.geom.Rectangle;

    import org.flixel.FlxG;
    import org.flixel.FlxGroup;
    import org.flixel.FlxTilemap;

    public class FlxTilemapLayer extends FlxTilemap
    {
        public var spriteGroups:Array = [];

        /**
         * Internal function that actually renders the tilemap.  Called by render().
         */
        override protected function renderTilemap():void
        {
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
            for each(var group:FlxGroup in spriteGroups) {
                group.render();
            }
        }
    }
}
