package nl.jorisdormans.phantomGUI 
{
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class PhantomSelectBox extends PhantomPanel
	{
		private var _cells:Vector.<PhantomSelectCell>;
		private var _selectedOption:String;
		private var _selectedIndex:int;
		public var cellHeight:Number = 20;
		public var onSelect:Function;
		
		public function PhantomSelectBox(parent:DisplayObjectContainer, x:Number, y:Number, width:Number, height:Number, showing:Boolean = true, enabled:Boolean = true) 
		{
			super(parent, x, y, width, height, showing, enabled);
			verticalScrollBarAlwaysVisible = true;
			checkSize();
			_cells = new Vector.<PhantomSelectCell>();
			_selectedIndex = -1;
			_selectedOption = "";
			addEventListener(MouseEvent.MOUSE_UP, doMouseUp);
			
		}
		
		private function doMouseUp(e:MouseEvent):void 
		{
			if (e.target == this) {
				_selectedIndex = -1;
				_selectedOption = "";
				if (onSelect != null) onSelect(this);
			}
		}
		
		public function addOption(option:String):void {
			scrollTo(0, 0);
			_cells.push(new PhantomSelectCell(option, changeCell, this, 0, _cells.length * cellHeight, _controlWidth - PhantomVerticalScrollbar.BARSIZE, cellHeight, showing, enabled));
			_cells[_cells.length - 1].index = _cells.length - 1;
			checkSize();
			scrollTo(0, Math.max(0, _cells.length * 20 - _controlHeight));
		}
		
		private function changeCell(cell:PhantomSelectCell):void {
			//on change cell
			if (cell.selected) {
				_selectedOption = cell.caption;
				_selectedIndex = cell.index;
			} else {
				_selectedOption = "";
				_selectedIndex = -1;
			}
			if (onSelect != null) onSelect(this);
		}
		
		public function get optionCount():int { return _cells.length}
		
		public function get selectedOption():String { return _selectedOption; }
		
		public function set selectedOption(value:String):void 
		{
			if (_selectedOption == value) return;
			if (_selectedIndex >= 0) _cells[_selectedIndex].selected = false;
			_selectedOption = value;
			_selectedIndex = -1;
			for each (var cell:PhantomSelectCell in _cells) {
				if (cell.caption == value) {
					_selectedIndex = cell.index;
					break;
				}
			}
			
			if (_selectedIndex >= 0) _cells[_selectedIndex].selected = true;
			else _selectedOption = "";
		}
		
		public function findOption(option:String):void {
			if (_selectedIndex >= 0 && _selectedIndex<_cells.length) _cells[_selectedIndex].selected = false;
			_selectedIndex = -1;
			if (option.length>0) {
				for (var i:int = 0; i < _cells.length; i++) {
					if (_cells[i].caption.substr(0, option.length).toLowerCase() == option.toLowerCase()) {
						_selectedIndex = i;
						if (onSelect != null) onSelect(this);
						break;
					}
				}
			}
			
			if (_selectedIndex >= 0) {
				_cells[_selectedIndex].selected = true;
				_selectedOption = _cells[_selectedIndex].caption;
			}
			else _selectedOption = "";
			
		}
		
		public function get selectedIndex():int { return _selectedIndex; }
		
		public function set selectedIndex(value:int):void 
		{
			if (_selectedIndex == value) return;
			if (_selectedIndex >= _cells.length) _selectedIndex = _cells.length - 1;
			if (_selectedIndex >= 0) _cells[_selectedIndex].selected = false;
			_selectedIndex = value;
			if (_selectedIndex >= 0 &&  _cells.length > _selectedIndex) {
				_cells[_selectedIndex].selected = true;
				_selectedOption = _cells[_selectedIndex].caption;
			} else {
				_selectedOption = "";
				_selectedIndex = -1;
			}
		}
		
		public function setOptions(options:Vector.<String>):void {
			scrollTo(0, 0);
			var selected:String = _selectedOption;
			var i:int = 0;
			while (i < options.length) {
				if (i < _cells.length) _cells[i].caption = options[i];
				else {
					_cells.push(new PhantomSelectCell(options[i], changeCell, this, 0, i * cellHeight, _controlWidth - PhantomVerticalScrollbar.BARSIZE, cellHeight, showing, enabled));
					_cells[i].index = i;
				}
				i++;
			}
			if (options.length < _cells.length) {
				for (i = options.length; i < _cells.length; i++) _cells[i].dispose();
				_cells.splice(options.length, _cells.length - options.length);
			}
			checkSize();
		}
		
		public function clearOptions():void {
			scrollTo(0, 0);
			for (var i:int = 0; i < _cells.length; i++) _cells[i].dispose();
			_cells.splice(0, _cells.length);
			checkSize();
			_selectedIndex = -1;
			_selectedOption = "";
		}
		
		override public function draw():void 
		{
			var face:uint = PhantomGUISettings.colorSchemes[colorScheme].colorFaceDisabled;
			graphics.clear();
			graphics.beginFill(face);
			graphics.drawRect(0, 0, _controlWidth, _controlHeight);
			graphics.endFill();
		}	
		
		public function changeOption(option:String):void {
			if (selectedIndex < 0) return;
			_cells[selectedIndex].caption = option;
		}
		
		public function scrollToOption(i:int):void {
			if (i < 0) return;
			if (_cells.length == 0) {
				scrollTo(0, 0);
				return;
			}
			var h:Number = _cells[0].controlHeight;
			var visibleOptions:int = _controlHeight / h;
			scrollTo(0, Math.min(optionCount-visibleOptions, Math.max(0, (i - Math.floor(visibleOptions / 2)) * h)));
			
			
		}	
		
		public function setOption(n:int, s:String):void {
			if (n >= 0 && n < this._cells.length) {
				_cells[n].caption = s;
			}
		}
		
		public function enableOption(n:int, enabled:Boolean):void {
			if (n >= 0 && n < this._cells.length) {
				_cells[n].enabled = enabled;
			}
		}
		
	}

}