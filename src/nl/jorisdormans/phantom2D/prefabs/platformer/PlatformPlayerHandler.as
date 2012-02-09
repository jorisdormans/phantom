package nl.jorisdormans.phantom2D.prefabs.platformer 
{
	import nl.jorisdormans.phantom2D.core.Component;
	import nl.jorisdormans.phantom2D.core.InputState;
	import nl.jorisdormans.phantom2D.objects.GameObject;
	import nl.jorisdormans.phantom2D.objects.IInputHandler;
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class PlatformPlayerHandler extends Component implements IInputHandler 
	{
		
		public function PlatformPlayerHandler() 
		{
			
		}
		
		public function handleInput(elapsedTime:Number, currentState:InputState, previousState:InputState):void {
			if (!gameObject || !gameObject.layer) return;
			var pm:PlatformerMover = (gameObject.mover as PlatformerMover);
			var ah:AnimatedHumanoid = gameObject.getComponentByClass(AnimatedHumanoid) as AnimatedHumanoid;
			pm.accelerating = false;
			if (currentState.arrowLeft) {
				pm.move(elapsedTime, -1);
				ah.doRun(elapsedTime, -1, pm.onFloor, pm.onLadder);
			}
			if (currentState.arrowRight) {
				pm.move(elapsedTime, 1);
				ah.doRun(elapsedTime, 1, pm.onFloor, pm.onLadder);
			}
			
			if (currentState.keySpace && !previousState.keySpace) {
				pm.jump();
			}			
			if (currentState.arrowUp && pm.onLadder) {
				pm.climbLadder(elapsedTime, -1);
				ah.doClimb(elapsedTime, -1);
			}			
			if (currentState.arrowDown) {
				if (pm.onLadder) {
					pm.climbLadder(elapsedTime, 1);
					ah.doClimb(elapsedTime, 1);
				} else if (pm.onZSlope) {
					//pm.accelerating = true; //obsolete when sliding is automatic
					pm.dropDown();
				} else {
					pm.dropDown();
				}
			}			
			
			if (pm.onLadder) {
				ah.doClimb(elapsedTime, 0);
			} else if (pm.onZSlope || pm.onSlope) {
				ah.doBalance(elapsedTime);
				if (pm.velocity.y > 10) ah.doSlide(elapsedTime);
			} else if (!pm.onFloor) {
				ah.doFall(elapsedTime);
			}
		}
		
	}

}