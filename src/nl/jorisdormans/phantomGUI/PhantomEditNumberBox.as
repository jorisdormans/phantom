package nl.jorisdormans.phantomGUI 
{
	import flash.display.DisplayObjectContainer;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.text.TextFieldAutoSize;
	import flash.ui.Keyboard;
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class PhantomEditNumberBox extends PhantomEditBox
	{
		private var _value:Number;
		public var min:Number = NaN;
		public var max:Number = NaN;
		public var precision:int;
		public var increment:Number;
		
		public function PhantomEditNumberBox(value:Number, precision:int, increment:Number, parent:DisplayObjectContainer, x:Number, y:Number, width:Number = 88, height:Number = 24, showing:Boolean = true, enabled:Boolean = true) 
		{
			this.precision = precision;
			_value = value;
			super(valueToString(), parent, x, y, width, height, showing, enabled);
			
			this.increment = increment;
			
			if (increment > 0) {
				new PhantomButton("", up, this, width-1, 0, height*0.5, height*0.5).glyph = PhantomGlyph.ARROW_UP;
				new PhantomButton("", down, this, width-1, height*0.5-1, height*0.5, height*0.5).glyph = PhantomGlyph.ARROW_DOWN;
			}
			_captionAlign = ALIGN_RIGHT;
			caption = valueToString();
		}
		
		private function up(sender:PhantomButton):void {
			_value += increment;
			if (!isNaN(max) && _value > max) _value = max;
			caption = valueToString();
			if (onChange != null) onChange(this);
		}
		
		private function down(sender:PhantomButton):void {
			_value -= increment;
			if (!isNaN(min) && _value < min) _value = min;
			caption = valueToString();
			if (onChange != null) onChange(this);
		}
		
		private function valueToString():String {
			if (precision<=0) {
				return _value.toString();
			} else {
				return _value.toFixed(precision);
			}
		}
		
		override protected function createTextField(text:String):void 
		{
			super.createTextField(text);
			_textField.autoSize = TextFieldAutoSize.RIGHT;
		}
		
		public function get value():Number { return _value; }
		
		public function set value(value:Number):void 
		{
			_value = value;
			caption = valueToString();
		}
		
		override protected function onKeyUp(e:KeyboardEvent):void 
		{
			if (_active && e.charCode == Keyboard.ENTER) {
				stage.focus = null;
			} else {
				var v:Number = parseFloat(_textField.text);
				if (!isNaN(max) && v > max) v = max;
				if (!isNaN(min) && v < min) v = min;
				if (!isNaN(v) && v != _value) {
					_value = v;
					if (onChange != null) onChange(this);
				}
			}
		}
		
		override protected function onFocusOut(e:FocusEvent):void 
		{
			active = true;
			caption = valueToString();
			e.stopPropagation();
		}
		
	}

}