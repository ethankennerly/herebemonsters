package
{
    public class TestTilemap
    {
        public function TestTilemap():void
        {
            testAutoTile();
            testAutoTileNoInterior();
            testIsSurrounded();
            testAutoTileInterior();
        }

        /**
         * An L shape, offset tile indexes by 4.
         *
         *      020
         *      022
         *      000
         */
        public function testAutoTile():void
        {
            var expected:String =             "14,19,17\n14,19,19\n6,7,7";
            var got:String = Tilemap.autoTile("0,2,0\n0,2,2\n0,0,0", 0, 2, 4);
            assert(expected, got);
            expected =             "4,20,4\n4,20,20\n4,4,4";
            got = Tilemap.autoTile("0,3,0\n0,3,3\n0,0,0", 0, 2, 4);
            assert(expected, got);
        }

        public function testIsSurrounded():void
        {
            assert(true, Tilemap.isSurrounded([[2,2,2],[2,2,2],[2,2,2]], 0, 1, 2));
            assert(false, Tilemap.isSurrounded([[2,2,2],[1,2,2],[2,2,2]], 0, 1, 2));
            assert(true, Tilemap.isSurrounded([[3,3,3],[3,3,3],[3,3,3]], 1, 1, 3));
            assert(false, Tilemap.isSurrounded([[3,3,3],[3,3,3],[3,3,2]], 1, 1, 3));
            assert(false, Tilemap.isSurrounded([[3,3,3],[3,1,3],[3,3,3]], 1, 1, 3));
            assert(true, Tilemap.isSurrounded([[4,4,4],[4,4,4],[4,4,4]], 2, 2, 4));
            assert(false, Tilemap.isSurrounded([[4,4,4],[4,1,4],[4,4,4]], 2, 2, 4));
        }

        public function testAutoTileNoInterior():void
        {
            var expected:String =             "19,19,19,17,8" 
                                          + "\n19,19,19,19,17"
                                          + "\n19,19,19,19,19"
                                          + "\n15,19,19,19,11"
                                          + "\n6,15,19,11,5";
            var got:String = Tilemap.autoTile("2,2,2,0,0" 
                                          + "\n2,2,2,2,0"
                                          + "\n2,2,2,2,2"
                                          + "\n0,2,2,2,0"
                                          + "\n0,0,2,0,0", 0, 2, 4);
            
            assert(expected, got);
        }

        /**
         * An interior, offset tile indexes by 24.
         * Expect combined edgings.
         */
        public function testAutoTileInterior():void
        {
            var expected:String =             "39,39,29,17,8" 
                                          + "\n39,39,37,28,17"
                                          + "\n27,35,39,29,24"
                                          + "\n15,26,27,25,11"
                                          + "\n6,15,24,11,5";
            var got:String = Tilemap.autoTile("2,2,2,0,0" 
                                          + "\n2,2,2,2,0"
                                          + "\n2,2,2,2,2"
                                          + "\n0,2,2,2,0"
                                          + "\n0,0,2,0,0", 0, 2, 4, 24);
            
            assert(expected, got);
        }

        private function assert(expected:*, got:*):void
        {
            if (expected != got) {
                throw new Error("Expected <" + expected + "> Got <" + got + ">");
            }
        }
    }
}

