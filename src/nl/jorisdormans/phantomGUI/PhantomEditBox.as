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
	public class PhantomEditBox extends PhantomControl
	{
		public var onChange:Function;
		public var onEnter:Function;
		public var onExit:Function;
		protected var _active:Boolean = false;
		
		public function PhantomEditBox(caption:String, parent:DisplayObjectContainer, x:Number, y:Number, width:Number = 88, height:Number = 24, showing:Boolean = true, enabled:Boolean = true) 
		{
			super(parent, x, y, width, height, showing, enabled);
			if (_captionAlign == null) _captionAlign = ALIGN_LEFT;
			this.caption = "edit";
			this.caption = caption;
		}
		
		
		override public function draw():void 
		{
			var border:uint = PhantomGUISettings.colorSchemes[colorScheme].colorBorder;
			var face:uint = PhantomGUISettings.colorSchemes[colorScheme].colorWindow;
			if (!enabled) {
				border = PhantomGUISettings.colorSchemes[colorScheme].colorBorderDisabled;
				face = PhantomGUISettings.colorSchemes[colorScheme].colorWindowDisabled;
			}
			if (_textField != null) _textField.textColor = border;
			
			graphics.beginFill(border);
			graphics.drawRect(0, 0, _controlWidth, _controlHeight);
			graphics.endFill();
			
			graphics.beginFill(face);
			graphics.drawRect(PhantomGUISettings.borderWidth, PhantomGUISettings.borderWidth, _controlWidth-PhantomGUISettings.borderWidth*2, _controlHeight-PhantomGUISettings.borderWidth*2);
			graphics.endFill();
		}
		
		override protected function createTextField(text:String):void 
		{
			super.createTextField(text);
			_textField.selectable = enabled;
			_textField.mouseEnabled = enabled;
			_textField.type = TextFieldType.INPUT;
			_textField.addEventListener(Event.CHANGE, doChange);
			_textField.addEventListener(MouseEvent.MOUSE_DOWN, onClick);
			_textField.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			_textField.addEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
			
			addEventListener(MouseEvent.MOUSE_DOWN, onClick);
			
		}
		
		protected function onFocusOut(e:FocusEvent):void 
		{
			if (onExit != null) onExit(this);
			active = false;
		}
		
		protected function onKeyUp(e:KeyboardEvent):void 
		{
			if (_active && e.charCode == Keyboard.ENTER) {
				stage.focus = null;
			} else {
				if (onChange != null) onChange(this);
			}
		}
		
		protected function onClick(e:MouseEvent):void 
		{
			active = true;
			//e.stopPropagation();
		}
		
		protected function doChange(e:Event):void 
		{
			_caption = _textField.text;
			if (onChange != null) onChange(this);
		}
		
		public function get active():Boolean { return _active; }
		
		public function set active(value:Boolean):void 
		{
			if (_active == value) return;
			_active = value;
			if (_active) {
				_textField.setSelection(0, _textField.text.length);
				_textField.stage.focus = _textField;
			} else {
				_textField.setSelection(0, 0);
			}
			
		}
		
		override public function get enabled():Boolean { return super.enabled; }
		
		override public function set enabled(value:Boolean):void 
		{
			super.enabled = value;
			if (_textField != null) {
				_textField.selectable = enabled;
				_textField.mouseEnabled = enabled;
			}
		}
	}

}