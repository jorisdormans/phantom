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
		public static const E_ONBLUR:String = "onBlur";
		
		private var mouseLoc:Vector3D;
		private var oldMouseLoc:Vector3D;
		private var mouseOver:Boolean;
		private var oldMouseOver:Boolean;
		
		private var mouseHover:Boolean;
		private var mouseDown:Boolean;
		
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
				//this.gameObject.sendMessage("mouseOver");
				mouseHover = true;
			}
			
			if (mouseHover && !currentState.mouseButton && mouseDown) {
				parent.sendMessage(E_ONRELEASE);
				mouseDown = false;
				//this.gameObject.sendMessage("mouseRelease");
			}
			
			if (!mouseOver && oldMouseOver && mouseHover) {
				parent.sendMessage(E_ONOUT);
				mouseHover = false;
				if (currentState.mouseButton || mouseDown) {
					parent.sendMessage(E_ONBLUR);
				}
			}
			
			if (mouseHover && currentState.mouseButton && !mouseDown) {
				mouseDown = true;
				//trace("mouseDown");
				parent.sendMessage(E_ONPRESS);
				} else {
					parent.sendMessage(E_ONBLUR);
			}
			
			if (mouseOver && mouseDown) {
				parent.sendMessage(E_ONPRESS);
				//this.gameObject.sendMessage("mousePress");
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
				case E_ONBLUR:
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