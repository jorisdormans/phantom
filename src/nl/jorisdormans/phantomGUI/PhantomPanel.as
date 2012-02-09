package nl.jorisdormans.phantomGUI 
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class PhantomPanel extends PhantomControl
	{
		protected var _scrollX:Number;
		protected var _scrollY:Number;
		private var _maskShape:Sprite;
		private var _scrollH:PhantomHorizontalScrollbar;
		private var _scrollV:PhantomVerticalScrollbar;
		private var _filler:Sprite;
		public var horizontalScrollBarAlwaysVisible:Boolean;
		public var verticalScrollBarAlwaysVisible:Boolean;
		
		public function PhantomPanel(parent:DisplayObjectContainer, x:Number, y:Number, width:Number, height:Number, showing:Boolean = true, enabled:Boolean = true) 
		{
			super(parent, x, y, width, height, showing, enabled);
			horizontalScrollBarAlwaysVisible = false;
			verticalScrollBarAlwaysVisible = false;
			_scrollX = 0;
			_scrollY = 0;
			setSize(width, height);
		}
		
		override public function draw():void 
		{
			var face:uint = PhantomGUISettings.colorSchemes[colorScheme].colorFace;
			if (!enabled) face = PhantomGUISettings.colorSchemes[colorScheme].colorFaceDisabled;
			graphics.clear();
			graphics.beginFill(face);
			graphics.drawRect(0, 0, _controlWidth, _controlHeight);
			graphics.endFill();
		}
		
		override public function setSize(width:Number, height:Number):void {
			var i:int = 0;
			var controlMaxX:Number = 0;
			var controlMaxY:Number = 0;
			while (i < numChildren) {
				var c:PhantomControl = getChildAt(i) as PhantomControl;
				if (c != null) {
					if (c.x + c.controlWidth > controlMaxX) controlMaxX = c.x + c.controlWidth * c.scaleX;
					if (c.y + c.controlHeight > controlMaxY) controlMaxY = c.y + c.controlHeight * c.scaleY;
				}
				i++;
			}
			
			_controlWidth = width;
			_controlHeight = height;
			var mX:Number = 0;
			var mY:Number  = 0;
			
			
			if (controlMaxX > width || horizontalScrollBarAlwaysVisible) mY = PhantomVerticalScrollbar.BARSIZE;
			if (controlMaxY > height - mY || verticalScrollBarAlwaysVisible) mX = PhantomHorizontalScrollbar.BARSIZE;
			if (controlMaxX > width - mX || horizontalScrollBarAlwaysVisible) mY = PhantomVerticalScrollbar.BARSIZE;
			
			if (mY > 0) {
				if (_scrollH == null) {
					_scrollH = new PhantomHorizontalScrollbar(_scrollX, Math.round(controlMaxX), Math.round(_controlWidth-mX), _parent, _controlX, _controlY + _controlHeight - PhantomHorizontalScrollbar.BARSIZE, _controlWidth-mX, showing, enabled);
					_scrollH.onChange = moveChildren;
				} else {
					_scrollH.x = _controlX;
					_scrollH.y = _controlY+_controlHeight - PhantomHorizontalScrollbar.BARSIZE;
					_scrollH.setLength(_controlWidth-mX);
					_scrollH.setValues(_scrollX, Math.round(controlMaxX), Math.round(_controlWidth-mX));
				}
			} else {
				if (_scrollH != null) {
					if (_scrollH.parent!=null) _scrollH.parent.removeChild(_scrollH);
					_scrollH = null;
				}
			}
			
			if (mX > 0) {
				if (_scrollV == null) {
					_scrollV = new PhantomVerticalScrollbar(_scrollY, Math.round(controlMaxY), Math.round(_controlHeight-mY), _parent, _controlX + _controlWidth - PhantomVerticalScrollbar.BARSIZE, _controlY, _controlHeight-mY, showing, enabled);
					_scrollV.onChange = moveChildren;
				} else {
					_scrollV.x = _controlX+_controlWidth - PhantomVerticalScrollbar.BARSIZE;
					_scrollV.y = _controlY;
					_scrollV.setLength(_controlHeight - mY);
					_scrollV.setValues(_scrollY, Math.round(controlMaxY), Math.round(_controlHeight-mY));
				}
			} else {
				if (_scrollV != null) {
					if (_scrollV.parent!=null) _scrollV.parent.removeChild(_scrollV);
					_scrollV = null;
				}
			}	
			
			if (mY > 0 && mX > 0) {
				if (_filler == null) {
					_filler = new Sprite();
					_parent.addChild(_filler);
				}
				_filler.x = x+_controlWidth - PhantomVerticalScrollbar.BARSIZE;
				_filler.y = y+_controlHeight - PhantomHorizontalScrollbar.BARSIZE;
				_filler.graphics.clear();
				_filler.graphics.beginFill(PhantomGUISettings.colorSchemes[colorScheme].colorFaceDisabled);
				_filler.graphics.drawRect(0, 0, PhantomVerticalScrollbar.BARSIZE, PhantomHorizontalScrollbar.BARSIZE);
				_filler.graphics.endFill();
			} else {
				if (_filler != null) {
					_filler.parent.removeChild(_filler);
					_filler = null;
				}
			}
			
			
			if (_maskShape!=null && _maskShape.parent != null) _maskShape.parent.removeChild(_maskShape);
			_maskShape = new Sprite();
			_maskShape.x = getStageX();
			_maskShape.y = getStageY();
			_maskShape.x = 0;
			_maskShape.y = 0;
			addChild(_maskShape);
			_maskShape.graphics.clear();
			_maskShape.graphics.beginFill(0x880000, 0.6);
			_maskShape.graphics.drawRect(0, 0, _controlWidth-mX, _controlHeight-mY);
			_maskShape.graphics.endFill();
			mask = _maskShape;
			draw();
		}
		
		public function checkSize():void {
			setSize(_controlWidth, _controlHeight);
		}
		
		private function moveChildren(sender:PhantomControl):void {
			var nx:Number = _scrollX;
			var ny:Number = _scrollY;
			if (_scrollH != null) nx = _scrollH.currentValue;
			if (_scrollV != null) ny = _scrollV.currentValue;
			if (nx != _scrollX || ny != _scrollY) {
				var i:int = 0;
				while (i < numChildren) {
					var c:PhantomControl = getChildAt(i) as PhantomControl;
					if (c is PhantomControl) c.setPosition(c.x - nx + _scrollX, c.y - ny + _scrollY);
					i++;
				}
				_scrollX = nx;
				_scrollY = ny;
			}
		}
		
		public function scrollTo(x:Number, y:Number):void {
			var nx:Number = x;
			var ny:Number = y;
			if (nx != _scrollX || ny != _scrollY) {
				var i:int = 0;
				while (i < numChildren) {
					var c:PhantomControl = getChildAt(i) as PhantomControl;
					if (c is PhantomControl) c.setPosition(c.x - nx + _scrollX, c.y - ny + _scrollY);
					i++;
				}
				_scrollX = nx;
				_scrollY = ny;
			}
			
			if (_scrollH != null) _scrollH.setValues(_scrollX);
			if (_scrollV != null) _scrollV.setValues(_scrollY);
		}
		
		
		
	}

}