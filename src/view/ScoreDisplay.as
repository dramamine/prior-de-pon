package view
{
	import com.greensock.TweenLite;
	
	import model.Block;
	import model.ScoreManager;
	
	import org.flixel.FlxGroup;
	import org.flixel.FlxPoint;
	import org.flixel.FlxText;
	
	public class ScoreDisplay extends FlxGroup
	{
		private var scores:ScoreManager;
		private var scoreBox:FlxText;
		
		private static const origin:FlxPoint = new FlxPoint(50,50);

		public function ScoreDisplay(scores:ScoreManager)
		{
			super();
			
			scores.useView(this);
			
			scoreBox = new FlxText(280, 50, 40);
			add(scoreBox);
			updateScore(0);
						
		} 
		
		/**
		 * Displays the chain count. I think this can go pretty high, maybe ~30. 
		 * @param chain
		 * @return 
		 * 
		 */
		public function displayChain(chain:int)
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
		public function displayCombo(combo:int)
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
		
		
		public function updateScore(score:int)
		{
			scoreBox.text = padString( score.toString(), "0", 6 );
		}
		
		private static function padString(string:String, padChar:String, finalLength:int, padLeft:Boolean = true):String {
			
			while (string.length < finalLength) {
				
				string = padLeft ? padChar + string : string + padChar;
				
			}
			
			return string;
		}	
	}
}