package gameplay
{
	import org.flixel.FlxGroup;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;

	public class Board extends FlxGroup
	{
		//private var allBlocks:FlxGroup;
		private var blocks:Vector.<Vector.<Block>>;
		private static const COLUMNS:int = 6;
		//private static const NEW_BLOCK_ORIGIN:FlxPoint = new FlxPoint( 50, 200 );
		//private var rowCounter:uint = 0;
		private var scrolledOffset:Number = 0; // the number of pixels already scrolled.
		private var rowCounter:int = 0; // the number of rows already generated.
		private static const ORIGIN:FlxPoint = new FlxPoint( 50, 200 );
		
		
		
		
		/**
		 * Board is the main class that controls all the available blocks.
		 * Here, we're setting up vectors and a FlxGroup to track the blocks. 
		 * @param SimpleGraphic: should be null. This is a FlxSprite so that we
		 * can move all blocks at once.
		 * 
		 */		
		public function Board()
		{
			super();
			
			//allBlocks = new FlxGroup;
			blocks = new Vector.<Vector.<Block>>;
			for(var i:int = 0; i < COLUMNS; i++)
			{
				blocks.push( new Vector.<Block> );
			}
			
			
			
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
			// must be called before creating blocks
			Block.initDictionary();
			
			
			for (var i:int = 0; i < rows; i++)
			{
				addRow();
			}
		}
		
		/**
		 * adds a row of blocks to the bottom of the pile. This row is not visible on the first
		 * frame - it's generated just below the line of visibility. If there's not any room,
		 * it moves all the blocks upwards. 
		 * 
		 */		
		private function addRow():void
		{
			
			// add a random block to each column
			var newBlock:Block;
			for(var column:int = 0; column < blocks.length; column++)
			{
				newBlock = new Block( Math.floor(Math.random() * Block.UNIQUE_BLOCKS ));
				newBlock.x = ORIGIN.x + column * Block.WIDTH;
				newBlock.y = ORIGIN.y + rowCounter * Block.HEIGHT - scrolledOffset;
				blocks[column].unshift( newBlock );
				add(newBlock);
				trace('added a new block with color ' + newBlock.type 
					+ ' and coordinates (' + newBlock.x + ',' + newBlock.y + ')');
			}
			
			// check the last newBlock's y. if it's below the origin, we should move all blocks up.
			if (newBlock.y > ORIGIN.y)
			{
				scroll(newBlock.y - ORIGIN.y);
			}
			
			rowCounter++;
			
		}
		
		private function scroll(pixels:int):void
		{
			trace('scroll called with pixels: ' + pixels);
			// TODO might be faster via a camera.
			// TODO add tweening later
			for each (var block:FlxSprite in members)
			{
				block.y -= pixels;
			}
			
			scrolledOffset += pixels;
		}
		
		
	}
}