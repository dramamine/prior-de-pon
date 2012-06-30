package view
{
	import model.Block;
	import model.Cursor;
	
	import model.Board;
	
	import org.flixel.FlxBasic;
	import org.flixel.FlxPoint;
	import org.flixel.FlxGroup;
	
	public class SinglePlayerDisplay extends FlxGroup
	{
		private var _board:Board;
		public static const ORIGIN:FlxPoint = new FlxPoint(50,200);
		public static const CURSOR_OFFSET:FlxPoint = new FlxPoint(-20,-12);
		
		public function SinglePlayerDisplay(board:Board)
		{
			super();
			this._board = board;
			
			add(board.blocks);
			add(board.cursor);
			
			
		}
		
		override public function update():void
		{
			// draw everything
			for each(var b:Block in _board.blocks.members)
			{
				if(b.state == Block.FALLING) continue;
				b.x = getColumnPixels(b.column);
				b.y = getRowPixels(b.row);
				
			}
			_board.cursor.x = getColumnPixels(_board.cursor.column) + CURSOR_OFFSET.x;
			_board.cursor.y = getRowPixels(_board.cursor.row) + CURSOR_OFFSET.y;
		}
		
		
		private function getRowPixels(row:uint):Number
		{
			return ORIGIN.y - Block.HEIGHT * row - _board.scrollingOffset;
		}
		private function getColumnPixels(column:uint):Number
		{
			return ORIGIN.x + Block.WIDTH * column;
		}
		
		
	}
}