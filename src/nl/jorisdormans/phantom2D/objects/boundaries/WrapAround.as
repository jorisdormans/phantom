package nl.jorisdormans.phantom2D.objects.boundaries
{
	import nl.jorisdormans.phantom2D.core.Component;
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class WrapAround extends Component
	{
		private var threshold:Number;
		private var horizontal:Boolean;
		private var vertical:Boolean;
		
		public function WrapAround(horizontal:Boolean = true, vertical:Boolean = true, threshold:Number = 0) 
		{
			this.threshold = threshold;
			this.horizontal = horizontal;
			this.vertical = vertical;
		}
		
		override public function updatePhysics(elapsedTime:Number):void 
		{
			if (horizontal) {
				if (gameObject.shape.position.x < -threshold) {
					gameObject.shape.position.x += threshold * 2 + gameObject.layer.layerWidth;
					gameObject.placeOnTile();
				} else if (gameObject.shape.position.x > threshold + gameObject.layer.layerWidth) {
					gameObject.shape.position.x -= threshold * 2 + gameObject.layer.layerWidth;
					gameObject.placeOnTile();
				}
			}
			if (vertical) {
				if (gameObject.shape.position.y < -threshold) {
					gameObject.shape.position.y += threshold * 2 + gameObject.layer.layerHeight;
					gameObject.placeOnTile();
				} else if (gameObject.shape.position.y > threshold + gameObject.layer.layerHeight) {
					gameObject.shape.position.y -= threshold * 2 + gameObject.layer.layerHeight;
					gameObject.placeOnTile();
				}
			}
			
		}
		
	}

}