package gameplay
{
	import org.flixel.FlxState;
	import org.flixel.FlxPoint;

	public class SinglePlayer extends FlxState
	{
		private var _board:Board;
		
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
			board = new Board();
			add(board);
			board.initialize();
		}

		
		
		public function get board():Board
		{
			return _board;
		}

		public function set board(value:Board):void
		{
			_board = value;
		}

		
		
	}
}