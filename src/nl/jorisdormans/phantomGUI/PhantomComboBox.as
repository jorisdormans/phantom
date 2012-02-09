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
	public class PhantomComboBox extends PhantomEditBox
	{
		private var _border:PhantomBorder;
		private var _selectBox:PhantomSelectBox;
		private var _button:PhantomButton;
		
		public function PhantomComboBox(caption:String, parent:DisplayObjectContainer, x:Number, y:Number, width:Number = 88, height:Number = 24, showing:Boolean = true, enabled:Boolean = true) 
		{
			super(caption, parent, x, y, width, height, showing, enabled);
			_button = new PhantomButton("", showSelect, this, width - height, 0, height-2, height-2, showing, enabled);
			_button.glyph = PhantomGlyph.ARROW_DOWN;
			_border = new PhantomBorder(stage, getStageX(), getStageY()+height, width, 5 * 20 + 4, false);
			_selectBox = new PhantomSelectBox(_border, 2, 2, width - 4, 5 * 20);
			_selectBox.onSelect = doSelect;
			_textField.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			_textField.type = TextFieldType.DYNAMIC;
		}
		
		private function doSelect(box:PhantomSelectBox):void
		{
			caption = box.selectedOption;
			_border.showing = false;
			stage.removeEventListener(MouseEvent.MOUSE_UP, removeSelect);
			if (onChange != null) onChange(this);
		}
		
		private function showSelect(button:PhantomButton):void
		{
			_border.showing = true;
			_selectBox.scrollToOption(_selectBox.selectedIndex);
			_border.colorScheme = colorScheme;
			stage.addEventListener(MouseEvent.MOUSE_DOWN, removeSelect);
		}
		
		private function removeSelect(e:MouseEvent):void 
		{
			if (e.stageX < _border.x || e.stageX >= _border.x + _border.controlWidth || e.stageY < _border.y - _controlHeight || e.stageY >= _border.y + _border.controlHeight) {
				_border.showing = false;
				if (stage!=null) stage.removeEventListener(MouseEvent.MOUSE_UP, removeSelect);
			}
		}
		
		public function findOption(option:String):void {
			_selectBox.findOption(option);
			caption = _selectBox.selectedOption;
		}
		
		public function get selectedIndex():int {
			return _selectBox.selectedIndex;
		}
		
		public function set selectedIndex(value:int):void {
			_selectBox.selectedIndex = value;
			caption = _selectBox.selectedOption;
		}
		
		public function updateOption(option:String):void {
			if (_selectBox.selectedIndex < 0) return;
			_selectBox.changeOption(option);
			caption = option;
		}
		
		
		public function addOption(option:String):void {
			_selectBox.addOption(option);
		}
		
		public function clearOptions():void {
			_selectBox.clearOptions();
		}
		
		public function setOptions(options:Vector.<String>):void {
			_selectBox.setOptions(options);
		}
		
		public function get optionCount():int {
			return _selectBox.optionCount;
		}
		
		override protected function doChange(e:Event):void 
		{
			_selectBox.findOption(_textField.text);
			if (_selectBox.selectedIndex >= 0) {
				var t:String = _textField.text;
				_textField.text = _selectBox.selectedOption;
				_textField.setSelection(t.length, _textField.text.length);
			}
			if (onChange != null) onChange(this);
		}
		
		override protected function onFocusOut(e:FocusEvent):void 
		{
			_selectBox.findOption(_textField.text);
			if (_selectBox.selectedIndex >= 0) {
				var t:String = _textField.text;
				_textField.text = _selectBox.selectedOption;
				_textField.setSelection(0, 0);
			} else {
				_textField.text = "";
				_textField.setSelection(0, 0);
			}
			
			if (onExit != null) onExit(this);
			active = false;
		}
		
		protected function onKeyDown(e:KeyboardEvent):void {
			if (e.keyCode == Keyboard.DOWN) {
				if (_selectBox.selectedIndex < _selectBox.optionCount - 1) {
					_selectBox.selectedIndex++;
					_textField.text = _selectBox.selectedOption;
					_textField.setSelection(0, _textField.text.length);
					e.stopImmediatePropagation();
					if (onChange != null) onChange(this);
				}
			} else if (e.keyCode == Keyboard.UP) {
				if (_selectBox.selectedIndex > -1) {
					_selectBox.selectedIndex--;
					_textField.text = _selectBox.selectedOption;
					_textField.setSelection(0, _textField.text.length);
					e.stopImmediatePropagation();
					if (onChange != null) onChange(this);
				}
			} else if (e.keyCode > 32 && e.keyCode < 128) {
				_selectBox.findOption(String.fromCharCode(e.keyCode));
			}
		}
		
	}

}