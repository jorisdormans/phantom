package nl.jorisdormans.phantom2D.gui 
{
	import flash.geom.Vector3D;
	import nl.jorisdormans.phantom2D.core.Component;
	import nl.jorisdormans.phantom2D.core.Composite;
	import nl.jorisdormans.phantom2D.core.InputState;
	import nl.jorisdormans.phantom2D.objects.GameObject;
	import nl.jorisdormans.phantom2D.objects.IInputHandler;
	import nl.jorisdormans.phantom2D.objects.ObjectLayer;
	
	/**
	 * ...
	 * @author R. van Swieten
	 */
	public class DragController extends Component implements IInputHandler
	{
		private var objectLayer:ObjectLayer;
		private var draggedObject:GameObject;
		private var mouseDownLoc:Vector3D;
		private var mouseOffSetX:Number;
		private var mouseOffSetY:Number;
		
		public function DragController() 
		{
			
		}
		
		/* INTERFACE nl.jorisdormans.phantom2D.objects.IInputHandler */
		
		public function handleInput(elapsedTime:Number, currentState:InputState, previousState:InputState):void 
		{
			var mouseX:Number = objectLayer.gameScreen.camera.left + currentState.mouseX;
			var mouseY:Number = objectLayer.gameScreen.camera.top + currentState.mouseY;
			
			if (currentState.mouseButton && !previousState.mouseButton) {
				mouseDownLoc = new Vector3D(mouseX, mouseY);
				draggedObject = objectLayer.getObjectAt(mouseDownLoc);
				
				if(draggedObject) {
					draggedObject.sendMessage("startDrag");
				
					mouseOffSetX = draggedObject.shape.position.x - mouseX;
					mouseOffSetY = draggedObject.shape.position.y - mouseY;
				}
			}
			
			if (!currentState.mouseButton && previousState.mouseButton && draggedObject) {
				draggedObject.sendMessage("stopDrag");
				draggedObject = null;
			}
			
			if (draggedObject) {
				
				if (draggedObject.mover) {
					var dx:Number = mouseOffSetX + mouseX - draggedObject.shape.position.x;
					var dy:Number = mouseOffSetY + mouseY - draggedObject.shape.position.y;
					if (dx!=0 ||dy!=0) {
						draggedObject.mover.velocity.x = dx / elapsedTime;
						draggedObject.mover.velocity.y = dy / elapsedTime;
					}
				}
				
				draggedObject.shape.position.x = mouseX + mouseOffSetX;
				draggedObject.shape.position.y = mouseY + mouseOffSetY;
				draggedObject.placeOnTile();
				draggedObject.sendMessage("dragTo", { x: mouseX, y: mouseY } );
			}
		}
		
		
		override public function onAdd(composite:Composite):void 
		{
			super.onAdd(composite);
			objectLayer = composite as ObjectLayer;
			if (!objectLayer) {
				throw new Error("DragController added to Composite that is not an ObjectLayer");
			}
		}
	}

}