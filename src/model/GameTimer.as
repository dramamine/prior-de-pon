package model
{
	import com.greensock.TimelineLite;
	import com.greensock.TweenLite;
	
	import org.flixel.FlxBasic;
	
	public class GameTimer extends FlxBasic
	{
		private var board:Board;
		private var _isTurboScrolling:Boolean = false;
		private var _isStopped:Boolean = false;
		private const TURBO_SCROLLING_SPEED:Number = .03125; // scroll one block in half a second.
		private const TURBO_DELAY:Number = .35; // after scrolling to next block, how long to wait
		
		public function GameTimer(theBoard:Board)
		{
			this.board = theBoard;
			
			super();
		}
		
		public function run():void
		{
			_isStopped = false;
			//trace('run called.');
			TweenLite.delayedCall( levelToScrollingTime(Board.LEVEL) / 1000, onTick );
		}
		
		public function onTick():void
		{
			//trace('onTick called.');
			board.scroll();
			run();
		}
		
		/**
		 * This function scrolls everything up to activate one more row. 
		 * @param pixelsLeft
		 * 
		 */
		public function activateTurboScroll(pixelsLeft:int):void
		{
			// if we're already scrolling, don't do anything.
			// this allows us to ignore if the player hits the scroll key
			// twice in a row, or holds the key down.
			if(_isTurboScrolling) return;
			
			_isTurboScrolling = true;
			stop();
			
			trace('acivating turbo scroll.');
			
			var tl:TimelineLite = new TimelineLite;
			for(var i:int = 0; i <= pixelsLeft; i++)
			{
				tl.append(new TweenLite(this, TURBO_SCROLLING_SPEED, {
					onComplete:board.scroll}
				));
				//TweenLite.delayedCall( i * TURBO_SCROLLING_SPEED, board.scroll );
			}
			
			tl.append(new TweenLite(this, TURBO_DELAY, {
				onComplete:function(){
					_isTurboScrolling = false;
					run();
				}
			}));
			
		}
		
		/**
		 * Stops the timer.  
		 * @param time: the length of time to freeze the screen. Enter 0 for 'forever until re-activated'.
		 */
		public function stop(time:Number = 0):void
		{
			TweenLite.killDelayedCallsTo(onTick);
			
			// if it's already stopped (ex. we're on a 3x combo), reset the delayed call to run()
			if(_isStopped)
			{
				TweenLite.killDelayedCallsTo(run);
			}
			
			_isStopped = true;
			
			if(time > 0)
			{
				TweenLite.delayedCall( time, run );
			}
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