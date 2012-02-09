package nl.jorisdormans.phantom2D.prefabs.adventure 
{
	import flash.geom.Vector3D;
	import nl.jorisdormans.phantom2D.core.Component;
	import nl.jorisdormans.phantom2D.core.InputState;
	import nl.jorisdormans.phantom2D.isometricWorld.IsoObjectLayer;
	import nl.jorisdormans.phantom2D.objects.IInputHandler;
	import nl.jorisdormans.phantom2D.util.MathUtil;
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class IsoAdventurePlayerHandler extends Component implements IInputHandler
	{
		private var moveDiagonal:Number;
		
		private var directions:Vector.<Number>;
		public function IsoAdventurePlayerHandler() 
		{
			moveDiagonal = Math.cos(Math.PI * 0.25);
			directions = new Vector.<Number>();
			directions.push(1, 0, moveDiagonal, moveDiagonal, 0, 1, -moveDiagonal, moveDiagonal, -1, 0, -moveDiagonal, -moveDiagonal, 0, -1, moveDiagonal, -moveDiagonal);
		}
		
		
		public function handleInput(elapsedTime:Number, currentState:InputState, previousState:InputState):void 
		{
			var adventureMover:IsoAdventureMover = gameObject.mover as IsoAdventureMover;
			if (!adventureMover) {
				throw new Error("A GameObject with an AdventurePlayerHandler component also requires an AdventureMover as its mover.");
			}
			adventureMover.moveX = 0;
			adventureMover.moveY = 0;
			if (currentState.arrowLeft) adventureMover.moveX -= 1;
			if (currentState.arrowRight) adventureMover.moveX += 1;
			if (currentState.arrowUp) adventureMover.moveY -= 1;
			if (currentState.arrowDown) adventureMover.moveY += 1;
			if (adventureMover.moveX != 0 || adventureMover.moveY != 0) {
				var a:Number = Math.atan2(adventureMover.moveY, adventureMover.moveX) - (gameObject.layer as IsoObjectLayer).getCameraYaw();
				//a = (a / MathUtil.TWO_PI) * 8 + Math.PI * 0.125;
				a = (a / MathUtil.TWO_PI) * 8;
				a = Math.round(a);
				a = (a + 8) % 8;
				adventureMover.moveX = directions[a * 2];
				adventureMover.moveY = directions[a * 2 + 1];
			}
			
			
			if (!(adventureMover.moveX == 0 && adventureMover.moveY == 0)) {
				a = Math.atan2(adventureMover.moveY, adventureMover.moveX);
				//gameObject.shape.setOrientation(a);
			}
			
			if (currentState.keySpace && !previousState.keySpace) {
				gameObject.sendMessage("action");
				adventureMover.jump();
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