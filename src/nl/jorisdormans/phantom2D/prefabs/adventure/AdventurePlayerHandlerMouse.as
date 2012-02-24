package nl.jorisdormans.phantom2D.prefabs.adventure 
{
	import nl.jorisdormans.phantom2D.core.Component;
	import nl.jorisdormans.phantom2D.core.InputState;
	import nl.jorisdormans.phantom2D.objects.IInputHandler;
	import nl.jorisdormans.phantom2D.prefabs.items.Hands;
	import nl.jorisdormans.phantom2D.prefabs.items.Inventory;
	import nl.jorisdormans.phantom2D.prefabs.items.Item;
	import nl.jorisdormans.phantom2D.util.MathUtil;
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class AdventurePlayerHandlerMouse extends Component implements IInputHandler
	{
		private var usingItem:Item;
		
		public function AdventurePlayerHandlerMouse() 
		{
			
		}
		
		public function handleInput(elapsedTime:Number, currentState:InputState, previousState:InputState):void 
		{
			var adventureMover:AdventureMover = gameObject.mover as AdventureMover;
			if (!adventureMover) {
				throw new Error("A GameObject with an AdventurePlayerHandlerMouse component also requires an AdventureMover as its mover.");
			}
			
			var inventory:Inventory = gameObject.getComponentByClass(Inventory) as Inventory;
			var doMouse:Boolean = true;
			if (inventory && inventory.visible) {
				doMouse = !inventory.handleInputMouse(elapsedTime, currentState, previousState);
			}
			
			if (doMouse) {
				if (currentState.mouseButton && !previousState.mouseButton) {
					var hands:Hands = gameObject.getComponentByClass(Hands) as Hands;
					if (hands) {
						usingItem = hands.useItem(0);
						if (!usingItem) {
							usingItem = hands.useItem(1);
						}
					}
				}
				if (!currentState.mouseButton && previousState.mouseButton) {
					if (usingItem) {
						usingItem.endUseItem(gameObject);
					}
				}
			}
			
			adventureMover.moveX = 0;
			adventureMover.moveY = 0;
			
			var dx:Number = currentState.mouseX - (gameObject.position.x - gameObject.layer.gameScreen.camera.left);
			var dy:Number = currentState.mouseY - (gameObject.position.y - gameObject.layer.gameScreen.camera.top);
			if (adventureMover.spinning==0) {
				var a:Number = Math.atan2(dy, dx);
				adventureMover.wantOrientation = a;
				
			}
			
			if (currentState.keySpace) {
				var d:Number = Math.sqrt(dx * dx + dy * dy);
				
				if (d > 10) {
					dx /= d;
					dy /= d;
					
					var dot:Number = dx * gameObject.shape.orientationVector.x + dy * gameObject.shape.orientationVector.y;
					if (dot>=0 || Math.abs(a)<0.1) {
						adventureMover.moveX = dx;
						adventureMover.moveY = dy;
					} else {
						adventureMover.moveX = 0;
						adventureMover.moveY = 0;
						
					}
					
				}
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