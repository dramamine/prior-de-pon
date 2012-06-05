package gameplay
{
	import org.flixel.FlxGroup;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;

	public class Board extends FlxGroup
	{
		private var allBlocks:FlxGroup;
		private var blocks:Vector.<Vector.<Block>>;
		private static const COLUMNS:int = 6;
		//private static const NEW_BLOCK_ORIGIN:FlxPoint = new FlxPoint( 50, 200 );
		private var rowCounter:uint = 0;
		
		
		/**
		 * Board is the main class that controls all the available blocks.
		 * Here, we're setting up vectors and a FlxGroup to track the blocks. 
		 * @param X: the X-coordinate of the "point of block origin".
		 * @param Y: the Y-coordinate of the "point of block origin".
		 * @param SimpleGraphic: should be null. This is a FlxSprite so that we
		 * can move all blocks at once.
		 * 
		 */		
		public function Board(X:Number=0, Y:Number=0, SimpleGraphic:Class)
		{
			super(X,Y,SimpleGraphic);
			
			allBlocks = new FlxGroup;
			blocks = new Vector.<Vector.<Block>>;
			for(var i = 0; i < COLUMNS; i++)
			{
				blocks.push( new Vector.<Block> );
			}
			
			
			
		}

		
		/**
		 * 
		 * @return 
		 * 
		 */		

		
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
		public function initialize(rows:int = 9, jagged:Boolean = false)
		{
			// must be called before creating blocks
			Block.initDictionary();
			
			
			for (var i = 0; i < rows; i++)
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
		private function addRow()
		{
			const blockYOrigin:Number = Block.HEIGHT * rowCounter;
			// make room for new rows
			if(blocks[0][0] != null
				&& blocks[0][0].y > blockYOrigin)
			{
				scroll( blockYOrigin );
			}
			
			// add a random block to each column
			var newBlock:Block;
			for(var column = 0; column < blocks.length; column++)
			{
				newBlock = new Block( Math.floor(Math.random() * Block.UNIQUE_BLOCKS ));
				
				blocks[column].unshift(  );
			}
			
			rowCounter++;
		}
		
		private function scroll(pixels:int)
		{
			// TODO add tweening later
			this.y -= pixels;
		}
		
		
	}
}