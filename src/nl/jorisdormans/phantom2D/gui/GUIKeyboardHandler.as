package nl.jorisdormans.phantom2D.gui 
{
	import nl.jorisdormans.phantom2D.core.Component;
	import nl.jorisdormans.phantom2D.core.InputState;
	import nl.jorisdormans.phantom2D.core.Phantom;
	import nl.jorisdormans.phantom2D.objects.IInputHandler;
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class GUIKeyboardHandler extends Component implements IInputHandler
	{
		public static const E_ONFOCUS:String = "onFocus";
		public static const E_ONBLUR:String = "onBlur";
		public static const E_ONPRESS:String = "onPress";
		public static const E_ONRELEASE:String = "onRelease";
		public static const M_FOCUS:String = "focus";
		public static const M_BLUR:String = "blur";
		public static const M_TOGGLEFOCUS:String = "toggleFocus";
		
		private var _focus:Boolean;
		private var _pressed:Boolean;
		
		public function GUIKeyboardHandler() 
		{
			
		}
		
		public function get focus():Boolean 
		{
			return _focus;
		}
		
		public function set focus(value:Boolean):void 
		{
			if (_focus == value) return;
			_focus = value;
			if (_focus) {
				parent.sendMessage(E_ONFOCUS);
				if (gameObject && gameObject.layer) {
					gameObject.layer.sendMessage(GUIKeyboardControler.M_FOCUS, { focus:gameObject }, GUIKeyboardControler);
				}
			} else {
				parent.sendMessage(E_ONBLUR);
			}
		}
		
		public function get pressed():Boolean 
		{
			return _pressed;
		}
		
		public function set pressed(value:Boolean):void 
		{
			if (_pressed == value) return;
			_pressed = value;
			if (_pressed) {
				parent.sendMessage(E_ONPRESS);
			} else {
				parent.sendMessage(E_ONRELEASE);
			}
		}
		
		override public function handleMessage(message:String, data:Object = null):int 
		{
			switch (message) {
				case M_FOCUS:
					focus = true;
					return Phantom.MESSAGE_CONSUMED;
				case M_BLUR:
					focus = false;
					return Phantom.MESSAGE_CONSUMED;
				case M_TOGGLEFOCUS:
					focus = !_focus;
					return Phantom.MESSAGE_CONSUMED;
			}
			return super.handleMessage(message, data);
		}
		
		/* INTERFACE nl.jorisdormans.phantom2D.objects.IInputHandler */
		
		public function handleInput(elapsedTime:Number, currentState:InputState, previousState:InputState):void 
		{
			if (_focus) {
				if (currentState.keyEnter && !previousState.keyEnter) {
					pressed = true;
				}
				if (!currentState.keyEnter && previousState.keyEnter) {
					pressed = false;
				}
				if (currentState.keySpace && !previousState.keySpace) {
					pressed = true;
				}
				if (!currentState.keySpace && previousState.keySpace) {
					pressed = false;
				}
			} else {
				_pressed = false;
			}
		}
		
		
	}

}