package nl.jorisdormans.phantom2D.gui 
{
	import nl.jorisdormans.phantom2D.core.Component;
	
	/**
	 * ...
	 * @author R. van Swieten
	 */
	public class Draggable extends Component 
	{
		
		public function Draggable() 
		{
			super();	
		}
		
		override public function handleMessage(message:String, data:Object = null):int 
		{
			switch(message) {
				case "startDrag":
					this.gameObject.doResponse = false;
					if(this.gameObject.mover){
						this.gameObject.mover.applyMovement = false;
					}
					break;
				case "dragTo":
					if (data && data.x && data.y) {
						if (this.gameObject.mover) {
							var dx:Number = data.x - this.gameObject.shape.position.x;
							var dy:Number = data.y - this.gameObject.shape.position.y;
							if (dx!=0 || dy!=0) {
								this.gameObject.mover.velocity.x = dx / data.elapsedTime;
								this.gameObject.mover.velocity.y = dy / data.elapsedTime;
							}
						}
						
						this.gameObject.shape.position.x = data.x;
						this.gameObject.shape.position.y = data.y;
						this.gameObject.placeOnTile();
					}
					break;
				case "stopDrag":
					this.gameObject.doResponse = true;
					if(this.gameObject.mover){
						this.gameObject.mover.applyMovement = true;
					}
					break;
			}
			return super.handleMessage(message, data);
		}
		
	}

}