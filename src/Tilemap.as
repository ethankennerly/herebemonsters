package
{
    public class Tilemap
    {
        /**
         * DAME csv string with tiles 0..3.
         * Example: Replace water 0 beside land 2 with 4..19.
         * @param   interiorIndex   If not -1, replace interior land bordering exterior land with offset, like 24..39
         *                           and replace land completely surrounded (including diagonals) by inner + 15, like 39.
         *
         * 16 tiles bitmask of corners.
         * http://www.codeproject.com/Articles/106884/Implementing-Auto-tiling-Functionality-in-a-Tile-M
         * Example: @see TestTilemap
         */
        public static function autoTile(csv:String, waterIndex:int, landIndex:int, landEdgeIndex:int, interiorIndex:int=-1):String
        {
            var rows:Array = csv.replace("\r", "\n").replace("\n\n", "\n").split("\n");
            for (var r:int = 0; r < rows.length; r++) {
                rows[r] = rows[r].split(",");
                for (var c:int = 0; c < rows[r].length; c++) {
                    rows[r][c] = parseInt(rows[r][c]);
                }
            }
            var edges:Array = [];
            var index:int;
            var cs:Array;
            var self:int;
            for (r = 0; r < rows.length; r++) {
                cs = [];
                for (c = 0; c < rows[r].length; c++) {
                    self = rows[r][c];
                    if (self == waterIndex || self == landIndex) {
                        index = getNeighborBitmask(rows, r, c, landIndex);
                        cs.push(index + landEdgeIndex);
                    }
                    else {
                        cs.push(rows[r][c] < landIndex ? self : self + 17);
                    }
                }
                edges.push(interiorIndex <= -1 ? cs.join(",") : cs );
            }
            var edges2:Array = [];
            if (0 <= interiorIndex) {
                var edgedLandIndex:int = landEdgeIndex + 15;
                var surroundedIndex:int = interiorIndex + 15;
                for (r = 0; r < edges.length; r++) {
                    edges2.push([]);
                    for (c = 0; c < edges[r].length; c++) {
                        self = edges[r][c];
                        if (self == edgedLandIndex 
                                && isSurrounded(edges, r, c, edgedLandIndex)) {
                            index = surroundedIndex;
                        }
                        else {
                            index = self;
                        }
                        edges2[r][c] = index;
                    }
                }
                for (r = 0; r < edges.length; r++) {
                    for (c = 0; c < edges[r].length; c++) {
                        self = edges2[r][c];
                        if (self == edgedLandIndex) {
                            index = interiorIndex + getNeighborBitmask(edges2, r, c, surroundedIndex);
                        }
                        else {
                            index = self;
                        }
                        edges[r][c] = index;
                    }
                    edges[r] = edges[r].join(",");
                }
            }
            return edges.join("\n");
        }

        /**
         * All eight neighbors are the same.
         */
        internal static function isSurrounded(rows:Array, r:int, c:int, landIndex:int):Boolean
        {
            var bottom:int = Math.min(r + 1, rows.length - 1);
            var rightmost:int = Math.min(c + 1, rows[r].length - 1);
            for (var down:int = Math.max(0, r - 1); down <= bottom; down++) {
                for (var right:int = Math.max(0, c - 1); right <= rightmost; right++) {
                    if (rows[down][right] != landIndex) {
                        return false;
                    }
                }
            }
            return true;
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
