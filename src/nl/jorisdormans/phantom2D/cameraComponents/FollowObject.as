package nl.jorisdormans.phantom2D.cameraComponents 
{
	import nl.jorisdormans.phantom2D.core.Phantom;
	import nl.jorisdormans.phantom2D.objects.GameObject;
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class FollowObject extends CameraComponent
	{
		public var following:GameObject;
		
		public static const M_FOLLOW_OBJECT:String = "followObject";
		public static const M_STOP_FOLLOWING:String = "stopFollowing";
		
		public function FollowObject(following:GameObject) 
		{
			this.following = following;
		}
		
		override public function onRemove():void 
		{
			following = null;
			super.onRemove();
		}
		
		override public function update(elapsedTime:Number):void 
		{
			super.update(elapsedTime);
			if (following) {
				camera.target.x = following.position.x;
				camera.target.y = following.position.y;
				camera.target.z = following.position.z;
			}
		}
		
		override public function handleMessage(message:String, data:Object = null):int 
		{
			switch (message) {
				case M_FOLLOW_OBJECT:
					following = data.followObject;
					return Phantom.MESSAGE_CONSUMED;
				case M_STOP_FOLLOWING:
					following = null;
					return Phantom.MESSAGE_CONSUMED;
			}
			return super.handleMessage(message, data);
		}
		
	}

}