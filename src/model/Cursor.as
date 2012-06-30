package model
{
	
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;

	public class Cursor extends FlxSprite
		
	{
		[Embed(source="../../assets/cursor.png")] public static var ImgCursor:Class;
		
		private var _row:int;
		private var _column:int;
		
		
		public function Cursor()
		{
			super(0,0,ImgCursor);
			this.scale = new FlxPoint(.5,.5);
			this.row = -3;
			this.column = 3;
		}
		
		

		public function get column():int
		{
			return _column;
		}
		
		public function set column(value:int):void
		{
			trace('cursor at (' + this.column + ',' + this.row + ') moved to column ' + value);
			
			// verify new value: must be between the leftmost and the second-rightmost column
			value = Math.max(0, Math.min(Board.COLUMNS - 2, value));
			
			
			//trace('new x: ' + this.x);
			_column = value;
		}
		
					
		public function get row():int
		{
			return _row;
		}
		
		public function set row(value:int):void
		{
			trace('cursor at (' + this.column + ',' + this.row + ') moved to row ' + value);
			
			value = Math.max(0, Math.min(Board.MAX_ROWS - 1, value));
				
			_row = value;
		}



	}
}