package nl.jorisdormans.phantom2D.prefabs.items 
{
	import flash.geom.Vector3D;
	import nl.jorisdormans.phantom2D.objects.GameObject;
	import nl.jorisdormans.phantom2D.objects.GameObjectComponent;
	import nl.jorisdormans.phantom2D.objects.Handler;
	import nl.jorisdormans.phantom2D.objects.ObjectLayer;
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class PowerUpHandler extends Handler
	{
		private var data:Object;
		private var message:String;
		
		public function PowerUpHandler(message:String, data:Object) 
		{
			this.message = message;
			this.data = data;
		}
		
		override public function afterCollisionWith(other:GameObject):void 
		{
			if (other.handleMessage(message, 0, data) > GameObjectComponent.MESSAGE_NOT_HANDLED) {
				gameObject.destroyed = true;
			}
			super.afterCollisionWith(other);
		}
		
	}

}