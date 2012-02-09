package nl.jorisdormans.phantomGUI 
{
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class PhantomDragHandle extends PhantomButton
	{
		private var _minX:Number;
		private var _maxX:Number;
		private var _minY:Number;
		private var _maxY:Number;
		private var _positionX:Number;
		private var _positionY:Number;
		private var _mouseDownX:Number;
		private var _mouseDownY:Number;
		public var onMove:Function;
		
		public function PhantomDragHandle(parent:DisplayObjectContainer, x:Number, y:Number, width:Number, height:Number, minX:Number, maxX:Number, minY:Number, maxY:Number, onMove:Function, showing:Boolean = true, enabled:Boolean = true) 
		{
			super("", null, parent, x, y, width, height, showing, enabled);
			_minX = minX;
			_maxX = maxX;
			_minY = minY;
			_maxY = maxY;
			_positionX = (x - _minX) / (_maxX - _minX);
			_positionY = (y - _minY) / (_maxY - _minY);
			this.onMove = onMove;
			
		}
		
		public function setArea(minX:Number, maxX:Number, minY:Number, maxY:Number):void {
			_minX = minX;
			_maxX = maxX;
			_minY = minY;
			_maxY = maxY;
			
			x = Math.max(_minX, Math.min(_maxX, x));
			y = Math.max(_minY, Math.min(_maxY, y));
			
			_controlX = x;
			_controlY = y;
			
		}
		
		public function moveTo(x:Number, y:Number):void {
			x = Math.max(_minX, Math.min(_maxX, x));
			y = Math.max(_minY, Math.min(_maxY, y));
			
			this.x = _controlX = x;
			this.y = _controlY = y;
			
			var nX:Number = (x - _minX) / (_maxX - _minX);
			var nY:Number = (y - _minY) / (_maxY - _minY);
			
			if (_minX == _maxX) nX = x;
			if (_minY == _maxY) nY = y;
			
			if (nX != _positionX || nY != _positionY) {
				_positionX = nX;
				_positionY = nY;
				if (onMove != null) onMove(this);
			}
		}		
		
		public function moveBy(dx:Number, dy:Number):void {
			x += dx;
			y += dy;
			
			x = Math.max(_minX, Math.min(_maxX, x));
			y = Math.max(_minY, Math.min(_maxY, y));
			
			_controlX = x;
			_controlY = y;
			
			var nX:Number = (x - _minX) / (_maxX - _minX);
			var nY:Number = (y - _minY) / (_maxY - _minY);
			
			if (_minX == _maxX) nX = x;
			if (_minY == _maxY) nY = y;
			
			if (nX != _positionX || nY != _positionY) {
				_positionX = nX;
				_positionY = nY;
				if (onMove != null) onMove(this);
			}
		}
		
		protected function moveHandle(e:MouseEvent):void 
		{
			if (!_pressed) return;
			x = _controlX + e.stageX - _mouseDownX;
			y = _controlY + e.stageY - _mouseDownY;
			
			x = Math.max(_minX, Math.min(_maxX, x))+1;
			y = Math.max(_minY, Math.min(_maxY, y))+1;
			
			var nX:Number = (x - _minX - 1) / (_maxX - _minX);
			var nY:Number = (y - _minY - 1) / (_maxY - _minY);
			
			if (_minX == _maxX) nX = x;
			if (_minY == _maxY) nY = y;
			
			if (nX != _positionX || nY != _positionY) {
				_positionX = nX;
				_positionY = nY;
				if (onMove != null) onMove(this);
			}
		}
		
		override protected function mouseDown(e:MouseEvent):void 
		{
			super.mouseDown(e);
			_mouseDownX = e.stageX;
			_mouseDownY = e.stageY;
			stage.addEventListener(MouseEvent.MOUSE_MOVE, moveHandle);
			stage.addEventListener(MouseEvent.MOUSE_UP, endMoveHandler);
		}
		
		override protected function mouseUp(e:MouseEvent):void 
		{
			//do nothing
		}
		
		protected function endMoveHandler(e:MouseEvent):void 
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, moveHandle);
			stage.removeEventListener(MouseEvent.MOUSE_UP, endMoveHandler);
			_controlX = x;
			_controlY = y;
			pressed = false;
			hover = false;
		}
		
		override protected function mouseOut(e:MouseEvent):void 
		{
			if (!pressed) hover = false;
		}
		
		public function get minX():Number { return _minX; }
		
		public function get maxX():Number { return _maxX; }
		
		public function get minY():Number { return _minY; }
		
		public function get maxY():Number { return _maxY; }
		
		public function get positionX():Number { return _positionX; }
		
		public function set positionX(value:Number):void 
		{
			_positionX = value;
		}
		
		public function get positionY():Number { return _positionY; }
		
		public function set positionY(value:Number):void 
		{
			_positionY = value;
		}
		
		
		
	}

}