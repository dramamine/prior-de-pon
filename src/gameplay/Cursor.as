package gameplay
{
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;

	public class Cursor extends FlxSprite
	{
		private var _row:int;
		private var _column:int;
		
		public function Cursor()
		{
			this.row = 6;
			this.column = 3;
		}
		
		override public function update():void
		{
			
			if(FlxG.keys.justPressed("LEFT"))
			{
				if(this.column > 0)
				{
					column--;
				}
			}
			else if(FlxG.keys.justPressed("RIGHT"))
			{
				if(this.column < Board.COLUMNS - 2) // 0-index, plus cursor is 2 blocks wide
				{
					column++;
				}
			}
			if(FlxG.keys.justPressed("UP"))
			{
				if(this.row < Board.MAX_ROWS - 1) // 0-index
				{
					row++;
					
				}
			}
			else if(FlxG.keys.justPressed("DOWN"))
			{
				if(this.row > 0)
				{
					row--;
				}
			}
			
			super.update();
		}

		public function get column():uint
		{
			return _column;
		}
		
		public function set column(value:uint):void
		{
			trace('cursor at (' + this.column + ',' + this.row + ') moved to column ' + value);
			// also handle graphics
			// TODO tweening, let's just do it suddenly for now
			var columnDelta:int = value - this.column;
			this.x += columnDelta * Block.WIDTH;
			
			trace('new x: ' + this.x);
			_column = value;
		}
		
		public function get row():uint
		{
			return _row;
		}
		
		public function set row(value:uint):void
		{
			trace('cursor at (' + this.column + ',' + this.row + ') moved to row ' + value);
			// also handle graphics
			// TODO tweening, let's just do it suddenly for now
			var rowDelta:int = value - this.row;
			this.y -= rowDelta * Block.HEIGHT;
			
			_row = value;
		}



	}
}