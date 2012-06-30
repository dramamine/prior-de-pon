package gameplay
{
	import com.greensock.TweenLite;
	
	import org.flixel.FlxPoint;
	import org.flixel.FlxState;
	import org.flixel.FlxSprite;

	
	
	public class SinglePlayer extends FlxState
	{
		
		
		
		
		
		
		[Embed(source="../assets/tetris-attack-bg.png")] private static var ImgTreeBackground:Class;
		
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
			
			// draw background image
			// TODO make the gameplay area transparent, then add this AFTER the controller.
			add(new FlxSprite(0,0,ImgTreeBackground));
			
			
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