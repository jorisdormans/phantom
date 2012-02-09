package nl.jorisdormans.phantomGUI 
{
	import flash.display.DisplayObjectContainer;
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class PhantomHorizontalScrollbar extends PhantomControl
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
		
		public function PhantomHorizontalScrollbar(currentValue:int, maxValue:int, handleSize:int, parent:DisplayObjectContainer, x:Number, y:Number, size:Number, showing:Boolean = true, enabled:Boolean = true) 
		{
			if (size < BARSIZE * 3) size = BARSIZE * 3;
			_controlHeight = BARSIZE;
			_controlWidth = size;
			setValues(currentValue, maxValue, handleSize);
			super(parent, x, y, size, BARSIZE, showing, enabled);
			
			new PhantomButton("", doDown, this, 0, 0, BARSIZE-1, BARSIZE-1, showing, enabled).glyph = PhantomGlyph.ARROW_LEFT;
			new PhantomButton("", doUp, this, _controlWidth - BARSIZE, 0, BARSIZE - 1, BARSIZE - 1, showing, enabled).glyph = PhantomGlyph.ARROW_RIGHT;
			
			_handle = new PhantomDragHandle(this, BARSIZE-1, 0, realHandleSize, BARSIZE - 1, BARSIZE-1, _controlWidth - BARSIZE - realHandleSize-1, 0, 0, doChange, showing, enabled);
		}
		
		private function doDown(sender:PhantomButton):void
		{
			_handle.moveBy( -(handleSize-1) * (realValueSize / (maxValue-handleSize)), 0);
		}
		
		private function doUp(sender:PhantomButton):void
		{
			_handle.moveBy( (handleSize-1) * (realValueSize / (maxValue-handleSize)), 0);
		}
		
		public function setValues(currentValue:int, maxValue:int  = -1, handleSize:int = -1):void {
			if (handleSize > 0) this.handleSize = handleSize;
			if (maxValue>=0) this.maxValue = maxValue;
			this.currentValue = currentValue;
			if (this.maxValue == 0) realHandleSize = Math.floor(_controlWidth - 2 * BARSIZE);
			else realHandleSize = Math.floor((_controlWidth - 2 * BARSIZE) * (this.handleSize / this.maxValue));
			if (realHandleSize > Math.floor(_controlWidth - 2 * BARSIZE)) realHandleSize = Math.floor(_controlWidth - 2 * BARSIZE);
			if (realHandleSize < BARSIZE - 1) {
				realHandleSize = BARSIZE - 1;
			}
			realValueSize = _controlWidth - BARSIZE * 2 - realHandleSize;
			if (_handle != null) {
				_handle.setSize(realHandleSize, BARSIZE - 1);
				_handle.setArea(BARSIZE - 1, _controlWidth - BARSIZE - realHandleSize-1, 0, 0);
				_handle.setPosition(BARSIZE - 1 + currentValue * (realValueSize / (this.maxValue-this.handleSize)), 0);
			}
			draw();
		}
		
		public function setLength(size:Number):void {
			if (size < BARSIZE * 3) size = BARSIZE * 3;
			_controlHeight = BARSIZE;
			_controlWidth = size;
		}
		
		public function get currentValue():int { 
			_currentValue = (maxValue-handleSize) * (_handle.positionX);
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
				face = PhantomGUISettings.colorSchemes[colorScheme].colorWindowDisabled;
			}
			graphics.clear();
			graphics.beginFill(panel);
			graphics.drawRect(0, 0, _controlWidth, _controlHeight);
			graphics.endFill();
			graphics.beginFill(border);
			graphics.drawRect(BARSIZE-PhantomGUISettings.borderWidth, 1, _controlWidth - BARSIZE*2+2*PhantomGUISettings.borderWidth, _controlHeight-1);
			graphics.endFill();
			graphics.beginFill(face);
			graphics.drawRect(BARSIZE, PhantomGUISettings.borderWidth+1, _controlWidth - BARSIZE*2, _controlHeight -1 - 2*PhantomGUISettings.borderWidth);
			graphics.endFill();
			
		}
		
		private function doChange(sender:PhantomControl):void {
			if (onChange != null) onChange(this);
		}
		
	}

}