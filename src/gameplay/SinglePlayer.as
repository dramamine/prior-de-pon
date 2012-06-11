package gameplay
{
	import com.greensock.TweenLite;
	
	import org.flixel.FlxPoint;
	import org.flixel.FlxState;

	public class SinglePlayer extends FlxState
	{
		//private var _board:Board;
		
		/**
		 * SinglePlayer is our basic state for one-player, solo games.
		 * We'll try to keep some layout options in here, but most of our code
		 * should end up in the other classes. 
		 * 
		 */		
		public function SinglePlayer()
		{
			trace('singleplayer called');
			super();
			
			var controller:Controller = new Controller();
			add(controller);
			controller.initialize();
			
			
			//board = new Board();
			//add(board);
			//board.initialize();
			
			//TweenLite.delayedCall(3, board.checkAll);
			
			
		}

		
		
	}
}