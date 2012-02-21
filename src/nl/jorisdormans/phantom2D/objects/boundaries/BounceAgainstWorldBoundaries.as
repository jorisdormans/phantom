package nl.jorisdormans.phantom2D.objects.boundaries
{
	import nl.jorisdormans.phantom2D.core.Component;
	/**
	 * A GameObjectComponent that causes the game object to bounce off the edges of its layer
	 * @author Joris Dormans
	 */
	public class BounceAgainstWorldBoundaries extends Component
	{
		private var bounceRestitution:Number;
		private var threshold:Number;
		private var left:Boolean;
		private var right:Boolean;
		private var up:Boolean;
		private var down:Boolean;
		
		
		public function BounceAgainstWorldBoundaries(threshold:Number = 0, bounceRestitution:Number = 0, left:Boolean = true, right:Boolean = true, up:Boolean = true, down:Boolean = true) 
		{
			this.bounceRestitution = -bounceRestitution;
			this.threshold = threshold;
			this.left = left;
			this.right = right;
			this.up = up;
			this.down = down;
		}
		
		override public function updatePhysics(elapsedTime:Number):void 
		{
			super.updatePhysics(elapsedTime);
			if (left && gameObject.position.x - threshold < 0) {
				gameObject.position.x = threshold;
				if (gameObject.mover.velocity.x < 0) gameObject.mover.velocity.x *= bounceRestitution;
			}
			if (right && gameObject.position.x + threshold > gameObject.layer.layerWidth) {
				gameObject.position.x = gameObject.layer.layerWidth - threshold;
				if (gameObject.mover.velocity.x > 0) gameObject.mover.velocity.x *= bounceRestitution;
			}
			if (up && gameObject.position.y - threshold < 0) {
				gameObject.position.y = threshold;
				if (gameObject.mover.velocity.y < 0) gameObject.mover.velocity.y *= bounceRestitution;
			}
			if (down && gameObject.position.y + threshold> gameObject.layer.layerHeight) {
				gameObject.position.y = gameObject.layer.layerHeight - threshold;
				if (gameObject.mover.velocity.y > 0) gameObject.mover.velocity.y *= bounceRestitution;
			}			
		}
		
	}

}