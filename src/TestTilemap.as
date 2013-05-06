package
{
    public class TestTilemap
    {
        public function TestTilemap():void
        {
            testAutoTile();
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
            test(expected, got);
            expected =             "4,20,4\n4,20,20\n4,4,4";
            got = Tilemap.autoTile("0,3,0\n0,3,3\n0,0,0", 0, 2, 4);
            test(expected, got);
        }

        private function test(expected:*, got:*):void
        {
            if (expected != got) {
                throw new Error("Expected <" + expected + "> Got <" + got + ">");
            }
        }
    }
}

