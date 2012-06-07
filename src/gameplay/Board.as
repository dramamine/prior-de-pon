package gameplay
{
	import com.greensock.TweenLite;
	
	import org.flixel.FlxGroup;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;

	public class Board extends FlxGroup
	{
		public static const COLUMNS:int = 6;
		
		public function Board()
		{
			super();
		}
		
		
		/**
		 * Adds a row of blocks to the bottom of the pile. Moves all other blocks upwards. 
		 * @param blocks
		 * 
		 */		
		public function addRow(blocks:Vector.<Block>):void
		{
			this.shiftUpwards();
			
			var position:uint = 0;
			for each(var block:Block in blocks)
			{
				add(block);
				block.position = position;
				position++;
			}
			
			/*
			// add a random block to each column
			var newBlock:Block;
			for(var column:int = 0; column < blocks.length; column++)
			{
				newBlock = new Block( Math.floor(Math.random() * Block.UNIQUE_BLOCKS ));
				
				
				//blocks[column].unshift( newBlock );
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
			*/
		}
		
		/**
		 * If the given block is part of a set, this function returns all the blocks that are part of that set. 
		 * @param block
		 * @return 
		 * 
		 */		
		public function checkForSet(block:Block):Vector.<Block>
		{
			return null;
		}
		private function checkColumn(column:int):Vector.<Block>
		{
			return getMatches( getColumn(column) );
		}
		private function checkRow(row:int):Vector.<Block>
		{
			return getMatches( getRow(row) );
		}
		
		/**
		 * Helper function for checkColumn and checkRow. Returns any blocks that are part of a match. 
		 * @param sequence The sequence of blocks to check.
		 * @return The blocks that are part of sets.
		 * 
		 */		
		private static function getMatches(sequence:Vector.<Block>):Vector.<Block>
		{
			var matchingBlocks:Vector.<Block> = new Vector.<Block>();
			var matches:int;
			
			for(var i:int = 0; i < blocks.length - 2; i++)
			{
				matches = getSequenceCount(blocks, i)
				if(matches >= 3)
				{
					do
					{
						matches--;
						matchingBlocks.push( blocks[i + matches] );
					} 
					while (matches >= 0);
					
					// don't re-check the ones we found!
					i += matches - 1;
				}
				
			}
			
			return matchingBlocks;
		}
		
		/**
		 * Helper function for getMatches. Returns the number of equal blocks in a row, given a
		 * starting index and an array to check. 
		 * @param blocks The array of blocks to check.
		 * @param indexToCheck The 'starting index', i.e. find out how many blocks after this block,
		 * INCLUDING this block, are equal to this block.
		 * @return The size of the set. This will range from 1 to...6 at most, I think?
		 * 
		 */
		private static function getSequenceCount(blocks:Vector.<Block>, indexToCheck:int):int
		{
			var counter:int = 1;
			for (var iterator:int = indexToCheck+1; iterator < blocks.length; iterator++)
			{
				if (blocks[indexToCheck].equals( blocks[iterator] ))
				{
					counter++;
				}
				else
				{
					break;
				}
				
			}
			return counter;
		}
		
		private function getColumn(column:int):Vector.<Block>
		{
			return members.filter( function(o:Block):Boolean
			{
				return o.column == column;
			}).sort("row");
		}
		
		private function getRow(row:int):Vector.<Block>
		{
			return members.filter( function(o:Block):Boolean
			{
				return o.row == row;
			}).sort("column");
		}
		
		
		
		/**
		 * Shifts the position of all blocks upwards. 
		 * 
		 */		
		private function shiftUpwards():void
		{
			for each (var b:Block in members)
			{
				b.position += Board.COLUMNS;
			}
		}
		
	}
}