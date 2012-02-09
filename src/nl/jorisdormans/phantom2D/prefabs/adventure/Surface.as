package nl.jorisdormans.phantom2D.prefabs.adventure 
{
	import nl.jorisdormans.phantom2D.objects.GameObject;
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class Surface extends GameObject
	{
		public var friction:Number;
		public var message:String;
		
		public function Surface(friction:Number = 3, message:String = null) 
		{
			this.friction = friction;
			this.message = message;
		}
		
		override public function canCollideWith(other:GameObject):Boolean 
		{
			return true;
		}
		
	}

}