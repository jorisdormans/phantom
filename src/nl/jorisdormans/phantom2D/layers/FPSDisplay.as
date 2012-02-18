package nl.jorisdormans.phantom2D.layers 
{
	import flash.text.TextField;
	import flash.text.TextFormat;
	import nl.jorisdormans.phantom2D.core.Layer;
	import nl.jorisdormans.phantom2D.core.PhantomGame;
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class FPSDisplay extends Layer
	{
		private var textField:TextField;
		
		public function FPSDisplay(color:uint=0xffffff, font:String = "Arial", size:int = 12) 
		{
			super();
			textField = new TextField();
			textField.defaultTextFormat = new TextFormat(font, size, color);
			textField.text = "fps";
			sprite.addChild(textField);
		}
		
		override public function update(elapsedTime:Number):void 
		{
			super.update(elapsedTime);
			textField.text = "fps: " + PhantomGame.fps;
		}
		
	}

}