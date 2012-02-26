package nl.jorisdormans.phantom2D.gui 
{
	import flash.geom.Vector3D;
	import nl.jorisdormans.phantom2D.core.Component;
	import nl.jorisdormans.phantom2D.core.InputState;
	import nl.jorisdormans.phantom2D.objects.IInputHandler;
	
	/**
	 * ...
	 * @author M. Dijkstra
	 */
	public class MouseHandler extends Component implements IInputHandler 
	{
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
				trace("mouseOver");
				//this.gameObject.sendMessage("mouseOver");
				mouseHover = true;
			}
			
			if (mouseHover && currentState.mouseButton && !mouseDown) {
				trace("mousePress");
				mouseDown = true;
				//this.gameObject.sendMessage("mousePress");
			} 
			if (!currentState.mouseButton && mouseDown) {
				trace("mouseRelease");
				mouseDown = false;
				//this.gameObject.sendMessage("mouseRelease");
			}
			
			if (!mouseOver && oldMouseOver) {
				trace("mouseOut");
				//this.gameObject.sendMessage("mouseOut");
				mouseHover = false;
			}
		}
	}

}