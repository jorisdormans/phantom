package nl.jorisdormans.phantom2D.layers 
{
	import flash.display.Bitmap;
	import nl.jorisdormans.phantom2D.core.Layer;
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class BackgroundImage extends Layer
	{
		
		public function BackgroundImage(image:Class) 
		{
			super();
			var bitmap:Bitmap = new image();
			sprite.addChild(bitmap);
		}
		
	}

}