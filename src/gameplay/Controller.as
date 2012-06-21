package gameplay
{
	import com.greensock.TweenLite;
	
	import org.flixel.FlxBasic;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxObject;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	
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
		private var cursor:Cursor;
		
		
		
		/**
		 * Board is the main class that controls all the available blocks.
		 * Here, we're setting up vectors and a FlxGroup to track the blocks. 
		 * @param SimpleGraphic: should be null. This is a FlxSprite so that we
		 * can move all blocks at once.
		 * 
		 */		
		public function Controller()
		{
			super();
			
			board = new Board();		
			add(board);
			
			TweenLite.delayedCall(2.5, board.checkEverything);
			
			
			
		}
		
		/**
		 * Creates a starting board. Also performs checks to make sure we
		 * don't start with any sets on the board.
		 * 
		 * @param rows: the number of rows of blocks to generate.
		 * @param jagged: whether the blocks should create a 'flat' pattern or
		 * 		a jagged pattern (like buildings).
		 * 
		 * 
		 */		
		public function initialize(rows:int = 9, jagged:Boolean = false):void
		{
			Block.initDictionary();
			
			var newRow:Vector.<Block>;
			for(var i:int = 0; i < rows; i++)
			{
				newRow = generateRow();
				board.addRow(newRow);
				//board.addRow( generateRow() );
				// only need to be checked on first-run.
				for each(var block:Block in newRow)
				{
					// this block is for preventing initial matches
					/*
					while(board.checkForSet(block).length > 0)
					{
						// this block causes a set
						// we need to change its color
						block.type = Math.floor(Math.random() * Block.UNIQUE_BLOCKS);
					}
					*/
				}
			}
			
		}
		
			
		
		/**
		 * Generates and adds a row of blocks to the bottom of the pile. This row is not visible on the first
		 * frame - it's generated just below the line of visibility. If there's not any room,
		 * it moves all the blocks upwards. 
		 * 
		 */		
		public static function generateRow():Vector.<Block>
		{
			var newBlocks:Vector.<Block> = new Vector.<Block>;
			// add a random block to each column
			//var newBlock:Block;
			for(var i:int = 0; i < Board.COLUMNS; i++)
			{
				newBlocks.push(new Block( Math.floor(Math.random() * Block.UNIQUE_BLOCKS )));
				//newBlock = new Block( Math.floor(Math.random() * Block.UNIQUE_BLOCKS ));
				//newBlock.x = ORIGIN.x + column * Block.WIDTH;
				//newBlock.y = ORIGIN.y + rowCounter * Block.HEIGHT - scrolledOffset;
				//blocks[column].unshift( newBlock );
				//add(newBlock);
				//trace('added a new block with color ' + newBlock.type 
				//	+ ' and coordinates (' + newBlock.x + ',' + newBlock.y + ')');
			}
			
			return newBlocks;
			
			// check the last newBlock's y. if it's below the origin, we should move all blocks up.
			//if (newBlock.y > ORIGIN.y)
			//{
			//	scroll(newBlock.y - ORIGIN.y);
			//}
			
			//rowCounter++;
			
		}
		
		
	}
}