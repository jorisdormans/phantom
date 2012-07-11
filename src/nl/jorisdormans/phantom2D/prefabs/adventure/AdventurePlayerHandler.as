package nl.jorisdormans.phantom2D.prefabs.adventure 
{
	import nl.jorisdormans.phantom2D.core.InputState;
	import nl.jorisdormans.phantom2D.objects.Component;
	import nl.jorisdormans.phantom2D.objects.IInputHandler;
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class AdventurePlayerHandler extends Component implements IInputHandler
	{
		private var moveDiagonal:Number;
		
		public function AdventurePlayerHandler() 
		{
			moveDiagonal = Math.cos(Math.PI * 0.25);
		}
		
		public function handleInput(elapsedTime:Number, currentState:InputState, previousState:InputState):void 
		{
			var adventureMover:AdventureMover = gameObject.mover as AdventureMover;
			if (!adventureMover) {
				throw new Error("A GameObject with an AdventurePlayerHandler component also requires an AdventureMover as its mover.");
			}
			adventureMover.moveX = 0;
			adventureMover.moveY = 0;
			if (currentState.arrowLeft) adventureMover.moveX -= 1;
			if (currentState.arrowRight) adventureMover.moveX += 1;
			if (currentState.arrowUp) adventureMover.moveY -= 1;
			if (currentState.arrowDown) adventureMover.moveY += 1;
			if (adventureMover.moveX != 0 && adventureMover.moveY != 0) {
				adventureMover.moveX *= moveDiagonal;
				adventureMover.moveY *= moveDiagonal;
			}
			if (!(adventureMover.moveX == 0 && adventureMover.moveY == 0)) {
				var a:Number = Math.atan2(adventureMover.moveY, adventureMover.moveX);
				gameObject.shape.setOrientation(a);
			}
			
			if (currentState.keySpace && !previousState.keySpace) {
				gameObject.sendMessage("action");
			}
		}
		
		override public function onRemove():void 
		{
			var adventureMover:AdventureMover = gameObject.mover as AdventureMover;
			if (adventureMover) {
				adventureMover.moveX = 0;
				adventureMover.moveY = 0;
			}
		}
		
	}

}