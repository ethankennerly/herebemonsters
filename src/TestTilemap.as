package
{
    public class TestTilemap
    {
        public function TestTilemap():void
        {
            testAutoTile();
            testAutoTileNoInner();
            // TODO: testAutoTileInner();
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

        public function testAutoTileNoInner():void
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
                                          + "\n0,0,2,0,0", 0, 2, 4, true);
            
            assert(expected, got);
        }

        /**
         * TODO: An interior, offset tile indexes by 4.
         * Expect combined edgings.
         */
        public function testAutoTileInner():void
        {
            var expected:String =             "?,?,?,17,8" 
                                          + "\n?,?,?,?,17"
                                          + "\n?,?,?,?,?"
                                          + "\n15,?,?,?,11"
                                          + "\n6,15,?,11,5";
            var got:String = Tilemap.autoTile("2,2,2,0,0" 
                                          + "\n2,2,2,2,0"
                                          + "\n2,2,2,2,2"
                                          + "\n0,2,2,2,0"
                                          + "\n0,0,2,0,0", 0, 2, 4, true);
            
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

