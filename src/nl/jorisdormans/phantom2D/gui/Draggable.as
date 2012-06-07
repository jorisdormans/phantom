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
		static public const M_START_DRAG:String = "startDrag";
		static public const M_DRAG_TO:String = "dragTo";
		static public const M_STOP_DRAG:String = "stopDrag";
		
		public function Draggable() 
		{
			super();	
			velocityEndWeight = 0.9;
		}
		
		override public function handleMessage(message:String, data:Object = null):int 
		{
			switch(message) {
				case M_START_DRAG:
					this.gameObject.doResponse = false;
					if(this.gameObject.mover){
						this.gameObject.mover.applyMovement = false;
					}
					break;
				case M_DRAG_TO:
					if (data && data.x && data.y) {
						if (this.gameObject.mover) {
							var dx:Number = data.x - this.gameObject.position.x;
							var dy:Number = data.y - this.gameObject.position.y;
							//if (dx!=0 || dy!=0) {
								var f:Number = 1 - velocityEndWeight;
								this.gameObject.mover.velocity.x = this.gameObject.mover.velocity.x * velocityEndWeight + f * (dx / data.elapsedTime);
								this.gameObject.mover.velocity.y = this.gameObject.mover.velocity.y * velocityEndWeight + f * (dy / data.elapsedTime);
							//}
						}
						
						this.gameObject.position.x = data.x;
						this.gameObject.position.y = data.y;
					}
					break;
				case M_STOP_DRAG:
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