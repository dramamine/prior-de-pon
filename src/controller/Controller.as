package controller
{
	import com.greensock.TweenLite;
	
	import model.Board;
	
	import org.flixel.FlxBasic;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxObject;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	
	import view.SinglePlayerDisplay;
	import model.Cursor;
	
	public class Controller extends FlxGroup
	{
		//private var allBlocks:FlxGroup;
		//private var blocks:Vector.<Vector.<Block>>;
		
		//private static const NEW_BLOCK_ORIGIN:FlxPoint = new FlxPoint( 50, 200 );
		//private var rowCounter:uint = 0;
		//private var scrolledOffset:Number = 0; // the number of pixels already scrolled.
		//private var rowCounter:int = 0; // the number of rows already generated.
		private static const ORIGIN:FlxPoint = new FlxPoint( 50, 200 );

		private var board:Board;
		private var display:SinglePlayerDisplay;
		private var cursor:Cursor;
		
		
		
		
		/**
		 * Board is the main class that controls all the available blocks.
		 * Here, we're setting up vectors and a FlxGroup to track the blocks. 
		 * @param SimpleGraphic: should be null. This is a FlxSprite so that we
		 * can move all blocks at once.
		 * 
		 */		
		public function Controller(board:Board, display:SinglePlayerDisplay)
		{
			super();
			
			this.board = board;
			this.display = display;
			
			//TweenLite.delayedCall(2.5, board.checkEverything);
			
			
			
		}
		
		override public function update():void
		{
			// handle swapping
			if(FlxG.keys.justPressed("SPACE"))
			{
				board.swap();
			}
			
			// handle scrolling
			if(FlxG.keys.justPressed("SHIFT"))
			{
				board.handleTurboScroll();
			}
			
			if(FlxG.keys.justPressed("LEFT"))
			{
				board.cursor.column--;
			}
			else if(FlxG.keys.justPressed("RIGHT"))
			{
				board.cursor.column++;
			}
			if(FlxG.keys.justPressed("UP"))
			{
				board.cursor.row++;
			}
			else if(FlxG.keys.justPressed("DOWN"))
			{
				board.cursor.row--;
			}
			
			super.update();
		}
		
		
			
		
		
		
		
	}
}