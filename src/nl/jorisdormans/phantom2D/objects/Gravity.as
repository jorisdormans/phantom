package nl.jorisdormans.phantom2D.objects 
{
	import flash.geom.Vector3D;
	import nl.jorisdormans.phantom2D.core.Component;
	import nl.jorisdormans.phantom2D.core.Composite;
	
	/**
	 * ...
	 * @author R. van Swieten
	 */
	public class Gravity extends Component 
	{
		private var gravity:Vector3D;
		public var applyGravity:Boolean = true;
		
		public function Gravity(gravity:Vector3D) 
		{
			this.gravity = gravity;
		}
		
		override public function updatePhysics(elapsedTime:Number):void 
		{
			super.updatePhysics(elapsedTime);
			if (this.gameObject.mover && this.gameObject.mover.applyMovement && this.applyGravity) {
				this.gameObject.mover.velocity.x += gravity.x * elapsedTime;
				this.gameObject.mover.velocity.y += gravity.y * elapsedTime;
			}
		}
		
	}

}