package gameplay
{
	import com.greensock.TweenLite;
	
	import org.flixel.FlxBasic;
	import org.flixel.FlxGroup;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;

	public class Board extends FlxGroup
	{
		public static const COLUMNS:int = 6;
		public static const MAX_ROWS:int = 13;
		public static const PANIC_ROWS:int = 10;
		public static const ORIGIN:FlxPoint = new FlxPoint(50,200);
		private var _scrollingOffset:int = 0;
		
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
			
			var column:uint = 0;
			for each(var block:Block in blocks)
			{
				add(block);
				//block.row = 0; // by default
				block.column = column;
				block.x = ORIGIN.x + block.column * Block.WIDTH;
				block.y = ORIGIN.y - block.row * Block.HEIGHT;
								
				column++;
			}
			
		}
		
		/**
		 * If the given block is part of a set, this function returns all the blocks that are part of that set.
		 * WARNING: right now, this function could return false positives, ex. if there's a set in this
		 * block's column, that doesn't include this block in particular. But right now, we're only using
		 * this function in the init() function to make sure that we start with a board with no sets, so
		 * it shouldn't be a problem. 
		 * @param block: The block to check.
		 * @return a Vector with all the blocks that form sets.
		 * 
		 */		
		public function checkForSet(block:Block):Vector.<Block>
		{
			return checkColumn(block.column).concat(checkRow(block.row));
		}
		
		
		/**
		 * This checks the entire board and handles any sets. (I'm not sure if we ever need to call this
		 * besides during debugging; it's overkill for basically all situations.) 
		 * @return 
		 * 
		 */
		public function checkEverything()
		{
			// check all columns
			for (var column:int = 0; column < Board.COLUMNS; column++)
			{
				trace('checking column ' + column);
				handleSet(checkColumn(column));
			}
			
			// check all rows
			for (var row:int = 0; row < Board.MAX_ROWS; row++)
			{
				trace('checking row ' + row);
				handleSet(checkRow(row));
			}
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
			
			
			for(var sequenceIndex:int = 0; sequenceIndex < sequence.length - 2; sequenceIndex += matches)
			{
				// matches = the size of the sequence. i.e. if the block is solitary, matches=1. 
				// the loop is "i += matches" so that we skip over any blocks we've already looked at.
				matches = getSequenceCount(sequence, sequenceIndex)
				if(matches >= 3)
				{
					for(var matchIndex:int = 0; matchIndex < matches; matchIndex++)
					{
						matchingBlocks.push( sequence[sequenceIndex + matchIndex] );
					}
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
			
			
			function columnMatcher(o:Block, index:int, arr:Array):Boolean
			{
				if(o == null) return false;
				return o.column == column;
			}
			
			function rowSorter(a:Block, b:Block):int
			{
				if(a.row < b.row) return -1;
				else if(a.row > b.row) return 1;
				else return 0;
			}
			
			
			return Vector.<Block>( this.members.filter(columnMatcher).sort(rowSorter) );
			
		}
		
		private function getRow(row:int):Vector.<Block>
		{
			return Vector.<Block>( members.filter( rowMatcher ).sort( columnSorter ) );
			
			function rowMatcher(o:Block, index:int, arr:Array):Boolean
			{
				if(o == null) return false;
				return o.row == row;
			}
			
			function columnSorter(a:Block, b:Block):int
			{
				if(a.column < b.column) return -1;
				else if(a.column > b.column) return 1;
				else return 0;
				//sortOn("row", Array.NUMERIC);
			}
			
		}
		
		
		
		/**
		 * Shifts the position of all blocks upwards. 
		 * 
		 */		
		private function shiftUpwards():void
		{
			// tracker
			for each (var b:Block in members)
			{
				b.row++;
			}
			
			// actual pixels
			if(scrollingOffset < Block.HEIGHT)
			{
				for each (var b:Block in members)
				{
					b.y -= Block.HEIGHT - scrollingOffset; // move up to the next full block
				}
				
				scrollingOffset = 0;
			}
			else
			{
				trace('warning: scrollingOffset was too high!');
			}
		}

		public function get scrollingOffset():int
		{
			return _scrollingOffset;
		}

		public function set scrollingOffset(value:int):void
		{
			_scrollingOffset = value;
		}

		
		/**
		 * Scrolls each block upwards by a certain number of pixels. 
		 * @param pixels: the number of pixels.
		 * 
		 */		
//		private function scroll(pixels:int):void
//		{
//			trace('scroll called with pixels: ' + pixels);
//			// TODO might be faster via a camera.
//			// TODO add tweening later
//			for each (var block:FlxSprite in members)
//			{
//				block.y -= pixels;
//			}
//			
//			scrolledOffset += pixels;
//		}
		
//		public function checkAll():void
//		{
//			for (var i:uint = 0; i < blocks.length; i++)
//			{
//				for (var j:uint = 0; j < blocks[i].length; j++)
//				{
//					if(blocks[i][j].checkMe && blocks[i][j].state = Block.ACTIVE)
//					{
//						handleSet(checkSet(i,j));
//						blocks[i][j].checkMe = false;
//					}
//				}
//			}
//		}
//		
//		private function checkSet(col:uint, row:uint):Vector.<Block>
//		{
//			trace('checkSet called with coordinates (' + col + ',' + row + ')');
//			// check for vertical matches
//			var verticalBlocks:Vector.<Block> = new Vector.<Block>();
//			var horizontalBlocks:Vector.<Block> = new Vector.<Block>();
//			
//			var rowIndex:int;
//			// look upwards
//			for(rowIndex = row - 1; (rowIndex > 0) && (blocks[col][row].equals(blocks[col][rowIndex])); rowIndex--)
//			{
//				trace('found a match above.');
//				verticalBlocks.push( blocks[col][rowIndex] );
//			}
//			
//			// look downwards
//			for(rowIndex= row + 1; (rowIndex < blocks[col].length) && (blocks[col][row].equals(blocks[col][rowIndex])); rowIndex++)
//			{
//				trace('found a match below.');
//				verticalBlocks.push( blocks[col][rowIndex] );
//			}
//			
//			var colIndex:int;
//			// look left
//			for(colIndex = col - 1; (colIndex > 0) && (blocks[col][row].equals(blocks[colIndex][row])); colIndex--)
//			{
//				trace('found a match above.');
//				verticalBlocks.push( blocks[colIndex][row] );
//			}
//			
//			// look right
//			for(colIndex = col + 1; (colIndex < blocks.length) && (blocks[col][row].equals(blocks[colIndex][row])); colIndex++)
//			{
//				trace('found a match below.');
//				verticalBlocks.push( blocks[colIndex][row] );
//			}
//			
//			
//			
//			
//			if(verticalBlocks.length >= 2 || horizontalBlocks.length >= 2)
//			{
//				var matchedBlocks:Vector.<Block> = new Vector.<Block>();
//				matchedBlocks.push(blocks[col][row]);
//				
//				if(verticalBlocks.length >= 2)
//				{
//					for each(var block:Block in verticalBlocks)
//					{
//						matchedBlocks.push(block);
//					}
//				}
//				if(horizontalBlocks.length >= 2)
//				{
//					for each(var block:Block in horizontalBlocks)
//					{
//						matchedBlocks.push(block);
//					}
//				}
//				
//				
//			}
//			return matchedBlocks;
//			
//		}
		
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
//			trace('checkGravity called.');
//			for each(var column:Vector.<Block> in blocks)
//			{
//				// TODO make sure we're not dealing with huge blocks of garbage.
//				
//				//column.filter( function(b:Block):Boolean{ return b.alive });
//				
//				for(var index:int = 0; index < column.length; index++)
//				{
//					if(column[index].alive) continue;
//					else
//					{
//						column.splice(index,1);
//						column.slice(index).map( function(b:Block, i:int, a:*){b.y += Block.HEIGHT;} );
//						index--;
//					}
//				}
//			}
		}
		
		
		
	}
}