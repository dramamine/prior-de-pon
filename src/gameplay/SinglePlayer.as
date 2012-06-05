package gameplay
{
	import org.flixel.FlxState;

	public class SinglePlayer extends FlxState
	{
		private static const BOARD_ORIGIN:FlxPoint = new FlxPoint( 50, 200 );
		private var _board:Board;
		
		/**
		 * SinglePlayer is our basic state for one-player, solo games.
		 * We'll try to keep some layout options in here, but most of our code
		 * should end up in the other classes. 
		 * 
		 */		
		public function SinglePlayer()
		{
			super();
		}
		
		override public function create()
		{
			board = new Board(BOARD_ORIGIN.x, BOARD_ORIGIN.y);
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