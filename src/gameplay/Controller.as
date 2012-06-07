package gameplay
{
	import org.flixel.FlxBasic;
	import org.flixel.FlxPoint;
	
	public class Controller extends FlxBasic
	{
		//private var allBlocks:FlxGroup;
		//private var blocks:Vector.<Vector.<Block>>;
		
		//private static const NEW_BLOCK_ORIGIN:FlxPoint = new FlxPoint( 50, 200 );
		//private var rowCounter:uint = 0;
		//private var scrolledOffset:Number = 0; // the number of pixels already scrolled.
		//private var rowCounter:int = 0; // the number of rows already generated.
		private static const ORIGIN:FlxPoint = new FlxPoint( 50, 200 );

		private var board:Board;
		
		
		
		
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
			var newRow:Vector.<Block>;
			for(var i:int = 0; i < rows; i++)
			{
				newRow = generateRow();
				board.addRow(newRow);
				//board.addRow( generateRow() );
				// only need to be checked on first-run.
				for each(var block:Block in newRow)
				{
					while(board.checkForSet(block) != null)
					{
						// this block causes a set
						// we need to change its color
						block.type = Math.floor(Math.random() * Block.UNIQUE_BLOCKS;
					}
				}
			}
			
		}
		
			
		
		/**
		 * Generates and adds a row of blocks to the bottom of the pile. This row is not visible on the first
		 * frame - it's generated just below the line of visibility. If there's not any room,
		 * it moves all the blocks upwards. 
		 * 
		 */		
		private function generateRow():Vector.<Block>
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
		
		/**
		 * Scrolls each block upwards by a certain number of pixels. 
		 * @param pixels: the number of pixels.
		 * 
		 */		
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
		
		public function checkAll():void
		{
			for (var i:uint = 0; i < blocks.length; i++)
			{
				for (var j:uint = 0; j < blocks[i].length; j++)
				{
					if(blocks[i][j].checkMe && blocks[i][j].state = Block.ACTIVE)
					{
						handleSet(checkSet(i,j));
						blocks[i][j].checkMe = false;
					}
				}
			}
		}
		
		private function checkSet(col:uint, row:uint):Vector.<Block>
		{
			trace('checkSet called with coordinates (' + col + ',' + row + ')');
			// check for vertical matches
			var verticalBlocks:Vector.<Block> = new Vector.<Block>();
			var horizontalBlocks:Vector.<Block> = new Vector.<Block>();
			
			var rowIndex:int;
			// look upwards
			for(rowIndex = row - 1; (rowIndex > 0) && (blocks[col][row].equals(blocks[col][rowIndex])); rowIndex--)
			{
				trace('found a match above.');
				verticalBlocks.push( blocks[col][rowIndex] );
			}
			
			// look downwards
			for(rowIndex= row + 1; (rowIndex < blocks[col].length) && (blocks[col][row].equals(blocks[col][rowIndex])); rowIndex++)
			{
				trace('found a match below.');
				verticalBlocks.push( blocks[col][rowIndex] );
			}
			
			var colIndex:int;
			// look left
			for(colIndex = col - 1; (colIndex > 0) && (blocks[col][row].equals(blocks[colIndex][row])); colIndex--)
			{
				trace('found a match above.');
				verticalBlocks.push( blocks[colIndex][row] );
			}
			
			// look right
			for(colIndex = col + 1; (colIndex < blocks.length) && (blocks[col][row].equals(blocks[colIndex][row])); colIndex++)
			{
				trace('found a match below.');
				verticalBlocks.push( blocks[colIndex][row] );
			}
			
			
			
			
			if(verticalBlocks.length >= 2 || horizontalBlocks.length >= 2)
			{
				var matchedBlocks:Vector.<Block> = new Vector.<Block>();
				matchedBlocks.push(blocks[col][row]);
				
				if(verticalBlocks.length >= 2)
				{
					for each(var block:Block in verticalBlocks)
					{
						matchedBlocks.push(block);
					}
				}
				if(horizontalBlocks.length >= 2)
				{
					for each(var block:Block in horizontalBlocks)
					{
						matchedBlocks.push(block);
					}
				}
				
				
			}
			return matchedBlocks;
			
		}
		
		/**
		 * This function sets all blocks to MATCHED, calls a timer to make them disappear,
		 * and handles chain / combo / scoring effects. 
		 * @param matchedBlocks: a Vector containing blocks that are part of a set.
		 * 
		 */		
		private function handleSet(matchedBlocks:Vector.<Block>):void
		{
			if(matchedBlocks == null || matchedBlocks.length == 0) return;
			
			trace('handleSet called with ' + matchedBlocks.length + ' blocks.');
			// TODO Auto Generated method stub
			for each(var block:Block in matchedBlocks)
			{
				block.match();
			}
			
			TweenLite.delayedCall(2.5, function()
			{
				// TODO could make these "chain-delete", might be cooler.
				for each(var block:Block in matchedBlocks)
				{
					block.kill();
				}
				
				checkGravity();				
			});
		}
		
		/**
		 * This sets up each block to fall as it should.
		 * Flixel does have some functions to handle gravity, but we need to make sure our
		 * "blocks" vector is set up properly. 
		 * 
		 */		
		private function checkGravity():void
		{
			trace('checkGravity called.');
			for each(var column:Vector.<Block> in blocks)
			{
				// TODO make sure we're not dealing with huge blocks of garbage.
				
				//column.filter( function(b:Block):Boolean{ return b.alive });
				
				for(var index:int = 0; index < column.length; index++)
				{
					if(column[index].alive) continue;
					else
					{
						column.splice(index,1);
						column.slice(index).map( function(b:Block, i:int, a:*){b.y += Block.HEIGHT;} );
						index--;
					}
				}
			}
		}
	}
}