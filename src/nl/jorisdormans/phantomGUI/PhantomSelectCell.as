package nl.jorisdormans.phantomGUI 
{
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextFieldType;
	import flash.ui.Keyboard;
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class PhantomSelectCell extends PhantomControl
	{
		public var onChange:Function;
		protected var _selected:Boolean = false;
		protected var _hover:Boolean = false;
		public var index:int;
		
		public function PhantomSelectCell(caption:String, onChange:Function, parent:DisplayObjectContainer, x:Number, y:Number, width:Number = 88, height:Number = 20, showing:Boolean = true, enabled:Boolean = true) 
		{
			super(parent, x, y, width, height, showing, enabled);
			if (_captionAlign == null) _captionAlign = ALIGN_LEFT;
			this.caption = caption;
			buttonMode = true;
			addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			this.onChange = onChange;
		}
		
		private function onMouseOut(e:MouseEvent):void 
		{
			hover = false;
		}
		
		private function onMouseOver(e:MouseEvent):void 
		{
			hover = true;
		}
		
		private function onMouseUp(e:MouseEvent):void 
		{
			if (!enabled) return;
			//selected = !_selected;
			selected = true;
			if (_selected) {
				var i:int = 0;
				while (i < _parent.numChildren) {
					var c:PhantomSelectCell = _parent.getChildAt(i) as PhantomSelectCell;
					if (c != null && c != this && c._selected) c.selected = false;
					i++;
				}
			}
			if (onChange != null) onChange(this);
		}
		
		override public function draw():void 
		{
			var face:uint = _selected?PhantomGUISettings.colorSchemes[colorScheme].colorBorder:(_hover?PhantomGUISettings.colorSchemes[colorScheme].colorFace:PhantomGUISettings.colorSchemes[colorScheme].colorWindow);
			var border:uint = _selected?(_hover?PhantomGUISettings.colorSchemes[colorScheme].colorFace:PhantomGUISettings.colorSchemes[colorScheme].colorWindow):PhantomGUISettings.colorSchemes[colorScheme].colorBorder;
			if (!enabled) {
				border = PhantomGUISettings.colorSchemes[colorScheme].colorFaceDisabled;
				face = PhantomGUISettings.colorSchemes[colorScheme].colorBorderDisabled;
			}
			if (_textField != null) _textField.textColor = border;
			
			graphics.beginFill(face);
			graphics.drawRect(0, 0, _controlWidth, _controlHeight);
			graphics.endFill();
		}
		
		public function get selected():Boolean { return _selected; }
		
		public function set selected(value:Boolean):void 
		{
			_selected = value;
			draw();
		}
		
		public function get hover():Boolean { return _hover; }
		
		public function set hover(value:Boolean):void 
		{
			_hover = value;
			draw();
		}
		
		override public function get enabled():Boolean { return super.enabled; }
		
		override public function set enabled(value:Boolean):void 
		{
			super.enabled = value;
			buttonMode = enabled;
		}
		

		
	}

}