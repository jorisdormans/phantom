package nl.jorisdormans.phantom2D.prefabs.platformer
{
	import nl.jorisdormans.phantom2D.objects.GameObject;
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class ProtoPlatform extends GameObject
	{
		public var friction:Number;
		public var grip:Number;
		
		
		public function ProtoPlatform(grip:Number = 3, friction:Number = 0) 
		{
			this.grip = grip;
			this.friction = friction;
		}
		
	}

}