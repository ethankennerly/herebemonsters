package
{
    public class Tilemap
    {
        /**
         * DAME csv string with tiles 0..3.
         * Replace land 2 with 4..19
         *
         * 16 tiles bitmask of corners.
         * http://www.codeproject.com/Articles/106884/Implementing-Auto-tiling-Functionality-in-a-Tile-M
         * Example: @see TestTilemap.as
         */
        public static function autoTile(csv:String, waterIndex:int, landIndex:int, landEdgeIndex:int):String
        {
            var rows:Array = csv.replace("\r", "\n").replace("\n\n", "\n").split("\n");
            for (var r:int = 0; r < rows.length; r++) {
                rows[r] = rows[r].split(",");
            }
            var edges:Array = [];
            var index:int;
            for (r = 0; r < rows.length; r++) {
                var cs:Array = [];
                for (var c:int = 0; c < rows[r].length; c++) {
                    var self:int = parseInt(rows[r][c]);
                    if (self == waterIndex || self == landIndex) {
                        index = getNeighborBitmask(rows, r, c, landIndex);
                        cs.push(index + landEdgeIndex);
                    }
                    else {
                        cs.push(rows[r][c] < landIndex ? self : self + 17);
                    }
                }
                edges.push(cs.join(","));
            }
            return edges.join("\n");
        }

        /**
         * 4-bits represent cornering neighbor of same index:
         *
         *     0011
         *     0011
         *     2233
         *     2233
         */
        private static function getNeighborBitmask(rows:Array, r:int, c:int, landIndex:int):int
        {
            var self:int = rows[r][c];
            var neighborBits:int = 0;
            var bottom:int = Math.min(r + 1, rows.length - 1);
            var rightmost:int = Math.min(c + 1, rows[r].length - 1);
            for (var down:int = Math.max(0, r - 1); down <= bottom; down++) {
                for (var right:int = Math.max(0, c - 1); right <= rightmost; right++) {
                    var neighbor:int = rows[down][right];
                    if (neighbor == landIndex) {
                        if (down <= r && right <= c) {
                            neighborBits |= 1;
                        }
                        if (down <= r && c <= right) {
                            neighborBits |= 2;
                        }
                        if (r <= down && right <= c) {
                            neighborBits |= 4;
                        }
                        if (r <= down && c <= right) {
                            neighborBits |= 8;
                        }
                    }
                }
            }
            return neighborBits;
        }
    }
}
