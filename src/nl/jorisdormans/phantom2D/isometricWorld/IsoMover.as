package nl.jorisdormans.phantom2D.isometricWorld 
{
	import flash.geom.Vector3D;
	import nl.jorisdormans.phantom2D.objects.Mover;
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class IsoMover extends Mover
	{
		protected var gravityZ:Number = 900;
		protected var frictionZ:Number = 0.1;
		
		public function IsoMover(velocity:Vector3D, friction:Number = 2, bounceRestitution:Number = 1, initiateCollisionCheck:Boolean = true) 
		{
			super(velocity, friction, bounceRestitution, initiateCollisionCheck);
		}
		
		override public function updatePhysics(elapsedTime:Number):void 
		{
			//apply gravity
			velocity.z -= gravityZ * elapsedTime;
			
			//update position
			gameObject.shape.position.x += elapsedTime * velocity.x;
			gameObject.shape.position.y += elapsedTime * velocity.y;
			gameObject.shape.position.z += elapsedTime * velocity.z;
			
			//update velocity
			var f:Number = 1 - 2 * friction * friction * elapsedTime;
			velocity.x *= f;
			velocity.y *= f;
			f = 1 - 2 * frictionZ * frictionZ * elapsedTime;
			velocity.z *= f;
			
			//update tile position
			gameObject.placeOnTile();			
			
			if (gameObject.shape.position.z < 0) {
				gameObject.shape.position.z = 0;
				velocity.z = 0;
			}
		}
		
		
		
	}

}