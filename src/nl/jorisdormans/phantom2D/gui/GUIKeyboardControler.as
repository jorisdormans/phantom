package nl.jorisdormans.phantom2D.gui 
{
	import nl.jorisdormans.phantom2D.core.Component;
	import nl.jorisdormans.phantom2D.core.Composite;
	import nl.jorisdormans.phantom2D.core.InputState;
	import nl.jorisdormans.phantom2D.core.Phantom;
	import nl.jorisdormans.phantom2D.objects.GameObject;
	import nl.jorisdormans.phantom2D.objects.IInputHandler;
	import nl.jorisdormans.phantom2D.objects.ObjectLayer;
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class GUIKeyboardControler extends Component implements IInputHandler
	{
		public static const UP_DOWN:String = "up-down";
		public static const LEFT_RIGHT:String = "left-right";
		private var objectLayer:ObjectLayer;
		private var focusedObject:int;
		public var orientation:String;
		
		public function GUIKeyboardControler(orientation:String = UP_DOWN) 
		{
			focusedObject = -1;
			this.orientation = orientation;
		}
		
		override public function onAdd(composite:Composite):void 
		{
			super.onAdd(composite);
			objectLayer = composite as ObjectLayer;
		}
		
		public function selectFirst():void {
			focusedObject = -1;
			changeFocus(1);
		}
		
		private function changeFocus(delta:int):void {
			var previousFocus:int = focusedObject;
			//TODO: this might go into an infinite loop when previousFocus = -1 and there are no KeyboardControlled Buttons in the layer
			while (true) {
				//change the object to focus on
				focusedObject += delta;
				if (focusedObject < 0) focusedObject = objectLayer.objects.length - 1;
				if (focusedObject >= objectLayer.objects.length) focusedObject = 0;
				
				//did I go full circle? than break
				if (focusedObject == previousFocus) {
					break;
				}
				
				//can I focus on this object, than change focus
				if (objectLayer.objects[focusedObject].sendMessage(GUIKeyboardHandler.M_FOCUS) == Phantom.MESSAGE_CONSUMED) {
					if (previousFocus >= 0) {
						objectLayer.objects[previousFocus].sendMessage(GUIKeyboardHandler.M_BLUR)
					}
					break;
				}
			}
		}
		
		/* INTERFACE nl.jorisdormans.phantom2D.objects.IInputHandler */
		
		public function handleInput(elapsedTime:Number, currentState:InputState, previousState:InputState):void 
		{
			switch (orientation) {
				case UP_DOWN:
					if (currentState.arrowDown && !previousState.arrowDown) {
						changeFocus(1);
					}
					if (currentState.arrowUp && !previousState.arrowUp) {
						changeFocus(-1);
					}
					break;
				case LEFT_RIGHT:
					if (currentState.arrowRight && !previousState.arrowRight) {
						changeFocus(1);
					}
					if (currentState.arrowLeft && !previousState.arrowLeft) {
						changeFocus(-1);
					}
					break;
			}
		}
		
	}

}