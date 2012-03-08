package nl.jorisdormans.phantom2D.cameraComponents 
{
	import nl.jorisdormans.phantom2D.core.Camera;
	import nl.jorisdormans.phantom2D.core.Component;
	import nl.jorisdormans.phantom2D.core.Composite;
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class CameraComponent extends Component
	{
		protected var camera:Camera
		
		public function CameraComponent() 
		{
			
		}
		override public function onAdd(composite:Composite):void 
		{
			super.onAdd(composite);
			camera = composite as Camera;
			if (!camera) {
				throw new Error(this + " cannot be added to a non-camera object.");
			}
		}
		
	}

}