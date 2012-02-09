package nl.jorisdormans.phantomGUI 
{
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class PhantomToolButton extends PhantomButton
	{
		private var _selected:Boolean;
		
		public function PhantomToolButton(caption:String, action:Function, parent:DisplayObjectContainer, x:Number, y:Number, width:Number, height:Number, selected:Boolean = true, showing:Boolean = true, enabled:Boolean = true) 
		{
			_selected = false;
			super(caption, action, parent, x, y, width, height, showing, enabled);
			this.selected = selected;
		}
		
		override protected function mouseUp(e:MouseEvent):void 
		{
			if (pressed) {
				selected = !_selected;
				pressed = false;
				if (_action != null) _action(this);
			}
		}
		
		override protected function mouseOut(e:MouseEvent):void 
		{
			hover = _selected;
			if (pressed) pressed = false;
			if (_toolTip != null) {
				_toolTip.dispose();
				_toolTip = null;
			}
		}
		
		public function get selected():Boolean { return _selected; }
		
		public function set selected(value:Boolean):void 
		{
			if (_selected  == value) return;
			_selected = value;
			_hover = _selected;
			
			if (_selected) {
				_edge -= PhantomGUISettings.press;
				x += PhantomGUISettings.press;
				y += PhantomGUISettings.press;
			} else {
				_edge += PhantomGUISettings.press;
				x -= PhantomGUISettings.press;
				y -= PhantomGUISettings.press;
			}
			
			if (_selected && parent != null) {
				var i:int = 0;
				while (i < parent.numChildren) {
					var other:PhantomToolButton = parent.getChildAt(i) as PhantomToolButton;
					if (other != null && other != this) other.selected = false;
					i++;
				}
			}
			
			draw();
		}
		
		
		
		
		
	}

}