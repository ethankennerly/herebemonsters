package  
{
	import flash.display.MovieClip;
	import flash.display.DisplayObjectContainer;
	
	/**
	 * ...
	 * @author Ethan Kennerly
	 */
	public class Hud extends MovieClip
	{
		// AS3 Embedded MovieClip Gotcha:  Need two frames to declare movieclip.
		// http://www.airtightinteractive.com/2008/05/as3-embedded-movieclip-gotcha/
		[Embed(source="../data/hud.swf", symbol="hud")] public static var MovieClipClass:Class;
		public var mc:MovieClip;
		/* movieclip on top of Flixel bitmap.  */
		public function Hud(root:DisplayObjectContainer) 
		{
			if (null != mc && null != mc.parent) {
				mc.parent.removeChild(mc);
			}
			// mc = (new MovieClipClass()) as MovieClip; // reentry.  
			mc = new MovieClipClass(); // reentry.  
			root.addChild(mc);
		}
	}
}


