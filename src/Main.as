package
{
	import flash.display.Sprite;
	import org.flixel.*;
	import gameplay.SinglePlayer;
	
	[SWF(width="640", height="480", backgroundColor="#000000")]
	public class Main extends FlxGame
	{
		public function Main()
		{
			super(320,240,SinglePlayer,2);
			trace('hi');
		}
	}
}