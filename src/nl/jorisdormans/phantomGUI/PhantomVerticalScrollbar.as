package nl.jorisdormans.phantomGUI 
{
	import flash.display.DisplayObjectContainer;
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class PhantomVerticalScrollbar extends PhantomControl
	{
		public var maxValue:int;
		private var _currentValue:int;
		public var increment:int = 1;
		public var handleSize:int = 1;
		private var realHandleSize:Number;
		private var realValueSize:Number;
		public static const BARSIZE:int = 16;
		private var _handle:PhantomDragHandle;
		public var onChange:Function;
		private var _down:PhantomButton;
		private var _up:PhantomButton;
		
		public function PhantomVerticalScrollbar(currentValue:int, maxValue:int, handleSize:int, parent:DisplayObjectContainer, x:Number, y:Number, size:Number, showing:Boolean = true, enabled:Boolean = true) 
		{
			if (size < BARSIZE * 3) size = BARSIZE * 3;
			_controlHeight = size;
			_controlWidth = BARSIZE;
			setValues(currentValue, maxValue, handleSize);
			super(parent, x, y, BARSIZE, size, showing, enabled);
			
			_down = new PhantomButton("", doDown, this, 0, 0, BARSIZE - 1, BARSIZE - 1, showing, enabled);
			_down.glyph = PhantomGlyph.ARROW_UP;
			_up = new PhantomButton("", doUp, this, 0, _controlHeight - BARSIZE, BARSIZE - 1, BARSIZE - 1, showing, enabled);
			_up.glyph= PhantomGlyph.ARROW_DOWN;
			
			_handle = new PhantomDragHandle(this, 0, BARSIZE-1, BARSIZE - 1, realHandleSize, 0, 0, BARSIZE-1, _controlHeight - BARSIZE - realHandleSize-1, doChange, showing, enabled);
		}
		
		private function doDown(sender:PhantomButton):void
		{
			_handle.moveBy(0, -(handleSize-1) * (realValueSize / (maxValue-handleSize)));
		}
		
		private function doUp(sender:PhantomButton):void
		{
			_handle.moveBy(0, (handleSize-1) * (realValueSize / (maxValue-handleSize)));
		}
		
		public function setValues(currentValue:int, maxValue:int = -1, handleSize:int = -1):void {
			if (handleSize > 0) this.handleSize = handleSize;
			if (maxValue >=0 ) this.maxValue = maxValue;
			this.currentValue = currentValue;
			if (this.maxValue == 0) realHandleSize = Math.floor(_controlHeight - 2 * BARSIZE) ;
			else realHandleSize = Math.floor((_controlHeight - 2 * BARSIZE) * (this.handleSize / this.maxValue));
			if (realHandleSize > Math.floor(_controlHeight - 2 * BARSIZE)) realHandleSize = Math.floor(_controlHeight - 2 * BARSIZE);
			if (realHandleSize < BARSIZE - 1) {
				realHandleSize = BARSIZE - 1;
			}
			realValueSize = _controlHeight - BARSIZE * 2 - realHandleSize;
			if (_handle != null) {
				_handle.setSize(BARSIZE - 1, realHandleSize);
				_handle.setArea(0, 0, BARSIZE - 1, _controlHeight - BARSIZE - realHandleSize-1);
				_handle.setPosition(0, BARSIZE - 1 + currentValue * (realValueSize / (this.maxValue-this.handleSize)));
				_handle.enabled = (realHandleSize == Math.floor(_controlHeight - 2 * BARSIZE))?false:true;
				_up.enabled = (realHandleSize == Math.floor(_controlHeight - 2 * BARSIZE))?false:true;
				_down.enabled = (realHandleSize == Math.floor(_controlHeight - 2 * BARSIZE))?false:true;
			}
			
			draw();
		}
		
		public function setLength(size:Number):void {
			if (size < BARSIZE * 3) size = BARSIZE * 3;
			_controlHeight = size;
			_controlWidth = BARSIZE;
		}
		
		public function get currentValue():int { 
			_currentValue = (maxValue-handleSize) * (_handle.positionY);
			return _currentValue; 
		}
		
		public function set currentValue(value:int):void 
		{
			_currentValue = value;
		}
		
		override public function draw():void 
		{
			var border:uint = PhantomGUISettings.colorSchemes[colorScheme].colorBorder;
			var face:uint = PhantomGUISettings.colorSchemes[colorScheme].colorFaceDisabled;
			var panel:uint = PhantomGUISettings.colorSchemes[colorScheme].colorFace;
			if (!enabled) {
				border = PhantomGUISettings.colorSchemes[colorScheme].colorBorderDisabled;
			}
			graphics.clear();
			graphics.beginFill(panel);
			graphics.drawRect(0, 0, _controlWidth, _controlHeight);
			graphics.endFill();
			
			graphics.beginFill(border);
			graphics.drawRect(1, BARSIZE-PhantomGUISettings.borderWidth, _controlWidth-1, _controlHeight - BARSIZE*2+2*PhantomGUISettings.borderWidth);
			graphics.endFill();
			graphics.beginFill(face);
			graphics.drawRect(PhantomGUISettings.borderWidth+1, BARSIZE, _controlWidth -1 - 2*PhantomGUISettings.borderWidth, _controlHeight - BARSIZE*2);
			graphics.endFill();
			
		}
		
		private function doChange(sender:PhantomControl):void {
			if (onChange != null) onChange(this);
		}
		
	}

}