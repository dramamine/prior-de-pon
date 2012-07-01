package model
{
	import com.greensock.TweenLite;
	
	import controller.Controller;
	
	import flash.utils.Dictionary;
	
	import org.flixel.FlxBasic;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxU;
	
	import view.ScoreDisplay;
	
	public class Board extends FlxGroup
	{
		
		
		public static const COLUMNS:int = 6;
		public static const MAX_ROWS:int = 13;
		public static const PANIC_ROWS:int = 10;
		
		public static const LEVEL:int = 20;
		private var _scrollingOffset:int = 0;
		
		private var _cursor:Cursor;
		private var timer:GameTimer;
		private var _blocks:FlxGroup;
		//private var cursorGroup:FlxGroup;
		private var comboTracker:Dictionary = new Dictionary;
		private var scoreManager:ScoreManager;
		
		
		
		public function Board()
		{
			super();
			
			blocks = new FlxGroup();	
			cursor = new Cursor();

			timer = new GameTimer(this);
			timer.run();
			
			// I don't like the way this is set up. We shouldn't be creating views
			// within the model like this...
			scoreManager = new ScoreManager();
			//add(scoreManager);
			var scoreDisplay:ScoreDisplay = new ScoreDisplay(scoreManager);
			add(scoreDisplay);
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
			
			//var newRow:Vector.<Block>;
			for(var i:int = 0; i < rows; i++)
			{
				
				addRow( generateRow(), false );
				
			}
			
			eliminateMatches();
			
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
		
		
		/**
		 * Adds a row of blocks to the bottom of the pile. Moves all other blocks upwards. 
		 * @param blocks
		 * 
		 */		
		public function addRow(newBlocks:Vector.<Block>, checkForSets:Boolean = true):void
		{
			this.shiftUpwards();
			
			var column:uint = 0;
			for each(var block:Block in newBlocks)
			{
				blocks.add(block);
				
				
				
				// 6/15 handling column/row adjustment from the block class
				//block.x = ORIGIN.x;// + block.column * Block.WIDTH;
				//block.y = ORIGIN.y;// - block.row * Block.HEIGHT;
				
				//block.row = 0; // by default
				block.column = column;
				
				column++;
			}
			
			// row 0 comes in as inactive.
			// let's activate row 1.
			for each(var block:Block in getRow(1))
			{
				block.activate();
			}
			if(checkForSets)
			{
				for each(var block:Block in getRow(1))
				{
					handleSet(checkForSet(block));
				}
			}
			
			
			
			
		}
		
		/**
		 * Swaps the block at the given location with the block to its right. 
		 * @param row: The row of the blocks to swap.
		 * @param column: The column of the first block to swap.
		 * @return 
		 * 
		 */
		public function swap():void
		{
			var blockA:Block = getBlockAt(cursor.row, cursor.column);
			var blockB:Block = getBlockAt(cursor.row, cursor.column+1);
			
			if(blockA == null && blockB == null) return;
			if(blockA == null || blockB == null)
			{
				if(blockA == null) blockB.column--;
				else if(blockB == null) blockA.column++;
				
				checkGravity(cursor.column);
				checkGravity(cursor.column+1);
			}
			else if(blockA.state == Block.ACTIVE && blockB.state == Block.ACTIVE)
			{
				blockA.column++;
				blockB.column--;
			}
			
			// handle any potential matches all at once
			handleSet(
				checkRow(cursor.row)
				.concat(checkColumn(cursor.column))
				.concat(checkColumn(cursor.column+1))
			);
			
		}
		
		/**
		 * If the given block is part of a set, this function returns all the blocks that are part of that set. 
		 * @param block
		 * @return 
		 * 
		 */		
		//		public function checkForSet(block:Block):Vector.<Block>
		//		{
		//			return null;
		//		}
		
		
		/**
		 * Checks the entire board for matches.
		 * WARNING: returns duplicates if a block is in a horizontal and a vertical set! 
		 * @return: a Vector containing all the blocks in matches.
		 * 
		 */
		public function checkEverything():Vector.<Block>
		{
			var resultSet:Vector.<Block> = new Vector.<Block>();
			// check all columns
			for (var column:int = 0; column < Board.COLUMNS; column++)
			{
				trace('checking column ' + column + ' which has ' + checkColumn(column).length + ' matches.');
				if(checkColumn(column).length > 0)
				{
					
					trace('hi');
					resultSet = resultSet.concat(checkColumn(column));
				}
				
			}
			
			// check all rows
			for (var row:int = 0; row < Board.MAX_ROWS; row++)
			{
				trace('checking row ' + row + ' which has ' + checkRow(row).length + ' matches.');
				resultSet = resultSet.concat(checkRow(row));
			}
			
			return resultSet;
		}
		
		/**
		 * If the given block is part of a set, this function returns all the blocks that are part of that set.
		 * WARNING: right now, this function could return false positives, ex. if there's a set in this
		 * block's column, that doesn't include this block in particular. But right now, we're only using
		 * this function in the init() function to make sure that we start with a board with no sets, so
		 * it shouldn't be a problem. 
		 * @param block: The block to check.
		 * @return a Vector with all the blocks that form sets. 
		 * @param column
		 * @return 
		 * 
		 */	
		public function checkForSet(block:Block):Vector.<Block>
		{
			return checkColumn(block.column).concat(checkRow(block.row));
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
			// don't check matched blocks
			if( blocks[indexToCheck].state == Block.MATCHED) return 1;
			
			
			function isAdjacent(blockA:Block, blockB:Block):Boolean
			{
				if(blockA.row == blockB.row
					&& Math.abs( blockA.column - blockB.column) == 1 ) return true;
				else if(blockA.column == blockB.column
					&& Math.abs( blockA.row - blockB.row) == 1 ) return true;
				return false;
			}
			
			
			var counter:int = 1;
			for (var iterator:int = indexToCheck+1; iterator < blocks.length; iterator++)
			{
				// make sure the blocks are actually adjacent.
				if (blocks[indexToCheck].equals( blocks[iterator] )
				&& isAdjacent(blocks[iterator], blocks[iterator - 1]))
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
		
		/**
		 * Returns all blocks in a given column, ordered by row. 
		 * @param column: the index of the column.
		 * @return a Vector containing all the blocks in the given column.
		 * 
		 */
		private function getColumn(column:int):Vector.<Block>
		{
			
			
			function columnMatcher(o:Block, index:int, arr:Array):Boolean
			{
				if(o == null || !o.exists) return false;
				return o.column == column;
			}
			
			function rowSorter(a:Block, b:Block):int
			{
				if(a.row < b.row) return -1;
				else if(a.row > b.row) return 1;
				else return 0;
			}
			
			return Vector.<Block>( blocks.members.filter(columnMatcher).sort(rowSorter) );
			
		}
		
		
		/**
		 * Returns the block at a given location. 
		 * @param row
		 * @param column
		 * @return 
		 * 
		 */
		private function getBlockAt(row:int, column:int):Block
		{
			function coordinateMatcher(o:Block, index:int, arr:Array):Boolean
			{
				if(o == null || !o.exists) return false;
				return (o.row == row && o.column == column);
			}
			if(blocks.members.filter(coordinateMatcher).length > 0)
			return blocks.members.filter(coordinateMatcher)[0];
			else return null;
		}
		
		/**
		 * Returns all the blocks in a given row, ordered by column. 
		 * @param row: the index of the row.
		 * @return a Vector containing all the blocks in the given row.
		 * 
		 */
		private function getRow(row:int):Vector.<Block>
		{
			
			
			function rowMatcher(o:Block, index:int, arr:Array):Boolean
			{
				if(o == null || !o.exists) return false;
				return o.row == row;
			}
			
			function columnSorter(a:Block, b:Block):int
			{
				if(a.column < b.column) return -1;
				else if(a.column > b.column) return 1;
				else return 0;
			}
			
			return Vector.<Block>( blocks.members.filter( rowMatcher ).sort( columnSorter ) );
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
		 * Shifts the position of all blocks upwards. This is done generally to make room for
		 * a new row of blocks on the bottom, i.e. row 0.
		 * 
		 */		
		private function shiftUpwards():void
		{
			// tracker
			for each (var b:Block in blocks.members)
			{
				b.row++;
			}
			
			// actual pixels
			if(scrollingOffset <= Block.HEIGHT)
			{
				for each (var b:Block in blocks.members)
				{
					b.y += scrollingOffset; // move up to the next full block
				}
				
				scrollingOffset = 0;
			}
			else
			{
				trace('warning: scrollingOffset was too high!');
				scrollingOffset = 0;
			}

			// update cursor's row tracker
			cursor.row++;
		}
		
		
		/**
		 * Scrolls each block upwards by a certain number of pixels. 
		 * @param pixels: the number of pixels.
		 * 
		 */		
		public function scroll(pixels:int = 1):void
		{
			//trace('scroll called with pixels: ' + pixels);
			// TODO might be faster via a camera.
			// TODO add tweening later
			for each (var block:Block in blocks.members)
			{
				block.y -= pixels;
			}
			cursor.y -= pixels;
			
			scrollingOffset += pixels;
			while(scrollingOffset > Block.HEIGHT)
			{
				addRow( generateRow() );
//				scrollingOffset -= Block.HEIGHT;
//				for each (var block:Block in blocks.members)
//				{
//					block.y += Block.HEIGHT;
//				}
			}
			
		}
				
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
		 * [v4] Now made recursive to handle chaining.
		 * @param matchedBlocks: a Vector containing blocks that are part of a set.
		 * @param chain: the iteration of chains.
		 * 
		 */		
		private function handleSet(matchedBlocks:Vector.<Block>, chain:int = 0):void
		{
			if(matchedBlocks == null || matchedBlocks.length == 0) return;
			
			chain++;
			trace('handleSet called with ' + matchedBlocks.length + ' blocks, chain count is now ' + chain);
			
			// scoring
			scoreManager.tally(matchedBlocks, chain);
			
			// freezing
			if(chain > 1 || matchedBlocks.length > 3)
			{
				timer.stop(Properties.SCREEN_FREEZE_LENGTH);
			}
			
			// TODO Auto Generated method stub
			for each(var block:Block in matchedBlocks)
			{
				block.match();
			}
			
			TweenLite.delayedCall(Properties.BLOCK_DISAPPEARING_DELAY, function()
			{
				// TODO could make these "chain-delete", might be cooler.
				for each(var block:Block in matchedBlocks)
				{
					block.kill();
				}
				
				// run checkAllGravity, and add the blocks to fall to the combo tracker.
				for each (var block:Block in checkAllGravity())
				{
					comboTracker[block] = chain;
				}
				
				// if gravity causes a chain, we need to keep this going.
			});
		}
		
		
		private function checkGravity(columnID:int):Vector.<Block>
		{
			var fell:Vector.<Block> = new Vector.<Block>;
			var column:Vector.<Block>;
			var lastRealBlock:int = 0;
			column = getColumn(columnID);
			// assumes that this is sorted by row
			for each (var block:Block in column)
			{
				if (block.exists
					&& block.row == lastRealBlock)
				{
					// everything's good
					lastRealBlock++;
				}
				else
				{
					// move it down enough rows
					block.fallToRow(lastRealBlock, onBlockFell);
					fell.push(block);
					lastRealBlock++;
				}
				
			}
			return fell;
		}
		
		/**
		 * Callback for when a block finishes falling. 
		 * @param e
		 * @return 
		 * 
		 */
		private function onBlockFell(block:Block):void
		{
			trace('onBlockFell called.');
			// see if this block causes any sets
			handleSet( checkForSet( block ) ,
				comboTracker[block]
			);
			
			// remove this block from the chain tracker
			delete comboTracker[block];
		}
		
		/**
		 * This sets up each block to fall as it should.
		 * Flixel does have some functions to handle gravity, but we need to make sure our
		 * "blocks" vector is set up properly. 
		 * 
		 * 
		 */		
		private function checkAllGravity():Vector.<Block>
		{
			trace('checkGravity called.');
			var fell:Vector.<Block> = new Vector.<Block>;
			var theseFell:Vector.<Block> = new Vector.<Block>;
			for (var i:int=0; i < Board.COLUMNS; i++)
			{
				theseFell = checkGravity(i);
				if(theseFell.length > 0) fell = fell.concat(theseFell);		
			}
			return fell;
		}
		
		
		/**
		 * Called to make sure the initial board doesn't have any matches on it. 
		 * 
		 */
		public function eliminateMatches():void
		{
			var allMatches:Vector.<Block> = this.checkEverything();
			trace('found ' + allMatches.length + ' matches.');
			var randomBlock:Block;
			while(allMatches.length > 0)
			{
				// this block causes a set
				// we need to change its color
				// get random block
				randomBlock = allMatches[ Math.floor(Math.random() * allMatches.length) ];
				randomBlock.type = Math.floor(Math.random() * Block.UNIQUE_BLOCKS);
				
				//try again
				allMatches = this.checkEverything();
			}
		}
		
		
		
		override public function update():void
		{
					
			super.update();
		}
		
		
		
		
		/**
		 * Handle player request to scroll more blocks. 
		 * 
		 */
		public function handleTurboScroll():void
		{
			timer.activateTurboScroll( Block.HEIGHT - scrollingOffset );
		}

		public function get blocks():FlxGroup
		{
			return _blocks;
		}

		public function set blocks(value:FlxGroup):void
		{
			_blocks = value;
		}

		public function get cursor():Cursor
		{
			return _cursor;
		}

		public function set cursor(value:Cursor):void
		{
			_cursor = value;
		}


	}
}