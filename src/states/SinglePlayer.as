package states
{
	import com.greensock.TweenLite;
	
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import model.Board;
	import view.SinglePlayerDisplay;
	import controller.Controller;

	
	
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
			
			
			
			var board:Board = new Board();
			var view:SinglePlayerDisplay = new SinglePlayerDisplay(board);
			var controller:Controller = new Controller(board, view);
			
			add(board);
			add(view);
			add(controller);
			
			// draw background image
			// TODO make the gameplay area transparent, then add this AFTER the controller.
			
			//add(new FlxSprite(0,0,ImgTreeBackground));
			
			board.initialize();
			
			
			
		}

		
		
	}
}