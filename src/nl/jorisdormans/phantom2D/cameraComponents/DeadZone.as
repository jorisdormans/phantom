package nl.jorisdormans.phantom2D.cameraComponents 
{
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class DeadZone extends CameraComponent
	{
		private var width:Number
		private var height:Number
		
		public function DeadZone(width:Number, height:Number) 
		{
			this.width = width * 0.5;
			this.height = height * 0.5;
		}
		
		override public function update(elapsedTime:Number):void 
		{
			super.update(elapsedTime);
			if (Math.abs(camera.target.x - camera.position.x) <= width) {
				camera.target.x = camera.position.x;
			}
			if (Math.abs(camera.target.y - camera.position.y) <= height) {
				camera.target.y = camera.position.y;
			}
		}
	}

}