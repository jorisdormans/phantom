package nl.jorisdormans.phantom2D.tweening 
{
	import nl.jorisdormans.phantom2D.util.MathUtil;
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class TweenFunctions 
	{
		
		public function TweenFunctions() 
		{
			
		}
		
		public static function linear(value:Number):Number {
			return MathUtil.clamp(value, 0, 1);
		}
		
		public static function sine(value:Number):Number {
			return Math.cos(MathUtil.clamp(value, 0, 1)*Math.PI)*-0.5+0.5;
		}
		
		
	}

}