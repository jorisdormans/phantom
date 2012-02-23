package nl.jorisdormans.phantom2D.graphics 
{
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class Animation 
	{
		public var frames:Vector.<int>;
		public var fps:Number;
		
		public function Animation(fps:Number, frames:Vector.<int>) 
		{
			this.fps = fps;
			this.frames = frames;
		}
		
	}

}