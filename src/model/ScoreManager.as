package model
{
	import com.greensock.TweenLite;
	
	import flash.globalization.NumberFormatter;
	
	import org.flixel.FlxBasic;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxText;
	
	import view.ScoreDisplay;
	
	public class ScoreManager extends FlxGroup
	{
		private var _score:int;

		private var scoreBox:FlxText;
		
		private var _view:ScoreDisplay;
		
		public function ScoreManager()
		{
			super();
			
			scoreBox = new FlxText(280, 50, 40);
			add(scoreBox);
			
			this.score = 0;
			//FlxG.state.add(scoreBox);
		}
		
		/**
		 * For notifying the view of changes. Had to use this instead of events
		 * due to Flixel restrictions. 
		 * @param display: the display to use.
		 * @return 
		 * 
		 */
		public function useView(view:ScoreDisplay)
		{
			this._view = view;
		}
		
		public function tally(blocks:Vector.<Block>, chain:int):void
		{

			if(chain > 1) _view.displayChain(chain);
			if(blocks.length > 3) _view.displayCombo(blocks.length);
			
			score += Math.floor(
				50 * blocks.length * .333 // i.e. 3 blocks: 50 pts each, 6 blocks: 100 each.
				* chain
				* (1 + Board.LEVEL / 30) // i.e. your score at lvl 75 is 2x your score at 45 and 3x your score at 15
			);
			
			_view.updateScore(score);
		}
		
		/**
		 * Displays the chain count. I think this can go pretty high, maybe ~30. 
		 * @param chain
		 * @return 
		 * 
		 */
		private function displayChain(chain:int, origin:FlxPoint)
		{
			var chainBox:FlxText = new FlxText(origin.x, origin.y,
				25, "X" + chain.toString()
				);
			add(chainBox);
			TweenLite.to(chainBox, 1.5, {
				y: origin.y - Block.HEIGHT * 1.5,
				onComplete:function(){
					remove(chainBox);
					chainBox.kill();
				}
			});
			
		}
		
		/**
		 * Displays the combo score. I think this can go up to 14. 
		 * @param combo
		 * @return 
		 * 
		 */
		private function displayCombo(combo:int, origin:FlxPoint)
		{
			var comboBox:FlxText = new FlxText(origin.x, origin.y,
				25, combo.toString()
			);
			add(comboBox);
			TweenLite.to(comboBox, 1.5, {
				y: origin.y - Block.HEIGHT * 1.5,
				onComplete:function(){
					remove(comboBox);
					comboBox.kill();
				}
			});
		}

		public function get score():int
		{
			return _score;
		}

		public function set score(value:int):void
		{
			_score = value;
			
			
			scoreBox.text = padString( value.toString(), "0", 6 );
		}

		
		private static function padString(string:String, padChar:String, finalLength:int, padLeft:Boolean = true):String {
			
			while (string.length < finalLength) {
				
				string = padLeft ? padChar + string : string + padChar;
				
			}
			
			return string;
		}
	}
}