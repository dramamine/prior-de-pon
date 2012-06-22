package gameplay
{
	import com.greensock.TweenLite;
	
	import org.flixel.FlxBasic;
	
	public class GameTimer extends FlxBasic
	{
		private var board:Board;
		
		public function GameTimer(theBoard:Board)
		{
			this.board = theBoard;
			
			super();
		}
		
		public function run():void
		{
			//trace('run called.');
			TweenLite.delayedCall( levelToScrollingTime(Board.LEVEL) / 1000, onTick );
		}
		
		public function onTick():void
		{
			//trace('onTick called.');
			board.scroll();
			run();
		}
		
		public function stop():void
		{
			TweenLite.killDelayedCallsTo(onTick);
		}
		
		/**
		 * Converts the LEVEL (0-99) into the # of milliseconds between
		 * scrolling the blocks up by one pixel. 
		 * 
		 * @param level
		 * @return 
		 * 
		 */
		private static function levelToScrollingTime(level:int):Number
		{
			// lvl 99: one block scrolls per second, i.e. one pixel every 62.5 ms
			// lvl 0: one block scrolls every 10 seconds, i.e. one pixel every 625 ms
			
			return (110 - level) * 5.7;
			
		}
	}
}