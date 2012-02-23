package nl.jorisdormans.phantom2D.gui 
{
	import nl.jorisdormans.phantom2D.core.Component;
	
	/**
	 * ...
	 * @author R. van Swieten
	 */
	public class Draggable extends Component 
	{
		public var velocityEndWeight:Number;
		
		public function Draggable() 
		{
			super();	
			velocityEndWeight = 0.9;
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
							var dx:Number = data.x - this.gameObject.position.x;
							var dy:Number = data.y - this.gameObject.position.y;
							if (dx!=0 || dy!=0) {
								var f:Number = 1 - velocityEndWeight;
								this.gameObject.mover.velocity.x = this.gameObject.mover.velocity.x * velocityEndWeight + f * (dx / data.elapsedTime);
								this.gameObject.mover.velocity.y = this.gameObject.mover.velocity.y * velocityEndWeight + f * (dy / data.elapsedTime);
							}
						}
						
						this.gameObject.position.x = data.x;
						this.gameObject.position.y = data.y;
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