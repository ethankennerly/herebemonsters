package 
{
    import org.flixel.FlxGroup;
    import org.flixel.FlxObject;

    public class FlxLayer extends FlxGroup
    {
        public var renderAutomatically:Array = [];

        override public function add(Object:FlxObject, renderManually:Boolean=false):FlxObject
        {
            if (!renderManually) {
                renderAutomatically.push(members.length);
            }
            return super.add(Object);
        }
        
        override protected function renderMembers():void
        {
            var o:FlxObject;
            var l:uint = members.length;
            for each(var i:uint in renderAutomatically)
            {
                o = members[i] as FlxObject;
                if((o != null) && o.exists && o.visible)
                    o.render();
            }
        }
    }
}
