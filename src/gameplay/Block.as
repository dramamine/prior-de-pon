package gameplay
{
	import flash.utils.Dictionary;
	
	import org.flixel.FlxSprite;
	

	
	
	public class Block extends FlxSprite
	{
		[Embed(source="../../assets/block-blue.gif")] public static var BlueGIF:Class;
		[Embed(source="../../assets/block-cyan.gif")] public static var CyanGIF:Class;
		[Embed(source="../../assets/block-green.gif")] public static var GreenGIF:Class;
		[Embed(source="../../assets/block-magenta.gif")] public static var MagentaGIF:Class;
		[Embed(source="../../assets/block-red.gif")] public static var RedGIF:Class;
		[Embed(source="../../assets/block-yellow.gif")] public static var YellowGIF:Class;
		
		public static const HEIGHT:Number = 16;
		public static const WIDTH:Number = 16;
		public static const UNIQUE_BLOCKS:uint = 6;
		
		public static const INACTIVE:uint = 0;
		public static const ACTIVE:uint = 1;
		public static const MATCHED:uint = 2;
		public static const GARBAGE:uint = 3;
		
		private static var graphicLookup:Dictionary;
		
		private var _type:uint;
		private var _state:uint;
		private var _wasMoved:Boolean;
		
		//private var _position:uint;
		private var _row:uint = 0;
		private var _column:uint = 0;
		
		/**
		 * Trying to design Blocks to involve as little code/action as possible.
		 * Most of the action should come from Board, etc. 
		 * 
		 */		
		public function Block(color:uint, X:Number=0, Y:Number=0)
		{
			super(X, Y, graphicLookup[color]);
			this.type = color;
			this.state = Block.INACTIVE;
			this.wasMoved = true;
		}
		
		/**
		 * Required for looking up the graphic assets of the blocks. This must be run
		 * before creating blocks or there won't be any graphics! 
		 * 
		 * 
		 */		
		public static function initDictionary():void
		{
			graphicLookup = new Dictionary();
			graphicLookup[Colors.BLUE] = BlueGIF;
			graphicLookup[Colors.CYAN] = CyanGIF;
			graphicLookup[Colors.MAGENTA] = MagentaGIF;
			graphicLookup[Colors.GREEN] = GreenGIF;
			graphicLookup[Colors.RED] = RedGIF;
			graphicLookup[Colors.YELLOW] = YellowGIF;
		}

		public function get state():uint
		{
			return _state;
		}

		public function set state(value:uint):void
		{
			_state = value;
		}

		public function get type():uint
		{
			return _type;
		}

		public function set type(value:uint):void
		{
			_type = value;
		}
		
		public function equals(o:Object):Boolean
		{
			if(o is Block
				&& this.type == Block(o).type
				&& this.state == Block(o).state)
			{
				return true;
			}
			return false;
		}
		
		/**
		 * Called when a block is matched. Handle fancy graphics and stuff. 
		 * @return 
		 * 
		 */		
		public function match()
		{
			this.state = Block.MATCHED;
			this.flicker(2.5);
		}

		public function get wasMoved():Boolean
		{
			return _wasMoved;
		}

		public function set wasMoved(value:Boolean):void
		{
			_wasMoved = value;
		}

		public function get column():uint
		{
			return _column;
		}

		public function set column(value:uint):void
		{
			_column = value;
		}

		public function get row():uint
		{
			return _row;
		}

		public function set row(value:uint):void
		{
			_row = value;
		}


	}
}

class Colors
{
	public static const BLUE:uint = 0;
	public static const CYAN:uint = 1;
	public static const GREEN:uint = 2;
	public static const MAGENTA:uint = 3;
	public static const RED:uint = 4;
	public static const YELLOW:uint = 5;
}