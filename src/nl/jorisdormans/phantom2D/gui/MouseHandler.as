package nl.jorisdormans.phantom2D.gui 
{
	import flash.geom.Vector3D;
	import nl.jorisdormans.phantom2D.core.Component;
	import nl.jorisdormans.phantom2D.core.InputState;
	import nl.jorisdormans.phantom2D.core.Phantom;
	import nl.jorisdormans.phantom2D.objects.IInputHandler;
	
	/**
	 * ...
	 * @author M. Dijkstra
	 */
	public class MouseHandler extends Component implements IInputHandler 
	{
		
		public static const E_ONOVER:String = "onOver";
		public static const E_ONOUT:String = "onOut";
		public static const E_ONPRESS:String = "onPress";
		public static const E_ONRELEASE:String = "onRelease";
		
		private var mouseLoc:Vector3D;
		private var oldMouseLoc:Vector3D;
		private var mouseOver:Boolean;
		private var oldMouseOver:Boolean;
		
		private var mouseHover:Boolean;
		private var mouseDown:Boolean;
		private var mouseDownOutside:Boolean;
		
		public function MouseHandler() 
		{
			
		}
				
		public function handleInput(elapsedTime:Number, currentState:InputState, previousState:InputState):void 
		{
			mouseLoc = new Vector3D(this.gameObject.layer.gameScreen.camera.left + currentState.mouseX, this.gameObject.layer.gameScreen.camera.left + currentState.mouseY);
			oldMouseLoc = new Vector3D(this.gameObject.layer.gameScreen.camera.left + previousState.mouseX, this.gameObject.layer.gameScreen.camera.left + previousState.mouseY);
			
			mouseOver = this.gameObject.shape.pointInShape(mouseLoc);
			oldMouseOver = this.gameObject.shape.pointInShape(oldMouseLoc);
			
			if (mouseOver && !mouseHover) {
				parent.sendMessage(E_ONOVER);
				mouseHover = true;
			}
			if (!mouseOver && oldMouseOver) {
				parent.sendMessage(E_ONOUT);
				mouseHover = false;
			}
			
			if (currentState.mouseButton && !mouseDown && !mouseDownOutside) {
				if(mouseHover && !mouseDownOutside){
					mouseDown = true;
					parent.sendMessage(E_ONPRESS);
				} else {
					mouseDownOutside = true;
				}
			}
			if (previousState.mouseButton && !currentState.mouseButton) {
				if (mouseHover && mouseDown) {
					parent.sendMessage(E_ONRELEASE);
				}
				mouseDown = false;
				mouseDownOutside = false;
			}
		}
		
		override public function handleMessage(message:String, data:Object = null):int 
		{
			switch (message) {
				case E_ONPRESS:
					//focus = true;
					return Phantom.MESSAGE_CONSUMED;
				case E_ONRELEASE:
					//focus = false;
					return Phantom.MESSAGE_CONSUMED;
				case E_ONOUT:
					//focus = !_focus;
					return Phantom.MESSAGE_CONSUMED;
				case E_ONOVER:
					//focus = true;
					return Phantom.MESSAGE_CONSUMED;
			}
			return super.handleMessage(message, data);
		}
	}

}