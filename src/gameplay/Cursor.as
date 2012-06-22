package gameplay
{
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;

	public class Cursor extends FlxSprite
		
	{
		[Embed(source="../../assets/cursor.png")] public static var ImgCursor:Class;
		
		private var _row:int;
		private var _column:int;
		public static const OFFSET:FlxPoint = new FlxPoint(-20,-12);
		
		public function Cursor()
		{
			super(0,0,ImgCursor);
			this.scale = new FlxPoint(.5,.5);
			this.row = -3;
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

		public function get column():int
		{
			return _column;
		}
		
		public function set column(value:int):void
		{
			trace('cursor at (' + this.column + ',' + this.row + ') moved to column ' + value);
			// also handle graphics
			// TODO tweening, let's just do it suddenly for now
			//var columnDelta:int = value - this.column;
			//this.x += columnDelta * Block.WIDTH;
			
			//trace('new x: ' + this.x);
			_column = value;
		}
		
		public function incrementColumn(changeGraphics:Boolean = true)
		{
			column++;
			if(changeGraphics)
			{
				this.x += Block.WIDTH;
			}
		}
		public function decrementColumn(changeGraphics:Boolean = true)
		{
			column--;
			if(changeGraphics)
			{
				this.x -= Block.WIDTH;
			}
			
		}
		
		/*
		public function incrementRow(changeGraphics:Boolean = true)
		{
			row++;
			if(changeGraphics)
			{
				this.y -= Block.HEIGHT;
			}
		}
		public function decrementRow(changeGraphics:Boolean = true)
		{
			row--;
			if(changeGraphics)
			{
				this.y += Block.HEIGHT;
			}
			
		}
		*/
		
		public function get row():int
		{
			return _row;
		}
		
		public function set row(value:int):void
		{
			trace('cursor at (' + this.column + ',' + this.row + ') moved to row ' + value);
			// also handle graphics
			// TODO tweening, let's just do it suddenly for now
			//var rowDelta:int = value - this.row;
			//this.y -= rowDelta * Block.HEIGHT;
			
			_row = value;
		}



	}
}