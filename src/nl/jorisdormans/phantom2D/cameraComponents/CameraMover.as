package nl.jorisdormans.phantom2D.cameraComponents 
{
	import nl.jorisdormans.phantom2D.core.Camera;
	import nl.jorisdormans.phantom2D.core.Component;
	import nl.jorisdormans.phantom2D.core.Composite;
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class CameraMover extends CameraComponent
	{
		
		
		
		public function CameraMover() 
		{
			
		}
		
		override public function update(elapsedTime:Number):void 
		{
			camera.position.x = camera.target.x;
			camera.position.y = camera.target.y;
		}
		
	}

}